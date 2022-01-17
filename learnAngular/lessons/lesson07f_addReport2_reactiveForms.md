Lesson 7f: Add Report2 / Form Validation with Reactive Forms
------------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1YrRwf13LPMK5VEOJE7KnbJwF9BO97RAHlyrSU2FZlK4/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson7f/reactive-forms
<br>
<br>





###Reactive Forms (also known as Model Based Forms)
Reactive forms give you a few advantages
 + Less HTML code
 + You can use built-in validators 
 + You can use make your own custom validators
 + The FormBuilder service lets you define validators and initialize a form object without having to create a separate class
 + Moving the validation logic from HTML to TypeScript gives you more power
<br>
<br>
<br>
<br>
<br>
```
Procedure
    1. Create the add-report2 component
        unix> cd ~/intellijProjects/angularApp1/frontend
        unix> ng generate component reports/add-report2


    2. Add the ReactiveFormModule to the project
        a. Edit app.module.ts

        b. Add to imports: [
                ReactiveFormsModule,
                FormsModule
            ]


    3. Add a route for the newly-created page component
        a. Edit app.module.ts

        b. Add this route:
            { path: 'page/addReport2',    component: AddReport2Component },

            
            NOTE:  Make sure any new routes you add occur  *ABOVE* or *BEFORE*
                          the path: '**', component: NotFoundComponent
            
            
            So, it should look something like this:
            
            const appRoutes: Routes = [
              { path: 'page/addReport',	component: AddReportComponent },
              { path: 'page/addReport2',	component: AddReport2Component },
              { path: 'page/viewReports',  component: ViewReportsComponent },
              { path: 'page/chart1',   	component: Chart1Component },
              { path: 'page/chart2',   	component: Chart2Component },
              { path: '',              	component: WelcomeComponent},
              { path: '**',            	component: NotFoundComponent}
            ];
            
            
            NOTE:  The NotFoundComponent is always *LAST*




    4. Add  "Add Report 2" to the navigation bar
        a. Edit navbar.component.html

        b. Add the navigation item
              <!-- Add Report 2 -->
              <mat-list-item class="navItem" [routerLink]="'page/addReport2'"
    routerLinkActive="active">
                <a title="Add Report">Add Report 2</a>
                <div fxFlex fxLayoutAlign="end end">
                  <a [routerLink]="'page/addReport2'" target="_blank">
                    <i class="fas fa-external-link-alt navItemIcon" title="Open Add Report 2 in a new window"></i>
                  </a>
                </div>
              </mat-list-item>


    5. Verify that the empty page appears 
        a. Activate the debugger
        b. Verify that you have an "Add Report 2" in the nav bar
        c. Verify that pressing "Add Report 2" shows you an empty page



    6. Add a reset() and save() methods to your add-report2.component.ts
        a. Edit add-report2.component.ts

        b. Replace  its contents with this:
                import { Component, OnInit } from '@angular/core';
        
                @Component({
                  selector: 'app-add-report2',
                  templateUrl: './add-report2.component.html',
                  styleUrls: ['./add-report2.component.css']
                })
                export class AddReport2Component implements OnInit {
        
        
                  constructor() { }
        
                  ngOnInit() {
                  }
        
                  public reset() {
                    console.log('user pressed reset');
                  }
        
                  public save() {
                    console.log('User pressed save.');
                  }
                }



    7. Setup a basic form within add-report2.component.html
        a. Edit add-report2.component.html
        b. Replace  its contents with this:
        
            <mat-card>
                  <mat-card-title>Add a Report 2</mat-card-title>
        
                  <mat-card-content>
        
                    <mat-form-field>
                        <mat-label>Enter Report Name</mat-label>
        
                 <!-- Report Name -->
                        <input matInput type="text" name="report.name"/>
                    </mat-form-field>
                    <br/>
        
                    <mat-form-field>
                      <mat-label>Choose Source</mat-label>
        
               <!-- Source -->
                      <mat-select name="report.source" >
                        <mat-option [value]=null>-Select Source-</mat-option>
                        <mat-option [value]=100>Israel</mat-option>
                        <mat-option [value]=101>United Kingdom</mat-option>
                        <mat-option [value]=102>USA</mat-option>
                      </mat-select>
                    </mat-form-field>
                    <br/>
        
                    <mat-form-field>
                      <mat-label>Choose Priority</mat-label>
        
                      <!-- Priority -->
                      <mat-select name="report.priority" >
                        <mat-option [value]=null>-Select Priority-</mat-option>
                        <mat-option [value]=1>Low</mat-option>
                        <mat-option [value]=2>Medium</mat-option>
                        <mat-option [value]=3>High</mat-option>
                        <mat-option [value]=4>Critical</mat-option>
                      </mat-select>
                    </mat-form-field>
                    <br/>
        
        
                    <mat-form-field>
                      <mat-label>Choose Authors</mat-label>
        
                      <!-- Authors -->
                      <mat-select multiple name="report.authors" >
                        <mat-option [value]=10>Adam</mat-option>
                        <mat-option [value]=11>Ben</mat-option>
                        <mat-option [value]=12>Peter</mat-option>
                        <mat-option [value]=13>Justin</mat-option>
                      </mat-select>
                    </mat-form-field>
                    <br/>
        
                    <!-- Reset and Save Buttons -->
                    <button type="button" (click)="reset()" style="margin-top: 20px"
        mat-raised-button>Reset</button>
            &nbsp;&nbsp;
                    <button type="button" (click)="save()" mat-raised-button color="primary">Save</button>
                  </mat-card-content>
        
        
            </mat-card>
            
            <pre>
            myForm.valid={{this.myForm.valid}}
            myForm.controls.report_name.errors={{this.myForm.controls?.report_name?.errors | json}}
            myForm.controls.priority.errors={{this.myForm.controls?.priority?.errors | json}}
            myForm.controls.source.errors={{this.myForm.controls?.source?.errors | json}}
            myForm.controls.authors.errors={{this.myForm.controls?.authors?.errors | json}}
            </pre>


    8. Setup  the TypeScript class to use the FormBuilder service for validation
        a. Edit add-report2.component.ts

        b. Change the constructor so that it injects the FormBuilder:

              constructor(private formBuilder: FormBuilder)
              { }


        c. Add a public myForm object:
              public myForm: FormGroup;



        d. Change the ngOnInit() to initialize the myForm object
            
              public ngOnInit(): void {
            
                this.myForm = this.formBuilder.group({
                          report_name: [null,
                            [
                              Validators.required,
                              Validators.minLength(2),
                              Validators.maxLength(100)
                            ]],
            
                          source: ['',  null],
            
                          priority:  ['', Validators.required],
            
                          authors:  ['', Validators.required]
                        });
            
              }
            
            
            NOTE:
                The 1st parameter holds an initial value
                The 2nd parameter holds the validators to apply


            So, this code would set the report_name to have an initial value
            
            this.myForm = this.formBuilder.group({
                          report_name: ['Initial Report Name',
                            [
                              Validators.required,
                              Validators.minLength(2),
                              Validators.maxLength(100)
                            ]],
            
                          source: ['',  null],
            
                          priority:  ['', Validators.required],
            
                          authors:  ['', Validators.required]
                        });
            
                      }
            



        e. Change the reset() and save() methods so that errors are highlighted/cleared
    
              public reset(): void {
                console.log('user pressed reset');
                this.myForm.reset();
              }
    
              public save(): void {
                console.log('User pressed save.');
    
                // Mark all fields as touched so the user can see any errors
                this.myForm.markAllAsTouched();
    
                if (this.myForm.invalid) {
                  // User did not pass validation so stop here
                  return;
                }
    
                // User enter valid data
                console.log('Valid data:  report_name=' +
    this.myForm.controls.report_name.value);
              }




    9. Setup the HTML to work with the FormBuilder
       LESSON:  You must have [formGroup]="myForm" in the form tag
       LESSON:  You must use formControlName=" " to it it together

        a. Edit add-report2.component.html

        b. Add an opening and closing form tag inside the <mat-card>...</mat-card> tags
           NOTE:  The novalidate stops the browser from using built-in validation
           NOTE:  The autocomplete="off" stops the browser from offering popup options in textboxes

                <form novalidate autocomplete="off" [formGroup]="myForm" >
                
        
                </form>

        c. Adjust the report name control:
                Change this:
                   <input matInput type="text" name="report.name"/>
                
                To this:
                  <input matInput type="text" formControlName="report_name" />
                

        d. Adjust the source control.
                Change this:
                   <mat-select name="report.source" >
                
                To this:
                    <mat-select formControlName="source">
                

        e. Change the priority control
                Change this:
                   <mat-select name="report.priority" >
                
                To this:
                   <mat-select formControlName="priority">

        f. Change the authors control
                Change this:
                   <mat-select multiple name="report.authors" >
                To this:
                   <mat-select multiple formControlName="authors">


    10. Add the <mat-error> tags to report name, priority, and authors
        NOTE:  The source field is *OPTIONAL* so there is no mat-error tag.

            <mat-error>
                Report Name is required
            </mat-error>
        
            <mat-error>
                Priority is required
            </mat-error>
        
            <mat-error>
                  Authors are required
            </mat-error>

            NOTE:  The <mat-error> tag must be INSIDE <mat-form-field>...</mat-form-field>



    11. Activate  the debugger
        a. Go to the Add Report 2 Page
        b. Enter just **ONE** character in the report_name textbox and press "Save"
           -- You should see that this is not valid as the report_name must be 2 characters

        c. Press "Reset"
           -- You should see all errors are cleared





When completed, add-report2.component.ts looks like this:

import { Component, OnInit } from '@angular/core';
import {FormBuilder, FormGroup, Validators} from "@angular/forms";

@Component({
  selector: 'app-add-report2',
  templateUrl: './add-report2.component.html',
  styleUrls: ['./add-report2.component.css']
})
export class AddReport2Component implements OnInit {
  public myForm: FormGroup;

  constructor(private formBuilder: FormBuilder)
  { }

  public ngOnInit() {

	this.myForm = this.formBuilder.group({
  	report_name: [null,
    	[
      	Validators.required,
      	Validators.minLength(2),
      	Validators.maxLength(100)
    	]],

  	source: ['', null],

  	priority:  ['', Validators.required],

  	authors:  ['', Validators.required]
	});

  }


  public reset() {
	console.log('user pressed reset');
	this.myForm.reset();
  }

  public save() {
	console.log('User pressed save.');

	// Mark all fields as touched so the user can see any errors
	this.myForm.markAllAsTouched();

	if (this.myForm.invalid) {
  	// User did not pass validation so stop here
  	return;
	}

	// User enter valid data
	console.log('Valid data:  report_name=' + this.myForm.controls.report_name.value);
  }

}




When completed, add-report2.component.html looks like this:

<form novalidate autocomplete="off" [formGroup]="myForm">

  <mat-card>
	<mat-card-title>Add a Report 2</mat-card-title>

	<mat-card-content>

  	<mat-form-field>
    	<mat-label>Enter Report Name</mat-label>

    	<!-- Report Name -->
    	<!-- Use the matInput for input fields inside <mat-form-field>...</mat-form-field> tags -->
    	<input matInput type="text" formControlName="report_name"/>

    	<mat-error>
      	Report Name is required
    	</mat-error>
  	</mat-form-field>
  	<br/>

  	<mat-form-field>
    	<mat-label>Choose Source</mat-label>

    	<!-- Source -->
    	<mat-select formControlName="source">
      	<mat-option [value]=null>-Select Source-</mat-option>
      	<mat-option [value]=100>Israel</mat-option>
      	<mat-option [value]=101>United Kingdom</mat-option>
      	<mat-option [value]=102>USA</mat-option>
    	</mat-select>

    	<mat-error>
      	Source is required
    	</mat-error>

  	</mat-form-field>
  	<br/>

  	<mat-form-field>
    	<mat-label>Choose Priority</mat-label>

    	<!-- Priority -->
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
  	<br/>


  	<mat-form-field>
    	<mat-label>Choose Authors</mat-label>

    	<!-- Authors -->
    	<mat-select multiple formControlName="authors">
      	<mat-option [value]=10>Adam</mat-option>
      	<mat-option [value]=11>Ben</mat-option>
      	<mat-option [value]=12>Peter</mat-option>
      	<mat-option [value]=13>Justin</mat-option>
    	</mat-select>

    	<mat-error>
      	Authors are required
    	</mat-error>
  	</mat-form-field>
  	<br/>

  	<!-- Reset and Save Buttons -->
  	<button type="button" (click)="reset()" style="margin-top: 20px" mat-raised-button>Reset</button>&nbsp;&nbsp;
  	<button type="button" (click)="save()" mat-raised-button color="primary">Save</button>
	</mat-card-content>

  </mat-card>

</form>


<pre>
  myForm.valid={{this.myForm.valid}}
  myForm.controls.report_name.errors={{this.myForm.controls?.report_name?.errors | json}}
  myForm.controls.priority.errors={{this.myForm.controls?.priority?.errors | json}}
  myForm.controls.source.errors={{this.myForm.controls?.source?.errors | json}}
  myForm.controls.authors.errors={{this.myForm.controls?.authors?.errors | json}}
 </pre>


```
