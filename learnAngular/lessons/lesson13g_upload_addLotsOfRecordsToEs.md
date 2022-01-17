Lesson 13g:  Upload Report / Add One MIllion Records to ES
----------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1y9sU5YB885kVRYd3B8vEMzeIVE71qwoPYug4_en8v5g/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson13g/add-lots-of-records
<br>
<br>
<br>

<h3> Problem Set </h3>

Problem: I want to add 1 million records to ElasticSearch in under 60 seconds (I hate waiting)<br>
Solution: Have that one back end thread spin off 100 threads to process the CSV file in parallel<br>

![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/lesson13g_image1.png)
<br>
<br>
<br>

<h3>Approach</h3>

1. Add Maven dependencies  

1. Generate a 1 million record CSV file  

1. Adjust the ElasticSearchService so it will automatically create the reports mapping on webapp startup  

1. Adjust the reports mapping (add a keyword for the id field)  

1. Create a ReportRecordDTO object (represents one line of the CSV file)  

1. Create the PartialFileWorker class  
   This class adds records to ES for a chunk of the file

   1. Loop through each csv line in this chunk of file

      1. Create a ReportRecordDTO object (from the csv line)
      1. Convert the ReportRecordDTO object into JSON
      1. Add the JSON so an ElasticSearch bulk json request
      1. If enough records have been added, then send the bulk request to ES

   1. If there are any records left, then send the last bulk request to ES  

1. Adjust the FileWorker class so that it kicks-off 100 PartialFileWorker threads

   1. Loop thru each line of the csv file

      1. Add the line to a stringBuilder
      1. After N lines, launch a thread to process that chunk (of the csv file)

   1. If there are lines left, launch one last thread to process the last chunk (of the csv file)  

1. Adjust the ReportController.uploadFile() so it passes-in the ES index name and ElasticSearchService

<br>
<br>

```

Procedure
---------
    1. Add maven dependencies for commons-io and commons-csv
        a. Edit backend/pom.xml

        b. Add these dependencies:
            
            <dependency>
                <groupId>commons-io</groupId>
                <artifactId>commons-io</artifactId>
                <version>2.8.0</version>
            </dependency>

            <dependency>
                <groupId>org.apache.commons</groupId>
                <artifactId>commons-csv</artifactId>
                <version>1.8</version>
            </dependency>

        c. Right-click on the pom.xml -> Maven -> Reload Project



    2. Make sure your Junit plugin is enabled in IntelliJ
        a. Pull File -> Settings
        b. Click on Plugins
        c. Search for junit
           -- Make sure it's enabled


    3. Create a test class that will a generate 1 million record csv file
        a. Edit backend/src/test/java/com/lessons/AppTests.java

        b. Replace its contents with this:
            
            package com.lessons;
            
            import static org.junit.Assert.assertTrue;
            import org.apache.commons.io.FileUtils;
            import org.junit.Test;
            import org.slf4j.Logger;
            import org.slf4j.LoggerFactory;
            import java.io.File;
            import java.nio.charset.StandardCharsets;
            import java.text.SimpleDateFormat;
            import java.util.Arrays;
            import java.util.Date;
            import java.util.List;
            import java.util.concurrent.ThreadLocalRandom;
            
            /**
             * Unit test for simple App.
             */
            public class AppTest
            {
                private static final Logger logger = LoggerFactory.getLogger(AppTest.class);
                private final SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
            
                private final List<String> randomDescriptions = Arrays.asList("This is description of this silly report",
                                         "I am still working on this report",
                                         "This report might contain malware so please be careful",
                                         "The O'reilly group is still investigating this for CUI",
                                         "Unknown Report",
                                         "The ark is a source of unspeakable power and it has to be researched.",
                                         "\"And, it will be researched.  I assure you, Dr. Jones.  We have top men working on it now.  Top men.\"");
            
            private final List<String> randomPriorities = Arrays.asList("Low", "Medium", "High", "Critical");
            
                /**
                * Rigorous Test :-)
                */
                @Test
                public void shouldAnswerWithTrue()
                {
                    assertTrue( true );
                }
            
                @Ignore
                @Test
                public void createTestFile() throws Exception {
                    long startTime = System.currentTimeMillis();
            
                    final int TOTAL_RECORDS=1_000_000;
                    final int tenPercentOfTotal = TOTAL_RECORDS / 10;
            
                    File outputFile = new File("../docs/large_file." + TOTAL_RECORDS + ".csv");
                    logger.debug("createTestFile() started.  Creating a file that holds {} records:\n\t{}", TOTAL_RECORDS, outputFile.getAbsolutePath());
            
                    if (outputFile.exists() ) {
                        outputFile.delete();
                    }
            
                    // Create a StringBuilder capable of holding 100 million bytes
                    StringBuilder fileContents = new StringBuilder(100_000_000);
            
                    // Add the header
                    fileContents.append("id,display_name,description,priority,start_date,end_date\n");
            
                    Date startDate1 = new SimpleDateFormat("yyyy-MM-dd").parse("2015-01-01");
                    Date startDate2 = new SimpleDateFormat("yyyy-MM-dd").parse("2019-12-31");
            
                    Date endDate1 = new SimpleDateFormat("yyyy-MM-dd").parse("2020-01-01");
                    Date endDate2 = new SimpleDateFormat("yyyy-MM-dd").parse("2021-12-31");
            
                    for (int i=1; i<=TOTAL_RECORDS; i++)
                    {
                            // Append one line to the stringBuilderobject
                            fileContents.append(i)
                                        .append(",")
                                        .append("report ")
                                        .append(i)
                                        .append(",")
                                        .append( getRandomDescription() )
                                        .append(",")
                                        .append( getRandomPriorityString() )
                                        .append(",")
                                        .append(getRandomDateBetweenDates(startDate1, startDate2) )
                                        .append(",")
                                        .append(getRandomDateBetweenDates(endDate1, endDate2))
                                        .append("\n");
            
                        if ((i % tenPercentOfTotal) == 0) {
                            logger.debug("Finished row " + i);
                            }
                    }
            
                    // Write the string to a file
                    FileUtils.writeStringToFile(outputFile, fileContents.toString(), StandardCharsets.UTF_8);
            
                    long endTime = System.currentTimeMillis();
                    logger.debug("createTestFile() finished after {} secs", (endTime - startTime) / 1000);
                }
            
            
                private String getRandomPriorityString() {
                    int randomPriorityIndex = ThreadLocalRandom.current().nextInt(0,
            this.randomPriorities.size());
                    String rndPriorityString = this.randomPriorities.get(randomPriorityIndex);
                    return rndPriorityString;
                }
            
                private String getRandomDescription() {
                    int randomArrayIndex = ThreadLocalRandom.current().nextInt(0, this.randomDescriptions.size());
                    String rndDescription = this.randomDescriptions.get(randomArrayIndex);
                    return rndDescription;
                }
            
                private String getRandomDateBetweenDates(Date aStartDate, Date aEndDate) {
                    Date randomDate = new Date(ThreadLocalRandom.current()
                            .nextLong(aStartDate.getTime(), aEndDate.getTime()));
                    return simpleDateFormat.format(randomDate);
                }
            
            }



        c. Create the docs directory
           unix> cd ~/intellijProjects/angularApp1
           unix> mkdir docs

        d. Run the single unit test to generate the file
           i.   Go to backend/src/test/java/com/lessons/AppTest 
           ii.  Put the cursor on createTestFile()
           iii. Right-click on createTestFile -> Run 'createTestFile' 
                -- This should generate a 98 MB file called large_file.1000000.csv



    4. Adjust the ElasticSearchService so it will automatically create the reports mapping on webapp startup
        a. Edit ElasticSearchService.java

        b. Add this private method:
            
            private void initializeMapping() throws Exception {
                    if (! doesIndexExist("reports")) {
                            // Create the reports ES mapping
            
                            // Read the mapping file into a large string
                            String reportsMappingAsJson=readInternalFileIntoString("reports.mapping.json");
            
                            // Create a mapping in ElasticSearch
                            createIndex("reports", reportsMappingAsJson);
                    }
            }


        c. Call this method at the end of ElasticSearchService.init():    (see changes in bold)
        
            @PostConstruct
            public void init() throws Exception {
                logger.debug("init() started.");
        
                // In order to make outgoing calls to ElasticSearch you need 2 things:
                //   1) The elastic search url -- e.g., "http://localhost:9201"
                //   2) The initialized AsyncHttpClient object
                this.elasticSearchUrl = elasticSearchResources.getElasticSearchUrl();
                this.asyncHttpClient = elasticSearchResources.getAsyncHttpClient();
        
        
                this.objectMapper = new ObjectMapper();
        
                // Create the reports mapping (if they do not exist)
                initializeMapping();
        
                logger.debug("init() finished.  elasticSearchUrl={}", this.elasticSearchUrl);
            }
        



    5. Adjust the reports mapping (increase the refresh_interval from 1s to 2s and add a keyword for the id
        a. Edit backend/src/main/resources/reports.mapping.json

        b. Change the id field so it has a subfield that is a keyword:
            
           Change the "id" field to this:
            
                "id": {
                        "type": "integer",
                        "ignore_malformed": false,
            
                        "fields": {
                            "raw": {
                                    "type": "keyword"
                            }
                        }
                },
        
        
        When finished the reports.mapping.json should look like this:
        
        {
          "settings": {
            "analysis": {
            "analyzer" : {
                "my_ngram_analyzer" : {
                "tokenizer" : "my_ngram_tokenizer",
                "filter": ["lowercase"]
                }
            },
            "tokenizer" : {
                "my_ngram_tokenizer" : {
                "type" : "ngram",
                "min_gram" : "1",
                "max_gram" : "25",
                "token_chars": [ ]
                }
            },
            "normalizer": {
                "case_insensitive_normalizer": {
                "type": "custom",
                "char_filter": [],
                "filter": [ "lowercase", "asciifolding" ]
                }
            }
            },
            "max_result_window": 500000,
            "refresh_interval": "1s",
            "max_ngram_diff": "25"
          },
        
          "mappings": {
            "dynamic": "strict",
            "properties": {
        
            "id": {
                "type": "integer",
                "ignore_malformed": false,
                "fields": {
                "raw": {
                    "type": "keyword"
                }
                }
            },
        
            "description": {
                "type": "text"
            },
        
            "display_name": {
                "type": "text",
                "fields": {
                "raw": {
                    "type": "keyword"
                },
                "sort": {
                    "type": "keyword",
                    "normalizer": "case_insensitive_normalizer"
                },
                "filtered": {
                    "type": "text",
                    "analyzer": "my_ngram_analyzer"
                }
                }
            },
        
            "priority": {
                "type": "text",
                "fields": {
                "raw": {
                    "type": "keyword"
                },
        
                "sort": {
                    "type": "keyword",
                    "normalizer": "case_insensitive_normalizer"
                },
        
                "filtered": {
                    "type": "text",
                    "analyzer": "my_ngram_analyzer"
                }
                }
            }
            }
          }
        }


    6. Create a ReportRecordDTO object (represents one line of the CSV file)
        a. Right-click on backend/src/main/java/com/lessons/models -> New Java Class
           Class Name:  ReportRecordDTO

        b. Copy this to your newly-created class:
            
            package com.lessons.models;
            
            import com.fasterxml.jackson.annotation.JsonProperty;
            
            public class ReportRecordDTO {
                @JsonProperty("id")		// The JsonProperty must match the ES mapping field name
                private final Integer id;         	// Variable name can be anything
            
                @JsonProperty("description")
                private final String description;
            
                @JsonProperty("display_name")
                private final String displayName;
            
                @JsonProperty("priority")
                private final String priority;
            
                // ---------------------- Constructor & Getters -----------------------
                public ReportRecordDTO(Integer id, String description, String displayName, String priority) {
                    this.id = id;
                    this.description = description;
                    this.displayName = displayName;
                    this.priority = priority;
                }
            
                public Integer getId() {
                    return id;
                }
            
                public String getDescription() {
                    return description;
                }
            
                public String getDisplayName() {
                    return displayName;
                }
            
                public String getPriority() {
                    return priority;
                }
            }


    7. Create the PartialFileWorker class
       This class adds records to ES for a chunk of the file
        a. Right-click on backend/src/main/java/com/lessons/workers -> New Java Class
           Class Name:  PartialFileWorker

        b. Copy this to your newly-created class:
            
            package com.lessons.workers;
            
            import com.fasterxml.jackson.databind.ObjectMapper;
            import com.lessons.models.ReportRecordDTO;
            import com.lessons.services.ElasticSearchService;
            import org.apache.commons.csv.CSVFormat;
            import org.apache.commons.csv.CSVParser;
            import org.apache.commons.csv.CSVRecord;
            import org.slf4j.Logger;
            import org.slf4j.LoggerFactory;
            import java.io.StringReader;
            import java.util.concurrent.Callable;
            
            public class PartialFileWorker implements Callable<Boolean> {
                private static final Logger logger = LoggerFactory.getLogger(PartialFileWorker.class);
            
                private final ElasticSearchService elasticSearchService;
                private final ObjectMapper objectMapper;
                private final String fileContents;
                private final String indexName;
            
            
                public PartialFileWorker(String aFileContents, String aIndexName, ElasticSearchService aElasticSearchService, ObjectMapper aObjectMapper) {
                    this.fileContents = aFileContents;
                    this.indexName = aIndexName;
                    this.elasticSearchService = aElasticSearchService;
                    this.objectMapper = aObjectMapper;
                }
            
                @Override
                public Boolean call() throws Exception {
                    final int BULK_RECORD_SIZE = 5000;
                    int recordNumber = 0;
            
                    CSVParser csvParser = null;
                    String jsonForThisCsvLine;
                    StringBuilder bulkJsonRequest = new StringBuilder(20000);
                    StringReader stringReader = new StringReader(this.fileContents);
            
                    try {
                        csvParser = new CSVParser(stringReader, CSVFormat.DEFAULT.withFirstRecordAsHeader()
                                                                                .withIgnoreHeaderCase()
                                                                                .withTrim()
                                                                                .withQuote('"'));
            
                        Iterable<CSVRecord> csvRecords = csvParser.getRecords();
            
                        // Loop through all csv lines in the fileContents string
                        for (CSVRecord csvRecord : csvRecords) {
            
                            // Create a ReportRecord object
                            ReportRecordDTO reportRecordDTO = new ReportRecordDTO(
                                                                Integer.parseInt(csvRecord.get("id")),
                                                                csvRecord.get("description"),
                                                                csvRecord.get("display_name"),
                                                                csvRecord.get("priority")  );
            
                            // Convert the ReportRecordDTO to a JSON string
                            jsonForThisCsvLine = objectMapper.writeValueAsString(reportRecordDTO);
            
            
                            // Append this JSON string to the bulkdJsonRequest
                            bulkJsonRequest.append("{ \"index\": { \"_index\": \"").append(this.indexName).append("\" }}\n")
                                    .append(jsonForThisCsvLine)
                                    .append("\n");
            
                            recordNumber++;
            
                            if ((recordNumber % BULK_RECORD_SIZE) == 0) {
                                logger.debug("Sending a batch of records to ES {}", this.indexName);
                                // I've reached N records.  So, send this bulk request to ElasticSearch
                                this.elasticSearchService.bulkUpdate(bulkJsonRequest.toString(), true);
            
                                // Clear out the string builder object
                                recordNumber = 0;
                                bulkJsonRequest.setLength(0);
                            }
                        }
                    } catch (Exception e) {
                        logger.error("Exception in PartialFileWorker.call()", e);
            
                        // This thread failed, so return false;
                        return false;
                    }
                    finally {
                        if (stringReader != null) {
                            stringReader.close();
                        }
            
                        if (csvParser != null) {
                            csvParser.close();
                        }
                    }
            
                    if (recordNumber > 0) {
                        // Send the last partial JSON to ElasticSearch
                        logger.debug("Sending the last batch of records to ES {}.", this.indexName);
                        this.elasticSearchService.bulkUpdate(bulkJsonRequest.toString(), true);
                    }
            
                    // This thread succeeded, so return true;
                    return true;
                }
            }


    8. Adjust the FileWorker class so that it kicks-off 100 PartialFileWorker threads
        a. Edit backend/src/main/java/com/lessons/worker/FileWorker

        b. Replace its contents with this:
            
            package com.lessons.workers;
            
            import com.fasterxml.jackson.core.JsonGenerator;
            import com.fasterxml.jackson.databind.ObjectMapper;
            import com.fasterxml.jackson.databind.PropertyNamingStrategy;
            import com.lessons.services.ElasticSearchService;
            import com.lessons.services.JobService;
            import org.apache.commons.io.FileUtils;
            import org.apache.commons.lang3.StringUtils;
            import org.slf4j.Logger;
            import org.slf4j.LoggerFactory;
            import java.io.*;
            import java.util.concurrent.*;
            
            
            public class FileWorker implements Callable<String> {
                private static final Logger logger = LoggerFactory.getLogger(FileWorker.class);
            
                private final Integer          	jobId;                   	// Holds the jobId for this job
                private final JobService       	jobService;              	// Holds a reference to the JobService so we can use it here
                private final ElasticSearchService elasticSearchService;
                private final String           	indexName;               	// Holds the destination ES index name
                private final ObjectMapper     	objectMapper;            	// Used to write java objects to JSON
                private final File             	tempSourceFile;
            
            
                /**
                * FileWorker constructor.  This is used to pass-in Spring services and other dependencies
                * @param aJobId holds the ID that uniquely identifies this job
                * @param aInputStream Holds the inputStream corresponding to the uploaded file
                * @param aJobService Holds a reference to the JobService (which is used to upload the job status)
                */
                public FileWorker(Integer aJobId, String aIndexName, InputStream aInputStream, JobService aJobService, ElasticSearchService aElasticSearchService) throws Exception {
                    this.jobId = aJobId;
                    this.indexName = aIndexName;
                    this.jobService = aJobService;
                    this.elasticSearchService = aElasticSearchService;
            
                    if (aInputStream == null) {
                        throw new RuntimeException("Error in FileWorker constructor.  The passed-in aInputStreamExcelFile is null.");
                    }
            
                    // Create a tempFile from the inputStream (so the web app uses less memory)
                    this.tempSourceFile = File.createTempFile("upload.report.", ".tmp");
                    FileUtils.copyInputStreamToFile(aInputStream, this.tempSourceFile);
                    logger.debug("Created this temp file: {}", this.tempSourceFile);
            
            
                    // Initialize the objectMapper  (used to convert a single row into a JSON string)
                    this.objectMapper = new ObjectMapper();
            
                    // Tell the object mapper to convert Objects to snake case
                    // For example.  object.getPersonName --> "person_name" in the json
                    this.objectMapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
            
                    // Escape non-nulls
                    this.objectMapper.getFactory().configure(JsonGenerator.Feature.ESCAPE_NON_ASCII, true);
                }
            
            
                /**
                * Remove any temporary files
                */
                private void cleanup() {
                    if (tempSourceFile != null) {
                        logger.debug("Started Deleting temp file {}", tempSourceFile);
                        boolean deleteWorked = tempSourceFile.delete();
                        if (!deleteWorked) {
                            logger.warn("WARNING:  Failed to delete this tempFile: {}", tempSourceFile);
                        }
                        else {
                            logger.debug("Successfully deleted this tempFile: {}", tempSourceFile);
                        }
                    }
                }
            
            
                /**
                * Launch lots of PartialFileWorker threads to process this file in parallel
                * 
                * @return a string that is not used
                */
                @Override
                public String call()  {
                    long startTime = System.currentTimeMillis();
                    logger.debug("FileWorker.call() started for jobId={}", this.jobId);
            
                    // Set the job status as work-in-progress (1%)
                    this.jobService.updateJobRecord(this.jobId, JobService.JOB_STATE_WORK_IN_PROGRESS, 1);
            
                    try {
                        logger.debug("call() started for jobId={}", this.jobId);
            
                        // Launch multiple threads to parse each tab of the workbook in parallel
                        processFileWithMultipleThreads();
            
                        // Mark this job as finished successfully (so the front-end will know to stop polling)
                        this.jobService.updateJobRecordAsSucceeded(this.jobId);
            
                        logger.debug("call() finished for jobId={}", this.jobId);
                    }
                    catch (Exception e) {
                        // This job failed
                        logger.error("Error in FileWorker.call()", e);
            
                        // Mark this job as finished with failure  (so the front-end will know to stop polling)
                        this.jobService.updateJobRecordAsFailed(this.jobId, e.getMessage());
                    }
                    finally {
                        cleanup();
                    }
            
                    long endTime = System.currentTimeMillis();
                    logger.debug("FileWorker.call() finished for jobId={} in {} secs", this.jobId,  ((endTime - startTime) / 1000) );
            
                    return null;
                }
            
            
            
                private void processFileWithMultipleThreads() throws Exception {
            
                    final int TOTAL_ACTIVE_THREAD_COUNT = 100;
            
                    // Create a threadpool with a fixed number of threads operating off a shared unbounded queue.
                    ExecutorService executorService = Executors.newFixedThreadPool(TOTAL_ACTIVE_THREAD_COUNT);
                    ExecutorCompletionService<Boolean> completionService = new
            ExecutorCompletionService<>(executorService);
            
            
                    try {
            
                        final int TOTAL_RECORDS_PER_THREAD = 10000;
            
                        int totalRecordsInFileContents = 0;
                        StringBuilder fileContentsForThread = new StringBuilder();
                        int totalThreadsLaunched = 0;
            
                        // Read the temporary file one line at a time.  And, create threads as we go along
                        try (BufferedReader bufferedReader = new BufferedReader(new FileReader(this.tempSourceFile))) {
                            String csvLine;
            
                            // Read the header line  (each chunk needs a header)
                            String headerLine = bufferedReader.readLine();
                            fileContentsForThread.append(headerLine).append("\n");
            
                            while ((csvLine = bufferedReader.readLine()) != null) {
            
                                // Trim any leading/trailing spaces
                                csvLine = csvLine.trim();
            
                                if (StringUtils.isBlank(csvLine)) {
                                    // Skip this empty line
                                    continue;
                                }
            
                                // Append this line to the fileContents StringBuilder object
                                fileContentsForThread.append(csvLine).append("\n");
                                totalRecordsInFileContents++;
            
                                if (totalRecordsInFileContents == TOTAL_RECORDS_PER_THREAD) {
                                    // Create a partial file worker to process this chunk of a file
                                    totalThreadsLaunched++;
                                    logger.debug("Submitting thread number {} to process {} lines", totalThreadsLaunched, totalRecordsInFileContents);
                                    PartialFileWorker partialFileWorker = new PartialFileWorker(fileContentsForThread.toString(),  this.indexName, this.elasticSearchService, this.objectMapper);
            
                                    // Submit the partial file worker to the queue
                                    // NOTE:  If the queue is full, then this will BLOCK and wait for a spot to open
                                    completionService.submit(partialFileWorker);
            
                                    // Clear the fileContents StringBuilder object
                                    fileContentsForThread.setLength(0);
                                    totalRecordsInFileContents = 0;
                                    fileContentsForThread.append(headerLine).append("\n");
                                }
                            } // End of looping through rows in the file
            
                            if (totalRecordsInFileContents > 0) {
                                // Submit a new worker to process this last piece
                                totalThreadsLaunched++;
                                logger.debug("Submitting thread number {} to process {} lines", totalThreadsLaunched, totalRecordsInFileContents);
                                PartialFileWorker partialFileWorker = new PartialFileWorker(fileContentsForThread.toString(),  this.indexName, this.elasticSearchService, this.objectMapper);
            
                                // Submit the partial file worker to the queue
                                // NOTE:  If the queue is full, then this will BLOCK and wait for a spot to open
                                completionService.submit(partialFileWorker);
                            }
            
            
                        } // End of try-with-resources block
            
            
                        // W A I T  	F O R   	A L L  	   T H R E A D S  	T O 	F I N I S H
                        final int totalThreads = totalThreadsLaunched;
                        int totalFailedThreads = 0;
                        int totalSuccessfulThreads = 0;
                        for (int threadNumber=1; threadNumber <= totalThreads; threadNumber++)
                        {
                            try
                            {
                                // Block and Wait for one of the threads to finish
                                Future<Boolean> f = completionService.take();
            
                                // One of the threads has completed
                                Boolean threadSucceeded = f.get();
            
                                if (! threadSucceeded) {
                                    this.jobService.updateJobRecordAsFailed(this.jobId, "One of the threads failed");
            
                                    // Stop here
                                    return;
                                }
            
                                totalSuccessfulThreads++;
                                logger.debug("One thread came back.  totalSuccessfulThreads={}", totalSuccessfulThreads);
            
                                // One of the threads has finished successfully.  So, calculate total percent completed
                                float totalProgressAsFloat =  ( (float) totalSuccessfulThreads / totalThreads) * 100;
                                int totalProgressAsInt = (int) totalProgressAsFloat;
            
                                // Update the job record with the new total percent completed
                                this.jobService.updateJobRecord(this.jobId, JobService.JOB_STATE_WORK_IN_PROGRESS, totalProgressAsInt);
                            }
                            catch (Exception e)
                            {
                                // One of the threads failed
                                logger.error("One thread failed totalFailedThreads=" + totalFailedThreads, e);
            
                                // One of the threads failed
                                this.jobService.updateJobRecordAsFailed(this.jobId, e.getMessage());
            
                                // Stop here
                                return;
                            }
                        } // end of for loop
            
                    }
                    finally {
                        // Gracefully shutdown the executor service
                        // NOTE:  Any running threads will run to completion first
                        logger.debug("Shutting down executor service started");
                        executorService.shutdown();
            
                        // Wait for all of the threads to finish
                        executorService.awaitTermination(10, TimeUnit.MINUTES);
                        logger.debug("Shutting down executor service finished.");
                    }
            
                }
            }


    9. Adjust the ReportController.uploadFile() so it passes-in the ES index name and ElasticSearchService
        a. Edit backend/src/main/com/lessons/controllers/ReportController

        b. Find the fileUpload method

        c. Change the one line that creates the FileWorker object to this:
            
            // Create the worker thread that will process this CSV file in the background
            FileWorker fileWorker = new FileWorker(jobId, "reports",  aMultipartFile.getInputStream(), this.jobService, this.elasticSearchService);
            


            When completed, the ReportController.uploadFile() method should look like this:
            
                /**
                * REST endpoint /api/reports/upload
                * @param aMultipartFile holds uploaded file InputStream and meta data
                * @return the jobId and a 200 status code
                */
                @RequestMapping(value = "/api/reports/upload", method = RequestMethod.POST)
                public ResponseEntity<?> uploadFile(
                        @RequestParam(value = "file", required = true) MultipartFile aMultipartFile) throws Exception {
                    logger.debug("uploadFile() started. ");
            
                    String loggedInUserName = "John Smith";
                    String uploadedFilename = aMultipartFile.getOriginalFilename();
            
                    // Add a record to the jobs table
                    Integer jobId = jobService.addJobRecord(loggedInUserName, uploadedFilename);
            
                    // Create the worker thread that will process this CSV file in the background
                    FileWorker fileWorker = new FileWorker(jobId, "reports",  aMultipartFile.getInputStream(), this.jobService, this.elasticSearchService);
            
                    // Execute the worker thread in the background
                    // NOTE:  This code runs in a separate thread
                    asyncService.submit(fileWorker);
            
                    // Return a response of 200 and the job number
                    return ResponseEntity.status(HttpStatus.OK)
                                        .body(jobId);
                }



    10. Destroy the existing reports mapping in ElasticSearch
        a. Go to your kibana console using http://localhost:5601/app/kibana#/dev_tools/console
        b. In the left side, run this command:

            DELETE reports


    11. Try it out
        a. Activate the Debugger -> Full WebApp     (this will create a new reports mapping on startup)
        b. Go to "Upload Reports"
        c. Browse to docs/large_file.1000000.csv
           -- You should see the progress bar advance


    12. Verify that there are now 1 million records in the report mapping
        a. Go to your kibana console using http://localhost:5601/app/kibana#/dev_tools/console
        b. In the left side, run this command:

            GET /reports/_count

            -- You should see a count of 1 million records



```
