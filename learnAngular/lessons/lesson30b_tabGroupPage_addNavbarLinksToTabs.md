Lesson 30b: Tab Group Page / Add Navbar Links to Different Tabs
---------------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1JC-tuZWVZNw29D72GsxnCc0E7uOOyaKCL5yAuYSuiQ0/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson30b/tab-group/nav-link-to-tab
<br>
<br>
<br>

<h3> Problem Set </h3>

```
Problem:  I want 2 different navbar links that take users to the *SAME* page but show *DIFFERENT* tabs
    Create a navbar link called "All Reports" that takes user to this page (showing "All Reports" tab) 
    Create a navbar link called "Critical Reports" that takes user to this page (showing "Critical Reports" tab)
     
    page/reports/grid-tab-group/1   -> Open tab group page and show tab group 1 
    page/reports/grid-tab-group/2   --> Open tab group page and show tab group 2



Problem:   How do I get the router to refresh the page (when the user is ALREADY on that page)?
    Consider this case:
    1) The user clicks on the "All Reports" nav link  (which opens the tab group page)
    2) The user clicks on the "Critical Reports" nav link   
    -- But, the router will NOT refresh the page as you are ALREADY on that page.

Solution:  Do *NOT* refresh the page.  
    Instead, have the destination page listen for router param changes
    If a router param change is detected, then change the tab group's selectedIndex




Procedure
---------
    1. Change the path in uicontrols
       a. Edit R__security.sql

       b. Change this record:
	        insert into uicontrols(id, name) values(1025, 'page/reports/grid-tab-group/);

          To this:
            insert into uicontrols(id, name) values(1025, 'page/reports/grid-tab-group/:startingTab');



    2. Change the route so that it has a required parameter called startingTab
       a. Edit app.module.ts

       b. Change this route
             { path: Constants.GRID_TAB_GROUP_ROUTE,   component: GridTabGroupPageComponent, canActivate: [PageGuard] },

          To this:
             { path: Constants.GRID_TAB_GROUP_ROUTE + ':startingTab',   component: GridTabGroupPageComponent, canActivate: [PageGuard] },



    3. Change the grid route so it ends with a slash
       a. Edit constants.ts

       b. Change this constant
              GRID_TAB_GROUP_ROUTE     	= "page/reports/grid-tab-group",   
            
          To this:
              GRID_TAB_GROUP_ROUTE     	= "page/reports/grid-tab-group/",   // This route has a required startingTab so it must end with a slash



    4. Change the navigation links
       NOTE:  The routerLink parameter is changed to this:  
                	[routerLink]="[constants.GRID_TAB_GROUP_ROUTE, 2]" 
	 
            -- The first element in this array is the path
	        -- The 2nd element is the passed-in route param


       a. Edit navbar.component.html

       b. Remove the old like to the Grid Tab Group Page

       c. Add these 2 links:
    
            <!-- Grid Tab Group / Critical Reports Tab -->
            <mat-list-item class="navItem"  [routerLink]="[constants.GRID_TAB_GROUP_ROUTE, 1]" routerLinkActive="active"  [routerLinkActiveOptions]="{exact: true}"
                            *ngIf="userInfo.pageRoutes.get(constants.GRID_TAB_GROUP_ROUTE + ':startingTab')">
                <a title="Critical Reports">Critical Reports</a>
                <div fxFlex fxLayoutAlign="end end" >
                <a [routerLink]="[constants.GRID_TAB_GROUP_ROUTE, 1]" target="_blank">
                    <i class="fas fa-external-link-alt navItemIcon" title="Open Critical Reports in a new window"></i>
                </a>
                </div>
            </mat-list-item>
    
    
            <!-- Grid Tab Group / All Reports Tab -->
            <mat-list-item class="navItem"  [routerLink]="[constants.GRID_TAB_GROUP_ROUTE, 2]" routerLinkActive="active"  [routerLinkActiveOptions]="{exact: true}"
                            *ngIf="userInfo.pageRoutes.get(constants.GRID_TAB_GROUP_ROUTE + ':startingTab')">
                <a title="All Reports">All Reports</a>
                <div fxFlex fxLayoutAlign="end end" >
                <a [routerLink]="[constants.GRID_TAB_GROUP_ROUTE, 2]" target="_blank">
                    <i class="fas fa-external-link-alt navItemIcon" title="Open All Reports in a new window"></i>
                </a>
                </div>
            </mat-list-item>


    5. Change the page to listen for route parameter changes
       a. Edit grid-tab-group-page.component.ts

       b. Change the class so it implements OnInit, OnDestroy

       c. Add these 2 class variables:
            public startingTabIndex: number;
            private paramRouteSubscription: Subscription


       d. Inject the activatedRoute

       e. Change ngOnInit() to this:
            
              public ngOnInit(): void {
                // Solution:  Listen for parameter changes and then adjust the page in code
                this.paramRouteSubscription = this.activatedRoute.params.subscribe(routeParams => {
                    // We got a new parameter -- so either the page is opening or need to refresh
            
                    let startingTabNumber: string | null = routeParams?.startingTab;
            
                    if (! isNumeric(startingTabNumber))  {
                    // The passed-in startingTab is not numeric
                    // -- So, go with the default starting tabIndex of zero
                    this.startingTabIndex = 0;
                    }
                    else {
                    let startingTabAsNumber = Number(startingTabNumber);
            
                    if ((startingTabAsNumber < 1) || (startingTabAsNumber > 2)) {
                        // The passed-in startingTab is not valid.
                        // -- So, go with the default starting tabIndex of zero
                        this.startingTabIndex = 0;
                    }
                    else {
                        // The passed-in startingTab is valid
                        this.startingTabIndex = startingTabAsNumber - 1;
                    }
                    }
                });
                 
              }  // end of ngOnInit()
            


       f. Add the ngOnDestroy method:

          public ngOnDestroy(): void {
            if (this.paramRouteSubscription) {
            this.paramRouteSubscription.unsubscribe();
            }
          }



    6. Edit grid-tab-group-page page so it changes the visible tab index
       a. Edit grid-tab-group-page.component.html

       b. Change the tab group from this:
            <mat-tab-group animationDuration="0ms" [selectedIndex]=0 >
        
          To this:
            <mat-tab-group animationDuration="0ms" [selectedIndex]=this.startingTabIndex >
        


    7. Verify that the "Critical Reports" and "All Reports" links work as expected
       a. Activate the debugger on Full WebApp
       b. Click on "Critical Reports" in the navbar  (and the "Critical Reports" tab should be visible)
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson30b_image1.png)
```



       c. Click on "All Reports" in the navbar (and the "All Reports" tab should be visible)
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson30b_image2.png)

