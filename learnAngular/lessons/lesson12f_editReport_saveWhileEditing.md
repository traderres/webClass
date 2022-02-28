Lesson 12f:  Edit Report / Save Automatically while Editing
-----------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1owvThBLmfpBDwdYgFK0keQwIkxANA31KUT8Z2lBh2OE/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson12f/save-while-editing
<br>
<br>
<br>

<h3> Problem Set </h3>

Problem:  I want to save all data 5 seconds (in the background) after a user makes a change<br>
Solution:  Subscribe to the formValueChanges and use 

<br>
<br>
<h3>Approach</h3>

1. Add a method called saveCurrentFormAsync()

   1. Set this.savingDataWhileEditing = true;
   2. Create a DTO of information from the reactive form (that holds all data)
   3. Manually subscribe to an observable (to invoke the update REST endpoint)
   4. In the finally block,  
      Set this.savingDataWhileEditing = false;  
        
1. In the ngOnInit() listen for valueChanges in the form  

1. In the ngOnDelete(), unsubscribe from formChangeSubscription (to prevent memory leaks)

  



<br>
<br>

```

Procedure
---------
    1. Add a front-end method to the "Edit Report" page that will save quietly in the background
        a. Edit edit-report.component.ts


        b. Add a public boolean to indicate a save operation while editing is in effect:
             public saveWhileEditingInProgress: boolean = false;


        c. Add this method:
            
              /*
               * Save the information to the back-end but to not show any popups
               */
              public saveCurrentFormAsync(): void {
            
                this.saveWhileEditingInProgress = true;
            
                // Create a DTO object to send to the back-end
                let dto: SetUpdateReportDTO = new SetUpdateReportDTO();
                dto.report_name = this.myForm.controls.report_name.value;
                dto.priority	= this.myForm.controls.priority.value;
                dto.id      	= this.reportId;
            
                this.reportService.setEditReportInfo(dto).subscribe( (response) => {
                    // The REST call came back successfully.  Do nothing.
            
                }).add( () => {
                    // The REST Call finally block
                    this.saveWhileEditingInProgress = false;
                });
            
              }  // end of saveCurrentFormAsync()
            


    2. Listen for value changes in the form
        a. Edit edit-report.component.ts


        b. Add a private subscription:
             private formChangeSubscription: Subscription;


        c. Adjust the ngOnInit() so it listens for value changes
            
           Add this block to the end of ngOnInit()
            
                // Automatically save 5 seconds after any form change
                this.formChangeSubscription = this.myForm.valueChanges
                  .pipe(
                            debounceTime(5000)		// Wait 5 seconds after a form change
                  ).subscribe( () => {
                        // User made some changes to the form.  Save the data asynchronously
                        this.saveCurrentFormAsync();
                });


        d. Change the EditReportComponent so it implements OnInit and OnDestroy


        e. Add this public method:
            
              public ngOnDestroy(): void {
                if (this.formChangeSubscription != null) {
                    // Unsubscribe to avoid memory leaks
                    this.formChangeSubscription.unsubscribe();
                }
              }




    3. Adjust the front-end to show a message while the save is in progress 
        a. Edit edit-report.component.html

        b. Add this after the Save Button

            <div *ngIf="this.saveWhileEditingInProgress" style="margin-top: 20px; display: block">
                    <!-- Save-while-editing is in progress -->
                    <span class="save-while-editing-label">Saving...</span>         	 
            </div>


    4. Add a CSS class for the save-while-editing-label
        a. Edit edit-report.component.css

        b. Add this CSS class
            
            .save-while-editing-label {
                 font-size: 20px;
                font-weight: 500;
                font-family: Roboto, "Helvetica Neue", sans-serif;
            }


    5. Verify it works
        a. Set a breakpoint in the ReportController.updateReport() java method
        b. Activate the Debugger for Full WebApp
        c. Go to "View Reports"
        d. Click the "Edit" button on one of the reports
        e. In the browser, change the report name and wait 5 seconds
           -- You should hit your breakpoint
           -- You should see the "Saving..." message appear
```
![](https://lh6.googleusercontent.com/aOH0F_Pz4cOY8ZU3ZE0sCmcG-OJ2lwf0sASGIqp7_8NBO1bOZJtdEuDHCe6VF4Gdq67vtou2v1PK7o24hgM0NrM5odVAHs76LLNB1zUvIaXTPrfbOhYGYrGyXabze94ESMqawpff)
```
NOTE:  While the REST call is running, the user sees the "Saving..." message



        f. Remove the breakpoint in the ReportController.updateReport
        g. In the browser, change the report name
           -- The save REST call runs so fast that the user sees just a flicker.

           POINT:  If the save operation is that fast, then you don't have to show a "Saving.." message at all.

```
