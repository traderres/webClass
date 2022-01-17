Lesson 10a:  Saving Data / Create REST Call
-------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1crOKwu0MUo6ApSU-iRFu6homP33USA9i1doVpxrFE4o/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson10a/create-rest-call
<br>
<br>

Problem: Need a REST call that will take the report data and save it to the database

Solution: Create a database table, create a DTO to hold the passed-in data, run SQL to save the data

  

<br>
<br>
<h3>Approach</h3>

1. Use flyway to add a reports tableDefines the new database table
1. Add a AddReportDTO objectHolds information passed-in from front-end
1. Add a ReportController to the backendActs as the REST endpoint
1. Add a ReportServiceRuns the SQL to insert a record
1. Add a DatabaseServiceGenerate the unique report ID



```

Procedure
---------
    1. Add a Reports table to the database by adding this file:  V1.3__reports.sql
        a. Right-click on backend/src/main/resources/db/migration -> New File
           Filename:  V1.3__reports.sql

           NOTE:  YOU CANNOT HAVE ANY LEADING SPACES in the FILE NAME

        b. Copy this to your newly-created SQL script

            --------------------------------------------------------------
            -- Filename:  V1.3__reports.sql
            --------------------------------------------------------------
        
            -- Create this table:  reports
            drop table if exists reports;
            create table reports
            (
                id            	integer      not null,
                version       	integer      not null,
                name          	varchar(256) not null,
                priority      	integer      null,
                start_date    	timestamp    null,
                end_date      	timestamp    null,
                primary key (id),
                constraint lookup_priority foreign key(priority) references  lookup(id)
            );
            comment on table reports      is 'This table holds all of the report metadata.';
            comment on column reports.id   is 'Uniquely identifies this report';
        

        c. Migrate the database to version 1.3
           unix> cd ~/intellijProjects/angularApp1/backend
           unix> mvn flyway:migrate


    2. Add  this class:  AddReportDTO
       a. Right-click on backend/src/main/java/com/lessons/models -> New Java Class
          Class Name:  AddReportDTO      

       b. Copy this to your newly-created class
            
            package com.lessons.models;
            
            import com.fasterxml.jackson.annotation.JsonProperty;
            import java.sql.Timestamp;
            import java.util.List;
            
            public class AddReportDTO {
                private String name;
                private Integer priority;
                private List<Integer> authors;
            
                @JsonProperty("start_date")
                @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "MM/dd/yyyy")
                private Timestamp startDate;
            
                @JsonProperty("end_date")
                @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "MM/dd/yyyy")
                private Timestamp endDate;
            }


        c. Generate your getters and setters (for the AddReportDTO class)
           -- Right-click where you want the getters to appear -> Generate -> Getters & Setters


        d. When finished, your AddReportDTO class should look like this:
            package com.lessons.models;
        
            import com.fasterxml.jackson.annotation.JsonFormat;
            import com.fasterxml.jackson.annotation.JsonProperty;
            import java.sql.Timestamp;
            import java.util.List;
        
            public class AddReportDTO {
                private String name;
                private Integer priority;
                private List<Integer> authors;
        
                @JsonProperty("start_date")
                @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "MM/dd/yyyy")
                private Timestamp startDate;
        
                @JsonProperty("end_date")
                @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "MM/dd/yyyy")
                private Timestamp endDate;
        
                public String getName() {
                    return name;
                }
        
                public void setName(String name) {
                    this.name = name;
                }
        
                public Integer getPriority() {
                    return priority;
                }
        
                public void setPriority(Integer priority) {
                    this.priority = priority;
                }
        
                public List<Integer> getAuthors() {
                    return authors;
                }
        
                public void setAuthors(List<Integer> authors) {
                    this.authors = authors;
                }
        
                public Timestamp getStartDate() {
                    return startDate;
                }
        
                public void setStartDate(Timestamp startDate) {
                    this.startDate = startDate;
                }
        
                public Timestamp getEndDate() {
                    return endDate;
                }
        
                public void setEndDate(Timestamp endDate) {
                    this.endDate = endDate;
                }
                }
		

    3. Add this class:   DatabaseService.java
       a. Right-click on backend/src/main/java/com/lessons/services -> New Java Class
          class name:  DatabaseService

       b. Copy this to your newly-created class 
            package com.lessons.services;
        
            import org.springframework.jdbc.core.JdbcTemplate;
            import org.springframework.stereotype.Service;
            import javax.annotation.Resource;
            import javax.sql.DataSource;
        
            @Service("com.lessons.services.DatabaseService")
            public class DatabaseService {
        
                @Resource
                private DataSource dataSource;
        
                public Integer getNextId() {
                    String sql = "select nextval('seq_table_ids')";
                    JdbcTemplate jt = new JdbcTemplate(this.dataSource);
                    Integer nextId = jt.queryForObject(sql, Integer.class);
                    return nextId;
                }
        
        
                public Integer getStartingVersionValue() {
                    return 1;
                }
            }


    4. Add class:  ReportService.java
       a. Right-click on backend/src/main/java/com/lessons/services -> New Java Class
          class name:  ReportService

       b. Copy this to your newly-created class
        
            package com.lessons.services;
        
            import com.lessons.models.AddReportDTO;
            import org.slf4j.Logger;
            import org.slf4j.LoggerFactory;
            import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
            import org.springframework.stereotype.Service;
        
            import javax.annotation.Resource;
            import javax.sql.DataSource;
            import java.util.HashMap;
            import java.util.Map;
        
            @Service("com.lessons.services.ReportService")
            public class ReportService {
        
                    private static final Logger logger = LoggerFactory.getLogger(ReportService.class);
        
                @Resource
                private DataSource dataSource;
        
                @Resource
                private DatabaseService databaseService;
        
        
                /**
                 * Attempt to add a report record to the database
                 *
                 * @param addReportDTO  Pass-in model object that holds all of the report fields
                 */
                public void addReport(AddReportDTO addReportDTO) {
                    logger.debug("addReport() started.");
        
                    String sql = "insert into reports(id, version, name, priority, start_date, end_date) " +
                                 "values(:id, :version, :name, :priority, :start_date, :end_date)";
        
                    Map<String, Object> paramMap = new HashMap<>();
                    paramMap.put("id", databaseService.getNextId() );
                    paramMap.put("version", databaseService.getStartingVersionValue());
                    paramMap.put("name", addReportDTO.getName());
                    paramMap.put("priority", addReportDTO.getPriority());
                    paramMap.put("start_date",addReportDTO.getStartDate());
                    paramMap.put("end_date", addReportDTO.getEndDate());
        
                    NamedParameterJdbcTemplate np = new NamedParameterJdbcTemplate(this.dataSource);
        
                    // Execute the SQL
                    int rowsCreated = np.update(sql, paramMap);
        
                    if (rowsCreated != 1) {
                        throw new RuntimeException("Critical error in addReport():  I expected to create one database record, but did not.");
                    }
        
                    logger.debug("addReport() finished.");
                }
            }


    5. Add this class:   ReportController.java
       a. Right-click on backend/src/main/java/com/lessons/controllers -> New Java Class
          class name:  ReportController

       b. Copy this to your newly-created class
        
            package com.lessons.controllers;
        
            import com.lessons.models.AddReportDTO;
            import com.lessons.services.ReportService;
            import org.slf4j.Logger;
            import org.slf4j.LoggerFactory;
            import org.springframework.http.HttpStatus;
            import org.springframework.http.ResponseEntity;
            import org.springframework.stereotype.Controller;
            import org.springframework.web.bind.annotation.RequestBody;
            import org.springframework.web.bind.annotation.RequestMapping;
            import org.springframework.web.bind.annotation.RequestMethod;
        
            import javax.annotation.Resource;
        
            @Controller("com.lessons.controllers.ReportController")
            public class ReportController {
                 private static final Logger logger = LoggerFactory.getLogger(ReportController.class);
        
                @Resource
                private ReportService reportService;
        
                /*************************************************************************
                 * POST /api/reports/add
                 * Add a Report record to the system
                 * @return nothing
                 *************************************************************************/
                @RequestMapping(value = "/api/reports/add", method = RequestMethod.POST, 
                                                       produces = "application/json")
                public ResponseEntity<?> addReport(@RequestBody AddReportDTO 
                                        aAddReportDTO) throws Exception {
                    logger.debug("addReport() started.");
        
                    // Adding a report record to the system
                    reportService.addReport(aAddReportDTO);
        
        
                    // Return a response code of 200
                    return ResponseEntity.status(HttpStatus.OK).body("");			
                }
            }


    6. Verify it works
        a. Startup your backend

        b. Set a breakpoint in your ReportController.addReport()

        c. Startup Postman
            i.  Create a new Request 
                TYPE:  POST
                URL:   http://localhost:8080/app1/api/reports/add

            ii. Click on Headers
                Key=Accept    		Value=application/json
                Key=Content-Type 	Value=application/json

            iii. Click on Body -> Raw
                 Type-in this in the text-box

                    {
                            "name":   "report 1",
                        "start_date": "02/14/2021",
                        "end_date": "12/31/2021"
                    }

            iv. Press "Send"

        d. You should reach your breakpoint

        e. Step through your code and make sure it works
            
           If the REST call is successful, it will return a 200 status code only
           If the REST call is successful, you should see the record in your reports table

        f. Open your database console and run this SQL
                SELECT * From Reports

        -- You should see the new reports record



```
