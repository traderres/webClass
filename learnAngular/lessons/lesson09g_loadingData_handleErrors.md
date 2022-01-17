Lesson 9g:  Loading Data / Async Pipe / Handle Errors
-----------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1GBNOm6AzTkU7ZQIBESVwdnMxBAZhBg-9HJaMyFunE7Y/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson9g/async-pipe-handle-errors1
<br>
<br>


Problem:  How do I handle loading errors when  using the Async Pipe?<br>
Solution:<br>
1. Add a subscription variable called LoadingPrioritiesErrorObs that holds true when an error occurs
1. Have the html template check if the priorities is loading *OR* an error occurred

<br>
<br>
<h5>References</h5>

- https://sebastian-holstein.de/post/error-handling-angular-async-pipe/
<br>
<br>


<br>
<br>
<h5>Explanation</h5>
Consider this block of code:

```
        <ng-container *ngIf="(prioritiesObs | async) as priorities; else loadingPriorities">
              <!-- Priorities are fully loaded -->
              <mat-form-field style="margin-top: 20px">
                  <mat-label>Choose Priority</mat-label>
  
                  <!-- Priorities Drop Down -->
                  <mat-select formControlName="priority">
                      <mat-option [value]=null>-Select Priority-</mat-option>
                      <mat-option *ngFor="let priority of priorities"  value="{{priority.id}}">{{priority.name}}</mat-option>
                  </mat-select>
  
              </mat-form-field>
        </ng-container>
  
        <ng-template #loadingPriorities>
              <!-- Priorities are loading message -->
              <p style="margin-top: 20px"><i class="fa fa-spin fa-spinner"></i> Loading Priorities...</p>
        </ng-template>

```




<br>
<br>
<h5>Order of Operations</h5>

1. The async pipe subscribes to the prioritiesObs

2. The first state is the "loading" state because the Observable hasn't emitted a value yet  
   -- So, the else case in our \*ngIf is active.  
   -- loadingPriorities is set
   
3. The REST call returns a response  
   If the HTTP request responds with an 2xx status code, the user will see the list of priorities  
   If the HTTP request responds with an error, the user sees no error message.  
   If an error occurs, the user still sees loading  (<b>which is NOT the correct behavior</b>)  
   <b>We need to catch the error</b>

<br>
<br>

```
Procedure
---------
    1. Add a catchError() to the subscribe call
        a. Edit add-report2.component.ts

        b. Change the prioritiesObs so it can be an observable or null
            public prioritiesObs: Observable<LookupDTO[] | null>;        // Yes, it can be null

        c. Add a new subject  loadingPriorityErrorObs
            public loadingPriorityErrorObs = new Subject<boolean>();

        d. Change the ngOnInit() to call code if an error occurs
            
            From this:
                this.prioritiesObs = this.lookupService.getLookupWithTypeAndOrder("priority", "display_order");
            
            To this:
                this.prioritiesObs = this.lookupService.getLookupWithTypeAndOrder("priority", "display_order").pipe(
                 catchError((error) => {
                // Log an error in the console here  (otherwise you will NOT see an error in the console)
                console.error('error loading the list of priorities: ', error);
            
                // Send a message to the html that there was an error loading priorities
                this.loadingPriorityErrorObs.next(true);
            
                // Recover the observable and give it a "falsy" value of null
                return of(null);
                })
            );
                


    2. Display the error in HTML   
       -- The else flag handles either loading *or* errors
       -- There is another async pipe that listens for errors
       
        a. Edit the add-report2.component.html priorities section
                  
            Change this:
                  <ng-container *ngIf="(prioritiesObs | async) as priorities; else loadingPriorities">
                        <!-- Priorities are fully loaded -->
                        <mat-form-field style="margin-top: 20px">
                            <mat-label>Choose Priority</mat-label>
        
                            <!-- Priorities Drop Down -->
                            <mat-select formControlName="priority">
                                <mat-option [value]=null>-Select Priority-</mat-option>
                                <mat-option *ngFor="let priority of priorities"  value="{{priority.id}}">{{priority.name}}</mat-option>
                            </mat-select>
        
                        </mat-form-field>
                  </ng-container>
        
                  <ng-template #loadingPriorities>
                        <!-- Priorities are loading message -->
                        <p style="margin-top: 20px"><i class="fa fa-spin fa-spinner"></i> 
                            Loading Priorities...
                        </p>
                  </ng-template>
            
            
            To this:
                 <ng-container *ngIf="(prioritiesObs | async) as priorities; else loadingPrioritiesOrError">
                    <!-- Priorities are fully loaded -->
                    <mat-form-field style="margin-top: 20px">
                        <mat-label>Choose Priority</mat-label>
        
                        <!-- Priorities Drop Down -->
                        <mat-select formControlName="priority">
                            <mat-option [value]=null>-Select Priority-</mat-option>
                            <mat-option *ngFor="let priority of priorities"  value="{{priority.id}}">{{priority.name}}</mat-option>
                        </mat-select>
        
                    </mat-form-field>
                 </ng-container>
        
                <ng-template #loadingPrioritiesOrError>
                <!-- Either the priorities are loading *OR* there is an error -->
        
                    <div *ngIf="this.loadingPriorityErrorObs | async; else loadingPriorities">
                        <!-- Priorities Failed to load message -->
                        Error loading the list of priorities.  Please try again later.
                    </div>
        
                    <ng-template #loadingPriorities>
                            <!-- Priorities are loading -->
                            <p style="margin-top: 20px"><i class="fa fa-spin fa-spinner"></i> 
                                Loading Priorities...
                            </p>
                    </ng-template>
                </ng-template>  

    3. Simulate an error
        a. Edit add-report2.component.ts

        b. Change  this line:
                this.prioritiesObs = this.lookupService.getLookupWithTypeAndOrder(
							"priority", "display_order").pipe(
        
           To this:
                this.prioritiesObs = this.lookupService.getLookupWithTypeAndOrder(
							"INVALID", "display_order").pipe(


    4.  Verify that the error message appears
        a. Run -> Debug 'Full WebApp'

        b. Click on "Add Report 2"

        c. Look at the priorities dropdown
            -- You should see an error message that the priorities failed to load
```
![](https://lh5.googleusercontent.com/9-4BCVl_C2iaAnQMzd5w146HgXNys4UV4wSridjNEqZliK-hX7oFJTaNwRPbBM45DvaPe0cQb1sacEdE9tErUkdi4mgfm8myHxAaJPwKh7-Cv3mCdy90eE3iP2qazslLkGmKlH7w)
```





        d. Edit the ngOnInit(), change the "INVALID_LOOKUP_TYPE" to "priority"
           -- Look at the priorities dropdown
           -- You should see the loading message (for 5 seconds)
           -- Then, you should see the dropdown values       


```
