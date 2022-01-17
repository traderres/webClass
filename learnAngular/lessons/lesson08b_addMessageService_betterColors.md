Lesson 8b:  Add a Message Service / Improve with Better Colors
--------------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/12kmsK_s1lbiu5tKUB-odNXx-TugSjAElMog4hk9_z9k/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson8b/message-service-improved
<br>
<br>

Most web applications have only 3 kinds of messages:<br>
1\. Success notifications<br>
2\. Warning notifications<br>
3\. Failure notifications<br>

So, let's have the messageService have 3 methods that would display the messages differently
<br>
<br>
<br>


![](https://lh5.googleusercontent.com/BC2v9eCHlWodEhV1V2KZyY1Ufb-Ac2xQcwejYHxSjsUcYURCrMf5biIJ_UyO7HCpZapxWNZb4qrWxFG-NFUSNdFcWZLkemSxWScC_aDRrbMr5sanFDFTocNTUh0ibH-r8-5EEjsq)
The success message is a bright green.
<br>
<br>
<br>
  
  


![](https://lh3.googleusercontent.com/9YtVTlmbjN142AyacFInjrqePyqFLpuXehmNpzHv7CTCNNYgn9Cnpn1oNRj8i5niGvPx1MkHTe38vgDww-ODe8hZ43IbkQUnAlPM0b0tdPL-80EIqw9Mi4DnIVOfFNwkIP6g_lUH)
The warning message uses this ugly orange color. But, it gets your attention.
<br>
<br>
<br>
  
  


**![](https://lh4.googleusercontent.com/lIDGCKGeeFRNuYZSkNTeGXNvQMMhNUYvz2oyWqec2wqp4OUAeW8oYZEroU2k4k_LRCFYJisSr8zYspBt-RT8Rm0p7-Z-hrumpQLx_Him65OlN2f2Y63k9VW3uD0d6coQ22vYKvEh)**
The error message appears in all red.
<br>
<br>
<br>


```
Procedure
---------
    1. Add additional methods to the messageService
        a. Edit message.service.ts

        b. Add these methods:
       
             public showSuccessMessage(message: string): void {
    
                this.snackBar.open(message, 'Done',
                  {
                    duration: 6000,        // Close the popup after 6 seconds
                    verticalPosition: 'bottom',
                    horizontalPosition: 'right',
                    panelClass: ['success-snackbar']
                  });
              }
    
    
              public showWarningMessage(message: string): void {
    
                this.snackBar.open(message, 'Done',
                  {
                    duration: 6000,        // Close the popup after 6 seconds
                    verticalPosition: 'bottom',
                    horizontalPosition: 'right',
                    panelClass: ['warning-snackbar']
                  });
              }
    
    
              public showErrorMessage(message: string): void {
    
                this.snackBar.open(message, 'Done',
                  {
                    duration: 6000,        // Close the popup after 6 seconds
                    verticalPosition: 'bottom',
                    horizontalPosition: 'right',
                    panelClass: ['error-snackbar']
                  });
              }   
             
              
     
    2. Add the css styles to your frontend/src/styles.css
        a. Edit styles.css

        b. Add these style classes to the end of it
            .success-snackbar {
              background: #2e7d32 !important;
              color: white;
              white-space: pre-wrap;
            }

            .warning-snackbar {
              background: #ff8f00 !important;
              color: white;
              white-space: pre-wrap;
            }

            .error-snackbar {
              background-color: #c62828 !important;
              color: white;
              white-space: pre-wrap;
            }

    3. Change your code in add-report2.component.ts to call your messageService.showSuccessMessage()
        a. Edit add-report2.component.ts

        b. Change your save() method so it calls this.messageService.showSuccessMessage();
              this.messageService.showSuccessMessage("Successfully saved this report");

    4. Remove the old sendMessage method from the message.service.ts
        a. Edit message.service.ts

        b. Remove this method:
              public sendMessage(message: string): void {
                this.snackBar.open(message, 'Done',
                {
                    duration: 6000,            	// Close the message after 6 sec
                    verticalPosition: 'bottom',
                    horizontalPosition: 'center'
                });
            
              }  // end of method


    5. Try it out (showing a success message)
        a. Activate the debugger
        b. Go to the "Add Report 2" page
        c. Fill in the required fields
        d. Press "Save"
           -- You should see a success message in the console
           -- After 6 seconds, the console message should disappear
```
![](https://lh6.googleusercontent.com/s0B3cGyn9oLgo47U4mUoAu9BEnYNDgGEQt5s3ifyF5yUjVVW35Lp5x_ztYnWcJoa_JRtCV71LY7MqrlcFczf9EsvwTXfXnnD5YzY2QKrR8G_z-Lbvs9AkpgR04ig6qnT_gbb3bEU)
```



    6. Change your code in add-report2.component.ts so that the save() method calls the  

	messageService.showWarningMessage("Warning Happened.  Be advised.")


    7. Try it out
        a. Activate the debugger
        b. Go to the "Add Report 2" page
        c. Fill in the required fields
        d. Press "Save"
           -- You should see a warning message  in the console
           -- After 6 seconds, the console message should disappear
```
![](https://lh6.googleusercontent.com/I5Mrz3a7-hujhwDAaGcnxwDdjq1Fqa7mVc03Et5-3xEbgjXyQztmyFykufa9Z75q1MAJZegkyUwOpb1ZaAn49rC0jqWM6i3Vg7zZG--9XNOI9FNPg4av2T6G9SI88aBiCfcdw9kn)
```





    8. Change your code in add-report2.component.ts so that the save() method calls this:

	         messageService.showErrorMessage("Failed to save your record.  An error occurred.")


    9. Try it out
        a. Activate the debugger
        b. Go to the "Add Report 2" page
        c. Fill in the required fields
        d. Press "Save"
           -- You should see the error message in the console
           -- After 6 seconds, the console message should disappear
```
![](https://lh4.googleusercontent.com/PfjRb4Cx33EmKS6rQUgba-NYDPRXRKS1jvWaHmfNFiOHdAtIhj7iTa5uWS9Yi4BuKJiUg0wZXt09CYpL1wxQsDXdkKXfumEzAqYf4Y-AW106Hdrdc9OvCr6fb7KSYYRwAeh6Nf6Y)
```




    10. Change the "Save" button so it shows a success message again



```
