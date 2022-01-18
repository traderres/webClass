Lesson 9i:  Loading Data / Async Pipe / Handle Errors w/Interceptor
-------------------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/10ZIBw7GdoGPYuQ-rkw2uire3MpzIbH9enUzmAOclc3I/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson9i/async-pipe-handle-errors3
<br>
<br>
Problem: We want to show a dialog box if any REST call fails  
+ User does not leave the page  
+ User can see the error message in a dialog box  
+ It handles \*ALL\* rest calls so we don't need to add catchError() calls everywhere  
+ We do not have to write HTML saying "Priorities would not load" \[which should be an unlikely event]  
  

<br>
<br>
<h3>Approach</h3>

1. Create the ErrorDialogBox component (to display the error)  

1. Create an ErrorService with two methods: addError() and getErrors()  
     
1. Have the main page (app.component.ts) listen for errors (using the ErrorService)

   - Main Page injects the ErrorService
   - Main Page listens for errors using errorService.getErrors()  
     -- If an error is found, then show the dialog box  

1. Create an Interceptor that adds errors (using the ErrorService)

   - Inject the ErrorService into the new Interceptor
   - If an error is found in a REST call, then call errorService.addError()  

![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson09i_image1.png)


<br>
<br>
<h5>Screen Shot</h5>

Any REST call that fails will show a popup error (without leaving the screen)

![](https://lh3.googleusercontent.com/jwyeGOcfrrHe4d_LEfFipJCdKx6ilg2zXmCMveL9esABg_3_V8cNPnlRufJNoa82MwenMS7UjT9cM0NQR_WveRE7c09f374wHP7XSdBZxxeNP0pO_nHhAWCaBMzZb8MrsknarvLr)
<br>
<br>
<br>

```
Procedure
---------
    1. Make sure that your app.module.ts has the MatDialogModule
        a. Edit app.module.ts

        b. Verify that you see this module in the imports section 
              MatDialogModule,



    2. Create the Error Dialog Box Form Data  (used to pass-in data to the Dialog Box)
        a. Create this class:  error-dialog-form-data.ts
           unix> cd ~/intellijProjects/angularApp1/frontend
           unix> ng generate class errorHandler/errorDialogFormData --skipTests

        b. Copy this to the newly-created class:
            export class ErrorDialogFormData {
                status_code: number;
                message: string;
                url: string | null;
                error_text: string;
            }


    3. Create the ErrorDialogBox component
        a. Create the error dialog box
           unix> cd ~/intellijProjects/angularApp1/frontend
           unix> ng generate component errorHandler/errorDialog --skipTests

        b. Replace error-dialog.component.ts with this:
            
            import {Component, Inject} from '@angular/core';
            import {MAT_DIALOG_DATA, MatDialogRef} from "@angular/material/dialog";
            import {ErrorDialogFormData} from "../error-dialog-form-data";
            
            @Component({
              selector: 'app-error-dialog',
              templateUrl: './error-dialog.component.html',
              styleUrls: ['./error-dialog.component.css']
            })
            export class ErrorDialogComponent  {
            
              constructor(private dialogRef: MatDialogRef<ErrorDialogComponent>,
                        @Inject(MAT_DIALOG_DATA) public data: ErrorDialogFormData) 
            {}
            
              public onCancelClick(): void {
                this.dialogRef.close();
              }
            }


        c. Replace error-dialog.component.html with this:
            
            <h2 mat-dialog-title>{{this.data.status_code}}&nbsp;{{this.data.error_text}}</h2>
            
            <div mat-dialog-content>
              This URL failed: {{this.data.url}}<br/><br/>
              {{this.data.message}}
            </div>
            
            <div mat-dialog-actions>
              <button type="button" mat-button mat-raised-button color="primary" class="button-class"
                    (click)="this.onCancelClick()">Close
              </button>
            </div>

    4. Create the ErrorService 
        a. Create the service
           unix> cd ~/intellijProjects/angularApp1/frontend
           unix> ng generate service errorHandler/error  --skipTests

        b. Replace the error.service.ts with this:
            
            import { Injectable } from '@angular/core';
            import {Observable, Subject} from "rxjs";
            import {HttpErrorResponse} from "@angular/common/http";
            
            @Injectable({
              providedIn: 'root'
            })
            export class ErrorService {
            
              private errors = new Subject<HttpErrorResponse>();
            
              constructor() { }
            
            
              public addError(aError: HttpErrorResponse): void {
                this.errors.next(aError);
              }
            
            
              public getErrors(): Observable<HttpErrorResponse> {
                return this.errors.asObservable();
              }
            
            }

    5. Tell the app.component.ts to show the Dialog Box if an error occurs
        a. Edit app.component.ts


        b. Add these 3 variables:
            private errorSubscription: Subscription;
            private errorDialogIsOpen = false;
            private errorDialogRef: MatDialogRef<ErrorDialogComponent, any>;


        c. Inject the ErrorService and MatDialog service
            constructor(
                . . .
                private errorService: ErrorService,
                        private matDialog: MatDialog
                    ) 
            {}



        d. Add this code to the ngOnDestroy() method

            if (this.errorSubscription) {
                this.errorSubscription.unsubscribe();
            }



        e. Add this to the ngOnInit() method on app.component.ts:
            
            this.errorSubscription =
                 this.errorService.getErrors().subscribe( (aError: HttpErrorResponse) => {
                        // An error came in.  So, display the error in a popup
            
                        // Create the form data object (to pass-in to the dialog box)
                        let errorFormData: ErrorDialogFormData = new ErrorDialogFormData();
                        errorFormData.error_text = aError.statusText;
                        errorFormData.status_code = aError.status
                        errorFormData.url = aError.url;
            
                        if (typeof aError.error === 'object') {
                            // The aError.error is an object.  So, pull the error from aError.error.message
                            errorFormData.message = aError.error.message;
                        } 
                        else {
                            // The aError.error is not an object.  So, pull the error from aError.error
                            errorFormData.message = aError.error;
                        }
            
                        if (this.errorDialogIsOpen) {
                            // The error dialog is already open -- so close it
                            this.errorDialogRef.close(false);
                        }
            
                        this.errorDialogIsOpen = true;
            
                        // Open the Error Dialog
                        // Do not set the height of dialog boxes.  Let them grow
                        this.errorDialogRef = this.matDialog.open(ErrorDialogComponent, {
                            minWidth: '400px',
                            maxWidth: '800px',
                            data: errorFormData
                        });
            
                        this.errorDialogRef.afterClosed().subscribe((formData: ErrorDialogFormData) => {
                            // The error dialog box has closed
                            this.errorDialogIsOpen = false;
                        });
            
                   });


    6. Create the ErrorInterceptor (that will intercept *ALL* REST calls)
        a. Create the MyInterceptor class
           unix> cd ~/intellijProjects/angularApp1/frontend
           unix> ng generate interceptor errorHandler/error  --skipTests

        b. Replace error.interceptor.ts with this::
            
            import { Injectable } from '@angular/core';
            import {
              HttpRequest, HttpHandler, HttpEvent, HttpInterceptor, HttpErrorResponse
            } from '@angular/common/http';
            import {Observable, throwError} from 'rxjs';
            import {ErrorService} from "./error.service";
            import {catchError} from "rxjs/operators";
            
            @Injectable()
            export class ErrorInterceptor implements HttpInterceptor {
            
              constructor(private errorService: ErrorService)
              {}
            
              public intercept(request: HttpRequest<unknown>, next: HttpHandler): 
                                            Observable<HttpEvent<any>>  
               {
                return next.handle(request).pipe(
                    catchError( (error: HttpErrorResponse) => this.handleErrorRestCall(error))
                );
            
              } // end of method
            
              private handleErrorRestCall(err: HttpErrorResponse): Observable<any> {
                if (err.status < 200 || err.status >= 300) {
                    // A REST call raised an error.  So, send the info to the ErrorService
                    // Send the error message to the errorService
                    this.errorService.addError(err);
                }
            
                // Throw the error
                return throwError(err);
              }
            }

        c. Register the ErrorInterceptor class
            i. Edit app.module.ts

            ii. Add this to the providers: section

                providers: [
                    { provide: HTTP_INTERCEPTORS, useClass: ErrorInterceptor, multi: true }
                  ],
                


    7. Setup the Add Report 2 Page so that it looks for a regular observable.
        a. Edit add-report2.component.ts   
        b. Adjust the ngOnInit()  

            Change this line
               this.prioritiesObs = new LoadingWrapper(
                    this.lookupService.getLookupWithTypeAndOrder("priority", "display_order")
                );
            
            To this:
               this.prioritiesObs = this.lookupService.getLookupWithTypeAndOrder(
                                            "priority555555", "display_order");


            NOTE:  We are removing the LoadingWrapper


        c. Change the prioritiesObs object to a regular Observable:
              public prioritiesObs: Observable<LookupDTO[]>;


    8. Edit add-report2.component.html
        a. Change the top so that it's using a multiple observable
                <ng-container *ngIf="
                    {
                        report_sources: this.reportSourceObs | async,
                        authors: this.authorsObs | async,
                        priorities: this.prioritiesObs | async
                    } as data;">
                
                
                        b. Change the priorities so that it looks for data.priorities
                
                  <ng-container *ngIf="data.priorities; else loadingPriorities">
                     <!-- Priorities are fully loaded -->
                     <mat-form-field style="margin-top: 20px">
                        <mat-label>Choose Priority</mat-label>
                
                        <!-- Priorities Drop Down -->
                        <mat-select formControlName="priority">
                            <mat-option [value]=null>-Select Priority-</mat-option>
                            <mat-option *ngFor="let priority of data.priorities"  value="{{priority.id}}">{{priority.name}}</mat-option>
                        </mat-select>
                
                      </mat-form-field>
                  </ng-container>

                  <ng-template #loadingPriorities>
                   <!-- Priorities are loading message -->
                    <p style="margin-top: 20px"><i class="fa fa-spin fa-spinner"></i>
                         Loading Priorities...
                    </p>
                  </ng-template>






    9. Verify it works
        a. Activate the debugger
        b. Go to the "Add Report 2" page
           -- You should see the error popup appear
```
![](https://lh3.googleusercontent.com/9JdDmRu8C2f4yr65t9mbkFxYFfa4yNyF5XCAdbqqoDmKmTpHwoxIIzJxqKO3il4yGjYY2MBqMCoavnRGYGgjlbkTIhuIdO_FIV1cKRhI3qTSaFSCvmLOvY_yi69u1JXZrmF6i35C)
```





    10. Adjust the REST endpoint so it works correctly.
        a. Edit add-report2.component.ts
        b. Adjust the ngOnInit()  
            
            Change this line
               this.prioritiesObs = this.lookupService.getLookupWithTypeAndOrder(
                                            "priority555555", "display_order");
            
            To this:
               this.prioritiesObs = this.lookupService.getLookupWithTypeAndOrder(
                                            "priority", "display_order");

    11. Verify it works correctly:
        a. Activate the debugger
        b. Go to the "Add Report 2" page
           -- You should see the dropdowns load normally

        
        But, any REST call that fails will be automatically caught and a popup displayed

```
