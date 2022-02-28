Lesson 6c:  Add Navigation Bar 2 / Making NavBar look better
------------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1a9JtP6BJAok6_Xu17cbFE6xLqjToRIGKqqJ1P0YypsE/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson6c/navbar-icons-use-gradients
<br>
<br>






In this lesson, we will build this page:
![](https://lh4.googleusercontent.com/WgbG3nJWELpJ55QhgshvpB87AdhkClv_WUlxTez9PT1sKNAOskslRKCMNxixC6UmJt-UPTnDjTYmFCtE8gz6aKg9XANq0vT2zywyXx6Yq03IsxHU-jI8c2UQZC1g5ORiOugIYy72)  
```
Notes:
    • The Navbar section header -- e.g., Reports -- has a gradient and icon 
    • The Navbar item has a gradient for the highlighted page
    • The Navbar item has a link that allows users to open that page in a new tab/window


Procedure
---------
    1. Add a public boolean called reportsToggled to the NavbarComponent
        a. Edit navbar.components.ts
        b. Add this to it:
             public reportsToggled: boolean = true;


    2. Change the navbar to look more polished 
        a. Replace the navbar.component.css with this:
            
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
            
            .navHeader{
              /* The navHeader has a background gradient that goes to the left */
              background: linear-gradient(to left, #5e6b7b, rgba(94, 107, 123, 0));
              font-family: Verdana, sans-serif;
              font-size: 16px;
              font-weight: bold;
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
              color: #999;
            }


        b. Change the navbar.component.html to this:
            
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
                             <i class="fas fa-external-link-alt navItemIcon" title="Open View
             Reports in a new window"></i>
                         </a>
                       </div>
                     </mat-list-item>
            
                     <!-- Add Report -->
                     <mat-list-item class="navItem" [routerLink]="'page/addReport'">
                       <a title="Add Report">Add Report</a>
                       <div fxFlex fxLayoutAlign="end end">
                         <a [routerLink]="'page/addReport'" target="_blank">
                           <i class="fas fa-external-link-alt navItemIcon" title="Open Add Report in
            a new window"></i>
                         </a>
                       </div>
                     </mat-list-item>
            
                     <!-- Audit History -->
                     <mat-list-item class="navItem" [routerLink]="'page/auditHistory'" >
                       <a title="Audit History">Audit History</a>
                       <div fxFlex fxLayoutAlign="end end">
                         <a [routerLink]="'page/auditHistory'" target="_blank">
                           <i class="fas fa-external-link-alt navItemIcon" title="Open Audit History
            in a new window"></i>
                         </a>
                       </div>
                     </mat-list-item>
                 </div>  <!-- End of navMenuGroup -->
            
                </mat-nav-list>
              </mat-sidenav>
            </mat-sidenav-container>
            

    3. Change the navbar so that the open-in-new-window icon only appears when hovering
        Approach: Set the icon to have the same color as the background 
        When hovering, change the color to be brighter

        Edit navbar.component.css
            The header and navbar background already is set to this: #364150
            So, set the .navItemIcon to have the same color
            
            .navItemIcon {
              color: #364150
            }
            
            .navItemIcon:hover {
              color: #999;
            }
            
            
            When finished, navbar.component.css looks like this:
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
            
            .navHeader{
              /* The navHeader has a background gradient that goes to the left */
              background: linear-gradient(to left, #5e6b7b, rgba(94, 107, 123, 0));
              font-family: Verdana, sans-serif;
              font-size: 16px;
              font-weight: bold;
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
              color: #364150;
            }
            
            .navItemIcon:hover {
              color: #999;
            }


    4. Try it out
        a. Activate the Debugger -> Full WebApp
        b. Look at the main page
        c. Place the cursor over the navigation icons
```
![](https://lh5.googleusercontent.com/1KY1A7XSf8SobjiHTDN0lZv3oQCja0A3UEHBuZ57rVP-Sj01V5Cfcr3wwj1Cmvs6Jt8kgEOY2Q4GUt2Ch_8RU5bW01x0kht0xMwEQBHjBYK_rhlIm8xZM8HlGVlKz2Gz9k1rY797)  
```



    5. Problem: The little icon only appears if you place the pointer over the small icon 
        We need it to work when you hover over the entire navItem
        Solution: When hovering over any part on the navItem, change the color of .navItemIcon
            
            .navItemIcon {
              /* By default, the navItemIcon is invisible (It's same color as the navbar background) */
              color: #364150
            }
            
            .navItem:hover .navItemIcon {
              /* When hovering over navItem change the color of the navItemIcon so it appears */
              color: #999
            }
            
            When finished, the navbar.component.css should look like this:
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
            
            .navHeader{
              /* The navHeader has a background gradient that goes to the left */
              background: linear-gradient(to left, #5e6b7b, rgba(94, 107, 123, 0));
              font-family: Verdana, sans-serif;
              font-size: 16px;
              font-weight: bold;
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
              /* By default, the navItemIcon is invisible (It's same color as the navbar background) */
              color: #364150
            }
            
            .navItem:hover .navItemIcon {
              /* When hovering over navItem change the color of the navItemIcon so it appears */
              color: #999
            }
            
    
    When finished, the navbar.component.html looks like this:
    
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
                <i class="fas fa-external-link-alt navItemIcon" title="Open View
     Reports in a new window"></i>
                </a>
            </div>
            </mat-list-item>
    
            <!-- Add Report -->
            <mat-list-item class="navItem" [routerLink]="'page/addReport'">
            <a title="Add Report">Add Report</a>
            <div fxFlex fxLayoutAlign="end end">
                <a [routerLink]="'page/addReport'" target="_blank">
                <i class="fas fa-external-link-alt navItemIcon" title="Open Add Report in
    a new window"></i>
                </a>
            </div>
            </mat-list-item>
    
            <!-- Audit History -->
            <mat-list-item class="navItem" [routerLink]="'page/auditHistory'" >
            <a title="Audit History">Audit History</a>
            <div fxFlex fxLayoutAlign="end end">
                <a [routerLink]="'page/auditHistory'" target="_blank">
                <i class="fas fa-external-link-alt navItemIcon" title="Open Audit History
    in a new window"></i>
                </a>
            </div>
            </mat-list-item>
        </div>  <!-- End of navMenuGroup -->
    
        </mat-nav-list>
      </mat-sidenav>
    </mat-sidenav-container>

    6. Try it out
        a. Activate the Debugger -> Full WebApp
        b. Look at the main page
        c. Place the cursor over the navigation icons
```
![](https://lh3.googleusercontent.com/-iZuJuwf4Kt44injAHeTAiaZgxFhPhfuUbUr0ymEHkFy_tMAsfe4MzH4zxay4eRVBoXwspU9MTfJqnEZdIgTRvmiVxxTtubZToD6WNJeZK-I9BbWd7V0aEEp-EemCYM279fktMmF)  
```
Now, when you place the mouse anywhere on the left navbar item, the little icon appears







NOTE:  There will be a gap between the navigation bar and the main viewing area
In lesson 6D, we will remove that.  If you want to do that now, here's how:

    7. Remove gap between the left navbar and main viewing area
        a. Edit app.component.html
            Changed the fxLayoutGap="10px" to fxLayoutGap="0"
                <div fxFlex fxLayout="row" fxLayoutGap="0">

            Changed the div for the left-side navigation bar so it has a width of 200px
                <div fxFlex="200px" style="padding: 0"...>

        b. Make sure there are no references to 225px
            Single-click on the frontend/src/app -> Press Control-Shift F
                -- Search everything for 225
                -- You should not see any matches
                -- if you do, change the 225 to 200


```
