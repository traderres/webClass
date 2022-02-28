Lesson 17d:  Add Banner / Save Banner State in Database
-------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1wBrPK1sIG67oXplLgqNT2iGV71jl_NGtLuh6_98YHjw/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson17d/toggle-banner-rest-call
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem:  The "Hide Banner" and "Show Banner" buttons do not save information to the back-end.<br>

- So, the web app does not remember the state between page loads<br>

<br>
Solution:<bR>

- Invoke a REST call to get banner info (before the initial app.component.html page loads)<br>

- When a user click "Hide Banner" or "Save Banner" save the information to the database
<br>
<br>
<br>


![](https://lh4.googleusercontent.com/ZthhK0Z_PsCoKtF4iZ9V814NDkE35dt17LCaCQaE1S09E8UbhcCeKE2d8BQpQWfjyIgwQEVrEkkxAH6s_iq3lrkpwG69BoyGn4OcUeIWlgu_hLOTxzNGnyWN5-0QljqfTbO6s1Up)

<br>
<br>

```
Part 1:  Create the Back-end REST Calls to Get and Set Preferences
------------------------------------------------------------------
    1. Create the preferences database table
        a. Right-click on backend/src/main/resources/db/migration -> New File
           Filename:  V1.5__preferences.sql

           WARNING:  Make sure there are no leading or trailing spaces in the filename!!
           WARNING:  Make sure the file starts with a capital V
           WARNING:  Make sure the file ends with .sql   

           These are Flyway's rules.  Please follow them or suffer serious head banging!!!



        b. Copy this to the new file 
            
            --------------------------------------------------------------
            -- Filename:  V1.5__preferences.sql
            --------------------------------------------------------------
            
            -- Create the preferences table
            create table preferences (
                id                	integer PRIMARY KEY,
                userid            	integer NOT NULL,
                show_banner       	boolean
            );
            


        c. Verify that flyway sees the v1.5 file   (by running flyway:info)
           unix> cd ~/intellijProjects/angularApp1/backend
           unix> mvn flyway:info

            You should see the 1.5 as "Pending":
            +-----------+---------+------------------------------+--------+---------------------+---------+
            | Category  | Version | Description                  | Type   | Installed On        | State   |
            +-----------+---------+------------------------------+--------+---------------------+---------+
            |           |         | << Flyway Schema Creation >> | SCHEMA | 2021-05-19 22:40:35 | Success |
            | Versioned | 1.1     | baseline                     | SQL	  | 2021-05-19 22:40:35 | Success |
            | Versioned | 1.2     | lookup tables                | SQL    | 2021-05-19 22:40:35 | Success |
            | Versioned | 1.3     | reports                      | SQL    | 2021-05-19 22:40:35 | Success |
            | Versioned | 1.4     | jobs                         | SQL    | 2021-05-19 22:40:35 | Success |
            | Versioned | 1.5     | preferences                  | SQL    |                     | Pending |
          

        d. Migrate the database
           unix> cd ~/intellijProjects/angularApp1/backend
           unix> mvn flyway:migrate


        e. Verify that flyway sees v1.5 as success
           unix> cd ~/intellijProjects/angularApp1/backend
           unix> mvn flyway:info

            You should see the 1.5 as "Success":
            +-----------+---------+------------------------------+--------+---------------------+---------+
            | Category  | Version | Description                  | Type   | Installed On        | State   |
            +-----------+---------+------------------------------+--------+---------------------+---------+
            |           |         | << Flyway Schema Creation >> | SCHEMA | 2021-05-19 22:40:35 | Success |
            | Versioned | 1.1     | baseline                     | SQL	  | 2021-05-19 22:40:35 | Success |
            | Versioned | 1.2     | lookup tables                | SQL    | 2021-05-19 22:40:35 | Success |
            | Versioned | 1.3     | reports                      | SQL    | 2021-05-19 22:40:35 | Success |
            | Versioned | 1.4     | jobs                         | SQL    | 2021-05-19 22:40:35 | Success |
            | Versioned | 1.5     | preferences                  | SQL    | 2021-05-19 22:40:35 | Success |
            


    2. Create a back-end model:  GetPreferenceDTO
        a. Right-click on backend/src/main/java/com/lessons/models -> New Java Class
           Class Name:  GetPreferenceDTO

        b. Replace its contents with the following::
                
                package com.lessons.models;
                
                import com.fasterxml.jackson.annotation.JsonProperty;
                
                public class GetPreferenceDTO {
                    
                    @JsonProperty("showBanner")
                    private final boolean showBanner;
                    
                    // ------------------- Constructor & Getters -------------------
                
                    public GetPreferenceDTO(boolean showBanner) {
                        this.showBanner = showBanner;
                    }
                
                    public boolean isShowBanner() {
                        return showBanner;
                    }
                }
                
                


    3. Add a back-end service:  PreferenceService
        a. Right-click on backend/src/main/java/com/lessons/services -> New Java Class
           Class Name:  PreferenceService

        b. Replace its contents with the following:
                
                package com.lessons.services;
                
                import com.lessons.models.GetPreferenceDTO;
                import org.slf4j.Logger;
                import org.slf4j.LoggerFactory;
                import org.springframework.jdbc.core.JdbcTemplate;
                import org.springframework.jdbc.support.rowset.SqlRowSet;
                import org.springframework.stereotype.Service;
                
                import javax.annotation.Resource;
                import javax.sql.DataSource;
                
                @Service("com.lessons.services.PreferenceService")
                public class PreferenceService {
                    private static final Logger logger = LoggerFactory.getLogger(PreferenceService.class);
                
                    @Resource
                    private DataSource dataSource;
                
                
                    /**
                    * Get all preferences for this userid
                    * @param aUserid holds the unique number that identifies this user
                    * @return GetPreferenceDTO object that holds all preferences
                    */
                    public GetPreferenceDTO getPreferences(int aUserid) {
                        GetPreferenceDTO dto;
                
                        // Construct the SQL to get all preferences for this userid
                        String sql = "Select show_banner from preferences where userid=?";
                
                        JdbcTemplate jt = new JdbcTemplate(this.dataSource);
                
                        SqlRowSet rs = jt.queryForRowSet(sql, aUserid);
                        if (! rs.next() ) {
                            // No records were found in the database for this user.  So, return default values
                            dto = new GetPreferenceDTO(true);
                        }
                        else {
                            // one record was found in the database
                            boolean showBanner = rs.getBoolean("show_banner");
                
                            dto = new GetPreferenceDTO(showBanner);
                        }
                
                        // Return the GetPreferenceDTO object
                        return dto;
                    }
                
                
                    /**
                    * Set the banner preference in the database
                    * @param aUserid holds the unique number that identifies this user
                    * @param aBannerValue holds the new banner value to store in the database
                    */
                    public void setBanner(int aUserid, Boolean aBannerValue) {
                        // Construct the SQL to update this record in the database
                        String sql = "update preferences set show_banner=? where userid=?";
                
                        JdbcTemplate jt = new JdbcTemplate(this.dataSource);
                
                        // Execute the sql to update this record
                        int rowsUpdated = jt.update(sql, aBannerValue, aUserid);
                
                        if (rowsUpdated == 0) {
                            // The record was not found, so insert a record
                            sql = "insert into preferences(id, show_banner, userid) " +
                                "values( nextval('seq_table_ids'), ?, ?);";
                
                            // Insert a new record in the database
                            int rowsInserted = jt.update(sql, aBannerValue, aUserid);
                
                            if (rowsInserted != 1) {
                                // I should have inserted 1 record, but did not
                                throw new RuntimeException("Error in setBanner():  I expected to insert 1 record.  Instead, I inserted " + rowsInserted + " records.");
                            }
                        }
                        else if (rowsUpdated > 1) {
                            // I updated multiple records -- this should never happen
                            throw new RuntimeException("Error in setBanner():  I expected to update 1 record.  Instead, I updated " + rowsUpdated + " records.");
                        }
                    }
                
                }
                



    4. Add a back-end controller:  PreferenceController
        a. Right-click on backend/src/main/java/com/lessons/controllers -> New Java Class
           Class Name:  PreferenceController

        b. Replace its contents with the following:
                
                package com.lessons.controllers;
                
                import com.lessons.models.GetPreferenceDTO;
                import com.lessons.services.PreferenceService;
                import org.slf4j.Logger;
                import org.slf4j.LoggerFactory;
                import org.springframework.http.HttpStatus;
                import org.springframework.http.ResponseEntity;
                import org.springframework.stereotype.Controller;
                import org.springframework.web.bind.annotation.PathVariable;
                import org.springframework.web.bind.annotation.RequestMapping;
                import org.springframework.web.bind.annotation.RequestMethod;
                
                import javax.annotation.Resource;
                
                @Controller("com.lessons.controllers.PreferenceController")
                public class PreferenceController {
                    private static final Logger logger = LoggerFactory.getLogger(PreferenceController.class);
                
                    @Resource
                    private PreferenceService preferenceService;
                
                
                    /**
                    * GET /api/preferences/banner REST call
                    *
                    * Returns a PreferenceDTO object that holds information about this preference
                    */
                    @RequestMapping(value = "/api/preferences/all", method = RequestMethod.GET, produces = "application/json")
                    public ResponseEntity<?> getPreferences() {
                
                        logger.debug("getPreferences() started.");
                
                        int loggedInUserId = 25;
                
                        // Get the preference information
                        GetPreferenceDTO preferenceDTO = this.preferenceService.getPreferences(loggedInUserId);
                
                        // Return the GetPreferenceDTO back to the front-end and a 200 status code
                        return ResponseEntity
                                .status(HttpStatus.OK)
                                .body(preferenceDTO);
                    }
                
                    /**
                    * POST /api/preferences/banner/set/{bannerValue} REST call
                    *
                    * This REST call sets the banner preference only
                    * Returns 200 status code if it works
                    */
                    @RequestMapping(value = "/api/preferences/banner/set/{bannerValue}", method = RequestMethod.POST, produces = "application/json")
                    public ResponseEntity<?> setBannerPreference(@PathVariable(value="bannerValue") Boolean aBannerValue) {
                
                        logger.debug("setBannerPreference() started.  aBannerValue={}", aBannerValue);
                
                        int loggedInUserId = 25;
                
                        // Set the banner preference
                        this.preferenceService.setBanner(loggedInUserId, aBannerValue);
                
                        // Return a 200 status code and a null object
                        return ResponseEntity
                                .status(HttpStatus.OK)
                                .body(null);
                    }
                
                }
                
                


    5. Verify that the REST call works
        a. Activate your Debugger on "Backend"

        b. Set a breakpoint in your PreferenceController.getPreferences() 

        c. Set a breakpoint in your PreferenceController.setBannerPreference()

        d. Go to your database console and run his SQL:

            Select * from preferences

            -- You should see zero records


        e. Use Postman to set the banner preference to true for userid 25
           NOTE:  If no record is found, then this 
            i.   Set the url to http://localhost:8080/app1/api/preferences/banner/set/true

            ii.  Set the type to POST

            iii. In Headers
                 Key="Accept"		Value="application/json"

            iv.  Press "Send"


        f. You should hit one of your breakpoints
           -- Press F9 to continue

        g. Go to your database console and run his SQL:

           Select * from preferences

           -- You should see 1 record with userid=25 and show_banner=true


        h. Use Postman to get all preferences
            i.   Set the url to http://localhost:8080/app1/api/preferences/all

            ii.  Set the type to GET

            iii. In Headers
                 Key="Accept"		Value="application/json"

            iv. Press "Send"
                
                You should see this:
                
                {
                   "showBanner": true
                }
                





Part 2:  Setup the Frontend to Get the Preferences on Page Load
---------------------------------------------------------------
    6. Create the PreferencesDTO
        a. Create the model class
           unix> cd ~/intellijProjects/angularApp1/frontend
           unix> ng generate class models/PreferencesDTO --skipTests

        b. Add a public property
                public showBanner: boolean;



    7. Adjust the Banner Service
        a. Edit banner.service.ts


        b. Inject the httpClient


        c. Add a public method called getLatestValueFromBackend() 
            
              public getLatestValueFromBackend(): Observable<PreferencesDTO> {
                // Construct the URL for the REST endpoint  (to get all preferences)
                const restUrl = environment.baseUrl + '/api/preferences/all';
            
                // NOTE:  The REST call is not invoked you call subscribe() on this observable
                return this.httpClient.get <PreferencesDTO> (restUrl);
              }



        d. Add a private method that setsValueInBackend

              private setLatestValue(aBannerInfo: boolean): Observable<object> {
                // Construct the URL for the REST endpoint  (to set the banner preference only)
                const restUrl = environment.baseUrl + '/api/preferences/banner/set/' + aBannerInfo;
            
                // Return an observable to this POST REST call
                // -- The 2nd {} is the empty json body sent to the REST call
                // -- The 3rd {} is the empty map of options
                return this.httpClient.post(restUrl, {}, {} );
              }



        e. Add a public method called initialize()

            public initialize(aBannerInfo: boolean) {
                // Send out a message that (to anyone listening) with the current value
                // Anyone who listens later, gets this initial message
                this.bannerStateSubject.next(aBannerInfo);
            }



        f. Change the hideBanner() method to invoke the REST call  and then send the message out

              public hideBanner(): void {
                this.setLatestValue(false).subscribe( () => {
                    // REST call came back successfully
            
                    // Send a message with false  (to tell anyone listening to hide the banner)
                    this.bannerStateSubject.next(false);
                })
              }



        g. Change the showBanner() method to invoke the REST call  and then send the message out

              public showBanner(): void {
                this.setLatestValue(true).subscribe( () => {
                    // REST call came back successfully
            
                    // Send a message with false  (to tell anyone listening to hide the banner)
                    this.bannerStateSubject.next(true);
                })
              }



    8. Adjust the app.component.ts
        a. Edit app.component.ts

        b. Add a public variable:
             public bannerObs: Observable<PreferencesDTO>

        c. Inject the banner service

        d. Add this call to the ngOnInit() to setup the observable to initialize the bannerService

            this.bannerObs = this.bannerService.getLatestValueFromBackend().pipe(
              tap((aData: PreferencesDTO) => {
                // The REST call came back with some data
            
                // Initialize the banner service
                this.bannerService.initialize(aData.showBanner);
              })
            );
             


    9. Add an Async Pipe to the main page so that nothing loads until the bannerService is initialized
        a. Edit app.component.html

        b. Put this around the existing HTML
              <ng-container *ngIf="this.bannerObs | async">
                <!-- The banner info has been loaded.  So, display the rest of the page -->
            
                ...
            
            </ng-container>


    10. Verify that it works
        a. Activate the Debugger on "Full WebApp"
        b. Connect to the webapp at http://localhost:4200
           -- Your webapp should be waiting at your PreferenceController.getPreferences() breakpoint
           -- Your webapp should show a blank page while this REST endpoint is hangin

        c. Remove the breakpoints in your PreferenceController

        d. Click on the "John.Smith" and select "Hide Banner"

        e. Open a new tab and connect to the webapp at http://localhost:4200
           -- The new tab should hide the banner on page load (as it's stored in the database)


```
