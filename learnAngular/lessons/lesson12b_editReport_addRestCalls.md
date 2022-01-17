Lesson 12b:  Edit Report / Add REST calls to Load & Save Info
-------------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/12pGkWV9MzWczxCX0jV8LbrGWYDGPAg4zkMZB9gUeUjs/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson12b/add-rest-calls
<br>
<br>

<h3>Approach</h3>



A. Create a REST call toset info in the database for one report

   1. Create a back-end SetUpdateReportDTO object (that holds edits to the report)  
        
   2. Create a back-end service that will run the SQL to update the report record  
        
   3. Create a controller method that acts as a REST call to update a report record

      ```
          POST /api/reports/update/set
          {
                  "id":  25,
                  "report_name":  "some report name",
                  "priority":   3 
          }    
      ```

   4. Use Postman to verify that the update-one-report REST call works  
    
     
B. Create a REST call toget info from the database for one report

   1. Create a Back-end GetUpdateReportDTO object (that holds information about the latest report)  

   2. Create a back-end service that executes the SQL to get the info for the "Edit Report" page  
        
   3. Create a controller method that acts as a REST call to get one report  
      **GET /api/reports/update/get/{reportId}**  
        
   4. Use Postman to verify that this get-one-report REST call works  
        


<h3>Notes</h3>

- You already have a DTO object called GetReportDTO (used for the "View Reports" page)
- Donot use the same DTO for multiple REST calls  
  (I know it's tempting -- but it's stupid)
- It is far safer to create different DTO objects for different REST calls  
  - Adding additional DTO objects and additional REST calls is a safer approach  
  - If you change the "View Reports" REST call, then you do not mess-up other code  

<br>
<br>




```

Part 1:  Create the REST call to Set Data for the "Edit Report" page
--------------------------------------------------------------------
     1. Add this class: SetUpdateReportDTO 		(that holds the updates to the report)
        a. Right-click on backend/src/main/java/com/lessons/models -> New Java Class
           Class Name:  SetUpdateReportDTO
 
        b. Add these private fields:
             
             private Integer id;
             
             private Integer priority;
             
             @JsonProperty("report_name")
             private String reportName;
             
             
         c. Generate the getters & setters
             Right-click -> Generate -> Getters & Setters -> Select All
             
             NOTE:  Where you right-click is where the getters & setters are generated
             
 
 
     2. Add two methods to the ReportService  (that will be used by the ReportController.java)
 
         a. Edit ReportService.java
 
         b. Add this method:
             
             /**
              * @param aReportId holds the ID that uniquely identifies thie report in the database
              * @return TRUE if the ID is found in the reports table.  False otherwise.
              */
             public boolean doesReportIdExist(Integer aReportId) {
                if (aReportId == null) {
                        return false;
                }
             
                String sql = "select id from reports where id=?";
                JdbcTemplate jt = new JdbcTemplate(this.dataSource);
                SqlRowSet rs = jt.queryForRowSet(sql, aReportId);
                if (rs.next() ) {
                        // I found the record in the database.  So, return true.
                        return true;
                }
                else {
                        // I did not find this ID in the database.  So, return false.
                        return false;
                }
             }
             
             
         c. Add this method to ReportService.java
             
             /**
              * Update the Report record in the database
              *
              * @param aUpdateReportDTO holds the information from the front-end with new report info
              */
             public void updateReport(SetUpdateReportDTO aUpdateReportDTO) {
                // Construct the SQL to update this record
                String sql = "UPDATE reports set name=:name, priority=:priority WHERE id=:id";
             
                // Create a parameter map
                Map<String, Object> paramMap = new HashMap<>();
                paramMap.put("name",   aUpdateReportDTO.getReportName() );
                paramMap.put("priority", aUpdateReportDTO.getPriority() );
                paramMap.put("id",   	    aUpdateReportDTO.getId() );
             
                // Execute the SQL and get the number of rows affected
                NamedParameterJdbcTemplate np = new
             NamedParameterJdbcTemplate(this.dataSource);
                int rowsUpdated = np.update(sql, paramMap);
             
                if (rowsUpdated != 1) {
                        throw new RuntimeException("I expected to update one report record.  Instead, I
             updated " + rowsUpdated + " records.  This should never happen.");
                }
             }
             
 
 
     3. Add the REST call to the ReportController.java
 
         a. Edit ReportController.java
 
         b. Add this public method:
 
             /**
              * POST /api/reports/update/set
              *
              * Update the Report record in the system
              * @return 200 status code if the update worked
              */
             @RequestMapping(value = "/api/reports/update/set", method = RequestMethod.POST,
                                             produces = "application/json")
             public ResponseEntity<?> updateReport(
                            @RequestBody SetUpdateReportDTO aUpdateReportDTO)  {
                logger.debug("updateReport() started.");
             
                // Verify that required parameters were passed-in
                if (aUpdateReportDTO.getId() == null) {
                        // The report ID was not passed-in
                        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                                .contentType(MediaType.TEXT_PLAIN)
                                .body("The report ID is null.  This is an invalid parameter.");
                }
                else if (StringUtils.isBlank(aUpdateReportDTO.getReportName() )) {
                        // The report name is blank
                        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                                .contentType(MediaType.TEXT_PLAIN)
                                .body("The report name is blank.  This is an invalid parameter.");
                }
                else if (! reportService.doesReportIdExist(aUpdateReportDTO.getId() ) ) {
                        // The report ID was not found in the system
                        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                                .contentType(MediaType.TEXT_PLAIN)
                                .body("The report ID was not found in the system.");
                }
             
                // Update the report record
                reportService.updateReport(aUpdateReportDTO);
             
                // Return only a 200 status code
                return ResponseEntity.status(HttpStatus.OK)
                                    .contentType(MediaType.TEXT_PLAIN)
                                    .body("");
             }
             
     4. Verify that the Update REST call works
         a. Get a report id to update
             i.  Open your database console
             ii. Double-click on your reports table
                 --  Get the ID of a report record to update -- e.g., 1000
 
         b. Startup your Backend debugger
 
         c. Set a breakpoint in the ReportController.updateReport() method
            -- We want to make sure your REST endpoint actually gets hit
 
         d. Startup Postman
             i.  Create a new Request with this information:
 
                 Method:  	POST
                 Url:		http://localhost:8080/app1/api/reports/update/set
 
 
             ii. Click on Headers
                 Key=Accept		Value=application/json
                 Key=Content-Type	Value=application/json
 
             iii. Click on Body 

             iv. Click on Raw
 
                 -- Enter this in the raw body  (I assume that you have a reports record with id=1000)
 
                 {
                    "id":       	   1000,
                    "report_name":  "Updated Report Name",
                    "priority":     3
                 }
                 
 
             v.  Click on "Send"
 
 
         e. Verify that your debugger breakpoint is hit
            Press F9 to continue
 
         f. If your REST call returns a 200 status code then double-click on your reports database table
            -- Verify that your Report record was updated with the new info (you provided in the raw body)
 
 


Part 2:  Create the REST call to Get Data for the "Edit Report" page
-------------------------------------------------------------------- 
     1. Add this class: GetUpdateReportDTO 		(that holds info loaded into the "Edit Report" page)
        a. Right-click on backend/src/main/java/com/lessons/models -> New Java Class
           Class Name:  getUpdateReportDTO
 
        b. Add these private fields:
             
             private Integer id;
             
             private Integer priority;
             
             @JsonProperty("report_name")
             private String reportName;
             
 
         c. Generate the Constructor
            Right-click -> Generate -> Constructor -> select all 3 parameters
 
         d. Generate the getters
            Right-click -> Generate -> Getter -> select all 3 parameters
 
            NOTE:  Where you right-click is where the getters & setters are generated
 
 
     2. Add two methods to the ReportService  (that will be used by the ReportController.java)
 
         a. Edit ReportService.java
 
         b. Add this method:
             
             /**
              * @param aReportId holds the ID that uniquely identifies a report in the database
              * @return GetUpdateReportDTO object that holds information to show in the "Edit Report" page
              */
             public GetUpdateReportDTO getInfoForUpdateReport(Integer aReportId) {
                // Construct the SQL to get information about this record
                String sql = "select name, priority from reports where id=?";
             
                // Execute the SQL, generating a read-only SqlRowSet
                JdbcTemplate jt = new JdbcTemplate(this.dataSource);
                SqlRowSet rs = jt.queryForRowSet(sql, aReportId);
             
                if (! rs.next() ) {
                        throw new RuntimeException("Error in getInfoForUpdateReport():  I did not find any records in the database for this reportId " + aReportId);
                }
             
                // Get the values out of the SqlRowSet object
                String reportName = rs.getString("name");
                Integer priority = (Integer) rs.getObject("priority");
             
                // Build & return the DTO object
                GetUpdateReportDTO dto = new GetUpdateReportDTO(aReportId, 
                                                    priority, reportName);
                return dto;
             }
             
 
     3. Add the REST call to the ReportController.java
 
         a. Edit ReportController.java
 
         b. Add this public method:
 
             /**
              * GET /api/reports/update/get/{reportId}
              *
              * @return JSON holding info about a single report to edit
              */
             @RequestMapping(value = "/api/reports/update/get/{reportId}", method = RequestMethod.GET, produces = "application/json")
             public ResponseEntity<?> getInfoForEditReport(@PathVariable(name="reportId") Integer aReportId)  {
                logger.debug("getInfoForEditReport() started.");
             
                if (! reportService.doesReportIdExist(aReportId ) ) {
                        // The report ID was not found in the system
                        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                                .contentType(MediaType.TEXT_PLAIN)
                                    .body("The report ID was not found in the system.");
                }
             
                // Get information about this report (for the "Edit Report" page)
                GetUpdateReportDTO dto = this.reportService.getInfoForUpdateReport(aReportId);
             
                // Return the object back to the front-end
                // NOTE:  Jackson will convert the list of java objects to JSON for us
                return ResponseEntity.status(HttpStatus.OK).body(dto);
             }
             
 
 
     4. Verify that the Get Edit Report Info REST call works
         a. Get a report id to get info about
             i.  Open your database console
             ii. Double-click on your reports table
                  --  Get the ID of a report record to update -- e.g., 1000
 
         b. Startup your Backend debugger
 
         c. Set a breakpoint in the ReportController.getInfoForEditReport() method
            -- We want to make sure your REST endpoint actually gets hit
 
         d. Startup Postman
             i.  Create a new Request with this information:
 
                 Method:  	GET
                 Url:		http://localhost:8080/app1/api/reports/update/get/1000
 
 
             ii. Click on Headers
                 Key=Accept		Value=application/json
 

             iii. Click on "Send"
 
 
         e. Verify that your debugger breakpoint is hit
            Press F9 to continue
 
         f. If your REST call returns a 200 status code then Postman should return  the same info as in your reports table:
             
             {
                "id": 1000,
                "priority": 3,
                "report_name": "Updated Report Name"
             }
             
             

```
