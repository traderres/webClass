Lesson 30e: Tab Group Page / Edit Page w/Fixed Title
----------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1aEc4lRNAX0kwf6opyhGUg2mED7XJLVjIgjgwThYLRbg/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson30e/tab-group/add-details-page
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem:  I have an "Edit Report" page that has a LOT of fields<br>
    -- If I have a "Save" button on the bottom, then the user has to scroll down to see it<br>
    -- I want another "Save" button on the top (that stays visible all of the time)<br>
<br>

![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson30e_image1.png)

<br>
<br>

![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson30e_image2.png)

As the user scrolls down, the page title, breadcrumbs, and "Save" button is ALWAYS visible






<br>
<br>

```
Procedure
---------
    1. Create the "Edit Report Details" page w/fixed title
       a. Generate the component
          unix> cd ~/intellijProjects/angularApp1/frontend
          unix> ng generate component analytics/grid-tab-group/edit-details-page --skipTests


       b. Add security for that route (so that the roles are authorized to see the page)
            i.   Edit R__security.sql

            ii.  Add a uicontrol record for the tab group:
                    insert into uicontrols(id, name) values(1026, 'page/reports/edit-details/:id');

            iii. Assign the uicontrols record to the 'admin' role
                    insert into roles_uicontrols(role_id, uicontrol_id) values(1, 1026);

            iv.   Assign the uicontrols record to the 'reader' role
                    insert into roles_uicontrols(role_id, uicontrol_id) values(2, 1026);



       c. Add a constant to constants.ts  (for the route)
             GRID_TAB_GROUP_EDIT_DETAILS_ROUTE = "page/reports/edit-details/",   // This route has a required startingTab


       d. Add the route to app.module.ts
             { path: Constants.GRID_TAB_GROUP_EDIT_DETAILS_ROUTE + ':id',   component: EditDetailsPageComponent, canActivate: [PageGuard] },




    2. Setup the "Edit Report Details" page type-script page to take the passed-in reportId
       a. Edit edit-details-page.component.ts

       b. Replace its contents with this:
            
            import { Component, OnInit } from '@angular/core';
            import {HttpErrorResponse} from "@angular/common/http";
            import {isNumeric} from "rxjs/internal-compatibility";
            import {ErrorService} from "../../../errorHandler/error.service";
            import {ActivatedRoute, Router} from "@angular/router";
            import {Constants} from "../../../utilities/constants";
            
            @Component({
              selector: 'app-edit-details-page',
              templateUrl: './edit-details-page.component.html',
              styleUrls: ['./edit-details-page.component.css']
            })
            export class EditDetailsPageComponent implements OnInit {
              public reportId: number;
            
              constructor(private errorService: ErrorService,
                        public  router: Router,
                        private activatedRoute: ActivatedRoute) { }
            
            
              public ngOnInit(): void {
                let rawReportId: string | null = this.activatedRoute.snapshot.paramMap.get("id");
            
                if (!rawReportId) {
                // The id field was not passed-in (in the URL to this route)
                // Display an error to the user
                this.errorService.addError(new HttpErrorResponse({
                    statusText: "Invalid reportId",
                    error:  	"The reportId is invalid or was not passed-in."
                }))
                return;
                }
                else if (! isNumeric(rawReportId))  {
                // The id field is not numeric.  So, display an error to the user
                this.errorService.addError(new HttpErrorResponse({
                    statusText: "Invalid reportId",
                    error:  	"The reportId is invalid or was not passed-in."
                }))
                return;
                }
            
            
                // Convert the reportId from a string to a number
                this.reportId = +rawReportId;
            
                // At this point, you would create an observable to get the details for this reportId
            
            
              } // end of ngOnInit()
            
            
              /*
               * This constants getter is added so we can use constants in the HTML markup
               */
              public get constants(): typeof Constants {
                return Constants;
              }
            
            }



    3. Setup the "Edit Report Details" HTML so that the title is fixed
       a. Edit edit-details-page.component.html

       b. Replace its contents with this:
            
            <div class="page-container">
            
              <div fxFlexFill fxLayout="column">
            
                <div fxLayout="column" fxLayoutAlign="start stretch" fxFlexFill>
            
                <!-- 1st Row is here -->
                <div fxFlex="none" fxLayout="row" fxLayoutGap="0">
            
                    <!-- Left Side of the Top Row -->
                    <div fxFlex fxLayoutAlign="left center" fxLayout="row" fxLayoutGap="0">
            
                        <div fxFlex fxLayout="column">
                        <!-- Page Title -->
                        <h1 class="mat-h1" style="margin-bottom: 0; padding-bottom: 0">Edit Report {{this.reportId}}</h1>
            
                        <!-- Bread Crumbs -->
                        <div class="breadcrumbs" style="padding-left: 20px">
                            <a class="breadcrumbs" (click)="this.router.navigate([constants.GRID_TAB_GROUP_ROUTE, 1])" title="Critical Reports">Critical Reports</a>  >
                            <span class="breadcrumbs_current_page">Edit Report #{{this.reportId}}</span>
                        </div>
                        </div>
            
                    </div>
            
            
                    <!-- Right Side of the Top Row -->
                    <div fxFlex fxLayoutAlign="end start">
                        <!-- Save Button -->
                        <button type="button" mat-raised-button color="primary">Save</button>
                    </div>
            
                </div>  <!-- End of 1st row -->
            
            
                <!-- 2nd Row is here -->
                <div fxFlex="20px" fxLayout="row">
                    <!-- Empty Vertical Spacer -->
                </div>
            
            
                <!-- 3rd Row is here -->
                <div fxFlex  fxLayout="column" fxLayoutGap="0">
            
                    <!-- This Row is fixed with its own scroll bar so that the save buttons are **ALWAYS VISIBLE AT THE TOP** -->
                    <div fxFlex="calc(100vh - 155px)" style="overflow: auto;">
            
                    <!-- Simulate a long page with 100 lines of text -->
                    <span *ngFor="let e of [].constructor(100); let i = index">
                        empty line {{i}}<br/>
                    </span>
            
                    </div>
            
            
            
                </div> <!-- End of 3rd row -->
            
               </div> <!-- End of Angular flex column -->
            
              </div>  <!-- End of Angular flex column -->
            
            </div>  <!-- End of page container -->
            


    4. Verify that the page has a fixed title
       a. Activate the debugger on "Full WebApp"
       b. Go to http://localhost:4200/page/reports/edit-details/25
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson30e_image3.png)
```
NOTE:  As the user scrolls, the page title, breadcrumbs, and "Save" button are ALWAYS visible.




    5. Add a reactive form to the "Edit Report Details" page
       a. Edit edit-details-page.component.ts

       b. Replace its contents with this:
            
            import { Component, OnInit } from '@angular/core';
            import {HttpErrorResponse} from "@angular/common/http";
            import {isNumeric} from "rxjs/internal-compatibility";
            import {ErrorService} from "../../../errorHandler/error.service";
            import {ActivatedRoute, Router} from "@angular/router";
            import {Constants} from "../../../utilities/constants";
            import {FormBuilder, FormGroup} from "@angular/forms";
            
            @Component({
              selector: 'app-edit-details-page',
              templateUrl: './edit-details-page.component.html',
              styleUrls: ['./edit-details-page.component.css']
            })
            export class EditDetailsPageComponent implements OnInit {
              public reportId: number;
              public myForm: FormGroup;
            
              constructor(private errorService: ErrorService,
                        public  router: Router,
                        private formBuilder: FormBuilder,
                        private activatedRoute: ActivatedRoute) { }
            
            
              public ngOnInit(): void {
                let rawReportId: string | null = this.activatedRoute.snapshot.paramMap.get("id");
            
                if (!rawReportId) {
                // The id field was not passed-in (in the URL to this route)
                // Display an error to the user
                this.errorService.addError(new HttpErrorResponse({
                    statusText: "Invalid reportId",
                    error:  	"The reportId is invalid or was not passed-in."
                }))
                return;
                }
                else if (! isNumeric(rawReportId))  {
                // The id field is not numeric.  So, display an error to the user
                this.errorService.addError(new HttpErrorResponse({
                    statusText: "Invalid reportId",
                    error:  	"The reportId is invalid or was not passed-in."
                }))
                return;
                }
            
            
                // Convert the reportId from a string to a number
                this.reportId = +rawReportId;
            
                // Initialize the form
                this.initializeForm();
            
                // TODO:  Use the reportId to get an observable and have an async-pipe and tap load the reactive form
            
              } // end of ngOnInit()
            
            
              private initializeForm(): void {
                // Initialize the reactive form
                this.myForm = this.formBuilder.group( {
                textField1:  [null, null],
                textField2:  [null, null],
                textField3:  [null, null],
                textField4:  [null, null],
                textField5:  [null, null],
                textField6:  [null, null],
                textField7:  [null, null],
                textField8:  [null, null],
                textField9:  [null, null],
                textField10:  [null, null]
                });
              }
            
              /*
               * This constants getter is added so we can use constants in the HTML markup
               */
              public get constants(): typeof Constants {
                return Constants;
              }
            
            }


    6. Add the form fields to the html template
       a. Edit edit-details-page.component.html

       b. Replace its contents with this:
            
            <div class="page-container">
            
              <div fxFlexFill fxLayout="column">
            
                <div fxLayout="column" fxLayoutAlign="start stretch" fxFlexFill>
            
                <!-- 1st Row is here -->
                <div fxFlex="none" fxLayout="row" fxLayoutGap="0">
            
                    <!-- Left Side of the Top Row -->
                    <div fxFlex fxLayoutAlign="left center" fxLayout="row" fxLayoutGap="0">
            
                        <div fxFlex fxLayout="column">
                        <!-- Page Title -->
                        <h1 class="mat-h1" style="margin-bottom: 0; padding-bottom: 0">Edit Report {{this.reportId}}</h1>
            
                        <!-- Bread Crumbs -->
                        <div class="breadcrumbs" style="padding-left: 20px">
                            <a class="breadcrumbs" (click)="this.router.navigate([constants.GRID_TAB_GROUP_ROUTE, 1])" title="Critical Reports">Critical Reports</a>  >
                            <span class="breadcrumbs_current_page">Edit Report #{{this.reportId}}</span>
                        </div>
                        </div>
            
                    </div>
            
            
                    <!-- Right Side of the Top Row -->
                    <div fxFlex fxLayoutAlign="end start">
                        <!-- Save Button -->
                        <button type="button" mat-raised-button color="primary">Save</button>
                    </div>
            
                </div>  <!-- End of 1st row -->
            
            
            
                <!-- 2nd Row is here -->
                <div fxFlex="20px" fxLayout="row">
                    <!-- Empty Vertical Spacer -->
                </div>
            
            
                <!-- 3rd Row is here -->
                <div fxFlex  fxLayout="column" fxLayoutGap="0">
            
                    <!-- This Row is fixed with its own scroll bar so that the save buttons are **ALWAYS VISIBLE AT THE TOP** -->
                    <div fxFlex="calc(100vh - 155px)" style="overflow: auto;">
            
                    <form [formGroup]="this.myForm" autocomplete=off novalidate>
            
                        <mat-card class="mat-elevation-z4">
                            <mat-card-content>
            
                            <mat-form-field style="display: block;">
                                <!-- Text Field 1 -->
                                <mat-label>Enter Text Field 1</mat-label>
                                <input matInput formControlName="textField1" aria-label="text field 1" />
                            </mat-form-field>
            
            
                            <mat-form-field style="display: block;">
                                <!-- Text Field 2 -->
                                <mat-label>Enter Text Field 1</mat-label>
                                <input matInput formControlName="textField2" aria-label="text field 2" />
                            </mat-form-field>
            
            
                            <mat-form-field style="display: block;">
                                <!-- Text Field 3 -->
                                <mat-label>Enter Text Field 3</mat-label>
                                <input matInput formControlName="textField3" aria-label="text field 3" />
                            </mat-form-field>
            
            
                            <mat-form-field style="display: block;">
                                <!-- Text Field 4 -->
                                <mat-label>Enter Text Field 4</mat-label>
                                <input matInput formControlName="textField4" aria-label="text field 4" />
                            </mat-form-field>
            
            
                            <mat-form-field style="display: block;">
                                <!-- Text Field 5 -->
                                <mat-label>Enter Text Field 5</mat-label>
                                <input matInput formControlName="textField5" aria-label="text field 5" />
                            </mat-form-field>
            
            
                            <mat-form-field style="display: block;">
                                <!-- Text Field 6 -->
                                <mat-label>Enter Text Field 6</mat-label>
                                <input matInput formControlName="textField6" aria-label="text field 6" />
                            </mat-form-field>
            
            
                            <mat-form-field style="display: block;">
                                <!-- Text Field 7 -->
                                <mat-label>Enter Text Field 7</mat-label>
                                <input matInput formControlName="textField7" aria-label="text field 7" />
                            </mat-form-field>
            
            
                            <mat-form-field style="display: block;">
                                <!-- Text Field 8 -->
                                <mat-label>Enter Text Field 8</mat-label>
                                <input matInput formControlName="textField8" aria-label="text field 8" />
                            </mat-form-field>
            
            
                            <mat-form-field style="display: block;">
                                <!-- Text Field 9 -->
                                <mat-label>Enter Text Field 9</mat-label>
                                <input matInput formControlName="textField9" aria-label="text field 9" />
                            </mat-form-field>
            
            
                            <mat-form-field style="display: block;">
                                <!-- Text Field 10 -->
                                <mat-label>Enter Text Field 10</mat-label>
                                <input matInput formControlName="textField10" aria-label="text field 10" />
                            </mat-form-field>
            
            
                            <div fxLayout="row" fxLayoutAlign="center center">
                                <!-- Save Button -->
                                <button type="button" mat-raised-button color="primary">Save</button>
                            </div>
            
            
                            </mat-card-content>
                        </mat-card>
                    </form>
            
            
                    </div>   <!-- End of the fixed area -->
            
            
                </div> <!-- End of 3rd row -->
            
               </div> <!-- End of Angular flex column -->
            
              </div>  <!-- End of Angular flex column -->
            
            </div>  <!-- End of page container -->
            



    7. Verify that the "Edit Report Details" page has a scroll bar and that the title is fixed (at the top)
       a. Activate the Debugger on "Full WebApp"
       b. Go to http://localhost:4200/page/reports/edit-details/25
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson30e_image4.png)
```
As you scroll down, the title and "Save" button are always visible  (so the top row is FIXED)




    8. Add the Critical Reports Grid Action Renderer Component
       a. Generate the component
          unix> cd ~/intellijProjects/angularApp1/frontend
          unix> ng generate component analytics/grid-tab-group/critical-reports-action-renderer --skipTests

       b. Edit critical-reports-action-renderer.component.ts

       c. Replace its contents with this:
            
            import { Component} from '@angular/core';
            import {ICellRendererAngularComp} from "ag-grid-angular";
            import {ICellRendererParams} from "ag-grid-community";
            
            @Component({
              selector: 'app-critical-reports-action-renderer',
              templateUrl: './critical-reports-action-renderer.component.html',
              styleUrls: ['./critical-reports-action-renderer.component.css']
            })
            export class CriticalReportsActionRendererComponent implements ICellRendererAngularComp {
            
            private params: ICellRendererParams;
            
              constructor() { }
            
              agInit(params: ICellRendererParams): void {
                this.params = params;
              }
            
              refresh(params: ICellRendererParams): boolean {
                return false;
              }
            
              public editClicked() {
                //@ts-ignore
                this.params.editButtonClicked(this.params);
              }
            
            
            }


       d. Edit critical-reports-action-renderer.component.html

       e. Replace its contents with this:
            
            <button title="Edit User" aria-label="Edit User" type="button" mat-icon-button (click)="this.editClicked()">
              <i class="fas fa-edit fa-2x"></i>
            </button>






    9. Add the Action Renderer Component to the Critical Reports Grid
       a. Edit critical-reports-grid.component.ts

       b. Inject the router

       c. Add a method to be called when a user clicks on the "Edit" icon
            
              /*
               * User clicked one of the Edit Report Buttons (in the grid)
               */
              private editReportClicked(params: ICellRendererParams) {
                // Navigate to the "Edit Report Details" page and passed-in the reportId
                this.router.navigate([Constants.GRID_TAB_GROUP_EDIT_DETAILS_ROUTE, params.data.id]).then();
              }



       d. Change the frameworkComponents to this:
            
              // Tell ag-grid which cell-renderers will be available
              // This is a map of component names that correspond to components that implement ICellRendererAngularComp
              public frameworkComponents: any = {
                editActionRenderer: CriticalReportsActionRendererComponent
              };



       e. Add a new column called "Action" and make it the first column
          
          So, replace the columnDefs with this:
            
               public columnDefs = [
                {
                    headerName: 'Action',
                    filter: false,
                    sortable: false,
                    cellStyle: {'text-align': 'left'},
                    cellRenderer: 'editActionRenderer',
                    cellRendererParams: {
                        editButtonClicked: (params: ICellRendererParams) => this.editReportClicked(params),
                    }
                },
                {
                    headerName: 'Id',
                    field: 'id',
                    filter: 'agNumberColumnFilter',       	// numeric filter
                    filterParams: this.textFilterParams,
                    cellClass: 'grid-text-cell-format',
                    checkboxSelection: false,
                },
                {
                    headerName: 'Report Name',
                    field: 'display_name',
                    filter: 'agTextColumnFilter',
                    filterParams: this.textFilterParams,
                    cellClass: 'grid-text-cell-format'
                },
                {
                    headerName: 'Priority',
                    field: 'priority',
                    filter: 'agTextColumnFilter',
                    filterParams: this.textFilterParams,
                },
                {
                    headerName: 'Description',
                    field: 'description',
                    sortable: false,                  	// The description field is not sortable
                    filter: 'agTextColumnFilter',
                    filterParams: this.textFilterParams,
                    cellClass: 'grid-text-cell-format'
                }
              ];



    10. Verify that the "Edit" icon works in the grid
        a. Activate the Debugger on "Full WebApp"
        b. Click on "Critical Reports"
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson30e_image5.png)
```
Now, clicking on the "Edit" icon will take you to the "Edit Report" page


```
