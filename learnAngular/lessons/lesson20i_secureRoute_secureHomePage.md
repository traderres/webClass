Lesson 20i:  Secure Routes /  Secure Home Page
----------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1sp0zL5qmTMhI0-9AVCNcbQpsbw9dS0Cl10EhaFgdsKQ/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson20i/secure-route/secure-home-page
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem:  If the user does not have any required security roles, then do not show the main page<br>
Solution:  Secure the HomeController url for "/" or "/page/**"  (in the back-end)


<br>
<br>
<h3>Order of Operations</h3>

1. User opens a browser and connects to http&#x3A;//localhost:8080/app1

1. Spring Web intercepts the call and looks for something that matches /  
   --> HomeController.home()  

1. **Spring looks for the @PreAuthorize to see if the user has one of the N roles**  
   -- If the user does not have the READER or ADMIN role --> STOP HERE!! 403 Forbidden*

1. HomeController.home() returns "forward:/index.html"  
   -- Tells Spring to take the user to the index.html  

1. The index.html page starts to load (Angular front-end starts-up)  
   -- Your app.component.ts  
   -- Async Pipes  
   -- Invoke REST calls


<br>
<br>

```
Procedure
---------
    1. Secure the Home page and every call to /page

        a. Edit HomeController.java

        b. Change the home() method by adding this to it:
   
              @PreAuthorize("hasAnyRole('READER', 'ADMIN')")


            NOTE:  If you have 5 roles, then include all 5 roles in this PreAuthorize call



        When finished, the home() method should look like this:
        
        /**
         * This page endpoint is needed to ensure that all page routes to the Angular Frontend
         * @return a string which causes Spring Web to redirect the user to index.html
         *
         * NOTE:  If the user is going to /app1/page/view/reports, then
         *     	1. Spring will redirect the user to the /index.html
         *     	2. Angular routes will redirect the user to the route for view/reports
         */
        @RequestMapping(value = {"/", "/page/**"}, method = RequestMethod.GET)
        @PreAuthorize("hasAnyRole('READER', 'ADMIN')")
        public String home() {
        
            // This method handles two cases:
            // Case 1: The user goes to http://localhost:8080/app1  --> Take users to the index.html
            // Case 2: The user goes to http://localhost:8080/app1/page/addReport and presses refresh --> Take users to the index.html
            return "forward:/index.html";
        }
        



    2. Make sure your code still compiles
       unix> cd ~/intellijProjects/angularApp1
       unix> mvn clean package -Pprod

```
