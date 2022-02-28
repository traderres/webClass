Lesson 7c: Add Report / Show an Icon after Valid Form Fields
------------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1jMkOOwx0Io7xpa6rewNGE2UrybwbC2R7p1h4lRoXjfM/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson7e/show-icon-after-valid-fields
<br>
<br>






Instead of highlighting form fields with red or green colors, we could show an icon 
![](https://lh6.googleusercontent.com/ES-Kbjsraq7Y-1LrsGlf6VW9LjwMTbzgGYFVxkztRmSaHVtrEK4W9NxEgONC0LVxm-8rx3Z1ktCrVJtV5fbjwLRn3hHCjNB0dpsQ4CTXRIHXuIXBupYag_7aUN-7kH-7SIw6xKDO)
In this example, a checkbox icon appears 5 pixels to the right of a valid form field
<br>
<br>
<br>
```
Procedure
    1. Remove all of the CSS the from add-report.component.css

    2. Approach 1:  Add a checkbox next to the mat-form-field by referencing a template variable for the field
        a. Edit add-report.component.html

        b. Make sure there is a template reference variable for the report name
            
            If you see this:
               <input matInput type="text" name="report.name"  [(ngModel)]="report.name" required />
            
            Change to this:
            <input matInput type="text" name="report.name"  [(ngModel)]="report.name" required #name="ngModel" />



        c. Add an ng-container after the closing </mat-form-field> tag that shows the icon
           
            Change this:
            
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
            
            To this:
            
               <mat-form-field>
                <mat-label>Enter Report Name</mat-label>
            
                    <!-- Use the matInput for input fields inside <mat-form-field>...</mat-form-field> tags -->
                    <input matInput type="text" name="report.name"  [(ngModel)]="report.name" required #name="ngModel" />
            
                    <mat-error>
                        <!-- This mat-error tag is displayed if this form field is invalid AND touched -->
                        Report Name is required
                        </mat-error>
                 </mat-form-field>
            
                 <ng-container  *ngIf="name.touched && name.errors==null">
                    <!-- The user visited this form field and filled-it in correctly -->
                    <div style="display:inline; margin-left: 5px">
                        <i class="fa fa-check"></i>
                    </div>
                 </ng-container>
            
                 <br/>

    3. Activate the debugger
        a. Pull Run -> Debug 'Full WebApp'
        b. Click on "Add Report"
        c. Go to the "Report Name" textbox
        d. Fill-in a few characters in the "Report Name" text box
        e. Leave the "Report Name" text box
           -- You should see the checkbox






    4. Approach 2:  Add a checkbox next to the mat-form-field by referencing the form variable
       ASSUMPTION:  Your html page has this at the top:
                            <form #form="ngForm" novalidate autocomplete="off">
                    This #form means we can reference any form field using form.controls.(form name)
     
        a. Edit add-report.component.html

        b. Remove the template variable from the report name text box
            
            Change this:
               <input matInput type="text" name="report.name"  [(ngModel)]="report.name" required #name="ngModel" />
            
            To this:
               <input matInput type="text"  name="report_name"  [(ngModel)]="report.name" required 
            #name="ngModel" />


        c. To reference the report_name field, we can use form.controls.report_name
            
            Change the ng-container from this:
               
                 <ng-container  *ngIf="name.touched && name.errors==null">
                    <!-- The user visited this form field and filled-it in correctly -->
                    <div style="display:inline; margin-left: 5px">
                        <i class="fa fa-check"></i>
                    </div>
                 </ng-container>
            
            
            To this:
               
                 <ng-container  *ngIf="form.controls.report_name?.touched &&
                                                    form.controls.report_name?.errors==null">
                    <!-- The user visited this form field and filled-it in correctly -->
                    <div style="display:inline; margin-left: 5px">
                        <i class="fa fa-check"></i>
                    </div>
                 </ng-container>


    5. Activate the debugger
        a. Pull Run -> Debug 'Full WebApp'
        b. Click on "Add Report"
        c. Go to the "Report Name" textbox
        d. Fill-in a few characters in the "Report Name" text box
        e. Leave the "Report Name" text box
           -- You should see the checkbox


    6. Add an icon if the Priority field is filled-in using approach 1
        a. Edit add-report.component.html
        b. Add a template reference to the Priority dropdown 
                #priority="ngModel"

        c. Add the <ng-container> after the closing </mat-form-field> tag that checks the priority variable.



    7. Add an icon if the Priority field is filled-in using approach 2
        a. Edit add-report.component.html

        b. Change the priority dropdown as it has name="priority"

        c. Remove the #priority template variable
               <mat-select name="priority" [(ngModel)]="report.priority" required >

        d. Add the <ng-container> after the closing </mat-form-field> tag but use form.controls.priority to reference the priority field
                
               <ng-container  *ngIf="form.controls.priority?.touched && 
                                                  form.controls.priority?.errors==null">
                        <!-- The user visited this form field and filled-it in correctly -->
                        <div style="display:inline; margin-left: 5px">
                            <i class="fa fa-check"></i>
                        </div>
               </ng-container>
                

    8. Try it out:  Verify that you see the black checkmark next to the report name text field
        a. Activate your debugger on "Full WebApp"
        b. Go to the "Add Report" page
        c. Type-in some characters next to the report name
           -- You should see the black checkmark

        d. Select a priority
           -- You should see the black checkmark next to priority


    9. Change the icon color to green
        a. Edit add-report.component.html

        b. Change the font awesome icon to this:
            <i class="fa fa-check"  style="color: green"></i>


    10. Try it out:  Verify that you see a green checkmark next to the report name text field
        a. Activate your debugger
        b. Go to the "Add Report" page
        c. Type-in some characters next to the report name
           -- You should see the green checkmark


    11. Make an application-wide CSS class called checkbox-color
        a. Edit styles.css

        b. Add this class to the end:
            
             .checkbox-color {
               color: green
            }


    12. Apply the checkbox-color class to all of your checkboxes
        a. Edit add-report.component.html

        b. Change the font awesome icon to this for all of these checkboxes:
             <i class="fa fa-check checkbox-color"></i>


        Now, all of the checkboxes use the *same* color css


    13. Try it out:  Verify that you see a green checkmark next to the report name text field
        a. Activate your debugger
        b. Go to the "Add Report" page
        c. Type-in some characters next to the report name
           -- You should see the green checkmark


    14. Pop quiz:  How would you increase the size of your font-awesome checkbox?

	


 


```
