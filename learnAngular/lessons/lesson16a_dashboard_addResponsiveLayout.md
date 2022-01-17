Lesson 16a:  Dashboard / Add Responsive Layout
----------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1TEehP46wmU5ayBn9XrS2Z0zglqXxG2Ce8wCHf4kofxE/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson16a/dashboard/add-layout
<br>
<br>
<br>

<h3> Problem Set </h3>

Problem 1:      Management wants a dashboard page with charts spread over 3 columns<br>
Problem 2:     The user's browser may not be wide enough to show all 3 columns<br>
Solution:      Setup a responsive layout <br>

<br>
<br>
Layout of the page using 3 columns  (if browser has sufficient width)

![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/lesson16a_image1.png)

NOTE:  If the browser cannot fit 3-tiles wide, we will adjust <mat-grid-list cols=" "> to be 2 or 1 column wide. 
<br>
<br>
<br>
Layout of the page using 2 columns  (if browser has sufficient width)

![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/lesson16a_image2.png)

<br>
<br>

<h5>References</h5>

- https://medium.com/@pjlamb12/angular-cdks-breakpointobserver-b75df04a1cc2

<br>
<br>

```
Procedure
---------
    1. Add a new dashboard page to the web app
        a. Create the dashboard page component
           unix> cd ~/intellijProjects/angularApp1/frontend
           unix> ng generate component analytics/dashboard --skipTests

        b. Add a route so that /page/dashboard --> DashboardComponent

        c. Add a new nav item to the "Analytics" section
            i. Edit navbar.component.html

            ii. Add a navigation icon to it for this route


    2. Change the default layout so that the "Analytics" navbar section is opened on page load
       And, the "Reports" navbar section is closed on page load
        a. Edit navbar.component.ts

        b. Change the initial value of this variable:
              public reportsNavGroupClosed: boolean = true;   // Close Reports  section on page load
              public analyticsGroupClosed:  boolean = false;    // Open Analytics section on page load



    3. Verify that the empty page appears
        a. Activate the debugger on "Full WebApp"
        b. Click on "Dashboard"
           -- Verify that you see the dashboard works! message

    4. Add the MatListModule and to app.module.ts
        a. Edit app.module.ts

        b. Add these imports:
            
                MatListModule,
                MatGridListModule,
            
           TIP:  Sort your imports so you can quickly identify if an import is present
            
           If you get errors about your new modules, then stop your debugger.  (really!)
           If that does not work, then delete node_modules and re-import package.json




    5. Setup angular flex on the page
        a. Edit dashboard.component.css

        b. Add this CSS class:

                .grid-container {
                    margin: 10px;
                }


        c. Edit dashboard.component.html

        d. Replace its contents with this:
            <div class="grid-container">
            
              <div fxFlexFill fxLayout="column">
            
                <div fxFlex fxLayout="row" fxLayoutGap="0" style="border: 1px solid black">
            
                <!-- Left Side of the Top Row -->
                <div fxFlex fxLayoutAlign="left center" fxLayout="row" fxLayoutGap="0">
                    <h1 class="mat-h1">Dashboard</h1>
                </div>
            
            
                <!-- Right Side of the Top Row -->
                <div fxFlex fxLayoutAlign="end center">
                     
                </div>
            
                </div>  <!-- End of top row -->
            
                <!-- Start of the second row -->
                <div fxFlex  fxLayout="column" fxLayoutGap="0"  style="border: 1px solid black">
            
                Second Row
            
                </div> <!-- End of 2nd row -->
            
              </div> <!-- End of Angular flex column -->
            
            </div>  <!-- End of grid container -->


        e. Examine the page in the debugger
```
![](https://lh4.googleusercontent.com/7_urPjVo2PNilp_DFfQ6byqL3R85jD6FqRiqab6RHUPDT76YJnm-GiKQ_RUpvHDI2z3HwVqH_CyC4vuhxAXgBiNvISJkAIQeRyJUndVbA-2l4UIybSa1LT5NiEdiWaB9fli0Frhj)
```




    6. Add the first charts  (it will take-up one of the 6 slots)
        a. Edit dashboard.component.html

        b. Replace the "Second Row" label with a mat-grid-list
        
            <!-- Setup the 1st row of graphs.  Each graph is 300px tall -->
            <mat-grid-list cols="3" rowHeight="300px">
        


        	</mat-grid-list>



        c. Inside the <mat-grid-list>, add a first tile  (that holds a mat-card)

            <mat-grid-tile colspan="1" rowspan="1">
                  <mat-card>
                        <mat-card-content>
            
                         <!-- Chart 1 -->
                         Chart 1
            
                         </mat-card-content>
                  </mat-card>
            </mat-grid-tile>


        d. Format the mat-card so it fits inside the tile
            i. Edit dashboard.component.css

            ii. Add this CSS class:
                
                mat-card {
                  /* Set spacing between cards */
                  position: absolute;
                  top: 10px;
                  left: 10px;
                  right: 10px;
                  bottom: 10px;
                  overflow-y: auto;
                }

    7. Verify that the first chart looks as follows
        a. Activate the Debugger on "Full WebApp"
        b. Click on the Dashboard navbar item
        c. You should see this:
```
![](https://lh5.googleusercontent.com/JkYwrzkRn4O1Yc0pJepANzZ8ZZRRrZCLgmS3fv9xJPKWf2xaZIphMvCoJnnQISYzRAl0YXb4H9JvNpz47ABp0O_7R0ELUOkd1e12xc3jiD0uUJILpmhT1DHGRVFmX4ZaO9_dkrCr)
```



    8. Add 5 more charts by copying the mat-grid-tile tag over
       And rename the chart so it shows "Chart 2", "Chart 3", "Chart 4", "Chart 5", "Chart 6"
        a. Edit dashboard.component.html

        b. Copy the mat-grid-tile tag 5 times over

        c. Remove the border style tags from the angular rows



    9. Verify that you now have 6 charts that stretch 
        a. Activate the Debugger on "Full WebApp"
        b. Click on "Dashboard"
        c. Examine the page
```
![](https://lh5.googleusercontent.com/IMqTv7dZGAq0FKCsm1h1z7D87dMcvHpjHdlx00o4E_RISAz_8FUIcWSKbiih7TkcQV5wp0Yg1WuydMs0XyMpBf40RvyXOC3f9hiiS6jd8CZ7i7UOqY1DEGPGQC1BEI9VCy2xqf8G)
```

        d. Now, stretch the browser:  The charts should stretch to take advantage of the space

        e. Now, toggle the left-side navbar.  The charts should adjust with the page width.
           NOTE:  There's always 3 columns of charts (so it's not really responsive yet).



    10. Adjust the dashboard class so it "listens" for changes in page width and sets totalColumns

        a. Edit dashboard.component.ts



        b. Inject the breakpointObserver     
           NOTE:  This is an Angular service that sends messages when you cross a "breakpoint" from small-to-medium or medium-to-large browser size) 



        c. Add a public integer that holds the total number of columns to show
   public totalColumns: number;



        d. Add a private Subscription (that will listen for messages from the breakpointObserver)
    private cardLayoutSubscription: Subscription;



        e. Change the empty ngOnInit() to this:
            
              public ngOnInit(): void {
            
               this.cardLayoutSubscription = this.breakpointObserver.observe(
                   [Breakpoints.XLarge, Breakpoints.Large, Breakpoints.Medium, Breakpoints.Small, Breakpoints.XSmall])
                .subscribe((state: BreakpointState) => {
                    // We received a message from the breakpointObserver.  The page width has adjusted.
            
                    if ((state.breakpoints[Breakpoints.XSmall]) || (state.breakpoints[Breakpoints.Small])) {
                        // The browser is Small or XSmall -- so set columns to 1
                        this.totalColumns = 1;
                        console.log('Width is small or xsmall.  totalColumns='+ this.totalColumns);
                    } 
                else if (state.breakpoints[Breakpoints.Medium]) {
                        // The browser is Medium -- so set columns to 2
                        this.totalColumns = 2;
                        console.log('Width is medium.  totalColumns=' + this.totalColumns);
                    }
                else {
                        // The browser is larger or greater -- so set the columns to 3
                        this.totalColumns = 3;
                        console.log('Width is large or greater.  totalColumns=' + this.totalColumns);
                    }
            
                 });
            
              }  // end of ngOnOnit()

    
    The BreakpointObserver has these provided breakpoints:
        XSmall 	599.99px or less
        Small  		600 - 959.99px
        Medium 	960 - 1279.99px
        Large  		1280 - 1919.99px
        XLarge 	1920px or greater



        f. Make your the dashboard.component.ts implement the onDestroy interface

        g. Fill-in the ngOnDestroy method so it unsubscribes from the cardLayoutSubscription:
        
          public ngOnDestroy(): void {
            if (this.cardLayoutSubscription) {
            // Unsubscribe from the subscription (to avoid memory leaks)
            this.cardLayoutSubscription.unsubscribe();
            }
          }
        


    11. Adjust the dashboard HTML template so it uses the this.totalColumns to adjust the number of columns
        a. Edit the dashboard.component.html

        b. Change this line:
            <!-- Setup the 1st row of graphs -->
            <mat-grid-list cols="3" rowHeight="300px">
     
         To this:
            <!-- Setup the 1st row of graphs -->
            <mat-grid-list [cols]="this.totalColumns" rowHeight="300px">



    12. Verify that the page is responsive
        a. Activate the Debugger on "Full WebApp"
        b. Click on "Dashboard"
        c. Press F12 to open the browser console
        d. Adjust the browser width.
```
![](https://lh5.googleusercontent.com/rGRMMTcSS-kGjt3gKUkB-mOAODFbcGAcNzHWkdlq1KvcNemVQnUEJugPs0pJeiP3TixjUtnrCs6SRJZ3o_QkMiKWFYfRD3Vlk5Er5Zxs3NvKt84Xfz_Nr0l-3g3sobgqGuRj0-aa)
```


        e. As the browser gets narrow, the grid should change from 3 columns to 2 columns
```
![](https://lh4.googleusercontent.com/r2fY8lgvN9PWZEczewJxo0B7F3FlqM808I1FG72XR8VNK2RHdUL2j_gJ7xzCwEG4nRuDwCVn1YF68XI0Nz5ofFQaibUvdGgTnYu9HWI9mTS7K_gaVmMx4k8CCY7snBlJ3A0sWrTD)
```
NOTE:  Look at the browser console to see what is happening




        f. As the browser gets even more narrow, the grid should change from 2 columns to 1 column
```
![](https://lh5.googleusercontent.com/VbEkC6udvxh60GsyfwMrtsgT37siFPXBEj7ykBzb4ZKJh53sO6VmN4atGCXlQrdl37OONSuXmXYIOygcX1yZtZ8IIXMiceb6vK5tebI0OUECM52wqIbBGe2N5Esa9r7ez8jeYSaz)
```



    13. Now, make the page responsive based on specific page widths
        if the page is 1100px or more, 	use 3 columns
        If the page is 800px-1100px, 		use 2 columns
        If the page is 1 to 800px, 		use 1 column

        a. Edit dashboard.component.ts

        b. Change the ngOnInit() so that the cardLayoutSubscription uses this logic:
            
            // Listen on an array of size breakpoints
            // NOTE:  The breakpoints can be min-width or max-width
            this.cardLayoutSubscription = this.breakpointObserver.observe([
                 '(min-width: 1px)', '(min-width: 800px)', '(min-width: 1100px)'
                   ]).subscribe( (state: BreakpointState) => {
            
                if (state.breakpoints['(min-width: 1100px)']) {
                    console.log("Screen is 1100px or more.  state=", state);
                    this.totalColumns = 3;
                }
                else if (state.breakpoints['(min-width: 800px)']) {
                    console.log("Screen is 800px-1100px.  state=", state);
                    this.totalColumns = 2;
                }
                else if (state.breakpoints['(min-width: 1px)']) {
                    console.log("Screen is 1 to 800px.  state=", state);
                    this.totalColumns = 1;
                }
            
            });


    14. Verify that you see 2 columns at 800px and 3 columns at 1100px
        a. Activate the debugger on "Full WebApp"
        b. Click on "Dashboard"
        c. Adjust the width of the browser
           As the browser width hits 800px, you should see 1 column -> 2 columns
           As the browser width hits 1100px, you should see 2 columns -> 3 columns
```
![](https://lh5.googleusercontent.com/ADDu5ADPBw8L6Z6z3XceVwUKGHoRveDXiOuMx9EjYbRO5PPTAix-uHPLtcd1HAsEr0mgOQoQUcugtVPMkTcOj3n7femWmbujOSulgDbNhS386D3J--6L7_hG284wa1G1SPOnLiqj)
```
NOTE:  In Chrome, as you resize, you will see the browser width in the upper right corner (when the F12 Developer Console is open)
-- The browser width is 872px so we should see 2 columns of charts



    15. Increase the 3D effect of the cards
        a. Edit dashboard.component.html

        b. Change the <mat-card> to this  <mat-card class="mat-elevation-z4"> 

        c. Change the <mat-card> tags to use mat-elevation-z8 -- do you like that one betteR?



```
