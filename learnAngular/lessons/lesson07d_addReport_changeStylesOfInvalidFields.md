Lesson 7c: Add Report / Change the Style of Valid & Invalid Form Fields
-----------------------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1RAKqbrvDEDMQj7w7vKwyzvUWrz2UdkTjlnYf9XDLen4/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson7d/set-style-of-invalid-fields
<br>
<br>
<br>

<h3> Problem Set </h3>

Problem:  How to show if a form field is valid/invalid without having to press the Submit button<br>
Solution:  One approach is to use different CSS classes for valid and invalid form-fields
<br>
<br>
<br>




In this lesson, we will adjust the form fields using CSS
![](https://lh4.googleusercontent.com/UJexUVIomTJRpr0sKl8_aziMEU41POIMsjcE-OTmmTdqPeX9SrinTWXe8LnQvsm_tdJrlhEJ_xHjftA3Ptk3c8R23lLIgV-WFKxAY4rJEx6AQWku_dV97aTKqJBD01P3JVFfEvPM)
<br>
<br>
```
Procedure
---------
    1. Set the CSS class for all invalid fields on this page
        a. Edit add-report.component.css

        b. Add these css classes to it to set invalid fields to red:
            
            input.ng-invalid.ng-touched {
              /* Set the background to red for the form fields that are invalid and were touched */
              background-color: #FA787E;
              color: white;
              padding: 4px;
            }
            
            select.ng-invalid.ng-touched {
              /* Set the background to red for the form fields that are invalid and were touched */
              background-color: #FA787E;
              color: white;
              padding: 4px;
            }
            
            mat-select.ng-invalid.ng-touched {
              /* Set the background to red for the form fields that are invalid and were touched */
              background-color: #FA787E;
              color: white;
              padding: 4px;
            }



    2. Activate the debugger
        a. Pull Run -> Debug 'Full WebApp'
        b. Click on "Add Report"
        c. Go to the "Report Name" textbox
        d. Leave the "Report Name" textbox without setting a value
           -- Because the field has been touched, the field is now invalid.
           -- And, the CSS class is applied.  
           -- So, the field becomes red immediately (without having the user to press "Save")
```
![](https://lh4.googleusercontent.com/UJexUVIomTJRpr0sKl8_aziMEU41POIMsjcE-OTmmTdqPeX9SrinTWXe8LnQvsm_tdJrlhEJ_xHjftA3Ptk3c8R23lLIgV-WFKxAY4rJEx6AQWku_dV97aTKqJBD01P3JVFfEvPM)
```





    3. Set the CSS class for all valid fields on this page
        a. Edit add-report.component.css

        b. Add these css classes to it to set invalid fields to red:
            
            input.ng-valid.ng-touched {
              /* Set the background to green for the form fields that are valid and were touched */
              background-color: #78FA89;
              padding: 4px;
            }
            
            select.ng-valid.ng-touched {
              /* Set the background to green for the form fields that are valid and were touched */
              background-color: #78FA89;
              padding: 4px;
            }
            
            mat-select.ng-valid.ng-touched {
              /* Set the background to green for the form fields that are valid and were touched */
              background-color: #78FA89;
              padding: 4px;
            }
            


    4. Activate the debugger
        a. Pull Run -> Debug 'Full WebApp'
        b. Click on "Add Report"
        c. Go to the "Report Name" textbox
        d. Fill-in a few characters in the "Report Name" text box
        e. Leave the "Report Name" textbox
           -- Because the field name was touched and has data, it is valid
           -- So, the CSS class is applied.  
           -- And, the field is green (without the user having to press "Save")
```
![](https://lh5.googleusercontent.com/XSewJWmV12RX0nhiV_YiY6GQ_1VoWjTzLzoX_Ot14-dEFij5g5z7za1-h1gT4pXF5DGrS3-OwO2Zcwm_SQSTpAZuEJz90SN_BI_Exwk33Q_-3FUVqvrxf_DgPKOI_xWDj4yNJ8eI)
```
 

```
