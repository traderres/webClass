Lesson 12a:  Edit Report / Add Front-End Page & Navigation
----------------------------------------------------------
The Google Drive link is here:<br>
https://docs.google.com/document/d/1inEHreMvluu0-rdXtqBu_34xaCLMK8ThONbZ11g9j04/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson12a/add-frontend-page
<br>
<br>
<br>



<h3>Thoughts on the Edit Report Page</h3>
The Edit Report page is more complex than other pages:

- Need to build 2 REST calls: One to load data, one to save data
- Need to invoke theload REST call to get the report data
- Need to show an error if an invalid report Id is passed-in  
  (We do not want to show the user a crippled web page)
- Need to initialize the reactive form with the report data
- Need to do form validation (so all required fields are filled-in)
- Need to invoke thesave REST call to save data:
  - Save the report when the user presses a "Save" button (on a click event)
  - Save the report when the user leaves the page
  - Save the report 5 seconds after any form field value changes (asynchronously)

  
<br><br>


The Edit Report page is different from other pages in that there is no direct navigation to it  
- This page needs an ID passed-in  
- The user will navigate to "View All Reports", then click on a single report to edit

  
  
  
<br>
<br>

<h3>Approach</h3>

1. Create a Edit Report Page (as a blank component)
2. Add the Edit-Report-Page route to the app.module.ts
3. Have the Edit Report Page get the id and display it in the HTML
4. Change View Reports so there is an "Edit" button that navigates to the Edit Report page

  
<br>
<br>

The goal of this lesson is to create a simple Edit Report page and verify that users can navigate to it.


<br>
<br>

```
Procedure
---------
 
Procedure
    1. Generate the Edit Report Page
       unix> cd ~/intellijProjects/angularApp1/frontend
       unix> ng generate component reports/edit-report --skipTests


    2. Add a route for the Edit Report Page
       NOTE:  This route has a required parameter

        a. Edit app.module.ts

        b. Add this route:
               { path: 'page/editReport/:id', component: EditReportComponent },

            
           When finished, your routes should look something like this:
                
                // Setup the routes.  If no route is found, then take the user to the NotFoundComponent
                const appRoutes: Routes = [
                  { path: 'page/addReport',	component: AddReportComponent },
                  { path: 'page/addReport2',	component: AddReport2Component },
                  { path: 'page/viewReports',  component: ViewReportsComponent },
                  { path: 'page/editReport/:id', component: EditReportComponent },
                  { path: 'page/chart1',   	component: Chart1Component },
                  { path: 'page/chart2',   	component: Chart2Component },
                  { path: '',              	component: WelcomeComponent},
                  { path: '**',            	component: NotFoundComponent}
                ];



    3. Adjust the Edit Report page so it pulls out the required parameter and holds it in a variable
        a. Edit edit-report.component.ts

        b. Inject the ActivatedRoute into the Edit Report Page 

        c. Inject the ErrorService into the Edit Report page

        d. Add a public reportId
              public reportId: number;

        e. Adjust the ngOnInit() so that it checks if the passed-in id is numeric
            
              public ngOnInit(): void {
                // Get the raw id from the activatedRoute
                let rawId: string | null = this.activatedRoute.snapshot.paramMap.get("id");
            
                if (! isNumeric(rawId))  {
                    // No id or a non-numeric ID was passed-in.  So, display an error and stop here
                    this.errorService.addError(new HttpErrorResponse({
                            statusText: "Invalid Page Parameters",
                            error:  	"The Report ID is invalid or not passed-in."
                    }));
            
                    // Stop here -- so the user sees nothing on the edit reports page
                    return;
                }
            
                // Convert the rawId into a numeric value (using the plus sign trick)
                this.reportId = +rawId;
              }


    4. Adjust the Edit Report page so it displays the report id
        a. Edit edit-report.component.html

        b. Replace its contents with this:
            
            Edit Report<br/><br/>
            
            The Report ID is {{this.reportId}}
            
            

    5. Adjust the View Reports class so that there is an method that navigates to the Edit Report page
        a. Edit view-reports.component.ts

        b. Inject the router (using constructor injection)

        c. Add a new public method called goToEditReport():
            
              public goToEditReport(aReportId: number): void {
                // Take the user to the Edit Report page and pass-in the reportId
                this.router.navigate(['page/editReport/',   aReportId]).then();
              }
            
            

    6. Add an "Edit" button to the View Reports html 
        a. Edit view-reports.component.html


        b. Add another column (before the Report ID) that in the table headers that is empty

             <div fxFlex="15%">
                	<!-- Empty header above buttons -->
             </div>


        c. Add another column (before the Report ID) that has an Edit button that calls the method
            <div fxFlex="15%"  fxLayoutAlign="center">
                <!-- Edit Report Button -->
                <button mat-raised-button (click)="this.goToEditReport(report.id)">Edit</button>
            </div>
        


    7. Verify that you can navigate to the Edit Report page and get the ID
        a. Activate the debugger on 'Full WebApp'
        b. Click on "View Reports"
           -- You should see the "Edit" button 
```
![](https://lh4.googleusercontent.com/Kx-qjEpeMriZnjIUlivpgybOgyADm182KevEMwV8IEpCF-ULhlOJHNwptYjMQyezWEBhoQqvGeYrN1bqKhDNOeRr9nhApsuKqn7gm1lv6hN27Uao5jf7I_E8Qp9AqGWVkWx_NowK)
```





        c. Click on "Edit" next to one of the buttons
           -- You should see the "Edit Report" page with the correct id
```
![](https://lh3.googleusercontent.com/Olc4VLhJQCalAd41QyKUxHIUlaQNaRUs4bmKyKdKXTxagICmiUJwHUMo4idrmWNkWvk5ixw6Z4ek8FTFG6F6I8_7wA653U2wixXsNmWuKcp_zb1feEqFAr_adNGrbYtAYp5Jod4l)
