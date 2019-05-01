## Spring Boot / Maven / Java Lesson Plan


### Assumptions
* You have installed Java JDK 1.8
* You have installed Maven 3.3.9
* You have installed IntelliJ<br/>
  [Setup Development Env for Unix](/learnSpringBoot/lessons/lesson01a_setupDevelopmentEnvForUnix.txt )<br>
  [Setup Development Env for Windows](/learnSpringBoot/lessons/lesson01b_setupDevelopmentEnvForWindows.txt)<br>  <br> 
  

### Lesson Plan
1. Java fundamentals<br/>
    [Exercise: Create a simple command-line Java program in Intellij](/learnJava/howToCreateJavaCommandLineProgramUsingIntellijMaven.txt)
    
1. Maven fundamentals<br/>
    Exercise: Add logback to thee command-line Java program

1. Spring fundamentals
   1. Lifecycle:  Constructor, Injection, Post-Construct
   1. Application Context / Spring beans (how does Spring manage them)
   1. Exercise: Adjust existing CDE webapp and inject code

1. Build SpringBoot webapp w/simple REST call
   1. [Exercise: Build Spring Boot Structure](/learnSpringBoot/lessons/lesson02_createProjectStructure.txt)<br/>
   1. [Exercise: Setup Springboot as Runnable JAR](/learnSpringBoot/lessons/lesson03_setupRunnableJar.txt)<br/>

1. Add a REST endpoint (controller)<br/>
   [Exercise: Setup NPM](/learnSpringBoot/lessons/lesson04_addAngularUsingNpm.txt)<br/>
   [Exercise: Add Angular Page](/learnSpringBoot/lessons/lesson05_addSimpleAngularPage.txt)<br/>
   [Exercise: Setup Front End Structure](/learnSpringBoot/lessons/lesson06_addAngularFrontEndStructure.txt)<br/>
   
1. Add JDBC connection pool (data source object)<br/>
   [Exercise: Setup Postgres Database](/learnSpringBoot/lessons/lesson07_setupPostgresDatabase.txt)<br/>
   [Exercise: Add JDBC Connection Pool](/learnSpringBoot/lessons/lesson09_addJdbcConnectionPool.txt)<br/>
   
1. Add REST endpoint w/service layer<br/>
   [Exercise: Add Service Layer](/learnSpringBoot/lessons/lesson10_AddRestEndPoint.txt)<br/>

1. Using Spring Profiles
   1. Setup multiple profiles in application.yaml
   1. Switch profiles<br/>
   
1. Encoding Passwords w/Jasypt<br/>
   [Excercise: Encode database password](/learnSpringBoot/howToUseJasyptToEncode.txt)
   
1. Creating unit tests w/JUnit

1. Add SSL and PKI Client Certificate Authentication
   1. [Setup your own Certificate Authority](/learnSSL/howToUseYourCertAuthority_InitialSetup.txt)
   1. [Create your own server certificate](/learnSSL/howToUseYourCertAuthority_MakeServerCert.txt)
   1. [Create your own PKI client certificate](/learnSSL/howToUseYourCertAuthority_MakeServerCert.txt)
   1. Configure SpringBoot to use your server cert
   1. Configure SpringBoot to require PKI client certificate
   1. Configure Security to protect your REST endpoints
   
1. Add Flyway as separate module<br/>
   [Exercise: Setup Flyway](/learnSpringBoot/lessons/lesson08_addFlyway.txt)<br/>
   
1. Building & Deployment
   1. Create Jenkins Job to build the uber JAR
   1. Add a MANIFEST.MF to your uber JAR
   1. Read the contents of the MANIFEST.MF from command-line
   1. Create a web page that displays the contents of MANIFEST.MF
