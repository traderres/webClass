Lesson X: TITLE
-------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1cAUe2UCepj8N6mQ3O-XfaVRy5P2Q-pKgbLDEq1OM8xk/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson27b/history/add-to-tab
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem:  I want the timeline to show up in the "History" tab
Solution: Use the the new timeline component to create a series of material cards tags.

![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson27b_image1.png)




<br>
<br>

```
Procedure
---------
    1. Add this front-end model class:   HistoryEntryDTO
       a. Generate the model class:
          unix> cd ~/intellijProjects/angularApp1/frontend
          unix> ng generate class  models/historyEntryDTO --skipTests

       b. Replace the contents with this:

            export class HistoryEntryDto {
              public id: number;
              public date: string;
              public dateAsDaysAgo: string;
              public description: string;
              public authorFullName: string;
              public eventType: number;
              public eventTypeDisplayed: string;
              public appState: number;
              public appStateDisplayed: string;
            }



    2. Add this front-end service:  HistoryService  
       And, add a method returns an observable with hardcoded-data

       a. Generate the service:
          unix> cd ~/intellijProjects/angularApp1/frontend
          unix> ng generate service services/history --skipTests

       b. Edit history.service.ts

       c. Replace its contents with this:
            
            import { Injectable } from '@angular/core';
            import {HistoryEntryDto} from "../models/history-entry-dto";
            import {Observable, of} from "rxjs";
            
            @Injectable({
              providedIn: 'root'
            })
            export class HistoryService {
            
              constructor() { }
            
            
              public getListOfHistoryEntries(aReportId: number): Observable<HistoryEntryDto[]> {
                let data: HistoryEntryDto[] = [
                {
                    id: 1,
                    date: "09/01/2020",
                    dateAsDaysAgo: "11 months ago",
                    description: "Description for entry 1 is here",
                    authorFullName: "John Smith",
                    eventType: 1,
                    eventTypeDisplayed: "User Submitted Application",
                    appState: 1,
                    appStateDisplayed: "App Submitted"
                },
                {
                    id: 2,
                    date: "10/01/2020",
                    dateAsDaysAgo: "9 months ago",
                    description: "System Assigned this application to Analyst named Jane Smith",
                    authorFullName: "System",
                    eventType: 2,
                    eventTypeDisplayed: "Application was assigned",
                    appState: 2,
                    appStateDisplayed: "Assigned to Operator"
                },
                {
                    id: 3,
                    date: "3/01/2021",
                    dateAsDaysAgo: "5 months ago",
                    description: "First review of the application",
                    authorFullName: "Jane Smith",
                    eventType: 2,
                    eventTypeDisplayed: "Analysts Reviewed",
                    appState: 2,
                    appStateDisplayed: "In Analysts Review"
                }
                ];
            
                // Return an observable that holds this data
                return of(data);
              }
            
            }
            
            



    3. Add this front-end component:  TabHistory  (that shows the timeline)
       a. Generate the component:
          unix> cd ~/intellijProjects/angularApp1/frontend
          unix> ng generate component tab-history --skipTests

       b. Edit tab-history.component.ts

       c. Replace its contents with this:
            
            import {Component, Input, OnDestroy, OnInit} from '@angular/core';
            import {HistoryService} from "../services/history.service";
            import {Observable} from "rxjs";
            import {HistoryEntryDto} from "../models/history-entry-dto";
            import {FormBuilder, FormGroup} from "@angular/forms";
            
            @Component({
              selector: 'app-tab-history',
              templateUrl: './tab-history.component.html',
              styleUrls: ['./tab-history.component.css']
            })
            export class TabHistoryComponent implements OnInit, OnDestroy {
              @Input() public reportId: number;
            
              public  historyEntriesObs: Observable<HistoryEntryDto[]>;
              public  myForm: FormGroup;
            
            
              constructor(private historyService: HistoryService,
                        private formBuilder: FormBuilder) { }
            
            
              public ngOnInit(): void {
            
                // Get an observable to the list of history entries   (for the history tab)
                // NOTE:  The Async Pipe will subscribe and unsubscribe to this observable
                this.historyEntriesObs = this.historyService.getListOfHistoryEntries(this.reportId);
            
                // Initialize the form (for the timeline filter)
                this.myForm = this.formBuilder.group({
                eventType:   	[null, null],
                eventDateRange:  [0, null],
                eventText:   	[null,  null]
                });
              }
            
            
              public ngOnDestroy(): void {
            
              }
            }





       d. Edit tab-history.component.html

       e. Replace its contents with this:
            
            <div class="tab-content">
              <div style="margin-top: 10px">
            
                <div style="height: calc(100vh - 200px);  padding-bottom: 5px">
                <ng-container *ngIf="(this.historyEntriesObs | async) as historyEntries">
                    <!-- REST call came back with the list of history entries -->
            
                    <ng-container *ngIf="historyEntries.length == 0">
                    <!-- There are *NO* past history entries -->
                    There are no history entries found
                    </ng-container>
            
                    <ng-container *ngIf="historyEntries.length > 0">
                    <!-- There are past history entries -->
            
                    <div fxFlex fxLayout="column" fxLayoutAlign="start stretch" style="margin-left: 50px; margin-right: 50px;">
                        <div fxFlex fxFlexAlign="center">
                        <!-- Timeline Filter -->
                        <form novalidate autocomplete="off" [formGroup]="myForm">
                            <section>
            
                            <!-- Date Range -->
                            <mat-form-field appearance="outline" floatLabel="always">
                                <mat-label>Date Range</mat-label>
            
                                <!-- Event Type Drop Down -->
                                <mat-select formControlName="eventDateRange" placeholder="Date Range">
                                <mat-option [value]=0>All History</mat-option>
                                <mat-option [value]=1>Last 2 days</mat-option>
                                <mat-option [value]=2>Last Week</mat-option>
                                <mat-option [value]=3>Last Month</mat-option>
                                <mat-option [value]=4>Year to Date</mat-option>
                                </mat-select>
            
                            </mat-form-field>
            
                            <!-- Event Type -->
                            <mat-form-field appearance="outline" floatLabel="always">
                                <mat-label>Event Types</mat-label>
            
                                <!-- Event Type Drop Down -->
                                <mat-select multiple formControlName="eventType" placeholder="All Event Types">
                                <mat-option [value]=1>Application Submitted</mat-option>
                                <mat-option [value]=2>Assigned to Manager for Review</mat-option>
                                <mat-option [value]=3>Approved</mat-option>
                        
                                </mat-select>
            
                            </mat-form-field>
            
            
            
                            <!-- Event Text -->
                            <mat-form-field appearance="outline" floatLabel="always">
                                <mat-label>Event Text</mat-label>
            
                                <!-- Event  Textbox -->
                                <input matInput type="text" formControlName="eventText" placeholder="Enter event text...." />
            
                            </mat-form-field>
            
                            <!-- Apply Filter button -->
                            <button type="button" mat-flat-button color="primary" title="Apply Filter">Filter</button>
            
                            </section>
                        </form>
                        </div>   <!-- End of div that holds timeline filter -->
            
            
                        <div>
                        <!-- Timeline -->
                        <timeline style="margin-bottom: 20px; margin-top: 20px">
            
                            <timeline-item *ngFor="let historyEntry of historyEntries" color="grey">
                            <mat-card class="mat-elevation-z6" style="z-index: 20; background: white">
            
                                <mat-card-title class="timeline-card">{{historyEntry.authorFullName}}</mat-card-title>
            
                                <mat-card-content>
                                <h4>{{historyEntry.appStateDisplayed}}</h4>
                                <p>{{historyEntry.description}}</p>
                                </mat-card-content>
            
                                <mat-card-subtitle>Additional information would be here</mat-card-subtitle>
            
                                <mat-card-actions class="timeline-footer">
                                <!-- Card Footer -->
                                {{historyEntry.appStateDisplayed}}
            
                                <div fxFlex fxLayoutAlign="end end">
                                    {{historyEntry.date}}
                                </div>
                                </mat-card-actions>
                            </mat-card>
            
                            </timeline-item>
            
                        </timeline>
                        </div>
            
                    </div>
            
            
                    </ng-container>
            
                </ng-container>   <!-- End of async pipe for historyEntriesObs -->
            
            
                </div>
              </div>
            </div>




       f. Edit tab-history.component.css

       g. Replace its contents with this:
            
            .timeline-card {
              padding: 5px 0 5px 0;
            
              /* Permalink - use to edit and share this gradient:
            https://colorzilla.com/gradient-editor/#ffffff+20,ffffff+45,009ffd+100 */
              background: #ffffff; /* Old browsers */
              background: -moz-linear-gradient(left,  #ffffff 20%, #ffffff 45%, #009ffd 100%); /* FF3.6-15 */
              background: -webkit-linear-gradient(left,  #ffffff 20%,#ffffff 45%,#009ffd 100%); /* Chrome10-25,Safari5.1-6 */
              background: linear-gradient(to right,  #ffffff 20%,#ffffff 45%,#009ffd 100%); /* W3C, IE10+, FF16+, Chrome26+, Opera12+, Safari7+ */
              filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#ffffff', endColorstr='#009ffd',GradientType=1 ); /* IE6-9 */
            }
            
            .timeline-footer {
              padding: 5px 0 5px 0;
              margin-left: 0;
              margin-right: 0;
            
              border-top: 1px solid rgba(0, 0, 0, 0.40);
            }
            
            
            section {
              /* Wrapper tag used to align the "filter" button with the form fields */
              display: flex;
              align-items: flex-start;
            }
            
            section button {
              /* Align the "Filter" button with the form fields */
              margin-top: 0.50em;
              padding: 0.38em	0   0.38em  0;
              width: 100px;
            }
            
            


    4. Add the "history-tab" component to the Tab Group Page
       a. Edit tab-group.component.html

       b. Delete the old <mat-tab> tag for "History"

       c. Insert this history tag

          	<mat-tab label="History" title="History">
            	<!-- 	H I S T O R Y 	               T A B 	-->
            	<app-tab-history [reportId]=25></app-tab-history>
          	</mat-tab>



    5. Try it out
       a. Activate the Debugger on "Full WebApp"
       b. Click on "Tab Group"
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson27b_image2.png)
```
History Tab on a wider browser


       c. Narrow the browser so it's not as wide
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson27b_image3.png)
```
History Tab when the browser is narrowed to 1200px or less
NOTE:  This can be adjusted by editing the max-width: 1200px in timeline.component.css


```
