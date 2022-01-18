Lesson 19b:  Add the "Forbidden" Page
-------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1D2FQlITcDwoMGYswkvs4hi-rRxhC4hsYbuFm0KtV9pY/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson19b/forbidden
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem:  The user attempts to visit a page that is not authorized<br>
Solution:  Show them the "Forbidden" page<br>

<br>
<br>

![](https://lh4.googleusercontent.com/7BKABGeM5TXmRcepTB5fD0b2pxyjCU1vU5acj1F33HwkNkk67KJxpx1LAMTrOmLpRjhtbfGClXkKToKq1MK4NxOOcoZm3k_L_5QQ3I-9EHkQv2UfW_naBSBFBiQJgKakAoNJiLVX)




<br>
<br>

```

Procedure
---------
Procedure
    1. Create a forbidden component

    2. Create a route for the forbidden page such that "page/403" --> ForbiddenComponent
        a. Edit app.module.ts

        b. Add a route such that "page/403" takes users to the ForbiddenComponent

    3. Verify that the route work
        a. Activate your Debugger on "Full WebApp"
        b. Change the url to http://localhost:4200/page/403 (to get to the forbidden page)
        c. Verify that you see the page
```
![](https://lh4.googleusercontent.com/fzBxMrmMK8duivg0Ypfg6Rn8BEh3E9Ri6ODcf6Y9MnolM81y8x2-nogAUW-pSDh4BlmMFEoROepzPQ0w0nOlgLa-4L_tnskfrietp_rcTzmGij5eVZa_WB5GRsEaDfUHLinTNS79)
```
V1 of the Forbidden Page is just an empty shell





    4. Make the page look better
        a. Edit forbidden.component.html

        b. Remove all of its contents

        c. Add a mat-card 

        d. Add a <mat-card-title> </mat-card-title> with the title of Restricted Access

        e. Add a <mat-card-content> with a message "You are not authorized to perform this action."


    5. Verify that the page looks better
        a. Activate your Debugger on "Full WebApp"
        b. Change the url to http://locahost:4200/page/403  (to get to the forbidden page)
        c. Verify that you see the page
```
![](https://lh3.googleusercontent.com/03wlJnpIZM8kvvzNpMvalGZ183lNLRPiJbkyavwE2rGPpRPeD4RanP-8EPsUf3mNnM7rS5SLxtTBWW1KkgtD-mPyXJDM6JMUwL0v6CzpNbBWCWl5vuNuHawOVqOfCapDu2kr2QPc)
```
V2 looks better, but we are not using 100% of the page and we do not have a margin of 10px around the page (which improved the 3D effect of the mat-card)






    6. Add a font-awesome icon fas fa-ban with a size of 5x underneath the page title

       So, your page layout should look like this
        
        Restricted Access
        15px of space
        Font Awesome fas fa-ban 5x
        15px of space
        You are not authorized to perform this action.
        


    7. Verify that the page looks better
        a. Activate your Debugger on "Full WebApp"
        b. Change the url to http://locahost:4200/page/403  (to get to the forbidden page)
        c. Verify that you see the page
```
![](https://lh4.googleusercontent.com/1HSG3z1c-H2B6WZYZsKogpGuz4FVBYxCmJHoeA0lRNir9R2_5GnOIxoHARarREAORkkXCtrzcWajwbCIfzC2qkIpGAeb7oUltIjewQnTAIwx8cOLQbW7MWldATTvd0OGgzJHD7-2)
```
V3 looks better, but we are not using 100% of the page and we do not have a margin of 10px around the page (which improved the 3D effect of the mat-card)




    8. Let's clean it up by doing a few things
        a. Add a "page-container" css class to your styles.css with a margin of 10px
(If you have not already added this)


        b. Add a wrapper div with class="page-container" to the page


        c. Change the mat-card-content to use 100% of the page

           Add a wrapper div (inside the mat-card-content) that adds this:
               <div style="height: calc(100vh - 140px)">
            
               </div>


        
        When completed, your forbidden.component.html should look something like this:
        
        <div class="page-container">
        
          <mat-card>
            <mat-card-title>Restricted Access</mat-card-title>
        
            <mat-card-content>
        
            <!-- Setup a wrapper div that uses the entire available height (total height - 140px) -->
            <div style="height: calc(100vh - 140px)">
        
                <i style="margin-top: 15px" class="fas fa-ban fa-5x"></i>
        
                <div style="display: block; margin-top:15px">
                You are not authorized to perform this action.
                </div>
        
            </div>
        
            </mat-card-content>
        
          </mat-card>
        
        </div>


    9. Verify that the page uses 100% of the page and there is a 3D effect
        a. Activate your Debugger on "Full WebApp"
        b. Change the url to http://locahost:4200/page/403  (to get to the forbidden page)
        c. Verify that you see the page
```
![](https://lh4.googleusercontent.com/7BKABGeM5TXmRcepTB5fD0b2pxyjCU1vU5acj1F33HwkNkk67KJxpx1LAMTrOmLpRjhtbfGClXkKToKq1MK4NxOOcoZm3k_L_5QQ3I-9EHkQv2UfW_naBSBFBiQJgKakAoNJiLVX)
```
V4: The page has a 3D effect and uses 100% of the available height



```
