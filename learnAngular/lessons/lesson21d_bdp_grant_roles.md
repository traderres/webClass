Lesson 21d:  BDP / Use Citadel to Grant Roles / Disable White Label
-------------------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1urjgfQIARbPcuvDnGfQ0wP7dZxoiPQ4s3UXqjNxm_JI/edit?usp=sharing
      

<br>
<br>

<h3> Problem Set </h3>
Problem:  My webapp is running on the BDP but I get "Forbidden" messages.<br>
Solution:  Use the BDP's Citadel to grant the READER role to our BDP account.<br>


If your BDP account is not granted the READER or ADMIN role, then you cannot get to the main page.


<br>
<br>
If you have <u>enabled</u> the whitelabel error page, then you would see this:<br>
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson21c_image1.png)

<br>
<br>
<br>
If you have <u>disabled</u> the whitelabel error page, then you would see this:<br>
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson21c_image1.png)
<br>
<br>
<br>

```

Assumptions
-----------
    A. You have putty installed
    B. You have a unix account on the target bdp
    C. The BDP Puppet master has this IP address:   	10.1.21.100


How to grant the "ADMIN" role to your BDP Account
-------------------------------------------------
    1. Connect to the puppet master
        a. Startup putty
        b. ssh to 10.1.21.100        # connect to the puppet master

    2. In the putty window
        a. Enter your bdp unix account
        b. Enter your bdp unix password

    3. Grant the ADMIN role to this account
       unix> sudo -s 
        
       # Get a list of all users in the system
       unix> citadel user:list
        
       # Once you find your username, set this variable
       unix> export USERNAME=john_smith
        
       # Show this user's current roles
       unix> citadel user:get -u $USERNAME
        
       # Grant the ADMIN role to this user
       unix> citadel attribute:add --username $USERNAME -a  ROLE:ADMIN 
        
       # Show this user's current roles  (we should see ADMIN)
       unix> citadel user:get -u $USERNAME
       unix> exit
       unix> exit

    4. Verify if the updated roles work
       a. Close your web browser (that you used to connect to the angularApp1)

       b. Open a new web browser and connect to angularApp1
          Go to https://10.1.21.107/app1/

       c. Look at your allowed maps
          Go to https://10.1.21.107/app1/api/user/me



How to Disable the White Label Error Page
-----------------------------------------
    1. Edit the production application.yaml

    2. Add the changes in bold

        # Tell Spring to disable DataSource Auto Configuration (so you can run the app without a datasource)
        # Tell Spring to disable using the White label ErrorMvcAutoConfiguration
        spring.autoconfigure:
             exclude:
            - org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration
            - org.springframework.boot.autoconfigure.orm.jpa.HibernateJpaAutoConfiguration
            - org.springframework.boot.autoconfigure.web.servlet.error.ErrorMvcAutoConfiguration
        
        # Disable the white label page
        server.error.whitelabel.enabled: false


    3. Build the Webapp as an RDA

    4. Deploy the new webapp


```
