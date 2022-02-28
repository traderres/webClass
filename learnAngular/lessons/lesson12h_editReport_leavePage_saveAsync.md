Lesson 12h:  Edit Report / Leaves Page / Save Asynchronously
------------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1pvOmvrWh7uCWj4IkrZ9MWeRBQWo1bgLDKjyCOxyplBE/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson12h/leave-page-save-async
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem:  I want to save and not wait (when a user leaves a page)<br>
Solution:  Inject the router and subscribe to this.router.events

<br>
<br>

<h3>OPINION: Why I don't like this approach</h3>

Consider this scenario

1. The user enters the Edit Report page
1. The user fills-in some fields
1. The user leaves the page  
   - So, our save method gets called (and runs in the background)
1. The new page has loaded  
   - The REST call comes back with an error (for some unknown reason)  
   - The ErrorInterceptor detects the error  
   - The Error Dialog Box appears on the \*NEW PAGE\*  
     
If an error occurs, I don't want to leave the page.



<br>
<br>

```

Procedure
---------
    1. Edit the edit.report.component.ts

        a. Inject the router
        	constructor(
	        	...
		        private router: Router)  { }


        b. Adjust the canDeactivate method so it always returns true


        c. Add this subscription:
             private routerSubscription: Subscription;


        d. Edit the ngOnInit() so it listens for router changes
            
            public ngOnInit(): void {
            
                this.routerSubscription = this.router.events.subscribe(event =>{
                if (event instanceof NavigationStart){
                    // Run some code asynchronously
                    // NOTE:  The user will continue navigating
                    console.log('user leaving page -- so save data');
                    this.saveCurrentFormAsync();
                }
                });
            
            }

        e. Edit the ngOnDestroy() so it unsubscribed
            
            public ngOnDestroy(): void {
                if (this.routerSubscription) {
                    this.routerSubscription.unsubscribe();
                }
            }


    2. Verify it works
        a. Set a breakpoint in your ReportController.updateReport()
        b. Activate your debugger on 'Full WebApp'
        c. Go to the "View Reports" page
        d. Click to Edit a Report

        e. Change one of the fields in the "Edit Report" page
           -- Change the report name to something else

        f. Click on the left-side navbar to go to a different page
           -- The save REST call should get hit (and your breakpoint should get hit)
           -- Press F9 to let the save continue

        g. Go back to Edit the same report
           -- Verify that you see that the report was updated


    3. Now, undo it (as the approach in 12g is MUCH BETTER)


```
