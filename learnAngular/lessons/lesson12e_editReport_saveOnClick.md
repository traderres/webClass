Lesson 12e:  Edit Report / Save Manually on Click
-------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1GOhXiM8TiP2TUxoo9c8qUjWHtasfzD8iuPZzIfhPnoA/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson12e/save-on-click-event
<br>
<br>


Problem: I want to invoke a REST call when the user presses "Save"<br>
Solution: Manually subscribe to invoke REST call  
  

<br>
<br>
<h3>Approach</h3>

1. Create a front-end SetUpdateReportDTO object that has all fields  

1. Add a public method to the front-end ReportService to save the data to the back-end  

1. Add a "Save" button to the "Edit Report" page  

1. Add a click handler that displays a spinner and manually subscribes to the REST call  

1. If the REST call finishes successfully, then remove the spinner and show a success message  
   NOTE: We do not need a failure message as the ErrorInterceptor catches all failed REST calls



<br>
<br>


```

Procedure
---------
    1. Create a front-end SetUpdateReportDTO class
       a. Generate the class:
          unix> cd ~/intellijProjects/angularApp1/frontend
          unix> ng generate class models/SetUpdateReportDTO --skipTests

        b. Add these fields to your class:
              public id: number; 
              public priority: number;   // holds the lookup value (not a string)
              public report_name: string;


    2. Add a method that will invoke the save-edit-report-info REST call
        a. Edit report.services.ts

        b. Inject the messageService

        c. Add this method:
            
              /*
               * Returns an observable with nothing
               * NOTE:  This method is used by the "Edit Report" page to save info
               */
              public setEditReportInfo(aData: SetUpdateReportDTO): Observable<string> {
                // Construct the URL of the REST call
                const restUrl = environment.baseUrl + '/api/reports/update/set';
            
                // Return an observable
                return this.httpClient.post(restUrl, aData, {responseType: 'text'});
              }


    3. Add the "Save" button to the "Edit Report" page
        a. Edit edit-report.component.html

        b. Add the "Save" button before the end of the <mat-card-content> section
                <!-- Save Button -->
                <button mat-raised-button color="primary" (click)="this.save()"
                                 style="display:block">Save</button>

    4. Add the save() method 
        a. Edit edit-report.component.ts


        b. Inject the messageService (in the constructor)


        c. Add the public save method
            
              /*
               * Save the information to the back-end
               */
              public save(): void {
            
                // Create a DTO object to send to the back-end
                let dto: SetUpdateReportDTO = new SetUpdateReportDTO();
                dto.report_name	 = this.myForm.controls.report_name.value;
                dto.priority		= this.myForm.controls.priority.value;
                dto.id      		= this.reportId;
            
                this.reportService.setEditReportInfo(dto).subscribe( (response) => {
                    // The REST call came back successfully
                    this.messageService.showSuccessMessage('Successfully updated the report.');
                }).add( () => {
                    // The REST Call finally block
            
                });
            
              }  // end of save()


    5. Verify it works:
        a. Activate the debugger for 'Full WebApp'
        b. Go to "View Reports"
        c. Press "Edit" on one of the reports
        d. Change the report name to something different
        e. Press "Save"
           -- If the REST call works, you should see a success message in the bottom corner
```
![](https://lh4.googleusercontent.com/_ugU1J6WVKHOK7EZxVRthffKMTUY-_SIctAwwYT9rATzAtVB5RGXnIvBzmsO_n6ASS0QXY7f_bnl83V7z9DiqwMBnMqkMP6nNMCKGvpwROsobEY3Q3CTsyA_I95cmWKN8AQopBEj)
```


        f. Go to "View Reports"
           -- You should see the report name is different




```
