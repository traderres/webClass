Lesson 25:  Add a Tab Group  (and Style the Tabs) 
-------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1CpYrpZBRhj6lt-pOaOwnGiZYfqVGqvjzeFpw2A8c32s/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson25/tab-groups1 <br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson25/tab-groups2 <br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson25/tab-groups3 <br> 
. . . <BR>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson25/tab-groups14 <br>
<br>
<br>

<h3> Problem Set </h3>
Problem:  The Angular Material tab group looks pretty lame<br>
Solution:  Use CSS to make them look great<br>

<br>
<br>
In this lesson, we generate 14 different looks for the Angular Material Tab Groups

![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson25_image1.png)

This is Tab Group v14


```

Procedure
---------
    1. Add the MatTabsModule to app.module.ts
       a. Edit app.module.ts

       b. Add MatTabsModule to the imports

       c. Stop and Start the debugger to make sure everything still compiles


    2. Add a Tab Group page
       a. Create the tab group component
          unix> cd ~/intellijProjects/angularApp1/frontend
          unix> ng generate component tab-group --skipTests

       b. Add a constant to constants.ts  (for the route)
            TAB_GROUP_ROUTE          	= "page/reports/tab-group"

       c. Add the route to app.module.ts
            { path: Constants.TAB_GROUP_ROUTE,   component: TabGroupComponent, canActivate: [PageGuard] },


       d. Add the page to the navbar.component.html

              <!-- Tab Group Page -->
              <mat-list-item class="navItem" 
                    [routerLink]="constants.TAB_GROUP_ROUTE" 
                    routerLinkActive="active"
                            *ngIf="userInfo.pageRoutes.get(constants.TAB_GROUP_ROUTE)">
                <a title="Tab Group Page">Tab Group Page</a>
                <div fxFlex fxLayoutAlign="end end" >
                    <a [routerLink]="constants.TAB_GROUP_ROUTE" target="_blank">
                                <i class="fas fa-external-link-alt navItemIcon" title="Open Tab Group Page in a new window"></i>
                    </a>
                </div>
              </mat-list-item>



        e. Add security for that route (so that the roles are authorized to see the page)
            i. Edit R__security.sql

            ii. Add a uicontrol record for the tab group:
                    insert into uicontrols(id, name) values(1019, 'page/reports/tab-group');


            iii. Assign the uicontrols record to the 'admin' role
                    insert into roles_uicontrols(role_id, uicontrol_id) values(1, 1019);


            iv. Assign the uicontrols record to the 'reader' role
                    insert into roles_uicontrols(role_id, uicontrol_id) values(2, 1019);
   

        f. Verify that you can get to the page
            i.  Activate the Debugger on "Full WebApp"
            ii. Click on the "Tab Groups" page  (in the navbar)
                -- You should see an empty page



    3. Format Tab Group 1
       a. Edit tab-group.component.html

       b. Replace its contents with this:
            
            <div class="page-container">
            
              <div fxFlexFill fxLayout="column">
            
                <div fxFlex fxLayout="row" fxLayoutGap="0">
            
                <!-- Left Side of the Top Row -->
                <div fxFlex fxLayoutAlign="left center" fxLayout="row" fxLayoutGap="0">
                    <h1 class="mat-h1">Tab Group Page</h1>
                </div>
            
            
                <!-- Right Side of the Top Row -->
                <div fxFlex fxLayoutAlign="end center">
            
                </div>
            
                </div>  <!-- End of top row -->
            
            
                <!-- Start of the second row -->
                <div fxFlex  fxLayout="column" fxLayoutGap="0">
            
                <mat-card class="mat-elevation-z0" style="padding: 0">
                    <mat-card-content>
            
                    <!-- Setup a wrapper div that uses the entire available height (total height - 165px) -->
                    <div style="height: calc(100vh - 165px)">
            
                        <mat-tab-group class="mat-elevation-z8" mat-align-tabs="start" color="default"
                                    [selectedIndex]=0
                                    [animationDuration]="'250ms'"
                                    [disableRipple]=true >
            
                        <mat-tab label="Enrichment">
                            <!-- 	E N R I C H M E N T 	T A B 	-->
                            <ng-template matTabContent>
                            <div class="tab-content">
            
                                <mat-card class="mat-elevation-z0">
                                <mat-card-title>Enrichment</mat-card-title>
            
                                <mat-card-content style="height: calc(100vh - 245px);">
                                    This is the Enrichment Tab
                                </mat-card-content>
                                </mat-card>
                            </div>
                            </ng-template>
            
                        </mat-tab>
            
                        <mat-tab label="Original Submission">
                            <!-- 	O R I G I N A L 	S U B M I S S I O N 	T A B 	-->
                            <ng-template matTabContent>
                            <div class="tab-content">
                                <mat-card class="mat-elevation-z0">
                                <mat-card-title>User's Original Submission</mat-card-title>
            
                                <mat-card-content style="height: calc(100vh - 245px);">
                                    This is the original submission tab
                                </mat-card-content>
                                </mat-card>
                            </div>
                            </ng-template>
                        </mat-tab>
            
                        <mat-tab label="Documents">
                            <!-- 	D O C U M E N T S 	T A B 	-->
                            <ng-template matTabContent>
                            <div class="tab-content">
                                <mat-card class="mat-elevation-z0">
                                <mat-card-title>Documents & Attachments</mat-card-title>
            
                                <mat-card-content style="height: calc(100vh - 245px);">
                                    This is the documents tab
                                </mat-card-content>
                                </mat-card>
                            </div>
                            </ng-template>
                        </mat-tab>
            
                        <mat-tab label="History">
                            <!-- 	H I S T O R Y 	T A B 	-->
                            <ng-template matTabContent>
                            <div class="tab-content">
                                <mat-card class="mat-elevation-z0">
                                <mat-card-title>History of this Submission</mat-card-title>
            
                                <mat-card-content style="height: calc(100vh - 245px);">
                                    This is the history tab
                                </mat-card-content>
                                </mat-card>
                            </div>
                            </ng-template>
                        </mat-tab>
                        </mat-tab-group>
            
                    </div>
            
                    </mat-card-content>
                </mat-card>
            
                </div> <!-- End of 2nd row -->
            
              </div> <!-- End of Angular flex column -->
            
            </div>  <!-- End of grid container -->
            

        c. Verify that you see Tab Group v1
            i. Activate the Debugger on "Full WebApp"
            ii. Click on "Tab Group"
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson25_image2.png)
```
Tab Group v1:  No CSS
See https://github.com/traderres/angularApp1Lessons/tree/lesson25/tab-groups1
+ We have established a tab group with 4 tabs
+ The tabs fit inside the page 
- The tabs look like shit!  It's all black & white




Tab Group v2:  Add color to the background and selected tab has green vertical gradient 
----------------------------------------------------------------------------------------
    4. Edit tab-group.component.html

    5. Add a background color that matches the primary angular material color (purple)

       Change <mat-tab-group> so it has this:
             backgroundColor="primary"
        
       When finished, the oepning <mat-tab-group> tag looks like this:
        
        <mat-tab-group class="mat-elevation-z8" mat-align-tabs="start" color="default"  
            backgroundColor="primary"
                    [selectedIndex]=0
                    [animationDuration]="'250ms'"
                    [disableRipple]=true>


    6. Edit tab-group.component.css
            (which should be empty)

    7. Replace its contents with this:
            
            :host ::ng-deep .mat-tab-label{
              /* Style for non-active tabs */
              min-width: 60px!important;
              width: 100%;
              color: white;
              font-family: Roboto;
              font-size: 16px;
            }
            
            :host ::ng-deep .mat-tab-group.mat-primary .mat-tab-label:not(.mat-tab-disabled):focus,.mat-tab-group.mat-primary .mat-tab-link:not(.mat-tab-disabled):focus, .mat-tab-nav-bar.mat-primary .mat-tab-label:not(.mat-tab-disabled):focus, .mat-tab-nav-bar.mat-primary .mat-tab-link:not(.mat-tab-disabled):focus{
              /* Style to apply when the user clicks on a tab (focus style) */
            
              background: #233329; /* Old browsers */
              background: -moz-linear-gradient(top,  #233329 0%, #64d473 100%); /* FF3.6-15 */
              background: -webkit-linear-gradient(top,  #233329 0%,#64d473 100%); /* Chrome10-25,Safari5.1-6 */
              background: linear-gradient(to bottom,  #233329 0%,#64d473 100%); /* W3C, IE10+, FF16+,Chrome26+, Opera12+, Safari7+ */
              filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#233329', endColorstr='#64d473',GradientType=0 ); /* IE6-9 */
            }
            
            
            :host ::ng-deep .mat-tab-list .mat-tab-labels .mat-tab-label-active  {
              /* Style to apply on *ACTIVE* tab */
            
              /* Permalink - use to edit and share this gradient: https://colorzilla.com/gradient-editor/#233329+0,64d473+100 */
              background: #233329; /* Old browsers */
              background: -moz-linear-gradient(top,  #233329 0%, #64d473 100%); /* FF3.6-15 */
              background: -webkit-linear-gradient(top,  #233329 0%,#64d473 100%); /* Chrome10-25,Safari5.1-6 */
              background: linear-gradient(to bottom,  #233329 0%,#64d473 100%); /* W3C, IE10+, FF16+, Chrome26+, Opera12+, Safari7+ */
              filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#233329', endColorstr='#64d473',GradientType=0 ); /* IE6-9 */
            
              color: white;
              font-family: Roboto;
              font-size: 16px;
            }
            
            
            :host ::ng-deep .mat-tab-label.mat-tab-label-active:not(.mat-tab-disabled),
            :host ::ng-deep .mat-tab-label.mat-tab-label-active.cdk-keyboard-focused:not(.mat-tab-disabled) {
              /* Set color when tab loses focus */
            
              /* Permalink - use to edit and share this gradient:
            https://colorzilla.com/gradient-editor/#233329+0,64d473+100 */
              background: #233329; /* Old browsers */
              background: -moz-linear-gradient(top,  #233329 0%, #64d473 100%); /* FF3.6-15 */
              background: -webkit-linear-gradient(top,  #233329 0%,#64d473 100%); /* Chrome10-25,Safari5.1-6 */
              background: linear-gradient(to bottom,  #233329 0%,#64d473 100%); /* W3C, IE10+, FF16+, Chrome26+, Opera12+, Safari7+ */
              filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#233329', endColorstr='#64d473',GradientType=0 ); /* IE6-9 */
            
              opacity: 1;
            }



    8. Verify that you see Tab Group v2
        a. Activate the Debugger on "Full WebApp"
        b. Click on "Tab Group"

Tab Group v2:  Using CSS to set active tab with a vertical gradient
See https://github.com/traderres/angularApp1Lessons/tree/lesson25/tab-groups2
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson25_image3.png)
```



Tab Group v3:  Reddish back ground color with green radiant
------------------------------------------------------------
    9.  Edit tab-group.component.html

    10. Edit the <mat-tab-group> tag and remove backgroundColor="primary"

        So, the tag looks like this:

             <mat-tab-group class="mat-elevation-z8" mat-align-tabs="start" color="default"
                        [selectedIndex]=0
                        [animationDuration]="'250ms'"
                        [disableRipple]=true>



    11. Edit tab-group.component.css

    12. Replace the CSS with this:
            
            :host ::ng-deep .mat-tab-label{
              /* label style */
              width: 100%;
              color: white;
              font-family: Roboto;
              font-size: 16px;
            }
            
            
            :host ::ng-deep .mat-tab-group.mat-primary .mat-tab-label:not(.mat-tab-disabled):focus, .mat-tab-group.mat-primary .mat-tab-link:not(.mat-tab-disabled):focus, .mat-tab-nav-bar.mat-primary .mat-tab-label:not(.mat-tab-disabled):focus, .mat-tab-nav-bar.mat-primary .mat-tab-link:not(.mat-tab-disabled):focus{
              /* Style to apply when the user clicks on a tab (focus style) */
              background: #233329; /* Old browsers */
              background: -moz-linear-gradient(top,  #233329 0%, #64d473 100%); /* FF3.6-15 */
              background: -webkit-linear-gradient(top,  #233329 0%,#64d473 100%); /* Chrome10-25,Safari5.1-6 */
              background: linear-gradient(to bottom,  #233329 0%,#64d473 100%); /* W3C, IE10+, FF16+, Chrome26+, Opera12+, Safari7+ */
              filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#233329', endColorstr='#64d473',GradientType=0 ); /* IE6-9 */
            }
            
            
            :host ::ng-deep .mat-tab-list .mat-tab-labels .mat-tab-label-active  {
              /* Permalink - use to edit and share this gradient: https://colorzilla.com/gradient-editor/#233329+0,64d473+100 */
              background: #233329; /* Old browsers */
              background: -moz-linear-gradient(top,  #233329 0%, #64d473 100%); /* FF3.6-15 */
              background: -webkit-linear-gradient(top,  #233329 0%,#64d473 100%); /* Chrome10-25,Safari5.1-6 */
              background: linear-gradient(to bottom,  #233329 0%,#64d473 100%); /* W3C, IE10+, FF16+, Chrome26+, Opera12+, Safari7+ */
              filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#233329', endColorstr='#64d473',GradientType=0 ); /* IE6-9 */
            
              color: white;
              font-family: Roboto;
              font-size: 16px;
            }
            
            
            :host ::ng-deep  .mat-tab-label.mat-tab-label-active {
              /* Set the color for the active tab */
            
              /* Permalink - use to edit and share this gradient: https://colorzilla.com/gradient-editor/#233329+0,64d473+100 */
              background: #233329; /* Old browsers */
              background: -moz-linear-gradient(top,  #233329 0%, #64d473 100%); /* FF3.6-15 */
              background: -webkit-linear-gradient(top,  #233329 0%,#64d473 100%); /* Chrome10-25,Safari5.1-6 */
              background: linear-gradient(to bottom,  #233329 0%,#64d473 100%); /* W3C, IE10+, FF16+, Chrome26+, Opera12+, Safari7+ */
              filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#233329', endColorstr='#64d473',GradientType=0 ); /* IE6-9 */
            }
            
            
            :host ::ng-deep.mat-tab-label.mat-tab-label-active:not(.mat-tab-disabled),
            :host ::ng-deep.mat-tab-label.mat-tab-label-active.cdk-keyboard-focused:not(.mat-tab-disabled) {
              /* Set color when tab loses focus */
            
              /* Permalink - use to edit and share this gradient: https://colorzilla.com/gradient-editor/#233329+0,64d473+100 */
              background: #233329; /* Old browsers */
              background: -moz-linear-gradient(top,  #233329 0%, #64d473 100%); /* FF3.6-15 */
              background: -webkit-linear-gradient(top,  #233329 0%,#64d473 100%); /* Chrome10-25,Safari5.1-6 */
              background: linear-gradient(to bottom,  #233329 0%,#64d473 100%); /* W3C, IE10+, FF16+, Chrome26+, Opera12+, Safari7+ */
              filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#233329', endColorstr='#64d473',GradientType=0 ); /* IE6-9 */
            
              opacity: 1;
            }
            
            
            :host ::ng-deep .mat-tab-header{
              /* Set the default background color of the header */
              background-color: #233329;
            }
            


    13. Verify that you see Tab Group v3
        a. Activate the Debugger on "Full WebApp"
        b. Click on "Tab Group"
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson25_image4.png)
```
Tab Group v3:  Changed the background color to red
See https://github.com/traderres/angularApp1Lessons/tree/lesson25/tab-groups3




Tab Group v4:  Orange-to-Yellow gradient for the active tab w/Open Sans font
-----------------------------------------------------------------------------
    14. Use the steps in lesson 15a to add the Google Font called Opens Sans (regular, 500, 600, 700)


    15. Edit tab-group.component.css

    16. Replace its contents with this:

:host ::ng-deep .mat-tab-label{
  width: 100%;
  color: white;

  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 600;
  font-size: 17px;
}


:host ::ng-deep .mat-tab-group.mat-primary .mat-tab-label:not(.mat-tab-disabled):focus, .mat-tab-group.mat-primary .mat-tab-link:not(.mat-tab-disabled):focus, .mat-tab-nav-bar.mat-primary .mat-tab-label:not(.mat-tab-disabled):focus, .mat-tab-nav-bar.mat-primary .mat-tab-link:not(.mat-tab-disabled):focus {
  background-color: #f5d020;
  background-image: linear-gradient(315deg, #f53803 0%, #f5d020 74%);
}


:host ::ng-deep .mat-tab-list .mat-tab-labels .mat-tab-label-active  {
  background-color: #f5d020;
  background-image: linear-gradient(315deg, #f53803 0%, #f5d020 74%);
  color: white;
}


:host ::ng-deep  .mat-tab-label.mat-tab-label-active {
  background-color: #f5d020;
  background-image: linear-gradient(315deg, #f53803 0%, #f5d020 74%);
}


:host ::ng-deep.mat-tab-label.mat-tab-label-active:not(.mat-tab-disabled),
:host ::ng-deep.mat-tab-label.mat-tab-label-active.cdk-keyboard-focused:not(.mat-tab-disabled) {
  /* Set color when tab loses focus */
  background-color: #f5d020;
  background-image: linear-gradient(315deg, #f53803 0%, #f5d020 74%);

  opacity: 1;
}

:host ::ng-deep .mat-tab-header{
  /* Set the default background color of the header */
  background-color: #233329;
}



    17. Verify that you see Tab Group v4
        a. Activate the Debugger on "Full WebApp"
        b. Click on "Tab Group"
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson25_image5.png)
```
Tab Group v4:  Added "Open Sans" font and activate tab has yellow-to-orange gradient
See https://github.com/traderres/angularApp1Lessons/tree/lesson25/tab-groups4




Tab Group v5:  Round off the edges of the selected tab
--------------------------------------------------------
    18. Edit tab-group.component.css

    19. Replace its contents with this:

:host ::ng-deep .mat-tab-label{
  /* label style */
  width: 100%;
  color: white;

  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 600;
  font-size: 17px;
}


:host ::ng-deep.mat-tab-label.mat-tab-label-active:not(.mat-tab-disabled),
:host ::ng-deep.mat-tab-label.mat-tab-label-active.cdk-keyboard-focused:not(.mat-tab-disabled) {
  /* Set color when tab loses focus */
  background-color: #63d471;
  background-image: linear-gradient(315deg, #63d471 0%, #233329 100%);
  opacity: 1;
}


:host ::ng-deep .mat-tab-header{
  /* Set the default background color of the header */
  background-color: #233329;
}


:host ::ng-deep .mat-tab-header, .mat-tab-nav-bar {
  border-bottom: 0;
}


:host ::ng-deep .mat-tab-label.mat-tab-label-active {
  /* Styles for the active tab label */
  border: 1px solid #63d471;
  box-sizing: border-box;
  border-radius: 20px;
}



    20. Verify that you see Tab Group v5
        a. Activate the Debugger on "Full WebApp"
        b. Click on "Tab Group"
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson25_image6.png)
```
Tab Group v5:  Selected Tab has border-radius of 20px (giving it the rounded edges)
See https://github.com/traderres/angularApp1Lessons/tree/lesson25/tab-groups5





Tab Group v6:  Selected Tab has gradient, is rounded, and has a thick gold border
---------------------------------------------------------------------------------
    21. Edit tab-group.component.css

    22. Replace its contents with this:

:host ::ng-deep .mat-tab-label{
  /* label style */
  min-width: 175px !important;
  color: white;

  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 700;
  font-size: 17px;
  margin: 5px;
}

:host ::ng-deep .mat-tab-list .mat-tab-labels .mat-tab-label-active  {
  color: white;
}

:host ::ng-deep .mat-tab-label.mat-tab-label-active:not(.mat-tab-disabled),
:host ::ng-deep .mat-tab-label.mat-tab-label-active.cdk-keyboard-focused:not(.mat-tab-disabled) {
  /* Set color when tab loses focus */
  background: linear-gradient(to bottom right, #679ad1 25%, #015eae 84%);
  opacity: 1;
}

:host ::ng-deep .mat-tab-header{
  /* Set the default background color of the header */
  background-color: #679ad1;
}

:host ::ng-deep .mat-tab-header, .mat-tab-nav-bar {
  border-bottom: 0;
}

:host ::ng-deep .mat-tab-label.mat-tab-label-active {
  /* Styles for the active tab label */
  border: 3px solid #c0da00;
  box-sizing: border-box;
  border-radius: 20px;
}

    23. Verify that you see Tab Group v6
        a. Activate the Debugger on "Full WebApp"
        b. Click on "Tab Group"
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson25_image7.png)
```
Tab Group v6:  Selected Tab has gradient, is rounded, and has a thick gold border
See https://github.com/traderres/angularApp1Lessons/tree/lesson25/tab-groups6




Tab Group v7:  Selected Tab has gradient, is rounded, and has a thick gold border w/dark background
---------------------------------------------------------------------------------------------------
    24. Edit tab-group.component.css

    25. Replace its contents with this

:host ::ng-deep .mat-tab-label{
  /* label style */
  min-width: 175px !important;
  color: white;

  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 700;
  font-size: 17px;
  margin: 5px;
}


:host ::ng-deep .mat-tab-list .mat-tab-labels .mat-tab-label-active  {
  color: white;
}


:host ::ng-deep .mat-tab-label.mat-tab-label-active:not(.mat-tab-disabled),
:host ::ng-deep .mat-tab-label.mat-tab-label-active.cdk-keyboard-focused:not(.mat-tab-disabled) {
  /* Set color when tab loses focus */
  background-color: #2a2a72;
  background-image: linear-gradient(315deg, #009ffd 0%, #2a2a72 74%);

  opacity: 1;
}


:host ::ng-deep .mat-tab-header{
  /* Set the default background color of the header */
  background-color: #2a2a72;
}


:host  ::ng-deep .mat-tab-header, .mat-tab-nav-bar {
  border-bottom: 0;
}


:host ::ng-deep .mat-tab-label.mat-tab-label-active {
  /* Styles for the active tab label */
  border: 3px solid #c0da00;
  box-sizing: border-box;
  border-radius: 20px;
}



    26. Verify that you see Tab Group v7
        a. Activate the Debugger on "Full WebApp"
        b. Click on "Tab Group"
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson25_image8.png)
```
Tab Group v7:  Selected Tab has gradient, is rounded, and has a thick gold border
See https://github.com/traderres/angularApp1Lessons/tree/lesson25/tab-groups7




Tab Group v8:  Selected Tab has multi-color gradient w/o border
----------------------------------------------------------------
    27. Edit tab-group.component.css

    28. Replace its contents with this

:host ::ng-deep .mat-tab-label{
  /* label style */
  min-width: 175px !important;
  color: white;

  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 700;
  font-size: 17px;
  margin: 5px;
}


:host ::ng-deep .mat-tab-list .mat-tab-labels .mat-tab-label-active  {
  color: white;
}


:host ::ng-deep .mat-tab-label.mat-tab-label-active:not(.mat-tab-disabled),
:host ::ng-deep .mat-tab-label.mat-tab-label-active.cdk-keyboard-focused:not(.mat-tab-disabled) {
  /* Set color when tab loses focus */
  background-color: #2a2a72;
  background-image: linear-gradient(315deg, #009ffd 0%, #2a2a72 74%, #f1ca0a 98%);

  opacity: 1;
}


:host ::ng-deep .mat-tab-header{
  /* Set the default background color of the header */
  background-color: #2a2a72;
}


:host ::ng-deep .mat-tab-header, .mat-tab-nav-bar {
  border-bottom: 0;
}


:host ::ng-deep .mat-tab-label.mat-tab-label-active {
  /* Styles for the active tab label */
  border: 0;
  box-sizing: border-box;
  border-radius: 20px;
}







    29. Verify that you see Tab Group v8
        a. Activate the Debugger on "Full WebApp"
        b. Click on "Tab Group"
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson25_image9.png)
```
Tab Group v8:  Selected Tab has a multi-color gradient, is rounded, and w/o a border
See https://github.com/traderres/angularApp1Lessons/tree/lesson25/tab-groups8






Tab Group v9:  Selected Tab has multi-color gradient (richer colors diagonal going other way)
---------------------------------------------------------------------------------------------
    30. Edit tab-group.component.css

    31. Replace its contents with this:

:host ::ng-deep .mat-tab-label{
  /* label style */
  min-width: 175px !important;
  color: white;

  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 700;
  font-size: 17px;
  margin: 5px;
}


:host ::ng-deep .mat-tab-list .mat-tab-labels .mat-tab-label-active  {
  color: white;
}


:host ::ng-deep .mat-tab-label.mat-tab-label-active:not(.mat-tab-disabled),
:host ::ng-deep .mat-tab-label.mat-tab-label-active.cdk-keyboard-focused:not(.mat-tab-disabled) {
  /* Set color when tab loses focus */
  background-color: #2a2a72;
  background-image: linear-gradient(45deg, #009ffd 5%, #2a2a72 54%, #f1ca0a 98%);
  opacity: 1;
}

:host ::ng-deep .mat-tab-header{
  /* Set the default background color of the header */
  background-color: #2a2a72;
}


:host ::ng-deep .mat-tab-header, .mat-tab-nav-bar {
  border-bottom: 0;
}


:host ::ng-deep .mat-tab-label.mat-tab-label-active {
  /* Styles for the active tab label */
  border: 0;
  box-sizing: border-box;
  border-radius: 20px;
}





    32. Verify that you see Tab Group v9
        a. Activate the Debugger on "Full WebApp"
        b. Click on "Tab Group"
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson25_image10.png)
```
Tab Group v9:  Selected Tab has a multi-color gradient (richer colors diagonal going other way)
See https://github.com/traderres/angularApp1Lessons/tree/lesson25/tab-groups9




Tab Group v10:  Selected Tab has a radial gradient
---------------------------------------------------
    33. Edit tab-group.component.css

    34. Replace its contents with this:

:host ::ng-deep .mat-tab-label{
  /* label style */
  min-width: 175px !important;
  color: white;

  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 700;
  font-size: 17px;
  margin: 5px;
}


:host ::ng-deep .mat-tab-list .mat-tab-labels .mat-tab-label-active  {
  color: white;
}


:host ::ng-deep .mat-tab-label.mat-tab-label-active:not(.mat-tab-disabled),
:host ::ng-deep .mat-tab-label.mat-tab-label-active.cdk-keyboard-focused:not(.mat-tab-disabled) {
  /* Set color when tab loses focus */
  background: radial-gradient(closest-side, #000000 0%,  #2a2a72 50%, #009ffd 100%);
  opacity: 1;
}


:host ::ng-deep .mat-tab-header{
  /* Set the default background color of the header */
  background-color: #2a2a72;
}


:host ::ng-deep .mat-tab-header, .mat-tab-nav-bar {
  border-bottom: 0;
}


:host ::ng-deep .mat-tab-label.mat-tab-label-active {
  /* Styles for the active tab label */
  border: 0;
  box-sizing: border-box;
  border-radius: 20px;
}






    35. Verify that you see Tab Group v10
        a. Activate the Debugger on "Full WebApp"
        b. Click on "Tab Group"
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson25_image11.png)
```
Tab Group v10:  Selected Tab has a radial gradient
See https://github.com/traderres/angularApp1Lessons/tree/lesson25/tab-groups10




Tab Group v11:  Selected Tab has a sharp-edge gradient
-------------------------------------------------------
    36. Edit tab-group.component.css

    37. Replace its contents with this:

:host ::ng-deep .mat-tab-label{
  /* label style */
  width: 100%;
  color: white;

  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 600;
  font-size: 17px;
}


:host ::ng-deep .mat-tab-list .mat-tab-labels .mat-tab-label-active  {
  color: white;
}


:host ::ng-deep.mat-tab-label.mat-tab-label-active:not(.mat-tab-disabled),
:host ::ng-deep.mat-tab-label.mat-tab-label-active.cdk-keyboard-focused:not(.mat-tab-disabled) {
  /* Set color when tab loses focus */
  background: linear-gradient(315deg, #2a2a72 25%, #f1ca0a 0%, #2a2a72 74%);
  opacity: 1;
}


:host ::ng-deep .mat-tab-header{
  /* Set the default background color of the header */
  background-color: #2a2a72;
}









    38. Verify that you see Tab Group v11
        a. Activate the Debugger on "Full WebApp"
        b. Click on "Tab Group"
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson25_image12.png)
```
Tab Group v11:  Selected Tab has a sharp-edge gradient
See https://github.com/traderres/angularApp1Lessons/tree/lesson25/tab-groups11





Tab Group v12:  Selected Tab has a diagonal gradient with light-colored edges
------------------------------------------------------------------------------
    39. Edit tab-group.component.css

    40. Replace its contents with this:

:host ::ng-deep .mat-tab-label{
  /* label style */
  color: white;
  width: 100%;

  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 700;
  font-size: 17px;
  margin: 5px;
}


:host ::ng-deep .mat-tab-list .mat-tab-labels .mat-tab-label-active  {
  color: white;
}

:host ::ng-deep .mat-tab-label.mat-tab-label-active:not(.mat-tab-disabled),
:host ::ng-deep .mat-tab-label.mat-tab-label-active.cdk-keyboard-focused:not(.mat-tab-disabled) {
  /* Set color when tab loses focus */

  /* Permalink - use to edit and share this gradient:
https://colorzilla.com/gradient-editor/#2a2a72+20,f1ca0a+22,f1ca0a+22,1876ab+24,2a2a72+47,2a2a72+53,1876ab+75,f1ca0a+76,2a2a72+80 */
  background: #2a2a72; /* Old browsers */
  background: -moz-linear-gradient(-45deg,  #2a2a72 20%, #f1ca0a 22%, #f1ca0a 22%, #1876ab 24%, #2a2a72 47%, #2a2a72 53%, #1876ab 75%, #f1ca0a 76%, #2a2a72 80%); /* FF3.6-15 */
  background: -webkit-linear-gradient(-45deg,  #2a2a72 20%,#f1ca0a 22%,#f1ca0a 22%,#1876ab 24%,#2a2a72 47%,#2a2a72 53%,#1876ab 75%,#f1ca0a 76%,#2a2a72 80%); /* Chrome10-25,Safari5.1-6 */
  background: linear-gradient(135deg,  #2a2a72 20%,#f1ca0a 22%,#f1ca0a 22%,#1876ab 24%,#2a2a72 47%,#2a2a72 53%,#1876ab 75%,#f1ca0a 76%,#2a2a72 80%); /* W3C, IE10+, FF16+, Chrome26+, Opera12+, Safari7+ */
  filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#2a2a72', endColorstr='#2a2a72',GradientType=1 ); /* IE6-9 fallback on horizontal gradient */

  opacity: 1;
}


:host ::ng-deep .mat-tab-header{
  /* Set the default background color of the header */
  background-color: #2a2a72;
}


:host ::ng-deep .mat-tab-header, .mat-tab-nav-bar {
  border-bottom: 0;
}


:host ::ng-deep .mat-tab-label.mat-tab-label-active {
  /* Styles for the active tab label */
  border: 0;
}


    41. Verify that you see Tab Group v12
        a. Activate the Debugger on "Full WebApp"
        b. Click on "Tab Group"
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson25_image13.png)
```
Tab Group v12:  Selected Tab has a sharp-edge gradient
See https://github.com/traderres/angularApp1Lessons/tree/lesson25/tab-groups12



Tab Group v13:  Selected Tab has a diagonal gradient with light-colored edges w/o bottom padding
-------------------------------------------------------------------------------------------------
    42. Edit tab-group.component.css

    43. Replace its contents with this:

:host ::ng-deep .mat-tab-label{
  /* label style */
  color: white;
  width: 100%;

  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 700;
  font-size: 17px;
}


:host ::ng-deep .mat-tab-list .mat-tab-labels .mat-tab-label-active  {
  color: white;
}


:host ::ng-deep .mat-tab-label.mat-tab-label-active:not(.mat-tab-disabled),
:host ::ng-deep .mat-tab-label.mat-tab-label-active.cdk-keyboard-focused:not(.mat-tab-disabled) {
  /* Set color when tab loses focus */

  /* Permalink - use to edit and share this gradient: https://colorzilla.com/gradient-editor/#2a2a72+21,f1ca0a+22,f1ca0a+22,1876ab+24,2a2a72+47,2a2a72+53,1876ab+75,f1ca0a+76,2a2a72+78 */
  background: #2a2a72; /* Old browsers */
  background: -moz-linear-gradient(-45deg,  #2a2a72 21%, #f1ca0a 22%, #f1ca0a 22%, #1876ab 24%, #2a2a72 47%, #2a2a72 53%, #1876ab 75%, #f1ca0a 76%, #2a2a72 78%); /* FF3.6-15 */
  background: -webkit-linear-gradient(-45deg,  #2a2a72 21%,#f1ca0a 22%,#f1ca0a 22%,#1876ab 24%,#2a2a72 47%,#2a2a72 53%,#1876ab 75%,#f1ca0a 76%,#2a2a72 78%); /* Chrome10-25,Safari5.1-6 */
  background: linear-gradient(135deg,  #2a2a72 21%,#f1ca0a 22%,#f1ca0a 22%,#1876ab 24%,#2a2a72 47%,#2a2a72 53%,#1876ab 75%,#f1ca0a 76%,#2a2a72 78%); /* W3C, IE10+, FF16+, Chrome26+, Opera12+, Safari7+ */
  filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#2a2a72', endColorstr='#2a2a72',GradientType=1 ); /* IE6-9 fallback on horizontal gradient */

  opacity: 1;
}


:host ::ng-deep .mat-tab-header{
  /* Set the default background color of the header */
  background-color: #2a2a72;
}


:host ::ng-deep .mat-tab-header, .mat-tab-nav-bar {
  border-bottom: 0;
}


:host ::ng-deep .mat-tab-label.mat-tab-label-active {
  /* Styles for the active tab label */
  border: 0;
}


    44. Verify that you see Tab Group v13
        a. Activate the Debugger on "Full WebApp"
        b. Click on "Tab Group"
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson25_image14.png)
```
Tab Group v13:  Selected Tab has a sharp-edge gradient
See https://github.com/traderres/angularApp1Lessons/tree/lesson25/tab-groups13



Tab Group v14:  v8 with gold hover effect
-----------------------------------------
    45. Edit tab-group.component.css

    46. Replace its contents with this

:host ::ng-deep .mat-tab-label{
  /* label style */
  min-width: 175px !important;
  color: white;

  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 700;
  font-size: 17px;

  margin: 5px;
}


:host ::ng-deep .mat-tab-list .mat-tab-labels .mat-tab-label-active  {
  color: white;
}


:host ::ng-deep .mat-tab-label.mat-tab-label-active:not(.mat-tab-disabled),
:host ::ng-deep .mat-tab-label.mat-tab-label-active.cdk-keyboard-focused:not(.mat-tab-disabled) {
  /* Set color when tab loses focus */
  background-color: #2a2a72;
  background-image: linear-gradient(315deg, #009ffd 0%, #2a2a72 77%, #f1ca0a 98%);

  opacity: 1;
}


:host ::ng-deep .mat-tab-header{
  /* Set the default background color of the header */
  background-color: #2a2a72;
}


:host ::ng-deep .mat-tab-header, .mat-tab-nav-bar {
  border-bottom: 0;
}


:host ::ng-deep .mat-tab-label {
  /* Set a border of 2px that has the same color as the background on all labels 	*/
  /* NOTE:  This is needed because on hover, we are going to change the border color */
  border: 2px solid #2a2a72;
  box-sizing: border-box;
  border-radius: 20px;
}


:host ::ng-deep  .mat-tab-label:hover:not(.mat-tab-label-active) {
  /* Show a gold border when the user hovers over an Inactive tab                              	*/
  /* NOTE:  The border should already exist otherwise the tabs will bump a little and it looks bad */
  border-color: #c0da00;
  opacity: 1 !important;   	/* The opacity is reduced for inactive tabs by default */
}





    47. Verify that you see Tab Group v14
        a. Activate the Debugger on "Full WebApp"
        b. Click on "Tab Group"
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson25_image15.png)
```
Tab Group v14:  Similar to v8 but when hovering over tabs, a gold border appears
See https://github.com/traderres/angularApp1Lessons/tree/lesson25/tab-groups14



```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson25_image16.png)
```
Tab Group v14:  On hover, the other tabs show a thin gold border


```
