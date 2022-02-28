Lesson 16g:  Dashboard / Customizing the Charts
-----------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1h_0BzCZvlyyQu9ue4oV849iZsPmO8XNZOhTTH5acUMI/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson16g/dashboard/customizations
<br>
<br>
<br>

<h3> Problem Set </h3>

Problem:  How do we adjust chart menu options, add click handlers or change tool-tips?
Solution:  In this lesson, we will customize the charts, specifically:<br>

1. Change the context menu byremoving default menu options
1. Change the context menu byadding a custom menu option
1. Change the chart tooltips
1. Add a click event to run a method when a user clicks on pie section

<br>
<br>

![](https://lh5.googleusercontent.com/GLQ6ZIbkk4JyVn44ureMinpeetIKqm6h5L84eMJF70PdaeEFpFnyg83bZOxPD6CpqtXLy49Mbz7SyS4beFU2KWJ1u168LN-I1CAWK7DcRKiXFYSOjtEI0o4KqMNMUnUttHv3JRis)




<br>
<br>

```
Procedure
---------



Problem 1:  I don't want to use the Default Context Menu Options
----------------------------------------------------------------
Adjust the Context Menu by explicitly setting the options (and not going with the default)

By default, HighCharts adds these context menu options

  exporting: {
  	buttons: {
    		contextButton: {
      			menuItems:  [
        				'viewFullscreen',
        				'printChart',
        				'separator',
        				'downloadPNG',
        				'downloadJPEG',
        				'downloadPDF',
        				'downloadSVG',
        				'separator',
        				'downloadCSV',
        				'downloadXLS',
				'viewData'
      			]
    		}
  	}
}




    1. Remove the "View Data Table"  from the chart
        a. Edit dashboard.component.ts

        b. Change chartOptions1 by adding this:     (NOTE:  we excluded 'viewData'):
             
              exporting: {
                buttons: {
                        contextButton: {
                            menuItems:  [
                                    'viewFullscreen',
                                    'printChart',
                                    'separator',
                                    'downloadPNG',
                                    'downloadJPEG',
                                    'downloadPDF',
                                    'downloadSVG',
                                    'separator',
                                    'downloadCSV',
                                    'downloadXLS'
                            ]
                        }
                }
            }

    2. Verify that Chart 1 context's menu does not have "View Data Table"
       -- Activate the Debugger, go to "Dashboards": You should not see "View Data Table"
```
![](https://lh5.googleusercontent.com/GLQ6ZIbkk4JyVn44ureMinpeetIKqm6h5L84eMJF70PdaeEFpFnyg83bZOxPD6CpqtXLy49Mbz7SyS4beFU2KWJ1u168LN-I1CAWK7DcRKiXFYSOjtEI0o4KqMNMUnUttHv3JRis)
```
NOTE:  The "View Data Table" is missing but only from Chart 1.




    3. Add my own custom menu option that runs my own method (to take me to a different page)
        a. Edit dashboard.component.ts

        b. Inject the router

        c. Add this public method:
            
              public goToWelcomePage(): void {
            
                // Navigate to the Welcome Page
                this.router.navigate(["/"]).then();
              } 


        d. Add the custom menu by adding this to the end of chartOptions2
            
                exporting: {
                    buttons: {
                            contextButton: {
                                menuItems:  [
                                        'viewFullscreen',
                                        'printChart',
                                        'separator',
                                        'downloadPNG',
                                        'downloadJPEG',
                                        'downloadPDF',
                                        'downloadSVG',
                                        'separator',
                                        'downloadCSV',
                                        'downloadXLS',
                                        'separator',
            
                                    {
                                        text: 'Go to Home Page',
                                            onclick: () => {
                                                this.goToWelcomePage()
                                            }
                                        }
                                ]
                            }
                    }
                }


    4. Verify that you see the custom menu option on chart 2
        a. Activate the Debugger on "Full WebApp"
        b. Click on "Dashboard"
        c. Look at the custom menu on Chart 2:
```
![](https://lh5.googleusercontent.com/socZGEEhXURbweEgMVlhTEds0GxmFJBgCNC0s4fyI7icnYAnJm7vzXONABIgvbQ05D0JvUP1FYAQI3edf_ODy04OZjcoaGDHELKRwJrqIVFON4O1bGRDMVrDjj9HiWnySw4r5GBM)
```
NOTE:  The "Go to Home Page" menu option at the end





    5. We have a new problem:  We see scroll bars in the mat-card  (which really sucks!)
       -- This is because the menu does not fit inside the mat-card
       -- So, let's hide the scroll bars

        a. Edit dashboard.component.css

        b. Change the chart-content CSS class so it hides the scroll bars  (change in bold)
            
            .chart-content {
              height: 100%; 		/* Needed to ensure the chart fills uses all of the height */
              overflow: hidden; 		 /* Hide the horizontal and vertical scroll bars */
            }


    6. Verify that the context menu appears and there are no scroll bars
        a. Activate the Debugger on "Full WebApp"
        b. Click on "Dashboard"
        c. Look at the custom menu on Chart 2:
```
![](https://lh3.googleusercontent.com/vhI5mXG-w_bcuXXH4kYxsFZWx7Ry0vd6aX_oU3mQyIWeKBcRGxp--JD_-3JOrcbxnvbrlGsZLNtqafZsmcapyNVqPHggYx5F5dyxuJcNwLEFJt58oQSLUjxDt4yZ7P0-lyLNoyRe)
```
Now, there are no scroll bars around mat-card for chart 2




    7. Verify that the "Go to Home Page" button works by clicking on it
-- You should be taking to the "Welcome Component"


    8. Problem:  I want to format the tooltips in my own way:
```
![](https://lh6.googleusercontent.com/5qxDFo89o6vlMqyNsD3BSdOk8mnWxfTJKWTUFp3q5B14dbgmT7vnMe-OK7J21yOBJvPQsTAZ9Fq-XUo6ZCdm5w4_lAFr-YQKwb30uKeSXwOumSDfAxRcqf158Cvz7e6O7ImKJJB-)
```
The date shows:  "Tuesday, Oct 1, 0100" but I want it to appears as mm/dd/yyyy

        a. Edit dashboard.component.ts

        b. Change chartOptions3 by adding a tooltip with a custom formatter:
            
            tooltip: {
                 formatter: function (): any {
                    // @ts-ignore
                    let date = new Date(this.x);
                 
                    // Get the formatted date as mm/dd/yyyy
                    // NOTE:  We must add 1 to the date.getMonth() as January has value of zero
                    let formattedDate: string = String(date.getMonth() + 1).padStart(2, "0") + '/' +
                                                String(date.getDay()).padStart(2, "0") + '/' +
                                                date.getFullYear();
                 
                // @ts-ignore
                    return '<span style="color:{this.color}">' + this.series.name + '</span>: <b>' + this.y + '</b> on ' + formattedDate + '<br/>';
                }	
            },
            

    9. Verify that Chart 3 has different tooltips:
        a. Activate the Debugger on "Full WebApp"
        b. Click on "Dashboard"
        c. Put the cursor over any of the points on chart 3
```
![](https://lh4.googleusercontent.com/iDAxJENVVi4F6klKB7C9IVX26YvTdZNmhYbyn_9KWgNV399RZk3oENztyemU3OiNZMW4JEblBIuTpjDLsi_tcdSMNIeiYsyQj8kxxRQs6Ds0soSeFi_hM6xv_94MlqqzGAQlKmqg)
```
Now, the tool tip is formatted with the date as mm/dd/yyyy




    10. Problem:  I want to run some code when a user clicks on a section of a chart
        a. Edit dashboard.component.ts

        b. Add this public method:

              public logPointInfo(event: any): void {
                console.log('name=' + event.point.name + '  x=' + event.point.x + '  y=' + event.point.y + '  percent=' + event.point.percentage);
              }

        c. Edit chart1Options by changing the series to this   (Changes in bold)
            
            series: [
               {
                    name: "Browsers",
                    colorByPoint: true,
                    data: [],
        
                    point:{
                        events:{
                                click: (event: any) => {
                                    this.logPointInfo(event)
                                }
                        }
                    }
        
               }
            ],


    11. Verify that clicking on a point chart shows information in the console
        a. Activate the Debugger on "Full WebApp"
        b. Press F12 to open your Dev Tools Console
        c. Click on "Dashboard"
        d. In Chart 1, single-click on a pie slice
           -- You should see the message in the console
            
           -- So, we can run any code we want when a user clicks on a point.


```
