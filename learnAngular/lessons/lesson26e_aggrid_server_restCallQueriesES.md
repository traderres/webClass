Lesson 26e:  AG Grid / Server Side / Change REST Call to Query ElasticSearch
----------------------------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1vjpXF6BXOMbt8RBSCAmDB89XnYm6dAUCfywjmaAMHkQ/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson26e/server-side-grid/query-es
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem:  We want the ag-grid server-side REST call to query ElasticSearch for filtering, sorting, and searching.<br>



<br>
<br>

```
Approach
--------
    A. Change the ES mapping to support sorting and filtering
    B. Generate a CSV file that has 1000,000 records in it
    C. Use the Upload Report page to upload this csv file    (to add the records to ElasticSearch)
    D. Verify that the data is in ElasticSearch
    E. Add methods to the ElasticSearchService.java to support searching and filtering
    F. Update GridService
        a. Inject the ElasticSearchService
        b. Change the method to run a search against ES
    G. Update the GridController
        a. Have the REST endpoint setup default sorting
        b. Have the REST endpoint pass-in a list of ES fields to search



Procedure
---------
    1. Change the ES mapping to support sorting and filtering
       a. Edit backend/src/main/resources/reports.mapping.json

       b. Change its contents to this:
            
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
            
                "description": {
                    "type": "text",
                    "fields": {
                    "filtered": {
                        "type": "text",
                        "analyzer": "my_ngram_analyzer"
                    }
                    }
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
            


    2. Generate a CSV file that has lots of records
       a. Edit backend/src/test/java/com/lessons/AppTest



       b. Edit the createTestFile() unit test so it has these 2 annotations:

            @Ignore
            @Test
            public void createTestFile() throws Exception {

        c. Right-click on the createTestFile method -> Debug 'createTestFile'
           -- This should run this unit test and create a large csv file here:
	            angularApp1/docs/large_file.1000000.csv
	


    3. Destroy the existing reports index in ElasticSearch
       a. Open a browser
       b. Connect to the kibana console
          http://localhost:5601/app/kibana#/dev_tools/console

       c. Enter this command:
             DELETE /reports

       d. Run this command by pressing the "Play" button or pressing Control-Enter
   



    4. Use the Upload Report page to upload this csv file    (to add the records to ElasticSearch)
       a. Startup the WebApp   (the ElasticSearchService will re-create the mapping on startup)
       b. Go to the "Upload Report" page
       c. Upload the large_file.1000000.csv


    5. Verify that you see data in ElasticSearch
       a. Open a browser
       b. Connect to the kibana console
          http://localhost:5601/app/kibana#/dev_tools/console

       c. Enter this command:
            POST reports/_count

       d. Verify that the count matches the total size of the CSV file





    6. Change the GridGetRowsResponseDTO constructor
       a. Edit GridGetRowsResponseDTO

       b. Change the constructor to this:

            public GridGetRowsResponseDTO(List<Map<String, Object>> data, Integer totalMatches, String aSearchAfterClause) {
                this.data = data;
                this.totalMatches = totalMatches;
                this.searchAfterClause = aSearchAfterClause;
            }



    7. Change the ElasticSearchService
       a. Edit ElasticSearchService.java

       b. Replace its contents with this:
            
            package com.lessons.services;
            
            import com.fasterxml.jackson.core.type.TypeReference;
            import com.fasterxml.jackson.databind.ObjectMapper;
            import com.lessons.config.ElasticSearchResources;
            import com.lessons.models.AutoCompleteDTO;
            import com.lessons.models.AutoCompleteMatchDTO;
            import com.lessons.models.ErrorsDTO;
            import com.lessons.models.grid.GridGetRowsResponseDTO;
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
            import java.util.*;
            import java.util.regex.Pattern;
            
            @Service
            public class ElasticSearchService {
            
                private static final Logger logger = LoggerFactory.getLogger(ElasticSearchService.class);
            
                @Resource
                private ElasticSearchResources elasticSearchResources;
            
                private String elasticSearchUrl;
                private AsyncHttpClient asyncHttpClient;
                private final int ES_REQUEST_TIMEOUT_IN_MILLISECS = 90000;
            
                private ObjectMapper objectMapper;
            
                private final Pattern patMatchDoubleQuote 	= Pattern.compile("\"");
                private final Pattern patMatchAscii1To31or128 = Pattern.compile("[\\u0000-\\u001F\\u0080]");
                private final Pattern patMatchBackwardSlashMissingReserveChar = Pattern.compile("\\\\([^+!-><)(:/}{*~]|\\Z)");
            
            
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
            
                private void initializeMapping() throws Exception {
                    if (! doesIndexExist("reports")) {
                        // Create the reports ES mapping
            
                        // Read the mapping file into a large string
                        String reportsMappingAsJson = readInternalFileIntoString("reports.mapping.json");
            
                        // Create a mapping in ElasticSearch
                        createIndex("reports", reportsMappingAsJson);
                    }
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
                    Response response = this.asyncHttpClient.prepareDelete(this.elasticSearchUrl + "/" +
                            aIndexName)
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
                                response.getStatusCode() + ".  Response message is " +
            response.getResponseBody() );
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
            
            
            
                public GridGetRowsResponseDTO runSearchGetRowsResponseDTO(String aIndexName, String aJsonBody) throws Exception {
                    if (StringUtils.isEmpty(aIndexName)) {
                        throw new RuntimeException("The passed-in aIndexName is null or empty.");
                    }
                    else if (StringUtils.isEmpty(aJsonBody)) {
                        throw new RuntimeException("The passed-in aJsonBody is null or empty.");
                    }
            
                    // Make a synchronous POST call to execute a search and return a response object
                    Response response = this.asyncHttpClient.prepareGet(this.elasticSearchUrl + "/" + aIndexName + "/_search")
                            .setRequestTimeout(this.ES_REQUEST_TIMEOUT_IN_MILLISECS)
                            .setHeader("accept", "application/json")
                            .setHeader("Content-Type", "application/json")
                            .setBody(aJsonBody)
                            .execute()
                            .get();
            
                    if (response.getStatusCode() != 200) {
                        throw new RuntimeException("Critical error in runSearchGetJsonResponse():  ElasticSearch returned a response status code of " +
                                response.getStatusCode() + ".  Response message is " + response.getResponseBody() + "\n\n" + aJsonBody);
                    }
            
            
                // Create an empty array list
                    List<Map<String, Object>> listOfMaps = new ArrayList<>();
            
                    // Pull the list of matching values from the JSON Response
                    String jsonResponse = response.getResponseBody();
            
                    // Convert the response JSON string into a map and examine it to see if the request really worked
                    Map<String, Object> mapResponse = objectMapper.readValue(jsonResponse, new TypeReference<Map<String, Object>>() {});
            
                    @SuppressWarnings("unchecked")
                    Map<String, Object> outerHitsMap = (Map<String, Object>) mapResponse.get("hits");
                    if (outerHitsMap == null) {
                        throw new RuntimeException("Error in runAutoComplete():  The outer hits value was not found in the JSON response");
                    }
            
                    @SuppressWarnings("unchecked")
                    List<Map<String, Object>> innerHitsListOfMaps = (List<Map<String, Object>>) outerHitsMap.get("hits");
                    if (innerHitsListOfMaps == null) {
                        throw new RuntimeException("Error in runAutoComplete():  The inner hits value was not found in the JSON response");
                    }
            
                    if (innerHitsListOfMaps.size() > 0) {
                        for (Map<String, Object> hit: innerHitsListOfMaps) {
            
                            // Get the source map (that has all of the results)
                            @SuppressWarnings("unchecked")
                            Map<String, Object> sourceMap = (Map<String, Object>) hit.get("_source");
                            if (sourceMap == null) {
                                throw new RuntimeException("Error in runAutoComplete():  The source map was null in the JSON response");
                            }
            
                            // Add the sourceMap to the list of maps
                            listOfMaps.add(sourceMap);
                        }
                    }
            
                    Integer totalMatches = 0;
            
            
                    if (listOfMaps.size() > 0) {
                        // Get the total matches from the json
                        @SuppressWarnings("unchecked")
                        Map<String, Object> totalInfoMap = (Map<String, Object>) outerHitsMap.get("total");
                        if ((totalInfoMap != null) && (totalInfoMap.size() > 0)) {
                            totalMatches = (Integer) totalInfoMap.get("value");
                        }
                    }
            
            
                    // Set the searchAfter clause in the GetResponseRowsDTO object
                    // NOTE:  The front-end will pass this back for page 2, page 3, page 4
                    //    	so we can run the same ES query and get page 2, page 3, page 4
                    String searchAfterClause = getSearchAfterFromEsResponseMap(innerHitsListOfMaps);
            
            
                    GridGetRowsResponseDTO responseDTO = new GridGetRowsResponseDTO(listOfMaps, totalMatches, searchAfterClause);
                    return responseDTO;
                }
            
            
                /**
                * Generate the search_after clause by looking at the last result from the last search
                *  1. If the list of maps is empty, return an empty string
                *  2. Loop through the sort model list
                *     -- Build the search_after by pulling the sorted field name
                *     -- If the sort field name == "_score", then pull the score
                *
                * @param aListOfHitsMaps holds the list of ES maps (that hold the search results)
                * @return a String that holds the search_after clause
                */
                private String getSearchAfterFromEsResponseMap(List<Map<String, Object>> aListOfHitsMaps) {
                    if ((aListOfHitsMaps == null) || (aListOfHitsMaps.size() == 0)) {
                        return "";
                    }
            
                    // Get the last map
                    Map<String, Object> lastMap = aListOfHitsMaps.get( aListOfHitsMaps.size() - 1);
                    if (lastMap == null) {
                        return "";
                    }
            
                    // Get the last source map  (it has the search results for the last match)
                    @SuppressWarnings("unchecked")
                    Map<String, Object> lastSourceMap = (Map<String, Object>) lastMap.get("_source");
                    if (lastSourceMap == null) {
                        throw new RuntimeException("Error in getSearchAfterFromEsResponseMap():  The lastSourceMap is null.");
                    }
            
                    // Get the list of sort fields from the lastMap.sort
                    @SuppressWarnings("unchecked")
                    List<Object> listOfSortFields = (List<Object>) lastMap.get("sort");
                    if ((listOfSortFields == null) || (listOfSortFields.size() == 0)) {
                        throw new RuntimeException("Error in getSearchAfterFromEsResponseMap():  The listOfSortFields is null or empty.  It should have always have one or more items.");
                    }
            
                    StringBuilder sbSearchAfterClause = new StringBuilder();
            
                    for (Object lastSortValueObject: listOfSortFields) {
                        String lastSortValue = "\"" + String.valueOf( lastSortValueObject ) + "\"";
            
                        sbSearchAfterClause.append(lastSortValue)
                                .append(",");
                    }
            
                    // Remove the last comma
                    sbSearchAfterClause.deleteCharAt(sbSearchAfterClause.length() - 1);
            
                    return sbSearchAfterClause.toString();
                }
            
            
            
                /**
                * Clean-up the passed-in raw query with the following rules:
                *   1) If Double quote is found, then replace it with \"
                *   2) If ASCII value between 1 and 31 is found or 128, then replace it with a space
                *   3) If "\" is found without a special reserve chars, then replace it with a space
                * @param aRawQuery holds the raw query from the front-end
                * @return cleaned-up query
                */
                public String cleanupQuery(String aRawQuery) {
            
                    // Convert  "and " or " and " or " and" to --> AND
                    // NOTE:  Do this first before encoding the quotes
                    String cleanedQuery = adjustElasticSearchAndOrNotOperators(aRawQuery);
            
                    // Convert the pattern match of " to \"
                    // NOTE:  Because of Java Regex, you have to use four backward slashes to match a \
                    cleanedQuery = this.patMatchDoubleQuote.matcher(cleanedQuery).replaceAll("\\\\\"");
            
                    // If ASCII 1-31 or 128 is found, then replace it with a space
                    cleanedQuery = this.patMatchAscii1To31or128.matcher(cleanedQuery).replaceAll(" ");
            
                    // If a single backslash is found but the required reserve char is missing -- then replace it with a space
                    cleanedQuery = this.patMatchBackwardSlashMissingReserveChar.matcher(cleanedQuery).replaceAll(" ");
            
                    return cleanedQuery;
                }
                
            
                private String adjustElasticSearchAndOrNotOperators(String aString) {
                    if (StringUtils.isBlank(aString)) {
                        return aString;
                    }
            
                    // Convert the string into a list of Strings
                    List<String> listOfWords = Arrays.asList(aString.trim().split("\\s+"));
            
                    // Get the iterator
                    ListIterator<String> iter = listOfWords.listIterator();
            
                    boolean inQuotes = false;
            
                    // Loop through the list and remove certain items
                    while (iter.hasNext())
                    {
                        String word = iter.next();
            
                        if (word.length() == 0) {
                            continue;
                        }
            
                        if (word.equalsIgnoreCase("\"")) {
                            // The entire word is an open quote
                            inQuotes = !inQuotes;
                            continue;
                        }
            
                        if ((word.startsWith("\"") && (! word.endsWith("\""))) ||
                                (! word.startsWith("\"") && (word.endsWith("\"")))) {
                            // The word either starts or ends with a quote
                            inQuotes = !inQuotes;
                        }
            
                        if (!inQuotes && (word.equalsIgnoreCase("and") || word.equalsIgnoreCase("or") || word.equalsIgnoreCase("not")))
                        {
                            // Convert this "and", "or", or "not" word to uppercase
                            word = word.toUpperCase();
                            iter.set(word);
                        }
                    }
            
                    String returnedStirng = StringUtils.join(listOfWords, " ");
                    return returnedStirng;
                }
            
            }
            
            
            




    8. Change the GridService
       a. Edit GridService.java

       b. Replace its contents with this:
            
            package com.lessons.services;
            
            import com.lessons.models.grid.*;
            import org.apache.commons.collections4.CollectionUtils;
            import org.apache.commons.lang3.StringUtils;
            import org.slf4j.Logger;
            import org.slf4j.LoggerFactory;
            import org.springframework.stereotype.Service;
            import javax.annotation.Resource;
            import java.util.List;
            import java.util.Map;
            
            
            @Service
            public class GridService {
                private static final Logger logger = LoggerFactory.getLogger(GridService.class);
            
                @Resource
                private ElasticSearchService elasticSearchService;
            
            
                /**
                *  1. Run a search
                *  2. Put the results into a list
                *  3. Create a GridGetRowsResponseDTO object
                *  4. Return the GridGetRowsResponseDTO object
                *
                * @param aGridRequestDTO holds information about the request
                * @return holds the response object (that holds the list of data)
                */
                public GridGetRowsResponseDTO getPageOfData(String aIndexName, List<String> aFieldsToSearch, List<String> aFieldsToReturn, GridGetRowsRequestDTO aGridRequestDTO) throws Exception {
            
                    logger.debug("getPageOfData()  startRow={}   endRow={}", aGridRequestDTO.getStartRow(), aGridRequestDTO.getEndRow() );
            
                    // Calculate the page size  (to determine how many records to request from ES)
                    int pageSize = aGridRequestDTO.getEndRow() - aGridRequestDTO.getStartRow();
            
                    // Build the search_after clause  (which is used to get page 2, page 3, page 4 from an ES query)
                    String esSearchAfterClause = "";
                    if (aGridRequestDTO.getStartRow() > 0) {
                        // Getting the 2nd, 3rd, 4th page....
                        esSearchAfterClause = " \"search_after\": [" +aGridRequestDTO.getSearchAfterClause() + "],";
                    }
            
                    // Construct the *SORT* clause
                    String esSortClauseWithComma = generateSortClauseFromSortParams(aGridRequestDTO.getSortModel() );
            
                    // Construct the *FILTER* clause (this holds the contains filters)
                    String filterClause = generateFilterClause(aGridRequestDTO.getFilterModel() );
            
                    // Construct the *MUST_NOT* clause (this holds the notContains filters)
                    String mustNotClause = generateMustNotClause(aGridRequestDTO.getFilterModel() );
            
                    // Construct the *QUERY* clause
                    String cleanedQuery = this.elasticSearchService.cleanupQuery( aGridRequestDTO.getRawSearchQuery()  );
                    String queryStringClause = generateQueryStringClause(cleanedQuery, aFieldsToSearch);
            
                    // Construct the _source clause (so ElasticSearch only returns a subset of the fields)
                    String esSourceClause = generateSourceClause(aFieldsToReturn);
            
                    // Assemble the pieces to build the JSON query
                    String jsonQuery = "{\n" +
                            esSourceClause + "\n" +
                            esSearchAfterClause + "\n" +
                            esSortClauseWithComma + "\n" +
                            "   \"track_total_hits\": true,\n" +
                            "   \"size\": " + pageSize +",\n" +
                            "  \"query\": {\n" +
                            "	\"bool\": {\n" +
                            "  	\"must\": {\n" +
                                    queryStringClause + "\n" +
                            "  	},\n" +
                                filterClause + "," +
                                mustNotClause +
                            "	}\n" +
                            "  }\n" +
                            "}";
            
                    // Execute the search and generate a GetResponsRowsResponseDTO object
                    // -- This sets responseDTO.setData() and responseDTo.setTotalMatches()
                    GridGetRowsResponseDTO responseDTO  = this.elasticSearchService.runSearchGetRowsResponseDTO(aIndexName, jsonQuery);
            
            
                    // Set the lastRow  (so the ag-grid's infinite scrolling works correctly)
                    if (aGridRequestDTO.getEndRow() < responseDTO.getTotalMatches() ) {
                        // This is not the last page.  So, set lastRow=-1  (which turns on infinite scrolling)
                        responseDTO.setLastRow(-1);
                    }
                    else {
                        // This is the last page.  So, set lastRow=totalMatches (which turns off infinite scrolling)
                        responseDTO.setLastRow( responseDTO.getTotalMatches() );
                    }
            
                    return responseDTO;
                }
            
            
            
                private String generateSourceClause(List<String> aFieldsToReturn) {
                    if (CollectionUtils.isEmpty(aFieldsToReturn)) {
                        // No fields were specified -- so ES will return all fields by default (but this is not efficient)
                        return "";
                    }
            
                    String quotedCsvFields = "\"" + StringUtils.join(aFieldsToReturn, "\",\"") + "\"";
                    String sourceClause = "\"_source\": [" + quotedCsvFields + "],";
                    return sourceClause;
                }
            
            
                private String generateQueryStringClause(String aCleanedQuery, List<String> aFieldsToSearch) {
                    String queryStringClause;
                    String fieldsClause = "";
            
                    if (CollectionUtils.isNotEmpty(aFieldsToSearch)) {
                        // A list of fields were passed-in.  So, generate a string that holds "fields": ["field1", "field2", "field3"],
                        fieldsClause = "\"fields\": [\"" + StringUtils.join(aFieldsToSearch, "\",\"") + "\"],\n";
                    }
            
                    if (StringUtils.isEmpty(aCleanedQuery)) {
                        // There is no query.  So, use ElasticSearch's match_all to run a search with no query
                        queryStringClause = "  \"match_all\": {}\n";
                    }
                    else {
                        // There is a query, so return a query_string clause
                        queryStringClause = "  \"query_string\": {\n" +
                                fieldsClause +
                                "    \"query\": \"" + aCleanedQuery + "\"\n" +
                                "     }\n";
                    }
            
                    return queryStringClause;
                }
            
            
            
                /**
                * Generate an ElasticSearch must_not clause
                *
                * If no filters are found, then return
                *	"must_not": []
                *
                * If filters are found, then return
                "	"must_not": [
                *   	{"term" : { "full_name.filtered":"jone"} }
                *   	{"term" : { "username.filtered":"jone"} },
                * 	]
                *
                * @param aFilterModelsMap holds a map of filter objects
                * @return String containing a filter clause
                */
                private String generateMustNotClause(Map<String, ColumnFilter> aFilterModelsMap) {
                    if ((aFilterModelsMap == null) || (aFilterModelsMap.size() == 0)){
                        // There are no filters.  So, return an empty must_not section
                        return "\"must_not\": []\n";
                    }
            
                    // Start off the filter ES query
                    StringBuilder sbFilterClause = new StringBuilder("\"must_not\": [");
            
                    for (Map.Entry<String, ColumnFilter> filter: aFilterModelsMap.entrySet() ) {
                        String actualFilterFieldName = filter.getKey();
            
                        // Get the columnFilter object -- it may be a NumericColumnFilter or a TextColumnFilter
                        ColumnFilter columnFilter = filter.getValue();
            
                        if (columnFilter instanceof NumberColumnFilter) {
                            // This is a numeric filter.
                            NumberColumnFilter numberColumnFilter = (NumberColumnFilter) columnFilter;
                            if ((numberColumnFilter.getType() == null) || (!(numberColumnFilter.getType().equalsIgnoreCase("notContains")))) {
                                // This is *NOT* a notContains filter.  So skip it
                                continue;
                            }
            
                            Integer filterValue = numberColumnFilter.getFilter();
                            if (filterValue == null) {
                                // The user typed-in an invalid filter (entering text in a numeric filter)
                                filterValue = -1;
                            }
            
                            // This is a number filter (so there are no quotes around the filterValue
                            sbFilterClause.append("\n{ \"term\" : {" )
                                    .append(" \"")
                                    .append(actualFilterFieldName)
                                    .append("\":")
                                    .append( filterValue )
                                    .append(" }},");
                        }
                        else if (columnFilter instanceof TextColumnFilter) {
                            // This is a text filter
                            TextColumnFilter textColumnFilter = (TextColumnFilter) columnFilter;
                            if ((textColumnFilter.getType() == null) || (!(textColumnFilter.getType().equalsIgnoreCase("notContains")))) {
                                // This is *NOT* a notContains filter.  So skip it
                                continue;
                            }
            
                            String filterValue = textColumnFilter.getFilter();
            
                            // Add the filter to the ES query
                            // NOTE: Set the filterValue to lowercase (as the filtered column is stored as lowercase)
                            sbFilterClause.append("\n{ \"term\" : {" )
                                    .append(" \"")
                                    .append(actualFilterFieldName)
                                    .append("\":\"")
                                    .append( filterValue.toLowerCase() )
                                    .append("\" }},");
                        }
                        else {
                            throw new RuntimeException("Error in generateFilterClause():  Unknown filter Type.");
                        }
            
                    }  // End of looping through filters
            
                    if (sbFilterClause.charAt(sbFilterClause.length() - 1) == ',') {
                        // Remove the last comma if found
                        sbFilterClause.deleteCharAt(sbFilterClause.length() - 1);
                    }
            
                    // Add the closing square bracket
                    sbFilterClause.append("]\n");
            
                    return sbFilterClause.toString();
                }
            
            
            
                /**
                * Generate an ElasticSearch Filter clause
                *
                * If no filters are found, then return
                *	"filter": []
                *
                * If filters are found, then return
                "	"filter": [
                *   	{"term" : { "full_name.filtered":"jone"} }
                *   	{"term" : { "username.filtered":"jone"} },
                * 	]
                *
                * @param aFilterModelsMap holds a map of filter objects
                * @return String containing a filter clause
                */
                private String generateFilterClause(Map<String, ColumnFilter> aFilterModelsMap) {
                    if ((aFilterModelsMap == null) || (aFilterModelsMap.size() == 0)){
                        // There are no filters.  So, return an empty filters section
                        return "\"filter\": []\n";
                    }
            
                    // Start off the filter ES query
                    StringBuilder sbFilterClause = new StringBuilder("\"filter\": [");
            
                    for (Map.Entry<String, ColumnFilter> filter: aFilterModelsMap.entrySet() ) {
                        String actualFilterFieldName = filter.getKey();
            
                        // Get the columnFilter object -- it may be a NumericColumnFilter or a TextColumnFilter
                        ColumnFilter columnFilter = filter.getValue();
            
                        if (columnFilter instanceof NumberColumnFilter) {
                            // This is a numeric filter.
                            NumberColumnFilter numberColumnFilter = (NumberColumnFilter) columnFilter;
                            if ((numberColumnFilter.getType() == null) || (!(numberColumnFilter.getType().equalsIgnoreCase("contains")))) {
                                // This is *NOT* a contains filter.  So skip it
                                continue;
                            }
            
                            Integer filterValue = numberColumnFilter.getFilter();
                            if (filterValue == null) {
                                filterValue = -1;
                            }
            
                            // This is a number filter (so there are no quotes around the filterValue
                            sbFilterClause.append("\n{ \"term\" : {" )
                                    .append(" \"")
                                    .append(actualFilterFieldName)
                                    .append("\":")
                                    .append( filterValue )
                                    .append(" }},");
                        }
                        else if (columnFilter instanceof TextColumnFilter) {
                            // This is a text filter
                            TextColumnFilter textColumnFilter = (TextColumnFilter) columnFilter;
                            if ((textColumnFilter.getType() == null) || (!(textColumnFilter.getType().equalsIgnoreCase("contains")))) {
                                // This is *NOT* a contains filter.  So skip it
                                continue;
                            }
            
                            String filterValue = textColumnFilter.getFilter();
            
                            // Add the filter to the ES query
                            // NOTE: Set the filterValue to lowercase (as the filtered collumn is stored as lowercase)
                            sbFilterClause.append("\n{ \"term\" : {" )
                                    .append(" \"")
                                    .append(actualFilterFieldName)
                                    .append("\":\"")
                                    .append( filterValue.toLowerCase() )
                                    .append("\" }},");
                        }
                        else {
                            throw new RuntimeException("Error in generateFilterClause():  Unknown filter Type.");
                        }
            
                    }  // End of looping through filters
            
                    if (sbFilterClause.charAt(sbFilterClause.length() - 1) == ',') {
                        // Remove the last comma if found
                        sbFilterClause.deleteCharAt(sbFilterClause.length() - 1);
                    }
            
                    // Add the closing square bracket
                    sbFilterClause.append("]\n");
            
                    return sbFilterClause.toString();
                }
            
            
            
                private String generateSortClauseFromSortParams(List<SortModel> aSortModelList) {
            
                    StringBuilder sbSortClause = new StringBuilder("\"sort\": [\n");
            
                    // Loop through the list of sort models, generating the ES sort clause
                    for (SortModel sortModel: aSortModelList) {
                        String sortFieldName = sortModel.getColId();
                        String sortOrder = sortModel.getSort();
            
                        if (sortFieldName.equalsIgnoreCase("_score")) {
                            // We are sorting by the _score so do not include the missing: field
                            sbSortClause
                        .append("{\n" + "\"")
                        .append(sortFieldName)
                        .append("\": {\n")
                        .append("   		 \"order\": \"")
                        .append(sortOrder)
                        .append("\"\n")
                        .append(" 		 }\n")
                        .append("   	 },");
                        }
                        else {
                            // We are sorting by a non _score field.  So, include the missing field
                            if (sortOrder.equalsIgnoreCase("asc")) {
                                // Sorting ascending, so set missing to _first  (so nulls are at the top)
                                sbSortClause
                        .append("{\n" + "\"")
                        .append(sortFieldName)
                        .append("\": {\n")
                        .append("   		 \"order\": \"")
                        .append(sortOrder)
                        .append("\",\n")
                        .append("   		 \"missing\" : \"_first\"\n")
                        .append(" 		 }\n")
                        .append("   	 },");
                            }
                            else {
                                // Sort descending, so set missing to _last  (so nulls are at the end)
                                sbSortClause
                        .append("{\n" + "\"")
                        .append(sortFieldName)
                        .append("\": {\n")
                        .append("   		 \"order\": \"")
                        .append(sortOrder)
                        .append("\",\n")
                        .append("   		 \"missing\" : \"_last\"\n")
                        .append(" 		 }\n")
                        .append("   	 },");
                            }
                        }
            
                    }
            
                    // Remove the last comma
                    sbSortClause.deleteCharAt(sbSortClause.length() - 1);
            
                    // Add the closing square bracket and comma to the end
                    sbSortClause.append("],");
            
                    return sbSortClause.toString();
                }
            }
            
            



    9. Change the GridController
       a. Edit GridController.java

       b. Replace its contents with this:
            
            package com.lessons.controllers;
            
            import com.lessons.models.grid.GridGetRowsRequestDTO;
            import com.lessons.models.grid.GridGetRowsResponseDTO;
            import com.lessons.models.grid.SortModel;
            import com.lessons.services.GridService;
            import org.apache.commons.collections4.CollectionUtils;
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
            import java.util.Arrays;
            import java.util.Collections;
            import java.util.List;
            
            @Controller
            public class GridController {
                private static final Logger logger = LoggerFactory.getLogger(GridController.class);
            
                @Resource
                private GridService gridService;
            
            
                /**
                * The AG-Grid calls this REST endpoint to load the grid in server-side mode
                *
                * @param aGridRequestDTO holds the Request information
                * @return ResponseEntity that holds a GridGetRowsResponseDTO object
                * @throws Exception if something bad happens
                */
                @RequestMapping(value = "/api/grid/getRows", method = RequestMethod.POST, produces = "application/json")
                public ResponseEntity<?> getRows(@RequestBody GridGetRowsRequestDTO aGridRequestDTO) throws Exception {
                    logger.debug("getRows() started.");
            
                    if (aGridRequestDTO.getStartRow() >= aGridRequestDTO.getEndRow() ) {
                        // This is an invalid request
                        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                                .contentType(MediaType.TEXT_PLAIN)
                                .body("The endRow must be greater than the startRow.");
                    }
            
                    // Change the sort field from "priority" to "priority.sort"  (so the sort is case insensitive -- see the mapping)
                    changeSortFieldToUseElasticFieldsForSorting(aGridRequestDTO, "id");
            
                    // Set Default sorting
                    //  1) If the sorting model is not empty, then do nothing
                    //  2) If the sorting model to empty and rawSearchQuery is empty, then sort by "id" ascending
                    //  3) If the sorting model is empty and rawSearchQuery is not empty, then sort by "_score" descending
                    setDefaultSorting(aGridRequestDTO, "id");
            
                    // Create an array of ES fields to **SEARCH**
                    List<String> esFieldsToSearch = Arrays.asList("id.sort", "description", "display_name.sort", "priority.sort");
            
                    // Create an array of ES fields to **RETURN**   (if this list is empty, then ES will return all fields in the ES mapping)
                    List<String> esFieldsToReturn = Arrays.asList("id", "description", "display_name", "priority");
            
                    // Invoke the GridService to run a search
                    GridGetRowsResponseDTO responseDTO = gridService.getPageOfData("reports", esFieldsToSearch, esFieldsToReturn, aGridRequestDTO);
            
                    // Return the responseDTO object and a 200 status code
                    return ResponseEntity
                            .status(HttpStatus.OK)
                            .body(responseDTO);
                }
            
            
            
                /**
                * Set default sorting
                *  1) If the sorting model is not empty and does not contain the "id" score, then append "id" ascending
                *  2) If the sorting model to empty and rawSearchQuery is empty, then sort by "id" ascending
                *  3) If the sorting model is empty and rawSearchQuery is not empty, then sort by "_score" descending
                *
                * ASSUMPTION:  Every query must have a sort field set so that the "infinity scroll" works
                *          	So, every query sent to ElasticSearch must be sorted on something -- either the "score" for sorting on relevancy or some sort field
                *          	If no sort field is provided, the the ES query will be sorted by the default ID field
                *
                * @param aGridRequestDTO holds information about the grid request
                */
                private void setDefaultSorting(GridGetRowsRequestDTO aGridRequestDTO, String aNameOfIdField) {
                    if (CollectionUtils.isNotEmpty( aGridRequestDTO.getSortModel() )) {
                        // Sorting model is not empty.  So, user is sorting by a column.  Append the id field ascending (if it's not already there)
            
                        for (SortModel sortModel: aGridRequestDTO.getSortModel() ) {
                            if ((sortModel.getColId() != null) && (sortModel.getColId().equalsIgnoreCase(aNameOfIdField)) ) {
                                // The SortModel is not empty and *ALREADY* contains the "id" field.  So, do nothing.
                                return;
                            }
                        }
            
                        // The SortModel is not empty and does *NOT* contain the "id" column.  So, add the "id" ascending to the list of sort models
                        SortModel sortById = new SortModel(aNameOfIdField, "asc");
                        aGridRequestDTO.getSortModel().add(sortById);
                        return;
                    }
            
                    List<SortModel> sortModelList;
            
                    // The sorting model is empty
                    if (StringUtils.isBlank(aGridRequestDTO.getRawSearchQuery())) {
                        // The sorting model is empty and rawSearchQuery is blank
                        // -- User is *not* running a search.  So, sort by "id" ascending
                        SortModel sortById = new SortModel(aNameOfIdField, "asc");
                        sortModelList = Collections.singletonList(sortById);
                    }
                    else {
                        // The sorting mode is empty and rawSearchQuery is not empty
                        // -- User is running a search.  SO, sort by "_score" descending *AND* by "id"
                        //	NOTE:  When using the search_after technique to get the next page, we need to sort by _score *AND* id
                        SortModel sortByScore = new SortModel("_score", "desc");
                        SortModel sortById = new SortModel(aNameOfIdField, "asc");
                        sortModelList = Arrays.asList(sortByScore, sortById);
                    }
            
            
                    aGridRequestDTO.setSortModel(sortModelList);
                }
            
            
                private void changeSortFieldToUseElasticFieldsForSorting(GridGetRowsRequestDTO aGridRequestDTO, String aNameOfIdField) {
            
                    if (CollectionUtils.isNotEmpty(aGridRequestDTO.getSortModel())) {
                        for (SortModel sortModel: aGridRequestDTO.getSortModel() ) {
                            String sortFieldName = sortModel.getColId();
                            if (! sortFieldName.equalsIgnoreCase(aNameOfIdField)) {
                                sortFieldName = sortFieldName + ".sort";
                                sortModel.setColId(sortFieldName);
                            }
                        }
                    }
                }
            }


    10. Verify the Server Side Grid Works
        a. Activate the Debugger on Full WebApp
        b. Go to the "Server Side Grid Page"
        c. Run a search

```
