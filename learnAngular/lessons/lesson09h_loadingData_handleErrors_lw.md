Lesson 9h:  Loading Data / Async Pipe / Handle Errors w/Loading Wrapper
-----------------------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1ek83iA_5DmMFEIL47TcisnGRF2wFu1PA9a9VNk2208M/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson9h/async-pipe-handle-errors2
<br>
<br>


Problem: We don't want to have a catchError() on every subscriber call<br>
Solution: Setup a LoadingWrapper class that will handle the catchError() for us

<br>
<br>
The prioritiesObs object has 2 properties:

1. prioritiesObs.dataObs holds the observable to the data
1. prioritiesObs.errorLoadingObs holds TRUE when an error occurs

  
  
<br>
<br>
<h5>Advantages to this Approach</h5>

- We still get to use Async Pipes
- We don't have to have 2 variables for each REST call -- just one
- If an error occurs, the Async Pipe can show a custom error

  

<br>
<br>
<h5>Disadvantages to this Approach</h5>

- Every Async Pipe now has a section to show an error if the dropdown did not load
- If one dropdown (on a page) does not load, then the entire page is messed-up  
  - So, it's not really recoverable  
  - The user will probably restart the browser or reload the page  

- Is it really valuable to show a message, "Loading priorities did not work"....?

<br>
<br>

```
Procedure
---------
    1. Create the loadingWrapper class
        a. Create the loading wrapper class
           unix> cd ~/intellijProjects/angularApp1/frontend
           unix> ng generate class utilities/loadingWrapper --skipTests 

        b. Replace loading-wrapper.ts with this:
            
                import {Observable, of, Subject} from "rxjs";
                import {catchError, shareReplay} from "rxjs/operators";
            
                export class LoadingWrapper<T> {
                  private readonly _errorLoadingObs = new Subject<boolean>();
            
                  public readonly errorLoadingObs: Observable<boolean> = this._errorLoadingObs.pipe(
                        shareReplay(1)
                  );
            
                  public readonly dataObs: Observable<T | null>;
            
                  public constructor(aData: Observable<T>) {
                    this.dataObs = aData.pipe(
                          shareReplay(1),
                          catchError(error => {
                            // Log an error in the console here
                            console.log(error);
            
                            // Emit a "truthy" value for errorLoadingObs
                            this._errorLoadingObs.next(true);
            
                            // Recover the observable and give it a "falsy" value of null
                            return of(null);
                          })
                        );
            
                    }  // end of constructor
            
                }


    2. Use  the LoadingWrapper in add-report2.component.ts
        a. Edit add-report2.component.ts

        b. Remove loadingPriorityErrorObs 

        c. Change prioritiesObs type to be of LoadingWrapper<LookupDTO[]>
            Change this:
                public prioritiesObs: Observable<LookupDTO[] | null>;
            To this:
                public prioritiesObs: LoadingWrapper<LookupDTO[]>;


        d. Change the code in ngOnInit() to use the LoadingWrapper
            
            From this:
                  this.prioritiesObs = this.lookupService.getLookupWithTypeAndOrder(
                                        "priority", "display_order").pipe(
                  catchError((error) => {
                        // Log an error in the console here  (otherwise you will NOT see an error in the console)
                        console.error('error loading the list of priorities: ', error);
            
                // send a message to the HTML indicating an error occurred
                        this.loadingErrorObs.next(true);
            
                        // Recover the observable and give it a "falsy" value of null
                        return of(null);
                     })
            );
            
            
            To this:
                this.prioritiesObs = new LoadingWrapper(
                     this.lookupService.getLookupWithTypeAndOrder("priority", "display_order")
                );


    3. Change the html template to show the error
        a. Edit add-report2.component.html

        b. Remove priorities from the <ng-container> at the top of the HTML

        c. Change this line
            From this
                    <ng-container *ngIf="(prioritiesObs | async) as priorities; else 
                                            loadingPrioritiesOrError">
                
            To this:
                    <ng-container *ngIf="(this.prioritiesObs.dataObs | async) as priorities; else
                                             loadingPrioritiesOrError">

        d. Change this line
            From this:
                <div *ngIf="loadingPriorityErrorObs | async; else loadingPriorities">
            
            To this:
                <div *ngIf="this.prioritiesObs.errorLoadingObs | async; else loadingPriorities">
            

        e. When completed, the priorities dropdown section looks like this:
            
            <ng-container *ngIf="(this.prioritiesObs.dataObs | async) as priorities; 
                                        else loadingPrioritiesOrError">
               <!-- Priorities are fully loaded -->
               <mat-form-field style="margin-top: 20px">
                <mat-label>Choose Priority</mat-label>
            
                <!-- Priorities Drop Down -->
                <mat-select formControlName="priority">
                    <mat-option [value]=null>-Select Priority-</mat-option>
                    <mat-option *ngFor="let priority of priorities"  
                            value="{{priority.id}}">{{priority.name}}</mat-option>
                </mat-select>
            
               </mat-form-field>
            </ng-container>

            
            <ng-template #loadingPrioritiesOrError>
                 <!-- Either priorities are loading OR there was an error -->
            
                <div *ngIf="this.prioritiesObs.errorLoadingObs | async; else loadingPriorities">
                    <!-- Priorities Failed to load message -->
                    Error loading the list of priorities.  Please try again later.
                 </div>
            
                <ng-template #loadingPriorities>
                    <!-- Priorities are loading message -->
                    <p style="margin-top: 20px"><i class="fa fa-spin fa-spinner"></i>
                         Loading Priorities...
                    </p>
                 </ng-template>
            
            </ng-template>
            
             


    4. Simulate an error
        a. Edit add-report2.component.ts
        b. Change this line within the ngOnInit()

            From this:
           	    this.lookupService.getLookupWithTypeAndOrder("priority", "display_order")
        
            To this:
                this.lookupService.getLookupWithTypeAndOrder("INVALID_LOOKUP_TYPE", "display_order")



    5. Verify that the error message appears
        a. Pull Run -> Debug 'Full WebApp'
        b. Click on "Add Report 2"
        c. Look at the priorities dropdown
           -- You should see an error message that the priorities failed to load
```
![](https://lh4.googleusercontent.com/JeO6E2JheiZ5ufHJmBTQ72hfceJrzcTb4Xf9UobKehrn61nfGl5a72kRiRnOxU-PIFmoEDRnQwnJ_m4Z_LA867K6rCu43o6JWO4BqlIk5fetWzc0cskX-AoI1c63yM6jEqqN0wp9)
```




        d. In ngOnInit(), change the "INVALID_LOOKUP_TYPE" to "priority"

        e. Look at the priorities dropdown
           -- You should see the loading message (for 5 seconds)
           -- Then, you should see the dropdown values





When finished, add-report2-component.ts looks like this:
     
    import {Component, OnInit} from '@angular/core';
    import {FormBuilder, FormGroup, Validators} from "@angular/forms";
    import {ValidatorUtils} from "../../validators/validator-utils";
    import {MessageService} from "../../services/message.service";
    import {LookupService} from "../../services/lookup.service";
    import {LookupDTO} from "../../models/lookup-dto";
    import {Observable} from "rxjs";
    import {LoadingWrapper} from "../../utilities/loading-wrapper";
    
    
    @Component({
      selector: 'app-add-report2',
      templateUrl: './add-report2.component.html',
      styleUrls: ['./add-report2.component.css']
    })
    export class AddReport2Component implements OnInit {
      public myForm: FormGroup;
    
      public prioritiesObs: LoadingWrapper<LookupDTO[]>;
    
      public authorsObs: Observable<LookupDTO[]>;
      public reportSourceObs: Observable<LookupDTO[]>;
    
    
      constructor(private lookupService: LookupService,
                private formBuilder: FormBuilder,
                private messageService: MessageService)
                { }
    
      public ngOnInit(): void {
    
        // Get the observable a list of LookupDTO objects for priorities
        // NOTE:  The AsyncPipe will subscribe and unsubscribe automatically
        this.authorsObs = this.lookupService.getLookupWithTypeAndOrder("author", "name")
        this.reportSourceObs = this.lookupService.getLookupWithTypeAndOrder("report_source", "name")
    
        this.prioritiesObs = new LoadingWrapper(
            this.lookupService.getLookupWithTypeAndOrder("priority", "display_order")
        );
    
    
        // Initialize the form object with the proper validators
        this.myForm = this.formBuilder.group({
        report_name: ['initial name',
            [
            Validators.required,
            Validators.minLength(2),
            Validators.maxLength(100)
            ]],
    
        source: ['', Validators.required],
        priority:  ['', Validators.required],
    
        authors:  ['',
            [
                Validators.required,
                ValidatorUtils.validateMultipleSelect(1,2)
            ]]
        });
    
      } // end of ngOnInit()
    
    
    public reset() {
        console.log('user pressed reset');
        this.myForm.reset();
      }
    
      public save() {
        console.log('User pressed save.');
    
        // Mark all fields as touched so the user can see any errors
        this.myForm.markAllAsTouched();
    
        if (this.myForm.invalid) {
        // User did not pass validation so stop here
        return;
        }
    
        this.messageService.showSuccessMessage("Failed to save your record.  An error occurred.")
    
        // User enter valid data
        console.log('Valid data:  report_name=' + this.myForm.controls.report_name.value);
      }
    
    }


When finished add-report2.component.html looks like this:
    
    <!-- Subscribe to Multiple Observables -->
    <ng-container *ngIf="
        {
            report_sources: reportSourceObs | async,
            authors: authorsObs | async
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
                            <mat-option *ngFor="let source of data.report_sources"  
                        value="{{source.id}}">{{source.name}}</mat-option>
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
    
    
    <ng-container *ngIf="(prioritiesObs.dataObs | async) as priorities; else loadingPrioritiesOrError">
     <!-- Priorities are fully loaded -->
     <mat-form-field style="margin-top: 20px">
                <mat-label>Choose Priority</mat-label>
    
                <!-- Priorities Drop Down -->
                <mat-select formControlName="priority">
                    <mat-option [value]=null>-Select Priority-</mat-option>
                    <mat-option *ngFor="let priority of priorities"
                          value="{{priority.id}}">{{priority.name}}</mat-option>
                </mat-select>
    
            </mat-form-field>
    </ng-container>
    
    <ng-template #loadingPrioritiesOrError>
        <!-- Either priorities are still loading OR there was an error -->
    
     <div *ngIf="prioritiesObs.errorLoadingObs | async; else loadingPriorities">
            <!-- Priorities Failed to load message -->
            Error loading the list of priorities.  Please try again later.
        </div>
    
        <ng-template #loadingPriorities>
              <!-- Priorities are loading message -->
              <p style="margin-top: 20px"><i class="fa fa-spin fa-spinner"></i> Loading Priorities...</p>
     </ng-template>
    
    </ng-template>
            <br/>
    
    
     <ng-container *ngIf="data.authors; else loadingAuthors">
                <!-- Authors are loaded -->
                <mat-form-field style="margin-top: 20px">
                    <mat-label>Choose Authors</mat-label>
    
                    <mat-select multiple formControlName="authors">
                        <mat-option *ngFor="let author of data.authors"  
                    value="{{author.id}}">{{author.name}}</mat-option>
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
