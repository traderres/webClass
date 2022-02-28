Lesson 16f:  Dashboard / Add REST Call to Get Data
--------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1limza7Ck2EoAgdAstXaVpjtyA9W3C0N1RhofRV2_66g/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson16f/dashboard/get-data-rest-call
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem:  How do we create a single REST call that <b>provides data for multiple</b> charts?<br>
Solution: We create a REST call that returns an object 3 fields<br>




<br>
<br>
<h3>Approach</h3>

1. Create a back-end java object: GetDashboardDataDTO(holds the DTO returned to the front-end)
1. Create a back-end java service: DashboardService(where data is retrieved)
2. Create a back-end java controller: DashboardController(holds the REST endpoint)
1. Change the front-end DashboardService to invoke the real REST call

<br>
<br>

![](https://lh6.googleusercontent.com/52buH-sFmTpK7XM9Bi97vW0bJinA7ex57YtcLp0_gENd3CvFFvMXxa4SzIr9xaPYwTd79vOAXrMHCvoZZ_QNur7EfquQWxZrShoaPrAJ0Zvw32ZOYCN-h2wgibt4KyXuA_oJ-UAp)



```
Procedure
---------
    1. Create a back-end java object:   GetDashboardDataDTO
       NOTE:  This java class holds all chart data returned from the REST call

        a. Right-click on backend/src/main/java/com/lessons/models -> New Java Class
           Class Name:  GetDashboardDataDTO

        b. Replace the class contents with this:
            
            package com.lessons.models;
            
            import com.fasterxml.jackson.annotation.JsonProperty;
            import java.util.List;
            import java.util.Map;
            
            public class GetDashboardDataDTO {
            
                @JsonProperty("chartData1")
                private final List<Map<String, Object>> chartData1;
            
                @JsonProperty("chartData2")
                private final List<Map<String, Object>> chartData2;
            
                @JsonProperty("chartData3")
                private final List<Map<String, Object>> chartData3;
            
                
                // ---------- Constructor and Getters -------------------
                public GetDashboardDataDTO(List<Map<String, Object>> chartData1, List<Map<String, Object>> chartData2, List<Map<String, Object>> chartData3) {
                    this.chartData1 = chartData1;
                    this.chartData2 = chartData2;
                    this.chartData3 = chartData3;
                }
            
                public List<Map<String, Object>> getChartData1() {
                    return chartData1;
                }
            
                public List<Map<String, Object>> getChartData2() {
                    return chartData2;
                }
            
                public List<Map<String, Object>> getChartData3() {
                    return chartData3;
                }
            }


    2. Create a back-end java service:  DashboardService
        a. Right-click on backend/src/main/java/com/lessons/services -> New Java Class
           Class Name:  DashboardService

        b. Replace the class contents with this:
            
            package com.lessons.services;
            
            import com.lessons.models.GetDashboardDataDTO;
            import org.slf4j.Logger;
            import org.slf4j.LoggerFactory;
            import org.springframework.stereotype.Service;
            import java.time.LocalDate;
            import java.time.ZoneId;
            import java.util.*;
            
            @Service("com.lessons.services.DashboardService")
            public class DashboardService {
                private static final Logger logger = LoggerFactory.getLogger(DashboardService.class);
            
                /**
                * Get all chart data for 3 charts
                *
                * @return GetDashboardDataDTO wrapper object that holds data for all charts
                */
                public GetDashboardDataDTO getAllChartData() {
                    logger.debug("getAllChartData() starated.");
            
                    List<Map<String, Object>> data1 = getListOfMapsForChart1();
                    List<Map<String, Object>> data2 = getListOfMapsForChart2();
                    List<Map<String, Object>> data3 = getListOfMapsForChart3();
            
                    // Create the DTO to that holds all of the chart data and return it
                    GetDashboardDataDTO dto = new GetDashboardDataDTO(data1, data2, data3);
                    return dto;
                }
            
            
                /**
                * Returns data that looks like this on the front-end
                *	let chartData1 =  [
                *   	{
                *     	name: "Item 3",
                *     	y: 989
                *   	},
                *   	{
                *     	name: "Item 3R",
                *     	y: 249
                *   	}
                * 	];
                *
                * Get data for chart1
                * @return List of maps
                */
                private List<Map<String, Object>> getListOfMapsForChart1() {
                    List<Map<String, Object>> listOfMaps = new ArrayList<>();
            
                    Map<String, Object> map1 = new HashMap<>();
                    map1.put("name", "Item 3");
                    map1.put("y", 989);
            
                    Map<String, Object> map2 = new HashMap<>();
                    map2.put("name", "Item 3R");
                    map2.put("y", 249);
            
                    Map<String, Object> map3 = new HashMap<>();
                    map3.put("name", "Item 5");
                    map3.put("y", 1035);
            
                    Map<String, Object> map4 = new HashMap<>();
                    map4.put("name", "Item 5R");
                    map4.put("y", 324);
            
                    listOfMaps.add(map1);
                    listOfMaps.add(map2);
                    listOfMaps.add(map3);
                    listOfMaps.add(map4);
            
                    return listOfMaps;
                }
            
            
                /**
                * Returns data that looks like this on the front-end
                * 	let chartData2 = [
                *   	{
                *     	name: 'T3',
                *     	legendIndex: 1,
                *     	data: [300, 5500, 1800, 1600, 1200, 1500, 1000, 800, 500, 400, 1000]
                *   	},
                *   	{
                *     	name: 'T3R',
                *     	legendIndex: 2,
                *     	data: [2, 2, 100, 2, 1]
                *   	}
                * 	];
                *
                * Get data for chart2
                * @return List of maps
                */
                private List<Map<String, Object>> getListOfMapsForChart2() {
                    List<Map<String, Object>> listOfMaps = new ArrayList<>();
            
                    Map<String, Object> map1 = new HashMap<>();
                    map1.put("name", "T3");
                    map1.put("legendIndex", 1);
                    map1.put("data", Arrays.asList(300, 5500, 1800, 1600, 1200, 1500, 1000, 800, 500, 400, 1000) );
            
                    Map<String, Object> map2 = new HashMap<>();
                    map2.put("name", "T3R");
                    map2.put("legendIndex", 2);
                    map2.put("data", Arrays.asList(2, 2, 100, 2, 1) );
            
                    Map<String, Object> map3 = new HashMap<>();
                    map3.put("name", "R5");
                    map3.put("legendIndex", 3);
                    map3.put("data", Arrays.asList(25, 500, 551, 600, 400, 300, 200, 500, 100, 100, 1200) );
            
                    Map<String, Object> map4 = new HashMap<>();
                    map4.put("name", "T5R");
                    map4.put("legendIndex", 4);
                    map4.put("data", Arrays.asList(200, 190, 190, 100, 50, 12, 37, 42, 98, 50, 600) );
            
                    listOfMaps.add(map1);
                    listOfMaps.add(map2);
                    listOfMaps.add(map3);
                    listOfMaps.add(map4);
            
                    return listOfMaps;
                }
            
            
                /**
                *  NOTE:  Epoch Time on the front-end is in MilliSeconds
                *     	Epoch Time in Java is in seconds.  So, multiply java epoch time * 1000
                *
                * Returns data that looks like this on the front-end
                *	let chartData3 =  [{
                *   	name: 'T3',
                *   	data: [
                *     	[1559361600000, 110],             	1559361600000 is 6/1/2019
                *     	[1561939200000, 145],             	1561939200000 is 7/1/2019
                *     	[1564617600000, 135],             	1564617600000 is 8/1/2019
                *     	[1567296000000, 140],             	1567296000000 is 9/1/2019
                *   	]
                * 	},
                * 	{
                *   	name: 'T3R',
                *   	data: [
                *     	[1559361600000, 175],
                *     	[1561939200000, 155],
                *     	[1564617600000, 100],
                *     	[1567296000000, 115],
                *   	]
                * 	}];
                *
                * Get data for chart3
                * @return List of maps
                */
                private List<Map<String, Object>> getListOfMapsForChart3() {
                    List<Map<String, Object>> listOfMaps = new ArrayList<>();
            
            
                    Map<String, Object> map1 = new HashMap<>();
                    map1.put("name", "T3");
                    map1.put("data", Arrays.asList(
                            Arrays.asList( 1559361600000L, 110),
                            Arrays.asList( 1561939200000L, 145),
                            Arrays.asList( 1564617600000L, 135),
                            Arrays.asList( 1567296000000L, 140),
                            Arrays.asList( 1569891600000L, 100),
                            Arrays.asList( 1572570000000L, 110),
                            Arrays.asList( 1575162000000L, 100),
                            Arrays.asList( 1577840400000L,  85),
                            Arrays.asList( 1580518800000L,  70),
                            Arrays.asList( 1583024400000L,  65),
                            Arrays.asList( 1585702800000L,  60),
                            Arrays.asList( 1588294800000L,  60)
                    ));
            
                    Map<String, Object> map2 = new HashMap<>();
                    map2.put("name", "T3R");
                    map2.put("data", Arrays.asList(
                            Arrays.asList( 1559361600000L, 175),
                            Arrays.asList( 1561939200000L, 155),
                            Arrays.asList( 1564617600000L, 100),
                            Arrays.asList( 1567296000000L, 115),
                            Arrays.asList( 1569891600000L, 87),
                            Arrays.asList( 1572570000000L, 90),
                            Arrays.asList( 1575162000000L, 88),
                            Arrays.asList( 1577840400000L,  86),
                            Arrays.asList( 1580518800000L,  75),
                            Arrays.asList( 1583024400000L,  60),
                            Arrays.asList( 1585702800000L,  60),
                            Arrays.asList( 1588294800000L,  45)
                            ));
            
                    Map<String, Object> map3 = new HashMap<>();
                    map3.put("name", "T5");
                    map3.put("data", Arrays.asList(
                            Arrays.asList( 1559361600000L,  230),
                            Arrays.asList( 1561939200000L,  225),
                            Arrays.asList( 1564617600000L,  205),
                            Arrays.asList( 1567296000000L,  210),
                            Arrays.asList( 1569891600000L,  212),
                            Arrays.asList( 1572570000000L,  185),
                            Arrays.asList( 1575162000000L,  187),
                            Arrays.asList( 1577840400000L,  150),
                            Arrays.asList( 1580518800000L,  105),
                            Arrays.asList( 1583024400000L,  85),
                            Arrays.asList( 1585702800000L,  85),
                            Arrays.asList( 1588294800000L,  70)
                    ));
            
                    Map<String, Object> map4 = new HashMap<>();
                    map4.put("name", "T5R");
                    map4.put("data", Arrays.asList(
                            Arrays.asList( 1559361600000L,  240),
                            Arrays.asList( 1561939200000L,  238),
                            Arrays.asList( 1564617600000L,  205),
                            Arrays.asList( 1567296000000L,  200),
                            Arrays.asList( 1569891600000L,  160),
                            Arrays.asList( 1572570000000L,  155),
                            Arrays.asList( 1575162000000L,  148),
                            Arrays.asList( 1577840400000L,  140),
                            Arrays.asList( 1580518800000L,  120),
                            Arrays.asList( 1583024400000L,  85),
                            Arrays.asList( 1585702800000L,  75),
                            Arrays.asList( 1588294800000L,  125)
                    ));
            
                    listOfMaps.add(map1);
                    listOfMaps.add(map2);
                    listOfMaps.add(map3);
                    listOfMaps.add(map4);
            
                    return listOfMaps;
                }
            }

    3. Create a back-end java controller:  DashboardController
        a. Right-click on backend/src/main/java/com/lessons/controllers -> New Java Class
           Class Name:  DashboardController

        b. Replace the class contents with this:
            
            package com.lessons.controllers;
            
            import com.lessons.models.GetDashboardDataDTO;
            import com.lessons.services.DashboardService;
            import org.slf4j.Logger;
            import org.slf4j.LoggerFactory;
            import org.springframework.http.HttpStatus;
            import org.springframework.http.ResponseEntity;
            import org.springframework.stereotype.Controller;
            import org.springframework.web.bind.annotation.RequestMapping;
            import org.springframework.web.bind.annotation.RequestMethod;
            import javax.annotation.Resource;
            
            @Controller("com.lessons.controllers.DashboardController")
            public class DashboardController {
                private static final Logger logger = LoggerFactory.getLogger(DashboardController.class);
            
                @Resource
                private DashboardService dashboardService;
            
                /**
                * REST endpoint /api/dashboard/chart/data
                *
                * @return ResponseEntity object that a GetDashboardDataDTO object and 200 status code
                */
                @RequestMapping(value = "/api/dashboard/chart/data", method = RequestMethod.GET, produces = "application/json")
                public ResponseEntity<?> getChartData() {
            
                    logger.debug("getChartData() started.");
            
                    // Use the DashboardService to get the information from the back-end
                    GetDashboardDataDTO getDashboardDataDTO = this.dashboardService.getAllChartData();
            
                    // Return the DTO object back (Jackson will convert the java object to JSON)
                    return ResponseEntity
                            .status(HttpStatus.OK)
                            .body(getDashboardDataDTO);
                }
            
            }
            

    4. Change the front-end DashboardService to invoke the real REST call
        a. Edit dashboard.service.ts

        b. Inject the front-end httpClient

        c. Change the getAllChartData() method so it returns an observable
            
              public getAllChartData(): Observable<DashboardDataDTO> {
                // Construct the URL of the REST call
                const restUrl = environment.baseUrl + '/api/dashboard/chart/data';
            
                // Return an observable
                return this.httpClient.get <DashboardDataDTO>(restUrl);
              }



    5. Verify that the DashboardComponent is subscribing to this REST call
        a. Examine dashboard.component.ts

        b. Verify that the reloadData() method subscribes to the dashboardService.getAllChartData()
            
              public reloadData(): void {
                this.dataIsLoading = true;
            
                this.dashboardService.getAllChartData().subscribe( (aData: DashboardDataDTO) => {
                    // The REST call came back with data
            
                    // Set the data for chart 1 and *render* chart 1
                    this.chartOptions1.series[0].data = aData.chartData1;
                    Highcharts.chart('chart1', this.chartOptions1);
            
                    this.chartOptions2.series = aData.chartData2;
                    Highcharts.chart('chart2', this.chartOptions2);
            
                    this.chartOptions3.series = aData.chartData3;
                    Highcharts.chart('chart3', this.chartOptions3);
            
                }).add(  () => {
                    // REST call finally block
            
                    // Redraw all charts on this page (so they fit perfectly in the <mat-card> tags)
                    Highcharts.charts.forEach(function (chart: Chart | undefined) {
                        chart?.reflow();
                    });
            
                    this.dataIsLoading = false;
                });
            
              }




    6. Verify that the charts look good
        a. Activate the Debugger on "Full WebApp"
        b. Click on "Dashboard"
        c. Examine the charts
           -- They should look good (the same as before with the hard-coded data)

```
![](https://lh6.googleusercontent.com/52buH-sFmTpK7XM9Bi97vW0bJinA7ex57YtcLp0_gENd3CvFFvMXxa4SzIr9xaPYwTd79vOAXrMHCvoZZ_QNur7EfquQWxZrShoaPrAJ0Zvw32ZOYCN-h2wgibt4KyXuA_oJ-UAp)
