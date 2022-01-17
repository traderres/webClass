Lesson 11a:  View Reports / Add REST Call
-----------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1f5eFXe1KzAvu9lzRb2HLBfsW12q0-SG_9rTnCw4EcWU/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson11a/view-reports-add-rest-call
<br>
<br>


<h3>Approach</h3>
- Create GetReportDTO.java (that holds information passed to the front-end)

- Create this method: ReportService.getAllReports() that runs SQL query

- Create this method: ReportController.getAllReports() with the REST call mapping  
    GET /api/reports/all  
    Returns a List of GetReportDTO objects  

- Use Postman to verify the REST call works

<br>
<br>

```

Procedure
--------- 
    1. Add this class:  GetReportDTO.java
       a. Right-click on backend/src/main/java/com/lessons/models -> New Class
          Class Name:  GetReportDTO


       b. Add these 5 private variables:
            private Integer id;
            private String  name;
            private String priority;
        
            @JsonProperty("start_date")
            private String  startDate;
        
            @JsonProperty("end_date")
            private String  endDate;


        c. Generate the getters & setters
           Right-click on a spot where you want the getters to appear -> Generate -> Getters & Setters


        d. When finished, the GetReportDTO class should look like this:
            
            package com.lessons.models;
            
            import com.fasterxml.jackson.annotation.JsonProperty;
            
            public class GetReportDTO {
                private Integer id;
                private String  name;
                private String priority;
            
                @JsonProperty("start_date")
                private String  startDate;
            
                @JsonProperty("end_date")
                private String  endDate;
            
                public Integer getId() {
                    return id;
                }
            
                public void setId(Integer id) {
                    this.id = id;
                }
            
                public String getName() {
                    return name;
                }
            
                public void setName(String name) {
                    this.name = name;
                }
            
                public String getPriority() {
                    return priority;
                }
            
                public void setPriority(String priority) {
                    this.priority = priority;
                }
            
                public String getStartDate() {
                    return startDate;
                }
            
                public void setStartDate(String startDate) {
                    this.startDate = startDate;
                }
            
                public String getEndDate() {
                    return endDate;
                }
            
                public void setEndDate(String endDate) {
                    this.endDate = endDate;
                }
            }
            




    2. Add a new method to ReportService.java
        a. Edit ReportService.java

        b. Add this method:
            
            /**
             * @return a List of all Reports (as a list of GetReportDTO objects)
             */
            public List<GetReportDTO> getAllReports() {
                    // Construct the SQL to get all reports
                    String sql =
                     "select r.id, r.name, l.name as priority, " +
                                    "to_char(start_date, 'mm/dd/yyyy') as start_date, to_char(end_date, 'mm/dd/yyyy') as end_date " +
                                "from reports r " +
                                "LEFT JOIN lookup l on (r.priority = l.id) " +
                                "order by id";
            
                    // Use the rowMapper to convert the results into a list of GetReportDTO objects
                    BeanPropertyRowMapper<GetReportDTO> rowMapper = new
            BeanPropertyRowMapper<>(GetReportDTO.class);
            
                    // Execute the SQL and Convert the results into a list of GetReportDTO objects
                    JdbcTemplate jt = new JdbcTemplate(this.dataSource);
                    List<GetReportDTO> listOfReports = jt.query(sql, rowMapper);
            
                    // Return the list of GetReportDTO objects
                    return listOfReports;
            }


    3. Add a new REST endpoint to your ReportController.java 
        a. Edit ReportController.java

        b. Add this method
            
            /**
             * GET /api/reports/all
             *
             * @return JSON holding a list of report objects and a 200 status code
             */
            @RequestMapping(value = "/api/reports/all", method = RequestMethod.GET,
                                             produces = "application/json")
            public ResponseEntity<?> getAllReports()  {
                logger.debug("getAllReports() started.");
            
                // Adding a report record to the system
                List<GetReportDTO> listOfReports = reportService.getAllReports();
            
                // Return the list of report objects back to the front-end
                // NOTE:  Jackson will convert the list of java objects to JSON for us
                return ResponseEntity.status(HttpStatus.OK).body(listOfReports);
            }


    4. Verify the REST endpoint works
        a. Start Postman

        b. Add a new request with these settings:
           GET http://localhost:8080/app1/api/reports/all

           Headers:
                Accept=application/json


        c. Add a breakpoint in your ReportController.getAllReports() method

        d. Press "Send"
           -- You should hit your breakpoint
           -- Press F9 to continue

        e. You should get SOMETHING like this back in your Postman response window
           For example, if you have 3 records in your REPORTS table, then you get 3 maps back:
        
        [
            {
                "id": 1,
                "name": "Report 1",
                "priority": "low",
                "start_date": null,
                "end_date": null
            },
            {
                "id": 2,
                "name": "Report 2",
                "priority": "medium",
                "start_date": null,
                "end_date": null
            },
            {
                "id": 3,
                "name": "Report 3",
                "priority": "high",
                "start_date": null,
                "end_date": null
            }
        ]


```
