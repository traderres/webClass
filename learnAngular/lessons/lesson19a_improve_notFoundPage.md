Lesson 19a:  Improve the "Not Found" page
-----------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1AgovT8hV91i4XHIGlUX4ToYGsH1DAnUH_8tJEgFFo0E/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson19a/not-found-page
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem:  The user attempts to visit a page that has no route<br>
Solution:  Show them a respectable "Not Found" page<br>

<br>
<br>

![](https://lh6.googleusercontent.com/m9qnYL53eX824xLHaVSH0TxgufaWqzn4KOuMwZWX8ojL0ZdW64FXybQJFHjNvirKy9kLeCxmr_cpobu2YSE88crQFxFcdPEQUYuQqJfujyNaoCutSaZGNynwbZQq1NrrT86JwJDt)




<br>
<br>

```
Procedure
---------
    1. Verify that your router will take users to the NotFoundComponent  (if no routes match)
        a. Edit app.module.ts

        b. Verify that you see this in your routes 
            
            const appRoutes: Routes = [
              { path: 'page/addReport',	component: AddReportComponent },
              { path: 'page/addReport2',	component: AddReport2Component },
              { path: 'page/viewReports',  component: ViewReportsComponent },
              { path: 'page/dashboard',	component: DashboardComponent },
              { path: 'page/usa-map',  	component: UsaMapComponent },
              { path: 'page/chart-drill-down',   component: ChartDrillDownComponent },
              { path: 'page/longView/:id',  component: LongViewInternalNavReportComponent },
              { path: 'page/editReport/:id', component: EditReportComponent },
              { path: 'page/search/details/:id', component: SearchBoxDetailsComponent },
              { path: 'page/uploadReport', component: UploadReportComponent },
              { path: 'page/chart1',   	component: Chart1Component },
              { path: 'page/chart2',   	component: Chart2Component },
              { path: 'page/longReport', 	component: LongViewOuterReportComponent },
              { path: '',              	component: WelcomeComponent},
              { path: '**',            	component: NotFoundComponent}
            ];


            NOTE:  The last route should be '**' and takes users to the NotFoundComponent



    2. Improve the not found page so it looks better
        a. Edit not-found.component.html

        b. Remove all of its contents

        c. Add a mat-card 

        d. Add a <mat-card-title> </mat-card-title> with the title of Page Not Found

        e. Add a <mat-card-content> with a message "You navigated to page that does not exist"


    3. Verify that your "Not Found" component shows this error when you attempt to navigate to a route that is not defined.
        a. Activate your Debugger on "Full WebApp"
        b. Change the url to something that is not found -- http://localhost:4200/page/whatever
        c. Verify that your page looks like this:
```
![](https://lh6.googleusercontent.com/yvURqQgV6QIxg0uLRr0vbobnRdmI8JGa79HvduOZKKdkrutRzNrPAMn8-bgUF4qIfrU9jWRDy1R3JfW1KSahvpsYAzGnemkS0izPYwzhyRrFDGDAcECF88JmRMR3f-FUnwrYVgvs)
```
V1 shows a message if a user navigates to a route that is not defined






    4. Add a font-awesome icon fas fa-exclamation-triangle with a size of 5x underneath the page title
        
       So, your page layout should look like this
        
            Page Not Found     
            15px of space
            Font Awesome Exclamation Triangle 5x
            15px of space
            You navigated to a page that does not exist
    


    5. Verify that your page has the big font awesome icon
        a. Activate your Debugger on "Full WebApp"
        b. Change the url to something that is not found -- http://localhost:4200/page/whatever
        c. Verify that your page looks like this:
```
![](https://lh6.googleusercontent.com/FxnwBAI6a49-711-Yknou72IJwbwlClq60ASNAUNnQRQbn_K-CCmk8b_OXtdJkllfbm_RTTviq2Nf0PBLCI2hOYVfM-AiPTP2Vxg5lu18406-QmmebqR-EAUCsU1XwNzDJrywIzO)
```
V2:  It looks better with the icon, but we're using half of the page (not 100% of the page).






    6. Let's clean it up by doing a few things
        a. Add a "page-container" css class to your styles.css with a margin of 10px


        b. Add a wrapper div with class="page-container" to the page


        c. Change the mat-card-content to use 100% of the page

           Add a wrapper div (inside the mat-card-content) that adds this:
               <div style="height: calc(100vh - 140px)">
            
               </div>

        
        
        When completed, your not-found.component.html should look something like this:
        
        <div class="page-container">
        
            <mat-card>
        
            <mat-card-title>Page Not Found</mat-card-title>
        
            <mat-card-content>
        
                   <!-- Setup a wrapper div that uses the entire available height (total height - 140px) -->
                   <div style="height: calc(100vh - 140px)">
        
                    <i style="margin-top: 15px" class="fas fa-exclamation-triangle fa-5x"></i>
        
                    <div style="display: block; margin-top:15px">
                            You navigated to a page that does not exist
                    </div>
                   </div>
        
            </mat-card-content>
        
            </mat-card>
        </div>


    7. Verify that your "Not Found" page uses the full page
        a. Activate your Debugger on "Full WebApp"
        b. Change the url to something that is not found -- http://localhost:4200/page/whatever
        c. Verify that your page looks like this:
```
![](https://lh6.googleusercontent.com/m9qnYL53eX824xLHaVSH0TxgufaWqzn4KOuMwZWX8ojL0ZdW64FXybQJFHjNvirKy9kLeCxmr_cpobu2YSE88crQFxFcdPEQUYuQqJfujyNaoCutSaZGNynwbZQq1NrrT86JwJDt)
```
V3:  The page uses 100% of the height.  There is a 3d effect (from the mat-card and the page-container class adding a margin of 10px)




```
