Lesson 9d:  Loading Data / Async Pipe
-------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1PeFsESp1VlD0utY9GxcBjqTVcYbJPDoEEK2dLm9g-OA/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson9d/async-pipe
<br>
<br>

Problem: I have a dropdown that I want to load from a REST call or some service.<br>
Solution: Use an Async Pipe

<br>
When using the Async Pipe, the HTML only needs the observable.<br>
Big advantage of Async Pipes: There is a lot less code.

  
  

<br>
<br>
<br>
<h5>Order of Operations with Async Pipe</h5>
1. User clicks the "Add Report 2" page link (in the navbar)  
 
1. Constructor is called  
    -- The add-report2.component.ts constructor is called (services are injected)  

1. ngOnInit is called  
   -- The add-report2.component.ts ngOnInit() is called  
   -- We initialize an observable&lt;LookupDTO\[]> with this line:
   ```
   this.prioritiesObs = this.lookupService.getLookupWithTypeAndOrder("priority", "display_order");
   ```

1. HTML is rendered: The add-report2.component.html is rendered

1. The async pipe is invoked by this line:
   ```
    <ng-container *ngIf="(this.prioritiesObs | async) as priorities; else loadingPriorities">
        <!-- This section renders when the REST call comes back -->

    </ng-container>
    ```

1. The async pipe subscribes to the observable  
   -- So, the REST call is invoked (we start waiting 5 seconds)  

1. The HTML page invokes the "loadingPriorities" section  

1. The REST call comes back (after 5 seconds)  
   -- The block of the &lt;ng-container> is now invoked and priorities holds an array of LookupDTO objects  
   -- The user now sees the priorities (returned from the REST call)  

1. The user leaves the page  
   -- The Async pipe automatically unsubscribes from the observable (so there is no memory leak

<br>
<br>
<br>

```
Procedure
    1. Adjust add-report2.component.ts so it gets the observable only
        a. Edit the add-report2.component.ts


        b. Change the public priorities instance variable to be an observable
           NOTE:  I rename it to prioritiesObs (because it's an observable)
	            public prioritiesObs: Observable<LookupDTO[]>;
	

        c.  Remove these objects from the top of the file
                public priorities: LookupDTO[];
                public prioritiesAreLoading: boolean;
                private lookupSubscription: Subscription;
	

        d. Remove the ngOnDestroy() method
                Change the class so that it does *NOT* implement OnDestroy interface


        e. Change ngOnInit() so that it gets the observable
           NOTE:  We do not call subscribe()

                // Get the observable to the List of LookupDTO objects
                // NOTE:  The AsyncPipe will subscribe and unsubscribe automatically
                this.prioritiesObs = this.lookupService.getLookupWithTypeAndOrder("priority", "display_order");



        f. When completed, the ngOnInit() method looks like this:
                
                public ngOnInit(): void {
                
                    // Get an observable for the List of LookupDTO objects
                    // NOTE:  The AsyncPipe will subscribe and unsubscribe automatically
                    this.prioritiesObs = this.lookupService.getLookupWithTypeAndOrder("priority",
                "display_order");
                
                
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



    2. Setup the Async Pipe in the HTML template (so it uses the priorities observable object)
        a. Edit add-report2.component.html

        b. Change the priorities <mat-form-field>...</mat-form-field> to this:
	
              <ng-container *ngIf="(this.prioritiesObs | async) as priorities; else loadingPriorities">
                  <!-- Priorities are fully loaded -->
                 <mat-form-field style="margin-top: 20px">
                    <mat-label>Choose Priority</mat-label>
            
                     <!-- Priorities Drop Down -->
                     <mat-select formControlName="priority">
                        <mat-option [value]=null>-Select Priority-</mat-option>
                        <mat-option *ngFor="let priority of priorities"
                             value="{{priority.id}}">
                                {{priority.name}}
                        </mat-option>
                     </mat-select>
            
                 </mat-form-field>
            </ng-container>


            <ng-template #loadingPriorities>
                <!-- Priorities are loading message -->
                <p style="margin-top: 20px"><i class="fa fa-spin fa-spinner"></i>
                     Loading Priorities...
                </p>
            </ng-template>





    3.  Verify that the priorities loading message appears
        a. Pull Run -> Debug 'Full WebApp'
        b. Click on "Add Report 2"
        c. Look at the priorities dropdown
           -- You should see a spinner and a message for 5 seconds
           -- When the 5 seconds are up, you should see your dropdown
  

```
