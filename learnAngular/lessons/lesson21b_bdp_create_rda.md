Lesson 21b:  BDP / Add Maven Module to Create RDA
-------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1-fnKeIfVPqzqTEeSlxmUyDlu5y_l3gwMdr30QGuaAQ0/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson21b/bdp/add-module-to-create-rda
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem:  In order to deploy the webapp, we need to package it as an RDA<br>
Solution:  Add a maven module that will build the RDA zip file<br><br>

```
When completed, the webapp.rda.zip should contain the following directory structure:

      Length      Date Time    Name
    ---------  -----------  ------   -----------
            0  07-08-2020    21:22   webapp/
     48236080  07-08-2020    21:22   webapp/backend-exec.jar
          534  07-08-2020    18:55   initial.config
         1327  07-08-2020    18:52   rda.manifest
            0  07-08-2020    21:22   config/
         3096  07-08-2020    18:30   config/application.yaml
    ---------                        -----------
     48241037                        6 items

```


<br>
<br>

```

Approach
--------
    A. Add a new Maven module called "install-bdp"

    B. Replace the files so it has this structure:
	./install-bdp/src
	./install-bdp/src/main
	./install-bdp/src/main/assembly
	./install-bdp/src/main/assembly/config
	./install-bdp/src/main/assembly/config/application.yaml
	./install-bdp/src/main/assembly/rda.manifest
	./install-bdp/src/main/assembly/assembly.xml
	./install-bdp/src/main/assembly/initial.config
	./install-bdp/pom.xml

    C. Adjust the install-bdp/pom.xml so that when running in the "buildRda" profile it will
        a. Build the uber-jar
        b. Add the uber-jar to a zip file and call it "backend-exec.jar"
        c. Add the config/application.yaml
        d. Add the rda.manifest
        e. Add the initial.config

    D. Use Maven to build the RDA file

    E. Verify that the generated RDA file is complete



Procedure
---------
    1. Turn off your debugger  (if it's running)

    2. Add a maven module named install-bdp to the angularApp1
        a. Open the angularApp1 project in Intellij
        b. Right-click on angularApp1 -> New -> Module

        c. In the "New Module" popup
            i. On the left, click "Maven"
            ii. On the right, click "Create from archetype"
            iii. Select maven-archetype-quickstart
            iv. Press "Next"


        d. In the next popup,
            i. Set the name:    install-bdp
            ii. Under Artifact Coordinates, make sure your maven artifacts match the screen shot
            iii. Press Next



        e. In the next popup, press "Finish"

            Intellij should add the install-bdp maven module and create an install-bdp/pom.xml file for you.



    3. Adjust the install-bdp directory structure
        a. Remove this directory:  	install-bdp/src/test/             	
        b. Remove the directory:   	install-bdp/src/main/java/       
        c. Add this directory:		install-bdp/src/main/assembly/    	
        d. Add this directory:		install-bdp/src/main/assembly/config/ 


    4. Tell Git to ignore compiled files found in the new install-bdp/target/ directory
       NOTE:  Every time we create the webapp.rda.zip, we do not want it to show up in the Git window

        a. Edit angularApp1/.gitignore

        b. Add this entry:
            
            ## Ignore the target directories found in install-bdp
            install-bdp/target/*




    5. Add the production application.yaml
        a. Right-click on install-bdp/src/main/assembly/config -> New -> File
           Filename:  application.yaml

            NOTE:  Do *NOT* add any leading spaces on the left side
            If you have left spaces, then highlight text and press Shift-tab to reverse indent


        b. Copy this to your newly-created file:
            
            #######################################################################
            # application.yaml   (used for **PRODUCTION** purposes)
            #
            # This is the application.yaml that will be packaged into the RDA
            #######################################################################
            name: app1
            server.servlet.context-path: /
            
            
            # Enable cors check because we are *NOT* running in local dev mode
            disable.cors: false
            
            # Set the Active profile to be prod
            spring.profiles.active: prod
            
            # Tell Spring to disable DataSource Auto Configuration (so you can run a springboot app without a datasource
            spring.autoconfigure:
                 exclude:
                       - org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration
                       - org.springframework.boot.autoconfigure.orm.jpa.HibernateJpaAutoConfiguration
            
            
            # Tell Spring to not run flyway
            # NOTE:  In the DataSourceConfig, there is code to run flyway migrate on webapp startup
            spring.flyway.enabled: false
            
            
            #################################################################
            # File Upload Settings
            #################################################################
            spring.servlet.multipart.enabled: true
            
            # Set the maximum file upload size for one file	(-1 is unlimited)
            spring.servlet.multipart.max-file-size: 24MB
            
            
            # Set the maximum request size
            # If a user uploads 5 files of 1 MB, then the entire request size is 25 MB   (-1 is unlimited)
            spring.servlet.multipart.max-request-size: 25MB
            
            
            
            #################################################################
            # Database Settings
            # ASSUMPTION:  The appKey in the rda.manifest is "angularApp1"
            #################################################################
            app.datasource:
              driver-class-name: org.postgresql.Driver
              url: jdbc:postgresql://{{{bdp:postgresql.servers}}}/{{{ angularApp1:db.name }}}
              username: {{{ angularApp1:db.username }}}
              password: {{{ angularApp1:db.password }}}
              schema: public
              maxPoolSize: 10
              flyway-migrate-on-startup: true
            
            
            
            ###########################################################
            # ElasticSearch Settings
            ##########################################################
            es:
              url: {{{bdp:proxy.url}}}/elasticsearch-primary
              ssl_enabled: true
              add_bdp_security: true
              client-p12: /etc/pki/java/keystore.p12
              client-p12-password: changeit
              trust-store: {{{bdp:host.pki.truststore.jks}}}
              trust-store-password: {{{bdp:host.pki.truststore.password}}}
              trust-store-type: JKS
            
            
            
            ###########################################################
            # SSL Settings
            ##########################################################
            ssl.security.mode: header
            
            server:
                  ssl:
                    key-store: {{{bdp:host.pki.keystore.jks}}}
                    key-store-password: {{{bdp:host.pki.keystore.password}}}
                    key-store-type: JKS
                    client-auth: need
                    trust-store: {{{bdp:host.pki.truststore.jks}}}
                    trust-store-password: {{{bdp:host.pki.truststore.password}}}
                    trust-store-type: JKS
                    enabled: true
            
            # Secure the cookies
            server.servlet.session.cookie.secure: true
            server.servlet.session.cookie.http-only: true
            
            # We are running on the BDP, so get the CN info from passed-in headers
            use.hardcoded.authenticated.principal: false

    6. Add this file:  initial.config
        a. Right-click on install-bdp/src/main/assembly -> New File
           filename:  initial.config

        b. Copy this to your newly-created file:
            
            [{
                    "type":  "web-service",
                    "name":  "AngularApp1 Web App",
                    "config": {
                            "container": {
                                "instances": 1,
                                "cores": 	1,
                                "memory":	1000
                        },
                        "app": {
                                "command": "java -Djava.io.tmpdir=./  -jar webapp/backend-exec.jar --server.port=${HTTPS_PORT}"
                            },
                        "navigatorApps": [{
                            "name": "Angular App1 Web App",
                            "appPath": "/app1"
                            }]
                    }
            }]





    7. Add this file:  rda.manifest
        a. Right-click on install-bdp/src/main/assembly -> New File
           filename:  rda.manifest

        b. Copy this to your newly-created file:
            
            {
                "name":    	"AngularApp1 Web App",
                "description": "A web application containing....",
                "appKey":  	"angularApp1",
                "version": 	"1.0.0-SNAPSHOT",
                "components": [
                    {
                            "type": "postgresql",
                            "name": "AngularApp1 Database",
                            "description": "Create the app1_db database and user for this webapp.",
                            "properties": {
                                "public": {
                                    "db.name": "app1_db",
                                    "db.username": "{{{ postgresql.username }}}",
                                    "db.password": "{{{ postgresql.password }}}"
                            }
                        },
                            "config": {
                            "databases": [{
                                        "name": "app1_db",
                                        "create": true
                                }]
                            }
                    },
            
                    {
                            "type": "web-service",
                            "name": "AngularApp1 WebApp",
                            "description": "Some web app that does something",
                            "config": {
                                "context": "/app1",
                                "files": [
                                    {
                                        "src": "webapp"
                                    },
                                    {
                                        "src": "config/application.yaml",
                                        "template": true
                                    }
                                ]
                            }
                    }
                ]
            }


    8. Add this file:  assembly.xml
        a. Right-click on install-bdp/src/main/assembly -> New File
           Filename:  assembly.xml

        b. Copy this to the newly-created file:
            
            <assembly xmlns="http://maven.apache.org/plugins/maven-assembly-plugin/assembly/1.1.2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="http://maven.apache.org/plugins/maven-assembly-plugin/assembly/1.1.2 http://maven.apache.org/xsd/assembly-1.1.2.xsd">
                <id>buildRdaZipFile</id>
            
                <includeBaseDirectory>false</includeBaseDirectory>
            
                <formats>
                        <format>zip</format>
                </formats>
            
                <fileSets>
                        <fileSet>
                                <!-- Add to the zip file:  initial.config and rda.manifest -->
                                <directory>src/main/assembly</directory>
                                <outputDirectory>./</outputDirectory>
                                <includes>
                                        <include>initial.config</include>
                                        <include>rda.manifest</include>
                                </includes>
                        </fileSet>
            
                        <fileSet>
                                <!-- Add to the zip file:  config/application.yaml -->
                                <directory>src/main/assembly/config</directory>
                                <outputDirectory>./config</outputDirectory>
                                <includes>
                                        <include>application.yaml</include>
                                </includes>
                        </fileSet>
                </fileSets>
            
                <files>
                        <file>
                            <!-- Add to the zip file:  webapp/backend-exec.jar -->
                            <!-- NOTE:  We need this section to include *AND* rename the file to backend-exec.jar -->
                            <source>../backend/target/backend-${project.version}-exec.jar</source>
                            <outputDirectory>./webapp</outputDirectory>
                            <destName>backend-exec.jar</destName>
                        </file>
                </files>
            </assembly>


    9. Adjust the install-bdp/pom.xml so that
       -- It's dependent on the backend jar (so the uber jar is built *first*)
       -- It packages it and inserts it into a zip file (*second*)
        a. Edit the install-bdp/pom.xml

        b. Replace its contents with this:
            
            <?xml version="1.0" encoding="UTF-8"?>
            
            <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
            http://maven.apache.org/xsd/maven-4.0.0.xsd">
                <parent>
                    <artifactId>angularApp1</artifactId>
                    <groupId>com.lessons</groupId>
                    <version>1.0-SNAPSHOT</version>
                </parent>
                <modelVersion>4.0.0</modelVersion>
            
                <artifactId>install-bdp</artifactId>
            
                <!-- There is no java code so tell maven to not compile anything -->
                <packaging>pom</packaging>
            
            
                <name>install-bdp</name>
            
                <dependencies>
                    <dependency>
                        <!-- Build the backend *before* doing this -->
                        <groupId>${project.groupId}</groupId>
                        <artifactId>backend</artifactId>
                        <version>${project.version}</version>
                    </dependency>
                </dependencies>
            
                <profiles>
                    <profile>
                        <id>buildRda</id>
                        <activation>
                            <activeByDefault>false</activeByDefault>
                        </activation>
                        <build>
                            <plugins>
                                <plugin>
                                    <artifactId>maven-assembly-plugin</artifactId>
                                    <version>3.3.0</version>
                                    <executions>
                                        <execution>
                                            <id>create-rda</id>
                                            <phase>package</phase>
                                            <goals>
                                                <goal>single</goal>
                                            </goals>
                                        </execution>
                                    </executions>
                                    <configuration>
                                        <appendAssemblyId>false</appendAssemblyId>
            
                                        <!-- The final name of the zip file will be webapp.rda.zip -->
                                        <finalName>webapp.rda</finalName>
            
                                        <descriptors>
                                            <descriptor>src/main/assembly/assembly.xml</descriptor>
                                        </descriptors>
                                    </configuration>
                                </plugin>
                            </plugins>
                        </build>
                    </profile>
                </profiles>
            </project>


    10. Change the parent pom.xml so that it only runs the install-bdp module when using the -PbuildRda
        a. Edit angularApp1/pom.xml

        b. Remove the <modules>...</modules> section from the top of this file

        c. Append this section before the closing </project> tag
            
              <profiles>
                <profile>
                <!-- When running the buildRda profile, use all 3 modules -->
                <id>buildRda</id>
            
                <modules>
                    <module>backend</module>
                    <module>frontend</module>
                    <module>install-bdp</module>
                </modules>
                </profile>
            
                <profile>
                <!-- By default, look only at backend and frontend modules -->
                <!-- Most of the time, developers do not need to run the install-bdp module so disable it with the default profile -->
                <id>default</id>
                <activation>
                    <activeByDefault>true</activeByDefault>
                </activation>
                <modules>
                    <module>backend</module>
                    <module>frontend</module>
                </modules>
                </profile>
              </profiles>


        d. Right-click on the angularApp1/pom.xml -> Maven -> Reload Project

        e. If you get this popup, then press "No"
            
            NOTE:  install-bdp is not a default maven module so IntelliJ is asking you to remove it
            But, when you use the buildRda profile, the install-bdp module is executed.
            -- So, we do not want to remove it.
            



    11. Adjust the backend/pom.xml so that the backend does *not* include this file when using buildRda
  backend/src/main/resources/application.yaml
        a. Edit backend/pom.xml

        b. Append this section before the closing </project> tag
            
              <profiles>
                <profile>
                <!-- When running the buildRda profile, exclude the backend/src/main/resources/application.yaml from the JAR file -->
                <id>buildRda</id>
                <activation>
                    <activeByDefault>false</activeByDefault>
                </activation>
                <build>
                    <resources>
                    <resource>
                        <filtering>true</filtering>
                        <directory>src/main/resources</directory>
                        <excludes>
                        <exclude>application.yaml</exclude>
                        </excludes>
                    </resource>
                    </resources>
                </build>
                </profile>
            
                <profile>
                <!-- When running any other build profile, include *ALL* files from the backend/src/main/resources into the JAR file -->
                <id>defaultProfile</id>
                <activation>
                    <activeByDefault>true</activeByDefault>
                </activation>
                <build>
                    <resources>
                    <resource>
                        <directory>src/main/resources</directory>
                        <filtering>true</filtering>
                    </resource>
                    </resources>
                </build>
                </profile>
              </profiles>

        c. Right-click on the backend/pom.xml -> Maven -> Reload Project


    12. Adjust the install-bdp/pom.xml so that it restores the dev application.yaml after building the RDA
        NOTE:  This solves the problem:
        a. User builds the RDA using mvn clean package -Pprod -PbuildRda
        b. User clicks to debug the "Full WebApp"
        -- The backend/target/classes/application.yaml is the production application.yaml  (which will not start up correctly)
        -- We want the backend/target/classes/application.yaml to be the development application.yaml


        a. Edit install-bdp/pom.xml

        b. Add this <plugin>...</plugin>  immediate after the last plugin in the pom.xml
            
            <plugin>
                <!-- This plugin restores the developer application.yaml to the backend/target/classes/application.yaml           	-->
                <!-- With this plugin added, a user can build the webapp using buildRda and then active the debugger and it all works -->
                <!-- NOTE:  This plugin must appear *AFTER* the above plugin that creates the RDA                                 	-->
                <groupId>com.coderplus.maven.plugins</groupId>
                    <artifactId>copy-rename-maven-plugin</artifactId>
                    <version>1.0.1</version>
                    <executions>
                        <execution>
                                <id>restore-dev-application-yaml</id>
                                <phase>package</phase>
                                <goals>
                                        <goal>copy</goal>
                                </goals>
                                <configuration>
                                        <sourceFile>../backend/src/main/resources/application.yaml</sourceFile>
                                        <destinationFile>../backend/target/classes/application.yaml</destinationFile>
                                </configuration>
                        </execution>
                </executions>
            </plugin>



When finished, the install-bdp/pom.xml looks like this:
-------------------------------------------------------
<?xml version="1.0" encoding="UTF-8"?>

<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
     	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
http://maven.apache.org/xsd/maven-4.0.0.xsd">
	<parent>
    	<artifactId>angularApp1</artifactId>
    	<groupId>com.lessons</groupId>
    	<version>1.0-SNAPSHOT</version>
	</parent>
	<modelVersion>4.0.0</modelVersion>

	<artifactId>install-bdp</artifactId>

	<!-- There is no java code so tell maven to not compile anything -->
	<packaging>pom</packaging>


	<name>install-bdp</name>

	<dependencies>
    	<dependency>
        	<!-- Build the backend *before* doing this -->
        	<groupId>${project.groupId}</groupId>
        	<artifactId>backend</artifactId>
        	<version>${project.version}</version>
    	</dependency>
	</dependencies>

	<profiles>
    	<profile>
        	<id>buildRda</id>
        	<activation>
            	<activeByDefault>false</activeByDefault>
        	</activation>
        	<build>
            	<plugins>
                	<plugin>
                    	<artifactId>maven-assembly-plugin</artifactId>
                    	<version>3.3.0</version>
                    	<executions>
                        	<execution>
                            	<id>create-rda</id>
                            	<phase>package</phase>
                            	<goals>
                                	<goal>single</goal>
                            	</goals>
                        	</execution>
                    	</executions>
                    	<configuration>
                        	<appendAssemblyId>false</appendAssemblyId>

                        	<!-- The final name of the zip file will be webapp.rda.zip -->
                        	<finalName>webapp.rda</finalName>

                        	<descriptors>
                            	<descriptor>src/main/assembly/assembly.xml</descriptor>
                        	</descriptors>
                    	</configuration>
                	</plugin>

                	<plugin>
                    	<!-- This plugin restores the developer application.yaml to the backend/target/classes/application.yaml           	-->
                    	<!-- With this plugin added, a user can build the webapp using buildRda and then active the debugger and it all works -->
                    	<!-- NOTE:  This plugin must appear *AFTER* the above plugin that creates the RDA                                 	-->
                    	<groupId>com.coderplus.maven.plugins</groupId>
                    	<artifactId>copy-rename-maven-plugin</artifactId>
                    	<version>1.0.1</version>
                    	<executions>
                        	<execution>
                            	<id>restore-dev-application-yaml</id>
                            	<phase>package</phase>
                            	<goals>
                                	<goal>copy</goal>
                            	</goals>
                            	<configuration>
                                	<sourceFile>../backend/src/main/resources/application.yaml</sourceFile>
                                	<destinationFile>../backend/target/classes/application.yaml</destinationFile>
                            	</configuration>
                        	</execution>
                    	</executions>
                	</plugin>

            	</plugins>
        	</build>
    	</profile>
	</profiles>
</project>


    13. Use Maven to build the RDA
        a. Build the RDA
           unix> cd ~/intellijProjects/angularApp1
           unix> mvn clean package -Pprod -PbuildRda 


        b. Verify that the backend.jar file does *NOT* have an application.yaml inside of it
            i. Browse to this directory:   angularApp1/install-bdp/target/

            ii. Open this archive:  webapp.rda.zip

            iii. Pull out the webapp/backend-exec.jar and rename it as backend-exec.zip

            iv. Open this archive: backend-exec.zip

            v. Browse to the /BOOT-INF/classes/ directory
                -- You should see logback.xml
                -- You should see reports.mapping.json
                -- You should not see application.yaml 




    14. Verify that your zip file has the correct contents
        If using Windows, then use 7zip to open-up the file and take a look
        dos>  set PATH=%PATH%;c:\progra~1\7-zip
        dos>  7z l install-bdp\target\webapp.rda.zip
        
        If using unix, run this command:
        unix> unzip -l install-bdp/target/webapp.rda.zip
        
              Length  	Date Time    Name
            ---------  -----------  ------   -----------
                    0  07-08-2020    21:22   webapp/
             48236080  07-08-2020    21:22   webapp/backend-exec.jar
                  534  07-08-2020    18:55   initial.config
                 1327  07-08-2020    18:52   rda.manifest
                    0  07-08-2020    21:22   config/
                 3096  07-08-2020    18:30   config/application.yaml
            ---------                   	    -----------
             48241037                 	    6 items


    15. Verify that you can still run the webapp (in dev mode) from the command line
        a. Build the webapp in local dev mode
           unix> cd ~/intellijProjects/angularApp1
           unix> mvn clean package -Pprod

        b. Run the webapp in local dev mode
           unix> java -jar ./backend/target/backend-1.0-SNAPSHOT-exec.jar

        c. Connect to the webapp in local dev mode by going to http://localhost:8080/app1

        d. Stop your jar by pressing Ctrl-C in that window



    16. Verify that your debugger still works
        a. In Intellij Pull Build -> Rebuild Project

        b.  Activate the Debugger on "Full WebApp"

        c. Verify that the webapp comes -up on localhost:4200

        d. Stop the debugger


```
