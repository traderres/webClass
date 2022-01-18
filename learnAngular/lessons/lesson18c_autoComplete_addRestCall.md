Lesson 18c:  Auto-Complete / Add REST Call
------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1GlU8gNuFSE8z1fnr5oqwSWdvy5G4d_7PDwcK7lQ2VJY/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson18c/autocomplete/add-rest-call
<br>
<br>
<br>

<h3> Design Decision:  What is being auto-completed? </h3>

- Approach 1: Auto-complete on the user's <b>search criteria</b><br>
  NOTE: This requires tracking the user's searches (Google does this)  
  Keep track of user's searches and auto-complete based on what the user has searched for  

- Approach 2: Auto-complete on <b>search results</b> -- e.g., data that exists in ElasticSearch  
    
  - Approach 2a: Auto-complete on asingle field in ElasticSearch (that we already have)  
    User types-in "64"  
    The auto-complete shows  
    "Report 64"  
    "Report 164"  
    "Report 264"  
    "Report 1664"  
    "Report 2664"  

  - Approach 2b: Auto-complete onmultiple fields in ElasticSearch (that we already have)  
    User types-in <b>"o'rei"</b>  
    The auto-complete shows  
    "Report 64"    \[These records have O'reilly in the description]  
    "Report 164"  
    "Report 264"  
    "Report 1664"  
    "Report 2664"
    
<br>
<br>

<h3>Approach</h3>

1. Create a REST call with this contract
   ```
       POST /api/search/autocomplete
           {
              "index_name":     "reports",
              "returned_field":     "display_name",
              "searched_field":     "display_name.filtered",
              "raw_query":          "64",
              "size":               5
           }
    ```

1. This REST call returns a list of (matching) strings


<br>
<br>
<h3> Auto-Complete Implementations with ElasticSearch </h3>

- Use prefix query
  - Matching is supported only at the <b>beginning</b> of the term. One cannot match the query in the middle of the text
  - Not optimized for large data set
  - Since this is a query, duplicate results won't be filtered out  
    (workaround is to use an aggregate query to group results and then filter the results)  
<br>
<br>
      
- Use ngrams
  - This approach uses different analyzers at index and search time
  - When indexing, a custom analyzer with an edge n-gram filter is applied.
  - At search time, standard analyzer can be applied
  - (Good) <b>Matches any character</b> (including spaces and special punctuation)
  - (Bad) Makes the ES index use more disk space (but disk space is cheap)  
<br>
<br>    
      
- Use Completion Suggester
  - ElasticSearch comes with a built-in solution called the Completion Suggester
  - NOTE: The auto-completed fields have type="completion" in the mapping
  - Storing all of the terms in lowercase helps in the case-insensitive match
  - (Bad) Matching always starts at the <b>beginning</b> of the text.
  - (Bad) No sorting mechanism is available. The only way to sort suggestions is via weights  
    This creates a problem when any custom sorting like alphabetical sort or sort by context is required)



<br>
<br>
<h3> Author's Opinions </h3>

- When in doubt, do an auto-complete on a *SINGLE* field.  
- I like using the ngram approach as it matches anywhere in the string
- In our case, we already have an ngram on the display_name.filtered field.  So, we'll use that.
- The user can type-in any part of a report.display_name and the entire display name will appear in the auto-complete.


<br>
<br>
<h3> Example ElasticSearch queries on ngram fields </h3>

- Ngram search on a *SINGLE* field
  ```
  # Ngram search on a single field
  # Search all report display_name which contain a 10
  POST /reports/_search
      {
          "query": {
              "term": {
                 "display_name.filtered": "10"
              }
          },
          "size": 5
      }       
  ```
<br>
<br>

- Ngram search on *MULTIPLE* fiel
  ```
  # Ngram search on *MULTIPLE* fields
  # Search all report names and descriptions which contain a o'rei
  POST /reports/_search
  {
    "query":{
      "multi_match":{
        "query":"o'rei",
        "fields":[
              "display_name.filtered",
              "description.filtered"
        ],
        "type":"best_fields",
        "minimum_should_match": "90%"
      }
    },
    "size":5
  }
  ```
  
  
<br>
<br>

```
Exercise 1:  Simulate running an auto-complete query on the display name
------------------------------------------------------------------------
ASSUMPTION:  You still have the 1 million report records in your ElasticSearch reports index
    1. Connect to your kibana console
       http://localhost:5601/app/kibana#/dev_tools/console


    2. Enter this search to see how many records are in your reports mapping
       <Press Control-Enter> to run the search

	        # Get the total number of records in report
	        GET /reports/_count



    3. Run an ngram search on the string "<space>64"

            # Ngram search on a *SINGLE* field
            # Search all report names which contain a 1
            POST /reports/_search
            {
                    "query": {
                            "term": {
                                "display_name.filtered": " 64"
                            }
                    },
                    "size": 5
            }  

    4. Verify that you get at most 5 matches and that all matches have "<space>64" in the display_name
       So, if a user types-in "<space>64" in the search box, these are the display names we would show




Procedure:  Add a REST call to run an ngram search
--------------------------------------------------
Create a REST call with this contract

	POST /api/search/autocomplete
    		{
   			"index_name": 	"reports",
   			"returned_field": 	"display_name",
   			"searched_field": 	"display_name.filtered",
   			"raw_query":  		"64",
   			"size":       		5
    		}

    	Returns a list of strings




    1. Create the back-end AutoCompleteDTO object that holds information passed-in to the REST call

        a. Right-click on backend/src/main/java/com/lessons/models -> New Java Class
           Class Name:  AutoCompleteDTO

        b. Add these private variables:
        
            @JsonProperty("index_name")
            private String indexName;
        
            @JsonProperty("returned_field")
            private String returnedField;
        
            @JsonProperty("searched_field")
            private String searchedField;
        
            @JsonProperty("raw_query")
            private String rawQuery;
        
            @JsonProperty("size")
            private int size;

        c. Generate the getters and setters
           Right-click (where you want the getters and setters to appear) -> Generate -> Getter & Setter
           Select all private variables


    2. Create the back-end AutoCompleteDTO object that holds information passed-out from the REST call
        a. Right-click on backend/src/main/java/com/lessons/models -> New Java Class
           Class Name:  AutoCompleteMatchDTO

        b. Copy this to your newly-created class:
            
            package com.lessons.models;
            
            import com.fasterxml.jackson.annotation.JsonProperty;
            
            public class AutoCompleteMatchDTO {
                
                @JsonProperty("id")
                private final String id;
                
                @JsonProperty("name")
                private final String name;
            
                
                // ------------------- Constructors & Getters ----------------------
            
                public AutoCompleteMatchDTO(String id, String name) {
                    this.id = id;
                    this.name = name;
                }
            
                public String getId() {
                    return id;
                }
            
                public String getName() {
                    return name;
                }
            }


    3. Modify the back-end ElasticSearchService
        a. Edit ElasticSearchService.java

        b. Add this private method:  cleanupRawQuery()
            
            /**
             * @param aRawQuery holds the raw query text
             * @return an empty string (if the passed-in string is null
             */
            private String cleanupRawQuery(String aRawQuery) {
                String cleanedQuery = aRawQuery;
            
                if (cleanedQuery == null) {
                 cleanedQuery = "";
                }
            
                return cleanedQuery;
            }


        c. Add this public method:  runAutoComplete()
            
            /**
             * Run an auto-complete search
             * @param aAutoCompleteDTO   holds information about the index and what field to search
             * @return a list of matching AutoCompleteMatchDTO objects (or an empty list if no matches are found)
             * @throws Exception if something bad happens
             */
            public List<AutoCompleteMatchDTO> runAutoComplete(AutoCompleteDTO aAutoCompleteDTO) throws Exception {
                if (aAutoCompleteDTO == null) {
                    throw new RuntimeException("Error in runAutoComplete():  The passed-in aAutoCompleteDTO is null.");
                }
            
                String cleanedQuery = cleanupRawQuery(aAutoCompleteDTO.getRawQuery());
            
                // Convert the cleaned query to lowercase (which is required as all ngrams are lowercase)
                cleanedQuery = cleanedQuery.toLowerCase();
            
                String jsonRequest =
                        "{\n" +
                                "  \"_source\": [\"" + aAutoCompleteDTO.getReturnedField() + "\"]," +
                                "  \"query\": {\n" +
                                "	\"term\": {\n" +
                                "   	\"" + aAutoCompleteDTO.getSearchedField() + "\": \"" + cleanedQuery + "\"\n" +
                                " 	}\n" +
                                "  },\n" +
                                "  \"size\": " + aAutoCompleteDTO.getSize() +"\n" +
                                "}";
            
                // Make a synchronous POST call to run this ES search
                Response response = this.asyncHttpClient.preparePost(this.elasticSearchUrl + "/" + aAutoCompleteDTO.getIndexName() + "/_search")
                        .setRequestTimeout(this.ES_REQUEST_TIMEOUT_IN_MILLISECS)
                        .setHeader("accept", "application/json")
                        .setHeader("Content-Type", "application/json")
                        .setBody(jsonRequest)
                        .execute()
                        .get();
            
                if (response.getStatusCode() != 200) {
                    // ElasticSearch returned a non-200 status response
                    throw new RuntimeException("Error in runAutoComplete():  ES returned a status code of " + response.getStatusCode() + " with an error of: " + response.getResponseBody());
                }
            
                // Create an empty array list
                List<AutoCompleteMatchDTO> listOfAutoCompleteMatchDTOs = new ArrayList<>();
            
                // Pull the list of matching values from the JSON Response
                String jsonResponse = response.getResponseBody();
            
                // Convert the response JSON string into a map and examine it to see if the request really worked
                Map<String, Object> mapResponse = objectMapper.readValue(jsonResponse, new TypeReference<Map<String, Object>>() {});
            
                @SuppressWarnings("unchecked")
                Map<String, Object> outerHits = (Map<String, Object>) mapResponse.get("hits");
                if (outerHits == null) {
                    throw new RuntimeException("Error in runAutoComplete():  The outer hits value was not found in the JSON response");
                }
            
                @SuppressWarnings("unchecked")
                List<Map<String, Object>> innerHits = (List<Map<String, Object>>) outerHits.get("hits");
                if (innerHits == null) {
                    throw new RuntimeException("Error in runAutoComplete():  The inner hits value was not found in the JSON response");
                }
            
                if (innerHits.size() > 0) {
                    for (Map<String, Object> hit: innerHits) {
            
                        // Get the _id field from the hit map
                        String id = (String) hit.get("_id");
            
                        @SuppressWarnings("unchecked")
                        Map<String, Object> sourceMap = (Map<String, Object>) hit.get("_source");
                        if (sourceMap == null) {
                            throw new RuntimeException("Error in runAutoComplete():  The source map was null in the JSON response");
                        }
            
                        // Get the matching returned field
                        String match = (String) sourceMap.get(aAutoCompleteDTO.getReturnedField());
            
                        // Create an AutoCompleteMatchDTO object
                        AutoCompleteMatchDTO matchDTO = new AutoCompleteMatchDTO(id, match);
            
                        // Add the AutoCompleteMatchDTO object to the list
                        // (so the front-end will have an id and name field for this match)
                        listOfAutoCompleteMatchDTOs.add(matchDTO);
                    }
                }
            
            
                // Return the list of matching strings
                return listOfAutoCompleteMatchDTOs;
            }
            



    4. Add a new controller class:  SearchController
        a. Right-click on backend/src/main/java/com/lessons/controllers -> New Class
           Class Name:  SearchController

        b. Copy this to your newly-created class:
            
            package com.lessons.controllers;
            
            import com.lessons.models.AutoCompleteDTO;
            import com.lessons.models.AutoCompleteMatchDTO;
            import com.lessons.services.ElasticSearchService;
            import org.apache.commons.lang3.StringUtils;
            import org.slf4j.Logger;
            import org.slf4j.LoggerFactory;
            import org.springframework.http.HttpStatus;
            import org.springframework.http.MediaType;
            import org.springframework.http.ResponseEntity;
            import org.springframework.stereotype.Controller;
            import org.springframework.web.bind.annotation.RequestBody;
            import org.springframework.web.bind.annotation.RequestMapping;
            import org.springframework.web.bind.annotation.RequestMethod;
            import javax.annotation.Resource;
            import java.util.List;
            
            @Controller("com.lessons.controllers.SearchController")
            public class SearchController {
                private static final Logger logger = LoggerFactory.getLogger(SearchController.class);
            
                @Resource
                private ElasticSearchService elasticSearchService;
            
                /**
                * REST endpoint /api/search/autocomplete
                * @return a list of AutoCopmleteMatchDTO objects (or an empty list if no matches were
            found)
                * @throws Exception if something bad happens
                */
                @RequestMapping(value = "/api/search/autocomplete", method = RequestMethod.POST, produces = "application/json")
                public ResponseEntity<?> runAutoComplete(@RequestBody AutoCompleteDTO aAutoCompleteDTO) throws Exception {
            
                    logger.debug("runAutoComplete() started.");
            
                    if (StringUtils.isEmpty(aAutoCompleteDTO.getIndexName() )) {
                        // The passed-in DTO does not have a valid index_name
                        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                                .contentType(MediaType.TEXT_PLAIN)
                                .body("The index name is empty or null.");
                    }
                    else if (StringUtils.isEmpty(aAutoCompleteDTO.getReturnedField() )) {
                        // The passed-in DTO does not have a valid returned_field
                        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                                .contentType(MediaType.TEXT_PLAIN)
                                .body("The returned field is empty or null.");
                    }
                    else if (StringUtils.isEmpty(aAutoCompleteDTO.getSearchedField() )) {
                        // The passed-in DTO does not have a valid searched_field
                        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                                .contentType(MediaType.TEXT_PLAIN)
                                .body("The searched field is empty or null.");
                    }
                    else if (aAutoCompleteDTO.getSize() <= 0) {
                        // The passed-in DTO has an invalid size:  It must be positive and less than 100
                        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                                .contentType(MediaType.TEXT_PLAIN)
                                .body("The size must be a positive number less than or equal to 100");
                    }
                    else if (aAutoCompleteDTO.getSize() > 100) {
                        // The passed-in DTO does has an invalid size:  It must be positive and less than 100
                        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                                .contentType(MediaType.TEXT_PLAIN)
                                .body("The size must be a positive number less than or equal to 100");
                    }
            
                    // Run the search and get a list of matching AutoCompleteMatchDTO objects
                    List<AutoCompleteMatchDTO> matches =
            elasticSearchService.runAutoComplete(aAutoCompleteDTO);
            
                    // Return a list of matches (or an empty list if there are no matches)
                    return ResponseEntity
                            .status(HttpStatus.OK)
                            .body(matches);
                }
            }



    5. Verify that the REST call works by running a search that returns at most 3 matches
        a. Activate the Debugger on "Backend"
        b. Startup Postman
        c. Press "+" to create a new request

        d. In the request, use these settings
            i. POST   http://localhost:8080/app1/api/search/autocomplete

            ii. Headers
   	        	Accept        application/json
   		        Content-Type  application/json

            iii. Body -> Raw

                    {
                       "index_name":        "reports",
                       "returned_field":    "display_name",
                       "searched_field":    "display_name.filtered",
                       "raw_query":         " 64",
                       "size":              3
                    }

            iv. Press "Send"


        e. Verify that all of the matching name fields have "<space>64" in them
            
            [
               {
                   "id": "NM27mnkBkorVSZiAq84r",
                   "name": "report 64"
               },
               {
                   "id": "hM67mnkBkorVSZiAqz5P",
                   "name": "report 644"
               },
               {
                   "id": "gc67mnkBkorVSZiAqz5P",
                   "name": "report 642"
               }
            ]



```
