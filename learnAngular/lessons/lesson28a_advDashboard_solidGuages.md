Lesson 28a:  Advanced Dashboard / Drag & Drop Charts and Grids / Solid Gauges
-----------------------------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1tWTbW_FVcflsHRUVAhHTJyPSnPYUUyEkiPNv3IaczTY/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson28a/dashboard/drag-and-drop
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem 1:  I want my users to be able to drag & drop charts and grids on my welcome page<br>
Problem 2:  Users want the ability to drag & drop columns in the charts<br>
<br>
Solution:  
 1. Create a welcome page that holds a single column of mat-grid-tile<br>
 2. Each mat-grid-tile holds a chart, grid, or component<br>
 3. Setup the page with 2 modes: (a) drag & drop grids and (b) drag & drop columns in a grid<BR>


![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson28a_image1.png)

The "Drag & Drop Mode" gives the user 2 options:<BR>
 1) Drag & Drop Charts -- which lets users drag & drop charts up/down<br>
 2) Drag & Drop Columns -- which lets users drag & drop columns in the grids<br>
 <br>
 <br>
 
 ![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson28a_image2.png)
 

<br>
<br>

```
Approach
--------
    1. Setup a welcome page layout 
    2. Add a multi-select dropdown and popup
    3. Add for loop and if statements for welcome page grids
    4. Add drag & drop to the charts
    5. Add logic to turn on/off drag & drop
    6. Add 2 real charts to the page
    7. Update the page to resize the charts if the left-side navbar appears



Procedure
---------
    1. Verify that the welcome page is the default page
       a. Edit app.module.ts

       b. Verify that you see this route:

             { path: '',              	component: WelcomeComponent},




    2. Setup the layout for the welcome page as
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson28a_image3.png)
```
       a. Edit welcome.component.html

       b. Replace all of the html with this:
            
            <div fxLayout="column" fxLayoutAlign="start stretch" fxLayoutGap="20px">
            
              <div fxLayout="row" fxLayoutAlign="space-between stretch">
                <div fxFlex="50%" fxLayoutAlign="start start">
                    <!-- Left Side of Row 1 -->
                    Page Title
                </div>
            
                <div fxFlex="50%"  fxLayoutAlign="end start">
                    <!-- Right Side of Row 1-->
                    Drop Downs
                </div>
            
              </div>
            
              <div>
                <!-- Row 2 -->
                Chart 1
              </div>
            
              <div>
                <!-- Row 3 -->
                Chart 2
              </div>
            
              <div>
                <!-- Row 4 -->
                Grid 1
              </div>
            
              <div>
                <!-- Row 5 -->
                Grid 2
              </div>
            </div>
            

       c. Activate the debugger on "Full WebApp" and verify the page looks like this:
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson28a_image4.png)
```




    3. Add the dropdowns and popup controls
       a. Edit welcome.component.ts

       b. Change its contents to this:
            
            import { Component, OnInit } from '@angular/core';
            import {FormBuilder, FormControl} from "@angular/forms";
            
            @Component({
              selector: 'app-welcome',
              templateUrl: './welcome.component.html',
              styleUrls: ['./welcome.component.css']
            })
            export class WelcomeComponent implements OnInit {
            
              public selectedVisibleControls: FormControl;
              public listOfVisibleCharts: number[] = [1, 2, 3, 4];
            
              constructor(private formBuilder: FormBuilder) { }
            
              ngOnInit(): void {
                // Create a form control that lists which controls are visible
                this.selectedVisibleControls = this.formBuilder.control(this.listOfVisibleCharts, null);
              }
            
            }



       c. Edit welcome.component.css

       d. Add these CSS classes:
            
            /* Removes the extra padding on the top of the form field */
            /* Padding comes from the MAT_FORM_FIELD_DEFAULT_OPTIONS */
            :host  ::ng-deep .mat-form-field-appearance-standard .mat-form-field-flex{
              padding-top: 0 !important;
            }
            
            :host  ::ng-deep .mat-form-field-infix {
              /* Adjust the drop down so it aligns with the "Drag & Drop Mode" button */
              padding-top: 7px !important;
            }
            
            .chart-wrapper {
              border: 1px solid black;
              padding: 15px;
            }


       e. Edit welcome.component.html

       f. Replace its contents with this:
            
            <div class="page-container">
              <div fxLayout="column" fxLayoutAlign="start stretch" fxLayoutGap="20px">
            
                <div fxLayout="row" fxLayoutAlign="space-between stretch">
                <div fxFlex="50%"  fxLayoutAlign="start start">
                        <!-- Left Side of Row 1 -->
                        <h1 class="mat-h1">Welcome to Angular App1</h1>
                </div>
            
                <div fxFlex="50%"  fxLayoutAlign="end start">
                    <!-- Right Side of Row 1-->
            
            
                    <div>
                    <!-- Popup to change the mode of the page -->
                    <button [matMenuTriggerFor]="menu" mat-raised-button aria-label="Select Drag & Drop Mode" title="Select Drag & Drop Mode"
                            style="width: 150px; margin-top: 5px">
                        Drag & Drop Mode
                    </button>
            
                    <mat-menu #menu="matMenu">
                            <mat-radio-group>
            
                            <button mat-menu-item style="height: fit-content;">
                                <mat-radio-button [value]=10>
                                    Enable Chart Drag & Drop
                                </mat-radio-button>
                            </button>
            
                            <button mat-menu-item style="height: fit-content;">
                                <mat-radio-button [value]=11>
                                Enable Grid Column Drag & Drop
                                </mat-radio-button>
                            </button>
                        </mat-radio-group>
            
                    </mat-menu>
                    </div>
            
            
            
                    <!-- Multiple dropdown that sets a list of numbers (which determines which charts/grids are visible -->
                    <mat-form-field style="width: 175px; margin-left: 20px" appearance="standard">
            
                    <!-- Show this label if a user unchecks all charts/grids -->
                    <mat-label *ngIf="this.selectedVisibleControls.value.length == 0">Showing No Charts</mat-label>
            
                    <mat-select multiple [formControl]="this.selectedVisibleControls">
            
                        <mat-option [value]=1>Chart 1</mat-option>
                        <mat-option [value]=2>Chart 2</mat-option>
                        <mat-option [value]=3>Grid 1</mat-option>
                        <mat-option [value]=4>Grid 2</mat-option>
            
                        <!-- Change the visible item to show how many charts/grids are visible -->
                        <mat-select-trigger>
                        <ng-container *ngIf="this.selectedVisibleControls.value.length > 1">Showing {{this.selectedVisibleControls.value.length}} Charts</ng-container>
                        <ng-container *ngIf="this.selectedVisibleControls.value.length == 1">Showing 1 Chart</ng-container>
                        </mat-select-trigger>
                    </mat-select>
                    </mat-form-field>
            
                </div>
            
                </div>
            
                <div class="chart-wrapper">
                <!-- Row 2 -->
                Chart 1
                </div>
            
                <div class="chart-wrapper">
                <!-- Row 3 -->
                Chart 2
                </div>
            
                <div class="chart-wrapper">
                <!-- Row 4 -->
                Grid 1
                </div>
            
                <div class="chart-wrapper">
                <!-- Row 5 -->
                Grid 2
                </div>
              </div>
            
            </div>


       g. Activate the debugger on "Full WebApp" and verify the page looks like this:
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson28a_image5.png)
```




    4. Place the charts and grids in <mat-card> tags
       a. Edit welcome.component.html

       b. Replace its contents with this:
            
            <div class="page-container">
              <div fxLayout="column" fxLayoutAlign="start stretch" fxLayoutGap="20px">
            
                <div fxLayout="row" fxLayoutAlign="space-between stretch">
                <div fxFlex="50%"  fxLayoutAlign="start start">
                    <!-- Left Side of Row 1 -->
                    <h1 class="mat-h1">Welcome to Angular App1</h1>
                </div>
            
                <div fxFlex="50%"  fxLayoutAlign="end start">
                    <!-- Right Side of Row 1-->
            
            
                    <div>
                    <!-- Popup to change the mode of the page -->
                    <button [matMenuTriggerFor]="menu" mat-raised-button aria-label="Select Drag & Drop Mode" title="Select Drag & Drop Mode"
                            style="width: 150px; margin-top: 5px">
                        Drag & Drop Mode
                    </button>
            
                    <mat-menu #menu="matMenu">
                        <mat-radio-group>
            
                        <button mat-menu-item style="height: fit-content;">
                            <mat-radio-button [value]=10>
                            Enable Chart Drag & Drop
                            </mat-radio-button>
                        </button>
            
                        <button mat-menu-item style="height: fit-content;">
                            <mat-radio-button [value]=11>
                            Enable Grid Column Drag & Drop
                            </mat-radio-button>
                        </button>
            
                        </mat-radio-group>
            
                    </mat-menu>
                    </div>
            
            
            
                    <!-- Multiple dropdown that sets a list of numbers (which determines which charts/grids are visible -->
                    <mat-form-field style="width: 175px; margin-left: 20px" appearance="standard">
            
                    <!-- Show this label if a user unchecks all charts/grids -->
                    <mat-label *ngIf="this.selectedVisibleControls.value.length == 0">Showing No Charts</mat-label>
            
                    <mat-select multiple [formControl]="this.selectedVisibleControls">
            
                        <mat-option [value]=1>Chart 1</mat-option>
                        <mat-option [value]=2>Chart 2</mat-option>
                        <mat-option [value]=3>Grid 1</mat-option>
                        <mat-option [value]=4>Grid 2</mat-option>
            
                        <!-- Change the visible item to show how many charst/grids are visible -->
                        <mat-select-trigger>
                        <ng-container *ngIf="this.selectedVisibleControls.value.length > 1">Showing {{this.selectedVisibleControls.value.length}} Charts</ng-container>
                        <ng-container *ngIf="this.selectedVisibleControls.value.length == 1">Showing 1 Chart</ng-container>
                        </mat-select-trigger>
                    </mat-select>
                    </mat-form-field>
            
                </div>
            
                </div>
            
                <mat-card class="mat-elevation-z4">
                <mat-card-content>
                    <!-- Row 2 -->
                    Chart 1
                </mat-card-content>
                </mat-card>
            
            
                <mat-card class="mat-elevation-z4">
                <mat-card-content>
                    <!-- Row 3 -->
                    Chart 2
                </mat-card-content>
                </mat-card>
            
            
                <mat-card class="mat-elevation-z4">
                <mat-card-content>
                    <!-- Row 4 -->
                    <div style="width: 100%; height: 100%;">
                    Grid 1
                    </div>
                </mat-card-content>
                </mat-card>
            
            
                <mat-card class="mat-elevation-z4">
                <mat-card-content>
                    <!-- Row 5 -->
                    <div style="width: 100%; height: 100%;">
                    Grid 2
                    </div>
                </mat-card-content>
                </mat-card>
            
              </div>
            
            </div>
            
            


       c. Activate the debugger on "Full WebApp" and verify the page looks like this:
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson28a_image6.png)
```




    5. Add a for loop so that the <mat-card> tags are created dynamically
       a. Edit welcome.component.css

       b. Replace its contents with this
          NOTE:  We updated .chart-content and added the mat-card class
            

            /* Removes the extra padding on the top of the form field */
            /* Padding comes from the MAT_FORM_FIELD_DEFAULT_OPTIONS */
            :host  ::ng-deep .mat-form-field-appearance-standard .mat-form-field-flex{
              padding-top: 0 !important;
            }
            
            :host  ::ng-deep .mat-form-field-infix {
              /* Adjust the drop down so it aligns with the "Drag & Drop Mode" button */
              padding-top: 7px !important;
            }
            
            .chart-content {
              height: 100% !important;	/* Needed to ensure the chart fills uses all of the height */
            }
            
            mat-card {
              /* Set spacing between cards */
              position: absolute;
              top: 10px;
              left: 10px;
              right: 10px;
              bottom: 10px;
              overflow: hidden; /* Removing the vertical scroll bar */
            
              padding: 5px;    /* Reduce the padding so the chart uses-up more space in the card */
            }


       c. Edit welcome.component.html

       d. Replace its contents with this:
            
            <div class="page-container">
              <div fxLayout="column" fxLayoutAlign="start stretch" fxLayoutGap="20px">
            
                <div fxLayout="row" fxLayoutAlign="space-between stretch">
                <div fxFlex="50%"  fxLayoutAlign="start start">
                    <!-- Left Side of Row 1 -->
                    <h1 class="mat-h1">Welcome to Angular App1</h1>
                </div>
            
                <div fxFlex="50%"  fxLayoutAlign="end start">
                    <!-- Right Side of Row 1-->
            
            
                    <div>
                    <!-- Popup to change the mode of the page -->
                    <button [matMenuTriggerFor]="menu" mat-raised-button aria-label="Select Drag & Drop Mode" title="Select Drag & Drop Mode"
                            style="width: 150px; margin-top: 5px">
                        Drag & Drop Mode
                    </button>
            
                    <mat-menu #menu="matMenu">
                        <mat-radio-group>
            
                        <button mat-menu-item style="height: fit-content;">
                            <mat-radio-button [value]=10>
                            Enable Chart Drag & Drop
                            </mat-radio-button>
                        </button>
            
                        <button mat-menu-item style="height: fit-content;">
                            <mat-radio-button [value]=11>
                            Enable Grid Column Drag & Drop
                            </mat-radio-button>
                        </button>
            
                        </mat-radio-group>
            
                    </mat-menu>
                    </div>
            
            
            
                    <!-- Multiple dropdown that sets a list of numbers (which determines which charts/grids are visible -->
                    <mat-form-field style="width: 175px; margin-left: 20px" appearance="standard">
            
                    <!-- Show this label if a user unchecks all charts/grids -->
                    <mat-label *ngIf="this.selectedVisibleControls.value.length == 0">Showing No Charts</mat-label>
            
                    <mat-select multiple [formControl]="this.selectedVisibleControls">
            
                        <mat-option [value]=1>Chart 1</mat-option>
                        <mat-option [value]=2>Chart 2</mat-option>
                        <mat-option [value]=3>Grid 1</mat-option>
                        <mat-option [value]=4>Grid 2</mat-option>
            
                        <!-- Change the visible item to show how many charst/grids are visible -->
                        <mat-select-trigger>
                        <ng-container *ngIf="this.selectedVisibleControls.value.length > 1">Showing {{this.selectedVisibleControls.value.length}} Charts</ng-container>
                        <ng-container *ngIf="this.selectedVisibleControls.value.length == 1">Showing 1 Chart</ng-container>
                        </mat-select-trigger>
                    </mat-select>
                    </mat-form-field>
            
                </div>
            
                </div>
            
            
              </div>
            
              <mat-grid-list [cols]=1 [rowHeight]=400>
                <mat-grid-tile [colspan]=1 [rowspan]=1 *ngFor="let chartType of this.listOfVisibleCharts">
            
                <mat-card class="mat-elevation-z4">
                    <mat-card-content class="chart-content">
            
                    <div style="width: 100%; height: 100%" *ngIf="chartType == 1">
                        <!-- This is chartType==1.  So, show chart 1 -->
                        Chart 1
                    </div>
            
                    <div style="width: 100%; height: 100%" *ngIf="chartType == 2">
                        <!-- This is chartType==2.  So, show chart 2 -->
                        Chart 2
                    </div>
            
                    <div style="width: 100%; height: 100%" *ngIf="chartType == 3">
                        <!-- This is chartType==3.  So, show grid 1 -->
                        Grid 1
                    </div>
            
                    <div style="width: 100%; height: 100%" *ngIf="chartType == 4">
                        <!-- This is chartType==4.  So, show grid 2 -->
                        Grid 2
                    </div>
            
                    </mat-card-content>
                </mat-card>
            
            
                </mat-grid-tile>
              </mat-grid-list>
            
            </div>


       e. Activate the debugger on "Full WebApp" and verify the page looks like this:
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson28a_image7.png)
```
NOTE:  The chart height is set by the [rowHeight]=400 in the <mat-grid-list> tag




    6. Add drag & drop to the mat-card tags
       a. Edit app.module.ts

       b. Add DragDropModule to the imports section

       c. Verify that this import is present at the top:
            import { DragDropModule } from '@angular/cdk/drag-drop';


       d. Edit welcome.component.ts

       e. Change its contents to this:
            
            import {Component, OnDestroy, OnInit} from '@angular/core';
            import {FormBuilder, FormControl} from "@angular/forms";
            import {CdkDragDrop, moveItemInArray} from "@angular/cdk/drag-drop";
            import {Subscription} from "rxjs";
            
            @Component({
              selector: 'app-welcome',
              templateUrl: './welcome.component.html',
              styleUrls: ['./welcome.component.css']
            })
            export class WelcomeComponent implements OnInit, OnDestroy {
              public selectedVisibleControls: FormControl;
              public listOfVisibleCharts: number[] = [1, 2, 3, 4];
              private selectedVisibleControlsSubscription: Subscription;
            
              constructor(private formBuilder: FormBuilder) { }
            
              public ngOnInit(): void {
                // Create a form control that lists which controls are visible
                this.selectedVisibleControls = this.formBuilder.control(this.listOfVisibleCharts, null);
            
                this.selectedVisibleControlsSubscription = this.selectedVisibleControls.valueChanges.subscribe((arrayOfSelectedValues: number[]) => {
                    // User selected some values in the multi-select dropdown
                
                    // Tell the *ngFor loop to re-render the components
                    //   1) set the listOfVisibleCharts to be empty
                    //   2) use setTimeout to set the listOfVisibleCharts to hold the new array
                    //  	This causes components to be re-rendered in the updated *ngFor loop
                    this.listOfVisibleCharts = [ ];
                    setTimeout( () => {
                            this.listOfVisibleCharts = arrayOfSelectedValues;
                    });
            
                })
              }
            
            
            
              public ngOnDestroy(): void {
                if (this.selectedVisibleControlsSubscription) {
                this.selectedVisibleControlsSubscription.unsubscribe();
                }
              }
            
            
              public drop(aEvent: CdkDragDrop<number[]>) {
                // Re-order the array
                moveItemInArray(this.listOfVisibleCharts, aEvent.previousIndex, aEvent.currentIndex);
              }
            
            }



       f. Edit welcome.component.html

           i.   Change the <mat-grid-list> opening tag to this:
                   <mat-grid-list [cols]=1 rowHeight="400px" 
                                  cdkDropList (cdkDropListDropped)="this.drop($event)">

            ii. Change the <mat-grid-tile> opening tag to this:
                    <mat-grid-tile [colspan]=1 [rowspan]=1 *ngFor="let chartType of this.listOfVisibleCharts"
                                cdkDrag>



       g. Activate the debugger on "Full WebApp" and verify the page now lets you drag & drop:
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson28a_image8.png)
```
NOTE:  We can now drag & drop these large <mat-card> tags up and down




    7. Add logic to turn on/off drag & drop and add an existing page for grid 1
       a. Edit welcome.component.ts

       b. Add this public boolean:
            public disableGridDragDrop: boolean = false;

       c. Add this public method:
            
              public userChangedDragAndDropMode(aNewDragMode: number) {
                if (aNewDragMode == 10) {
                // User selected to enable chart drag & drop
                this.disableGridDragDrop = false;
                }
                else if (aNewDragMode == 11) {
                // User selected to enable Grid drag & drop  (so disable the cdk drag and drop)
                this.disableGridDragDrop = true;
                }
              }



       d. Edit welcome.component.html

          i.  Change the radio group so it calls this method on click:
                
                <mat-radio-group>
                  <button mat-menu-item style="height: fit-content;">
                    <mat-radio-button  [value]=10
                                 (click)="this.userChangedDragAndDropMode(10)" 
                                [checked]="this.disableGridDragDrop == false">
                    Enable Chart Drag & Drop
                    </mat-radio-button>
                  </button>
                
                  <button mat-menu-item style="height: fit-content;">
                    <mat-radio-button  [value]=11 
                                (click)="this.userChangedDragAndDropMode(11)" 
                                 [checked]="this.disableGridDragDrop == true">
                    Enable Grid Column Drag & Drop
                    </mat-radio-button>
                  </button>
                </mat-radio-group>

          ii.  Change the <mat-grid-tile> to this:

                 <mat-grid-tile [colspan]=1 [rowspan]=1 *ngFor="let chartType of this.listOfVisibleCharts"
                                cdkDrag [cdkDragDisabled]="this.disableGridDragDrop">


           iii. Change the *ngIf for chartType == 3 to this:
            
              <div style="width: 100%; height: 100%" *ngIf="chartType == 3">
                <!-- This is chartType==3.  So, show grid 1 -->
                <app-report-grid-view></app-report-grid-view>
              </div>


       e. Activate the debugger on "Full WebApp" and verify the page now lets you drag & drop:
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson28a_image9.png)
```
Drag and drop the 3rd chart to the top of the page
Press Drag & Drop Mode -> Choose "Enable Grid Column Drag & Drop"
Drag and drop the columns in this grid from left to right





    8. Add 2 real highchart charts to the page
       a. Edit welcome.component.html

            i. Replace the hard-coded label "Chart 1" with this:
                
                  <div style="width: 100%; height: 100%" *ngIf="chartType == 1">
                    <!-- This is chartType==1.  So, show chart 1 -->
                    Chart 1
                  </div>
                
                
                With this:
                
                  <div style="width: 100%; height: 100%" *ngIf="chartType == 1">
                    <!-- This is chartType==1.  So, show chart 1 -->
                    <div style="width: 100%; height: 100%" id="chart1"></div>
                  </div>

	

            ii. Replace the hard-coded label "Chart 2" with this:
                
                  <div style="width: 100%; height: 100%" *ngIf="chartType == 2">
                    <!-- This is chartType==2.  So, show chart 2 -->
                    Chart 2
                  </div>
                
                
                With this:
                
                  <div style="width: 100%; height: 100%" *ngIf="chartType == 2">
                    <!-- This is chartType==2.  So, show chart 2 -->
                    <div style="width: 100%; height: 100%" id="chart2"></div>
                  </div>


       b. Edit welcome.component.ts 

       c. Replace its contents with this:    (changes in bold)

            
            import {AfterViewInit, Component, OnDestroy, OnInit} from '@angular/core';
            import {FormBuilder, FormControl} from "@angular/forms";
            import {CdkDragDrop, moveItemInArray} from "@angular/cdk/drag-drop";
            import {Subscription} from "rxjs";
            
            
            import * as Highcharts from "highcharts";
            window.Highcharts = Highcharts;
            
            // Turn on the highchart context menu view/print/download options
            import HC_exporting from "highcharts/modules/exporting";
            HC_exporting(Highcharts);
            
            // Turn on the highchart context menu *export* options
            // NOTE:  This provides these menu options: Download CSV, Download XLS, View Data Table
            import HC_exportData from "highcharts/modules/export-data";
            HC_exportData(Highcharts);
            
            // Do client-side exporting (so that the exporting does *NOT* go to https://export.highcharts.com/
            // NOTE:  This does not work on all web browsers
            import HC_offlineExport from "highcharts/modules/offline-exporting";
            HC_offlineExport(Highcharts);
            
            // Turn on the drill-down capabilities
            import HC_drillDown from "highcharts/modules/drilldown";
            import {DashboardDataDTO} from "../models/dashboard-data-dto";
            import {DashboardService} from "../services/dashboard.service";
            import {Chart} from "highcharts";
            HC_drillDown(Highcharts);
            
            
            @Component({
              selector: 'app-welcome',
              templateUrl: './welcome.component.html',
              styleUrls: ['./welcome.component.css']
            })
            export class WelcomeComponent implements OnInit, OnDestroy, AfterViewInit {
              public  selectedVisibleControls: FormControl;
              public  listOfVisibleCharts: number[] = [1, 2, 3, 4];
              private selectedVisibleControlsSubscription: Subscription;
              public  disableGridDragDrop: boolean = false;
              private pageIsInitialized: boolean = false;
              public  dataIsLoading: boolean = false;
            
              constructor(private formBuilder: FormBuilder,
                        private dashboardService: DashboardService) {
              }
            
              public ngOnInit(): void {
                // Create a form control that lists which controls are visible
                this.selectedVisibleControls = this.formBuilder.control(this.listOfVisibleCharts, null);
            
                this.selectedVisibleControlsSubscription =
            this.selectedVisibleControls.valueChanges.subscribe((arrayOfSelectedValues: number[]) => {
                // User selected some values inj the multi-select dropdown
            
                // Change the public list of numbers (which causes charts to appear/disappear)
                this.listOfVisibleCharts = arrayOfSelectedValues;
            
                if (this.pageIsInitialized) {
                    // Render the charts (if they are set as visible)
                    this.reloadData()
                }
                })
              }
            
              public ngOnDestroy(): void {
                if (this.selectedVisibleControlsSubscription) {
                this.selectedVisibleControlsSubscription.unsubscribe();
                }
              }
            
            
              public ngAfterViewInit(): void {
                // Reload chart data
                // NOTE:  This call must be in ngAfterContentInit() and not in ngOnInit()
                this.reloadData();
            
                this.pageIsInitialized = true;
              }
            
              public drop(aEvent: CdkDragDrop<number[]>) {
                // Re-order the array
                moveItemInArray(this.listOfVisibleCharts, aEvent.previousIndex, aEvent.currentIndex);
              }
            
            
              public userChangedDragAndDropMode(aNewDragMode: number) {
                if (aNewDragMode == 10) {
                // User selected to enable chart drag & drop
                this.disableGridDragDrop = false;
                } else if (aNewDragMode == 11) {
                // User selected to enable Grid drag & drop  (so disable the cdk drag and drop)
                this.disableGridDragDrop = true;
                }
              }
            
            
            
              public reloadData(): void {
                this.dataIsLoading = true;
            
                // Run this code in setInterval() so the code is executed after angular does a refresh
                // NOTE:  the ms wait does not matter
                let intervalFunction = setInterval(() => {
            
                this.dashboardService.getAllChartData().subscribe((aData: DashboardDataDTO) => {
                    // The REST call came back with data
                    if (this.listOfVisibleCharts.includes(1)) {
                    // Set the data for chart 1 and *render* chart 1
                    this.chartOptions1.series[0].data = aData.chartData1;
                    Highcharts.chart('chart1', this.chartOptions1);
                    }
            
                    if (this.listOfVisibleCharts.includes(2)) {
                    this.chartOptions2.series = aData.chartData2;
                    Highcharts.chart('chart2', this.chartOptions2);
                    }
            
                // Redraw all charts on this page (so they fit perfectly in the <mat-card> tags)
                    Highcharts.charts.forEach(function (chart: Chart | undefined) {
                    chart?.reflow();
                    });
            
            
                }).add(() => {
                    // REST call finally block
            
               
                    this.dataIsLoading = false;
            
                    // Whether the REST endpoint worked or not, clear the interval
                    clearInterval(intervalFunction);
                });
            
                }, 1);
            
              } // end of reloadData()
            
            
            
              private chartOptions1: any = {
                credits: {
                enabled: false    	// Hide the highcharts.com label
                },
                caption: {
                text: ''
                },
                chart: {
                type: 'pie'
                },
                title: {
                text: 'Pending Case Distribution'
                },
                subtitle: {
                text: ''
                },
                accessibility: {
                announceNewData: {
                    enabled: true
                },
                point: {
                    valueSuffix: '%'
                }
                },
                plotOptions: {
                series: {
                    enableMouseTracking: true,
                    dataLabels: {
                    enabled: true,
                    format: '<b>{point.name}</b>:<br>{point.percentage:.1f} %<br>value: {point.y}'
                    }
                }
                },
                tooltip: {
                headerFormat: '<span style="font-size:11px">{series.name}</span><br>',  	pointFormat: '<span style="color:{point.color}">{point.name}</span>: <b>{point.y}</b> or <b>{point.percentage:.1f}%</b> of total<br/>'
                },
                series: [
                {
                    panning: false,
                    dragDrop: {
                    draggableY: false,
                    draggableX: false
                    },
                    name: "Browsers",
                    colorByPoint: true,
                    data: [],
            
                    point:{
                    events:{
                        click: (event: any) => {
                        this.logPointInfo(event)
                        }
                    }
                    }
            
                }
                ],
                exporting: {
                buttons: {
                    contextButton: {
                    menuItems:  [
                        'viewFullscreen',
                        'printChart',
                        'separator',
                        'downloadPNG',
                        'downloadJPEG',
                        'downloadPDF',
                        'downloadSVG',
                        'separator',
                        'downloadCSV',
                        'downloadXLS'
                    ]
                    }
                }
                },
            
                annotations: [{
                labels: [{
                    point: 'max',
                    text: 'Max'
                }],
                draggable: ""
                }]
            
              };
            
            
              public logPointInfo(event: any): void {
                console.log('name=' + event.point.name + '  x=' + event.point.x + '  y=' +
            event.point.y + '  percent=' + event.point.percentage);
              }
            
              // Chart 2 is a bar chart2
              private chartOptions2: any = {
                chart: {
                type: 'column'   // Uuse type:'bar' for horizontal chart.  Use type:'column' for vertical bar chart
                },
                credits: {
                enabled: false    	// Hide the highcharts.com label
                },
                title: {
                text: 'Case Timeliness of Closes Cases (Days)'
                },
                xAxis: {
                categories: ['0-30', '31-60', '61-90', '91-120', '121-150', '151-180', '181-210', '211-240', '241-270', '271-300', '301+']
                },
                yAxis: {
                min: 0,
                title: {
                    text: 'Number of Cases'
                }
                },
                legend: {
                reversed: false
                },
                plotOptions: {
                series: {
                    enableMouseTracking: true,
                    stacking: 'normal'
                }
                },
            
                series: [],
                exporting: {
                buttons: {
                    contextButton: {
                    menuItems:  [
                        'viewFullscreen',
                        'printChart',
                        'separator',
                        'downloadPNG',
                        'downloadJPEG',
                        'downloadPDF',
                        'downloadSVG',
                        'separator',
                        'downloadCSV',
                        'downloadXLS'
                    ]
                    }
                }
                }
              };
            
            }
 





       d. Activate the debugger on "Full WebApp" and verify that you see 2 charts:
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson28a_image10.png)
```
Now, you can drag & drop the charts and drag & drop the grids!!





    9. Update the charts so that they resize if the user shows/hides the left-side navbar
       a. Edit welcome.component.ts


       b. Add a private subscription:
             private navbarSubscription: Subscription;


       c. Inject the navbarService, so your constructor looks like this:

              constructor(private formBuilder: FormBuilder,
                        private dashboardService: DashboardService,
                        private navbarService: NavbarService) {
              }


       d. Adjust the ngOnInit so listen for navbar changes.  Add this to ngOnInit():

            this.navbarSubscription = this.navbarService.getNavbarStateAsObservable().subscribe(() => {
            // The user has made the left navbar hidden or visible
        
            // Redraw all of the charts on this page (so they fit perfectly within the mat-card tags
            this.resizeChartsToFitContainers();
            })


       e. Add this to ngOnDestroy():
        
            if (this.navbarSubscription) {
                this.navbarSubscription.unsubscribe();
            }


       f. Add this private method:
            
              /*
               * Send a 'resize' event
               * This will cause HighCharts to resize all charts to fit inside their parent containers
               */
              private resizeChartsToFitContainers(): void {
            
                setTimeout(()=> {
                // Send a 'resize' event
                // NOTE:  The window.dispatchEvent() call MUST be in a setTimeout or it will not work
                window.dispatchEvent(new Event('resize'));
                }, 200);
              }


       g. Activate the debugger on "Full WebApp" and verify that you see 2 charts:
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson28a_image11.png)
```
NOTE:  Now, if you show/hide the left-side navbar, the charts resize to use the space correctly




    10. Add a set of 3 gauges as one chart (to the welcome page)
        a. Edit welcome.component.html

            i. Add this after the last grid  (as chart type == 5)
                
                <div fxLayout="row" style="width: 100%; height: 100%; " *ngIf="chartType == 5">
                    <!-- Gauge Charts -->
                    <div style="height: 100%" fxFlex="33.3%" id="gaugeChart1"></div>
                    <div style="height: 100%" fxFlex="33.3%" id="gaugeChart2"></div>
                    <div style="height: 100%" fxFlex="33.3%" id="gaugeChart3"></div>
                </div>


            ii. Add an option to the <mat-select>
                  <mat-option [value]=5>Guage Chart</mat-option>




        b. Edit welcome.component.ts

            i.  Add these imports so that we can render gauge charts:
                
                // Included because the solid gauge charts are not included in vanilla Highcharts
                import HC_more from "highcharts/highcharts-more";
                import HC_solidgauge from 'highcharts/modules/solid-gauge';
                HC_more(Highcharts);
                HC_solidgauge(Highcharts);




            ii.  Change the public listOfVisibleCharts to (by default) show chart type == 5:
                  public  listOfVisibleCharts: number[] = [1, 2, 3, 4, 5];


            iii. Add this private variable to the end of the class:
                
                  private gaugeChartOptions: any = {
                    chart: {
                    type: 'solidgauge'
                    },
                    pane: {
                    center: ['50%', '65%'],
                    size: '100%',
                    startAngle: -90,
                    endAngle: 90,
                    background: {
                        backgroundColor: '#EEE',
                        innerRadius: '60%',
                        outerRadius: '100%',
                        shape: 'arc'
                    }
                    },
                
                    credits: {
                    enabled: false
                    },
                
                    exporting: {
                    enabled: false
                    },
                
                    tooltip: {
                    enabled: false
                    },
                
                    // the value axis
                    yAxis: {
                    lineWidth: 0,
                    tickWidth: 0,
                    minorTickInterval: null,
                    tickAmount: 2,
                    labels: {
                        y: 16
                    }
                    },
                
                    plotOptions: {
                    solidgauge: {
                        dataLabels: {
                        y: 5,
                        borderWidth: 0,
                        useHTML: true
                        }
                    }
                    }
                  };


            iv. Change the reloadData() method to this:
                
                  public reloadData(): void {
                    this.dataIsLoading = true;
                
                    // Run this code in setInterval() so the code is executed after angular does a refresh
                    // NOTE:  the ms wait does not matter
                    let intervalFunction = setInterval(() => {
                
                    this.dashboardService.getAllChartData().subscribe((aData: DashboardDataDTO) => {
                        // The REST call came back with data
                            if (this.listOfVisibleCharts.includes(1)) {
                            // Set the data for chart 1 and *render* chart 1
                            this.chartOptions1.series[0].data = aData.chartData1;
                            Highcharts.chart('chart1', this.chartOptions1);
                            }
                
                            if (this.listOfVisibleCharts.includes(2)) {
                            this.chartOptions2.series = aData.chartData2;
                            Highcharts.chart('chart2', this.chartOptions2);
                            }
                
                            if (this.listOfVisibleCharts.includes(5)) {
                
                            // Render guageChart1
                            Highcharts.chart('gaugeChart1', Highcharts.merge(this.gaugeChartOptions, {
                                title: {
                                text: 'Total Units',
                                y: 70
                                },
                                yAxis: {
                                min: 0,
                                max: 20,
                    tickPositions: [0, 20],	// put min and max values in this array
                                stops: [
                                    [1, '#800080'] // purple
                                ],
                                },
                                series: [{
                                name: 'Total Units in System',   // smaller label
                                data: [6],
                                dataLabels: {
                                    format:
                                    '<div style="text-align:center">' +
                                    '<span style="font-size:25px">{y}</span><br/>' +
                                    '<span style="font-size:12px;opacity:0.4">Total Units in System</span>' +
                                    '</div>'
                                }
                                }]
                
                            }));
                
                
                
                            // Render guageChart2
                            Highcharts.chart('gaugeChart2', Highcharts.merge(this.gaugeChartOptions, {
                                title: {
                                text: 'Pending Units',
                                y: 70
                                },
                                yAxis: {
                                min: 0,
                                max: 50,
                    tickPositions: [0, 50],	// put min and max values in this array
                                stops: [
                                    [1, '#FF0000'] // red
                                ],
                                },
                                series: [{
                                name: 'Total Pending Units',
                                data: [15],
                                dataLabels: {
                                    format:
                                    '<div style="text-align:center">' +
                                    '<span style="font-size:25px">{y}</span><br/>' +
                                    '<span style="font-size:12px;opacity:0.4">Total Pending Units</span>' +
                                    '</div>'
                                }
                                }]
                
                            }));
                
                            // Render guageChart3
                            Highcharts.chart('gaugeChart3', Highcharts.merge(this.gaugeChartOptions, {
                                title: {
                                text: 'Work in Progress Units',
                                y: 70
                                },
                                yAxis: {
                                min: 0,
                                max: 50,
                    tickPositions: [0, 50],	// put min and max values in this array
                                stops: [
                                    [1, '#008000'] // green
                                ],
                                },
                                series: [{
                                name: 'Total Work in Progress Units',
                                data: [33],
                                dataLabels: {
                                    format:
                                    '<div style="text-align:center">' +
                                    '<span style="font-size:25px">{y}</span><br/>' +
                                    '<span style="font-size:12px;opacity:0.4">Total Work in Progress Units</span>' +
                                    '</div>'
                                }
                                }]
                
                            }));
                
                            }
                
                        // Redraw all charts on this page (so they fit perfectly in the <mat-card> tags)
                        Highcharts.charts.forEach(function (chart: Chart | undefined) {
                        chart?.reflow();
                        });
                
                    }).add(() => {
                        // REST call finally block
                
                        this.dataIsLoading = false;
                
                        // Whether the REST endpoint worked or not, clear the interval
                        clearInterval(intervalFunction);
                    });
                
                    }, 1);
                
                  } // end of reloadData()


        c. Activate the debugger on "Full WebApp" and verify that you see 3 gauge charts:
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson28a_image12.png)

