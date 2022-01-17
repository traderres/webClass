Lesson 12c:  Edit Report / Add Reactive Form
--------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1O_LSca3UzI5OicmSic4HgVaxwOcTscOWyRuMy5XAzvk/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson12c/add-reactive-form
<br>
<br>
<br>


<h3>Notes</h3>

- The "Edit Report" page is similar to the "Add Report" page.
- It's tempting to use the same page for both -- don't do it!
- It's easier to maintain the webapp when each page is independent of each other  
  - If you make changes to the "Edit Report", you do not need to re-test the "Add Report" page  
  - So, keep the pages separate


<br>
<br>

```
Procedure
---------
    1. Initialize the Reactive Form in the typescript
        a. Edit edit-report.component.ts

        b. Inject the formBuilder

        c. Add a public myForm object   (it has to be public so we can access it from the HTML)
              public myForm: FormGroup;

        d. Initialize the myForm object at the end of ngOnInit():
            
            // Initialize the reactive form
            this.myForm = this.formBuilder.group({
              report_name: [null,
                [
                Validators.required,
                Validators.minLength(2),
                Validators.maxLength(100)
                ]],
            
              source: ['',  null],
            
              priority:  ['', Validators.required]
            });


    2. Setup the dropdowns and text boxes in the "Edit Report" HTML page
        a. Edit edit-report.component.html

        b. Remove everything in the HTML file

        c. Add a simple <mat-card> tag and form tag
            
            <mat-card>
                <form novalidate autocomplete="off" [formGroup]="myForm" >
            
                     <mat-card-title>Edit Report {{this.reportId}}</mat-card-title>
            
                     <mat-card-content>
                         Card Content Goes here
                 
            
                     </mat-card-content>
                  </form>
            </mat-card>

    3. Verify that the page works
        a. Activate the debugger 'Full WebApp'
        b. Click on "View Reports"
        c. Press the "Edit" button on one of the reports
            -- You should see your simple HTML page
```
![](https://lh5.googleusercontent.com/C_Il-w8lxDeNEhgDhX8xQ0JS2EOt3UE-lMiQ9T_R_fAb6qk1f0P4BYFtzVIKtlD6tB9zX2YGW9xVW4vvmIKGz3e8PM1xzDhqJnEK32ntlsjY8IFfAXxCM5DsJG2Yw7sYG0XtiKjo)
```



    4. Add the report name text box to the page
        a. Edit edit-report.component.html

        b. Remove the message:  Card Contents Goes here

        c. Add the report text box field (inside the mat-card-content)
            <mat-form-field>
              <mat-label>Enter Report Name</mat-label>
            
              <!-- Report Name -->
              <input matInput type="text" formControlName="report_name" />
            
              <mat-error>
                Report Name is required
              </mat-error>
            </mat-form-field>


        d. Add the priority dropdown 
           NOTE:  It has hard-coded values for now.  That's OK.  
            
            <mat-form-field style="display: block">
                <mat-label>Choose Priority</mat-label>
            
                <!-- Priority Dropdown -->
                <mat-select formControlName="priority">
                <mat-option [value]=null>-Select Priority-</mat-option>
                <mat-option [value]=1>Low</mat-option>
                <mat-option [value]=2>Medium</mat-option>
                <mat-option [value]=3>High</mat-option>
                <mat-option [value]=4>Critical</mat-option>
                </mat-select>
            
                <mat-error>
                    Priority is required
                </mat-error>
            </mat-form-field>


        e. After the closing </mat-card> tag add this (so we can see the reactive form values)
            <pre>
              myForm.valid={{this.myForm.valid}}
              myForm.controls.report_name.value={{this.myForm.controls?.report_name?.value}}
              myForm.controls.report_name.errors={{this.myForm.controls?.report_name?.errors | json}}
              myForm.controls.priority.value={{this.myForm.controls?.priority?.value}}
              myForm.controls.priority.errors={{this.myForm.controls?.priority?.errors | json}}
            </pre>



    5. Verify that the page works
        a. Activate the debugger 'Full WebApp'
        b. Click on "View Reports"
        c. Press the "Edit" button on one of the reports
           -- You should see your simple HTML page
```
![](https://lh3.googleusercontent.com/izbEkCbm4_U0wAqRM0qlZK0L_cOy3okeSzukA5ke5kTDYdnBoq6kL0OHnkMhUEncXNLkUPxUB4oZw7ysZfbTrAAKMzX6wqyKQml8OtNNOL_kx1JohrAFETYmjSxdhabhn6A2J06c)
