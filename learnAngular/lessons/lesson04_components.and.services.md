Lesson 4: Using Components & Services
--------------------------------------
The Google Drive link is found here:
   https://docs.google.com/document/d/1vtt0lr6f05gcN642X8saS1D0JB4eNNB6-V7LPu1m95g/edit?usp=sharing
      

The source code for this lesson is here:
   https://github.com/traderres/angularApp1Lessons/tree/lesson4/components_and_services

  
  


Key Points:

- The Angular Web App is a tree of components
- Components share services
- Only one instance of each service exists (it is automatically instantiated)

  

```
Exercise
    1. Generate a Welcome Component
        unix> cd ~/intellijProjects/angularApp1/frontend
        unix> ng generate component welcome

        You should see the following:
            CREATE src/app/welcome.component.css (0 bytes)
            CREATE src/app/welcome.component.html (25 bytes)
            CREATE src/app/welcome.component.spec.ts (650 bytes)
            CREATE src/app/welcome.component.ts (290 bytes)
            UPDATE src/app/app.module.ts (606 bytes)


    2. Generate a View Reports Component
        unix> cd ~/intellijProjects/angularApp1/frontend
        unix> ng generate component reports/viewReports
        
        You should see the following:
            CREATE src/app/reports/view-reports/view-reports.component.css (0 bytes)
            CREATE src/app/reports/view-reports/view-reports.component.html (25 bytes)
            CREATE src/app/reports/view-reports/view-reports.component.spec.ts (650 bytes)
            CREATE src/app/reports/view-reports/view-reports.component.ts (290 bytes)
            UPDATE src/app/app.module.ts (606 bytes)



NOTES:
  If you add --dry-run to the ng generate command, you will see what ng generate would do
  If you add --skip-tests then the test class is not generated


    3. Generate a Report Service
        unix> cd ~/intellijProjects/angularApp1/frontend
        unix> ng generate service services/report


    4. Take a look at what you generated
        -- Tell me what you see


Questions
    1. What's the difference between a component and a service?
        a. Components are created and destroyed as you navigate throughout the app
        b. Services are "injectable" -- i.e., we can access it from other components using constructor injection
        c. Components have HTML

    2. When should you use components?


    3. When should you use services?



Part 2:  Modify app.component.html
    1. Edit app.component.html

    2. It should look like this:
        <app-add-report> </app-add-report>

        Change it to this:
            <app-add-report></app-add-report>
            <app-add-report></app-add-report>


    3. Take a look
        a. Activate your debugger by selecting "Full WebApp" and Press the debug button
        b. In the browser, you should see the "Add Report" page duplicated




Part 3:  Inject your ReportService into the AddReport Component
    1. Edit the report.service.ts and add a method
        a. Edit report.service.ts

        b. Add this public method:

          /*
           * showMessage()  Demonstrate Sharing Code
           */
          public showMessage(aMessage: string): void {
            console.log('Here is the message: ' + aMessage);
          }


    2. Inject the ReportService into your AddReport page
        a. Edit add-report.component.ts

        b. Change the constructor

            from this:
               constructor() { }
            
            To this:
               constructor(private reportService: ReportService) { }


    3. Call the reportService.showMessage() from the reset and save methods
        a. Edit add-report.component.ts

        b. Change the reset method to this:

  public reset() {
	this.report.name = "";
	this.report.priority = 0;
	this.report.source = 0;
	this.report.authors = "";

	this.reportService.showMessage('User pressed RESET');
  }


    4. Try it out
        a. Activate your debugger
        b. Press the "Reset" button
            -- You should see the message in the console
```
