Lesson 9e:  Loading Data / Multiple Async Pipes / Part 1
--------------------------------------------------------
The Google Drive link is here:<br>
https://docs.google.com/document/d/1pmSSHyzLLsl0gukq6aA0maEeAsk3D2YVso0lIrwcAK4/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson9e/multiple-async-pipes-simple
<br>
<br>
<br>

<h3> Problem Set </h3>

Problem:  I have multiple form controls that I want to load from multiple REST calls.<br>
Solution: Use a multiple Async Pipe calls
<br>
<br>



```
Procedure
    1. Add additional observables to add-report2.component.ts
        a. Edit add-report2.component.ts

        b. Define additional instance variables:
            public prioritiesObs: Observable<LookupDTO[]>;
            public authorsObs: Observable<LookupDTO[]>;
            public reportSourceObs: Observable<LookupDTO[]>;


        c. Initialize the variables in ngOnInit() by adding these lines to your ngOnInit()
            ngOnInit(): void {
               . . .


                this.prioritiesObs = this.lookupService.getLookupWithTypeAndOrder(
									"priority", "display_order");

                this.authorsObs = this.lookupService.getLookupWithTypeAndOrder("author", "name");

                this.reportSourceObs = this.lookupService.getLookupWithTypeAndOrder(
									"report_source", "name");

		. . .
            }


    2. Use the authorsObs in add-report2.component.html
        a. Edit add-report2.component.html

        b. Change the authors section to this:
            
            <ng-container *ngIf="(this.authorsObs | async) as authors; else loadingAuthors">
                <!-- Authors are loaded -->
                        <mat-form-field style="margin-top: 20px">
                            <mat-label>Choose Authors</mat-label>
            
                                <mat-select multiple formControlName="authors">
                                        <mat-option *ngFor="let author of authors" 
                             value="{{author.id}}">{{author.name}}
                        </mat-option>
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


        c. Verify it works by activating the debugger
           -- You should see your Authors loaded (after 5 long seconds of waiting)


    3. Use the reportSourceObs in add-report2.component.html
        a. Edit add-report2.component.html

        b. Change the report source dropdown to this
                
                <ng-container *ngIf="(this.reportSourceObs | async) as report_sources; else loadingReportSources">
                            <!-- Report Sources are loaded -->
                            <mat-form-field style="margin-top: 20px">
                                <mat-label>Choose Source</mat-label>
                
                                <!-- Report Sources Drop Down -->
                                    <mat-select formControlName="source">
                                            <mat-option [value]=null>-Select Source-</mat-option>
                                            <mat-option *ngFor="let source of report_sources"  value="{{source.id}}">{{source.name}}</mat-option>
                                    </mat-select>
                
                        <mat-error>
                                Source is required
                            </mat-error>
                
                            </mat-form-field>
                </ng-container>
                        
                <ng-template #loadingReportSources>
                          <!-- Report Sources are loading message -->
                          <p style="margin-top: 20px"><i class="fa fa-spin fa-spinner">
                        </i> Loading Report Sources...
                    </p>
                </ng-template>


    4. Verify it works by activating the debugger
       -- You should see your Report Sources loaded (after 5 long seconds of waiting)

```
