Lesson 9a:  Loading Data / Setup LoadingService & Backend REST Call
-------------------------------------------------------------------
The Google Drive link is here:<br>
https://docs.google.com/document/d/18-DOnot2MEBYn86KhhfheO9hwgNgHDsJMrh4ByvQI64/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson9a/loading-data
<br>
<br>
<br>


For these lessons, we need to setup a few things on the back-end:
1. Add Flyway to your back-end:  
   [https://github.com/traderres/webClass/blob/master/learnAngular/lessons/lesson01b_setupFlyway.txt](https://github.com/traderres/webClass/blob/master/learnAngular/lessons/lesson01b_setupFlyway.txt)

2. Add a Spring-JDBC Connection pool to your backend:  
   [https://github.com/traderres/webClass/blob/master/learnAngular/lessons/lesson01c_addSpringJdbcConnectionPool.txt](https://github.com/traderres/webClass/blob/master/learnAngular/lessons/lesson01c_addSpringJdbcConnectionPool.txt)
    
3. Create a front-end lookup service that returns hard-coded data:  
   [https://github.com/traderres/webClass/blob/master/learnAngular/lessons/lesson09a_lookupData_notes1_hardcodedData.txt](lesson09a_lookupData_notes1_hardcodedData.txt)

4. Create a backend REST call that will return real data:  
   [https://github.com/traderres/webClass/blob/master/learnAngular/lessons/lesson09a_lookupData_notes2_invokeRestCall.txt](lesson09a_lookupData_notes2_invokeRestCall.txt)

5. Change your front-end lookup service to invoke the real REST endpoint  
   [https://github.com/traderres/webClass/blob/master/learnAngular/lessons/lesson09a_lookupData_notes3_restEndpoint.txt](lesson09a_lookupData_notes3_restEndpoint.txt)



<br>
<br>
At this point, you have:<br>
- Database tables that hold lookup info<br>
- A backend REST call that returns lookup values<br>
- A frontend lookupService that invokes the REST call
