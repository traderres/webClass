Lesson 30c: Tab Group Page / Add "Critical Reports" Grid to Tab
---------------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1MJ58GbvJG2vO3OH6AXSbG93ncnR9OOnYlwKz8AObc2k/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson30c/tab-group/add-critical-reports-grid
<br>
<br>
<br>

<h3> Problem Set </h3>
In this lesson, we will add the <b>server-side grids</b> to the page<br>
The "Critical Reports" tab will show a server side grid that is limited to reports with priority=critical<br>
The "All Reports" tab will show all reports<br>
<br>

![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson30c_image1.png)






<br>
<br>

```
Procedure
---------
    1. Add a REST call that limits results to "Critical Reports" only
       a. Edit GridController.java

       b. Add this private method:
            
            private void setDefaultSearchForGrid(GridGetRowsRequestDTO aGridRequestDTO, String aDefaultQueryString) {
            
                if (StringUtils.isBlank(aGridRequestDTO.getRawSearchQuery())) {
                    // Search text is empty so set it to search for registered users
                    aGridRequestDTO.setRawSearchQuery(aDefaultQueryString);
                } else {
                    // Search text is not empty so AND the default search text to the original query
                    String newSearchText = aGridRequestDTO.getRawSearchQuery() + " AND " + aDefaultQueryString;
                    aGridRequestDTO.setRawSearchQuery(newSearchText);
                }
            }


       c. Add this public method   (acts as the REST endpoint used by the server-side ag-grid)
            
            /**
             * The "Critical Reports" AG-Grid calls this REST endpoint to load the grid in server-side mode
             *
             * @param aGridRequestDTO holds the Request information
             * @return ResponseEntity that holds a GridGetRowsResponseDTO object
             * @throws Exception if something bad happens
             */
            @RequestMapping(value = "/api/grid/critical-reports/getRows", method = RequestMethod.POST, produces = "application/json")
            public ResponseEntity<?> getRowsForCriticalReports(@RequestBody GridGetRowsRequestDTO aGridRequestDTO) throws Exception {
                logger.debug("getRowsForCriticalReports() started.");
            
                if (aGridRequestDTO.getStartRow() >= aGridRequestDTO.getEndRow() ) {
                    // This is an invalid request
                    return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                            .contentType(MediaType.TEXT_PLAIN)
                            .body("The endRow must be greater than the startRow.");
                }
            
                // Set default raw-query string for this grid  (to limit all results to the critical reports)
                setDefaultSearchForGrid(aGridRequestDTO, "priority.sort:critical");
            
                // Change the sort field from "priority" to "priority.sort"  (so the sort is case insensitive -- see the mapping)
                changeSortFieldToUseElasticFieldsForSorting(aGridRequestDTO, "id");
            
                // Set Default sorting
                //  1) If the sorting model is not empty, then do nothing
                //  2) If the sorting model to empty and rawSearchQuery is empty, then sort by "id" ascending
                //  3) If the sorting model is empty and rawSearchQuery is not empty, then sort by "_score" descending
                setDefaultSorting(aGridRequestDTO, "id");
            
                // Create an array of ES fields to **SEARCH**
                List<String> esFieldsToSearch = Arrays.asList("id.sort", "description", "display_name.sort", "priority.sort");
            
                // Create an array of ES fields to **RETURN**   (if this list is empty, then ES will return all fields in the ES mapping)
                List<String> esFieldsToReturn = Arrays.asList("id", "description", "display_name", "priority");
            
                // Invoke the GridService to run a search
                GridGetRowsResponseDTO responseDTO = gridService.getPageOfData("reports", esFieldsToSearch, esFieldsToReturn, aGridRequestDTO);
            
                // Return the responseDTO object and a 200 status code
                return ResponseEntity
                        .status(HttpStatus.OK)
                        .body(responseDTO);
            }
            


    2. Add a method to the front-end grid.service.ts that will invoke this REST call
       a. Edit grid.service.ts

       b. Add this public method:

            
              /*
               * The "Critical Reports" srever side grid invokes this REST endpoint to get data for the grid
               */
              public getServerSideDataForCriticalReports(aGridGetRowsRequestDTO: GridGetRowsRequestDTO): Observable<GridGetRowsResponseDTO> {
                // Construct the URL of the REST call
                const restUrl = environment.baseUrl + '/api/grid/critical-reports/getRows';
            
                // Use a POST call to send a JSON body of info
                return this.httpClient.post <GridGetRowsResponseDTO> (restUrl, aGridGetRowsRequestDTO, {} );
              }
            
            


    3. Create a small component (that holds the "Critical Reports" server side grid and buttons)
       a. Generate the component
          unix> cd ~/intellijProjects/angularApp1/frontend
          unix> ng generate component analytics/grid-tab-group/critical-reports-grid --skipTests

       b. Edit critical-reports-grid.component.ts
            
            Replace its contents with this:
            
            import {AfterViewInit, Component, ElementRef, OnDestroy, OnInit, ViewChild} from '@angular/core';
            import {ColumnApi, ColumnState, GridApi, GridOptions, IServerSideDatasource, IServerSideGetRowsParams,  ServerSideStoreType} from "ag-grid-community";
            import {GridGetRowsRequestDTO} from "../../../models/grid/grid-get-rows-request-dto";
            import {GridGetRowsResponseDTO} from "../../../models/grid/grid-get-rows-response-dto";
            import {GridService} from "../../../services/grid.service";
            import {Subject, Subscription} from "rxjs";
            import {ThemeOptionDTO} from "../../../models/theme-option-dto";
            import {ApplyColumnStateParams} from "ag-grid-community/dist/lib/columnController/columnApi";
            import {PreferenceService} from "../../../services/preference.service";
            import {ThemeService} from "../../../services/theme.service";
            import {debounceTime, switchMap} from "rxjs/operators";
            import {Constants} from "../../../utilities/constants";
            import {GetOnePreferenceDTO} from "../../../models/preferences/get-one-preference-dto";
            
            @Component({
              selector: 'app-critical-reports-grid',
              templateUrl: './critical-reports-grid.component.html',
              styleUrls: ['./critical-reports-grid.component.css']
            })
            export class CriticalReportsGridComponent implements OnInit, OnDestroy, AfterViewInit {
              private readonly PAGE_NAME: string = "critical-reports-server-grid";
              private userHasPastColumnState: boolean = false;
              private listenForGridChanges: boolean = false;
              private saveGridColumnStateEventsSubject: Subject<any> = new Subject();
              private saveGridEventsSubscription: Subscription;
            
              private themeStateSubscription: Subscription;
              public  currentTheme: ThemeOptionDTO;
            
              private searchAfterClause: string | null;
              public  totalMatches: number = 0;
              public  rawSearchQuery: string = "";
              public  isValidQuery: boolean = true;
            
            
              public gridOptions: GridOptions = {
                debug: false,
                suppressCellSelection: true,
                rowSelection: 'multiple',  	// Possible values are 'single' and 'multiple'
                domLayout: 'normal',
                rowModelType: 'serverSide',	// Possible values are 'clientSide', 'infinite', 'viewport', and 'serverSide'
                pagination: false,    	// Do not show the 1 of 20 of 20, page 1 of 1 (as we are doing infinite scrolling)
            
                serverSideStoreType: ServerSideStoreType.Partial,   // Use partial Server Side Store Type so that pages of data are loaded
                cacheBlockSize: 50,                             	// Load 50 records at a time with each REST call
                blockLoadDebounceMillis: 100,
                debounceVerticalScrollbar: true,
                overlayNoRowsTemplate: "<span class='no-matches-found-message'>No matches were found</span>",
            
                onFilterChanged: () => {
                // The user changed a filer.  So, clear the grid cache before the REST endpoint is invoked
                this.clearGridCache();
                },
            
                onSortChanged: () => {
                // The user changed a sort.  So, clear the grid cache before the REST endpoint is invoked
                this.clearGridCache();
                },
            
                onDragStopped: () => {
                // User finished resizing or moving column
                this.saveColumnState();
                },
            
                onDisplayedColumnsChanged: () => {
                this.saveColumnState();
                },
            
                onColumnVisible: () => {
                this.saveColumnState();
                },
            
                onColumnPinned: () => {
                this.saveColumnState();
                }
              }
            
            
              private saveColumnState(): void {
                if (this.listenForGridChanges) {
                // The grid has rendered data.  So, save the sort/column changes
            
                // Get the current column state
                let currentColumnState = this.gridColumnApi.getColumnState();
            
                // Send a message to save the current column state
                this.saveGridColumnStateEventsSubject.next(currentColumnState)
                }
              }
            
            
              public firstDataRendered(): void {
                // The grid is fully rendered.  So, set the flag to start saving sort/column changes
                this.listenForGridChanges = true;
              }
            
              private clearGridCache(): void {
            
                if (this.totalMatches > 0) {
                // The last search had matches and we are clearing the grid cache.
            
                // So, move the scrollbar to the top
                this.gridApi.ensureIndexVisible(0, 'top');
                }
            
                // Clear the cache
                this.gridApi?.setServerSideDatasource(this.serverSideDataSource);
              }
            
            
            
              /*
               * Clear all grid sorting
               */
              private clearGridSorting(): void {
            
                let columnState: ApplyColumnStateParams = new class implements ApplyColumnStateParams {
                applyOrder: boolean;
                defaultState: ColumnState;
                state: ColumnState[];
                }
            
                this.gridColumnApi.applyColumnState(columnState);
              }
            
            
            
            
              /*
               * User pressed the Reset Button
               *  1. Clear the grid cache
               *  2. Clear all sorting
               *  3. Clear all filters
               *  4. Empty the search box
               *  5. Force the grid to invoke the REST endpoint by calling onFilterChanged()
               */
              public resetGrid(): void {
                // Clear the grid cache and move the vertical scrollbar to the top
                this.clearGridCache();
            
                // Clear all sorting
                this.clearGridSorting();
            
                // Clear the filters
                this.gridApi.setFilterModel(null);
            
                // Clear the search box
                this.rawSearchQuery = "";
            
                // Force the grid to invoke the REST endpoint
                this.gridApi.onFilterChanged();
            
                // Reset columns (so they are visible and restored to default)
                this.gridColumnApi.resetColumnState();
              }
            
            
              /*
               * User clicked to run a search
               *  1. Clear the grid cache
               *  2. Clear all sorting
               *  3. Clear all filters
               *  4. Force the grid to invoke the REST endpoint by calling onFilterChanged()
               */
              public runSearch(): void {
                this.clearGridCache();
            
                // Clear all sorting
                this.clearGridSorting();
            
                // Clear the filters
                this.gridApi.setFilterModel(null);
            
                // Force the grid to invoke the REST endpoint
                this.gridApi.onFilterChanged();
              }
            
            
              /*
               * Create a server-side data source object
               *
               * The getRows() method is invoked when a user scrolls down (to get more rows)
               * The getRows() method is invoked when a user changes a filter
               * The getRows() method is invoked when a user changes sorting
               * The getRows() method is invoked manually when the code calls this.gridApi.onFilterChanged()
               */
              private serverSideDataSource: IServerSideDatasource = {
                getRows: (params: IServerSideGetRowsParams) => {
                // The grid needs to load data.  So, subscribe to gridService.getServerSideData() and load the data
            
                if (params.request.startRow == 0) {
                    // The user is requesting a first page (so we are not getting a 2nd or 3rd page)
                    // -- Reset the additional sort fields  (needed for the 2nd, 3rd, 4th pages)
                    this.searchAfterClause = null;
                }
            
                if (this.totalMatches == 0) {
                    this.gridApi.hideOverlay();
                }
            
                // Add the additional sort fields to the request object
                let getRowsRequestDTO: GridGetRowsRequestDTO = new GridGetRowsRequestDTO(params.request, this.searchAfterClause, this.rawSearchQuery)
            
                // Subscribe to this service method to get the data
                this.gridService.getServerSideDataForCriticalReports(getRowsRequestDTO)
                    .subscribe((response: GridGetRowsResponseDTO) => {
                    // REST Call finished successfully
            
                    this.isValidQuery = response.isValidQuery;
            
                    if (! response.isValidQuery) {
                        // The user entered an invalid search
            
                        // Set the flag to false (so the search box changes color)
                        this.isValidQuery = false;
            
                        // Update total matches on the screen
                        this.totalMatches = 0;
            
                        // Show the 'no matches were found'
                        this.gridApi.showNoRowsOverlay();
            
                        // Tell the ag-grid that there were no results
                        params.successCallback([], 0);
                        return;
                    }
            
                    // Save the additional sort fields  (we will use when getting the next page)
                    this.searchAfterClause = response.searchAfterClause;
            
                    // Update total matches on the screen
                    this.totalMatches = response.totalMatches;
            
                    if (this.totalMatches == 0) {
                        this.gridApi.showNoRowsOverlay();
                    }
            
                    // Load the data into the grid and turn on/off infinite scrolling
                    // If lastRow == -1,       	then Infinite-Scrolling is turned ON
                    // if lastRow == totalMatches, then infinite-scrolling is turned OFF
                    params.successCallback(response.data, response.lastRow)
                    });
            
                }
              };
            
            
            
              public defaultColDefs: any = {
                flex: 1,
                sortable: true,
                filter: true,
                floatingFilter: true,	// Causes the filter row to appear below column names
                autoHeight: true,
                resizable: true
              };
            
            
              private textFilterParams = {
                filterOptions: ['contains', 'notContains'],
                caseSensitive: false,
                debounceMs: 200,
                suppressAndOrCondition: true,
              };
            
              public columnDefs = [
                {
                headerName: 'Id',
                field: 'id',
                filter: 'agNumberColumnFilter',       	// numeric filter
                filterParams: this.textFilterParams,
                cellClass: 'grid-text-cell-format',
                checkboxSelection: false
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
            
              // This is a map of component names that correspond to components that implement ICellRendererAngularComp
              public  frameworkComponents: any = {  };
            
              private gridApi: GridApi;
              private gridColumnApi: ColumnApi;
            
              @ViewChild('searchBox',  { read: ElementRef }) searchBox: ElementRef;
            
              constructor(private gridService: GridService,
                        private preferenceService: PreferenceService,
                        private themeService: ThemeService) {}
            
              public ngOnInit(): void {
            
                // Listen for changes from the theme service
                this.themeStateSubscription = this.themeService.getThemeStateAsObservable().subscribe( (aNewTheme: ThemeOptionDTO) => {
                // The theme has changed.
                this.currentTheme = aNewTheme;
                });
            
                // Listen for save-grid-column-state events
                // NOTE:  If a user manipulates the grid, then we could be sending LOTS of save-column-state REST calls
                //    	The debounceTime slows down the REST calls
                //    	The switchMap cancels previous calls
                //    	Thus, if there are lots of changes to the grid, we invoke a single REST call using the *LAST* event (over a span of 250 msecs)
                this.saveGridEventsSubscription = this.saveGridColumnStateEventsSubject.asObservable().pipe(
                debounceTime(250),     	// Wait 250 msecs before invoking REST call
                switchMap( (aNewColumnState: any) => {
                    // Use the switchMap for its cancelling effect:
                    // On each observable, the previous observable is cancelled
            
                    // Return an observable
                    // Invoke the REST call to save it to the back end
                    return this.preferenceService.setPreferenceValueForPageUsingJson(Constants.COLUMN_STATE_PREFERENCE_NAME, aNewColumnState, this.PAGE_NAME)
                })
                ).subscribe();
            
              }  // end of ngOnInit()
            
            
              public ngAfterViewInit(): void {
                // Set the focus on the search box
                setTimeout(() => this.searchBox.nativeElement.focus(), 10);
              }
            
            
              public ngOnDestroy(): void {
                if (this.themeStateSubscription) {
                this.themeStateSubscription.unsubscribe();
                }
            
                if (this.saveGridEventsSubscription) {
                this.saveGridEventsSubscription.unsubscribe();
                }
            
                if (this.saveGridColumnStateEventsSubject) {
                this.saveGridColumnStateEventsSubject.unsubscribe();
                }
              }
            
            
              /*
               * The grid calls onGridReady() once it is fully initialized.  This is the start of this page.
               *  1. Invoke a REST call to get the grid preferences
               *  2. When the REST call returns
               *  	a. Configure the grid with the correct columns
               *  	b. Initialize the server-side data source
               *     	(which will cause the getRows() REST endpoint to be called asynchronously)
               */
              public onGridReady(params: any): void {
                // Get a reference to the gridApi and gridColumnApi (which we will need later to get selected rows)
                this.gridApi = params.api;
                this.gridColumnApi = params.columnApi;
            
                this.preferenceService.getPreferenceValueForPage( Constants.COLUMN_STATE_PREFERENCE_NAME, this.PAGE_NAME).subscribe( (aPreference: GetOnePreferenceDTO) => {
                // REST call came back.  I have the grid preferences
            
                if (! aPreference.value) {
                    // There is no past column state
                    this.userHasPastColumnState = false;
                }
                else {
                    // There is past column state
                    let storedColumnStateObject = JSON.parse(aPreference.value);
            
                    // Set the grid state -- e.g., set the column widths, column order, visible columns
                    this.gridColumnApi.applyColumnState( { state: storedColumnStateObject,  applyOrder: true} );
            
                    // Clear all sorting
                    this.clearGridSorting();
            
                    // Clear any filtering
                    this.gridApi.setFilterModel(null);
            
                    this.userHasPastColumnState = true;
                }
            
                // Set the server-side data source
                // NOTE:  The grid will asynchronously call getRows() as it needs to load data
                this.gridApi.setServerSideDatasource(this.serverSideDataSource);
            
                });
            
              }  // end of onGridReady()
            
            }
            
            
            


       c. Edit critical-reports-grid.component.html
            
          Replace its contents with this:
            
            <div style="margin-top: 25px">
              <div fxFlex fxLayout="row">
                <div fxFlex fxLayoutAlign="left end" fxLayout="row" fxLayoutGap="0">
                <!-- Left side of the button row -->
                <button mat-stroked-button type="button" color="primary" title="Reset Grid" aria-label="Reset Grid" (click)="this.resetGrid()">Reset</button>
                </div>
            
                <!-- Center of the "button row"  -->
                <div fxFlex fxLayoutAlign="center center" fxLayout="row" fxLayoutGap="0">
            
                <div [ngClass]="{   'light':   this.currentTheme.isLightMode == true,
                                        'dark':	this.currentTheme.isLightMode == false
                            }">
            
                    <div   [ngClass]="{   'light searchBoxWrapperValid   fa-border':  this.isValidQuery == true,
                                        'dark searchBoxWrapperInvalid fa-border':  this.isValidQuery == false }">
            
                    <!-- Search Box -->
                    <input matInput type="text"  #searchBox [(ngModel)]="this.rawSearchQuery" (keyup.enter)="this.runSearch()"
                            [ngClass]="{   'searchBoxValid':  this.isValidQuery == true,
                                            'searchBoxInvalid':   this.isValidQuery == false } "
                            placeholder="Enter Criteria..."
                            autocomplete="off"
                            aria-label="search box" />
            
                    <!-- Search Icon -->
                    <span class="searchBoxIcon" (click)="this.runSearch()">
                            <i class="fa fa-search"></i>
                            </span>
                    </div>
            
                </div>
                </div>
            
                <div fxFlex fxLayoutAlign="end end" fxLayout="row" fxLayoutGap="0">
                <!-- Right side of the button row -->
                <b>{{this.totalMatches | number }} matches</b>
                </div>
              </div>
            </div>
            
            <!-- Set the grid to use the entire height (except for the height of the header and page title) -->
            <div style="height: calc(100vh - 265px); margin-top: 5px;">
            
              <!-- Angular Grid:  NOTE: Angular flex layout does not work with ag-grid-angular -->
              <ag-grid-angular
                style="width: 100%; height: 100%;"
                [ngClass]="{   'ag-theme-alpine':   	this.currentTheme.isLightMode == true,
                            'ag-theme-alpine-dark':  this.currentTheme.isLightMode == false
                        }"
                [gridOptions]="this.gridOptions"
                [defaultColDef]="this.defaultColDefs"
                [columnDefs]="this.columnDefs"
                [frameworkComponents]="this.frameworkComponents"
                (firstDataRendered)="this.firstDataRendered()"
                (gridReady)="this.onGridReady($event)">
              </ag-grid-angular>
            
            </div>




       d. Edit critical-reports-grid.component.css
            
          Replace its contents with this:
            
            :host ::ng-deep .ag-body-viewport.ag-layout-normal {
              /* Force ag-grid to show a vertical scrollbar all of the time to avoid the "bump" */
              /* The bump appears when the user searches for something that has no matches, then vertical scrollbar disappears and the columns move over */
              overflow-y: scroll;
            }
            
            
            /**********   L I G H T  	M O D E  **********/
            .light .searchBoxValid  {
              width: 250px;            	/* Set the width of the search box */
              padding: 6px 0 6px 8px;  	/* The last padding value determines how far indented the textbox appears in the wrapper */
              background-color: #dcdcdc;   /* light white color */
              border: 0;
            
              /* Remove the outline that appears when clicking in textbox */
              outline: none;
            
              margin-left: 3px;   /* Push the search box to the right inside the wrapper */
            }
            
            
            .light .searchBoxInvalid  {
              width: 250px;        	/* Set the width of the search box */
              padding: 6px 0 6px 8px;
              background-color: red;   /* light white color */
              color: white;
              caret-color: white;
              border: 0;
            
              /* Remove the outline that appears when clicking in textbox */
              outline: none;
            
              margin-left: 3px;   /* Push the search box to the right inside the wrapper */
            }
            
            
            .light .searchBoxWrapperValid  {
              background-color: #dcdcdc;
              border-radius: 9px;  	/* Controls the rounded corners */
              border: 0;
            
              /* Center the search box and the icon */
              display: flex;
              flex-direction: row;
              align-items: center;
            }
            
            
            .light .searchBoxWrapperInvalid {
              background-color: red;
              color: white;
              border-radius: 9px;  	/* Controls the rounded corners */
              border: 0;
            
              /* Center the search box and the icon */
              display: flex;
              flex-direction: row;
              align-items: center;
            }
            
            
            .light .searchBoxIcon {
              color: black;
              padding: 6px 6px 6px 1px;
              cursor: pointer;
              border: 0;
              background-color: transparent;
            }
            
            
            
            
            /**********   D A R K   	M O D E  **********/
            .dark .searchBoxValid {
              width: 250px;               	/* Set the width of the search box */
              padding: 6px 0 6px 8px;     	/* The last padding value determines how far indented the textbox appears in the wrapper */
              background-color: transparent;  /* The searchboxWrapper sets the background-color */
              color: white;
              caret-color: white;
              border: 0;
            
              /* Remove the outline that appears when clicking in textbox */
              outline: none;
            
              margin-left: 3px;   /* Push the search box to the right inside the wrapper */
            }
            
            
            .dark .searchBoxInvalid {
              width: 250px;        	/* Set the width of the search box */
              padding: 6px 0 6px 8px;
              background-color: red;   /* invalid background color */
              color: white;
              caret-color: white;
              border: 0;
            
              /* Remove the outline that appears when clicking in textbox */
              outline: none;
            
              margin-left: 3px;   /* Push the search box to the right inside the wrapper */
            }
            
            
            .dark .searchBoxWrapperValid {
              background-color: #111111;
              caret-color: white;
              border-radius: 9px;  	/* Controls the rounded corners */
              border: 0;
            
              /* Center the search box and the icon */
              display: flex;
              flex-direction: row;
              align-items: center;
            }
            
            
            .dark .searchBoxWrapperInvalid {
              background-color: red;
              caret-color: white;
              border-radius: 9px;  	/* Controls the rounded corners */
              border: 0;
            
              /* Center the search box and the icon */
              display: flex;
              flex-direction: row;
              align-items: center;
            }
            
            
            .dark .searchBoxIcon {
              color: #dcdcdc;
              padding: 6px 6px 6px 10px;
              cursor: pointer;
              border: 0;
              background-color: transparent;
            }
            
            
             


    4. Add the small component to the tab group page
       a. Edit grid-tab-group-page.component.html

       b. Change this HTML from this:
              <!-- Critical Reports Tab -->
              <mat-tab label="Critical Reports">
                <div class="tab-content">
                Critical Reports
                </div>
              </mat-tab>
            
            
          To this:
              <!-- Critical Reports Tab -->
              <mat-tab label="Critical Reports">
                <div class="tab-content">
              
                <!-- Critical Reports Grid -->
                <app-critical-reports-grid></app-critical-reports-grid>
            
                </div>
              </mat-tab>
            

    5. Verify that the "Critical Reports" grid looks good
       a. Activate the debugger on "Full WebApp"
       b. Click on "Critical Reports" on the left-side navbar
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson30c_image2.png)
```
The server-side grid now appears in the "Critical Reports" tab

```
