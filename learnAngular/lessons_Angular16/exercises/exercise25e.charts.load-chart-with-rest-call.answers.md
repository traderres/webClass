```
Exercise 25e / Add REST call to get the chart data
--------------------------------------------------
Problem:  I want to build a real REST call that is used to load the chart
Solution: Build the REST call and integrate it with the front-end



Part 1 / Build the REST call contract
-------------------------------------
a. What is the URL?
   Rule:  Must start with /api

b. What is the URL Type?
        GET			Used for read-only operations
        PUT			Used for write operations and passing-in 1 parameter on the URL
        POST   		Used for write operations and passing-in multiple parameters [no limit]
        DELETE		Used for write operations involving deletes

c. What is passed-in?

d. What is returned?

e. What checks are made on the passed-in data?
    -- What is REQUIRED?		Everything is required / the DTO should have something for all 4 fields
    -- What is OPTIONAL?

f. What security roles are granted access to this REST call?


g. What does this REST call do?




Part 2 / Build the REST Call to get the chart data
--------------------------------------------------
 1. Create the back-end DTO:  GetChart2DataDTO
 
 2. Create the back-end Java service:  ChartService
 
 3. Create the back-end Java controller:  ChartController
 
 4. Use Postman to verify it works
 



Part 3 / Integrate the back-end REST call with the front-end
------------------------------------------------------------
 1. Edit the front-end chart.service.ts
    a. Inject the httpClient
    
    b. Edit the getAllDataForChart2()
       -- Remove all of the hard-coded stuff
       -- Build the REST call url
       -- Use the httpClient to setup an observable hooked-up to this REST call
       
       
            public getAllDataForChart2(): Observable<GetChart2DataDTO[]> {
                // Construct the URL of the REST call
                const restUrl = environment.baseUrl + '/api/dashboard/chart/data';
            
                // Return an observable
                return this.httpClient.get <GetChart2DataDTO[]>(restUrl);
            }
       
 2. Verify it works

```