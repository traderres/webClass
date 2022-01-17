Lesson 13e:  Upload Report / Write Data to ElasticSearch
--------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/10E5C2wJ7qCyzNqDHHJ1qTtW6BTbvvXGwdXAfx4RQOog/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson13e/write-to-es
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem: I want to create a REST endpoint that writes data to ElasticSearch

<br>
<br>
<h3> Assumptions </h3>

- You have ElasticSearch 6.8 or later installed and running
- You have ElasticSearch listening on port 9201

<br>
<br>
<h3> Back-End Design </h3>

1. Add the async-http-client maven dependency  
   (which allows our spring-boot app to make \*OUTGOING\* REST calls)  
     
1. Create an ElasticSearchResources class has the url and the AsyncHttpClient  
   - This is a wrapper DTO that holds two things (the ElasticSearch url and the AsyncHttpClient object)
   - If you have these two things, then java can talk to ElasticSearch

1. Create an ElasticSearchResourcesConfig class

   1. This class will get the es.url from the application.yaml
   2. This class will create a Java Bean that will initialize the ElasticSearchResources on startup

1. Create an ElasticSearchService class that depends on ElasticSearchResources class

   1. This class has the createIndex() method
   2. This class has the bulkUpdate() method  
        
1. Any Java controller method can inject the ElasticSearchService whenever they need to talk to ES


<br>
<br>
ReportController --> depends on ElasticSearchService --> depends on ElasticSearchResources <br><br>

And, the ElasticSearchResources is created upon startup



```

Procedure
---------
    1. Add the AsyncHttpClient dependency to your backend
        a. Edit the backend/pom.xml

        b. Add this dependency:

                <dependency>
                    <!-- AsyncHttpClient Client implementation           --> 
                    <!--    (used to make outgoing REST calls out to ES) -->
                    <groupId>com.ning</groupId>
                    <artifactId>async-http-client</artifactId>
                    <version>1.9.40</version>
                </dependency>

        c. Right-click on the pom.xml -> Maven -> Reload project



    2. Add this to your application.yaml
            
            ###########################################################
            # ElasticSearch Settings
            ##########################################################
            es:
              url: http://localhost:9201
              ssl_enabled: false




    3. Add this class:    ElasticSearchResources
       NOTE:  This class is just a wrapper to hold two things:  The asyncHttpClient and the esUrl
        a. Right-click on backend/src/main/java/com/lessons/config -> New Java Class
           Class name:  ElasticSearchResources

        b. Copy this to your new class:
                
                package com.lessons.config;
                
                import com.ning.http.client.AsyncHttpClient;
                
                
                public class ElasticSearchResources {
                
                    private AsyncHttpClient asyncHttpClient;
                    private String      	elasticSearchUrl;
                
                    // Used for test classes
                    public ElasticSearchResources(String aElasticSearchUrl, AsyncHttpClient asyncHttpClient) {
                     this.elasticSearchUrl = aElasticSearchUrl;
                     this.asyncHttpClient = asyncHttpClient;
                    }
                
                
                    public String getElasticSearchUrl() {
                     return elasticSearchUrl;
                    }
                
                    public AsyncHttpClient getAsyncHttpClient() {
                     return this.asyncHttpClient;
                    }
                }



    4. Add this java class: ElasticSearchResourcesConfig
       NOTE:  This class creates and initializes the ElasticSearchResources class on startup

        a. Right-click on backend/src/main/java/com/lessons/config -> New Java Class
           Class name:  ElasticSearchResourcesConfig

        b. Copy this to your new class
                
                package com.lessons.config;
                
                import com.ning.http.client.AsyncHttpClient;
                import org.springframework.beans.factory.annotation.Value;
                import org.springframework.context.annotation.Bean;
                import org.springframework.context.annotation.Configuration;
                
                @Configuration
                public class ElasticSearchResourcesConfig {
                
                    @Value("${es.url:}")
                    private String elasticSearchUrl;
                
                    @Bean
                    public ElasticSearchResources elasticSearchResources() {
                     // Create a new AsyncHttpClient object
                     com.ning.http.client.AsyncHttpClientConfig.Builder configBuilder = new
                com.ning.http.client.AsyncHttpClientConfig.Builder();
                
                     configBuilder.setReadTimeout(-1);
                     configBuilder.setAcceptAnyCertificate(true);
                     configBuilder.setFollowRedirect(true);
                     com.ning.http.client.AsyncHttpClientConfig config = configBuilder.build();
                     AsyncHttpClient asyncHttpClient = new AsyncHttpClient(config);
                
                     // Store the AsyncHttpClient and elasticSearch url in the ElasticSearchResources object
                     // NOTE:  THe elastic search url is injected from the application.yaml
                     //    	The AsyncHttpClient is constructed with java code
                     ElasticSearchResources elasticSearchResources = new
                ElasticSearchResources(this.elasticSearchUrl, asyncHttpClient);
                
                     // Return a spring bean that holds the AsyncHttpClient and elasticsearch url
                     return elasticSearchResources;
                    }
                }


    5. Add this class:  ErrorsDTO
        a. Right-click on backend/src/main/java/com/lessons -> New Package
           Package Name: models

        b. Right-click on backend/src/main/java/com/lessons/models -> New Java Class
           Class Name:  ErrorsDTO

        c. Copy this to your new class:
                
                package com.lessons.models;
                
                import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
                
                // Tell Jackson to ignore the "took" and "items" fields
                @JsonIgnoreProperties(value = { "took", "items" })   
                public class ErrorsDTO {
                    private boolean errors;
                
                    public boolean isErrors() {
                            return errors;
                    }
                
                    public void setErrors(boolean errors) {
                            this.errors = errors;
                    }
                }


    6. Add this class:  ElasticSearchService
        a. Right-click on backend/src/main/java/com/lessons/ -> New Package
           Package Name:  services

        b. Right-click on services -> New Java Class
           Class Name:  ElasticSearchService

        c. Copy this to your new class:
            
            package com.lessons.services;
            
            import com.lessons.config.ElasticSearchResources;
            import com.ning.http.client.AsyncHttpClient;
            import com.ning.http.client.Response;
            import org.apache.commons.lang3.StringUtils;
            import org.slf4j.Logger;
            import org.slf4j.LoggerFactory;
            import org.springframework.stereotype.Service;
            import org.springframework.util.StreamUtils;
            
            import javax.annotation.PostConstruct;
            import javax.annotation.Resource;
            import java.io.InputStream;
            import java.nio.charset.StandardCharsets;
            
            @Service("com.lessons.services.ElasticSearchService")
            public class ElasticSearchService {
            
                private static final Logger logger = LoggerFactory.getLogger(ElasticSearchService.class);
            
                @Resource
                private ElasticSearchResources elasticSearchResources;
            
                private String elasticSearchUrl;
                private AsyncHttpClient asyncHttpClient;
                private ObjectMapper objectMapper;
                private final int ES_REQUEST_TIMEOUT_IN_MILLISECS = 90000; 
                
                @PostConstruct
                public void init() {
                        logger.debug("init() started.");
            
                        // In order to make outgoing calls to ElasticSearch you need 2 things:
                        //   1) The elastic search url -- e.g., "http://localhost:9201"
                        //   2) The initialized AsyncHttpClient object
                        this.elasticSearchUrl = elasticSearchResources.getElasticSearchUrl();
                        this.asyncHttpClient = elasticSearchResources.getAsyncHttpClient();
            
                    this.objectMapper = new ObjectMapper();
            
                        logger.debug("init() finished.  elasticSearchUrl={}", this.elasticSearchUrl);
                }
            
                /**
                * Helper to read an entire file into a String -- handy for reading in JSON mapping files
                * @param aFilename holds the name of the file (found in /src/main/resources
                * @return the file's contents as a String
                * @throws Exception if there are problems reading from the file
                */
                public String readInternalFileIntoString(String aFilename) throws Exception {
                       try (InputStream inputStream =  ElasticSearchService.class.getResourceAsStream("/" +
            aFilename)) {
                           return StreamUtils.copyToString(inputStream, StandardCharsets.UTF_8);
                      }
                }
            
                /**
                * Create a new ES Index
                * @param aIndexName holds the name of the new index to create
                * @param aJsonMapping holds the mapping of this index
                * @throws Exception if something bad happens
                */
                public void createIndex(String aIndexName, String aJsonMapping) throws Exception {
                    logger.debug("createIndex() started.  aIndexName={}", aIndexName);
            
                    if (StringUtils.isEmpty(aIndexName)) {
                        throw new RuntimeException("The passed-in aIndexName is null or empty.");
                    }
            
                    String url = this.elasticSearchUrl + "/" + aIndexName;
                    logger.debug("Going to this url:  {}", url);
            
                    // Make a synchronous POST call to ElasticSearch to create this an index
                    Response response = this.asyncHttpClient.preparePut(url)
                            .setRequestTimeout(this.ES_REQUEST_TIMEOUT_IN_MILLISECS)
                            .setHeader("accept", "application/json")
                            .setHeader("Content-Type", "application/json")
                            .setBody(aJsonMapping)
                            .execute()
                            .get();
            
                    if (response.getStatusCode() != 200) {
                        // ElasticSearch returned a non-200 status response
                        throw new RuntimeException("Error in createIndex:  ES returned a status code of " +
            response.getStatusCode() + " with an error of: " + response.getResponseBody());
                    }
            
                    logger.info("Successfully created this ES index: {}", aIndexName);
                }
            
                /**
                * Do a bulk update within ES
                * @param aBulkUpdateJson Holds the JSON bulk string
                * @param aWaitForRefresh Holds TRUE if we will wait for a refresh
                * @throws Exception if something bad happens
                */
                public void bulkUpdate(String aBulkUpdateJson, boolean aWaitForRefresh) throws 
            Exception {
                    if (StringUtils.isEmpty(aBulkUpdateJson)) {
                        throw new RuntimeException("The passed-in JSON is null or empty.");
                    }
            
                    String url = this.elasticSearchUrl + "/_bulk";
                    if (aWaitForRefresh) {
                        url = url + "?refresh=wait_for";
                    }
            
                    // Make a synchronous POST call to do a bulk-index request
                    Response response = this.asyncHttpClient.preparePost(url)
                            .setRequestTimeout(this.ES_REQUEST_TIMEOUT_IN_MILLISECS)
                            .setHeader("accept", "application/json")
                            .setHeader("Content-Type", "application/json")
                            .setBody(aBulkUpdateJson)
                            .execute()
                            .get();
            
                    if (response.getStatusCode() != 200) {
                            // ElasticSearch returned a non-200 status response
                            throw new RuntimeException("Error in bulkUpdate:  ES returned a status code of " + response.getStatusCode() + " with an error of: " + response.getResponseBody()); 
                    }
            
                    // Examine the JSON response to see if the errors="true" flag was set
                    //  1. Convert the response JSON string into an errorsDto object
                    //  2. Look at the errorsDTO object.isErrors() method
                    // 	NOTE:  This is substantially faster as the ErrorDTO tells Jackson to ignore the other fields
                    String jsonResponse = response.getResponseBody();
                    ErrorsDTO errorsDTO = objectMapper.readValue(jsonResponse, ErrorsDTO.class);
            
                    if (errorsDTO.isErrors()) {
                            // ElasticSearch returned a 200 response, but the bulk update failed
                            logger.error("Error in bulkUpdate:  ES returned a status code of {} with an error of {}", response.getStatusCode(), response.getResponseBody());
                            throw new RuntimeException("Error in bulkUpdate:  ES returned a status code of " + response.getStatusCode() + " with an error of: " + response.getResponseBody());
                    }
            
                }
            
                /**
                * Delete the index from ElasticSearch
                * @param aIndexName  holds the index name (or alias name)
                */
                public void deleteIndex(String aIndexName) throws Exception {
                    if (StringUtils.isEmpty(aIndexName)) {
                        throw new RuntimeException("The passed-in aIndexName is null or empty.");
                    }
            
                    // Make a synchronous POST call to delete this ES Index
                    Response response = this.asyncHttpClient.prepareDelete(this.elasticSearchUrl + "/" + aIndexName)
                            .setRequestTimeout(this.ES_REQUEST_TIMEOUT_IN_MILLISECS)
                            .setHeader("accept", "application/json")
                            .setHeader("Content-Type", "application/json")
                            .execute()
                            .get();
            
                    if (response.getStatusCode() != 200) {
                        // ElasticSearch returned a non-200 status response
                        throw new RuntimeException("Error in deleteIndex:  ES returned a status code of " +
            response.getStatusCode() + " with an error of: " + response.getResponseBody());
                    }
                 }
            
            
            
                /**
                * Helper method to determine if the passed-in ES mapping name or alias exists
                * @param aIndexName holds the ES mapping name or alias
                * @return TRUE if the passed-in index or alias exists
                */
                public boolean doesIndexExist(String aIndexName) throws Exception {
            
                    if (StringUtils.isEmpty(aIndexName)) {
                        throw new RuntimeException("The passed-in aIndexName is null or empty.");
                    }
            
                    // Make a synchronous GET call to get a list of all index names
                    Response response = this.asyncHttpClient.prepareGet(this.elasticSearchUrl + "/_cat/indices")
                            .setRequestTimeout(this.ES_REQUEST_TIMEOUT_IN_MILLISECS)
                            .setHeader("accept", "text/plain")
                            .execute()
                            .get();
            
                    if (response.getStatusCode() != 200) {
                        throw new RuntimeException("Critical error in doesIndexExist():  ElasticSearch returned a response status code of " +
                                response.getStatusCode() + ".  Response message is " + response.getResponseBody() );
                    }
            
                    // Loop through the lines of data -- looking for the passed-in index name
                    String linesOfInfo = response.getResponseBody();
                    if (StringUtils.isNotEmpty(linesOfInfo)) {
                        String[] lines = linesOfInfo.split("\n");
            
                        for (String line : lines) {
                            String[] indexParts = line.split(" ");
                            if (indexParts.length >= 3) {
                                String actualIndexName = indexParts[2];
            
                                if (actualIndexName.equalsIgnoreCase(aIndexName)) {
                                    logger.debug("doesIndexExist() returns true for {}", aIndexName);
                                    return true;
                                }
                            }
                        }
                    }
            
                    // The index name was not found in the system.  So, return false
                    return false;
            
               }  // end of doesIndexExist()
            
            
            }


    7. Inject the ElasticSearchService into your ReportController
        a. Edit ReportController.java

        b. Inject the ElasticSearchService into the ReportController by adding this to the top of the class:
        
            @Resource
            private ElasticSearchService elasticSearchService;



    8. Add this file:  reports.mapping.json
       ASSUMPTION:  You are running ES 6.8 or later
        a. Right-click on backend/src/main/resources -> New File
           File name:  reports.mapping.json

        b. Copy this to your reports.mapping.json
            
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
                        "ignore_malformed": false
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
            
            




    9. Edit ReportContoller.java and add the createMapping() REST endpoint
       NOTE:  This REST endpoint will allow the front-end to create the index
        
        /**
          * REST endpoint /api/mapping/create
          *
          * This REST endpoint will create the ES mapping
          * @return a ResponseEntity object that holds a 200 status code and a basic string message
          * @throws Exception if something bad happens
          */
        @RequestMapping(value = "/api/mapping/create", method = RequestMethod.GET, produces = "application/json")
        public ResponseEntity<?> createMapping() throws Exception {
        
            logger.debug("createMapping() started.");
        
            // Read the mapping file into a large string
            String reportsMappingAsJson =
        elasticSearchService.readInternalFileIntoString("reports.mapping.json");
        
            // Create a mapping in ElasticSearch
            elasticSearchService.createIndex("reports" , reportsMappingAsJson);
        
            // Return a simple message back to the front-end as a string
            return ResponseEntity
                    .status(HttpStatus.OK)
                    .contentType(MediaType.TEXT_PLAIN)
                    .body("Successfully Created the mapping reports");
        }



    10. Edit ReportContoller.java and add the addRecords() REST endpoint
        NOTE:  This REST endpoint will allow the front-end to add records to the index 
        
        /**
         * REST endpoint /api/mapping/add
         *
         * @return ResponseEntity object that holds a 200 status code and a basic string message
         * @throws Exception if something bad happens
         */
        @RequestMapping(value = "/api/mapping/add", method = RequestMethod.GET, produces = "application/json")
        public ResponseEntity<?> addRecords() throws Exception {
        
            logger.debug("addRecords() started.");
        
            // Construct the JSON for a bulk update
            // NOTE:  You must have the \n at the end of each data line (including the last one)
            String jsonBulkInsert = "" +
          "{ \"index\": { \"_index\": \"reports\" }}\n" +
          "{ \"priority\": \"low\", \"description\": \"he really likes o'reilly\"}\n" +
          "{ \"index\": { \"_index\": \"reports\"  }}\n" +
          "{ \"priority\": \"LOW\",  \"description\": \"depending on the kind query, you might want to go different ways with it\"}\n";
        
        
            // Add 2 records to the Reports mapping and *wait* for ES to refresh
            elasticSearchService.bulkUpdate(jsonBulkInsert, true);
        
            // Return a simple message back to the front-end
            return ResponseEntity
                    .status(HttpStatus.OK)
                    .contentType(MediaType.TEXT_PLAIN)
                    .body("Successfully added some records.  Here is what was added:  " + jsonBulkInsert);
        }
        

    11. Edit ReportController.java and have your uploadFile() add records

        Change your uploadFile() method to this: 
            
            /**
             * REST endpoint /api/reports/upload
             * @param aMultipartFile
             * @return
             */
            @RequestMapping(value = "/api/reports/upload", method = RequestMethod.POST)
            public ResponseEntity<?> uploadFile(
                    @RequestParam(value = "file", required = true) MultipartFile aMultipartFile) throws Exception
            {
                logger.debug("uploadFileWithParams() started. ");
            
                String uploadedFilename = aMultipartFile.getOriginalFilename();
                long uploadedFileSize = aMultipartFile.getSize();
            
                logger.debug("Submitted file name is {}", uploadedFilename );
                logger.debug("Submitted file is {} bytes",uploadedFileSize );
            
            
                // Construct the JSON for a bulk update
                // NOTE:  You must have the \n at the end of each data line (including the last one)
                String jsonBulkInsert = "" +
                        "{ \"index\": { \"_index\": \"reports\" }}\n" +
                        "{ \"priority\": \"low\", \"description\": \"he really likes o'reilly\"}\n" +
                        "{ \"index\": { \"_index\": \"reports\" }}\n" +
                        "{ \"priority\": \"LOW\",  \"description\": \"depending on the kind query, you might want to go different ways with it\"}\n";
            
                // Add 2 records to the Reports mapping and *wait* for ES to refresh
                elasticSearchService.bulkUpdate(jsonBulkInsert, true);
            
                // Return a message back to the front-end
                String returnedMessage = "You uploaded the file called " + uploadedFilename + " with a size of " + uploadedFileSize + " bytes";
            
                return ResponseEntity.status(HttpStatus.OK)
                        .contentType(MediaType.TEXT_PLAIN)
                        .body(returnedMessage);
            }



    12. Use the Backend to create and add records
        a. Activate the Backend

        b. Invoke a rest call (or use a browser) to get to http://localhost:8080/app1/api/mapping/create
           -- To create the index in ElasticSearch

        c. Verify that the ES index was created
            i.   Connect to kibana at http://localhost:5601
            ii.  Connect to DevTools
            iii. Connect to the Console
            *OR*
            Go to http://localhost:5601/app/kibana#/dev_tools/console

            iv.  Enter this in the console (on the left side)
                    GET _cat/indices

                Press the Play button or Control-Enter
                -- You should see the "reports" index

        d. Invoke a rest call (or use a browser to connect to http://localhost:8080/app1/api/mapping/add
           -- To add records to ElasticSearch

        e. Verify that the data was added to the ES index
            i.   Connect to kibana at http://localhost:5601
            ii.  Connect to DevTools
            iii. Connect to the Console
            iv.  Enter this in the console (on the left side)
                    GET reports/_search  

                 Press the Play button or Control-Enter
                 -- You should see the 2 records you added

    13. Stop the backend debugger


    14. Activate the debugger for "Full WebApp"
        a. Connect to the webapp at http://localhost:4200
        b. Go to the "Upload Report" page
        c. Press "Select File to Upload"
        d. Browse to a file
        e. Press "Upload File"
           -- This should call your ReportController.uploadFile()
           -- And, this should add 2 records to ElasticSearch

        f. Verify that the data was added to the ES index
            i.   Connect to kibana at http://localhost:5601
            ii.  Connect to DevTools
            iii. Connect to the Console
            iv.  Enter this in the console (on the left side)
                    GET reports/_search  

                 Press the Play button or Control-Enter
                 -- You should see the 2 additional records you added


```
