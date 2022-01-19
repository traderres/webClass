Lesson X: TITLE
-------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1KEeZd9Psakev1mKMlUh500k_Zz1mWt-YhMd4jgzkTqM/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson20d/secure-route/hide-navbar-options
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem:  The webapp shows navbar options that are restricted<br>
Solution:  Have the navbar html template check if the route is found in the pageRoutes map.<br>


<br>
<br>
<h3>Approach</h3>

1. Change the navbar.component.ts page so it has a public observable to the UserInfoDTO

   1. Inject the UserService
   1. Add a public observable userInfoObs
   1. In the ngOnInit(), initialize the observable to getUserInfo  

1. Add an async pipe to the html page (so the html page has the map of page routes)  
   Add \*ngIf statements that check if the route is found in the map.  
   NOTE: If the route is not found in the map, then it is not visible in the navbar


<br>
<br>

```
Procedure
---------
    1. Change the navbar.component.ts page so it has a public observable to the UserInfoDTO
        a. Edit navbar.component.ts

        b. Inject the UserService

        c. Add a public variable called userInfoObs that is an Observable holding a UserInfoDTO object

        d. Modify the ngOnInit() so that it initialize the userInfoObj object by calling the UserService


    2. Add an async pipe to the HTML page that holds the UserInfoDTO object pageRoutes map
        a. Edit navbar.component.html

        b. Add an async pipe using <ng-container> and *ngIf
           NOTE:  We want to call the variable userInfo


    3. Use the userInfo variable in the HTML and check the map
        a. Edit navbar.component.html

        b. Change the "View Reports" mat-list-item tag by adding an *ngIf

               *ngIf="userInfo.pageRoutes.get(constants.VIEW_REPORTS_ROUTE)"

            If the route is not found in the pageRoutes, then the mat-list-item is not created
            If the route is found in the pageRoutes, then the mat-list-item is created
            
            NOTE:  Make sure your async-pipe is inside the div that sets the width of the navbar


    4. Verify that the "View Reports" navbar option disappears if not authorized
        a. Edit the user.service.ts
        b. Change the userInfo.pageRoutes so that VIEW_REPORTS_ROUTE has false next to it
        c. Activate the Debugger on "Full WebApp"
           -- Verify that "View Reports" navbar option is not present
```
![](https://lh4.googleusercontent.com/wRBV-1TlGeScqV6YK6tz7UcYcmy-aibj9MFbYk2fC7nDJfTBGm8Q1-fOhlZD0wWDT9sY04y8z5TCKOJDkcFifOFEvUFTKawNC8dOUYo9_g_ZyyA4aw9C2SJHUeHXS8nZ5SbExLY4)
```
The "Verify Reports" navbar option is not visible




        d. Attempt to manually navigating to the "VIEW_REPORTS_ROUTE"
           NOTE:  In my webapp, the "View Reports" page is linked to "page/viewReports"
           -- So, go to http://localhost:4200/page/viewReports

        e. Verify that you see the "Forbidden" page
```
![](https://lh5.googleusercontent.com/2XP3wBKjPFqd3WHp8B1N9NJG1yJ5HxBAY6O2x4s2s3PUK6r4gIP0j_lPLVd5EldfZPtB4cyPXct2lsucoC7eyGrUWWx_2J1NP6yiESBlOdJm05IcfKtiUX1Fuk4I6L8XmZcPfbcG)
```



    5. Add the security check for all navbar options in the left-side navbar
        a. Edit navbar.component.html

        b. Adjust the <mat-list-item> tags by adding *ngIf statements that check the map


    6. Verify that the checks work
        a. Edit the user.service.ts
        b. Adjust the map of page routes
        c. Verify that the navbar options appear/disappear



    7. Change the navbar.component.html page so that the "Reports" section headers appear/disappear
       (if the user is not authorized to any of the "Reports" menu items)
        a. Edit navbar.component.html

        b. We want to hide the "Reports" menu group if the user is not authorized to see any of the 6 reports navbar items





    8. Repeat the entire process for the right-side navbar
        a. Edit user-navbar.component.ts
            i. Inject the UserService
            ii. Add a public observable
            iii. Edit the ngOnInit() so it initializes the public observable

        b. Edit user-navbar.component.html
            i. Add an async-pipe that uses the observable
            ii. Add *ngIf calls on the <mat-list-item> tags to make sure the route is found in the pageRoutes


        NOTE:  Make sure your async-pipe is inside the div that sets the width of the navbar

```
