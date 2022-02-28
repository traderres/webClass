Lesson 20f:  Secure Routes /  Add REST Call to get Map of Allowed Routes
------------------------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1EPnRTj7FXJDm_DrFObcZBvdPWW_mgcNxgHhQ8v_pSBQ/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson20f/secure-route/add-rest-call
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem:  The business rules (that relate ROLES to page ROUTES) must be stored somewhere.<br>
<b>Where should we store these rules?</b><br>

<br>
<br>
<h3>Approaches</h3>

- Option 1: Put lots of if statements all over the front-end  
  If (user is granted ADMIN_ROLE), then show the VIEW_REPORTS_PAGE  
  \+ Simple to implement  
  \- Difficult to maintain as you there are lots of if statements all over the front-end  
  \- Security is tightly coupled  
  <br>
  
- Option 2: Store role-to-routes relationships in database tables  
   \+ More flexible (if you change the database records, then UI controls can appear/disappear)  
   \+ The same map can be used individual UI controls (and not just whole pages)  
   \+ Store this data in a repeatable migration file so it can be maintained in one SQL script  
   \+ Security is loosely coupled  
    
  \- More complex: Requires the creating database tables, database records  
  \- Requires a REST endpoint that provides the front-end with the map of roles-to-routes  
    
  \- Requires if statements in the front-end but they are <b>simple if statements</b>
     if (user is allowed to see VIEW_REPORTS_PAGE), then show the navbar option  
  <br>
  
- Option 3: Store role-to-routes relationships in the application.yaml (property file)  
  Store a list of roles there  
  Store a list of routes there  
  Store the relationships routes there
  \- The data is hard-coded in an application.yaml (instead of in a database), so it's hardto retrieve  
  \- Requires if statements in the front-end but they are \*simple\* if statement<br>
       if (user is allowed to see VIEW_REPORTS_PAGE), then show the navbar option  

<br>
<br>
<h3>Approach</h3>

1. Create the database tables  
   Create table called "roles"that holds the roles -- e.g., admin, reader  
   Create table called "uicontrols"that holds the routes/controls (one route for each page)  
   Create table called "roles_uicontrols"that holds the relationships  

1. On the back-end, grant the the READER role to the user (when running in local dev mode)  

1. Add a map to the back-end UserInfo object called accessMap as a map&lt;String, Boolean>  

1. Configure the back-end to populate the UserInfo.accessMap object on authentication

   1. The key is the route or UI control
   1. The value holds true if the user is allowed to see that route. False otherwise  

1. Create a REST call that returns the UserInfoDTO object back to the front-end  
   GET /api/users/me  

1. Use Postman to verify that the REST call works

  
  


<br>
<br>

```

Procedure
---------
    1. Create the database tables by adding the R__security.sql script
        a. Right-click on backend/src/main/resources/db/migration -> New File
           Filename:  R__security.sql

        b. Add this to your newly-created file:
            
            --------------------------------------------------------------------------------
            -- Filename:  R__security.sql
            --
            -- NOTE:  This is a repeatable migration file because this data does not change
            --    	So, if anything changes in this file, this script is re-executed on startup
            --------------------------------------------------------------------------------
            drop table if exists roles_uicontrols;
            drop table if exists uicontrols;
            drop table if exists roles;
            
            
            -- Create this table:  roles
            create table roles (
                id   integer 	not null,
                name varchar(50) not null,
                primary key(id)
            );
            
            comment on table  roles   	is 'This table holds all of the application roles used by the web app.';
            comment on column roles.id   is 'This number uniquely identifies this role.';
            comment on column roles.name is 'This identifies the name of the role.';
            
            
            
            -- Create this table:  uicontrols
            create table uicontrols (
                id   integer 	not null,
                name varchar(50) not null,
                primary key(id)
            );
            
            comment on table  uicontrols   	is 'This table holds all of the application roles used by the web app.';
            comment on column uicontrols.id   is 'This number uniquely identifies this UI feature.';
            comment on column uicontrols.name is 'This identifies the name of the UI feature.';
            
            
            -- Create this table:  roles_uicontrols
            create table roles_uicontrols (
                role_id  	integer not null,
                uicontrol_id integer not null
            );
            comment on table  roles_uicontrols   is 'This table holds the relationships between the roles and uicontrols tables.';
            
            
            --
            -- Define the security roles
            --
            insert into roles(id, name) values (1, 'ADMIN');
            insert into roles(id, name) values( 2, 'READER');
            
            
            --
            -- Add the uicontrols records
            -- ASSUMPTION:  These routes match your routes in constants.ts
            --
            insert into uicontrols(id, name) values(1001, 'page/viewReports');
            insert into uicontrols(id, name) values(1002, 'page/addReport');
            insert into uicontrols(id, name) values(1003, 'page/longReport');
            insert into uicontrols(id, name) values(1004, 'page/searchResults');
            
            
            -- Assign ui controls for the 'admin' role
            insert into roles_uicontrols(role_id, uicontrol_id) values(1, 1001);
            insert into roles_uicontrols(role_id, uicontrol_id) values(1, 1002);
            insert into roles_uicontrols(role_id, uicontrol_id) values(1, 1003);
            insert into roles_uicontrols(role_id, uicontrol_id) values(1, 1004);
            
            
            -- Assign ui controls for the 'reader' role  (cannot get to addReport)
            insert into roles_uicontrols(role_id, uicontrol_id) values(2, 1001);
            insert into roles_uicontrols(role_id, uicontrol_id) values(2, 1003);
            insert into roles_uicontrols(role_id, uicontrol_id) values(2, 1004);
            


        c. Run flyway:info before running flyway migrate
           (to make sure that flyway sees the new R__security.sql file)
           unix> cd ~/intellijProjects/angularApp1/backend
           unix> mvn flyway:info

            You should see the security entry as "Pending"
            +------------+---------+------------------------------+--------+---------------------+---------+
            | Category   | Version | Description                  | Type   | Installed On        | State   |
            +------------+---------+------------------------------+--------+---------------------+---------+
            |            |     	| << Flyway Schema Creation >> | SCHEMA  | 2021-05-19 22:40:35 | Success |
            | Versioned  | 1.1 	| baseline                     | SQL     | 2021-05-19 22:40:35 | Success |
            | Versioned  | 1.2 	| lookup tables                | SQL     | 2021-05-19 22:40:35 | Success |
            | Versioned  | 1.3 	| reports                      | SQL     | 2021-05-19 22:40:35 | Success |
            | Versioned  | 1.4 	| jobs                         | SQL     | 2021-05-19 22:40:35 | Success |
            | Versioned  | 1.5 	| preferences                  | SQL     | 2021-05-19 22:43:48 | Success |
            | Repeatable |     	| security                     | SQL     |                     | Pending |
            +------------+---------+------------------------------+--------+---------------------+---------+


        d. Run flyway:migrate  (to apply the security changes to your database)
           unix> cd ~/intellijProjects/angularApp1/backend
           unix> mvn flyway:migrate


        e. Run flyway:info after running flyway migrate
           (to make sure that flyway migrates the new R__security.sql file)
           unix> cd ~/intellijProjects/angularApp1/backend
           unix> mvn flyway:info

            You should see the security entry as "Success"
            +------------+---------+------------------------------+--------+---------------------+---------+
            | Category   | Version | Description                  | Type   | Installed On        | State   |
            +------------+---------+------------------------------+--------+---------------------+---------+
            |            |     	| << Flyway Schema Creation >> | SCHEMA  | 2021-05-19 22:40:35 | Success |
            | Versioned  | 1.1 	| baseline                     | SQL     | 2021-05-19 22:40:35 | Success |
            | Versioned  | 1.2 	| lookup tables                | SQL     | 2021-05-19 22:40:35 | Success |
            | Versioned  | 1.3 	| reports                      | SQL     | 2021-05-19 22:40:35 | Success |
            | Versioned  | 1.4 	| jobs                         | SQL     | 2021-05-19 22:40:35 | Success |
            | Versioned  | 1.5 	| preferences                  | SQL     | 2021-05-19 22:43:48 | Success |
            | Repeatable |     	| security                     | SQL     | 2021-06-01 18:21:08 | Success |
            +------------+---------+------------------------------+--------+---------------------+---------+


        f. Refresh your IntelliJ Database Console and verify that you see the new tables in it


        g. Double-click on the roles table (in the Database Console)
           -- You should see 2 records in there



    2. On the back-end, grant the the READER role to the user     (when running in local dev mode)
        a. Edit MyAuthenticationManager

        b. Look at the method called loadUserDetailsForDevelopment()

        c. Make sure you see this line:
             grantedAuthorities.add(new SimpleGrantedAuthority("ROLE_READER"));

           NOTE:  The "ROLE_" prefix is needed



    3. Adjust the date/time REST endpoint so that it requires the SUPERUSER role
        a. Edit HomeController.java

        b. Edit the getDateTime() REST endpoint so that it has this annotation in it:
              @PreAuthorize("hasAnyRole('SUPERUSER')")



        When finished, the REST endpoint should look like this:
        
        /**
         * GET /api/time
         * @return a plain-old string with the system time
         */
        @RequestMapping(value = "/api/time", method = RequestMethod.GET, produces = "application/json")
        @PreAuthorize("hasAnyRole('SUPERUSER')")
        public ResponseEntity<?> getDateTime() {
            logger.debug("getDateTime() started.");
        
            // Get the date/time
            DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
            Date date = new Date();
            String dateTime = dateFormat.format(date);
        
            // Return the date/time string as plain-text
            return ResponseEntity
                    .status(HttpStatus.OK)
                    .contentType(MediaType.TEXT_PLAIN)
                    .body(dateTime);
        }



    4. Verify that your PKI client user is forbidden from using the /api/time REST endpoint
        a. Activate the debugger on "Backend (prod)"
        b. Startup your browser (that has your PKI client certificate)
        c. Connect to https://localhost:8443/app1/api/time
-- Verify that you see this forbidden page
```
![](https://lh4.googleusercontent.com/C19_ArWKuMFVFkxh__r_Vdfj-a309-_rrJsaU4Fz7XetDY9KAl1Ldsi7aZ1IP0xMwb6fdEl5Em13qqTo7IJ0v4h4sAN7X3MEDWCO4PjUGiefkiGZk7Yk6_swEeb_hX39FuNIxUEc)
```
        d. Stop the debugger




    5. Change the REST endpoint so that it requires the READER or ADMIN role
        a. Edit HomeController.java

        b. Change the getDateTime so that it requires either the READER or ADMIN role
              @PreAuthorize("hasAnyRole('READER', 'ADMIN')")



    6. Verify that your PKI client user can successfully use the /api/time REST endpoint
        a. Activate the debugger on "Backend (prod)"
        b. Startup your browser (that has your PKI client certificate)
        c. Connect to https://localhost:8443/app1/api/time
           -- Verify that you see the time
        d. Stop the debugger


        Key Lesson:  We protect REST endpoints with the @PreAuthorize annotation




    7. Add the accessMap to the UserInfo object
       So, that there will be a map of allowed routes created upon authentication

        a. Edit UserInfo.java


        b. Add this private variable:
    	private Map<String, Boolean> accessMap;


        c. Add this getter
                public Map<String, Boolean> getAccessMap() {
                        return accessMap;
                }

        d. Add this public method
                public UserInfo withAccessMap(Map<String, Boolean> aAccessMap) {
                        this.accessMap = aAccessMap;
                        return this;
                }



    8. Configure the back-end to populate the UserInfo.accessMap object on authentication
        a. Edit UserService.java

        b. Add this method:    generateAccessMap()
            
            public Map<String, Boolean> generateAccessMap(List<GrantedAuthority> aGrantedRoleAuthorities) {
            
                // Convert the list of granted authority objects into a list of strings (and strip-off the "ROLE_" prefix)
                List<String> roleList = aGrantedRoleAuthorities.stream().map(auth -> {
                    String authString = auth.toString();
                    if (authString.startsWith("ROLE_")) {
                            // Remove the "ROLE_" prefix
                            return authString.substring(5);
                    }
                    else {
                            return authString;
                    }
                }).collect(Collectors.toList());
            
                // Create a parameter map (required to use bind variables with postgres IN clause)
                Map<String, Object> paramMap = new HashMap<>();
                paramMap.put("roleList", roleList);
            
                // Construct the SQL to get list of ui-controls with true if allowed and false if not allowed
                String sql = "select distinct ui.name, true as access\n" +
                            "from uicontrols ui\n" +
                            " join roles r on (r.name IN ( :roleList ))\n" +
                            " join roles_uicontrols ru ON (r.id=ru.role_id) AND (ui.id=ru.uicontrol_id)\n" +
                            "order by 1";
            
            
                // Execute the query to get all uicontrols that are allowed for this user's role
                NamedParameterJdbcTemplate np = new NamedParameterJdbcTemplate(this.dataSource);
            
                SqlRowSet rs = np.queryForRowSet(sql, paramMap);
            
                // Create the map
                Map<String, Boolean> accessMap = new HashMap<>();
            
                // Loop through the SqlRowSet, putting the results into a map
                while (rs.next() ) {
                        accessMap.put( rs.getString("name"), rs.getBoolean("access") );
                }
            
                // Return the map
                return accessMap;
            }
            


        c. Edit MyAuthenticationManager.java

        d. Replace loadUserDetailsForDevelopment() with this:
            
            public UserDetails loadUserDetailsForDevelopment(Authentication authentication) {
                String userUID = "my_test_user";
                String userDN = "3.2.12.144549.1.9.1=#161760312e646576,CN=my_test_user,OU=Hosts,O=ZZTop.Org,C=ZZ";
            
                if ((authentication != null) && (authentication.getPrincipal() != null)) {
                        userDN = authentication.getPrincipal().toString();
                        userUID = getCnValueFromLongDnString(userDN);
                        if (userUID == null) {
                                userUID = "my_test_user";
                        }
                }
            
                // Create a list of granted authorities
                List<GrantedAuthority> grantedRoleAuthorities = new ArrayList<>();
                grantedRoleAuthorities.add(new SimpleGrantedAuthority("ROLE_READER"));
                grantedRoleAuthorities.add(new SimpleGrantedAuthority("ROLE_USER_FOUND_IN_VALID_LIST_OF_USERS"));
            
                // User is about to login
                // -- This would be the place to add/update a database record indicating that the user logged-in
                Integer userId = 25;
            
                // Get the user's granted access map
                // NOTE:  This holds all authorized routes and UI controls (based on the user's granted roles)
                Map<String, Boolean> accessMap = userService.generateAccessMap(grantedRoleAuthorities);
            
                // Create a bogus UserInfo object
                // NOTE:  I am hard-coding the user's userid=25
                UserInfo anonymousUserInfo = new UserInfo()
                            .withId(userId)
                            .withUsernameUID(userUID)
                            .withUsernameDn(userDN)
                            .withGrantedAuthorities(grantedRoleAuthorities)
                            .withAccessMap(accessMap);
                
                return anonymousUserInfo;
            }



        e. Replace loadUserDetailsFromRealSource() with this: 
            
            private UserDetails loadUserDetailsFromRealSource(Authentication authentication) {
                logger.debug("loadUserDetailsFromRealSource() started authentication={}", authentication);
                String userDN;
                PreAuthenticatedAuthenticationToken token;
            
                if (authentication.getPrincipal() instanceof String) {
                        userDN = authentication.getPrincipal().toString();
                } else if (authentication.getPrincipal() instanceof UserInfo) {
                        return (UserDetails) authentication.getPrincipal();
                } else {
                        token = ( PreAuthenticatedAuthenticationToken ) authentication.getPrincipal();
                        userDN = token.getName();
                }
            
                logger.debug("userDN={}", userDN);
            
                // Get the user's UID from the CN=<...>
                try {
                    String userUID = getCnValueFromLongDnString(userDN);
            
                    // Get the list of roles from the header
                    List<GrantedAuthority> grantedRoleAuthorities = getAuthoritiesFromHeaderValue();
            
                    if (grantedRoleAuthorities.size() > 0) {
                        // This user has at least one role found in my authorization service
                        // NOTE:  All granted authorities must start with the "ROLE_" prefix
                        grantedRoleAuthorities.add(new SimpleGrantedAuthority("ROLE_USER_FOUND_IN_VALID_LIST_OF_USERS"));
                    }
                    else {
                        // This user has no roles so throw a runtime exception
                        throw new RuntimeException("No roles were found for this user: " + userUID);
                    }
            
                    logger.info("{} successfully logged-in.", userUID);
            
                    // User is about to login
                    // -- This would be the place to add/update a database record indicating that the user logged-in
                    Integer userId = this.userService.getOrAddUserRecordsToSystem(userUID);
            
                    // Get the user's granted access map
                    // NOTE:  This holds all authorized routes and UI controls (based on the user's granted roles)
                    Map<String, Boolean> accessMap = userService.generateAccessMap(grantedRoleAuthorities);
                
                    logger.debug("loadUserDetailsFromRealSource() about to return new UserInfo object");
            
                    // We *MUST* set the database ID in the UserInfo object here
                    return new UserInfo()
                            .withId(userId)
                            .withUsernameDn(userDN)
                            .withUsernameUID(userUID)
                            .withGrantedAuthorities(grantedRoleAuthorities);
                } catch (Exception e) {
                    throw new UsernameNotFoundException("Exception raised in loadUserDetailsFromRealSource():  This user will definitely not login", e);
                }
            }



    9. Create this object:  UserInfoDTO   (holds the user info returned to the front-end)

        a. Right-click on backend/src/main/java/com/lessons/models -> New Class
           Class Name:  UserInfoDTO

        b. Replace its contents with this:
            
            package com.lessons.models;
            
            import com.fasterxml.jackson.annotation.JsonProperty;
            
            import java.util.Map;
            
            public class UserInfoDTO {
                @JsonProperty("name")
                private final String name;
            
                @JsonProperty("pageRoutes")
                private final Map<String, Boolean> accessMap;
            
                // -------------- Constructor & Getters --------------------------------
            
                public UserInfoDTO(String name, Map<String, Boolean> accessMap) {
                        this.name = name;
                        this.accessMap = accessMap;
                }
            
                public String getName() {
                        return name;
                }
            
                public Map<String, Boolean> getAccessMap() {
                        return accessMap;
                }
            }
            


    10. Create this REST endpoint that returns the UserInfoDTO object
        a. Right-click on backend/src/main/java/com/lessons/controllers -> New Java Class
           Class Name:  UserController

        b. Replace its contents with this:
            
            package com.lessons.controllers;
            
            import com.lessons.models.UserInfoDTO;
            import com.lessons.security.UserInfo;
            import com.lessons.services.UserService;
            import org.slf4j.Logger;
            import org.slf4j.LoggerFactory;
            import org.springframework.http.HttpStatus;
            import org.springframework.http.ResponseEntity;
            import org.springframework.security.access.prepost.PreAuthorize;
            import org.springframework.stereotype.Controller;
            import org.springframework.web.bind.annotation.RequestMapping;
            import org.springframework.web.bind.annotation.RequestMethod;
            import javax.annotation.Resource;
            import java.util.Map;
            
            @Controller
            public class UserController {
                private static final Logger logger = LoggerFactory.getLogger(UserController.class);
            
                @Resource
                private UserService userService;
            
                /**
                * REST endpoint /api/user/me
                */
                @RequestMapping(value = "/api/user/me", method = RequestMethod.GET, produces = "application/json")
                @PreAuthorize("hasAnyRole('READER', 'ADMIN')")
                public ResponseEntity<?> getUserInfo() {
            
                    // Get the user's logged-in name
                    String loggedInUsername = userService.getLoggedInUserName();
            
                    // Get the user's access map (from the UserInfo object)
                    UserInfo userInfo = userService.getUserInfo();
                    Map<String, Boolean> accessMap = userInfo.getAccessMap();
            
                    // Create the UserInfoDTO object
                    UserInfoDTO userInfoDTO = new UserInfoDTO(loggedInUsername, accessMap);
            
                    // Return a response of 200 and the UserInfoDTO object
                    return ResponseEntity.status(HttpStatus.OK).body(userInfoDTO);
                }
            }


    11. Verify that the REST call works using a browser
        a. Activate the Debugger on "Backend (prod)"
        b. Open a browser that has the PKI client installed
        c. Connect to https://localhost:8443/app1/api/user/me
        d. Verify that you get this info:
```
![](https://lh5.googleusercontent.com/Je9vrcGOg1QpFwyajCQxyy2dDR65QvalNe5YaK-CL43NpBCxhM6HRWwiu1Qs2pj3sbBee0ca0F3SLWKWt3djVaWzlWjhhzA2VwKTFoehgkIMAUzD2IIP7Xkex_1HB6WDPXAzQHj7)
```
 (in Firefox, it would like this)






```
