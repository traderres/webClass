Lesson 6a: Add Navigation Bar 1 / Simple Bar
--------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1HK9pRqwka0NX9wcMVETt2R3reN1vAMETN8zgm7dyrnk/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson6a/navbar-simple
<br>
<br>


In this lesson, we will create a navigation bar that looks like this:

![](https://lh4.googleusercontent.com/ICgqcVNBbuYhLk3FFimxeEGMvc4lW43mgwCfryLFPs9X4xPzWoveTqiM_Ja1xRtBohNFTkEvyvCjHEM59kd3U9Jd6oJ51bt1aKayL4gfs3LnFoSwh2VBTMqJqGHlHYLlRiJJ5Dv6)



```
Notes
    • Clicking on the hamburger makes the left-side nav appear/disappear
    • The link to Add Reports work (because that page was created
    • The link to View Reports does not work (because that page has not been created yet) 


Procedure
---------
    1. Add a navigation bar to the app.component.html to this:
        a. Go to frontend/src/app/app.component.html
        b.  Replace it with this:

         <div>
           <!-- Top Menubar -->
           <mat-toolbar color="primary">
             <mat-toolbar-row style="padding-left: 0">
               <button mat-icon-button>
                 <mat-icon (click)="sidenav.toggle()">
                   <!-- hamburger icon that shows/hides the navigation bar -->
                   <i class="fas fa-bars"></i>
                 </mat-icon>
               </button>

               <h1>{{title}}</h1>
               <span class="menu-spacer"></span>
               <div>
                 <!-- Top Menubar Buttons -->
                 <a mat-button [routerLink]="'page/addReport'">Add Report</a>
                 <a mat-button [routerLink]="'page/viewReports'">View Reports</a>
               </div>
               <span class="menu-spacer"></span>

             </mat-toolbar-row>
           </mat-toolbar>

           <!-- Side Navigation Bar -->
           <mat-sidenav-container>
             <!-- On Page load, the side navigation is already opened -->
             <mat-sidenav #sidenav mode="side" opened="true">
               <mat-nav-list>
                 <a mat-list-item [routerLink]="'page/addReport'">Add Report</a>
                 <a mat-list-item [routerLink]="'page/viewReports'">View Reports</a>
               </mat-nav-list>
             </mat-sidenav>

             <mat-sidenav-content>
               <div style="height: 88vh;">
                 <!-- Main Viewing Area -->
                 <router-outlet></router-outlet>
               </div>
             </mat-sidenav-content>
           </mat-sidenav-container>
         </div>



    2. Add missing Angular Material modules
        
        WARNING:  If you do not get the option to import the module angular Model in IntelliJ, then
		1. Delete frontend/node_modules   
		2. Right-click on front-end/package.json -> Run 'npm install'
		3. Wait for Intellij to re-download the files
		4. Wait for IntelliJ to finish reindexing
		

        a. In the app.component.html, place the mouse pointer over <mat-toolbar>
            -- You should see red lines on the right that say
               "Component or directive matching...is out of the current angular module scope"
            -- Press Alt-Enter
            -- You should get the option to "Import MatToolbarModule"
            -- Select this option

        b. Put the mouse over <mat-icon>
            -- Press Alt-Enter
            -- You should get the option to "Import MatIconModule"
            -- Select this option

        c. Put the mouse over <mat-sidenav-container>
            -- Press Alt-Enter
            -- You should get the option to "Import MatSidenavModule"
            -- Select this option

        d. Put the mouse over <mat-nav-list>
            -- Press Alt-Enter
            -- You should get the option to "Import MatListModule"
            -- Select this option

 **OR**

    Add these imports to the app.module.ts
        MatToolbarModule,
        MatIconModule,
        MatSidenavModule,
        MatListModule,
        
	


    3. Verify that your app.module.ts contains these modules
        a. Go to app.modules.ts

        b. Look at the app.module.ts
        c. Verify that these modules are here:

			MatToolbarModule,
    			MatIconModule,
    			MatSidenavModule,
    			MatListModule,


    4. Define the CSS for menu-spacer
        a. Edit frontend/src/styles.css
        b. Add this to the styles.css

            .menu-spacer {
                       width: 25px
            }


    5. Create the NotFound Component
        -- This is the page that shows if a user navigates to a page that is not defined
        unix> cd ~/intellijProjects/angularApp1/frontend
        unix> ng generate component notFound 


    6. Make sure your app.module.ts has these routes defined
        (If this is confusing, see the next page and the changes are in bold)
        
        // Setup the routes.  If no route is found, then take the user to the NotFoundComponent
        const appRoutes: Routes = [
          { path: 'page/addReport',	component: AddReportComponent },
          { path: '**',            	component: NotFoundComponent  }    
        ];

        NOTE:  If you have not defined any routes, then add this:
        
        imports [
           RouterModule.forRoot(appRoutes),
        ]

        
        So, your app.module.ts would look something like this:
        
        import { BrowserModule } from '@angular/platform-browser';
        import { NgModule } from '@angular/core';
        import { AppRoutingModule } from './app-routing.module';
        import { AppComponent } from './app.component';
        import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
        import {MatSidenavModule} from "@angular/material/sidenav";
        import {MatToolbarModule} from "@angular/material/toolbar";
        import {MatIconModule} from "@angular/material/icon";
        import {MatButtonModule} from "@angular/material/button";
        import {MatListModule} from "@angular/material/list";
        import { AddReportComponent } from './reports/add-report/add-report.component';
        import {RouterModule, Routes} from "@angular/router";
        import { NotFoundComponent } from './not-found/not-found.component';
        
        const appRoutes: Routes = [
          { path: 'page/addReport',  component: AddReportComponent },
          { path: '**',          	           component: NotFoundComponent  }
        ];
        
        @NgModule({
          declarations: [
            AppComponent,
            AddReportComponent,
            NotFoundComponent
          ],
          imports: [
            BrowserModule,
            AppRoutingModule,
            BrowserAnimationsModule,
            MatSidenavModule,
            MatToolbarModule,
            MatIconModule,
            MatButtonModule,
            MatListModule,
            RouterModule.forRoot(appRoutes)
          ],
          providers: [],
          bootstrap: [AppComponent]
        })
        export class AppModule { }
        
        



    7. Activate the debugger to see your new menu
        a. Pull Run -> Debug 'Full WebApp'
        b. Verify that you see a menubar
```
![](https://lh4.googleusercontent.com/tkzBCf9uixqScE_a0g08NZB4py7ZMKB1ZlwcMkJAfyIb1NHGurFRrSSJ_LfQl4ncXAw0BtxjMyVC1xA4_4LoKgO8P9f7ifiyPKpwSMQ3StpkY1mq1sMw1YVopwLPKC-J2z76c3gq)  
```
        c. Click on the "Add Report" option (on the top or left side)
            -- You should see the "Add Report" page inside the viewing area
```
![](https://lh3.googleusercontent.com/B-FEQxPowbpZVNAoDK0G76SM32RxlAxEDQDSbeVCthQylCwcU3cmkZGMug-cgcLz9XvXNmFsGU9v6mD05bjqunQbSxFSaBb4mREOtgVzfQ8ieQklqVzCkI7mO3XA79FCSEyACIqN)  
```

        d. Click on "View Reports", and you see the "Not Found Component"

```
<table border="1"><tr><td>
<img src="https://lh5.googleusercontent.com/ymcq3R0mDLh_88Kdkqs0c8oM_Ly1hbiqFIUFPs7SUuP2_2gCOHW1zdFmlXsdoIskibHgPRJ167obI0XIUQfK1vDadXUPv8VnrbuIa2dOB1KJYCSyOcCrO-KE4Wo0IK6tz_PB_Jug"/>
</td></tr></table>
```
    

 Why is the "Not Found" page displayed?




NOTES:  Moving Forward, Every New Page Component Needs the Big Three:
So, if you want to navigate to a page, then you must have 3 things:
    1. A component must exist for the page -- e.g., AddReport.component.ts, AddReport.component.html
        unix> cd ~/intellijProjects/angularApp1/frontend
        unix> ng generate component myPage


    2. A route must exist in the app.module.ts
        
        const appRoutes: Routes = [
          { path: 'page/addReport',	component: AddReportComponent },
          { path: 'page/my',   		component: MyPageComponent },
          { path: '**',            		component: NotFoundComponent  }
        ];

NOTE:  The *LAST* item in the apRroutes must be '**'
-- So, if the user navigates to an unknown page, then show the NotFoundComponent



    3. A link must exist in the navigation bar (so the user can get to that page).
        a. Edit navbar.component.html or app.component.html

        b. Add the the link:

        <a mat-list-item [routerLink]="'page/my'">My New Page</a>
         

```
