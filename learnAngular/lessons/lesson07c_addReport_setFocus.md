Lesson 7c: Add Report / Set Focus to a Textbox on Page Load
-----------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1ZL7PmEY3nOYbKA5ScnL9bUVY4ZoUNN5nXwCixSpEMaA/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson7c/focus-on-pageload
<br>
<br>






```
Problem:   When the user clicks on a navigation item, the focus is not set on any textbox.  So, the user must click or tab over to a textbox first.  How do we set the focus on a specific field?
Solution:  Use setTimeout() to run something outside of Angular


Order of Operations (when a page loads)
---------------------------------------
    1. Constructor is called
       -- Dependencies/services are passed-in

    2. ngOnInit() is called
       -- At this point, this.reportNameTextbox --> undefined

    3. HTML View is created
       -- Textboxes actually exist

    4. ngAfterViewInit() is called
       -- Set the focus on my timeout
       -- this.reportNameTextbox --> points to a real textbox at this time 



Procedure
---------
    1. Make sure the input field has a template reference
         <input matInput type="text" name="report.name"  [(ngModel)]="report.name" required #name="ngModel" />


    2. Adjust the add-report.component.ts code to set the focus 
        a. Change the class to implement AfterViewInit
              export class AddReportComponent implements OnInit, AfterViewInit {


        b. Get a pointer to the template reference called #name
              @ViewChild('name',  { read: ElementRef }) reportNameTextbox: ElementRef;


        c. Create the ngAfterViewInit() method that will set the focus

              ngAfterViewInit(): void {
                  // Set the focus to the report name textbox
                  setTimeout(() => this.reportNameTextbox.nativeElement.focus(), 0);
              }




    3. Activate the debugger to see the new Report Start Date
        a. Pull Run -> Debug 'Full WebApp'
        b. Click on "Add Report"
           -- The Report name textbox should have the focus



POP QUIZ:  Why did we set the focus in ngAfterViewInit()...?   Why not put this code in ngOnInit()...?








When finished, the add-report.component.ts looks like this:

import {AfterViewInit, Component, ElementRef, OnInit, ViewChild} from '@angular/core';
import {NgForm} from "@angular/forms";

export class Report {
  name: string | null;
  priority: number | null;
  source: number | null;
  authors: string | null;
  start_date: Date | null;
  end_date: Date | null;
}

@Component({
  selector: 'app-add-report',
  templateUrl: './add-report.component.html',
  styleUrls: ['./add-report.component.css']
})
export class AddReportComponent implements OnInit, AfterViewInit {
  @ViewChild('name',  { read: ElementRef }) reportNameTextbox: ElementRef;

  public formSubmitted: boolean = false;
  public report: Report;
  public defaultReportStartDate: Date = this.getFirstDayOfPreviousMonth();

  constructor() { }

  ngAfterViewInit(): void {
	// Set the focus to the report name textbox
	setTimeout(() => this.reportNameTextbox.nativeElement.focus(), 0);
  }


  private getFirstDayOfPreviousMonth(): Date {
	let now = new Date();
	let firstDayPrevMonth = new Date(now.getFullYear(), now.getMonth() - 1, 1);
	return firstDayPrevMonth;
  }


  ngOnInit(): void {
	// Initialize the report object
	this.report = new Report();
	this.report.name = null;
	this.report.priority = null;
	this.report.source = null;
	this.report.authors = null;
	this.report.start_date = this.getFirstDayOfPreviousMonth();
	this.report.end_date = null;
  }

  public reset(aForm:  NgForm): void {
	// Reset the form back to pristine/untouched condition
	aForm.resetForm();

	this.report.start_date = this.getFirstDayOfPreviousMonth();

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




When finished, the add-report.component.html looks like this:

<mat-card>
  <mat-card-title>Add a Report</mat-card-title>

  <mat-card-content>

	<form #form="ngForm" novalidate autocomplete="off">

  	<mat-form-field>
    	<mat-label>Enter Report Name</mat-label>

    	<!-- Use the matInput for input fields inside <mat-form-field>...</mat-form-field> tags -->
    	<input matInput type="text" name="report.name"  [(ngModel)]="report.name" required #name="ngModel" />

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

  	<mat-form-field style="margin-top: 20px;">
    	<mat-label>Report Start Date</mat-label>

    	<div class="date_container">
      	<input  matInput name="start.date" [(ngModel)]="report.start_date"
              	[matDatepicker]="startDatePicker" required>
      	<mat-datepicker-toggle [for]="startDatePicker"></mat-datepicker-toggle>
      	<mat-datepicker #startDatePicker  [startAt]="defaultReportStartDate"></mat-datepicker>
    	</div>

    	<mat-error>
      	<!-- This mat-error tag is displayed if this form field is invalid AND touched -->
      	Report Start Date is Required
    	</mat-error>

  	</mat-form-field>


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
