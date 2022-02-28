Lesson 8a:  Add a Message Service
---------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1S9UhBButmuNh_CSMm4QNSVkKDn6NeK4FcXTI16vQDCE/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson8a/message-service
<br>
<br>
Problem: We want all success/error messages to be displayed in a central place<br>
So, when a user saves a new report, the message shows in the console and then disappears<br>
<br>
<br>
 


![](https://lh3.googleusercontent.com/6KjDUfv4ZYcKJJun_WlQ7GXjHgiRTfJ3LrhiFqYNG5Wt4PElVa9AP0u-3lui6ozRRfjdaAs0uSHiqJFC8rd2nWXfy6IV1Zz2ns1GA0_wDSzHpblr80oxp2C4gmQ3PBbag8H3TVPs)
NOTE: The snackbar shows a message on the bottom of the screen that will auto-disappear after 6 seconds.
<br>
<br>
<br>


```
Procedure
    1. Add the SnackBar module
        a. Edit app.module.ts

        b. Add this to the imports:

         imports: [ MatSnackBarModule, ... ]

         
         NOTE:  If you get errors in your app.module.ts, then
            A) Delete the frontend/node_modules directory  (and all of its sub-directories)
            B) Right-click on frontend/package.json -> Run 'npm install'
            C) Wait for IntelliJ to finish reindexing
            D) Then, your app.module.ts should be good

    2. Create the message service
       unix> cd ~/intellijProjects/angularApp1/frontend
       unix> ng generate service services/message

    3. Setup the MessageService with a public method called sendMessage()
       a. Edit message.service.ts

       b. Replace its contents with this:
            import { Injectable } from '@angular/core';
            import {MatSnackBar} from "@angular/material/snack-bar";
        
            @Injectable({
                  providedIn: 'root'
            })
            export class MessageService {
        
              public constructor(private snackBar: MatSnackBar) { }
        
                  public sendMessage(message: string) {
                this.snackBar.open(message, 'Done',
                 {
                    duration: 6000,                // Close the message after 6 sec
                    verticalPosition: 'bottom',
                    horizontalPosition: 'center'
                  });
        
                 }  // end of method
        
             }

    4. Modify the add-report.component.ts to inject the MessageService and send a message upon save()
        a. Edit the add-report2.component.ts

        b. Inject the MessageService by adding it to your constructor.
           So your constructor looks something like this:
		
                constructor(private messageService: MessageService,
                           private formBuilder: FormBuilder)
                { }

        c. Change the save() method so that it uses the messageService.sendMessage() method
           Add this to the save() method:

                // Send a message 
                this.messageService.sendMessage("Successfully saved this report");
            

    5. Try it out
        a. Activate the debugger
        b. Go to the "Add Report 2" page
        c. Fill in the required fields
        d. Press "Save"
           -- You should see a message in the console
           -- After 6 seconds, the console message should disappear


```
