Lesson 20b:  Secure Routes /  Add a User Service
------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1LFP3bQkq-jtrrJsZEXW7Hovlq9AexHAkhgzDco68ESA/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson20b/secure-route/add-user-service
<br>
<br>
<br>

<h3> Problem Set </h3>

Problem:  The PageGuard needs a map of information
-  Key=Page-Route   Value=true/false    (true if router should proceed)<br>
<br>

Solution
- Inject a UserService that returns this information as an Observable that holds the user's name and map of allowedRoutes
- Have the PageGuard return an Observable<boolean> so that that the router subscribes to it

  

<br>
<br>

```
Procedure
---------
    1. Create the UserInfoDTO class
        a. Create this class:  UserInfoDTO  (in the models directory)

        b. Edit user-info-dto.ts

        c. Add these 2 public fields:
               name    (it will hold the user's name as text)
               pageRoutes     (it's a map of key=page route   and   value=true/false


    2. Create the UserService
        a. Create this service:  UserService  (in the services directory)

        b. Edit user.services.ts

        c. Add a public method called getUserInfo() that returns an Observable holding a UserInfoDTO

        d. In the getUserinfo() let's return some hard-coded data:
            i.   Create a UserInfoDTO object
            ii.  Set the name to be 'John Smith'
            iii. Set the pageRoutes to be a new Map that holds this information
            iv.  Return the hard-coded observable such that pageRoutes hold this:
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson20b_image1.png)
```
	

    3. Change the PageGuard so it gets the UserInfoDTO information
        a. Edit page.guard.ts

        b. Inject the UserService

        c. Change canActivate method signature so it only returns an Observable<boolean>


        d. Change the canActivate method so it converts the Observable<UserInfoDTO> into an Observable<boolean>

           Change the canActivate method to this:
            
                public canActivate(next: ActivatedRouteSnapshot, state: RouterStateSnapshot):
                                                         Observable<boolean> {
                
                   return this.userService.getUserInfo().pipe(
                       map( (userInfoDTO: UserInfoDTO) => {
                            // Use the map operator to convert the Observable<UserInfoDTO> into an Observable<boolean>
                
                            // Get the next url from the next variable
                            let nextUrl: string | undefined = next.routeConfig?.path;
                            if (! nextUrl) {
                                // The user is going to an undefined page. 
                        // So, return an observable<false> so the router does not proceed
                                return false;
                            }
                
                            // Check if the url is allowed
                            let routeAllowed: boolean | undefined = userInfoDTO.pageRoutes.get(nextUrl);
                
                            if (! routeAllowed) {
                                // The route was not found in the map or holds False.  
                        // So, redirect the user to the Forbidden Page
                                this.router.navigate(['page/403']).then();
                
                                // Return false so that the router will not route the user to the new page
                                return false;
                            }
                
                            // The route was allowed.  So, return an observable holding true
                            return true;
                
                        })  // end of map
                      );  // end of pipe
                
                 }  // end of canActivate()
                


    4. Register the PageGuard to all routes (except for page/403, '', and '**'
        a. Edit app.module.ts

        b. Change every route (except page/403, '', and '**' so that they all have 
             canActivate: [pageGuard]




    5. Verify that the user is only allowed to get to routes that have TRUE in the map in the user service
        a. Set a breakpoint in your PageGuard.canActivate() method
        b. Activate the Debugger on "Full WebApp"
        c. Click on each of these routes.  Follow the breakpoints
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson20b_image2.png)
```


        d. Verify that any route that is not found or has false is restricted (Forbidden page is shown)
           -- So, all of the analytic page routes should be restricted
           -- The Upload Report page should be restricted

        e. Verify that these 4 pages are the only pages that are authorized  (router is allowed to proceed)




Pop Quiz:  There is no subscribe() operator.  So, how does the REST call get invoked?
-------------------------------------------------------------------------------------

You see this line of code in the page.guard.ts

      return this.userService.getUserInfo().pipe(

    )



There is no call to subscribe().  

So, why does the PageGuard.canActivate() invoke the REST call?


```
