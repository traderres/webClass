Lesson 20g:  Secure Routes /  Invoke REST Call
----------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1VXMivk5XRsJ714CzTwJ1k5KBXPha1UtNVRm2cCyK8eI/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson20g/secure-route/invoke-rest-call
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem:  The front-end needs the accessMap and name<br>
Solution:  Change the user.service.ts to invoke a the REST endpoint and  return an observable (holding info) <br>
           GET /api/user/me




<br>
<br>

```

Procedure
---------
    1. Change the front-end user.service.ts to invoke the real REST endpoint
        a. Edit user.service.ts

        b. Inject the httpClient

        c. Replace the getUserInfo() with this:
            
              /*
               * Return an observable that holds information about the user
               * -- The UserInfoDTO holds the user's name and map of routes
               */
              public getUserInfo(): Observable<UserInfoDTO> {
            
                // Construct the URL of the REST call
                const restUrl = environment.baseUrl + '/api/user/me';
            
                // Return an observable
                return this.httpClient.get <UserInfoDTO>(restUrl);
              }

            But, we have a problem:  Java Maps are not automatically converted to TypeScript Maps


        d. So, we need to change the getUserInfo so it changes the Observable
           Replace the getUserInfo() method with this:
            
              /*
               * Return an observable that holds information about the user
               * -- The UserInfoDTO holds the user's name and map of routes
               */
              public getUserInfo(): Observable<UserInfoDTO> {
            
                // Construct the URL of the REST call
                const restUrl = environment.baseUrl + '/api/user/me';
            
                // Return an observable
                return this.httpClient.get <UserInfoDTO>(restUrl).pipe(
                       map( (userInfoDTO: UserInfoDTO) => {
            
                        // Convert the userInfoDTO.pageRoutes into a TypeScript Map
                        // -- We do this hear so the PageGuard does not have to do it repeatedly
                        let mapPageRoutes: Map<string, boolean> = 
                            new Map(Object.entries(userInfoDTO.pageRoutes));
            
                        userInfoDTO.pageRoutes = mapPageRoutes;
                        return userInfoDTO;
                         }
                ));
            
              } 	// end of getUserInfo
            




    2. Activate the Debugger and verify that the only routes you can see if "View Reports"
        a. Activate the Debugger on "Full WebApp"
        b. Verify that you can only see View Reports in the left navbar
```
![](https://lh6.googleusercontent.com/rT0o6psMzDaTeKTHb2nq-5Zl_AbhElwIgum8s66ITw6X9LWS_x1ZDS29MXPcFI-fPnieLEnEvnN7ZcyL9SOPXAZUb61fcUaSE6ZoL_97WkBbaMS8E514Xiz_P_avWi1fFsi7Z9vF)
```
NOTE:  We can only connect to the "View Reports" page



        c. Attempt to go to one of the other pages by entering this url:
           http://localhost:4200/page/reports/add


        d. Verify that you see the "Forbidden" message




    3. Change what routes are granted to the READER role
       In development mode, the user is granted the READER role.

       If you add more page routes to the READER role in the database, then the user will see more routes

        a. Edit R__security.sql

        b. Add the route for the "Add Reports" and "Add Reports2" routes to the uicontrols

           Change the end of the file to this:
            
            --
            -- Add the uicontrols records
            -- ASSUMPTION:  These routes match your routes in constants.ts
            --
            insert into uicontrols(id, name) values(1001, 'page/viewReports');
            insert into uicontrols(id, name) values(1002, 'page/reports/add');
            insert into uicontrols(id, name) values(1003, 'page/reports/add2');
            insert into uicontrols(id, name) values(1004, 'page/longReport');
            insert into uicontrols(id, name) values(1005, 'page/searchResults');
            
            
            -- Assign ui controls for the 'admin' role
            insert into roles_uicontrols(role_id, uicontrol_id) values(1, 1001);
            insert into roles_uicontrols(role_id, uicontrol_id) values(1, 1002);
            insert into roles_uicontrols(role_id, uicontrol_id) values(1, 1003);
            insert into roles_uicontrols(role_id, uicontrol_id) values(1, 1004);
            
            
            -- Assign ui controls for the 'reader' role 
            insert into roles_uicontrols(role_id, uicontrol_id) values(2, 1001);
            insert into roles_uicontrols(role_id, uicontrol_id) values(2, 1002);
            insert into roles_uicontrols(role_id, uicontrol_id) values(2, 1003);
            insert into roles_uicontrols(role_id, uicontrol_id) values(2, 1004);
            insert into roles_uicontrols(role_id, uicontrol_id) values(2, 1005);

    4. Update the security records in the database
       NOTE:  Because we changed the R__security.sql, running flyway migrate will re-run it

        a. Run flyway migrate
           unix> cd ~/intellijProjects/angularApp1/backend
           unix> mvn flyway:migrate


    5. Verify that the local dev user can now see the "Add Reports" and "Add Reports2" pages
        a. Activate the Debugger on "Full WebApp"
        b. Verify that you can see the "Add Reports" and "Add Reports2" pages in the navbar
```
![](https://lh4.googleusercontent.com/AQ5VI3K52Vw2_NAFtRSuSRhYJSLKV0-slbNtA08gN6Jeu5i7DRyza0mM1XAFU-zMeyzIJKbjAnSrBFl3xaM6WBTJ4bF2JnTbcw9GwEgLB7aks6M8lx21QPLis6yI_7REkBmfWeaQ)
```
We can see "Add Report" and "Add Report 2" because they were granted to the READER role


```
