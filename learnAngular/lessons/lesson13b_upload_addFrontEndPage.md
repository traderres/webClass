Lesson 13b:  Upload Report / Add Front-End Page
-----------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1dO36vt-IhRDfuDqSbloQQYCjBupEfTavVw8sixyT_g8/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson13b/add-frontend-page
<br>
<br>
<br>

<h3> Problem Set </h3>

Problem:  I need a front-end page with an upload button<br>
Solution: Add a page that has an upload file button

![](https://lh3.googleusercontent.com/PVICpadIFtRi-Qe1s6j_SqOBp4SxrJsaeb0sqIXTaF4vQQsv2wdtgTL9yLSeI0fApqbTHwicPFiU0sjV1chgMHYBO2_JcK1CJv5VxUyb2-v_OZV7pGC4BoediKBvOjopLL-BRLPN)


<br>
<br>

```
Procedure
---------
    1. Install the ng2-file-upload javascript library
       unix> cd ~/intellijProjects/angularApp1/frontend
       unix> npm install ng2-file-upload 

       After this command, your frontend/package.json should have this entry (or something like it)
	        "ng2-file-upload": "1.4.0",


    2. Add the FileUploadModule to the app.module.ts imports
        a. Edit frontend/src/app.module.ts

        b. Add FileUploadModule to the imports section
               imports: [
                         ...
                         FileUploadModule,
                         ...
               ] 

        c. Add the import statement to the top
               import {FileUploadModule} from "ng2-file-upload"; 


    3. Add a new report upload page
        a. Create the page component
           unix> cd ~/intellijProjects/angularApp1/frontend
           unix> ng generate component reports/uploadReport


        b. Add 'page/uploadReport' to the routes
            i. Edit frontend/src/app.module.ts

            ii. Add this to the list of routes
                 { path: 'page/uploadReport', component: UploadReportComponent }, 


            When finished, the appRoutes object should look something like this:
            
            const appRoutes: Routes = [
              { path: 'page/addReport',	component: AddReportComponent },
              { path: 'page/viewReports',  component: ViewReportsComponent },
              { path: 'page/uploadReport', component: UploadReportComponent },
              { path: 'page/chart1',   	component: Chart1Component },
              { path: 'page/chart2',   	component: Chart2Component },
              { path: '',              	component: WelcomeComponent},
              { path: '**',            	component: NotFoundComponent}
            ];

                
        c. Add the "Upload Report" route to the navigation bar
            i. Edit navbar.component.html

            ii. Add this block after the Audit History button:
                
                  <!-- Upload Report -->
                  <mat-list-item class="navItem" [routerLink]="'page/uploadReport'"
                                        routerLinkActive="active">
                    <a title="Upload Report">Upload Report</a>
                    <div fxFlex fxLayoutAlign="end end" >
                      <a [routerLink]="'page/uploadReport'" target="_blank">
                     <i class="fas fa-external-link-alt navItemIcon" 
                                title="Open 'Upload Report' a new window"></i>
                      </a>
                    </div>
                  </mat-list-item>
                

    4. Verify that the "Upload Report" page shows up
        a. Start the debugger -- "Full WebApp"
        b. Make sure you see an Upload Report option


    5. Configure the FileUploader object in upload-report.component.ts
        a. Edit upload-report-component.ts

        b. Replace its contents with this:
            
            import { Component, OnInit } from '@angular/core';
            import {FileUploader, ParsedResponseHeaders} from "ng2-file-upload";
            import {environment} from "../../../environments/environment";
            import {MessageService} from "../../services/message.service";
            
            
            const backendUploadUrl = environment.baseUrl + '/api/reports/upload';
            
            @Component({
              selector: 'app-upload-report',
              templateUrl: './upload-report.component.html',
              styleUrls: ['./upload-report.component.css']
            })
            export class UploadReportComponent implements OnInit {
            
              // Make sure the itemAlias matches the
              //     @RequestParam(value = "file" in the REST endpoint on backend
              //
              public uploader: FileUploader = new FileUploader(  {
                                                url: backendUploadUrl,
                                         queueLimit: 1,
                                          itemAlias: 'file'
                                              });
            
              constructor(private messageService: MessageService) { }
            
              ngOnInit(): void {
                 this.uploader.onAfterAddingFile = (file) => {
                     // This call is need to make the upload work with spring security
                     file.withCredentials = false;
                 };
            
                 this.uploader.onCompleteItem = (item, response, status, headers) =>
            this.onCompleteItem(item, response, status, headers);
              }
            
            
              onCompleteItem(item: any, response: any, status: number, headers: ParsedResponseHeaders): any {
                  // Send a message to the user letting him know if it worked
                  let message = " status=" + status + "   response=" + response;
                  this.messageService.showSuccessMessage(message);
              }
            
            }


    6. Edit the upload-report.component.html
        a. Edit upload-report.component.html

        b. Replace its contents with this: 
            
            <mat-card>
              <mat-card-title>Upload Report</mat-card-title>
            
              <mat-card-content>
                
                <input type="file" name="file" ng2FileSelect [uploader]="uploader" />
            
                <button type="button" class="btn btn-success btn-s"
                     (click)="uploader.uploadAll()"
                     [disabled]="!uploader.getNotUploadedItems().length" >
                  Upload a file
                </button>
            
              </mat-card-content>
            </mat-card>



    7. Activate the debugger using "Full WebApp"
        a. Click on the Upload Report option
```
![](https://lh3.googleusercontent.com/PVICpadIFtRi-Qe1s6j_SqOBp4SxrJsaeb0sqIXTaF4vQQsv2wdtgTL9yLSeI0fApqbTHwicPFiU0sjV1chgMHYBO2_JcK1CJv5VxUyb2-v_OZV7pGC4BoediKBvOjopLL-BRLPN)
```


        b. Press "Choose File" and browse to a file on your computer

        c. Press "Upload a file"
           -- You should hit your breakpoint
           -- Press F9 to continue

        d. You should see the popup on the bottom saying the upload was successful




```
