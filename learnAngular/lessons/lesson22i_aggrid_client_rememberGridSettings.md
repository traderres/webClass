Lesson 22i:  Ag Grid / Client Side / Remember Grid Columns & Sorting / Preferences REST endpoint
------------------------------------------------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1qwfz-sfCxjvK0uvMiOX1RDcQ9X4q6sHHELM5pPKwERc/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson22i
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem:     The grid does not remember column width, column order, sorting<br>
Solution: <br>
(1) When the user moves or resizes a grid or sorts, save that preference information.<br>  
(2) When the grid page is loaded, then retrieve that preference information<br><br>

    

The net effect is that the grid appears to "remember" its last state.
+ The grid remembers the user's column order  (in case the user drags & drops columns over)
+ The grid remembers the column widths
+ The grid remembers which columns are visible/invisible
+ The grid remembers the user's sorting 

Finally, we can cache this information on the front-end (to reduce the number of REST calls)
```


Approach for Saving Grid State
------------------------------
    1. Backend:  Add a user_preference table  (this is a generic preferences mechanism)
    2. Backend:  Add REST calls to get & set preferences
    3. Frontend:  Upon page load, get the grid state from the database
        a. The Preferences Service will pull it from a database table as a Json string
        b. The JSON is converted to an object
        c. That object is stored in the grid
    4. Frontend:  When the user sorts, resizes, hides a grid column
        a. Get the grid state
        b. Send a message saying that the grid state has been updated (and provide the updated state)
        c. The page will listen for these messages
            i.  If there are lots of grid state messages, then take the LAST message over 250 msecs
                (so, if the user clicks to sort a column 3 times, then the page stores the LAST grid state)

            ii. Invoke a REST call to save that information to the backend
                NOTE:  This is done quietly (so there is no spinner)


Procedure
---------
    1. Add a user_preference table  (this is a generic preferences mechanism)
        a. Add this file:  V1.6__user_preferences.sql
            i.  Edit the backend/src/main/resources/db/migration/
            ii. Right-click on migration -> New File
                Filename:  V1.6__user_preferences.sql

        b. Copy this to your new file
        
        --------------------------------------------------------------
        -- Filename:  V1.6__user_preferences.sql
        --------------------------------------------------------------
        
        
        -----------------------------------------------------------------------------
        -- Create this table:  Users
        -----------------------------------------------------------------------------
        create table Users
        (
            id           	integer  	not null,
            version      	integer  	not null default (1),
            full_name    	varchar(200) null,
            user_name    	varchar(100) not null,
            is_locked    	boolean  	not null,
            last_login_date  timestamp	not null default now(),
            unique(user_name),
            primary key(id)
        );
        comment on table Users is 'The Users table holds information about each registered user';
        
        
        -----------------------------------------------------------------------------------------
        -- Create this table:  user_preferences
        -- NOTE:  This table does not have a unique ID.  Instead the userid, page, name is unique
        -----------------------------------------------------------------------------------------
        create table user_preferences (
          userid            	integer 	NOT NULL,
          page              varchar     	NULL,
          name              varchar(50)  NOT NULL,
          value             text    	NOT NULL,
          constraint userpreferences_userid FOREIGN KEY(userid) references users(id),
          unique(userid, page, name)
        );
        comment on table user_preferences is 'The user_preferences table holds preferences for each user';
        
        


        c. Update your local database
           unix> cd backend
           unix> mvn flyway:migrate


        d. Verify that flyway ran successfully
           unix> mvn flyway:info
            
            You should see Version 1.6 user preferences Success
             Versioned  | 1.6 	| user preferences         	| SQL	| 2021-08-13 18:53:11 | Success



    2. Edit UserService.java
        a. Inject the DatabaseService
            @Resource
            private DatabaseService databaseService

        b. Add this method:
            
            private void updateLastLoginDate(Integer aUserId) {
                    TransactionTemplate tt = new TransactionTemplate();
                    tt.setTransactionManager(new DataSourceTransactionManager(dataSource));
            
                    // This transaction will throw a TransactionTimedOutException after 60 seconds (causing the transaction to rollback)
                    tt.setTimeout(60);
            
                    tt.execute(new TransactionCallbackWithoutResult()
                    {
                        protected void doInTransactionWithoutResult(TransactionStatus aStatus) {
                            // All database calls in this block are part of a SQL Transaction
            
                            // Construct the SQL to set the last login date
                            String sql = "update users set last_login_date = now() where id = :userId";
            
                            Map<String, Object> paramMap = new HashMap<>();
                            paramMap.put("userId", aUserId);
            
                            NamedParameterJdbcTemplate np = new NamedParameterJdbcTemplate(dataSource);
            
                            // Executing SQL to update the users record
                            int totalRowsUpdated = np.update(sql, paramMap);
            
                            if (totalRowsUpdated != 1) {
                                throw new RuntimeException("Error in updateLastLoginDate(). I expected to update 1 record but I actually updated " + totalRowsUpdated);
                            }
                        }
                    });
                }
             


        c. Replace getOrAddUserRecordsToSystem() with this
       
           WARNING!!
           If running in development mode, then use the synchronized for this method
           If running in production mode, then remove the "synchronized" keyword
           WARNING!!

           public synchronized Integer getOrAddUserRecordsToSystem(String aUsername) {
                // This SQL string will check if the id already exists
                String sql = "select id from users where user_name = ?";
        
                JdbcTemplate jt = new JdbcTemplate(this.dataSource);
        
                SqlRowSet rs = jt.queryForRowSet(sql, aUsername);
        
                Integer userId;
        
                if (rs.next()) {
                    // The username exists in the database
                    // Updating the last login date
                    userId = rs.getInt("id");
        
                    updateLastLoginDate(userId);
                }
                else {
                    // The username does not exist in the database
                    // Inserting a new users record
                    userId = insertUsersRecord(aUsername);
                }
        
                return userId;
            }
        
            private Integer insertUsersRecord(String aUsername) {
                TransactionTemplate tt = new TransactionTemplate();
                tt.setTransactionManager(new DataSourceTransactionManager(dataSource));
        
                // This transaction will throw a TransactionTimedOutException after 60 seconds (causing the transaction to rollback)
                tt.setTimeout(60);
        
        
                // Tell the tt object that this method returns a String
                Integer returnedUserId = tt.execute(new TransactionCallback<Integer>()
                {
        
                    @Override
                    public Integer doInTransaction(TransactionStatus aStatus)
                    {
                        // All database calls in this block are part of a SQL Transaction
        
                        // Get the next unique id
                        Integer userId = databaseService.getNextId();
        
                        // Construct the SQL to get these columns of data
                        String sql = "insert into users (id, user_name, full_name, is_locked, last_login_date)\n" +
                                    "values (:userId,  :userName, :fullName, false, now())";
        
                        Map<String, Object> paramMap = new HashMap<>();
                        paramMap.put("userId", userId);
                        paramMap.put("userName", aUsername);
                        paramMap.put("fullName", aUsername);
        
                        NamedParameterJdbcTemplate np = new NamedParameterJdbcTemplate(dataSource);
        
                        // Executing SQL to insert the new user into the users table
                        int totalRowsInserted = np.update(sql, paramMap);
        
                        if (totalRowsInserted != 1) {
                            throw new RuntimeException("Error in insertUsersRecord(). I expected to insert 1 record but I actually inserted " + totalRowsInserted);
                        }
        
                        return userId;
                    }
                });
        
                return returnedUserId;
            }

	
        -- Now, every time a user authenticates, we have a Users database record




    3. Adjust the MyAuthenticationManager so that it creates or updates a Users record upon login
        a. Edit MyAuthenticationManager.java

        b. Edit loadUserDetailsForDevelopment()

            Replace this line:
               Integer userId = 25;
            
            With this line:
                Integer userId = this.userService.getOrAddUserRecordsToSystem(userUID);

        c. Edit loadUserDetailsFromRealSource()
           -- Make sure that the userid is made with the same method call

                Integer userId = this.userService.getOrAddUserRecordsToSystem(userUID);


    4. Add REST calls to get & set preferences
        a. Add this java class:  Constants.java
            i.   Right-click on backend/src/main/java/com/lessons -> New Package
                 Package Name:  Utilities

            ii.  Right-click on Utilities -> New Java Class
                 Class Name:  Constants

            iii. Copy this to your new Constants.java class
                    
                    package com.lessons.utilities;
                    
                    public class Constants {
                    
                        public static final int SQL_TRANSACTION_TIMEOUT_SECS = 60;
                    
                    }



        b. Add this java class:  GetOnePreferenceDTO.java
            i.   Right-click on backend/src/main/java/com/lessons/models -> New Package
                 Package Name:  preferences

            ii.  Right-click on backend/src/main/java/com/lessons/models/preferences -> New Java Class
                 Class Name:  GetOnePreferenceDTO

            iii. Copy this to your class
                    
                    package com.lessons.models.preferences;
                    
                    import com.fasterxml.jackson.annotation.JsonProperty;
                    
                    public class GetOnePreferenceDTO {
                    
                        @JsonProperty("value")
                        private final String value;
                    
                        // ------------------------------- Constructor & Getters ---------------------------------------
                    
                        public GetOnePreferenceDTO(String value) {
                            this.value = value;
                        }
                    
                        public String getValue() {
                            return value;
                        }
                    
                    }


        c. Add this java class:  SetPreferenceWithPageDTO.java
            i.  Right-click on backend/src/main/java/com/lessons/models/preferences -> New Java Class
                Class Name:  SetPreferenceWithPageDTO

            ii. Copy this to your class
                    
                    package com.lessons.models.preferences;
                    
                    import com.fasterxml.jackson.annotation.JsonProperty;
                    
                    public class SetPreferenceWithPageDTO {
                    
                        @JsonProperty("name")
                        private String name;
                    
                        @JsonProperty("value")
                        private String value;
                    
                        @JsonProperty("page")
                        private String page;
                    
                    
                        // --------------------- Getters & Setters --------------------------------
                    
                        public String getName() {
                            return name;
                        }
                    
                        public void setName(String name) {
                            this.name = name;
                        }
                    
                        public String getValue() {
                            return value;
                        }
                    
                        public void setValue(String value) {
                            this.value = value;
                        }
                    
                        public String getPage() {
                            return page;
                        }
                    
                        public void setPage(String page) {
                            this.page = page;
                        }
                    
                    }
                    


        d. Add this java class:  SetPreferenceDTO.java
            i.  Right-click on backend/src/main/java/com/lessons/models/preferences -> New Java Class
                Class Name:  SetPreferenceDTO

            ii. Copy this to your class
                    
                    package com.lessons.models.preferences;
                    
                    import com.fasterxml.jackson.annotation.JsonProperty;
                    
                    public class SetPreferenceDTO {
                    
                        @JsonProperty("name")
                        private String name;
                    
                        @JsonProperty("value")
                        private String value;
                    
                        // --------------------- Getters & Setters --------------------------------
                    
                        public String getName() {
                            return name;
                        }
                    
                        public void setName(String name) {
                            this.name = name;
                        }
                    
                        public String getValue() {
                            return value;
                        }
                    
                        public void setValue(String value) {
                            this.value = value;
                        }
                    
                    }




        e. Update PreferenceService.java by making it more generic
           Replace it with this:
                
                package com.lessons.services;
                
                import com.lessons.models.preferences.GetOnePreferenceDTO;
                import com.lessons.utilities.Constants;
                import org.slf4j.Logger;
                import org.slf4j.LoggerFactory;
                import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
                import org.springframework.jdbc.datasource.DataSourceTransactionManager;
                import org.springframework.jdbc.support.rowset.SqlRowSet;
                import org.springframework.stereotype.Service;
                import org.springframework.transaction.TransactionStatus;
                import org.springframework.transaction.support.TransactionCallbackWithoutResult;
                import org.springframework.transaction.support.TransactionTemplate;
                
                import javax.annotation.Resource;
                import javax.sql.DataSource;
                import java.util.HashMap;
                import java.util.Map;
                
                @Service("com.lessons.services.PreferenceService")
                public class PreferenceService {
                    private static final Logger logger = LoggerFactory.getLogger(PreferenceService.class);
                
                    @Resource
                    private DataSource dataSource;
                
                    private static final String PREFERENCE_WITHOUT_PAGE_VALUE = "ANY";
                
                
                    /**
                    * Get one preference in the system
                    *
                    * @param aUserid holds the unique number that identifies this user
                    * @param aPreferenceName holds the preference name
                    */
                    public GetOnePreferenceDTO getOnePreferenceWithoutPage(int aUserid, String aPreferenceName) {
                        String sql = "Select value from user_preferences where userid=:userid and name=:name and page=:page";
                
                        // Create a parameter map
                        Map<String, Object> paramMap = new HashMap<>();
                        paramMap.put("userid", aUserid);
                        paramMap.put("name",   aPreferenceName);
                        paramMap.put("page",   PREFERENCE_WITHOUT_PAGE_VALUE);
                
                        NamedParameterJdbcTemplate np = new NamedParameterJdbcTemplate(this.dataSource);
                
                        // Execute the sql to get this one value
                        SqlRowSet rs = np.queryForRowSet(sql, paramMap);
                
                        String preferenceValue = null;
                
                        if (rs.next() ) {
                            // there was a value in the database.  So, pull it out
                            preferenceValue  = rs.getString("value");
                        }
                
                        GetOnePreferenceDTO dto = new GetOnePreferenceDTO(preferenceValue);
                        return dto;
                    }
                
                
                    /**
                    * Get one preference in the system
                    *
                    * @param aUserid holds the unique number that identifies this user
                    * @param aPage holds the string that identifies this page
                    * @param aPreferenceName holds the preference name
                    */
                    public GetOnePreferenceDTO getOnePreferenceWithPage(int aUserid, String aPreferenceName, String aPage) {
                        String sql = "Select value from user_preferences where userid=:userid and page=:page and name=:name";
                
                        // Create a parameter map
                        Map<String, Object> paramMap = new HashMap<>();
                        paramMap.put("userid", aUserid);
                        paramMap.put("page",   aPage);
                        paramMap.put("name",   aPreferenceName);
                
                        NamedParameterJdbcTemplate np = new NamedParameterJdbcTemplate(this.dataSource);
                
                        // Execute the sql to get this one value
                        SqlRowSet rs = np.queryForRowSet(sql, paramMap);
                
                        String preferenceValue = null;
                
                        if (rs.next() ) {
                            // there was a value in the database.  So, pull it out
                            preferenceValue  = rs.getString("value");
                        }
                
                        GetOnePreferenceDTO dto = new GetOnePreferenceDTO(preferenceValue);
                        return dto;
                    }
                
                
                    /**
                    * Set one preference in the system
                    *
                    * @param aUserid holds the unique number that identifies this user
                    * @param aPage holds the string that identifies this page
                    * @param aPreferenceName holds the preference name
                    * @param aPreferenceValue holds the preference value
                    */
                    public void setPreferenceValueWithPage(int aUserid, String aPreferenceName, String aPreferenceValue, String aPage) {
                        TransactionTemplate tt = new TransactionTemplate();
                        tt.setTransactionManager(new DataSourceTransactionManager(this.dataSource));
                
                        // This transaction will throw a TransactionTimedOutException after 60 seconds (causing the transaction to rollback)
                        tt.setTimeout(Constants.SQL_TRANSACTION_TIMEOUT_SECS);
                
                        tt.execute(new TransactionCallbackWithoutResult()
                        {
                            protected void doInTransactionWithoutResult(TransactionStatus aStatus)
                            {
                
                                // Construct the SQL to do an UPSERT operation:
                                // -- Attempt to insert the record into the USER_PREFERENCES table.
                                // -- If the insert fails, then update the existing USER_PREFERENCES record
                                String  sql = "insert into user_preferences(userid, page, name, value ) " +
                                            "values( :userid, :page, :name, :value) " +
                                            "on conflict (userid, page, name) " +
                                            "do update set value = :value  ";
                
                                // Create a parameter map (to hold all of the bind variables)
                                Map<String, Object> paramMap = new HashMap<>();
                                paramMap.put("name",	aPreferenceName);
                                paramMap.put("value",   aPreferenceValue);
                                paramMap.put("userid",  aUserid);
                                paramMap.put("page",	aPage);
                
                                NamedParameterJdbcTemplate np = new NamedParameterJdbcTemplate(dataSource);
                
                                // Execute the sql to perform the *UPSERT* operation
                                int rowsUpdated = np.update(sql, paramMap);
                
                                if (rowsUpdated != 1) {
                                    // I should have inserted or updated 1 row but did not
                                    throw new RuntimeException("Error in setPreferenceValueWithPage():  I expected to insert 1 record.  Instead, I inserted " + rowsUpdated + " records.");
                                }
                
                                // TODO: Add Audit Record
                
                                // Commit the transaction if I get to the end of this method
                            }
                        });  // end of sql transaction
                
                    }  // end of setPreferenceValueWithPage()
                
                
                    /**
                    * Set one preference in the system
                    *
                    * @param aUserid holds the unique number that identifies this user
                    * @param aPreferenceName holds the preference name
                    * @param aPreferenceValue holds the preference value
                    */
                    public void setPreferenceValueWithoutPage(int aUserid, String aPreferenceName, String aPreferenceValue) {
                        logger.debug("setPreferenceValueWithoutPage() started aUserid={}  name={}", aUserid, aPreferenceName);
                
                        TransactionTemplate tt = new TransactionTemplate();
                        tt.setTransactionManager(new DataSourceTransactionManager(this.dataSource));
                
                        // This transaction will throw a TransactionTimedOutException after 60 seconds (causing the transaction to rollback)
                        tt.setTimeout(Constants.SQL_TRANSACTION_TIMEOUT_SECS);
                
                        tt.execute(new TransactionCallbackWithoutResult()
                        {
                            protected void doInTransactionWithoutResult(TransactionStatus aStatus)
                            {
                                // Construct the SQL to do an UPSERT operation:
                                // -- Attempt to insert the record into the USER_PREFERENCES table.
                                // -- If the insert fails, then update the existing USER_PREFERENCES record
                                String  sql = "insert into user_preferences(userid, page, name, value ) " +
                                            "values( :userid, :page, :name, :value) " +
                                            "on conflict (userid, page, name) " +
                                            "do update set value = :value  ";
                
                                // Create a parameter map (to hold all of the bind variables)
                                Map<String, Object> paramMap = new HashMap<>();
                                paramMap.put("name",	aPreferenceName);
                                paramMap.put("value",   aPreferenceValue);
                                paramMap.put("userid",  aUserid);
                                paramMap.put("page", PREFERENCE_WITHOUT_PAGE_VALUE);
                
                                NamedParameterJdbcTemplate np = new NamedParameterJdbcTemplate(dataSource);
                
                                // Execute the sql to perform the *UPSERT* operation
                                int rowsUpdated = np.update(sql, paramMap);
                
                                if (rowsUpdated != 1) {
                                    // I should have inserted or updated 1 row but did not
                                    throw new RuntimeException("Error in setPreferenceValueWithoutPage():  I expected to insert 1 record.  Instead, I inserted " + rowsUpdated + " records.");
                                }
                
                                // TODO: Add Audit Record
                
                                // Commit the transaction if I get to the end of this method
                            }
                        });  // end of sql transaction
                
                        logger.debug("setPreferenceValueWithoutPage() finished aUserid={}  name={}", aUserid, aPreferenceName);
                
                    }  // end of setPreferenceValueWithoutPage()
                
                }
                


        f. Update PreferenceController.java
           Replace its contents with these REST endpoints
                
                package com.lessons.controllers;
                
                import com.lessons.models.preferences.GetOnePreferenceDTO;
                import com.lessons.models.preferences.SetPreferenceDTO;
                import com.lessons.models.preferences.SetPreferenceWithPageDTO;
                import com.lessons.services.PreferenceService;
                import com.lessons.services.UserService;
                import org.apache.commons.lang3.StringUtils;
                import org.slf4j.Logger;
                import org.slf4j.LoggerFactory;
                import org.springframework.http.HttpStatus;
                import org.springframework.http.MediaType;
                import org.springframework.http.ResponseEntity;
                import org.springframework.stereotype.Controller;
                import org.springframework.web.bind.annotation.PathVariable;
                import org.springframework.web.bind.annotation.RequestBody;
                import org.springframework.web.bind.annotation.RequestMapping;
                import org.springframework.web.bind.annotation.RequestMethod;
                
                import javax.annotation.Resource;
                
                @Controller("com.lessons.controllers.PreferenceController")
                public class PreferenceController {
                    private static final Logger logger = LoggerFactory.getLogger(PreferenceController.class);
                
                    @Resource
                    private PreferenceService preferenceService;
                
                    @Resource
                    private UserService userService;
                
                
                    /**
                    * GET /api/preferences/get/{preferenceName}/{pageName}  REST call
                    *
                    * Returns the single preference value
                    */
                    @RequestMapping(value = "/api/preferences/get/{preferenceName}/{pageName}", method = RequestMethod.GET, produces = "application/json")
                    public ResponseEntity<?> getPreferenceForPage(@PathVariable(value="preferenceName") String aPreferenceName,
                                                                @PathVariable(value="pageName") String aPageName) {
                        logger.debug("getPreferenceForPage() started.");
                
                        int loggedInUserId = this.userService.getLoggedInUserId();
                
                        // Get the preference value
                        GetOnePreferenceDTO getOnePreferenceDTO = this.preferenceService.getOnePreferenceWithPage(loggedInUserId, aPreferenceName, aPageName);
                
                        // Return the GridPreferenceDTO back to the front-end and a 200 status code
                        return ResponseEntity
                                .status(HttpStatus.OK)
                                .body(getOnePreferenceDTO);
                    }
                
                
                
                    /**
                    * GET /api/preferences/get/{preferenceName}}  REST call
                    *
                    * Returns the single preference value
                    */
                    @RequestMapping(value = "/api/preferences/get/{preferenceName}", method = RequestMethod.GET, produces = "application/json")
                    public ResponseEntity<?> getPreference(@PathVariable(value="preferenceName") String aPreferenceName) {
                        logger.debug("getPreference() started.");
                
                        int loggedInUserId = this.userService.getLoggedInUserId();
                
                        // Get the preference value
                        // NOTE:  Pass-in null for the page value
                        GetOnePreferenceDTO getOnePreferenceDTO = this.preferenceService.getOnePreferenceWithoutPage(loggedInUserId, aPreferenceName);
                
                        // Return the GridPreferenceDTO back to the front-end and a 200 status code
                        return ResponseEntity
                                .status(HttpStatus.OK)
                                .body(getOnePreferenceDTO);
                    }
                
                
                    /**
                    * POST /api/preferences/page/set REST call
                    *
                    * This REST call sets the theme name preference only
                    * Returns 200 status code if it works
                    */
                    @RequestMapping(value = "/api/preferences/page/set", method = RequestMethod.POST, produces = "application/json")
                    public ResponseEntity<?> setPreferenceValueWithPage(@RequestBody SetPreferenceWithPageDTO aSetPreferenceDTO) {
                        logger.debug("setPreferenceValueWithPage() started.");
                
                        if (StringUtils.isBlank(aSetPreferenceDTO.getName() )) {
                            // The passed-in name is invalid
                            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                                    .contentType(MediaType.TEXT_PLAIN)
                                    .body("The passed-in name is blank.  This must be set.");
                        }
                        else if (StringUtils.isBlank(aSetPreferenceDTO.getPage() )) {
                            // The passed-in name is page
                            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                                    .contentType(MediaType.TEXT_PLAIN)
                                    .body("The passed-in page is blank.  This must be set.");
                        }
                
                        int loggedInUserId = this.userService.getLoggedInUserId();
                
                        // Set the preference in the system
                        this.preferenceService.setPreferenceValueWithPage(loggedInUserId, aSetPreferenceDTO.getName(), aSetPreferenceDTO.getValue(), aSetPreferenceDTO.getPage()  );
                
                        // Return a 200 status code and a null object
                        return ResponseEntity
                                .status(HttpStatus.OK)
                                .body(null);
                    }
                
                
                
                    /**
                    * POST /api/preferences/set REST call
                    *
                    * This REST call sets the theme name preference only
                    * Returns 200 status code if it works
                    */
                    @RequestMapping(value = "/api/preferences/set", method = RequestMethod.POST, produces = "application/json")
                    public ResponseEntity<?> setPreferenceValueWithoutPage(@RequestBody SetPreferenceDTO aSetPreferenceDTO) {
                        logger.debug("setPreferenceValueWithoutPage() started.");
                
                        if (StringUtils.isBlank(aSetPreferenceDTO.getName() )) {
                            // The passed-in name is invalid
                            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                                    .contentType(MediaType.TEXT_PLAIN)
                                    .body("The passed-in name is blank.  This must be set.");
                        }
                
                        int loggedInUserId = this.userService.getLoggedInUserId();
                
                        // Set the preference in the system
                        this.preferenceService.setPreferenceValueWithoutPage(loggedInUserId, aSetPreferenceDTO.getName(), aSetPreferenceDTO.getValue() );
                
                        // Return a 200 status code and a null object
                        return ResponseEntity
                                .status(HttpStatus.OK)
                                .body(null);
                    }
                }



Part 2:  Update the Front End
-----------------------------
    5. Add this front-end class:  GetOnePreferenceDTO
        a. Create the GetOnePreferenceDTO class
           unix> cd frontend
           unix> ng generate class models/preferences/GetOnePreferenceDTO  --skipTests

        b. Replace its contents with this:

                export class GetOnePreferenceDTO {
                  public value: string;
                }


    6. Add this front-end class:  SetPreferenceDTO
        a. Create the SetPreferenceDTO class
           unix> cd frontend
           unix> ng generate class models/preferences/SetPreferenceDTO  --skipTests

        b. Replace its contents with this:
                
                export class SetPreferenceDTO {
                  public name: string;
                  public value: string;
                  public page: string;
                }


    7. Add this front-end class:  PreferenceService
        a. Create the PreferenceService class
           unix> cd frontend
           unix> ng generate service services/preference  --skipTests

        b. Replace its contents with this:
                
                import { Injectable } from '@angular/core';
                import {HttpClient} from "@angular/common/http";
                import {environment} from "../../environments/environment";
                import {Observable} from "rxjs";
                import {SetPreferenceDTO} from "../models/preferences/set-preference-dto";
                import {GetOnePreferenceDTO} from "../models/preferences/get-one-preference-dto";
                
                @Injectable({
                  providedIn: 'root'
                })
                export class PreferenceService {
                
                
                  constructor(private httpClient: HttpClient) { }
                
                
                  public getPreferenceValueForPage(aPreferenceName: string, aPage: string):Observable<GetOnePreferenceDTO> {
                    // Construct the URL for the REST endpoint  (to get the grid preferences for this page)
                    const restUrl = environment.baseUrl + `/api/preferences/get/${aPreferenceName}/${aPage}`;
                
                    // NOTE:  The REST call is not invoked you call subscribe() on this observable
                    return this.httpClient.get <GetOnePreferenceDTO> (restUrl);
                  }
                
                
                  public getPreferenceValueWithoutPage(aPreferenceName: string): Observable<GetOnePreferenceDTO> {
                    // Construct the URL for the REST endpoint  (to get the grid preferences for this page)
                    const restUrl = environment.baseUrl + `/api/preferences/get/${aPreferenceName}`;
                
                    // NOTE:  The REST call is not invoked you call subscribe() on this observable
                    return this.httpClient.get <GetOnePreferenceDTO> (restUrl);
                  }
                
                
                  public setPreferenceValueWithoutPage(aPreferenceName: string, aPreferenceValue: any): Observable<string> {
                    // Construct the URL for the REST endpoint  (to set the banner preference only)
                    const restUrl = environment.baseUrl + '/api/preferences/set';
                
                    let setPreferenceDTO: SetPreferenceDTO = new SetPreferenceDTO();
                    setPreferenceDTO.name = aPreferenceName;
                    setPreferenceDTO.value = aPreferenceValue;
                
                    // Return an observable to this POST REST call
                    // -- The 2nd {} is the json body sent to the REST call
                    // -- The 3rd {} is the map of options
                    return this.httpClient.post(restUrl, setPreferenceDTO, {responseType: 'text'} );
                  }
                
                
                  public setPreferenceValueForPage(aPreferenceName: string, aPreferenceValue: any, aPage: string): Observable<string> {
                    // Construct the URL for the REST endpoint  (to set the banner preference only)
                    const restUrl = environment.baseUrl + '/api/preferences/page/set';
                
                    let setPreferenceDTO: SetPreferenceDTO = new SetPreferenceDTO();
                    setPreferenceDTO.name = aPreferenceName;
                    setPreferenceDTO.value = aPreferenceValue;
                    setPreferenceDTO.page = aPage;
                
                    // Return an observable to this POST REST call
                    // -- The 2nd {} is the json body sent to the REST call
                    // -- The 3rd {} is the map of options
                    return this.httpClient.post(restUrl, setPreferenceDTO, {responseType: 'text'} );
                  }
                
                
                  public setPreferenceValueForPageUsingJson(aPreferenceName: string, aPreferenceValue: any, aPage: string): Observable<string> {
                    // Construct the URL for the REST endpoint  (to set the banner preference only)
                    const restUrl = environment.baseUrl + '/api/preferences/page/set';
                
                    let setPreferenceDTO: SetPreferenceDTO = new SetPreferenceDTO();
                    setPreferenceDTO.name = aPreferenceName;
                    setPreferenceDTO.value = JSON.stringify(aPreferenceValue);
                    setPreferenceDTO.page = aPage;
                
                    // Return an observable to this POST REST call
                    // -- The 2nd {} is the json body sent to the REST call
                    // -- The 3rd {} is the map of options
                    return this.httpClient.post(restUrl, setPreferenceDTO, {responseType: 'text'} );
                  }
                
                }


    8. Change the front-end  BannerService to use the new generic PreferenceService
        a. Edit banner.service.ts


        b. Inject the preferenceService in the constructor
             constructor(private httpClient: HttpClient,
          	          	 private preferenceService: PreferenceService) { }


        c. Change getLatestValueFromBackend() to this

              public getLatestValueFromBackend(): Observable<GetOnePreferenceDTO> {
                // invoke the preference service to get the show-banner boolean value
                return this.preferenceService.getPreferenceValueWithoutPage("show.banner");
              }


        d. Change setLatestValue() to this:

              private setLatestValue(aBannerInfo: boolean): Observable<string> {
                // Use the preference service to set the show-banner boolean value
                return this.preferenceService.setPreferenceValueWithoutPage("show.banner",aBannerInfo);
              }


        e. Change the initialize() method so it creates a new BehaviorSubject

              public initialize(aBannerInfo: boolean) {
                // Send out a message that (to anyone listening) with the current value
                // Anyone who listens later, gets this initial message
                this.bannerStateSubject = new BehaviorSubject<boolean>(aBannerInfo);   
              }


        f. Change the private variable to this:
                private bannerStateSubject: BehaviorSubject<boolean>;



        g. Edit app.component.ts

        h. Change the public bannerObs to this:
             public bannerObs: Observable<GetOnePreferenceDTO>

        i. Edit ngOnInit() by removing these lines:

            this.bannerObs = this.bannerService.getLatestValueFromBackend().pipe(
                tap((aData: PreferencesDTO) => {
                    // The REST call came back with some data
            
                    // Initialize the banner service
                    this.bannerService.initialize(aData.showBanner);
                })
            );

           this.bannerSubscription =
             this.bannerService.getStateAsObservable().subscribe( (aShowBanner: boolean) => {
                // We received a message from the Banner Service
                // If we receive false, then set the flag to false
                // If we receive true,  then set the flag to true
                this.showBannerOnPage = aShowBanner;
            });



        j. Edit ngOnInit() by adding these lines:
        
            this.bannerObs = this.bannerService.getLatestValueFromBackend().pipe(
                tap((aData: GetOnePreferenceDTO) => {
                    // The REST call came back with some data
            
                    if (aData.value == null) {
                        // This user has *no previous preference*.  So, have show.banner initialize to TRUE (to show the banner)
                        this.bannerService.initialize(true);
                    }
                    else {
                        // This user has a preference.  So, initialize the bannerService with the stored string value
                        let initialShowBannerValue: boolean = true;
                        if (aData.value.toLowerCase() == 'false') {
                                initialShowBannerValue = false;
                        }
            
                        this.bannerService.initialize(initialShowBannerValue);
                    }
            
            
                    // Now that the banner service is initialized we can listen on it
                    this.bannerSubscription =
                    this.bannerService.getStateAsObservable().subscribe( (aShowBanner: boolean) => {
                        // We received a message from the Banner Service
                            // If we receive false, then set the flag to false
                            // If we receive true,  then set the flag to true
                            this.showBannerOnPage = aShowBanner;
                        });
            
                })   // end of tap
            );   // end of pipe


 



    9. Edit the navbar.service.ts so that it uses a behaviorSubject in the constructor
        a. Edit navbar.service.ts


        b. Change the private navbarStateSubject variable to this:
              private navbarStateSubject: BehaviorSubject<NavbarState>;

        c. Change the constructor to initialize the navbar state subject

              public constructor() {
                // Initialize the navbarState
            
                // The AppNavBar will be visible on startup
                this.navbarState.isAppNavbarDisplayed = true;
            
                // The UserNavBar will not be visible on startup
                this.navbarState.isUserNavbarDisplayed = false;
            
                // Initialize the navbar state subject
                this.navbarStateSubject = new BehaviorSubject(this.navbarState);
              }





    10. Verify that the Banner Service works with the new generic preference REST calls
        a. Activate the Debugger on "Full WebApp"
        b. Click on the Username in the header (to open the right-side menu)
        c. Click on "Show Banner"
           -- The banner should appear

        d. Click on "Hide Banner"
           -- The banner should disappear


    11. Change the constants so it has a constant for the column state
        a. Edit constants.ts

        b. Add this line:
                COLUMN_STATE_PREFERENCE_NAME = "grid_column_state"    



    12. Change the front-end grid page to remember column state
        a. Edit report-grid-view.component.ts

        b. Add private variables to the top of the class:
              private readonly PAGE_NAME: string = "reports-grid-view";
              private userHasPastColumnState: boolean = false;
              private listenForGridChanges: boolean = false;
              private saveGridColumnStateEventsSubject: Subject<any> = new Subject();
              private saveGridEventsSubscription: Subscription;


        c. Change the gridOptions variable so it calls methods when a user sorts, resizes, moves columns
              public gridOptions: GridOptions = {
                debug: true,
                suppressCellSelection: true,
                rowSelection: 'multiple',  	// Possible values are 'single' and 'multiple'
                domLayout: 'normal',
            
                onSortChanged: () => {
                this.saveColumnState();
                },
            
                onDragStopped: () => {
                // User finished resizing or moving column
                this.saveColumnState();
                },
            
                onDisplayedColumnsChanged: () => {
                this.saveColumnState();
                },
            
                onColumnVisible: () => {
                this.saveColumnState();
                },
            
                onColumnPinned: () => {
                this.saveColumnState();
                }
              };


        d. Add these methods to your grid page:
            
              private saveColumnState(): void {
                if (this.listenForGridChanges) {
                // The grid has rendered data.  So, save the sort/column changes
            
                // Get the current column state
                let currentColumnState = this.gridColumnApi.getColumnState();
            
                // Send a message to save the current column state
                this.saveGridColumnStateEventsSubject.next(currentColumnState)
                }
              }


              public firstDataRendered(): void {
                // The grid is fully rendered.  So, set the flag to start saving sort/column changes
                this.listenForGridChanges = true;
              }



        e. Change the columnDefs so that the columns are sortable and resizable
            
              public columnDefs = [
                {
                field: 'id',
                cellClass: 'grid-text-cell-format',
                cellRenderer: 'actionCellRenderer',
                cellRendererParams: {
                    deleteButtonGridMethod: (params: ICellRendererParams) => this.openDeleteDialog(params),
                    editButtonGridMethod: (params: ICellRendererParams) => this.openEditDialog(params)
                },
                headerName: 'Actions',
                filter: false,
                suppressMenu: false,
                sortable: false,
                resizable: true,
                checkboxSelection: true
                },
                {
                field: 'name',
                cellClass: 'grid-text-cell-format',
                sortable: true,
                resizable: true,
                filter: 'agTextColumnFilter'
                },
                {
                field: 'priority',
                cellRenderer: 'priorityCellRenderer',
                sortable: true,
                resizable: true,
                filter: 'agTextColumnFilter'
                },
                {
                field: 'start_date',
                cellClass: 'grid-text-cell-format',
                sortable: true,
                resizable: true,
                filter: 'agTextColumnFilter'
                },
                {
                field: 'end_date',
                cellClass: 'grid-text-cell-format',
                sortable: true,
                resizable: true,
                filter: 'agTextColumnFilter'
                }
              ];


        f. Inject the preference service into the constructor

              constructor(private gridService: GridService,
                        private preferenceService: PreferenceService,
                        private matDialog: MatDialog) {}



        g. Change the ngOnInit() so it saves grid events (but only after 250 milliseconds)
            
              public ngOnInit(): void {
            
                // Listen for save-grid-column-state events
                // NOTE:  If a user manipulates the grid, then we could be sending LOTS of save-column-state REST calls
                //    	The debounceTime slows down the REST calls
                //    	The switchMap cancels previous calls
                //    	Thus, if there are lots of changes to the grid, we invoke a single REST call using the *LAST* event (over a span of 250 msecs)
                this.saveGridEventsSubscription = this.saveGridColumnStateEventsSubject.asObservable().pipe(
                    debounceTime(250),     	// Wait 250 msecs before invoking REST call
                    switchMap( (aNewColumnState: any) => {
                        // Use the switchMap for its cancelling effect: 
                    // On each observable, the previous observable is cancelled
            
                        // Return an observable
                        // Invoke the REST call to save it to the back end
                        return this.preferenceService.setPreferenceValueForPageUsingJson(Constants.COLUMN_STATE_PREFERENCE_NAME, aNewColumnState, this.PAGE_NAME)
                })
                ).subscribe();
            
              }



        h. Add an ngOnDestroy method to stop listening on these subscriptions:

              public ngOnDestroy(): void {
                if (this.saveGridEventsSubscription) {
                    this.saveGridEventsSubscription.unsubscribe();
                }
            
                if (this.saveGridColumnStateEventsSubject) {
                    this.saveGridColumnStateEventsSubject.unsubscribe();
                }
              }




        i. Change the class so it implements OnDestroy by changing this line:

            	export class ReportGridViewComponent implements OnInit, OnDestroy {



        j. Change onGridReady() to get the preference values
            
              /*
               * The grid is ready.  So, perform grid initialization here:
               *  1) Invoke the REST call to get the grid column state preferences
               *  2) When the REST endpoint returns
               * 	a) Set the grid column state preferences
               * 	b) Load the data into the grid
               */
              public onGridReady(params: any): void {
                // Get a reference to the gridApi and gridColumnApi (which we will need later to get selected rows)
                this.gridApi = params.api;
                this.gridColumnApi = params.columnApi;
            
            
                this.preferenceService.getPreferenceValueForPage(Constants.COLUMN_STATE_PREFERENCE_NAME, this.PAGE_NAME).subscribe( (aPreference: GetOnePreferenceDTO) => {
                        // REST call came back.  I have the grid preferences
                    
                        if (! aPreference.value) {
                            // There is no past column state
                            this.userHasPastColumnState = false;
                        }
                        else {
                            // There is past column state
                            let storedColumnStateObject = JSON.parse(aPreference.value);
                    
                            // Set the grid to use past column state
                            this.gridColumnApi.setColumnState(storedColumnStateObject);
                    
                            this.userHasPastColumnState = true;
                        }
                    
                        // Load the grid with data
                        this.reloadPage();
                  });
              }


        k. Adjust the reloadPage() method by changing this line:
    	        this.gridApi.sizeColumnsToFit()

           To this:
                if (! this.userHasPastColumnState) {
                        // We did not get any column state on page load.  So, resize the columns
                        this.gridApi.sizeColumnsToFit();
                }


    13. Change grid to call a method when the grid is rendered (by modifying report-grid-view.component.html)
        a. Edit report-grid-view.component.html

        b. Add this to <ag-grid-angular>
                 (firstDataRendered)="this.firstDataRendered()"


        When completed, the grid tag should look like this:
        
                    <!-- AG-Grid -->
                    <ag-grid-angular
                        style="width: 100%; height: 100%"
                        class="ag-theme-alpine"
                        [rowData]="this.rowData"
                        [defaultColDef]="this.defaultColDefs"
                        [columnDefs]="this.columnDefs"
                        [gridOptions]="this.gridOptions"
                        [frameworkComponents]="this.frameworkComponents"
                        (selectionChanged)="this.generateDerivedValuesOnUserSelection()"
                        (firstDataRendered)="this.firstDataRendered()"
                        (gridReady)="this.onGridReady($event)">
                    </ag-grid-angular>


    14. Try it out
        a. Activate your debugger on "Full WebApp"
        b. Click on "Report Grid View"
        c. Change the width of a column
        d. Leave the page
        e. Come back to the page
           -- The grid should remember the column width


    15. Problem:  If a user hides all columns, then there is no way to reset it back to the original view
        Solution:  Add a "Reset" button

        a. Edit report-grid-view.component.ts

        b. Add these 2 methods:
            
              /*
               * Clear all grid sorting
               */
              private clearGridSorting(): void {
            
                // Tell the grid to clear sorting on all columns
                this.gridColumnApi.applyColumnState({
                defaultState: { sort: null }
                });
              }
            
              /*
               * Reset the grid back to default settings
               */
              public resetGrid(): void {
                // Clear all sorting
                this.clearGridSorting();
            
                // Clear the filters
                this.gridApi.setFilterModel(null);
            
                // Reset columns (so they are visible and restored to default)
                this.gridColumnApi.resetColumnState();
              }



        c. Edit report-grid-view.component.html

        d. Change the right side of the button row from to this:
        
            <!-- Right Side of the "button row" -->
            <div fxFlex fxLayoutAlign="end center">
        
                <!-- Reset Button -->
                <button mat-stroked-button type="button" color="primary" (click)="this.resetGrid()" title="Reset Grid" aria-label="Reset Grid">Reset</button>
            </div>


    16. Verify that the Reset Button works
        a. Activate your debugger on "Full WebApp"
        b. Click on "Report Grid View"
        c. Change the width of a column
        d. Remove some of the columns by dragging the columns up
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson22i_image1.png)
```

        e. Press the "Reset" button
           -- The grid should return to default settings
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson22i_image2.png)
```


    17. Add a cache to the PreferenceService
        Right now:  The grid page makes 2 REST calls when the grid page loads
        (1) 1st REST call gets the preferences
        (2) 2nd REST call get the grid data

        But, if the preference.service.ts had a cache, then the grid page would only need 1 REST call
        
        Follow these steps to add a front-end cache to the preference.service.ts
                a. Edit preference.service.ts
        
                b. Replace its contents with this:
                    
                    import { Injectable } from '@angular/core';
                    import {HttpClient} from "@angular/common/http";
                    import {environment} from "../../environments/environment";
                    import {EMPTY, Observable} from "rxjs";
                    import {SetPreferenceDTO} from "../models/preferences/set-preference-dto";
                    import {GetOnePreferenceDTO} from "../models/preferences/get-one-preference-dto";
                    import {catchError, shareReplay} from "rxjs/operators";
                    
                    @Injectable({
                      providedIn: 'root'
                    })
                    export class PreferenceService {
                    
                    
                      // The cache holds key="preference-name,page" value=Observable that holds GetOnePreferenceDTO
                      private cache: any = {};
                    
                      constructor(private httpClient: HttpClient) { }
                    
                    
                      public getPreferenceValueForPage(aPreferenceName: string, aPage: string): Observable<GetOnePreferenceDTO> {
                        let cacheKey: string = aPreferenceName + aPage;
                        if (this.cache[cacheKey]) {
                        // This observable is in the cache.  So, return it from the cache
                        return this.cache[cacheKey];
                        }
                    
                    
                        // Construct the URL for the REST endpoint  (to get the grid preferences for this page)
                        const restUrl = environment.baseUrl + `/api/preferences/get/${aPreferenceName}/${aPage}`;
                    
                        // NOTE:  The REST call is not invoked you call subscribe() on this observable
                        this.cache[cacheKey] = this.httpClient.get <GetOnePreferenceDTO> (restUrl).pipe(
                        shareReplay(1),
                        catchError(err => {
                            console.error('Error in getPreferenceValueForPage().  Error is ', err);
                            delete this.cache[cacheKey];
                            return EMPTY;
                        }));
                    
                        return this.cache[cacheKey];
                      }
                    
                    
                      public getPreferenceValueWithoutPage(aPreferenceName: string): Observable<GetOnePreferenceDTO> {
                        let cacheKey: string = aPreferenceName;
                        if (this.cache[cacheKey]) {
                        // This observable is in the cache.  So, return it from the cache
                        return this.cache[cacheKey];
                        }
                    
                        // Construct the URL for the REST endpoint  (to get the grid preferences for this page)
                        const restUrl = environment.baseUrl + `/api/preferences/get/${aPreferenceName}`;
                    
                        // NOTE:  The REST call is not invoked you call subscribe() on this observable
                        this.cache[cacheKey] = this.httpClient.get <GetOnePreferenceDTO> (restUrl).pipe(
                        shareReplay(1),
                        catchError(err => {
                            console.error('Error in getPreferenceValueWithoutPage().  Error is ', err);
                            delete this.cache[cacheKey];
                            return EMPTY;
                        }));
                    
                        return this.cache[cacheKey];
                      }
                    
                    
                      public setPreferenceValueWithoutPage(aPreferenceName: string, aPreferenceValue: any): Observable<string> {
                        let cacheKey: string = aPreferenceName;
                        if (this.cache[cacheKey]) {
                        // Remove this from the cache  (as the value is changingThis observable is in the cache.  So, return it from the cache
                        delete this.cache[cacheKey];
                        }
                    
                        // Construct the URL for the REST endpoint  (to set the preference only)
                        const restUrl = environment.baseUrl + '/api/preferences/set';
                    
                        let setPreferenceDTO: SetPreferenceDTO = new SetPreferenceDTO();
                        setPreferenceDTO.name = aPreferenceName;
                        setPreferenceDTO.value = aPreferenceValue;
                    
                        // Return an observable to this POST REST call
                        // -- The 2nd arg is the json body sent to the REST call
                        // -- The 3rd arg is the map of options
                        return this.httpClient.post(restUrl, setPreferenceDTO, {responseType: 'text'} );
                      }
                    
                    
                      public setPreferenceValueForPage(aPreferenceName: string, aPreferenceValue: any, aPage: string): Observable<string> {
                        let cacheKey: string = aPreferenceName + aPage;
                        if (this.cache[cacheKey]) {
                        // Remove this from the cache  (as the value is changingThis observable is in the cache.  So, return it from the cache
                        delete this.cache[cacheKey];
                        }
                    
                        // Construct the URL for the REST endpoint  (to set the preference for this page)
                        const restUrl = environment.baseUrl + '/api/preferences/page/set';
                    
                        let setPreferenceDTO: SetPreferenceDTO = new SetPreferenceDTO();
                        setPreferenceDTO.name = aPreferenceName;
                        setPreferenceDTO.value = aPreferenceValue;
                        setPreferenceDTO.page = aPage;
                    
                        // Return an observable to this POST REST call
                        // -- The 2nd arg is the json body sent to the REST call
                        // -- The 3rd arg is the map of options
                        return this.httpClient.post(restUrl, setPreferenceDTO, {responseType: 'text'} );
                      }
                    
                    
                      public setPreferenceValueForPageUsingJson(aPreferenceName: string, aPreferenceValue: any, aPage: string): Observable<string> {
                        let cacheKey: string = aPreferenceName + aPage;
                        if (this.cache[cacheKey]) {
                        // Remove this from the cache  (as the value is changingThis observable is in the cache.  So, return it from the cache
                        delete this.cache[cacheKey];
                        }
                    
                        // Construct the URL for the REST endpoint  (to set the preference only)
                        const restUrl = environment.baseUrl + '/api/preferences/page/set';
                    
                        let setPreferenceDTO: SetPreferenceDTO = new SetPreferenceDTO();
                        setPreferenceDTO.name = aPreferenceName;
                        setPreferenceDTO.value = JSON.stringify(aPreferenceValue);
                        setPreferenceDTO.page = aPage;
                    
                        // Return an observable to this POST REST call
                        // -- The 2nd arg is the empty json body sent to the REST call
                        // -- The 3rd arg is the empty map of options
                        return this.httpClient.post(restUrl, setPreferenceDTO, {responseType: 'text'} );
                      }
                    
                    
                    }
                    


    18. Try it out
        a. Activate your debugger on "Full WebApp"
        b. Click on "Report Grid View"
        c. Change the width of a column
        d. Leave the page
        e. Return to the page
           -- The column width should be remembered
        f. Leave the page (without changing any column width or sorting)
        g. Return to the page
           -- You should not have invoked a REST call to get preferences (as they are cached in preference.service.ts)


```
