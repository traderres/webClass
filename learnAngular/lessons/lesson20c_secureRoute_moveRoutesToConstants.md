Lesson 20c:  Secure Routes / Move Routes to Constants
-----------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1ItHPZNb6f_F9-y5lsaFCY6HedluBR0VBt3XACtK9H6M/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson20c/secure-route/constants
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem:  The route paths are scattered among many files (and are not easy to change)<br>
Solution:  Place all routes in constants.ts<br>

<br>
<br>
<h3>Benefits of Moving Routes to constants</h3>

- Makes it easier to change routes
- Makes it easier to compare route names against allowed route names (see Lesson 20d)
- Avoid page-not-found errors  (that can only be found at runtime as the routes are strings)

NOTE:  This is not required to secure routes, but it is a best practice.  Sometimes, your clients will want specific paths for the routes.  If the path is in one file, then changing it is easy.

<br>
<br>
<h3>Approach</h3>

1. Create an enumerated class to hold routes
1. Replace the hard-coded routes with the constants in app.module.ts, page.guard.ts
1. To use the constants in a component HTML, we must add a "getter" to the component ts class.
   1. Edit navbar.component.ts so it has a getter for constants
   2. Edit navbar.component.html so it uses constants




<br>
<br>

```
Procedure
---------
    1. Create the constants class to hold routes in one place (on the front-end)

        a. Create the constants class  (in the utilities directory)

        b. Change the class so it is an enumerated type and add a few constants
            
            export enum Constants {
              FORBIDDEN_ROUTE       = "page/403",
              ADD_REPORTS_ROUTE     = "page/addReport",
              ADD_REPORTS2_ROUTE    = "page/addReport2",
              VIEW_REPORTS_ROUTE    = "page/viewReports"
            }
            


    2. Change the app.module.ts class to use your constants
        a. Edit app.module.ts

        b. Change the forbidden route to use the new constant:
               
           Change this line from this:
               { path: 'page/403', 	component: ForbiddenComponent },
            
           To this:
              { path: Constants.FORBIDDEN_ROUTE, 	component: ForbiddenComponent },


        c. Change the "Add Report" and "View Reports" path to use constants




    3. Change the left-side navbar to use the constants
       PROBLEM:  The Html Templates cannot access enumerated classes
       SOLUTION:  Add a get property

        a. Edit navbar.component.ts

        b. Add this public getter

              public get constants(): typeof Constants {
                // Get a reference to the enumerated object
                // -- This is needed so that the html page can use the enum class
                return Constants;
              }

        c. Edit navbar.component.html to use the constants

        d. Change the "Add Report" link to use constants by changing [routerLink] to use the constants

           Change this:
               [routerLink]=" 'page/addReport' "
            
           To this:
               [routerLink]="constants.ADD_REPORTS_ROUTE"


        e. Edit user.service.ts

        f. Edit the UserService.getUserInfo() method to use the constants




    4. Verify the web app still works
        a. Activate the Debugger on "Full WebApp"
        b. Click on "Add Report"
           -- Verify that you see the "Add Report" page





    5. Add constants for all hard-coded routes in constant.ts
        a. Edit constants.ts

        b. Add a constant name for every route
           NOTE:  Make sure each name ends with _ROUTE  -- e.g., DASHBOARD_ROUTE

        c. For those routes that have a required field 
                 { path: 'page/longView/:id',  component: LongViewInternalNavReportComponent },


            i.  Add a route for the LONGVIEW_ROUTE to app.module.ts
                     LONGVIEW_ROUTE = "page/longview/",   // NOTE:  The trailing slash is needed


            ii. Change the route in app.module.ts to use hold everything up to the :id
                    { path: Constants.LONG_VIEW_ROUTE + ':id',  component:LongViewInternalNavReportComponent  },




    6. Replace all hard-coded routes through the webapp to use constants 
        a. Single-click on frontend/src/app
        b. Press Control-Shift-F
        c. Search for this:    page/
        d. Press "Open in Find Window"
        e. Use the "Find Window" to quickly find every constant.

           NOTE:  If a hard-coded route is found in an HTML page, then you must add the public getter:

              public get constants(): typeof Constants {
                // Get a reference to the enumerated object
                // -- This is needed so that the html page can use the enum class
                return Constants;
              }


            When finished, the only place that holds routes is constants.ts
            

            Rules to Use when working with constants
            ----------------------------------------
            1) In the html, use constants.VIEW_ALL_REPORTS_ROUTE   (constants has little c)
                WHY?  Because constants is a getter method 
            
            2) In the ts, use Constants.VIEW_ALL_REPORTS_ROUTE       (Constats has a capital C)
            
            3) When replacing routes in app.module.ts, the constant route does *NOT* include the :id




    7. Change the UserService so that all routes are allowed
        a. Edit user.service.ts
        b. Add all routes to the userInfo.pageRoutes


    8. Verify that the webapp uses the new route
        a. Activate the Debugger on "Full WebApp"
        b. Try out some of the routes


    9. Change some of the routes in constants.ts
        a. Change ADD_REPORTS_ROUTE to be "page/reports/add"
        b. Change ADD_REPORTS2_ROUTE to be "page/reports/add2"


    10. Verify that the updated routes are picked-up
        a. Activate the Debugger on "Full WebApp"
        b. Click on the "Add Reports" route 
           -- Verify that the url matches what is in constants.ts



NOTE:  In a real production webapp:  The routes may be in 2 places:
    • The constants.ts
    • A flyway SQL script that relates security roles to routes
      So, if you change constants.ts then you must change the other





```
