Lesson 6d:  Add Navigation Bar 2 / Collapsable Menu Groups
----------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1IUBAVqovoN5LBoWgNQH77wytS1hQmSL6sWSefCs1tVU/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson6b/navbar-holy-grail-layout
<br>
<br>






Upon entering the webapp, the section headers are collapsed:
![](https://lh4.googleusercontent.com/PkV_rdsNFSSECNhYmAxeQuePXWA_2tlc8fmgOOejWCc4Xnq94NBDNc6nDYlmx-G8oyte7fgqLJcYvPqblq5qQ4FbnikPNsAi9_o40OSEGd9dliT4KkulP-t1lxs_djpWNcG7_cBh)  
<br>
<br>
Clicking on the "Reports" section header opens it
![](https://lh3.googleusercontent.com/MyX79e1-mmpGLJWx3jnTVxg-y-Ev7xZk4i0eMrS4kCglnjpS4XoZvnrAKH-jbTWQrhd_4w-uH9B2Z_b5N2XGCmC8GGEuuIrK5syOIihJOpOv2TgO1FqjjODN8zInRiMbKoX8HL4o)  
<br>
<br>
  




```
Procedure
    1. Make sure there is no gap between the left navbar and the content window
        NOTE:  The fxLayoutGap controls the space between the left navbar and the main viewing area

        a. Edit app.component.html
        b. Set the width of the navbar to be 200px
            Set the fxLayoutGap="0px"


        When finished, the app.component.html should look like this:
            <div fxFlexFill fxLayout="column">
                        
              <div fxFlex="75px">
                <!-- Header is 75 pixels high -->
                <app-header></app-header>
              </div>
            
            
              <div fxFlex fxLayout="row" fxLayoutGap="0px">
                <div fxFlex="200px" style="padding: 0" *ngIf="this.isSideNavVisible">
                  <!-- Left Side Navigation -->
                  <app-navbar></app-navbar>
                </div>
            
                <div fxFlex>
                  <!-- Main Viewing Area -->
                  <router-outlet></router-outlet>
                </div>
              </div>
            
            </div>


    2. Add the 2nd menu group
        a. Edit navbar.component.html
        b. Update navbar.component.html so it looks like this:
            
            <mat-sidenav-container autosize>
              <mat-sidenav class="navbar" style="width:200px" mode="side" opened="true"
            [fixedInViewport]="true" [fixedTopGap]="75" [fixedBottomGap]="0">
                <mat-nav-list style="margin-top: 0; padding-top: 0">
            
                  <!-- Menu Group 1 -->
                  <div class='navHeader' [ngClass]="{'toggled': reportsToggled == true}"
                    (click)="reportsToggled = !reportsToggled">
                 <i class="fa fa-file-alt navHeaderIcon"></i>
                 <span class="navHeaderTitle">Reports</span>
                  </div>
            
                  <div class='navGroup' data-ng-class="{'toggled': reportsToggled}">
            
                 <!-- View Reports -->
                 <mat-list-item class="navItem" [routerLink]="'page/viewReports'" >
                   <a title="View Reports">View Reports</a>
                   <div fxFlex fxLayoutAlign="end end">
                     <a [routerLink]="'page/viewReports'" target="_blank">
                       <i class="fas fa-external-link-alt navItemIcon" title="Open View Reports in a
            new window"></i>
                     </a>
                   </div>
                 </mat-list-item>
            
                 <!-- Add Report -->
                 <mat-list-item class="navItem" [routerLink]="'page/addReport'">
                   <a title="Add Report">Add Report</a>
                   <div fxFlex fxLayoutAlign="end end">
                     <a [routerLink]="'page/addReport'" target="_blank">
                       <i class="fas fa-external-link-alt navItemIcon" title="Open Add Report in a new
             window"></i>
                     </a>
                   </div>
                 </mat-list-item>
            
                 <!-- Audit History -->
                 <mat-list-item class="navItem" [routerLink]="'page/auditHistory'">
                   <a title="Audit History">Audit History</a>
                   <div fxFlex fxLayoutAlign="end end" >
                     <a [routerLink]="'page/auditHistory'" target="_blank">
                       <i class="fas fa-external-link-alt navItemIcon" title="Open Audit History in a new
            window"></i>
                     </a>
                   </div>
                 </mat-list-item>
                  </div>  <!-- End of navMenuGroup -->
            
                  <!-- Menu Group 2 -->
                  <div class='navHeader'>
                 <i class="fa fa-file-alt navHeaderIcon"></i>
                 <span class="navHeaderTitle">Analytics</span>
                  </div>
            
                  <!-- Menu Group 2 Items -->
                  <div class='navGroup' data-ng-class="{'toggled': reportsToggled}">
            
                 <!-- Chart 1 -->
                 <mat-list-item class="navItem" [routerLink]="'page/chart1'" >
                   <a title="Chart 1">Chart 1</a>
                   <div fxFlex fxLayoutAlign="end end">
                     <a [routerLink]="'page/chart1'" target="_blank">
                       <i class="fas fa-external-link-alt navItemIcon" title="Open Chart 1 in a new
            window"></i>
                     </a>
                   </div>
                 </mat-list-item>
            
                 <!-- Chart 2 -->
                 <mat-list-item class="navItem" [routerLink]="'page/chart2'">
                   <a title="Chart 2">Chart 2</a>
                   <div fxFlex fxLayoutAlign="end end">
                     <a [routerLink]="'page/chart2'" target="_blank">
                       <i class="fas fa-external-link-alt navItemIcon" title="Open Chart 2 in a new
            window"></i>
                     </a>
                   </div>
                 </mat-list-item>
            
                  </div>  <!-- End of Menu Group 2 Items -->
            
                </mat-nav-list>
              </mat-sidenav>
            </mat-sidenav-container>

    3. Add components for chart1 and chart2
        unix> cd ~/intellijProjects/angularApp1/frontend
        unix> ng generate component analytics/chart1
        unix> ng generate component analytics/chart2

    4. Add routes (to app.module.ts)
        a. Edit app.module.ts
        b. Add these routes to appRoutes
            { path: 'page/chart1',  component: Chart1Component },
            { path: 'page/chart2',  component: Chart2Component }
            { path: '',              	component: WelcomeComponent},

        c. When finished, the appRoutes list should look like this:
            
            const appRoutes: Routes = [
              { path: 'page/addReport',    component: AddReportComponent },
              { path: 'page/viewReports',  component: ViewReportsComponent },
              { path: 'page/chart1',   	    component: Chart1Component },
              { path: 'page/chart2',   	    component: Chart2Component },
              { path: '',              	    component: WelcomeComponent},
              { path: '**',            	    component: NotFoundComponent}
            ];

            WARNING:  The path for '**' must be *LAST*


    5. Adjust the navbar so that clicking on a navbar item is highlighted in the navbar
        a. Edit navbar.component.css
        b. Add this:
            
            .mat-list-item.active{
              /* Set the color for the actively clicked navbar item */
              /* Active mat-list-item has a background gradient that goes to the right */
              color: #fff;
              background: linear-gradient(to right, #5e6b7b, rgba(94, 107, 123, 0));
              font-weight: bold;
            }
            
            When finished, the navbar.component.css should look this:
            .navbar {
              background: #364150;
              color: white;
            }
            
            .mat-list-item {
              font-family: Verdana, sans-serif;
              font-size: 13px;
              color: white;
              height: 25px;
            }
            
            .mat-list-item.active{
              /* Set the color for the actively clicked navbar item */
              /* Active mat-list-item has a background gradient that goes to the right */
              color: #fff;
              background: linear-gradient(to right, #5e6b7b, rgba(94, 107, 123, 0));
              font-weight: bold;
            }
            
            .navHeader{
              /* The navHeader as a gradient that goes to the left */
              background: linear-gradient(to left, #5e6b7b, rgba(94, 107, 123, 0));
              font-family: Verdana, sans-serif;
              font-size: 16px;
              font-weight:bold;
              padding: 0;
              margin-top: 0;
              height: 44px;
              display: flex;
              align-items: center;
            }
            
            .navHeaderIcon {
              margin-left: 7px;
            }
            
            .navHeaderTitle {
              margin-left: 8px;
            }
            
            .mat-list-item.navItem {
              height: 40px;
            }
            
            .navItem:hover  {
              color: #fff;
              background: linear-gradient(to right, #5e6b7b, rgba(94, 107, 123, 0));
              font-weight: bold;
            }
            
            .navItemIcon {
              /* By default, the navItemIcon is invisible (It's the same color as the navbar background) */
              color: #364150
            }
            
            .navItem:hover .navItemIcon {
              /* When hovering over navItem change the color of the navItemIcon so it appears */
              color: #999
            }


        c. Add routerLinkActive="active" to the <mat-list-item>
           NOTE:  This tells Angular Material to add a the CSS class of "active" when is item is clicked
            i. Edit navbar.component.html


            ii. Change this:
                    <mat-list-item class="navItem" [routerLink]="'page/chart1'">
                To this:
                    <mat-list-item class="navItem" [routerLink]="'page/chart1'" routerLinkActive="active">


            iii. Repeat step 2 for all of the <mat-list-item> tags
                

            When completed, navbar.component.html should look like this:
                
                <mat-sidenav-container autosize>
                  <mat-sidenav class="navbar" style="width:200px" mode="side" opened="true"
                [fixedInViewport]="true" [fixedTopGap]="75" [fixedBottomGap]="0">
                    <mat-nav-list style="margin-top: 0; padding-top: 0">
                
                      <!-- Menu Group 1 -->
                      <div class='navHeader' [ngClass]="{'toggled': reportsToggled == true}"
                        (click)="reportsToggled = !reportsToggled">
                     <i class="fa fa-file-alt navHeaderIcon"></i>
                     <span class="navHeaderTitle">Reports</span>
                      </div>
                
                      <div class='navGroup' data-ng-class="{'toggled': reportsToggled}">
                
                     <!-- View Reports -->
                     <mat-list-item class="navItem" [routerLink]="'page/viewReports'"
                routerLinkActive="active">
                       <a title="View Reports">View Reports</a>
                       <div fxFlex fxLayoutAlign="end end">
                         <a [routerLink]="'page/viewReports'" target="_blank">
                           <i class="fas fa-external-link-alt navItemIcon" title="Open View Reports
                in a new window"></i>
                         </a>
                       </div>
                     </mat-list-item>
                
                     <!-- Add Report -->
                     <mat-list-item class="navItem" [routerLink]="'page/addReport'"
                routerLinkActive="active">
                       <a title="Add Report">Add Report</a>
                       <div fxFlex fxLayoutAlign="end end">
                         <a [routerLink]="'page/addReport'" target="_blank">
                           <i class="fas fa-external-link-alt navItemIcon" title="Open Add Report in
                a new window"></i>
                         </a>
                       </div>
                     </mat-list-item>
                
                     <!-- Audit History -->
                     <mat-list-item class="navItem" [routerLink]="'page/auditHistory'"
                routerLinkActive="active">
                       <a title="Audit History">Audit History</a>
                       <div fxFlex fxLayoutAlign="end end" >
                         <a [routerLink]="'page/auditHistory'" target="_blank">
                           <i class="fas fa-external-link-alt navItemIcon" title="Open Audit History
                in a new window"></i>
                         </a>
                       </div>
                     </mat-list-item>
                      </div>  <!-- End of navMenuGroup -->
                
                      <!-- Menu Group 2 -->
                      <div class='navHeader'>
                     <i class="fa fa-file-alt navHeaderIcon"></i>
                     <span class="navHeaderTitle">Analytics</span>
                      </div>
                
                      <!-- Menu Group 2 Items -->
                      <div class='navGroup' data-ng-class="{'toggled': reportsToggled}">
                
                     <!-- Chart 1 -->
                     <mat-list-item class="navItem" [routerLink]="'page/chart1'"
                routerLinkActive="active">
                       <a title="Chart 1">Chart 1</a>
                       <div fxFlex fxLayoutAlign="end end">
                         <a [routerLink]="'page/chart1'" target="_blank">
                           <i class="fas fa-external-link-alt navItemIcon" title="Open Chart 1 in a
                new window"></i>
                         </a>
                       </div>
                     </mat-list-item>
                
                     <!-- Chart 2 -->
                     <mat-list-item class="navItem" [routerLink]="'page/chart2'"
                routerLinkActive="active">
                       <a title="Chart 2">Chart 2</a>
                       <div fxFlex fxLayoutAlign="end end">
                         <a [routerLink]="'page/chart2'" target="_blank">
                           <i class="fas fa-external-link-alt navItemIcon" title="Open Chart 2 in a
                new window"></i>
                         </a>
                       </div>
                     </mat-list-item>
                
                      </div>  <!-- End of Menu Group 2 Items -->
                
                    </mat-nav-list>
                  </mat-sidenav>
                </mat-sidenav-container>

            iv. Verify that the reportsToggled variable exists in navbar.component.ts  (if it is not found)
	                public reportsToggled: boolean = true;


    6. Try it out
        a. Run the Debugger on 'Full WebApp'
        b. Look at the navigation bar
```
![](https://lh5.googleusercontent.com/i_uQ_Ui7yGp_QP-RmFNOWzyHeiF2ubOVd2g4FjH6xIY2DXzjMab4d0jYFxOYXGWgBGZH1mFET5oKQ3bogtkNkWT2SAL9E4nvn0OmlGk3WgU2Ss3X5JmKULazQBKawfJF9RHFZbIt)  
```
When you click on a navigation item, it is highlighted with the active class
The .mat-list-item.active class causes it to appear with a gradient



    7. Adjust the navbar so that clicking on a navbar header opens/closes a nav group
        a. Add a new CSS class to the navbar.component.css called navGroupClosed
            .navGroupClosed {
              display: none;
            }

        b. Add two properties to the navbar.component.ts:
        	public reportsNavGroupClosed: boolean = true;
	        public analyticsGroupClosed: boolean = true;	

        c. Remove the reportsToggled boolean from navbar.component.ts


        d. Edit navbar.component.html
            Change the menu groups so that the css class "navGroupClosed" is applied if the property is set to true

            Replace navbar.component.html with this:
                
                <mat-sidenav-container autosize>
                  <mat-sidenav class="navbar" style="width:200px" mode="side" opened="true" [fixedInViewport]="true" [fixedTopGap]="75" [fixedBottomGap]="0">
                    <mat-nav-list style="margin-top: 0; padding-top: 0">
                
                      <!-- Menu Group 1 -->
                      <div class='navHeader'  (click)="reportsNavGroupClosed = !reportsNavGroupClosed">
                     <i class="fa fa-file-alt navHeaderIcon"></i>
                     <span class="navHeaderTitle">Reports</span>
                      </div>
                
                      <!-- Menu Group 1 Items -->
                      <div class='navGroup' [ngClass]="{'navGroupClosed': reportsNavGroupClosed == true}">
                
                     <!-- View Reports -->
                     <mat-list-item class="navItem" [routerLink]="'page/viewReports'"
                routerLinkActive="active">
                       <a title="View Reports">View Reports</a>
                       <div fxFlex fxLayoutAlign="end end">
                         <a [routerLink]="'page/viewReports'" target="_blank">
                           <i class="fas fa-external-link-alt navItemIcon" title="Open View Reports in a
                new window"></i>
                         </a>
                       </div>
                     </mat-list-item>
                
                     <!-- Add Report -->
                     <mat-list-item class="navItem" [routerLink]="'page/addReport'"
                routerLinkActive="active">
                       <a title="Add Report">Add Report</a>
                       <div fxFlex fxLayoutAlign="end end">
                         <a [routerLink]="'page/addReport'" target="_blank">
                           <i class="fas fa-external-link-alt navItemIcon" title="Open Add Report in a new
                window"></i>
                         </a>
                       </div>
                     </mat-list-item>
                
                     <!-- Audit History -->
                     <mat-list-item class="navItem" [routerLink]="'page/auditHistory'"
                routerLinkActive="active">
                       <a title="Audit History">Audit History</a>
                       <div fxFlex fxLayoutAlign="end end" >
                         <a [routerLink]="'page/auditHistory'" target="_blank">
                           <i class="fas fa-external-link-alt navItemIcon" title="Open Audit History in a new
                window"></i>
                         </a>
                       </div>
                     </mat-list-item>
                      </div>  <!-- End of navMenuGroup -->
                
                      <!-- Menu Group 2 -->
                      <div class='navHeader'   (click)="analyticsGroupClosed = !analyticsGroupClosed">
                     <i class="fa fa-file-alt navHeaderIcon"></i>
                     <span class="navHeaderTitle">Analytics</span>
                      </div>
                
                      <!-- Menu Group 2 Items -->
                      <div class='navGroup' [ngClass]="{'navGroupClosed': analyticsGroupClosed == true}">
                
                      <!-- Chart 1 -->
                     <mat-list-item class="navItem" [routerLink]="'page/chart1'" routerLinkActive="active">
                       <a title="Chart 1">Chart 1</a>
                       <div fxFlex fxLayoutAlign="end end">
                         <a [routerLink]="'page/chart1'" target="_blank">
                           <i class="fas fa-external-link-alt navItemIcon" title="Open Chart 1 in a new
                window"></i>
                         </a>
                       </div>
                     </mat-list-item>
                
                     <!-- Chart 2 -->
                     <mat-list-item class="navItem" [routerLink]="'page/chart2'" routerLinkActive="active">
                       <a title="Chart 2">Chart 2</a>
                       <div fxFlex fxLayoutAlign="end end">
                         <a [routerLink]="'page/chart2'" target="_blank">
                           <i class="fas fa-external-link-alt navItemIcon" title="Open Chart 2 in a new
                window"></i>
                         </a>
                       </div>
                     </mat-list-item>
                      </div>  <!-- End of Menu Group 2 Items -->
                
                    </mat-nav-list>
                  </mat-sidenav>
                </mat-sidenav-container>



    8. Try it out
        a. Run the Debugger on 'Full WebApp'

        b. Clicking on the "Reports" header shows/hides all of its menu items
```
![](https://lh5.googleusercontent.com/NHX-j3vtDUBlwf7e4nFagsxLIqFg_UNjVHiMVO9t5fsFThCt5gio43rcnU1GXqbgSuRZ12uGm1alVEK1U-B2cJBvgYPYXQn-5UuvU0NQS1q16pR02_kLBoFB7cQaCgenwSX9Im2D)  
```

        c. Click on the "Reports" header again, and it expands:
```
![](https://lh5.googleusercontent.com/b7Iz4FlxY29Hsfl2X9bi07EsHW493JcRHaRpzzxz2oDiPW5TAokNmY5SpbailKgIGWJZ7bfI2TNdG6ETwaNBrizhKOftDYNWXovc4yDCE1V7IyIp_gdgRVT_I3s8z80JK3hGHh6v)  
```



    9. Problem: The headers are clickable but the mouse does not show a hand-pointer
       Solution: Create a "clickable" css class and apply it to the nav header
        a. Edit the navbar.component.css by adding a "clickable" class
            
            .clickable {
              cursor: pointer;
            }

        b. Apply the "clickable" class to the navHeader in navbar.component.html
            Change this:
                <!-- Menu Group 1 -->
                <div class='navHeader'  (click)="reportsNavGroupClosed = !reportsNavGroupClosed">
                       <i class="fa fa-file-alt navHeaderIcon"></i>
                       <span class="navHeaderTitle">Reports</span>
                </div>
            
            To this:
                <!-- Menu Group 1 -->
                <div class='navHeader clickable'  (click)="reportsNavGroupClosed = !reportsNavGroupClosed">
                   <i class="fa fa-file-alt navHeaderIcon"></i>
                   <span class="navHeaderTitle">Reports</span>
                </div>

        c. Repeat this for Menu Group 2   (add clickable to your "Analytics" menu group)


    10. Run the debugger
        a. Verify that the nav groups change the mouse icon to a pointer
        b. Place the cursor over "Reports" and "Analytics"
            -- and the cursor should show a clickable hand


    11. Problem:   Opening one nav group should *close* all other nav groups
        Solution:  Create a method called toggleNavGroup()

            toggleNavGroup(1) flips the reportsNavGroupClosed variable *AND* closes all other menu groups
            toggleNavGroup(2) flips the analyticsGroupClosed variable *AND* closes all other menu groups

        a. Edit navbar.component.ts

        b. Add this public method:   toggleNavGroup()
            
            public toggleNavGroup(aNavGroupNumber: number) {
                if (aNavGroupNumber == 1) {
                  // User clicked on the Reports navgroup (so hide the other nav-group)
                  this.analyticsGroupClosed = true;
            
                  // Toggle the Reports navgroup (So, it switches from opened to close)(
                  this.reportsNavGroupClosed = ! this.reportsNavGroupClosed;
                }
                else if (aNavGroupNumber == 2) {
                  // User clicked on the Analytics navgroup (so hide the other nav-group)
                  this.reportsNavGroupClosed = true;
            
                  // Toggle the Analytics navgroup
                  this.analyticsGroupClosed = ! this.analyticsGroupClosed;
                }
            }
            
            When finished, navbar.component.ts looks like this:
            import { Component, OnInit } from '@angular/core';
            
            @Component({
              selector: 'app-navbar',
              templateUrl: './navbar.component.html',
              styleUrls: ['./navbar.component.css']
            })
            export class NavbarComponent implements OnInit {
              public reportsNavGroupClosed: boolean = false;
              public analyticsGroupClosed: boolean = true;
            
              constructor() { }
            
              ngOnInit(): void {
              }
            
              public toggleNavGroup(aNavGroupNumber: number) {
                if (aNavGroupNumber == 1) {
                  // User clicked on the Reports navgroup (so hide the other navgroup)
                  this.analyticsGroupClosed = true;
            
                  // Toggle the Reports navgroup (So, it switches from opened to close)(
                  this.reportsNavGroupClosed = ! this.reportsNavGroupClosed;
                }
                else if (aNavGroupNumber == 2) {
                  // User clicked on the Analytics navgroup (so hide the other navgroups)
                  this.reportsNavGroupClosed = true;
            
                  // Toggle the Analytics navgroup
                  this.analyticsGroupClosed = ! this.analyticsGroupClosed;
                }
              }
            
            }
            

        c. Clicking on the navgroup header should call the toggleNavGroup(1) or toggleNavGroup(2)

            Edit navbar.component.html

            i. Change navgroup 1 from this:
                    <!-- Menu Group 1 -->
                    <div class='navHeader clickable'  (click)="reportsNavGroupClosed =
                !reportsNavGroupClosed">
                           <i class="fa fa-file-alt navHeaderIcon"></i>
                           <span class="navHeaderTitle">Reports</span>
                    </div>
                
                To this:
                    <!-- Menu Group 1 -->
                    <div class='navHeader clickable'  (click)="toggleNavGroup(1)">
                        <i class="fa fa-file-alt navHeaderIcon"></i>
                        <span class="navHeaderTitle">Reports</span>
                    </div>	

            ii. Change navgroup 2 from this:
                    <!-- Menu Group 2 -->
                    <div class='navHeader clickable'   (click)="analyticsGroupClosed =
                !analyticsGroupClosed">
                           <i class="fa fa-file-alt navHeaderIcon"></i>
                           <span class="navHeaderTitle">Analytics</span>
                    </div>
                
                To this:
                    <!-- Menu Group 2 -->
                    <div class='navHeader clickable'   (click)="toggleNavGroup(2)">
                       <i class="fa fa-file-alt navHeaderIcon"></i>
                       <span class="navHeaderTitle">Analytics</span>
                    </div>


    12. Run the debugger
        a. Verify that opening one navgroup closes the other
        b. Click on the "Reports" nav header (and the "Analytics" nav group should close)
        c. Click on the "Analytics" nav header (and the "Reports" nav group should close)



```
