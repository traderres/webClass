Lesson 20h:  Secure Routes /  Cache REST Call
---------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1a6IJdPSyBmZOUnIjlBnZFaW6C5mIjohBBwo-t3Bvefg/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson20h/secure-route/cache-rest-call
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem:  We want to cache the UserInfo REST call as there is no need to call it repeatedly<br>
Solution:  Have the user.service.ts cache the observable<br>





<br>
<br>

```
Procedure
---------
    1. Edit user.service.ts

    2. Add an private observable that holds the cached info
          private cachedObservable: Observable<UserInfoDTO> | null = null;


    3. Change the getUserInfo() method to examine the cached value first:
        
          /*
           * Return an observable that holds information about the user
           * -- The UserInfoDTO holds the user's name and map of routes
           */
          public getUserInfo(): Observable<UserInfoDTO> {
        
            if (this.cachedObservable != null) {
                // This observable is already cached.  So, return the cached value
                console.log('returning cached userinfo');
                return this.cachedObservable;
            }
        
            // Construct the URL of the REST call
            const restUrl = environment.baseUrl + '/api/user/me';
        
            // Get the observable and store it in the internal cache
            this.cachedObservable = this.httpClient.get <UserInfoDTO>(restUrl).pipe(
                    map( (userInfoDTO: UserInfoDTO) => {
        
                        // Convert the userInfoDTO.pageRoutes into a map
                        // So that the PageGuard does not have to do it repeatedly
                        let mapPageRoutes: Map<string, boolean> = new
                        Map(Object.entries(userInfoDTO.pageRoutes));
        
                        userInfoDTO.pageRoutes = mapPageRoutes;
        
                        return userInfoDTO;
                    }),
                shareReplay(1)
            );
        
            // Return the cached observable
            console.log('returning real userinfo');
            return this.cachedObservable;
        
          } 	// end of getUserInfo


    4. Verify that the UserService gets the real info once and returns the cached info every time after
        a. Activate the Debugger on "Full WebApp"
        b. Press F12 to open your browser console
        c. Click on different pages
           -- Verify that you see "returning real userinfo" only once
           -- Verify that you see "returning cached userinfo" one the 2nd, 3rd, 4th, 5th, page route


    5. Remove the console.log calls from the user.service.ts


    6. Verify that the UserService gets the real info once and returns the cached info every time after
        a. Activate the Debugger on "Full WebApp"
        b. Press F12 to open your "Network" console
        c. Click on different pages
           -- Verify that you see the REST call /api/user/me only once





```
