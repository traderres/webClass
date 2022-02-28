Lesson 13c:  Upload Report / Show Progress Bar for Uploading
------------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1sjrGBZQthe02KCfhMz8g7tBbq8gsOuyYf9DqhrdV_b0/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson13c/add-upload-progress-bar
<br>
<br>
<br>

<h3> Problem Set </h3>

Problem:
- If the user uploads a large file or if the user's bandwidth completely sucks, then the user will be waiting
- If the user must wait, then we should show the user a progress bar  
    
<br>
<br>
This lesson describes how to add an upload progress bar (that increases to 100% as the bytes are uploaded to the back-end spring boot application)

  
  
<br>
<br>

<h3>Approach</h3>

The Uploader object has a property called progress that changes based on how much is uploaded  
- Uploader.progress=10 when 10% of the file has been uploaded  
- Uploader.progress=80 when 80% of the file has been uploaded  
  
We simply have to hook-up a mat-progress-bar with this Uploader.progress value

![](https://lh4.googleusercontent.com/Qh72MhsIJ6daKPoTaWLDfvxuIsuybuvSb5ueZURf_5fIxMPjevTdMKM0MhuHtfKz0qIYKvjNOxncpnRLtkVdZxcdtct_I68lrVEJpwL5TavkQaX8RQH3ATMTovAnguBmw2tjUJoH)




<br>
<br>

```
Procedure
---------
    1. Add the MatProgressBarModule module to app.module.ts
        a. Edit app.module.ts

        b. Add MatProgressBarModule to the imports: [  ] section

        c. Add this to the imports at the top:
            import { MatProgressBarModule} from '@angular/material/progress-bar';



    2. Add a progress bar to the upload page 
        a. Edit upload-report.component.html

        b. Add the progress bar to the bottom of the page:
            
            <!-- Upload Progress Bar -->
            <mat-progress-bar *ngIf="uploader.progress > 0"
                         style="margin-top: 5px" [value]="uploader.progress"></mat-progress-bar>


        c. When completed, the upload-report-component.html should look like this:
            
            <mat-card>
              <mat-card-title>Upload Report</mat-card-title>
            
              <mat-card-content>
                <br/>
                <input type="file" name="file" ng2FileSelect [uploader]="uploader" />
            
                <button type="button" class="btn btn-success btn-s"
                     (click)="uploader.uploadAll()"
                     [disabled]="!uploader.getNotUploadedItems().length" >
                  Upload a file
                </button>
            
                <!-- Upload Progress Bar -->
                <mat-progress-bar *ngIf="uploader.progress > 0" 
                                   style="margin-top: 5px"
                                 [value]="uploader.progress">
                </mat-progress-bar>
            
              </mat-card-content>
            </mat-card>
            




        d. When finished, the upload-report-component.ts file looks like this:
            
            import { Component, OnInit } from '@angular/core';
            import {FileUploader} from "ng2-file-upload";
            import {environment} from "../../../environments/environment";
            import {MessageService} from "../../services/message.service";
            
            
            const backendUploadUrl =  environment.baseUrl + '/api/reports/upload';
            
            @Component({
              selector: 'app-upload-report',
              templateUrl: './upload-report.component.html',
              styleUrls: ['./upload-report.component.css']
            })
            export class UploadReportComponent implements OnInit {
            
              // Make sure the itemAlias matches the
              //     @RequestParam(value = "file" in the REST endpoint on backend
              //
              public uploader: FileUploader = new FileUploader(
                                             {
                                                url: backendUploadUrl,
                                                  queueLimit: 1,
                                             itemAlias: 'file'
                                              });
            
              constructor(private messageService: MessageService) { }
            
              ngOnInit(): void {
                this.uploader.onAfterAddingFile = (file) => {
                  file.withCredentials = false;
                };
            
            
                this.uploader.onCompleteItem = (item: any, response: any, status: any, headers: any ) => {
                  console.log('File uploaded:  item=', item, '  status=', status, '  response=', response, ' headers=', headers);
            
                  // Send a message to the user letting him know if it worked
                  let message = " status=" + status + "   response=" + response;
                  this.messageService.showSuccessMessage(message);
                };
            
            
            
              }  // end of ngOnInit
            }
            

    3. Verify that the progress bar shows
        a. Activate the 'Full WebApp" debugger
        b. Click on "Upload Report"
        c. Press "Choose File" -- browse to a large file 
        d. Press "Upload a file"

You should see a progress bar
```
![](https://lh4.googleusercontent.com/Qh72MhsIJ6daKPoTaWLDfvxuIsuybuvSb5ueZURf_5fIxMPjevTdMKM0MhuHtfKz0qIYKvjNOxncpnRLtkVdZxcdtct_I68lrVEJpwL5TavkQaX8RQH3ATMTovAnguBmw2tjUJoH)
```



Question 1
----------
How would you make the progress bar 10 pixels thick?
[Scroll down to see the answer]
 






































Answer 1
--------
A1. Use CSS and set the height to 10 px in the mat-progress bar

    <!-- Progress Bar -->
    <mat-progress-bar *ngIf="uploader.progress > 0" 
                       style="margin-top: 5px; height: 10px"
                     [value]="uploader.progress">
    </mat-progress-bar>


```
