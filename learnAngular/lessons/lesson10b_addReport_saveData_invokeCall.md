Lesson 10b:  Saving Data / Invoke REST Call
-------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/17Rdi29W36L0Tfh3mThnl80VE6bCVTxGspTRxZwUe7Z8/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson10b/invoke-rest-call
<br>
<br>


<h3>Approach</h3>

1. Create a frontend ReportService (that has a method that invokes the add report REST endpoint)

2. Inject the ReportService into the add-report.component.ts

3. Have add-report2.compoennt.ts save() method call the ReportService.add() method  
   NOTE: The ReportService uses the environment.baseUrl for production and non-production mode  
   - If running in development, the url is http&#x3A;//localhost:8080/app1/api/time


<br>
<br>

```
Procedure
---------
    1. Add the HttpClientModule to the app.module.ts imports: [ ]  statement
        a. Edit app.module.ts

        b. Verify that the HttpClientModule is the imports section   
            
            imports: [
                ...
                HttpClientModule
            ]


    2. Create a Front-end Report Service (IF you have not already created it)
       unix> cd ~/intellijProjects/angularApp1/frontend
       unix> ng generate service services/report --skipTests
         
 

    3. Create a ReportDTO object
       a. Create the ReportDTO class
          unix> cd ~/intellijProjects/angularApp1/frontend
          unix> ng generate class models/AddReportDTO  --skipTests

       b. Fill-in the AddReportDTO class with this:
        
            export class AddReportDTO {
                public name: string | null;
                public priority: number | null;
                public source: number | null;
                public authors: string | null;
                public start_date: Date | null;
                public end_date: Date | null;    
            }


    4. Build your ReportService
        a. Edit report.service.ts

        b. Inject the httpClient object into the constructor

        c. Add a public method called add() that will invoke the REST call

              /*
               * Return an observable that will add a Reports record to the system
               */
              public add(report: AddReportDTO): Observable<string> {
                // Construct the URL for the REST endpoint (so it works in dev and prod mode)
                const restUrl = environment.baseUrl + '/api/reports/add';
        
                // NOTE:  The REST call is not invoked you call subscribe() on this observable
                return this.httpClient.post(restUrl, report, {responseType: 'text'});
              }


    5. Update add-report2.component.ts to use the new ReportService
        a. Edit add-report2.component.ts

        b. Inject the ReportService into the add-report2.component.ts

        c. Adjust your save() method so it invokes the REST endpoint
            
            // Build the AddReportDTO object (which will be sent to the back-end)
            let reportDTO: AddReportDTO = new AddReportDTO();
            reportDTO.name = this.myForm.controls.report_name.value;
            
            // Invoke a service to add a report record
            this.reportService.add(reportDTO).subscribe(response => {
                // REST call succeeded
                this.messageService.showSuccessMessage("Successfully added a new report.");
            
                // Reset the form
                this.myForm.reset();
              },
              response => {
                // REST call failed
                console.error('Failed to create a new report.  Error is ', response?.error);
                this.messageService.showErrorMessage(`Failed to create a new report.  Error is ${response?.error}`);
            
              }).add(  () => {
              // REST call finally block
              console.log('REST call finally block');
            });

        
        NOTE:
        If you have the ErrorInterceptor setup,
        then you might want to comment out the call to showErrorMessage()
        -- If an error occurs, the ErrorInterceptor will display a popup w/the error message
        -- So, there's no need to display 2 errors
                d. When completed, add-report2.component.ts looks something like this:
        
        import {Component, OnInit} from '@angular/core';
        import {FormBuilder, FormGroup, Validators} from "@angular/forms";
        import {ValidatorUtils} from "../../validators/validator-utils";
        import {MessageService} from "../../services/message.service";
        import {LookupService} from "../../services/lookup.service";
        import {LookupDTO} from "../../models/lookup-dto";
        import {Observable} from "rxjs";
        import {Router} from "@angular/router";
        import {ReportDTO} from "../../models/report-dto";
        import {ReportService} from "../../services/report.service";
        
        
        @Component({
          selector: 'app-add-report2',
          templateUrl: './add-report2.component.html',
          styleUrls: ['./add-report2.component.css']
        })
        export class AddReport2Component implements OnInit {
          public myForm: FormGroup;
        
          public prioritiesObs: Observable<LookupDTO[]>;
          public authorsObs: Observable<LookupDTO[]>;
          public reportSourceObs: Observable<LookupDTO[]>;
        
        
        
          constructor(private lookupService: LookupService,
                    private formBuilder: FormBuilder,
                    private messageService: MessageService,
                    private reportService: ReportService,
                    public router: Router)
                    { }
        
        
          public ngOnInit(): void {
        
            // Get the observable a list of LookupDTO objects for priorities
            // NOTE:  The AsyncPipe will subscribe and unsubscribe automatically
            this.authorsObs = this.lookupService.getLookupWithTypeAndOrder("author", "name")
            this.reportSourceObs = this.lookupService.getLookupWithTypeAndOrder("report_source", "name")
            this.prioritiesObs = this.lookupService.getLookupWithTypeAndOrder("priority", "display_order");
        
        
            // Initialize the form object with the proper validators
            this.myForm = this.formBuilder.group({
            report_name: ['initial name',
                [
                Validators.required,  	Validators.minLength(2),      	Validators.maxLength(100)
                ]],
        
            source: ['', Validators.required],
            priority:  ['', Validators.required],
            states: ['', null],
            authors:  ['',
                [
                    Validators.required, ValidatorUtils.validateMultipleSelect(1,2)
                ]]
            });
        
        
            this.myForm.controls.states.valueChanges.subscribe( (value: string) => {
                // User selected a new value in the State Dropdown
                if (value == 'DC') {
                        // User Selected DC -- take the user to the "My Reports" page
                        this.router.navigate( ['page/MyReports'] ).then();
                }
            });
        
          } // end of ngOnInit()
        
        
        
        
        public reset() {
            console.log('user pressed reset');
            this.myForm.reset();
          }
        
        
        public save() {
            console.log('User pressed save.');
        
            // Mark all fields as touched so the user can see any errors
            this.myForm.markAllAsTouched();
        
            if (this.myForm.invalid) {
                // User did not pass validation so stop here
                return;
            }
        
            // Build the ReportDTO object
            let reportDTO: AddReportDTO = new AddReportDTO();
            reportDTO.name = this.myForm.controls.report_name.value;
        
            // Invoke a service to add a report record
            this.reportService.add(reportDTO).subscribe(response => {
                    // REST call succeeded
                    this.messageService.showSuccessMessage(
                                "Successfully added a new report.");
        
                    // Reset the form
                    this.myForm.reset();
            },
            response => {
                    // REST call failed
                    console.error('Failed to create a new report.  Error is ', response?.error);
                    this.messageService.showErrorMessage(`Failed to create a new report.  Error is ${response?.error}`);
        
            }).add(  () => {
                // REST call finally block
                console.log('REST call finally block');
            });
        
          }  // end of save()
        
        
        }
        
        




    6. Verify it works
        a. Startup your debugger to run the Full Web App
        b. Go to "Add Reports 2"
        c. Fill-in all required fields
        d. Press "Save"
           -- You should hit your breakpoint in your java code


    7. Verify that the new report appears in your database
        a. Connect to your database console
        b. Run this sql:
                select * from reports;
           -- Verify that the record appears in your reports table



Part 2:  What happens if the REST call fails?
---------------------------------------------
    8. Change the back-end ReportController to simulate an error
        a. Edit ReportController.java

        b. Add this to your addReport() method:

            int x = 5;
            if (x == 5) {
                   throw new RuntimeException("Something bad happened in this REST call.");
            }


        c. When completed, your addReport method should look like this:
            
            @RequestMapping(value = "/api/reports/add", method = RequestMethod.POST, produces = "application/json")
            public ResponseEntity<?> addReport(@RequestBody AddReportDTO aAddReportDTO) 
                                                throws Exception {
                    logger.debug("addReport() started.");
            
                    int x = 5;
                    if (x == 5) {
                           throw new RuntimeException("Something bad happened in this REST call.");
                    }
            
                    // Adding a report record to the system
                    reportService.addReport(aAddReportDTO);
            
                    // Return a response code of 200
                    return ResponseEntity.status(HttpStatus.OK).body("");
            }


    9. Verify that an error appears
        a. Activate your Full Debugger
        b. Go to the "Add Reports 2" page
        c. Fill in the required forms
        d. Press "Save"
           -- How many error messages do you see?
```
![](https://lh4.googleusercontent.com/QPBaLBXHFulvLq_e-NQtZn2sIXgxiO-GUVDJxlEEitiqfw2uy2inM6j7t1dWyPh04TvIkeyXzfqSBiy-w7wJIg7UUNDsF3B7CIqDDY2xxqmHWVy-jkqn9i4KO4PyA8hpCSwdvtrW)
```




Why did 2 error messages appear?  Because you told it to do so
    • The Error Interceptor listens for ANY REST call that fails
    • Your add-report2.component.ts  save() also calls if a REST call fails with this line:

       this.messageService.showErrorMessage(`Failed to create a new report.  Error is ${response?.error}`);




    10. Since the Error Interceptor has you covered, change the save() method to this:
        We removed the error handler (as the ErrorInterceptor catches ALL failed REST calls)
            
              public save(): void {
            
                // Mark all fields as touched so the user can see any errors
                this.myForm.markAllAsTouched();
            
                if (this.myForm.invalid) {
                // User did not pass validation so stop here
                return;
                }
            
                // Build the ReportDTO object
                let reportDTO: ReportDTO = new ReportDTO();
                reportDTO.name = this.myForm.controls.report_name.value;
            
                // Invoke a service to add a report record
                this.reportService.add(reportDTO).subscribe(response => {
                        // REST call succeeded
                        this.messageService.showSuccessMessage("Successfully added a new report.");
            
                        // Reset the form
                        this.myForm.reset();
                },
                ).add(  () => {
                        // REST call finally block
                        console.log('REST call finally block');
                });
              }


    11. Verify that only the Error Interceptor picks-up the error
        a. Activate the Full Debugger -> Web App
        b. Go to the "Add Reports 2" page
        c. Fill in the required fields
        d. Press "Save"

           You should only see the Error Interceptor message
```
![](https://lh6.googleusercontent.com/9moHuGqLCXE6of2ZeHDhUojzX__6ubi8wFJCD7nwPXqMrfbwGws6oIaWUfFktsvfcEHjmbymnKUhz49CZ06z4SFFRPxivsiPu_7CTxUIaKI1MXHsyIebxfAKQtHp6WrhfGgUyKj_)
```
Because you have the Error Interceptor watching ALL REST calls, you do not need code to add code if a REST call fails.






    12. Adjust the REST call so it does not blow up
        a. Edit ReportController.java
        b. Remove the throw new RuntimeException code
            
           So, your addReport() method looks like this:
                
                 @RequestMapping(value = "/api/reports/add", method = RequestMethod.POST, produces = "application/json")
                 public ResponseEntity<?> addReport(@RequestBody AddReportDTO aAddReportDTO) throws Exception {
                    logger.debug("addReport() started.");
                
                    // Adding a report record to the system
                    reportService.addReport(aAddReportDTO);
                
                    // Return a response code of 200
                    return ResponseEntity.status(HttpStatus.OK).body("");
                }


    13. Verify that the REST call works
        a. Activate the Full Debugger -> Web App
        b. Go to the "Add Reports 2" page
        c. Fill in the required fields
        d. Press "Save"
           -- It should create the record in the database


```
