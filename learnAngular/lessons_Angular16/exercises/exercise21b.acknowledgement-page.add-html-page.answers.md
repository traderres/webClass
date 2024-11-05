```8
Exercise 21b / Acknowledgement Page / Add HTML Page  (Answers)
--------------------------------------------------------------



Part 1 / Setup the Page with a button that invokes your acknowledge REST call
-----------------------------------------------------------------------------
 1. Setup the Page
    a. Generate the component:                Call it AcknowledgementPage
    b. Add the route to constants.ts:         the route will be this:   page/acknowledgement
    c. Register the route
    d. Add the route to the database table:  ui_controls        (if using real security)
    e. Add a link to the navbar (using that route)
    f. Use the debugger to verify that the navbar link works



 2. Setup this page layout
     +-------------------------------------------------------------------+
     |                    Acknowledgement Page                           |
     |                                                                   |
     |                      <Acknowledge Btn>                            |
     +-------------------------------------------------------------------+


 3. Create the frontend AcknowledgementService
     a. Create the frontend DTO:  AcknowledgementStatusDTO
        -- It should have the same boolean as that used in your backend
        
    b. Create the frontend service:  AcknowledgementService
    
    c. Edit acknowledgemen.service.ts / inject the httpClient
    
    c. Edit acknowledgemen.service.ts / add a public method:  getUserAcknowledged()
        -- What is passed-in?  Nothing
        -- What is returned?   Observable that holds AcknowledgementStatusDTO
        -- Use the httpClient to create an observable hooked-up to your get-acknowledgement-status REST call
        
        
 3. Change the main page so that it shows your acknowledgement page if the user has not acknowledged
    a. Edit app.component.ts / Inject the AcknowledgementService
    
    b. Edit app.component.ts / Add a class variable
                userAcknowledgedObs  / The type is an Observable that holds AcknowledgementStatusDTO
                
    c. Edit app.component.ts / In ngOnInit(), initialize the observable so it's hooked-up to your REST call
    
    
 4. Change the main page so that it invokes an async pipe
    a. Edit app.component.html / Use an async pipe to invoke your observable
    
    b. We 2 if statements in our app.component.html
            if the user has not acknowledged, then show your acknowledgement page
            If the user has     acknowledged, then show everything else
            
      
            <ng-container *ngIf="(this.userAcknowledgedDodConsentObs | async) as userAcknowledgedConsent">
            
              <ng-container *ngIf="! userAcknowledgedConsent.userAcknowledged">
                <!-- User has NOT acknowledged.  So, show the acknowledge page -->
                <app-dod-acknowledgement-page></app-dod-acknowledgement-page>
              </ng-container>
              
                <ng-container  *ngIf="userAcknowledgedConsent.userAcknowledged">
                    <!-- User has acknowledged the DOD Consent.  So, show the header and navbar -->
                
                    <!-- R E S T    O F    M A I N       L A Y O U T     P A G E  -->
                
                </ng-container>
             </ng-container>
             
             
            
            
Part 2:  Send a message from your Acknowledgement Page to the app.component.ts that it should check again to see if the user has acknwoledged
---------------------------------------------------------------------------------------------------------------------------------------------            
 1. Edit acknowledgemen.service.ts
  
    a. Add a class variable 
            subReloadAcknowledgement / type is a subject that holds void / initialize it to be a new subject
        
            private subReloadGettingAcknowledgement: Subject<void> = new Subject();
        
        
        
    b. Add a public method:  listenForMessageToGetAcknowledgementStatus()
        -- It returns the subject as an observable
 
            public listenForMessageToGetAcknowledgementStatus(): Observable<void> {
                return this.subReloadAcknowledgement.asObservable();
            }
 
 
 
    c. Add a public method:  sendMessageToGetAcknowledgementStatus()
        -- It uses the subject to send a message
        
            public sendMessageToGetAcknowledgementStatus(): void {
                this.subReloadAcknowledgement.next();
            }


 2. Edit the main page (app.component.ts)
     a. Change ngOnInit() so it listens for messages to get acknowledgement 
     b. If the main page receives a message, then invoke REST call to get the user's acknowledgement
     
         this.acknowledgementService.listenForMessageToGetAcknowledgementStatus().subscribe( () => {
              // Got a message to reload the main page.  So, re-initialize this observable to cause the page to refresh
              this.userAcknowledgedObs = this.acknowledgementService.getUserAcknowledged();
          } );

 3. Nuke your database
 
 4. Try it out
 
 
 
Part 3:  Turn off this behavior by default
------------------------------------------
If the backend REST call always returns a DTO that holds true, then we are *NEVER* prompted for the "Acknowledgement" page 
 
  1. Edit your backend/src/main/resources/application.yaml
  
     a. Add this property to the application.yaml:
            app.skip_acknowledgement: true
            
  
  2. Change your AcknowledgementService to look at this flag
     a. Edit AcknowledgementService.java
     
     
     b. Add a class variable that holds a boolean and injects the value from the application.yaml
     
         @Value("${app.skip_acknowledgement:false}")
         private boolean skipAcknowledgement;
            
     
     c. Change the method that gets the current acknowledgement status
        -- If skipAcknowledgement holds TRUe, then do not query the databas -- instead return a DTO that holds true
        
        
```


