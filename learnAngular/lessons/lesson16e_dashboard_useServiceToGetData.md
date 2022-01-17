Lesson 16e:  Dashboard / Add Front-End Service to Get Data
----------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1fmkOovXlRru1OL0_IWqi-Jc1n3LKrGk3pMl2dzmql-s/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson16e/dashboard/get-data-front-end
<br>
<br>
<br>

<h3> Problem Set </h3>

Problem:  How do I load data into a grid from a REST call?
Solution:  Create a front-end service.<br>
- The REST call will return a single DashboardDataDTO object with info for each chart
- DashboardService.getAllChartData() will return an observable with hard-coded data
- DashboardComponent.reloadData() will subscribe to this REST call

<br>
Once we know our hard-coded DashboardService works, then we can use a real REST call to get data.

<br>
<br>
<h3>Approach</h3>

1. Create the front-en *DashboardDataDTO object (to hold data from REST call)
1. Create the front-end DashboardService w/public method that returns observable&lt;DashboardDataDTO>
1. Adjust the front-end DashboardComponent so it uses the DashboardService to get data


<br>
<br>

```
Procedure
---------
    1. Create a DashboardDataDTO object  
       NOTE:  This object will hold data for the charts
       
        a. Create the DashboardDataDTO class
           unix> cd ~/intellijProjects/angularApp1/frontend
           unix> ng generate class models/DashboardDataDTO --skipTests


        b. Add these public fields:

               public chartData1: any;
               public chartData2: any;
               public chartData3: any;



    2. Create a dashboard service that simulates a REST call returning data
        a. Create the Dashboard Service
           unix> cd ~/intellijProjects/angularApp1/frontend
           unix> ng generate service services/dashboard --skipTests

        b. Edit dashboard.service.ts

        c. Add a public method called getAllChartData()

              public getAllChartData(): Observable<DashboardDataDTO> {
                
                let data1 =  [
                {
                    name: "Item 3",
                    y: 989
                },
                {
                    name: "Item 3R",
                    y: 249
                },
                {
                    name: "Item 5",
                    y: 1035
                },
                {
                    name: "Item 5R",
                    y: 324
                }
                ];
                
                // Create the DashboardDataDTO and populate it w/data for chart 1 only
                let dto: DashboardDataDTO = new DashboardDataDTO();
                dto.chartData1 = data1;
                
                // Return an observable with the DashboardDataDTo object
                return of(dto);
              }


    3. Change DashboardComponent.ngOnInit() to invoke the REST call 
        a. Edit dashboard.component.ts

        b. Inject the DashboardService

        c. Edit the reloadData() method to invoke a REST call and render the charts
            i.   Change reloadData() to subscribe to dashboardService.getAllChartData()

            ii.  Add a finally block that will run this code when the REST call finishes: 
                      this.dataIsLoading = false  

            iii. Make sure you have Highcharts render the chart *after* you load data


            Hint:  Take a look at add-report2.component.ts save() to see how to invoke a REST call




    4. Verify Chart1 works look
        a. Activate your Debugger on "Full WebApp"
        b. Click on Dashboard
           -- You should see Chart1 appear normally


    5. Move the data from DashboardComponent.reloadData() to the DashboardService.getAllChartData()
        a. Edit dashboard.service.ts

        b. Edit the getAllChartData() so it gets and sets chart2 data

        c. Edit dashboard.component.ts

        d. Change the reloadData() so after the REST call comes back, we set chart2 data



    6. Verify Chart 2 looks good
        a. Activate your Debugger on "Full WebApp"
        b. Click on Dashboard
           -- You should see Chart2 appear normally


```
