```
Exercise 25k / Change the Chart Theme Dynamically  (Answer)
-----------------------------------------------------------
Problem:  I want to change the theme of my chart


```
![](../images/exercise25k_image1.png)

![](../images/exercise25k_image2.png)
```




Part 1 / Adjust the full chart page's context menu so it can adjust the theme
-----------------------------------------------------------------------------
 1. Edit the small pie chart page / TypeScript
 
 2. Change the context menu so it has a light mode and dark mode options
    a. Add in the context options (so we're not using the default ones)
    
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
           
           
     
    b. Add a method:  toggleChartTheme()
       -- This method have a logger statement for now
 
            private toggleChartTheme(): void {
                 console.log('toggleChartTheme() started');
            } 
            
               
                  
    c. Add the custom Context Menu option
       
            {
                text: 'Toggle Chart Theme',
                onclick: () => {
                    this.toggleChartTheme()
                }
            }          
       
       
       When finished, the exporting section looks like this:
       
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
                    'viewData',
                    'separator',
                    {
                      text: 'Toggle Chart Theme',
                      onclick: () => {
                        this.toggleChartTheme()
                      }
                    }
                  ]
                }
              }
            },       
           
    d. Verify that the button works
    
    
    
Part 2 / Add the Dark Unica Theme to your Chart Service
-------------------------------------------------------
 1. Get the dark mode javascript from highcharts
    -- Open up frontend/node_modules/highcharts/themes/dark-unica.src.js
    
    -- Copy the code lines 62 to 252
    
              DarkUnicaTheme.options = {
                colors: [
  
              }
              
 2. Insert the dark theme into your chart service (so that many charts can use it)
    a. Edit your frontend chart service
    
    b. Add a public class variable:  darkUnicaTheme
               public darkUnicaTheme: any;
   
   
    c. Set your public class variable to hold that large object
                
            public darkUnicaTheme: any = {
                colors: [
                    '#2b908f', '#90ee7e', '#f45b5b', '#7798BF', '#aaeeee', '#ff0066',
                    '#eeaaee', '#55BF3B', '#DF5353', '#7798BF', '#aaeeee'
                ],
                chart: {
                    backgroundColor: {
                        linearGradient: { x1: 0, y1: 0, x2: 1, y2: 1 },
                        stops: [
                            [0, '#2a2a2b'],
                            [1, '#3e3e40']
                        ]
                    },
                    style: {
                        fontFamily: '\'Unica One\', sans-serif'
                    },
                    plotBorderColor: '#606063'
                },
                title: {
                    style: {
                        color: '#E0E0E3',
                        textTransform: 'uppercase',
                        fontSize: '20px'
                    }
                },
                subtitle: {
                    style: {
                        color: '#E0E0E3',
                        textTransform: 'uppercase'
                    }
                },
                xAxis: {
                    gridLineColor: '#707073',
                    labels: {
                        style: {
                            color: '#E0E0E3'
                        }
                    },
                    lineColor: '#707073',
                    minorGridLineColor: '#505053',
                    tickColor: '#707073',
                    title: {
                        style: {
                            color: '#A0A0A3'
                        }
                    }
                },
                yAxis: {
                    gridLineColor: '#707073',
                    labels: {
                        style: {
                            color: '#E0E0E3'
                        }
                    },
                    lineColor: '#707073',
                    minorGridLineColor: '#505053',
                    tickColor: '#707073',
                    tickWidth: 1,
                    title: {
                        style: {
                            color: '#A0A0A3'
                        }
                    }
                },
                tooltip: {
                    backgroundColor: 'rgba(0, 0, 0, 0.85)',
                    style: {
                        color: '#F0F0F0'
                    }
                },
                plotOptions: {
                    series: {
                        dataLabels: {
                            color: '#F0F0F3',
                            style: {
                                fontSize: '13px'
                            }
                        },
                        marker: {
                            lineColor: '#333'
                        }
                    },
                    boxplot: {
                        fillColor: '#505053'
                    },
                    candlestick: {
                        lineColor: 'white'
                    },
                    errorbar: {
                        color: 'white'
                    }
                },
                legend: {
                    backgroundColor: 'rgba(0, 0, 0, 0.5)',
                    itemStyle: {
                        color: '#E0E0E3'
                    },
                    itemHoverStyle: {
                        color: '#FFF'
                    },
                    itemHiddenStyle: {
                        color: '#606063'
                    },
                    title: {
                        style: {
                            color: '#C0C0C0'
                        }
                    }
                },
                credits: {
                    style: {
                        color: '#666'
                    }
                },
                drilldown: {
                    activeAxisLabelStyle: {
                        color: '#F0F0F3'
                    },
                    activeDataLabelStyle: {
                        color: '#F0F0F3'
                    }
                },
                navigation: {
                    buttonOptions: {
                        symbolStroke: '#DDDDDD',
                        theme: {
                            fill: '#505053'
                        }
                    }
                },
                // scroll charts
                rangeSelector: {
                    buttonTheme: {
                        fill: '#505053',
                        stroke: '#000000',
                        style: {
                            color: '#CCC'
                        },
                        states: {
                            hover: {
                                fill: '#707073',
                                stroke: '#000000',
                                style: {
                                    color: 'white'
                                }
                            },
                            select: {
                                fill: '#000003',
                                stroke: '#000000',
                                style: {
                                    color: 'white'
                                }
                            }
                        }
                    },
                    inputBoxBorderColor: '#505053',
                    inputStyle: {
                        backgroundColor: '#333',
                        color: 'silver'
                    },
                    labelStyle: {
                        color: 'silver'
                    }
                },
                navigator: {
                    handles: {
                        backgroundColor: '#666',
                        borderColor: '#AAA'
                    },
                    outlineColor: '#CCC',
                    maskFill: 'rgba(255,255,255,0.1)',
                    series: {
                        color: '#7798BF',
                        lineColor: '#A6C7ED'
                    },
                    xAxis: {
                        gridLineColor: '#505053'
                    }
                },
                scrollbar: {
                    barBackgroundColor: '#808083',
                    barBorderColor: '#808083',
                    buttonArrowColor: '#CCC',
                    buttonBackgroundColor: '#606063',
                    buttonBorderColor: '#606063',
                    rifleColor: '#FFF',
                    trackBackgroundColor: '#404043',
                    trackBorderColor: '#404043'
                }
            };

   


    
Part 3 / Change your theme from default to Dark Unica
-----------------------------------------------------
 1. Edit your small chart component
 
 
 2. Inject the chartService  (if you have not already)
 
 
 3. Add a private class variable:  useDarkMode
    -- By default, set it to false
  
      private useDarkMode: boolean = false;
  
  
 4. Edit your toggleChartTheme()
    a. It must flip the useDarkMode flag
    b. It must call reloadData(0;
 
       private toggleChartTheme(): void {
            this.useDarkMode = !this.useDarkMode;
            this.reloadData();
       }


 5. Edit the reloadData() method
    If useDarkMode == true,  then render the chart normally
    If useDarkMode == false, then you want to merge the map and apply the dark unica theme
     
        if (this.useDarkMode) {
          // Render the charts in dark dark unica theme
          Highcharts.chart('pie-chart1',  Highcharts.merge(this.chartOptions, this.chartService.darkUnicaTheme));
        }
        else {
          // Render the charts in light mode
          Highcharts.chart('pie-chart1', this.chartOptions);
        }
    
    
 6. Try it out
   
   
   
   
   
    The completed small chart HTML
    ------------------------------
    <div class="h-full w-full" id="pie-chart1"></div>


    
    The completed small chart TypeScript
    ------------------------------------
    import {AfterViewInit, Component} from '@angular/core';
    
    
    import * as Highcharts from "highcharts";
    window.Highcharts = Highcharts;
    
    // Turn on the high-chart context menu view/print/download options
    import HC_exporting from "highcharts/modules/exporting";
    HC_exporting(Highcharts);
    
    // Turn on the high-chart context menu *export* options
    // NOTE:  This provides these menu options: Download CSV, Download XLS, View Data Table
    import HC_exportData from "highcharts/modules/export-data";
    HC_exportData(Highcharts);
    
    // Do client-side exporting (so that the exporting does *NOT* go to https://export.highcharts.com/
    // NOTE:  This does not work on all web browsers
    import HC_offlineExport from "highcharts/modules/offline-exporting";
    HC_offlineExport(Highcharts);
    
    // Turn on the drill-down capabilities
    import HC_drillDown from "highcharts/modules/drilldown";
    import {Chart} from "highcharts";
    import {ChartService} from "../../../services/chart.service";
    HC_drillDown(Highcharts);
    
    @Component({
      selector: 'app-pie-chart-small',
      templateUrl: './pie-chart-small.component.html',
      styleUrls: ['./pie-chart-small.component.scss']
    })
    export class PieChartSmallComponent implements AfterViewInit {
    
      private useDarkMode: boolean = false;
    
      private chartOptions: any =  {
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
                'viewData',
                'separator',
                {
                  text: 'Toggle Chart Theme',
                  onclick: () => {
                    this.toggleChartTheme()
                  }
                }
              ]
            }
          }
        },
        chart: {
          type: "pie",
        },
        title: {
          text: "Egg Yolk Composition",
        },
        tooltip: {
          valueSuffix: "%",
        },
        subtitle: {
          text: 'Source:<a href="https://www.mdpi.com/2072-6643/11/3/684/htm" target="_default">MDPI</a>',
        },
        plotOptions: {
          series: {
            allowPointSelect: true,
            cursor: "pointer",
            dataLabels: [
              {
                enabled: true,
                distance: 20,
              },
              {
                enabled: true,
                distance: -40,
                format: "{point.percentage:.1f}%",
                style: {
                  fontSize: "1.2em",
                  textOutline: "none",
                  opacity: 0.7,
                },
                filter: {
                  operator: ">",
                  property: "percentage",
                  value: 10,
                },
              },
            ],
          },
        },
        series: [
          {
            name: "Percentage",
            colorByPoint: true,
            data: [],
          },
        ],
      };
    
      public constructor(private chartService: ChartService) {}
    
      private toggleChartTheme(): void {
        this.useDarkMode = !this.useDarkMode;
        this.reloadData();
      }
    
      public ngOnInit(): void {
        // Set options for high-charts
        Highcharts.setOptions( {
          lang: {
            thousandsSep: ','	// Set the thousand separator as a comma
          }
        });
      }
    
    
      public ngAfterViewInit(): void {
        // NOTE:  This call must be in ngAfterViewInit() and not in ngOnInit()
        setTimeout( () => {
          // Reload the data in a setTimeout block so Angular has time to build the page
          this.reloadData();
        });
      }
    
    
      private reloadData(): void {
    
        // Update chart 1 with hard-coded data
        this.chartOptions.series[0].data = [
          {
            name: "Water",
            y: 55.02,
          },
          {
            name: "Fat",
            sliced: true,
            selected: true,
            y: 26.71,
          },
          {
            name: "Carbohydrates",
            y: 1.09,
          },
          {
            name: "Protein",
            y: 15.5,
          },
          {
            name: "Ash",
            y: 1.68,
          },
        ];
    
        if (this.useDarkMode) {
          // Render the charts in dark dark unica theme
          Highcharts.chart('pie-chart1',  Highcharts.merge(this.chartOptions, this.chartService.darkUnicaTheme));
        }
        else {
          // Render the charts in light mode
          Highcharts.chart('pie-chart1', this.chartOptions);
        }
    
      }
    }

```