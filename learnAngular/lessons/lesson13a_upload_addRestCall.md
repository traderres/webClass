Lesson 13a:  Upload Report / Add Back-End REST Call
---------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1CSax2jsKaGQfajXse0vXry5CpYXdMjkpQvXSQj1pYV0/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson13a/upload-rest-call
<br>
<br>
<br>

<h3> Problem Set </h3>

Problem:  I need a REST call to process an uploaded file<br>
Solution:  Create a REST call that accepts a file and returns a simple message


<br>
<br>

```

Procedure
---------
    1. Add a new REST endpoint called /api/reports/upload
       NOTE: It won't process the file; it simply returns a message.  

        a. Edit backend/src/main/java/com/lessons/controllers/ReportController.java

        b. Make sure there is a logger at the top:
                
                private static final Logger logger =
                      LoggerFactory.getLogger(ReportController.java);
                
        c. Add this method to it:
                
                /**
                 * REST endpoint /api/reports/upload
                 * @param aMultipartFile
                 * @return
                 */
                @RequestMapping(value = "/api/reports/upload",   method = RequestMethod.POST)
                public ResponseEntity<?> uploadFile(
                     @RequestParam(value = "file", required = true) MultipartFile aMultipartFile)
                {
                    logger.debug("uploadFileWithParams() started. ");
                
                    String uploadedFilename = aMultipartFile.getOriginalFilename();
                    long uploadedFileSize = aMultipartFile.getSize();
                
                    logger.debug("Submitted file name is {}", uploadedFilename );
                    logger.debug("Submitted file is {} bytes",uploadedFileSize );
                
                    // Create a message
                    String returnedMessage = "You uploaded the file called " + 
                    uploadedFilename + " with a size of " + uploadedFileSize + " bytes";
                
                    // Return a text message back to the front-end
                    return ResponseEntity.status(HttpStatus.OK)
                         .contentType(MediaType.TEXT_PLAIN)
                         .body(returnedMessage);
                
                }


    2. Configure SpringBoot's limits on maximum file uploads
        a. Edit the backend/src/main/resources/application.yaml

        b. Add this section to the top:
            
            ##########################################################
            # File Upload Settings
            ##########################################################
            spring.servlet.multipart.enabled: true
            
            # Set the maximum file upload size for one file    (-1 is unlimited)
            spring.servlet.multipart.max-file-size: 300MB
            
            # Set the maximum request size
            # If a user uploads 5 files of 1 MB, then the entire request size is 5 MB   (-1 is unlimited)
            spring.servlet.multipart.max-request-size: 400MB


    3. Startup the back end only in debug mode
        a. Set a breakpoint in your new REST endpoint
        b. Activate the debugger -- but for "Backend" only


    4. Verify your REST endpoint works (using Postman to simulate a file upload)
        a. Startup Postman
        b. Create a new request  (to clear out any headers you might have)
        c. Set the type to POST
        d. Set the url to http://localhost:8080/app1/api/reports/upload

        e. Click on Body -> form-data
            i.   Click in the key field (when it's empty)
            ii.  In the first key row, set the key=file
            iii. Click on the line below
            iv.  Click on the "file" key again -- You should see a "File" dropdown
                 In the value field, press "Select Files"
            v.   Browse and select the file you want to upload -- e.g., something.txt

        f. Press "Send" button
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson13a_image1.png)
```
You should hit your java breakpoint after pressing "Send"


```
