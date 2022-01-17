Lesson 11c:  View Reports / Add Front End Page / Invoke REST Call
-----------------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/12qfzE31GS-onMzCphXMZlm1AKJRkTzU4Cmxb_SfNVNg/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson11c/invoke-rest-call
<br>
<br>

<h3>Approach</h3>

- Adjust your front-end report.service.ts to call the real REST endpoint

<br>
<br>




```
Procedure
---------
    1. Change your ReportService.getAllReports() to invoke a REST call
       a. Edit report.service.ts

       b. Replace your ReportService.getAllReports() method with these few lines:
            
                public getAllReports(): Observable<GetReportDTO[]> {
                
                    // Construct the URL of the REST call
                    const restUrl = environment.baseUrl + '/api/reports/all';
                
                    // Return an observable
                    return this.httpClient.get <GetReportDTO[]>(restUrl);
                }


    2. Verify it works
       a. Activate your Debugger 'Full WebApp'
       b. Go to the "View Reports" page
       c. Verify that you see the records in your database

```
