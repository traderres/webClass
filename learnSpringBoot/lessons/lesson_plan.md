## Spring Boot / Maven / Java Lesson Plan
* [Best Practices](/learnSpringBoot/lessons/best_practices.txt)
<br/>

### Assumptions
* You have setup a development environment w/Java JDK, Postgres, IntelliJ, Maven<br/>
  [Setup development env for Unix](/learnSpringBoot/lessons/lesson01a_setupDevelopmentEnvForUnix.txt )<br>
  [Setup Development Env for Windows](/learnSpringBoot/lessons/lesson01b_setupDevelopmentEnvForWindows.txt)<br> 
<br/>

### Lesson Plan
1. Java fundamentals<br/>
    [Exercise: Create the "addNumbers" command-line Java program in Intellij](/learnJava/howToCreateJavaCommandLineProgram_numbers.txt)<br/>
    [Exercise: Create a spring-jdbc command-line Java program in Intellij](/learnJava/howToCreateJavaCommandLineProgram_springJdbc.txt)<br/>
    Variables:  Local, Instance, and Class (Static) <br/>
    Data Types: Primitives vs Objects<br/>

1. Methods and Constructors

1. Variables<br/>
   Primitives -- the 8 types<br/>
   Objects<br/>
   When to use primitives?<br/>
   When to use objects?<br/>
       
1. Java Strings
    
1. Java Collections<br/>
    Exercise: Working with lists<br/>
    Exercise: Working with maps<br/>
    
1. More Java fundamentals<br/>
    Java Constructors Explained<br/>
    Exercise: Change the Queries class so that there is a no-arg constructor<br/>
    Exercise: Queries 1.0: What are the strengths/weaknesses now?<br/>
    Exercise: Queries 2.0: Add an instance variable called DataSource and give it a getter and setter<br/>
    Exercise: Queries 2.0: What are the strengths/weaknesses now?
    Exercise: Queries 3.0: Update constructor<br/>
    Exercise: Queries 3.0: What are the strengths/weaknesses now?<br/>
    Exercise: Change the Data source to a C3P0 Connection Pool<br/>
    Exercise: Change the Data source to a Hikari Connection Pool<br/>
    Exercise: Create maps, loop through keys, loop through entry sets<br/>
    Exercise: Use StringUtils to create a fixed array<br/>
    Exercise: Create a method that converts string into a list of words<br/>
    
1. Spring fundamentals
   1. Lifecycle:  Constructor, Injection, Post-Construct
   1. Application Context / Spring beans (how does Spring manage them)
   1. Exercise: Adjust existing CDE webapp and inject code

1. Build SpringBoot webapp w/simple REST call
   1. [Build Spring Boot Structure](/learnSpringBoot/lessons/lesson02_createProjectStructure.txt)<br/>
   1. [Setup Springboot as Runnable JAR](/learnSpringBoot/lessons/lesson03_setupRunnableJar.txt)<br/>

1. Add a REST endpoint (controller)<br/>
   1. [Setup NPM](/learnSpringBoot/lessons/lesson04_addAngularUsingNpm.txt)<br/>
   1. [Add Angular Page](/learnSpringBoot/lessons/lesson05_addSimpleAngularPage.txt)<br/>
   1. [Setup Front End Structure](/learnSpringBoot/lessons/lesson06_addAngularFrontEndStructure.txt)<br/>   

1. [Setup Local Git Repo](/learnGit/howToAddProjectToLocalRepo.txt)
   
1. Add a REST endpoint that queries the database<br/>
   1. [Setup Postgres Database](/learnSpringBoot/lessons/lesson07_setupPostgresDatabase.txt)<br/>
   1. [Add JDBC Connection Pool](/learnSpringBoot/lessons/lesson09_addJdbcConnectionPool.txt)<br/>
   1. [Add REST controller, service layer, SQL call](/learnSpringBoot/lessons/lesson10_AddRestEndPoint.txt)<br/>

1. Use Flyway to setup a database table and sequence<br/>
   1. [Setup Flyway](/learnSpringBoot/lessons/lesson08a_addFlyway.txt)<br/>
   1. [Use Flyway to add database tables](/learnSpringBoot/lessons/lesson08c_useFlywayToAddTables.txt)<br/>
   1. [Use Intellij Database Plugin to run SQL](/learnIntellij/howToRunSqlInIntellij.txt)<br/>
   
1. Quick Start: Run SQL call in Java w/Spring-JDBC
   1. [Run SQL to select, insert, and delete records](/learnSpringBoot/lessons/lesson12_runSqlToInsertRecords.txt)
   1. [Create a command-line java program to run SQL call w/Spring-JDBC](/learnJdbcConnectionPools/postgreSQL/howToSetupSingleConnectionDataSourceWithIntellij.txt)
   1. [Add a Java service class to run SQL call w/Spring-JDBC](/learnSpringBoot/lessons/lesson13_addServiceLayerThatRunsSql.txt)
   1. [Add bind parameters with question marks](/learnSpringJdbc/howToAddBindParameters.txt)<br/>
   1. [Add bind parameters with maps](/learnSpringJdbc/howToUseNamedParamsForInsert.txt) 
   
1. Using REST endpoint parameters
   1. [Basic REST endpoint parameters](/learnSpringBoot/lessons/lesson14_restParams.txt)
   1. [Advanced REST endpoint parameters](/learnSpringBoot/lessons/lesson14_restParams_advanced.txt)   
   
1. More Java fundamentals
   1. ["Instance World" vs "Static World"](/learnJava/learnJavaFundamentals.txt)
   1. [How to return multiple items from a method](/learnJava/howToReturnMultipleItemsFromMethod.txt)
   1. [Lists vs Fixed Arrays](/learnJava/learnArraysAndArrayLists.txt) -- looping, passing lists into methods, finding element in a list
   1. Working with maps

1. Create a FilterService to convert list of filter strings into a SQL where clause
     1. [FilterService Class](/learnSpringBoot/lessons/lesson_filterService.outline.txt)<br/>
     1. Exercise: Create a FilterParams class
     1. Exercise: Implement the methods in the FilterService class (to get more practice with lists and maps)

1. Creating unit tests w/JUnit
   1. [Fundamentals of Unit Tests](/learnSpringBoot/lessons/lesson17_unitTestsFundamentals.txt)<br/>
   1. Exercise: Create a test case for the service class<br/>
   1. Exercise: Create a test case for the controller class<br/>
   1. [Setup Unit Tests that use an Embedded Postgres Data Source](/learnSpringBoot/lessons/lesson18_setupEmbeddedPostgres.txt)<br/>

1. Build a Spring Boot Console Application that talks to ES and postgres<br/>
   1. [Setup Spring Console application as Maven module](/learnSpringBoot/lessons/lesson24_syncApp_setupStructure.txt)<br/>
   1. [Change the app to stay running on startup](/learnSpringBoot/lessons/lesson25_syncApp_staysRunning.txt)<br/>
   1. [Add a Postgres data source and Hikari connection pool](/learnSpringBoot/lessons/lesson26_syncApp_addDataSource.txt)<br/>
   1. [Add an ElasticSearchService](/learnSpringBoot/lessons/lesson27_syncApp_addElasticSearchService.txt)<br/>
   1. [Call Refresh Service on App startup](/learnSpringBoot/lessons/lesson28_syncApp_addRefreshService.txt)<br/>
   1. [Fill-in Refresh Service](/learnSpringBoot/lessons/lesson29_syncApp_fillinRefreshService.txt)<br/>
   1. [Add a mapping to the Sync Service](/learnSpringBoot/lessons/lesson32_syncApp_addMapping.txt)
   1. [Add data to your new ES index](/learnSpringBoot/lessons/lesson33_syncApp_addDataToIndex.txt)
   1. [Improve Error Checking](/learnSpringBoot/lessons/lesson34_syncApp_improveErrorChecking.txt) after running the bulk index operation
   1. [Switch the alias](/learnSpringBoot/lessons/lesson35_syncApp_switchAliases.txt)
   1. [Cleanup old indices](/learnSpringBoot/lessons/lesson36_syncApp_cleanup.txt)
   1. [Sync priority and created_date fields using a database view](/learnSpringBoot/lessons/lesson37_syncApp_syncFieldsUsingView.txt)
   1. [Add Embedded Data Source unit tests](/learnSpringBoot/lessons/lesson30_syncApp_addEmbeddedDataSource.txt)<br/>
   1. [Add Embedded ElasticSearch unit test](/learnSpringBoot/lessons/lesson31_syncApp_addEmbeddedElasticSearch.txt)<br/>
   
1. Even More Java:  Handling Java Exceptions
   1. What happens when controller method throws an exception?
   1. How to gracefully handle exceptions in a controller   
   1. [Setup a generic Exception handler](/learnSpringBoot/lessons/lesson23_setupExceptionHandler.txt) to log errors in Spring Beans
   1. Create your own "404 not found" page template -- e.g., 404.html file
      
1. Learn Advanced SQL
   1. Run SQL to join tables
   1. Run SQL to aggregate values (group by SQL)
   1. Working with database views
   1. Working with database materialized views   
   
1. Run SQL code in Java w/Spring-JDBC
   1. Run Java code to get next value from a sequence
   1. Run Java code to run SQL update and delete calls
   1. Run Java code to run SQL insert and return newly-created id
  
1. Run SQL transactions in Java w/Spring-JDBC
   1. [Run Java code to execute a transaction w/o returning anything](/learnSpringJdbc/howToRunSqlTransactionWithNoResults.txt)
   1. [Run Java code to execute a transaction that returns an object](/learnSpringJdbc/howToRunSqlTransactionWithReturnObject.txt)
   
1. Create a REST endpoint that returns a list of data
   1. Construct SQL join that retrieves the data
   1. Create Java model object
   1. Create Service class to run SQL call, return list of objects
   1. Create Controller class with REST endpoint
   1. Add Angular front-end call

1. Create a REST endpoint that returns a file

1. Create a REST endpoint that returns CSV values

1. Using Spring Profiles
   1. How to setup multiple profiles in application.yaml -- e.g., "dev", "prod"
   1. How to switch profiles

1. More Maven Tricks
   1. Setup a maven profile that will replace logback.xml and application.yaml with different files (for production)
   1. [Tell maven to run "npm install" when running npm clean install](/learnMaven/howToTellMavenToRunNpmInstall.txt)
   1. [Tell maven to include the build-user, build-time, jenkins build name](/learnMaven/howToAddToManifestInfoToJar.txt) into the manifest uber jar

1. How to Create an "About" Page that displays the MANIFEST.MF
   1. Adjust Maven to create a manifest.txt
   1. Add REST call that returns the contents of manifest.txt
   1. Add page call to forward to manifest.htm
   1. Create manifest.htm page that invokes the REST call
   
1. Encoding Passwords w/Jasypt<br/>
   [Excercise: Encode database password](/learnSpringBoot/howToUseJasyptToEncode.txt)

1. Run Java code after your web app has started
   1. Used to run health checks

1. Security Design & Decisionss
   1. [What will be protected](/learnSpringBoot/lessons/lesson19_securityDecisions.txt) in addition to REST calls?
   1. [Will security be implemented inside or outside](/learnSpringBoot/lessons/lesson19_securityDecisions.txt) of the REST code?
   1. Will you use PKI authentication or login/password?
   
1. Add SSL and PKI Client Certificate Authentication
   1. Setup your own Certificate Authority&nbsp;&nbsp;[(in Windows)](/learnSSL/howToUseYourCertAuthority_InitialSetup.txt)&nbsp;&nbsp;[(in Unix)](/learnSSL/howToUseYourCertAuthority_InitialSetup_centos7.txt)<br/>
   1. Create your own server certificate&nbsp;&nbsp;[(in Windows)](/learnSSL/howToUseYourCertAuthority_MakeServerCert.txt)&nbsp;&nbsp;[(in Unix)](/learnSSL/howToUseYourCertAuthority_MakeServerCert_centos7.txt)<br/>
   1. Create your own PKI client certificate&nbsp;&nbsp;[(in Windows)](/learnSSL/howToUseYourCertAuthority_MakeClientCert.txt)&nbsp;&nbsp;[(in Unix)](/learnSSL/howToUseYourCertAuthority_MakeClientCert_centos7.txt)
   1. [Configure SpringBoot to use require PKI certificates to protect REST endpoints using AuthorizationFilter](/learnSpringBoot/lessons/lesson20a_secureWebappWithPki_authFilter.txt)
   1. [Configure SpringBoot to use require PKI certificates to protect REST endpoints using PreAuthorize](/learnSpringBoot/lessons/lesson20b_secureWebappWithPki_preAuthorize.txt)
   1. Setup a Spring Profile called "dev"  that uses http
   1. Setup a Spring Profile called "prod" that uses https
   1. [How to create a mocked logged-in user for test classes](/learnSpringBoot/lessons/lesson21_testControllersWithMockUser.txt)

1. Add an AngularJS front-end
   1. [Add a navigation bar](/learnAngularJS/lessons/lesson02_setupNavigationBar.txt)
   1. ["Add Report" Page: Setup](/learnAngularJS/lessons/lesson03_addReportPage.txt)
   1. ["Add Report" Page: Press "Save" Invokes REST call](/learnAngularJS/lessons/lesson04_addReportPage_invokeRestCallOnSave.txt)
   1. ["Add Report" Page: Add Spinner](/learnAngularJS/lessons/lesson05_addReportPage_addSpinner.txt)
   1. ["Add Report" Page: Form Validation](/learnAngularJS/lessons/lesson06_addReportPage_formValidation.txt)
   1. ["Add Report" Page: Setup Lookup REST Call](/learnAngularJS/lessons/lesson07_addReportPage_addLookupRestCall.txt)
   1. ["Add Report" Page: Setup Lookup Factory](/learnAngularJS/lessons/lesson08_addReportPage_addLookupFactory.txt)
   1. [Improve Lookup Factory with map of lookups](/learnAngularJS/lessons/lesson09_improveLookupFactoryWithMaps.txt)
   1. [Improve Lookup Factory with a front-end Cache](/learnAngularJS/lessons/lesson10_improveLookupFactoryWithCache.txt)
   1. [Add a page that has a UI-Grid](/learnAngularJS/lessons/lesson11_setupGrid.txt)
   1. [Have page wait for REST calls to resolve](/learnAngularJS/lessons/lesson12_setupGridDataWithResolve.txt)
   1. [Setup Grid Filter dropdowns](/learnAngularJS/lessons/lesson13_setupGridFilterDropDowns.txt)
   1. [Setup Grid Filter w/Look Factory for Drop Downs](/learnAngularJS/lessons/lesson14_setupGridWithLookupFactory.txt)
   1. [Setup Grid Filter w/Server Side REST calls](/learnAngularJS/lessons/lesson15_setupGridServerSideFiltering.txt)
   1. Have front-end wait for user's permissions
   1. [Add a External Export Menu Option](/learnAngularJS/lessons/lesson16_addMenuOptionForExportCsv.txt)
   1. Add a page with Tabs
   1. [Add a page with Graphs](/learnAngularJS/lessons/lesson17_addGraphsToPage.txt)
   
1. Building & Deployment
   1. Create Jenkins Job to build the uber JAR
   1. Add a MANIFEST.MF to your uber JAR
   1. Read the contents of the MANIFEST.MF from command-line
   1. Create a web page that displays the contents of MANIFEST.MF

