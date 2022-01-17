Lesson 12g:  Edit Report / Leaves Page / Save and Wait
------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1RMSWf_vUtYZc49MkEU1vvxQho1Tr8flaH4gk7hYYcQ8/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson12g/leave-page-save-and-wait
<br>
<br>
<br>

<h3> Problem Set </h3>

Problem: The user is filling-in lots of form fields and the user has navigated to a different page (without pressing the "save" button).  
- <b>I want the user's navigation to WAIT until the save operation has finished.</b>
- I want the user's navigation to STOP if the save operation fails  
  (so the ErrorInterceptor shows the popup error and keeps the user on the current page)

  
<br>
<br>

<h3>Approach</h3>

1. Create an interface called CanComponentDeactivate that has a public method called  
    public canDeactivate() that returns boolean or Observable&lt;boolean>  
     - If this method returns TRUE, then the router can proceed with navigation  
     - If this method returns FALSE, then the router does not change pages  
     - If this method returns observable&lt;boolean>, then the router \*WAITS\* for it and then decides  

1. Create a guard called CanDeactivateGuard implements CanDeactivate&lt;CanComponentDeactivate>
1. Register the CanDeactivateGuard
1. Tell the Router that the AddReportComponent must call canDeactivate before leaving the page
1. Add the canDeactivate method to the AddReportComponent  
     
     


<br>
<br>

```

Procedure
---------
    1. Create this guard:  CanDeactivateGuard
       a. Create the guard
          unix> cd ~/intellijProjects/angularApp1/frontend
          unix> ng generate guard guards/CanDeactivate  --implements CanDeactivate --skipTests

        b. Edit can-deactivate.guard.ts

        c. Replace its contents with this:

                import { Injectable } from '@angular/core';
                import {ActivatedRouteSnapshot, CanDeactivate, RouterStateSnapshot, UrlTree} from "@angular/router";
                import {Observable} from "rxjs";
                
                
                export interface CanComponentDeactivate {
                
                     canDeactivate: () => Observable<boolean | UrlTree> | 
                                Promise<boolean | UrlTree> | boolean | UrlTree;
                
                }
                
    
                
                @Injectable()
                export class CanDeactivateGuard implements CanDeactivate<CanComponentDeactivate> {
                
                    public canDeactivate(aComponent: CanComponentDeactivate,
                                            aRoute: ActivatedRouteSnapshot,
                                            AState: RouterStateSnapshot) {
                        return aComponent.canDeactivate ? aComponent.canDeactivate() : true;
                    }
                
                }


    2. Register the guard as a provider
        a. Edit app.module.ts
        b. Add CanDeactivateGuard as a provider:

                providers: [
                    CanDeactivateGuard
                ],

        
        When finished, your providers section should look something like this:
            providers: [
            { provide: MAT_FORM_FIELD_DEFAULT_OPTIONS, 
                                useValue: { appearance: 'standard' } },
            { provide: HTTP_INTERCEPTORS, useClass: ErrorInterceptor, multi: true },
            CanDeactivateGuard
            ],
        



    3. Tell the Router that the EditReportComponent must call canDeactivate before leaving the page
        a. Edit app.module.ts
        b. Change the route for Edi to this:

            const appRoutes: Routes = [
            
                   { path: 'page/editReport/:id', component: EditReportComponent, 
                                canDeactivate: [CanDeactivateGuard]     },


            
            This tells the Router that if the user is on the EditReport page and attempts to leave, then call the canDeactivate() method.
            -- If that method returns TRUE, then navigation proceeds.  
            -- If that method returns an observable<TRUE>, then it WAITS and then proceeds.
            


    4. Adjust the EditReportComponent so it runs code and *WAITS* if the user leaves the page
        a. Edit edit-report.component.ts

        b. Change the class definition so it implements CanComponentDeactivate

                export class EditReportComponent  implements OnInit, OnDestroy, CanComponentDeactivate  {
                
                }



        c. Add a private method that will save the data and returns an observable<boolean>
           -- If the save REST call works, return observable<true>
           -- If the save REST call fails, return observable<false>
                
                  /*
                   * Return an observable that will cause the data to be saved
                   * NOTE:  Change what the REST call returns
                   *	The observable returns TRUE  if the REST call succeeds
                   *	The observable returns FALSE if the REST call fails
                   */
                  private saveDataReturnObservable(): Observable<boolean> {
                    
                    // Create a DTO object to send to the back-end
                    let dto: SetUpdateReportDTO = new SetUpdateReportDTO();
                    dto.report_name = this.myForm.controls.report_name.value;
                    dto.priority	= this.myForm.controls.priority.value;
                    dto.id      	= this.reportId;
                
                    return this.reportService.setEditReportInfo(dto).pipe(
                        map( () => {
                                // The REST call finished successfully
                                //  Return an observable<true> so the router goes to the new page
                                return true;
                        }),
                       catchError(() => {
                                // The REST call failed. Return observable<false> so router stays on page
                                // NOTE:  The ErrorInterceptor should be displaying a popup error
                                return of(false);
                       }),
                       finalize( () => {
                            // Finally block with pipes.
                
                           }
                    ));
                
                  }  // end of saveDataReturnObservable()
                



        d. Add the public canDeactivate() method
           NOTE:  This method is needed to implement the interface called CanComponentDeactivate 
            
              /*
               * The user is navigating to another page.  The router calls this method before leaving the page
               * If this method returns true,  then the router *CONTINUES* to a new route
               * If this method returns false, then the router *STAYS HERE*
               */
             public canDeactivate(): Observable<boolean | UrlTree> | Promise<boolean | UrlTree> |
                                                 boolean | UrlTree {
            
                 if (! this.myForm.dirty) {
                // The user did *NOT CHANGE* any form field values.  
                // So, let the router proceed to the next page
                return true;
                }
            
               // Return an observable<boolean> so the router will *SUBSCRIBE AND WAIT*
               //  for the REST call to finish
               return this.saveDataReturnObservable();
            }
            


    5. Verify it works
        a. Set a breakpoint in your ReportController.updateReport()
        b. Activate your debugger on 'Full WebApp'
        c. Go to the "View Reports" page
        d. Click to Edit a Report

        e. Change one of the fields in the "Edit Report" page
           -- Change the report name to something else

        f. Click on the left-side navbar to go to a different page -- e.g., View Reports
           -- The save REST call should get hit (and your breakpoint should get hit)
           -- Press F9 to let the save continue

        g. Go back to Edit the same report
           -- Verify that you see that the report was updated


```
