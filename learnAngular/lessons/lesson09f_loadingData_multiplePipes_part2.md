Lesson 9f:  Loading Data / Multiple Async Pipes / Part 2
--------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/111Kj9qIrHr_X1hiPzrU-x6slGq3oxahv7AF154-jcuk/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson9f/multiple-async-pipes-complex
<br>
<br>
<br>

<h3> Problem Set </h3>

Problem: We have multiple async pipe variables all over the add-report2.component.html

Solution: Create a single variable called "data" that holds all 3 async pipes<br>
- data.report_sources hold the report sources  
- data.priorities holds the priorities  
- data.authors holds the authors

<br>
<br>
<h3>Big advantage: The 3 async pipes run in parallel</h3>

```

  <!-- Subscribe to Multiple Observables -->
  <ng-container *ngIf="
   {
      report_sources: reportSourceObs | async,
      authors: authorsObs | async,
      priorities: prioritiesObs | async
   } as data;">

         <!-- Inside here, we have data.report_sources, data.priorities, and data.authors -->

  </ng-container>
```
<br>
<br>
<h3>Lousy Alternative:  Using nested ng-container tags but this runs the REST calls in series</h3>

 - So, report_source is loaded, then authors is loaded, then priorities is loaded
 - And, the user WAITS longer

 
<br>
<br>

```
Procedure
---------
    1. Create a single html variable called data that holds all 3 Async Pipe variables
        a. Edit add-report2.component.html

        b. Add an <ng-container> tag that surrounds the mat-card tag
           This ng-container tag subscribes to *multiple* observables

              <!-- Subscribe to Multiple Observables -->
              <ng-container *ngIf="
               {
                  report_sources: reportSourceObs | async,
                  authors: authorsObs | async,
                  priorities: prioritiesObs | async
               } as data;">
            
              
                 <!-- Inside here, we have data.report_sources, data.priorities, and data.authors -->
                 <mat-card>
            
                    <!-- Existing mat-card code here -->
            
                </mat-card>         
                  
              </ng-container>
              


        c. Within this new <ng-container>...</ng-container>, place the dropdown code
            data.report_sources==false means that the report_sources are still loading
            data.report_sources==true  means that the report_sources are loaded
            
            data.priorities==false means that the priorities are still loading
            data.priorities==true  means that the priorities are loaded
            
            data.authors==false    means that the authors are still loading
            data.authors==true     means that the authors are loaded


        So, the wrapper for Report Sources should look like this:
        
            <ng-container *ngIf="data.report_sources; else loadingReportSources">
                        <!-- Report Sources are loaded -->
                        <mat-form-field style="margin-top: 20px">
                            <mat-label>Choose Source</mat-label>
            
                            <!-- Report Sources Dropdown -->
                            <mat-select formControlName="source">
                                <mat-option [value]=null>-Select Source-</mat-option>
                                <mat-option *ngFor="let source of data.report_sources"  value="{{source.id}}">{{source.name}}</mat-option>
                            </mat-select>
            
                            <mat-error>
                                Source is required
                            </mat-error>
                        </mat-form-field>
            </ng-container>


        d. Adjust the ng-container wrapper for priorities to use data.priorities

        e. Adjust the ng-container for authors to use data.authors


    2. Verify it works
        a. Activate the Debugger
        b. Go to the "Add Report 2" page
           -- You should see the 3 dropdowns loaded (after waiting 5 seconds)



When completed, the add-report2.component.html should look something like this:

<!-- Subscribe to Multiple Observables -->
<ng-container *ngIf="
   {
      	report_sources: reportSourceObs | async,
      	authors: authorsObs | async,
      	priorities: prioritiesObs | async
   } as data;">


   <mat-card>
  	<mat-card-title>Add a Report 2</mat-card-title>

  	<form novalidate autocomplete="off" [formGroup]="myForm" >

     	<mat-card-content>

      	<mat-form-field>
        	<mat-label>Enter Report Name</mat-label>

        	<!-- Use the matInput for input fields inside <mat-form-field>...</mat-form-field> tags -->
        	<input matInput type="text"  formControlName="report_name" />

        	<mat-error>
            	Report Name is required
        	</mat-error>
      	</mat-form-field>
      	<br/>

       	<ng-container *ngIf="data.report_sources; else loadingReportSources">
         	<!-- Report Sources are loaded -->
         	<mat-form-field style="margin-top: 20px">
           	<mat-label>Choose Source</mat-label>

           	<!-- Report Sources Dropdown -->
           	<mat-select formControlName="source">
             	<mat-option [value]=null>-Select Source-</mat-option>
             	<mat-option *ngFor="let source of data.report_sources"  value="{{source.id}}">{{source.name}}</mat-option>
           	</mat-select>

           	<mat-error>
             	Source is required
           	</mat-error>
         	</mat-form-field>
       	</ng-container>

       	<ng-template #loadingReportSources>
         	<!-- Report Sources are loading message -->
         	<p style="margin-top: 20px"><i class="fa fa-spin fa-spinner"></i> Loading Report Sources...</p>
       	</ng-template>

      	<br/>


       	<ng-container *ngIf="data.priorities; else loadingPriorities">
         	<!-- Priorities are fully loaded -->
         	<mat-form-field style="margin-top: 20px">
           	<mat-label>Choose Priority</mat-label>

           	<!-- Priorities Drop Down -->
           	<mat-select formControlName="priority">
             	<mat-option [value]=null>-Select Priority-</mat-option>
             	<mat-option *ngFor="let priority of data.priorities"  value="{{priority.id}}">{{priority.name}}</mat-option>
           	</mat-select>

         	</mat-form-field>
       	</ng-container>

       	<ng-template #loadingPriorities>
         	<!-- Priorities are loading message -->
         	<p style="margin-top: 20px"><i class="fa fa-spin fa-spinner"></i> Loading Priorities...</p>
       	</ng-template>
      	<br/>


       	<ng-container *ngIf="data.authors; else loadingAuthors">
         	<!-- Authors are loaded -->
         	<mat-form-field style="margin-top: 20px">
           	<mat-label>Choose Authors</mat-label>

           	<mat-select multiple formControlName="authors">
             	<mat-option *ngFor="let author of data.authors"  value="{{author.id}}">{{author.name}}</mat-option>
           	</mat-select>

           	<mat-error *ngIf="myForm.controls?.authors?.errors?.required">
             	Authors are required
           	</mat-error>

           	<mat-error *ngIf="myForm.controls?.authors?.errors?.custom_error">
             	{{myForm.controls?.authors?.errors?.custom_error}}
           	</mat-error>

         	</mat-form-field>
       	</ng-container>

       	<ng-template #loadingAuthors>
         	<!-- Authors are loading message -->
         	<p style="margin-top: 20px"><i class="fa fa-spin fa-spinner"></i> Loading Authors...</p>
       	</ng-template>
      	<br/>

      	<!-- Use the pretty material design buttons -->
      	<button type="button" (click)="reset()" style="margin-top: 20px" mat-raised-button>Reset</button>&nbsp;&nbsp;
      	<button type="button" (click)="save()" mat-raised-button color="primary">Save</button>&nbsp;
    	</mat-card-content>

  	</form>


    </mat-card>

</ng-container>


<pre>
  myForm.valid={{this.myForm.valid}}
  myForm.controls.report_name.errors={{this.myForm.controls?.report_name?.errors | json}}
  myForm.controls.priority.errors={{this.myForm.controls?.priority?.errors | json}}
  myForm.controls.source.errors={{this.myForm.controls?.source?.errors | json}}
  myForm.controls.authors.errors={{this.myForm.controls?.authors?.errors | json}}
  myForm.controls.authors.valid={{myForm.controls.authors.valid }}
</pre>

```
