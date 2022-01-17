Lesson 9c:  Loading Data / Manual Subscribe
-------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1V-A-rfsVA5KWvs-toHbRRQE_DGafmloff7A33U7lyVU/edit?usp=sharing


The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson9c/manual-subscribe
<br>
<br>
<br>
Problem:  I have a dropdown that I want to load from a REST call or some service.<br>
Solution: Manually subscribe to the data and show a loading flag
<br>

<u>General Approach</u>

1. In ngOnInit, Set the loadingData flag = true (to show a spinner)

2. Subscribe to the Observable (to invoke the REST call)

3. Upon getting the data
   - Store the data in a component instance variable
   - Set the loadingData flag false (to hide a spinner)

4. in NgOnDestroy, Unsubscribe from the subscription (to prevent memory leaks)
<br>
<br>
<br>
```
Procedure
    1. Edit add-report2.component.ts
        a. Inject the LookupService 
              constructor(private lookupService: LookupService)
              { } 

        b. Make sure the AddReportComponent2 implements OnInit and OnDestroy
              class AddReportComponent implements OnInit, OnDestroy {

        c. Make sure you have a private Subscription variable:
        	  private lookupSubscription: Subscription;

        d. Add a public prioritiesAreLoading flag
        	  public prioritiesAreLoading: boolean;

        e. Make sure your ngOnDestroy() unsubscribes from subscriptions
              public ngOnDestroy(): void {
            
                if (this.lookupSubscription) {
                    // Unsubscribe from this subscription so we don't have a memory leak
                    this.lookupSubscription.unsubscribe();
                }

        f. Make sure your ngOnInit() subscribes to the lookupService.getLookupWithType()
            
            public ngOnInit(): void {
            
              this.prioritiesAreLoading = true;
                
              // Invoke the REST end point
              this.lookupSubscription =  this.lookupService.getLookupWithType("priority").subscribe(data =>{
                        // The REST call finished successfully
            
                        // Get the data from the REST call
                        this.priorities = data;
                    },
            
                    (err) => {
                        // REST Call call finished with an error
                        console.error(err);
            
                    }).add( () => {
                        // Code to run after the REST call finished
                 
                        // Unset the flag (so that the priorities-are-loading spinner disappears)
                        this.prioritiesAreLoading = false;
                })
            
            
                // Initialize the form object with the proper validators
                this.myForm = this.formBuilder.group({
                    report_name: ['',  [
                                    Validators.required,
                                    Validators.minLength(2),
                                    Validators.maxLength(100)
                                ]],
            
                    source: ['', Validators.required],
                    priority:  ['', Validators.required],
                    authors:  ['',    [
                                        Validators.required,
                                        ValidatorUtils.validateMultipleSelect(1,2)
                                ]]
                });
            
              } // end of ngOnInit()

    2. Change the template so that it uses the prioritiesAreLoading flag (to show a spinner)
        a. Edit add-report2.component.html
        b. Change the priorities dropdown section from this
            
            <mat-form-field>
                <mat-label>Choose Priority</mat-label>
                <mat-select formControlName="priority">
                    <mat-option [value]=null>-Select Priority-</mat-option>
                    <mat-option *ngFor="let priority of priorities"  value="{{priority.id}}">{{priority.name}}</mat-option>
                </mat-select>
            
                <mat-error>
                    Priority is required
                </mat-error>
            </mat-form-field>
            
            To this:
            
            <ng-container *ngIf="!prioritiesAreLoading">
                <!-- Priorities are fully loaded -->
                <mat-form-field style="margin-top: 20px">
                        <mat-label>Choose Priority</mat-label>
            
                        <!-- Priorities Drop Down -->
                        <mat-select formControlName="priority">
                                <mat-option [value]=null>-Select Priority-</mat-option>
                                <mat-option *ngFor="let priority of priorities" value="{{priority.id}}">{{priority.name}}</mat-option>
                        </mat-select>
            
                        <mat-error>
                           Priority is required
                        </mat-error>
                </mat-form-field>
            </ng-container>
            
            <ng-container *ngIf="prioritiesAreLoading">
                <!-- Priorities are loading, so show the loading message -->
                <div style="margin-top: 20px"><i class="fa fa-spin fa-spinner"></i>
                     Loading Priorities...
                </div>
            </ng-container>

    3. Add a 5-second delay to the lookup REST call
        a. Edit the backend/src/main/java/com/lessons/controllers/LookupController.java

        b. Add this java code before the list is returned in LookupController.getLookupsWithType()
                try {
                    // Sleep for 5 seconds
                    Thread.sleep(5000);
                }
                catch(Exception e) {
                    // Do nothing
                }


        c. When finished, the LookupController.getLookupsWithType() looks like this:
                
                @RequestMapping(value = {"/api/lookups/{lookupType}/{orderBy}",
                                                       "/api/lookups/{lookupType}"}, 
                                                      method = RequestMethod.GET, produces = "application/json")
                public ResponseEntity<?> getLookupswithType(
                                @PathVariable(name="lookupType") String aLookupType,
                                                        @PathVariable(name="orderBy", required=false) String aOrderBy)
                {
                        logger.debug("getLookupsWithType() started.  aLookupType={}", aLookupType);
                
                        if (! lookupService.doesLookupTypeExist(aLookupType)) {
                                return ResponseEntity
                                            .status(HttpStatus.BAD_REQUEST)
                                            .contentType(MediaType.TEXT_PLAIN)
                                            .body("The passed-in lookup type does not exist: " + aLookupType);
                        }
                
                        List<LookupDTO> lookupDTOs = lookupService.getLookupsWithType(aLookupType, aOrderBy);
                
                        try {
                                // Sleep for 5 seconds
                                Thread.sleep(5000);
                        }
                        catch(Exception e) {
                                // Do nothing    
                        }
                
                        // Return the list of lookupDTO objects
                        return ResponseEntity.status(HttpStatus.OK)
                                            .body(lookupDTOs);
                }
                

    4. Verify that the loading message shows for 5 seconds when you visit the page call works when using the debugger
        a. Activate the debugger
        b. Go to "Add Report 2"
           -- You should see "Loading Priorities" for 5 seconds
           -- Then, the priorities dropdown appears

        c. Go to a different page
        d. Return to "Add Report 2"
-- You should see "Loading Priorities" for 5 seconds
-- Then, the priorities dropdown appears

NOTE:  There is no caching so every time you hit the page, it calls the REST endpoint
```
![](https://lh5.googleusercontent.com/21W4uEq00jlDAlMCLHt6klpaD5L1H9uuQs2ATy-MygGelLl_czCRkf6AZyvRF5iUpS8DW5astbeP7CGMDMXM_ooqQYHjNlmFqJjLqd8U4T2ITNoLoyJVBL3mMQAkw74IvTr9b554)
```
Notice the "Loading Priorities" message appears for 5 seconds






    5. Add another method to the Angular lookup.service.ts to get the lookups by type *and* sort
        a. Edit lookup.service.ts

        b. Add  this method:  getLookupWithTypeAndOrder()

              /*
               * Return a sorted list of LookupDTO objects that correspond to the passed-in type name -- e.g, 'priority'
               */
              public getLookupWithTypeAndOrder(aType: string, aOrderBy: string): Observable<LookupDTO[]>  {
    
                const restUrl = environment.baseUrl + '/api/lookups/' + aType + '/' + aOrderBy;
    
                return this.httpClient.get <LookupDTO[]>(restUrl);
              }


    6. Change add-report2.component.ts to call this new method:
        a. Edit add-report2.component.ts

        b. Change the ngOnInit() so it calls lookupService.getLookupWithTypeAndOrder() instead of calling lookupService.getLookupWithType()


        c. When done, the ngOnInit() method looks something like this:
                
                public ngOnInit(): void {
                
                  this.prioritiesAreLoading = true;
                    
                  // Invoke the REST end point
                  this.lookupSubscription =  this.lookupService.getLookupWithTypeAndOrder("priority",
                                                                                                                                           "display_order")
                    .subscribe(data =>{
                            // The REST call finished successfully
                
                            // Get the data from the REST call
                            this.priorities = data;
                        },
                
                        (err) => {
                            // REST Call call finished with an error
                            console.error(err);
                
                        }).add( () => {
                            // Code to run after the REST call finished
                     
                            // Unset the flag (so that the priorities-are-loading spinner disappears)
                            this.prioritiesAreLoading = false;
                    })
                
                    // Initialize the form object with the proper validators
                    this.myForm = this.formBuilder.group({
                        report_name: ['',  [
                                        Validators.required,
                                        Validators.minLength(2),
                                        Validators.maxLength(100)
                                    ]],
                
                        source: ['', Validators.required],
                        priority:  ['', Validators.required],
                        authors:  ['',    [
                                            Validators.required,
                                            ValidatorUtils.validateMultipleSelect(1,2)
                                    ]]
                    });
                
                  }    // end of ngOnInit()


    7. Verify that the priorities are sorted by display order -- e.g., "low", "medium", "high", "critical"
       NOTE:  This is not the same as alphabetical order
        a. Pull Run -> Debug 'Full WebApp'
        b. Click on "Add Report 2"
        c. Look at the priorities dropdown
           -- You should see a spinner for 5 seconds
           -- Then, you should see the dropdown entries listed by their display_order column
            


```
  
  
