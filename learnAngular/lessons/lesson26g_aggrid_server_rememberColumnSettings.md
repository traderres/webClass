Lesson 26g:  AG Grid / Server Side / Remember Column Settings
-------------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1bBemm9yttZ0ucQ_o1T-u_kn_L4hM8I8vACjDZys1iOw/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson26g/server-side-grid/remember-settings
<br>
<br>
<br>
<b>Warning: This code works best on ag-grid 25.3.0 or later</b>
<br>
<br>

<h3> Problem Set </h3>
1. User adjusts the grid column widths, grid column order in the server-side grid <br>
2. User leaves the page<br>
3. User returns to the server-side grid<br>
4. The grid column widths are what they were before (which sucks!!)<br>
<br>
Solution:  Have the grid remember column widths and visible columns in the database (so the grid remembers this).  The grid will not remember filtering or sorting.<br>



<br>
<br>

```
Assumptions
-----------
   You have completed lesson 22i in which we had REST point and db tables for preferences
   https://docs.google.com/document/d/1qwfz-sfCxjvK0uvMiOX1RDcQ9X4q6sHHELM5pPKwERc/edit?usp=sharing



Procedure
---------
    1. Change the front-end grid page to remember column state
       a. Edit server-side-grid.component.ts


       b. Add private variables to the top of the class:
            
              private readonly PAGE_NAME: string = "server-side-grid-view";
              private userHasPastColumnState: boolean = false;
              private listenForGridChanges: boolean = false;
              private saveGridColumnStateEventsSubject: Subject<any> = new Subject();
              private saveGridEventsSubscription: Subscription;


       c. Change the gridOptions variable so it saves when a user adjusts column widths
            
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



       d. Add these methods to your grid page:
            
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
            


       e. Inject the preference service into the constructor
        
          constructor(private gridService: GridService,
                    private preferenceService: PreferenceService,
                    private matDialog: MatDialog) {}
        



       f. Change the ngOnInit() so it saves grid events (but only after 250 milliseconds)
            
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
            
              }



       g. Add an ngOnDestroy method to stop listening on these subscriptions:
            
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



       h. Verify that these 2 methods exists:  
          If this does not exist, then add it:
            
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
            
            
              private clearGridCache(): void {
            
                if (this.totalMatches > 0) {
                  // The last search had matches and we are clearing the grid cache.
            
                  // So, move the scrollbar to the top
                  this.gridApi.ensureIndexVisible(0, 'top');
                }
            
                // Clear the cache
                this.gridApi?.setServerSideDatasource(this.serverSideDataSource);
              }
            
            


       i. Change onGridReady() to get the preference values and then setup the server side data source
            
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
            



    2. Change grid to call a method when the grid is rendered (by modifying report-grid-view.component.html)
       a. Edit server-side-grid.component.html

       b. Add this to <ag-grid-angular>
            (firstDataRendered)="this.firstDataRendered()"
          
  
          When completed, the grid tag should look like this:
            
                        <!-- AG-Grid -->
                        <ag-grid-angular
                        style="width: 100%; height: 100%"
                        [ngClass]="{   'ag-theme-alpine':    	this.currentTheme.isLightMode == true,
                                       'ag-theme-alpine-dark':  this.currentTheme.isLightMode == false
                                }"
                        [rowData]="this.rowData"
                        [defaultColDef]="this.defaultColDefs"
                        [columnDefs]="this.columnDefs"
                        [gridOptions]="this.gridOptions"
                        [frameworkComponents]="this.frameworkComponents"
                        (firstDataRendered)="this.firstDataRendered()"
                        (gridReady)="this.onGridReady($event)">
                        </ag-grid-angular>


    3. Try it out
       a. Activate your debugger on "Full WebApp"
       b. Click on "Server Side Grid Page"
       c. Change the width of a column
       d. Leave the page
       e. Return to the "Server Side Grid Page"
          -- The grid should remember the column width
          -- The grid should remember which columns are visible

```
