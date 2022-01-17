Lesson 13f:  Upload Report / Show Progress Bar for Processing / Polling on JobId
--------------------------------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1v9Zhpoa2c1bTXF6pyCwEeaCGoQLPO5uwI1QA32dV6ug/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson13f/poll-with-jobid
<br>
<br>
<br>

<h3> Problem Set </h3>

Problem: It may take 60-120 seconds to finish processing the uploaded file<br>
Solution: Show progress by <b>polling on the front-end</b> against the jobStatus record<br>

- On the back-end, the upload REST call adds a new record to the jobs database table, launches a background thread to process the file, and immediately returns the jobId to the front-end
- On the front-end, the web page polls on the status of the jobID
- The front-end progress bar changes as the progress information info changes in the database

<br>

![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/lesson13f_image1.png)

<br>
<br>
Screen Shot during Processing<br>

![](https://lh5.googleusercontent.com/2uBSP-KewxR-LEeEbu7iJJ00ZZH5ztI7dwRYmgdpbpFx4JLBOxWA9Wi1Fo1pYsf4Uk-ZLzLF1P_dpXihjv3kxrXXONq3LMM4iIFgX4Ye8gw2luUICkd65HZkVnbBblEvcOGvptUH)

There are 2 progress bars:  
1. The 1st progress bar shows what percent of the file has been uploaded
1. The 2nd progress bar shows what percent of file processing is complete 


<br>
<br>
<h3>Approach</h3>

1. Adds the Jobs database table to your project  

1. Add a JobStatusDTO object (used to return job status information)  

1. Add a JobService to the back-end that has two method:

   1. addJob() which adds a new jobs record to the database
   1. getJobStatus() which returns a JobStatusDTO object with info about the job  

1. Add a REST endpoint to get job status information (create a JobController)  
   GET /api/jobs/status/{id} that returns the status of a jobId  

1. Add an AsyncService (that is used to launch threads)  

1. Create a FileWorker class (that will simulate processing a file over 60 seconds)  

1. Replace the Reports.uploadFile() REST endpoint so after file upload it will  
   POST /api/file/upload  

   1. Adds a new Jobs record to the database
   1. Kick off a background thread to process the uploaded file
   1. Returns the jobId to the front-end  
        
1. Create a front-end JobServiceDTO object  

1. Create a front-end JobService that will invoke the REST call  
     GET /api/jobs/status/{id}  
     
1. Adjust the Upload Report page so that upon successful upload of the file, it will

    1. Get the jobId

    1. Start polling every 2 seconds

       1. Invoke a REST endpoint to get the status of the jobs record  
          NOTE: The jobs record contains a current_progress value that is displayed
          
       1. If the (job status == finished_success) or (job_status == finished_failure)  
          then stop polling  
  
<br>
<br>
<h5>Advantages of thie Approach</h5>

- Each uploaded file has its own jobId
- If we upload multiple files, this will still work as each upload creates a new job Id


<br>
<br>

```

Procedure
---------
    1. Add the jobs database table
        a. Right-click on backend/src/main/resources/db/migration -> New File
           File name:  V1.4__jobs.sql

        b. Copy this to your newly-created file:
            
            --------------------------------------------------------------
            -- Filename:  V1.4__jobs.sql
            --------------------------------------------------------------
            
            
            -- Create the JOBS table
            create table jobs (
              id              	integer PRIMARY KEY,
              state           	integer NOT NULL,
              type            	integer,
              progress_as_percent   integer,
              submitter_username    varchar(100),
              submitter_date  	timestamp default now(),
              original_filename 	varchar(100),
              user_message    	varchar(2000)
            );


        c. Migrate your database
           unix> cd ~/intellijProjects/angularApp1/backend
           unix> mvn flyway:migrate

        d. Run flyway:info to verify it worked:
           unix> mvn flyway:info

        e. Refresh your database console  (so IntelliJ knows about the new table)




    2. Create this back-end class:  JobStatusDTO   (used to return job status info back to the front-end)
        a. Right-click on backend/src/main/java/com/lessons/models -> New Java Class
           Class Name:  JobStatusDTO

        b. Copy this to your newly-created class:
            
            package com.lessons.models;
            
            import com.fasterxml.jackson.annotation.JsonProperty;
            
            public class JobStatusDTO {
                @JsonProperty("id")
                private Integer id;
            
                @JsonProperty("state")
                private Integer state;
            
                @JsonProperty("user_message")
                private String userMessage;
            
                @JsonProperty("progress_as_percent")
                private Integer progressAsPercent;
            
                /**
                * Spring-JDBC's BeanPropertyRowMapper needs the default constructor for the JobService
                * to get a list of jobStatusDTO objects
                */
                public JobStatusDTO() {
            
                }
            
            
                public JobStatusDTO(Integer aId, Integer aState, Integer aProgressAsPercent, String aUserMessage) {
                    this.id = aId;
                    this.state = aState;
                    this.progressAsPercent = aProgressAsPercent;
                    this.userMessage = aUserMessage;
                }
            
            
                public Integer getId() {
                    return id;
                }
            
                public Integer getState() {
                    return state;
                }
            
                public String getUserMessage() {
                    return userMessage;
                }
            
                public Integer getProgressAsPercent() {
                    return progressAsPercent;
                }
            
            }





    3. Create this back-end class:  JobService
        a. Right-click on backend/src/main/java/com/lessons/services -> New Java Class
           Class Name:  JobService

        b. Copy this to your newly-created class:
            
            package com.lessons.services;
            
            import com.lessons.models.JobStatusDTO;
            import org.slf4j.Logger;
            import org.slf4j.LoggerFactory;
            import org.springframework.jdbc.core.JdbcTemplate;
            import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
            import org.springframework.jdbc.support.rowset.SqlRowSet;
            import org.springframework.stereotype.Service;
            
            import javax.annotation.Resource;
            import javax.sql.DataSource;
            import java.util.HashMap;
            import java.util.Map;
            
            @Service("com.lessons.services.JobService")
            public class JobService {
                private static final Logger logger = LoggerFactory.getLogger(JobService.class);
            
                @Resource
                private DataSource dataSource;
            
                @Resource
                private DatabaseService databaseService;
            
                public static final Integer JOB_STATE_PENDING = 1;
                public static final Integer JOB_STATE_WORK_IN_PROGRESS = 2;
                public static final Integer JOB_STATE_FINISHED_SUCCESS = 3;
                public static final Integer JOB_STATE_FINISHED_ERROR = 4;
            
                /**
                *  Update the job record in the database
                */
                public void updateJobRecord(Integer aJobId, Integer aJobState, Integer aProgressAsPercent) {
                    logger.debug("updateJobRecord started:  aJobId={}", aJobId);
            
                    if (aJobId == null) {
                        throw new RuntimeException("Error in updateJobRecord():  The passed-in aJobId is null.");
                    }
                    else if (aJobState == null) {
                        throw new RuntimeException("Error in updateJobRecord():  The passed-in aJobStatus is null.");
                    }
            
                    // Construct the SQL to update this job record
                    String sql = "update jobs set state=?, progress_as_percent=? where id=?";
            
                    JdbcTemplate jt = new JdbcTemplate(this.dataSource);
                    int rowsUpdated = jt.update(sql, aJobState, aProgressAsPercent, aJobId);
            
                    if (rowsUpdated != 1) {
                        throw new RuntimeException("Error in updateJobRecord():  I expected to update one record, but instead I updated " + rowsUpdated + " rows.  This should never happen.");
                    }
            
                    logger.debug("updateJobRecord finished:  aJobId={}  aJobState={}", aJobId, aJobState);
                }
            
            
                /**
                *  Update the job record as failed
                */
                public void updateJobRecordAsFailed(Integer aJobId, String aJobMessage) {
                    logger.debug("updateJobRecordAsFailed started:  aJobId={}", aJobId);
            
                    if (aJobId == null) {
                        throw new RuntimeException("Error in updateJobRecordAsFailed():  The passed-in aJobId is null.");
                    }
            
                    // Construct the SQL to update this job record
                    String sql = "update jobs set state=?, user_message=? where id=?";
            
                    JdbcTemplate jt = new JdbcTemplate(this.dataSource);
                    int rowsUpdated = jt.update(sql, JOB_STATE_FINISHED_ERROR, aJobMessage, aJobId);
            
                    if (rowsUpdated != 1) {
                        throw new RuntimeException("Error in updateJobRecordAsFailed():  I expected to update one record, but instead I updated " + rowsUpdated + " rows.  This should never happen.");
                    }
            
                    logger.debug("updateJobRecordAsFailed finished:  aJobId={}", aJobId);
                }
            
            
                /**
                *  Update the job record as completed successfully
                */
                public void updateJobRecordAsSucceeded(Integer aJobId) {
                    logger.debug("updateJobRecordAsSucceeded started:  aJobId={}", aJobId);
            
                    if (aJobId == null) {
                        throw new RuntimeException("Error in updateJobRecordAsSucceeded():  The passed-in aJobId is null.");
                    }
            
                    // Construct the SQL to update this job record
                    String sql = "update jobs set state=?, progress_as_percent=100 where id=?";
            
                    JdbcTemplate jt = new JdbcTemplate(this.dataSource);
                    int rowsUpdated = jt.update(sql, JOB_STATE_FINISHED_SUCCESS, aJobId);
            
                    if (rowsUpdated != 1) {
                        throw new RuntimeException("Error in updateJobRecordAsSucceeded():  I expected to update one record, but instead I updated " + rowsUpdated + " rows.  This should never happen.");
                    }
            
                    logger.debug("updateJobRecordAsSucceeded finished:  aJobId={}", aJobId);
                }
            
            
                /**
                * Create a job record and return the number of the newly-created record
                */
                public Integer addJobRecord(String aJobSubmitterName, String aUploadedFilename) {
                    logger.debug("addJobRecord() started.");
            
                    // Get the next unique id from the database
                    Integer newJobId = this.databaseService.getNextId();
            
                    // Create a parameter map to hold all of the bind variables
                    Map<String, Object> paramMap = new HashMap<>();
                    paramMap.put("id", newJobId);
                    paramMap.put("state", JOB_STATE_WORK_IN_PROGRESS);
                    paramMap.put("submitter_username", aJobSubmitterName);
                    paramMap.put("original_filename", aUploadedFilename);
            
                    // Construct the SQL to insert the jobs record
                    String sql = "insert into jobs(id, state, submitter_username, original_filename) " +
                            "values(:id, :state, :submitter_username, :original_filename)";
            
                    // Execute the SQL to insert the jobs record
                    NamedParameterJdbcTemplate nt = new
            NamedParameterJdbcTemplate(this.dataSource);
                    nt.update(sql, paramMap);
            
                    // Return the new job id
                    return newJobId;
                }
            
                /**
                * Get Single JobStatusDTO objects back from the database
                */
                public JobStatusDTO getJobStatus(Integer aJobId) {
            
                    // Execute the SQL to get information about this job
                    JdbcTemplate jt = new JdbcTemplate(this.dataSource);
                    String sql = "select state, user_message, progress_as_percent from jobs where id=?";
                    SqlRowSet rs = jt.queryForRowSet(sql, aJobId);
            
                    if (! rs.next() ) {
                        // I did not find the record
                        throw new RuntimeException("Error in getJobStatus() with aJobId=" + aJobId + "  The job record was not found in the database.");
                    }
            
                    // Get the values out of the SqlRowSet
                    int	state         	= rs.getInt("state");
                    int	progressAsPercent = rs.getInt("progress_as_percent");
                    String userMessage   	= rs.getString("user_message");
            
                    // Put the information into a single object
                    JobStatusDTO jobStatusDTO = new JobStatusDTO(aJobId, state, progressAsPercent, userMessage);
            
                    return jobStatusDTO;
                }
            
            
                /**
                * @param aJobId ID that uniquely identifies this job record
                * @return TRUE if the passed-in aJobId is found in the JOBS database table.  FALSE if
            not found
                */
                public boolean doesJobExist(int aJobId) {
                    // Execute the SQL to get information about this job
                    JdbcTemplate jt = new JdbcTemplate(this.dataSource);
                    String sql = "select id from jobs where id=?";
                    SqlRowSet rs = jt.queryForRowSet(sql, aJobId);
            
                    return rs.next();
                }
            
            }
            



    4. Create this back-end class:  JobController   (holds the REST endpoints for job operations)
        a. Right-click on backend/src/main/java/com/lessons/controllers -> New Java Class
           Class Name:  JobController

        b. Copy this to your newly-created class:
            
            package com.lessons.controllers;
            
            import com.lessons.models.JobStatusDTO;
            import com.lessons.services.JobService;
            import org.slf4j.Logger;
            import org.slf4j.LoggerFactory;
            import org.springframework.http.HttpStatus;
            import org.springframework.http.MediaType;
            import org.springframework.http.ResponseEntity;
            import org.springframework.stereotype.Controller;
            import org.springframework.web.bind.annotation.PathVariable;
            import org.springframework.web.bind.annotation.RequestMapping;
            import org.springframework.web.bind.annotation.RequestMethod;
            import javax.annotation.Resource;
            
            @Controller("com.lessons.controllers.JobController")
            public class JobController {
                private static final Logger logger = LoggerFactory.getLogger(JobController.class);
            
                @Resource
                private JobService jobService;
            
                /**
                * GET /api/jobs/status/{jobId} REST call
                *
                * Returns a JobStatusDTO object that holds information about this one job
                */
                @RequestMapping(value = "/api/jobs/status/{jobId}", method = RequestMethod.GET, produces = "application/json")
                public ResponseEntity<?> getJobStatus(@PathVariable(value="jobId") Integer aJobId) {
            
                    logger.debug("getJobStatus() started.  aJobId={}", aJobId);
            
                    if (! this.jobService.doesJobExist(aJobId)) {
                        // The job id is not found in the database
                        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                                .contentType(MediaType.TEXT_PLAIN)
                                .body("Your job id does not exist in the database: " + aJobId);
                    }
            
                    // Get the status information for this job
                    JobStatusDTO jobStatusDTO = jobService.getJobStatus(aJobId);
            
                    logger.debug("getJobStatus() returns.  aJobId={}  state={}", aJobId, jobStatusDTO.getState());
            
                    // Return the JobStatusDTO back to the front-end and a 200 status code
                    return ResponseEntity
                            .status(HttpStatus.OK)
                            .body(jobStatusDTO);
                }
            
            }
            
            
            





    5. Add this service:  AsyncService
        a. Right-click on backend/src/main/java/com/lessons/services -> New Java Class
           Class Name:  AsyncService

        b. Copy this to your newly-created class
            
            package com.lessons.services;
            
            import org.slf4j.Logger;
            import org.slf4j.LoggerFactory;
            import org.springframework.stereotype.Service;
            
            import javax.annotation.PostConstruct;
            import javax.annotation.PreDestroy;
            import java.util.concurrent.*;
            
            @Service("com.lessons.services.AsyncService")
            public class AsyncService {
                private static final Logger logger = LoggerFactory.getLogger(AsyncService.class);
            
                private ExecutorService executorService = null;
                private ExecutorCompletionService<?> completionService = null;
            
            
                @PostConstruct
                public void init() {
                    final int TOTAL_THREAD_COUNT = 50;
                    final int TOTAL_ACTIVE_THREAD_COUNT = 40;
            
                    // Create a thread pool that can hold 50 threads total
                    this.executorService = Executors.newFixedThreadPool(TOTAL_THREAD_COUNT);
            
                    // Create a threadpool with a fixed number of threads operating off a shared unbounded queue.
                    ExecutorService executorService = Executors.newFixedThreadPool(TOTAL_ACTIVE_THREAD_COUNT);
                    this.completionService = new ExecutorCompletionService<>(executorService);
                }
            
            
                @PreDestroy
                public void destroy() {
                    if (this.executorService != null) {
                        logger.debug("destroy() Shutting down executorService started.");
                        try {
                            executorService.shutdown();
            
                            // Wait 2 seconds threads to finish
                            executorService.awaitTermination(2, TimeUnit.SECONDS);
                        }
                        catch (Exception e) {
                            logger.warn("Ignoring exception raised shutting down the executor service.", e);
                        }
            
                        logger.debug("destroy() Shutting down executorService finished.");
                    }
                }
            
                public void submit(Callable<?> aCallableOperation) {
                    if (aCallableOperation == null) {
                        throw new RuntimeException("Error in submit():  The passed-in callable reference is null.");
                    }
            
                    this.executorService.submit(aCallableOperation);
                }
            }






    6. Add this class:  FileWorker   (used to actually process the file in the background)
        a. Right-click on backend/src/main/java/com/lessons -> new Package
           Package Name:  workers

        b. Right-click on workers -> New Java Class
           Class Name:  FileWorker

        c. Replace FileWorker with this:
            
            package com.lessons.workers;
            
            import com.lessons.services.JobService;
            import org.slf4j.Logger;
            import org.slf4j.LoggerFactory;
            import java.io.InputStream;
            import java.util.concurrent.Callable;
            
            
            public class FileWorker implements Callable<String> {
                private static final Logger logger = LoggerFactory.getLogger(FileWorker.class);
            
                private final Integer jobId;                          		// Holds the jobId for this job
                private final InputStream inputStream;                	// Holds the inputStream of the uploaded file
                private final JobService jobService;                  	// Holds a reference to the JobService so we can use it here
            
            
            
                /**
                * FileWorker constructor.  This is used to pass-in Spring services and other dependencies
                * @param aJobId holds the ID that uniquely identifies this job
                * @param aInputStream Holds the inputStream corresponding to the uploaded file
                * @param aJobService Holds a reference to the JobService (which is used to upload the job status)
                */
                public FileWorker(Integer aJobId, InputStream aInputStream, JobService aJobService) {
                    this.jobId = aJobId;
                    this.inputStream = aInputStream;
                    this.jobService = aJobService;
                }
            
            
                /**
                * Perform the work in the background and update the Jobs record as it progresses
                *
                * @return a string that is not used
                */
                @Override
                public String call()  {
                    try {
                        logger.debug("call() started for jobId={}", this.jobId);
            
                        Thread.sleep(3000);
            
                        // Mark this job as 25% complete in the database
                        this.jobService.updateJobRecord(this.jobId,
            JobService.JOB_STATE_WORK_IN_PROGRESS, 25);
            
            
                        Thread.sleep(3000);
            
                        // Mark this job as 50% complete in the database
                        this.jobService.updateJobRecord(this.jobId, JobService.JOB_STATE_WORK_IN_PROGRESS, 50);
            
            
                        Thread.sleep(3000);
            
                        // Mark this job as 25% complete in the database
                        this.jobService.updateJobRecord(this.jobId, JobService.JOB_STATE_WORK_IN_PROGRESS, 75);
            
                        Thread.sleep(3000);
            
                        // Mark this job as finished successfully (so the front-end will know to stop polling)
                        this.jobService.updateJobRecordAsSucceeded(this.jobId);
            
                        logger.debug("call() finished for jobId={}", this.jobId);
                    }
                    catch (Exception e) {
                        // Mark this job as finished with failure  (so the front-end will know to stop polling)
                        this.jobService.updateJobRecordAsFailed(this.jobId, e.getMessage());
                    }
            
                    return null;
                }
            }
            


    7. Replace the ReportController.uploadFile REST endpoint
        a. Edit this class:  ReportController.java

        b. Inject the asyncService and jobService at the top
             @Resource
             private AsyncService asyncService;
        
             @Resource
             private JobService jobService;


        c. Replace the uploadFile() method with this:
        
            /**
            * REST endpoint /api/reports/upload
            * @param aMultipartFile holds uploaded file InputStream and meta data
            * @return the jobId and a 200 status code
            */
            @RequestMapping(value = "/api/reports/upload", method = RequestMethod.POST)
            public ResponseEntity<?> uploadFile(
                    @RequestParam(value = "file", required = true) MultipartFile aMultipartFile) 
                                                throws Exception
            {
                logger.debug("uploadFile() started. ");
        
                String loggedInUserName = "John Smith";
                String uploadedFilename = aMultipartFile.getOriginalFilename();
        
                // Add a record to the jobs table
                Integer jobId = jobService.addJobRecord(loggedInUserName, uploadedFilename);
        
                // Create the worker thread that will process this NISS file (xlsx file)
                FileWorker fileWorker = new FileWorker(jobId, aMultipartFile.getInputStream(),
                                                 this.jobService);
                // Execute the worker thread in the background
                // NOTE:  This code runs in a separate thread
                asyncService.submit(fileWorker);
        
                // Return a response of 200 and the job number
                return ResponseEntity.status(HttpStatus.OK)
                                    .body(jobId);
            }


    8. On the front-end, create a JobServiceDTO typescript class
        a. Create the job-status-dto.ts class
           unix> cd ~/intellijProjects/angularApp1/frontend
           unix> ng generate class models/JobStatusDTO --skipTests

        b. Replace its contents with this:
            
            export class JobStatusDTO {
              public id             		: number;
              public state          		: number;
              public user_message   	: string;
              public progress_as_percent	: number;
            }



    9. On the front-end, create a JobService typescript class
        a. Create the job.service.ts class
           unix> cd ~/intellijProjects/angularApp1/frontend
           unix> ng generate service services/job --skipTests

        b. Replace its contents with this
            
            import { Injectable } from '@angular/core';
            import {Observable} from "rxjs";
            import {environment} from "../../environments/environment";
            import {HttpClient} from "@angular/common/http";
            import {JobStatusDTO} from "../models/job-status-dto";
            
            @Injectable({
              providedIn: 'root'
            })
            export class JobService {
            
              constructor(private httpClient: HttpClient) { }
            
              /*
               * These JobStates must correspond to the back-end JobService
               */
              public JOB_STATE_WORK_IN_PROGRESS: number = 2;
              public JOB_STATE_FINISHED_SUCCESS: number = 3;
              public JOB_STATE_FINISHED_ERROR: number = 4;
            
              /*
               * Returns an observable that holds the JobStatusDTO object
               */
              public getJobStatus(aJobId: number): Observable<JobStatusDTO> {
                // Construct the URL of the REST call
                const restUrl = environment.baseUrl + '/api/jobs/status/' + aJobId;
            
                // Return an observable
                return this.httpClient.get <JobStatusDTO>(restUrl);
              }
            
            }



    10. Adjust the Upload Report page to do the polling on file upload
        a. Edit upload-report.component.ts

        b. Replace its contents with this:
            
            import {Component, ElementRef, OnInit, ViewChild} from '@angular/core';
            import {FileItem, FileUploader, ParsedResponseHeaders} from "ng2-file-upload";
            import {environment} from "../../../environments/environment";
            import {MessageService} from "../../services/message.service";
            import {JobStatusDTO} from "../../models/job-status-dto";
            import {JobService} from "../../services/job.service";
            
            
            const backendUploadUrl = environment.baseUrl + '/api/reports/upload';
            
            @Component({
              selector: 'app-upload-report',
              templateUrl: './upload-report.component.html',
              styleUrls: ['./upload-report.component.css']
            })
            export class UploadReportComponent implements OnInit {
              @ViewChild('selectedFile') selectedFile: ElementRef;
            
              public PROCESSING_NOT_STARTED    	: number = 1;
              public PROCESSING_IN_PROGRESS    	: number = 2;
              public PROCESSING_FINISHED_SUCCESS   : number = 3;
              public PROCESSING_FINISHED_FAILURE   : number = 4;
              public PROCESSING_UPLOAD_IN_PROGRESS : number = 5;
            
              public  selectedFileToUpload:  FileItem | null = null;
              private lastFileItemAddedToQueue: FileItem;
            
              public  pageState: number = this.PROCESSING_NOT_STARTED;
              private pollingAttempts: number = 0;
              private interval: any;
              public  percentProcessed: number;
              public  userMessage: string;
            
              // Make sure the itemAlias matches the
              // 	@RequestParam(value = "file" in the REST endpoint on backend
              //
              public uploader: FileUploader = new FileUploader(
                {
                url: backendUploadUrl,
                queueLimit: 2,
                itemAlias: 'file'
                });
            
              constructor(private messageService: MessageService,
                        private jobService: JobService) { }
            
            
              ngOnInit(): void {
                this.uploader.onAfterAddingFile = (item: FileItem) => this.onAfterAddingFile(item);
            
                this.uploader.onCompleteItem = (item, response, status, headers) =>
                this.onCompleteItem(item, response, status, headers);
              }
            
            
              /*
               * The upload has finished and we got a response back from the back-end
               *  1) If the response = 200, then start polling on the returned jobId
               *  2) Else, show an error
               */
              onCompleteItem(item: any, response: any, status: number, headers:
            ParsedResponseHeaders): any {
            
                this.pageState = this.PROCESSING_IN_PROGRESS;
            
                // An Upload has finished
                if (status == 200) {
                this.pageState = this.PROCESSING_IN_PROGRESS;
            
                // Get the jobId from the response
                let jobId: number = response;
            
                // Start polling
                this.startPolling(jobId);
                }
                else {
                // Send a message to the user letting him know if it failed
                this.pageState = this.PROCESSING_FINISHED_FAILURE;
            
                let message = " status=" + status + "   response=" + response;
                this.messageService.showErrorMessage(message);
                }
              }
            
            
              public onFileSelected(aFiles: File[]) {
                if (aFiles.length == 0) {
                // The user cancelled selecting a file -- so stop here
                return;
                }
            
                if (this.selectedFileToUpload != null) {
                // Remove the old file from the queue
                this.uploader.removeFromQueue(this.selectedFileToUpload)
                }
            
                this.selectedFileToUpload = this.lastFileItemAddedToQueue;
              }
            
            
              /*
               * When using the FileUploader, there is an order of operations
               *  1) User selects file
               *  2) The FileUploader adds it to the queue
               *  3) onAfterAddingFile() is called
               *  4) onFileSelected() is called
               */
              private onAfterAddingFile(aFileItem: FileItem) {
                // This line is required to make upload work with spring security
                aFileItem.withCredentials = false;
            
                // Get a reference to the last FileItem object added to the queue
                // NOTE:  This reference is used in onFileSelected()
                this.lastFileItemAddedToQueue = aFileItem;
              }
            
            
            
              public clearAll(): void {
                this.uploader.clearQueue();
                this.selectedFileToUpload = null;
                this.pageState = this.PROCESSING_NOT_STARTED;
                this.pollingAttempts = 0;
                this.percentProcessed = 0;
            
                // Fixes the problem in which a user selects the same file twice
                if (this.selectedFile) {
                this.selectedFile.nativeElement.value = '';
                }
              }
            
            
              private stopPolling(): void {
                if (this.interval != null) {
                clearInterval(this.interval);
                }
              }
            
            
              public beginFileUpload(): void {
                this.pageState = this.PROCESSING_UPLOAD_IN_PROGRESS;
            
                // Tell the FileUploader to send the file to the back-end
                this.uploader.uploadAll();
              }
            
            
              /*
               * Start polling the front-end on the passed-in aJobId
               * -- As the REST call comes in, the HTML template should show the progress bar advancing
               */
              private startPolling(aJobId: number): void {
                this.pollingAttempts = 0;
            
                // Poll every 2 seconds
                this.interval = setInterval(() => {
            
                this.jobService.getJobStatus(aJobId).subscribe(data => {
            
                    let jobStatusDTO: JobStatusDTO = data;
            
                    this.pollingAttempts++;
            
                    if ((this.pollingAttempts >= 30) && (jobStatusDTO.state == 0)) {
                    // We have not seen any increase in 30 attempts -- so something is wrong
                    this.pageState = this.PROCESSING_FINISHED_FAILURE;
                    this.stopPolling();
                    let message: string = "Error processing this file:  It failed to be parsed.";
                    this.messageService.showErrorMessage(message);
                    }
                    else if (jobStatusDTO.state == this.jobService.JOB_STATE_WORK_IN_PROGRESS) {
                    // The job is work-in-progress
                    this.percentProcessed = jobStatusDTO.progress_as_percent;
                    }
                    else if (jobStatusDTO.state == this.jobService.JOB_STATE_FINISHED_SUCCESS) {
                    // The job finished successfully
                    this.pageState = this.PROCESSING_FINISHED_SUCCESS;
                    this.percentProcessed = 100;
            
                    // The backend has finished processing -- so stop polling
                    this.stopPolling();
            
                    let message: string = "Successfully processed this file.";
                    this.messageService.showSuccessMessage(message);
                    }
                    else if (jobStatusDTO.state == this.jobService.JOB_STATE_FINISHED_ERROR) {
                    this.pageState = this.PROCESSING_FINISHED_FAILURE;
                    this.userMessage = jobStatusDTO.user_message;
            
                    this.messageService.showErrorMessage('Failed to process this file:\n' + jobStatusDTO.user_message);
            
                    // The job finished with failure
                    this.stopPolling();
                    }
                })}, 2000);
            
              }  // end of startPolling()
            
            
            }
            
            



    11. Adjust the CSS classes for the Upload Report page
        a. Edit upload-report.component.css

        b. Add these CSS classes:
            
            .mat-progress-bar {
              height: 15px;
            }
            
            .error-message {
              font-size: 15px;
              font-weight: 500;
              font-family: Roboto, "Helvetica Neue", sans-serif;
            }
            
            :host ::ng-deep .mat-progress-bar .mat-progress-bar-fill {
                /* Fix the bug with the mat-progress-bar's animation being choppy */
                transition: transform 100ms linear;
            }
            



    12. Adjust the HTML to show the two progress bars
        a. Edit upload-report.component.html

        b. Remove the old progress bar

        c. Replace it with this HTML:
            
            <div style="margin-top: 20px">
                    <div *ngIf="(this.pageState == this.PROCESSING_IN_PROGRESS) || (this.pageState == this.PROCESSING_UPLOAD_IN_PROGRESS)">
                    <!-- Show Spinner -->
                    <div style="margin-top: 20px"><i class="fa fa-spin fa-spinner fa-2x"></i> Processing the pdf file...</div>
                    </div>
                 
                    <div *ngIf="this.uploader.progress > 0"  style="margin-top: 20px">
                    <!-- Show the "Upload" Progress Bar -->
                    Percentage of the file uploaded: {{uploader.progress | number:'1.0-0'}}% &nbsp;
                    <mat-progress-bar  color="accent" [value]="uploader.progress"></mat-progress-bar>
                    </div>
            
                    <div *ngIf="this.percentProcessed > 0"  style="margin-top: 20px">
                    <!-- Show the "File Processing" Progress Bar and keep it present (even if the job state changes from wip to completed -->
                    Percentage of the file Processed: {{percentProcessed | number:'1.0-0'}}% &nbsp;
                    <mat-progress-bar color="primary" [value]="this.percentProcessed"></mat-progress-bar>
                    </div>
            
                    <div *ngIf="this.pageState == this.PROCESSING_FINISHED_FAILURE" style="margin-top: 20px">
                    <!-- The Job Finished in Failure:  So, show an error message -->
                    <p class="error-message">Error occurred processing this file.<br/>{{this.userMessage}}</p>
                    </div>
                </div>


        d. Adjust the "Reset" and "Upload All" buttons as so:
        
                <!-- Reset Button -->
                <button type="button" mat-raised-button
                        [disabled]="(this.uploader.queue.length == 0) || (this.pageState == this.PROCESSING_IN_PROGRESS)"
                        (click)="this.clearAll()">
                   Reset
                </button>
        
                <!-- Begin Upload Button -->
                <button type="button" mat-raised-button style="margin-left: 15px" color="primary"
                        [disabled]="(this.uploader.queue.length == 0) || (this.pageState != this.PROCESSING_NOT_STARTED)"
                        (click)="this.beginFileUpload()">
                   Upload File
                </button>
        

        e. Change the upload-file-button so that it has an html template variable
           (Add the #selectedFile to it)
            
                <input id="file-upload" type="file" name="file" ng2FileSelect #selectedFile
                        [uploader]="uploader"
                        [disabled]="this.pageState != this.PROCESSING_NOT_STARTED"
                        (onFileSelected)="this.onFileSelected($event)" />




        f. When finished, the upload-report.component.html looks something like this:
            
            <mat-card>
              <mat-card-title>Upload Report</mat-card-title>
            
              <mat-card-content>
            
                <div style="text-align: center; display: block; margin-top: 10px">
            
                <!-- Upload Button -->
                <label for="file-upload" class="custom-file-upload">
                    <i class="fas fa-cloud-upload-alt"></i>&nbsp;&nbsp;Select File to Upload
                </label>
                <input id="file-upload" type="file" name="file" ng2FileSelect #selectedFile
                        [uploader]="uploader"
                        [disabled]="this.pageState != this.PROCESSING_NOT_STARTED"
                        (onFileSelected)="this.onFileSelected($event)" />
            
                <!-- Show information about selected file -->
                <div *ngIf="this.selectedFileToUpload != null"  style="margin-top: 10px;">
                    Ready to upload <b>{{this.selectedFileToUpload.file.name}}</b>
                </div>
            
                <!-- Page Buttons -->
                <div style="display: block; margin-top: 25px">
            
                    <!-- Clear Button -->
                    <button type="button" mat-raised-button
                            [disabled]="(this.uploader.queue.length == 0) || (this.pageState == this.PROCESSING_IN_PROGRESS)"
                            (click)="this.clearAll()">
                    Reset
                    </button>
            
                    <!-- Begin Upload Button -->
                    <button type="button" mat-raised-button style="margin-left: 15px" color="primary"
                            [disabled]="(this.uploader.queue.length == 0) || (this.pageState != this.PROCESSING_NOT_STARTED)"
                            (click)="this.beginFileUpload()">
                    Upload File
                    </button>
                </div>
            
                </div>
            
                <div style="margin-top: 20px">
                    <div *ngIf="(this.pageState == this.PROCESSING_IN_PROGRESS) || (this.pageState == this.PROCESSING_UPLOAD_IN_PROGRESS)">
                    <!-- Show Spinner -->
                    <div style="margin-top: 20px"><i class="fa fa-spin fa-spinner fa-2x"></i> Processing the pdf file...</div>
                    </div>
            
                    <div *ngIf="this.uploader.progress > 0"  style="margin-top: 20px">
                    <!-- Show the "Upload" Progress Bar -->
                    Percentage of the file uploaded: {{uploader.progress | number:'1.0-0'}}% 
                    <mat-progress-bar  color="accent" [value]="uploader.progress"></mat-progress-bar>
                    </div>
            
                    <div *ngIf="this.percentProcessed > 0"  style="margin-top: 20px">
                    <!-- Show the "File Processing" Progress Bar and keep it present (even if the job state changes from wip to completed -->
                    Percentage of the file Processed: {{percentProcessed | number:'1.0-0'}}% 
                    <mat-progress-bar color="primary" [value]="this.percentProcessed"></mat-progress-bar>
                    </div>
            
                    <div *ngIf="this.pageState == this.PROCESSING_FINISHED_FAILURE" style="margin-top: 20px">
                    <!-- The Job Finished in Failure:  So, show an error message -->
                    <p class="error-message">Error occurred processing this file.<br/>{{this.userMessage}}</p>
                    </div>
                </div>
            
              </mat-card-content>
            </mat-card>
            


    13. Give it a shot
        a. Activate the Debugger - Full WebApp
        b. Go to "Upload Reports"
        c. Upload a file -- e.g., a file that's oh say, under 10 gigabytes in size

```
![](https://lh5.googleusercontent.com/2uBSP-KewxR-LEeEbu7iJJ00ZZH5ztI7dwRYmgdpbpFx4JLBOxWA9Wi1Fo1pYsf4Uk-ZLzLF1P_dpXihjv3kxrXXONq3LMM4iIFgX4Ye8gw2luUICkd65HZkVnbBblEvcOGvptUH)
