Lesson 7a: Add Report / Form Validation / HTML Templates
--------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1nxDXDhHqOUX71Nkj-p071rY4A6fI7LR3ZbWvhXwhfH0/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson7a/html-templates
<br>
<br>

###Form Validation Approaches
1\. Using HTML Templates
+ Requires the <b>FormsModule</b> (in the app.module.ts)
+ It's familiar
+ Simple to implement:  We if statements to the html
+ Works well with few controls
- MAJOR WEAKNESS:  For large forms, the HTML code turns into a mess
<br>
<br>

2\. Using Reactive Forms  (also known as Model-Based Forms)
+ Requires the <b>ReactiveFormsModule</b> (in the app.module.ts)
+ More complicated implementation:  We have a form object and bind controls to it
+ As form becomes more complex, it's easier to maintain (as the HTML is simple)
+ Lots of power
+ Easy to test (as you are testing TypeScript code)
- Requires more TypeScript code  (but not as bad using the FormBuilder service)
<BR>
<BR>

Add Report Form on Initial Page Load
![](https://lh4.googleusercontent.com/UPv56SDE_GtyOYbqnj_AgyBc3CTnhxb-2u-w5MkkzpNDE28OfmfO-LnmMvCCw5Te0I5gPapMk3uB_RnETDnxaPBDEcrEgkvwd9NveJbjmpCsO24zNZS9fUHkYpsr2YK8OEKsdHN4)
<br>
<br>
<br>
Add Report Form after user presses "Save"
![](https://lh3.googleusercontent.com/6Xkzj4-grVbgbjADjVspkA-deCFrPZA25wbFOP3r9Z375_Lp9hKmD19vINlVr-e_8nVM6fATQzNKcW8q_NHznaiO6B5O__MnbE2qplXf_0B3SgxJAcQHdpxv4t47A-wLO19mBMVc)
Notice that the "Report name is required" and "Priority is required" show up in red.
<br>
<br>
Be aware that errors show up when a field has been <b>touched</b>.  So, we have to have the "Save" button touch all fields for messages to appear.
<br>
<br>
<br>


```
Procedure
---------
    1. Edit the fields in the add-report.component.html

        a. Add the form tag WITHIN the mat-card-content tags

            NOTE:  We add a template reference variable called "form" that points to this form

            <mat-card-content>
                       <form #form="ngForm" novalidate autocomplete="off">
            
                    <!-- Existing HTML is here -->
            
                </form>
            </mat-card-content>


        b. Make the report name textbox a *required* field and set a custom error message
            
            Change the input field from this:
                <input matInput type="text" name="report.name"  [(ngModel)]="report.name""/>
            
            To this:
                <input matInput type="text" name="report.name"  [(ngModel)]="report.name" required />
            
                <mat-error>
                            <!-- This mat-error tag is displayed if this form field is invalid AND touched -->
                                Report Name is required
                </mat-error>
            
                NOTE:  The <mat-error> tag must be placed INSIDE the <mat-form-field> tag


        c. Make the priority dropdown a *required* field
                       
            Change the <mat-select> tag from this:
                <mat-select name="report.priority" [(ngModel)]="report.priority">
            
            To this:
            <mat-select name="report.priority" [(ngModel)]="report.priority" required>
                <mat-option [value]=null>-Select Priority-</mat-option>
                <mat-option [value]=1>Low</mat-option>
                <mat-option [value]=2>Medium</mat-option>
                <mat-option [value]=3>High</mat-option>
                <mat-option [value]=4>Critical</mat-option>
            </mat-select>
            
            <mat-error>
                <!-- This mat-error tag is displayed if this form field is invalid AND touched -->
                Priority is required
            </mat-error>


        d. Change the Reset button so that the click event takes-in the form variable
            
            Change the button tag from this:
                <button type="button" (click)="reset()" style="margin-top: 20px" mat-raised-button>Reset</button>
            
            To this:
                <button type="button" (click)="reset(form)" style="margin-top: 20px" mat-raised-button>Reset</button>
            
            NOTE:  The form variable is defined at the top:
                <form #form="ngForm" novalidate autocomplete="off">
            

        e. Change the Save button so that the click event takes-in the form variable
            
            Change the button tag from this:
                <button type="button" (click)="save()" mat-raised-button color="primary">Save</button>
            
            To this:
                <button type="button" (click)="save(form)" mat-raised-button color="primary">Save</button>


        f. Change a diagnostic <pre>...</pre> tag to the end to show if the form is invalid
            <pre>
                  report={{report | json}}
                 form.invalid={{form.invalid}}
            </pre>


    2. Change the add-report.component.ts so that the form object is passed-in on the reset() and save() methods
        a. Edit add-report.component.ts

        b. Change the reset method so that the form object is passed-in
            
             public reset(aForm:  NgForm): void {
                        // Reset the form back to pristine/untouched condition
                        aForm.resetForm();
            }


        c. Change the save() method so that the form object is passed-in
            
            public save(aForm: NgForm): void {
                        if (aForm.valid) {
                            // Invoke a service to save the record
                            console.log("Save record.");
            
                            // Reset the form
                            aForm.resetForm();
                        }
            }
            



    3. Change the component and HTML so that the Report Model fields can be null
        a. Edit add-report.component.ts

        b. Change the Report model to allow for null fields
           export class Report {
              name: string | null;
              priority: number | null;
              source: number | null;
              authors: string | null
            }    

        c. Change the AddReportComponent.ngOnInit() so that unset values are null
          ngOnInit(): void {
            // Initialize the report object
            this.report = new Report();
            this.report.name = null;
            this.report.priority = null;
            this.report.source = null;
            this.report.authors = null;
         } 

        d. Change the priority dropdown in add-report.component.html so that null is the default value         by changing the <mat-option> tags so that it uses [value]=null   

            Change the priority dropdown to this:
                <mat-select name="report.priority" [(ngModel)]="report.priority" required>
                    <mat-option [value]=null>-Select Priority-</mat-option>
                    <mat-option [value]=1>Low</mat-option>
                    <mat-option [value]=2>Medium</mat-option>
                    <mat-option [value]=3>High</mat-option>
                    <mat-option [value]=4>Critical</mat-option>
                </mat-select>

        e. Change the Report source dropdown so that null is the default value
            
            Change the source dropdown to this:
                <select matNativeControl name="report.source" [(ngModel)]="report.source">
                    <option [value]=null>-Select Source-</option>
                    <option [value]=100>Israel</option>
                    <option [value]=101>United Kingdom</option>
                    <option [value]=102>USA</option>
                </select>  
   
    4. Activate the debugger to see if form field validation shows when a field is touched and left empty
        a. Pull Run -> Debug 'Full WebApp'
        b. Click on "Add Report"
        c. Type-in a name in the report-name and then clear it out (so it's touched and empty)
           -- You should see the "Name is required"  





Problem:  If you enter the page and press "Save", the user does not see the error messages<br>
          (because the form fields were not touched)
LESSON:   <mat-error> tags appear when the fields are **TOUCHED**


    5. Change the save() button so that press "Save" causes the errors to appear on the page
        a. Edit add-report.component.ts
        b. Change the save() method by adding these lines:
        
            // Make all form fields as touched -- so that error validation displays
            aForm.form.markAllAsTouched();


        When completed, the save() method should look like this:
    
            public save(aForm: NgForm): void {
                // Mark all form fields as touched -- so that error validation displays
                aForm.form.markAllAsTouched();
    
                if (aForm.valid) {
                    // Invoke a service to save the record
                    console.log("Save record.");
    
                    // Reset the form
                    aForm.resetForm();
                }
            }


    6. Activate the debugger to see if error messages appear when a user presses "Save" on page load
        a. Pull Run -> Debug 'Full WebApp'
        b. Click on "Add Report"
        c. Press "Save" [without clicking on any fields so all fields are untouched]
            -- You should see the error messages -- e.g., "Report Name is required"
```
![](https://lh3.googleusercontent.com/ndtZQZlVDtJrl0Y-mM-lp74DRYFHeHzBoupBkcOH1ihdyeqkGSKtrpOwXIlxIFaO6ZcJDgD7vzlFqGFO73eFpx2WuK5lV3qpx_lC4-aNe9xxSCZR3Odcj3MnfTyZYzNvS7_MEmP8)
```


        d. Press "Reset"
            -- It should clear all of the errors  
```
![](https://lh5.googleusercontent.com/3BMtumUhcKatM1W_LKy_uKzrchaIKLmavDM2GuDt8HyUffTlzQ5YGcgpOC98B2UKCF4VDzkIc3m4zj-KJtXNa-WlqZEwaIysRsK_r84lWlaxqSAQgOkeB6fmGo6R5e8mtI1IAsuY)
```




Part 2:  Change the Save button behavior so Save button is disabled after showing errors
----------------------------------------------------------------------------------------
In part 2, we will change the "Save" button so that pressing "Save" on page load does the following:
    A. User presses "Save"
        -- Error messages appear
        -- Save button is disabled
    B. User fills-in required fields
    C. When all required fields are filled-in, the Save button is enabled


Procedure
---------
    1. Edit app-report.component.ts
        a. Add a boolean flag to the add-report.component.ts
              public formSubmitted: boolean = false;

        b. Change the save() method to reset the formSubmitted flag
            
            Change the save() method to this:
                     public save(aForm: NgForm): void {
                        this.formSubmitted = true;
            
                        // Make all form fields as touched -- so that error validation displays
                        aForm.form.markAllAsTouched();
            
                        if (aForm.valid) {
                          // Invoke a service to save the record
                          console.log("Save record.");
            
                          // Reset the form
                          aForm.resetForm();
                          this.formSubmitted = false;
                        }
                     }


        c. Change the reset() method to reset the flag
                  public reset(aForm:  NgForm): void {
                    // Reset the form back to pristine/untouched condition
                    aForm.resetForm();
        
                    this.formSubmitted = false;
                  }   


    2. Edit the save button disabled property
        a. Edit add-report.component.html

        b. Adjust the "Save" button so it's disabled if the user has submitted the form once and there are warnings by adding this to the "Save" button tag:
                
                Change the button tag from this:
                <button type="button" (click)="save(form)" mat-raised-button color="primary">Save</button>
                
                To this:
                <button type="button" (click)="save(form)" mat-raised-button color="primary"     [disabled]="this.formSubmitted && form.invalid">Save</button>
                      
                      
    
    3. Activate the debugger to see if error messages appear when a user presses "Save" on page load
        a. Pull Run -> Debug 'Full WebApp'
        b. Click on "Add Report"
        c. Press "Save" [without clicking on any fields so all fields are untouched]
            -- You should see the error messages -- e.g., "Name is required"
            -- Now, the "Save" button is disabled (until all form errors are resolved)
        d. Fill-in the required fields
            -- When all required fields are filled-in, the "Save" button should be enabled
```
![](https://lh3.googleusercontent.com/dHsKUzuB_MIdazWwprc_c9xMmjtdYoaceqAckqT2Hmm-sKzEXeb8qumwj_w1D7cfM_uuu-b1nLvVsv0LOmTk-x1YQzOdHT-kAlqZH-vSIjPYqcww_xWxkdFJXwGcbjHekOakRJ2_)
```
Pressing "Save" show the errors -- but the "Save" button is disabled until all required fields are provided



   
   
Part 3:  Change the Appearance of the mat-form-field Tag
--------------------------------------------------------
The mat-form-field tag has 4 built-in provided appearances.  You can see them by setting appearance=" "

Procedure
    1. Set 4 mat-form-field tags to show different appearances
        a. Edit add-report.component.html
        b. Edit the report name <mat-form-field> tag so it has appearance="fill"
            
            Change this:
               <mat-form-field>
            
            To this:
               <mat-form-field appearance="fill">

        c. Edit the 2nd <mat-form-field> tag so it has appearance="standard"
        d. Edit the 3rd <mat-form-field> tag so it has appearance="legacy"
        e. Edit the 4th <mat-form-field> tag so it has appearance="outline"
  
    2. Activate the debugger to view the different appearances
        a. Pull Run -> Debug 'Full WebApp'
        b. Click on "Add Report"
```
![](https://lh6.googleusercontent.com/AKzHqZONgudm-1EpRyRzFxDpC8O6c25Xg5XiWYEOcu-N4DETQsBJTwBaTnDUMFstyAtxMNOHcCfb62IyXv_3y8vN8qcFYDaXNKsAhN9rMJb68UQErXm7fhUdYfUjP9PJDaw42ScM)
```
NOTE:  Put the mouse pointer over each form field and you will see different hovering effects




    3. Set a default appearance for *ALL* mat-form-field tags in your webapp
        a. Edit add-report.component.html
        b. Remove all of the appearance=" " tags from the page

        c. Edit app.module.ts
        d. Add this to the providers section:
                
                providers: [ 
                   { provide: MAT_FORM_FIELD_DEFAULT_OPTIONS, useValue: { appearance: 'outline' } } 
                ],
                       
	
    4. Activate the debugger to view the different appearances
        a. Pull Run -> Debug 'Full WebApp'
        b. Click on "Add Report"
            -- You should see all mat-form-field tags as outline
```
![](https://lh4.googleusercontent.com/DXjZ5y1-2SSsdaiy7rPEgB6bJQgjY0GJcVR__o9jxrrraWA1EtUozBM0gEH_HZ8F5cg6AhJ-sAAuZiCapfLn1yuOB_evLBhzsfV6NeXgzuoYqKPLnnOdYmjxIgCSllyG3XG7ihoh)
```
NOTE:  All of the mat-form-field tags are using the outline appearance




    5. Set the default appearance for all mat-form-field tags as standard
        a. Edit app.module.ts

        b. Change the providers to this:

            providers: [
              { provide: MAT_FORM_FIELD_DEFAULT_OPTIONS, useValue: { appearance: 'standard' } }
            ],


    6. Activate the debugger to view the different appearances
        a. Pull Run -> Debug 'Full WebApp'
        b. Click on "Add Report"
            -- You should see all mat-form-field tags as the standard look



Lessons:
    • You can set default appearance for all mat-form-field tags in app.module.ts
    • Individual pages can override the value by using appearance="outline"


At the end of the lesson, add-report.component.ts looks like this:
    
    
    import { Component, OnInit } from '@angular/core';
    import {NgForm} from "@angular/forms";
    
    export class Report {
      name: string | null;
      priority: number | null;
      source: number | null;
      authors: string | null
    }
    
    @Component({
      selector: 'app-add-report',
      templateUrl: './add-report.component.html',
      styleUrls: ['./add-report.component.css']
    })
    export class AddReportComponent implements OnInit {
      public formSubmitted: boolean = false;
      public report: Report;
    
      constructor() { }
    
      ngOnInit(): void {
        // Initialize the report object
        this.report = new Report();
        this.report.name = null;
        this.report.priority = null;
        this.report.source = null;
        this.report.authors = null;
      }
    
      public reset(aForm:  NgForm): void {
        // Reset the form back to pristine/untouched condition
        aForm.resetForm();
    
        this.formSubmitted = false;
      }
    
      public save(aForm: NgForm): void {
        this.formSubmitted = true;
    
        // Make all form fields as touched -- so that error validation displays
        aForm.form.markAllAsTouched();
    
        if (aForm.valid) {
        // Invoke a service to save the record
        console.log("Save record.");
    
        // Reset the form
        aForm.resetForm();
        this.formSubmitted = false;
        }
      }
    
    
    }


At the end of the lesson, add-report.component.html looks like this:
    
    <mat-card>
      <mat-card-title>Add a Report</mat-card-title>
    
      <mat-card-content>
    
        <form #form="ngForm"  novalidate autocomplete="off" >
    
        <mat-form-field>
            <mat-label>Enter Report Name</mat-label>
    
            <!-- Use the matInput for input fields inside <mat-form-field>...</mat-form-field> tags -->
            <input matInput type="text" name="report.name"  [(ngModel)]="report.name" required/>
    
            <mat-error>
            <!-- This mat-error tag is displayed if this form field is invalid AND touched -->
            Report Name is required
            </mat-error>
        </mat-form-field>
        <br/>
    
        <mat-form-field>
            <mat-label>Choose Source</mat-label>
    
            <!-- Use the matNativeControl for select and input fields inside <mat-form-field>...</mat-form-field> tags -->
            <select matNativeControl name="report.source" [(ngModel)]="report.source">
            <option [value]=null>-Select Source-</option>
            <option [value]=100>Israel</option>
            <option [value]=101>United Kingdom</option>
            <option [value]=102>USA</option>
            </select>
        </mat-form-field>
        <br/>
    
        <mat-form-field>
            <mat-label>Choose Priority</mat-label>
    
            <!-- Priority Dropdown -->
            <mat-select name="report.priority" [(ngModel)]="report.priority" required>
            <mat-option [value]=null>-Select Priority-</mat-option>
            <mat-option [value]=1>Low</mat-option>
            <mat-option [value]=2>Medium</mat-option>
            <mat-option [value]=3>High</mat-option>
            <mat-option [value]=4>Critical</mat-option>
            </mat-select>
    
            <mat-error>
            <!-- This mat-error tag is displayed if this form field is invalid AND touched -->
            Priority is required
            </mat-error>
        </mat-form-field>
        <br/>
    
    
        <mat-form-field>
            <mat-label>Choose Authors</mat-label>
    
            <!-- Multiple Select -->
            <mat-select multiple name="report.authors" [(ngModel)]="report.authors">
            <mat-option value="10">Adam</mat-option>
            <mat-option value="11">Ben</mat-option>
            <mat-option value="12">Peter</mat-option>
            <mat-option value="13">Justin</mat-option>
            </mat-select>
        </mat-form-field>
        <br/>
    
        <!-- Reset and Save Buttons -->
        <button type="button" (click)="reset(form)" style="margin-top: 20px" mat-raised-button>Reset</button>
        &nbsp;&nbsp;
        <button [disabled]="this.formSubmitted && form.invalid" type="button" (click)="save(form)" mat-raised-button color="primary">Save</button>
        </form>
    
      </mat-card-content>
    </mat-card>
    
    
    <pre>
      report={{report | json}}
    
      form.invalid={{form.invalid}}
    </pre>

```
