Lesson 20a:  Secure Routes /  Add a Page Guard  (hard-coded)
------------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1E2BzWaOYsauVcXBVt3yjLOtHUhsfty1tkw0MQw-pMts/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson20a/secure-route/add-page-guard
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem:  I want to prevent users from navigating to certain pages<br>
Solution:  Use the Guard and implement CanActivate  (which will take users to the forbidden page if needed)<br>

<br>
<br>
<h3>Approach</h3>

1. Add a PageGuard class that implements CanActivate

1. Protect the page by telling the router to call the PageGuard.canActivate()

1. When a user attempts to visit that page, the router runs the canActivate method

1. The canActivate method checks if the user is authorized

   1. If a user is authorized, then canActivate returns TRUE (and the router proceeds)  
        
   1. Else (user is not authorized) redirect the user to "page/403" instead 
      and return FALSE (so the router does not proceed)



<br>
<br>

```
Procedure
---------
    1. Create the Page Guard  (so it always takes users to the "Forbidden Page"

        a. Create the Page Guard such that it implements the CanActivate interface
           unix> cd ~/intellijProjects/angularApp1/frontend
           unix> ng generate guard guards/page --implements CanActivate  --skipTests

        b. Edit page.guard.ts

        c. Add a public constructor

        d. Inject the router

        e. Adjust the canActivate method so that it uses the router to navigate the user to 'page/403'

        f. Adjust the canActivate method so it returns false (so the router does not route to the original page)




    2. Adjust the "Add Report" page so that it is protected by the Page Guard
        a. Edit app.module.ts

        b. Change the route from this:
              { path: 'page/addReport',	component: AddReportComponent },
            
           To this:
              { path: 'page/addReport',	component: AddReportComponent,  canActivate: [PageGuard] },




    3. Verify that the "Add Report" page is protected
        a. Set a breakpoint in the PageGuard.canActivate() method
        b. Activate the Debugger on "Full WebApp"
        c. Click on "Add Report"
        d. You should reach the breakpoint
           Press F9 to continue
        e. You should see the "Forbidden" page
```
![](https://lh6.googleusercontent.com/S7GK_T4ZrSKZdgp4ciPVCMEP2t93e18BhR2kCEv_CSztIe_MxXKwLHlI1Mfbq33JNICb4-c8F-hyBFwMPIoT5XhTrYK3mrU5OAsdBRbqRStvlQQ_N30X1P37E82x27U1gqei1qM3)
```

        f. Remove the breakpoint from the PageGuard class
        g. Click to navigate to a different page
        h. Then, click back to the "Add Report" page
           -- You should always get the Forbidden page











```
