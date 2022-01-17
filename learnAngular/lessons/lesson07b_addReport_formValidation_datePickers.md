Lesson 7b: Add Report / Form Validation / Date Pickers
------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1R7ODgft6i2mOqFl0JMLum1ckEs94RbCMgJ0wU7j2QY0/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson7b/date-pickers
<br>
<br>






In this lesson, you will add two Angular Material Date Pickers and validate it
![](https://lh4.googleusercontent.com/E10OBDz1RjYLfo6ZKC0-9OEzYi3T2yLlQqErBYTOawZISExqMf-QBq30OhoIlb8Y8q2giAQBrICc8zCcP1E-12nnIwWsall-LkfqKUAHFVqjK2puDnFXsWQDExmlluodOaC-mFse)

```

The Material Date Picker is a combination of 3 elements:
    • The popup date selector
    • The textbox that stores the selected date
    • The date icon (that opens/closes the popup date selector)


Procedure
---------
    1. Import Angular material datepicker module
        a. Edit app.module.ts

        b. Add this to this imports:
        
              import {MatDatepickerModule} from "@angular/material/datepicker";
              import {MatNativeDateModule} from "@angular/material/core";
             
        c. Add this to the imports section:
    
              imports: [
                  . . .
                 MatDatepickerModule,
                 MatNativeDateModule
              ]
            
            
            NOTE:  If you see errors in your app.module.ts, then 
              A) Delete the frontend/node_modules/ directory    (and all of its sub-directories)
              B) Right-click on the frontend/package.json -> Run 'npm install'
              C) Wait for IntelliJ to finish reindexing
              D) Return to the app.module.ts 
                   -- The errors should be gone


    2. Add this CSS class to the frontend/src/styles.css
        .date_container {
          float: left;
          display: flex;
          align-items: center;
        }

    3. Add the start_date to the Report model
        a. Edit add-report.component.ts

        b. Modify the Report class so that it has this field:
               start_date: Date | null;
                     
            So, the Report class should look like this:
                export class Report {
                  name: string | null;
                  priority: number | null;
                  source: number | null;
                  authors: string | null;
                  start_date: Date | null;
                }
    


        c. Initialize the report.start_date in the ngOnInit
            this.report.start_date = null;
            
            So, the ngOnInit() method looks like this:
                    ngOnInit(): void {
                        // Initialize the report object
                        this.report = new Report();
                        this.report.name = null;
                        this.report.priority = null;
                        this.report.source = null;
                        this.report.authors = null;
                        this.report.start_date = null;
                    }


    4. Add a start-report-date date picker to the add-report.component.html
       NOTE:  We use the date_container so that the date toggle appears on the *same* line as the date
        a. Edit add-report.component.html

        b. Add this after the "Choose Authors" and before the page buttons
                
                <mat-form-field style="margin-top: 20px;">
                        <mat-label>Report Start Date</mat-label>
                
                        <div class="date_container">
                          <input  matInput name="start.date" [(ngModel)]="report.start_date"
                                                [matDatepicker]="startDatePicker" required>
                             <mat-datepicker-toggle [for]="startDatePicker"></mat-datepicker-toggle>
                             <mat-datepicker #startDatePicker></mat-datepicker>
                        </div>
                
                        <mat-error>
                          <!-- This mat-error tag is displayed if this form field is invalid AND touched -->
                          Report Start Date is Required
                        </mat-error>
                
                 </mat-form-field>
                 <br/>




    5. Activate the debugger to see the new Report Start Date
        a. Pull Run -> Debug 'Full WebApp'
        b. Click on "Add Report"
            -- You should see a Report Start Date with date-picker
        c. Press "Save"
            -- The date picker should show-up with a warning (as it's a required field)
```
![](https://lh6.googleusercontent.com/_hlvQtJTpv4Hx4JDxg0MuQh3Cm1GbmxizfmomCFZO-BnCae1nF5gRwyBzdxjTjTw9GWdKfNSWQWQeRMeeuCQ407N-Z48bc2keoYSUrcyWKTSRmouadUX6bcl_UNtcllXWBgt-Fgd)
```
Now, there is a "Report Start Date" and a date-picker button

 



    6. Add Report End Date field (positioned to the right of the Report Start Date)
        a. Add end_date to the Report class (in add-report.component.ts)
            
            export class Report {
                      name: string | null;
                      priority: number | null;
                      source: number | null;
                      authors: string | null;
                      start_date: Date | null;
                      end_date: Date | null;
            }

        b. Edit the ngOnInit() method to initialize the end_date to null;

            ngOnInit(): void {
                // Initialize the report object
                this.report = new Report();
                this.report.name = null;
                this.report.priority = null;
                this.report.source = null;
                this.report.authors = null;
                this.report.start_date = null;
                this.report.end_date = null;
            }    


        c. Edit add-report.component.html and add this 2nd date control after the Report Start Date

              <mat-form-field style="margin-left: 40px">
                <mat-label>Report End Date</mat-label>
        
                <div class="date_container">
                  <input  matInput name="end.date" [(ngModel)]="report.end_date"
        [matDatepicker]="endDatePicker" required>
                  <mat-datepicker-toggle [for]="endDatePicker"></mat-datepicker-toggle>
                  <mat-datepicker #endDatePicker></mat-datepicker>
                </div>
        
                <mat-error>
                  <!-- This mat-error tag is displayed if this form field is invalid AND touched -->
                  Report End Date is Required
                </mat-error>
        
              </mat-form-field>
              <br/>

        d. Remove the <br/> tag between the Report Start Date and Report End Date





    7. Activate the debugger to see the new Report Start Date
        a. Pull Run -> Debug 'Full WebApp'
        b. Click on "Add Report"
            -- You should see a Report Start Date with date-picker
            -- You should see a Report End Date with date-picker
```
![](https://lh5.googleusercontent.com/04lmixj1rKMyESWEDNoEngCZEuK6rsI6YKsjodwpga2ntf2Etthklr8B88B4SsaxyqHy-8XT8QU9vH6mu53PCAEpZMOdMSmshMwY118x-Vcd-vw3xsTg1Iiz0NxyVTLPEURL6E2I)
```
Now, there are Report Start Date and Report End Date fields.  And, both are required.




    8. Set an initial default value for the start date to be the 1st day of the previous month 
       NOTE:  When the user clicks on the date-picker, this day will be selected
              But, this will not show-up in the textbox

        a. Add this code to add-report.component.ts
              public defaultReportStartDate: Date = this.getFirstDayOfPreviousMonth();

        b. Add this method to add-report.component.ts
              private getFirstDayOfPreviousMonth(): Date {
                  let now = new Date();
                  let firstDayPrevMonth = new Date(now.getFullYear(), now.getMonth() - 1, 1);
                  return firstDayPrevMonth;
              }

        c. Use the defaultReportStartDate in add-report.component.html

            Change the Report Start Date from this: 
               <mat-datepicker #startDatePicker></mat-datepicker>
            
            To this:
               <mat-datepicker #startDatePicker [startAt]="this.defaultReportStartDate">
                </mat-datepicker>


    9. Activate the debugger to see the new Report Start Date
        a. Pull Run -> Debug 'Full WebApp'
        b. Click on "Add Report"
        c. Press the "Report Start Date"
            -- By default the first day of the previous month should be selected

            PROBLEM: The default start date is *NOT* visible in the text box  (so it's not that great)



    10. Set the Report Start Date to show the defaultReportStartDate in the date-picker textbox
        a. Change ngOnInit() to set the start_date
            
            Change this:
                this.report.start_date = null;

            To this:
                this.report.start_date = this.getFirstDayOfPreviousMonth();

        b. Change the reset method so that it sets the start_date to the first day of the previous month
            public reset(aForm:  NgForm): void {
                this.formSubmitted = false;
        
                // Reset the form back to pristine/untouched condition
                aForm.resetForm();
        
                this.report.start_date = this.getFirstDayOfPreviousMonth();
              }



    11. Activate the debugger to see the new Report Start Date
        a. Pull Run -> Debug 'Full WebApp'
        b. Click on "Add Report"
        c. Press the "Report Start Date"
           -- By default the first day of the previous month should be selected
           -- You should see the first day of the previous month in the text box
```
![](https://lh4.googleusercontent.com/ac4teIPJtUoO2OCK7AQjQRLQ_7a2zwzN_9UnbaVIGmtsmeuvorD-usRzCNS-3G92B_wtI5oTyGG5bYSqJt8dRZZPGVVRM6oE7EeEDGkDNcjPmF4wI-xdlVvEADOU-oxnRy04cW7V)
```
Notice that the Report Start Date has an initial value of the first day of the previous month



```
