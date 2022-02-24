Lesson 21c:  BDP / Deploy the RDA
---------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1OcilaI2z07CgAZviu5UBq9EiR0alMuZ-WA472-1AbLM/edit?usp=sharing
      

<br>
<br>

```
Assumptions
-----------
    A. You have putty installed
    B. You have a unix account on the target bdp
    C. Your BDP has these IP address
        a. The Puppet master has this IP address:   			10.1.21.100
        b. The RDA deployer has this IP address (inside the bdp):  	10.1.21.102
        c. The proxy server has this IP address:  			10.1.21.107

    D. You have a BDP account and were provided a p12 file  (client PKI certificate file)
    E. You have imported the client PKI certificate file into your browser
    F. You can reach your BDP using this url:				https://10.1.21.107/





Why You Need a Tunnel to Reach the RDA Deployer
------------------------------------------------
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson21c_image1.png)
```



Approach
--------
    A. Build the RDA

    B. Use Putty to setup a tunnel so that 
        https://localhost:9998 --> RDA Deployer

    C. Connect to the RDA Deployer on https://localhost:9998

    D. Use the RDA Deployer to upload, deploy, and start the AngularApp1 webapp

    E. Verify that the AngularApp1 webapp started (by examining the log files)




How to Setup Tunnel without putty
---------------------------------
Suppose you want to setup local port 9998 --> rda deployer server (10.1.21.102) port 9998
unix> ssh  -N -L 9998:10.1.21.102:9998  -D 5000 aresnick@10.1.21.100

There are 4 parts to the ssh command:
    • The -N 	 			means to NOT create a shell
    • The -L 9998:10.1.21.102:9998 	forwards localhost:9998 -->  10.1.21.102:9998
    • The -D 5000				creates a dynamic port 5000  (to view log files)
    • The aresnick@10.1.21.100  		means use this unix account on the puppet master (10.1.21.100)    



Procedure
---------
    1. Stop your debugger


    2. Build the webapp.rda.zip
       unix> cd ~/intellijProjects/angularApp1
       unix> mvn clean package -Pprod -PbuildRda


    3. Verify that your zip has the following directory structure
        
       If using Windows, then use 7zip to list the contents of the zip file:
       dos>  set PATH=%PATH%;c:\progra~1\7-zip
       dos>  7z l install-bdp\target\webapp.rda.zip
        
       If using unix, run this command to list the contents of the zip file:
       unix> unzip -l install-bdp/target/webapp.rda.zip


        Te webapp.rda.zip should contain the directory structure:
        
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

    4. If your BDP is behind a VPN, then activate your VPN   (so you can reach the puppet master)

    5. Setup an ssh tunnel such that localhost:9998 --> rda_deployer_server:9998
        a. Startup putty

        b. In the Host Name, type-in 10.1.21.100          (this is the puppet master)
            Under Saved Sessions, type-in Lab rda tunnel and socks
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson21c_image2.png)
```


        c. On the left side, browse to Connection --> SSH
            i. Check "Don't start a shell or command at all"
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson21c_image3.png)
```


        d. Setup the tunnel so that localhost:9998 --> 10.1.21.102:9998
            i. On the left side, browse to Connection --> SSH --> Tunnels

            ii. In Source port, enter 9998
                In Destination:  10.1.21.102:9998                (This is the RDA deployer server)
                In Destination:  Check "Local" and "Auto"
                Press "Add"

           iii. In Source port, enter 5000
                In Destination:  It's blank
                In Destination, Check "Dynamic" and "Auto"
                Press "Add"

        e. When finished, your tunnels should look like this:
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson21c_image4.png)
```


        f. Save your session by clicking on "Session" on the left and press "Save" on the right.


        g. Verify that your tunnel was saved
            i.   Close-up Putty
            ii.  Start-up Putty
            iii. Single-click on your "Lab rda tunnel and socks" and press Load
            iv.  Browse to Connection -> SSH -> Tunnels
                 -- You should see the same tunnels as on the previous page.


    6. Activate your tunnel
        a. Startup Putty
        b. Double-click on "Lab rda tunnel and socks"
        c. Enter your BDP unix username and password



    7. Create a new firefox profile called "Lab Dev BDP Profile"
        a. Startup the Firefox Profile Manager

Windows
DOS> cd "C:\Program Files\Mozilla Firefox"
DOS> firefox -p

Unix
unix> firefox  -p

        b. Press "Create Profile"
        c. Press "Next"
        d. In the "Create Profile" popup
Name:  Lab Dev Profile
Press "Finish"

        e. In the firefox browser that opens
            i. Import the BDP p12 file into your Firefox browser
                1. Pull Tools -> Settings
                2. Search for certificates
                3. Click on "View Certificates"
                4. Click on "Your Certificates"
                5. Press "Import"
-- Browse to your BDP p12 file

            ii. Add a bookmark for the RDA Deployer 
                1. Go to https://localhost:9998/deployer
                2. Press Control-D 
                3. Set the name as RDA Deployer

            iii. Add a bookmark for the App1 Webapp --> https://10.1.21.107/app1
                1. Go to  https://10.1.21.107/app1
                2. Press Control-D


        f. Make the default home page take you to the deployer url
              i. In the url, enter this:  about:preferences
             ii. Click on the "Home" button   [on the left]
            iii. Set the dropdown to "Custom URLs..."
                 Url:   https://localhost:9998/deployer
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson21c_image5.png)
```



        g. Setup this Firefox Profile to use the socks tunnel
            i. In the url, enter this:  about:preferences
            ii. search for proxy
            iii. Click on the "Settings"  for Network Settings
            iv. Click "Manual proxy configuration"
Socks Host:  localhost
Socks port:   5000 
Check the "SOCKS v5"

            v. Check "Proxy DNS when using SOCKS v5"
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson21c_image6.png)
```

        h. Close-up Firefox


At this point, if you need to reach the RDA deployer, the process is always the same
 A) Activate your VPN Client
 B) Use Putty to setup your SSH Tunnel
 C) Startup the Firefox Profile manager                  (by running firefox -p)
 D) Select your Lab Dev BDP Profile
      --> This will automatically take your to the RDA deployer



Part 2:  Use the RDA Deployer to Deploy the AngularApp1 Web App
    1. Use your "Lab Dev BDP Profile" to deploy the RDA
        a. Startup the Firefox Profile Manager
           unix> firefox  -p

        b. Choose "Lab Dev BDP Profile"   (as it has the BDP client certificate loaded and the bookmarks)

        c. Go to the RDA Deployer url:   https://localhost:9998/deployer

    2. Upload the RDA
        a. Press the "UPLOAD RDA" button (in the upper right corner)
        b. Browse to your intellijProjects/angularApp1/install-bdp/target/webapp.rda.zip
           NOTE:  If it uploads successfully, you should see "AngularApp1 Web App" listed on the left side



    3. Deploy the RDA
       You should see "AngularApp1 Web App" on the left side
        a. Select the 3 dots and press "Deploy"
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson21c_image7.png)
```



        b. Single-click on "AngularApp1 Web App" on the left
           NOTE:  You should see 2 components on the right

        c. Single-click on the 2nd component (on the right) to view configuration options

        d. Verify that the Configuration has the right command
           Press "CONFIGURATION" and look at the command:

```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson21c_image8.png)
```

        The command should hold this:
           java -Djava.io.tmpdir=./  -jar webapp/backend-exec.jar --server.port=${HTTPS_PORT}
                e. Press the 3 dots next to "STOPPED" and change it to "START"



        e. Press the 3 dots next to "STOPPED" and change it to "START"
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson21c_image9.png)
```

        f. Verify that the web app started (by examining the backend log file)
           Press "RUNS/LOGS"
           Keep pressing "Refresh" until you see 2 containers:
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson21c_image10.png)
```


        g. Click on the second container -- e.g., CONTAINER_010000002

        h. Keep refreshing the web browser (by pressing F5) until you see slider-service.log
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson21c_image11.png)
```

        i. Click on slider-service.log   (this holds all of the back-end logging output)



        j. Verify that you see the "WebApp is Up." message
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson21c_image12.png)
```
        The "WebApp is Up" message is present.  So, the angularApp1 web app is up.

