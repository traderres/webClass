Lesson 20j:  Secure Routes / Secure Page with Route Parameter (passed-in ID)
----------------------------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1JR1D1sAXSA6r1URaP2heI4x1eNZ0pq9OtYY4yn9ySUI/edit?usp=sharing
      

<br>

<h3> Problem Set </h3>

Problem:  I want to secure a page route that has an id in it<br>
Solution:  Store the :id in the R__security.sql<br>

<br>
<br>
<h3>Approach</h3>

1. In the **R\_\_security.sql**  
   insert into uicontrols(id, name) values(1011, 'page/reports/edit/:id');  
   <br>

1. In the **constants.ts**  
   EDIT_REPORT_ROUTE = "page/reports/edit/", // This route has a required id  
   <br>

1. In the **app.module.ts**  
     
         { path: Constants.EDIT_REPORT_ROUTE + ':id', 
                component: EditReportComponent , canActivate: [PageGuard] },

            NOTE:  It must have ':id'   (The colon is IMPORTANT!!!))  
   <br>
   
1. In the**page.guard.ts****  
   -- Do not strip-out anything from url
   <br>


<br>
<br>

```
Here is the code for the page.guard.ts
--------------------------------------
import { Injectable } from '@angular/core';
import {CanActivate, ActivatedRouteSnapshot, RouterStateSnapshot, Router} from '@angular/router';
import { Observable } from 'rxjs';
import {UserService} from "../services/user.service";
import {UserInfoDTO} from "../models/user-info-dto";
import {map} from "rxjs/operators";
import {Constants} from "../utilities/constants";

@Injectable({
  providedIn: 'root'
})
export class PageGuard implements CanActivate {

  public constructor(private router: Router,
                 	private userService: UserService) {
  }


  public canActivate(next: ActivatedRouteSnapshot, state: RouterStateSnapshot): Observable<boolean> {

    return this.userService.getUserInfo().pipe(
      map( (userInfoDTO: UserInfoDTO) => {
    	// Use the map operator to convert the Observable<UserInfoDTO> into an Observable<boolean>

    	// Get the next url from the next variable
    	let nextUrl: string | undefined = next.routeConfig?.path;
    	if (! nextUrl) {
      	// The user is going so an undefined page.  So, return an observable<false> so the router does not proceed
      	return false;
    	}

    	// Check if the url is allowed
    	let routeAllowed: boolean | undefined = userInfoDTO.pageRoutes.get(nextUrl);

    	if (! routeAllowed) {
      	// The route was not found in the map or holds False.  So, redirect the user to the Forbidden Page
      	this.router.navigate([Constants.FORBIDDEN_ROUTE]).then();

      	// Return false so that the router will not route the user to the new page
      	return false;
    	}

    	// The route was allowed.  So, return an observable holding true
    	return true;

      })  // end of map
    );  // end of pipe

  }  // end of canActivate()


}


```
