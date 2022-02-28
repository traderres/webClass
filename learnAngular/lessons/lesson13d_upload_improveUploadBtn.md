Lesson 13d:  Upload Report / Improve Look of Upload Button
----------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1_UHTIxdx2TghugsXy6ASEVWJDg8xEVr50kiRNwzcnxk/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson13d/better-upload-button
<br>
<br>
<br>

<h3> Problem Set </h3>

Problem:  The upload buttons looks ugly<br>
Solution:  Let's replace the stock file upload with something better

<br>
<br>
After this Lesson, the Upload Button will look like this (on page load)<br>

![](https://lh6.googleusercontent.com/bhiNSlnIKVGpHZVnEREekFA2xo-Ii5eTDuw1orWEqruhS1g0XiNfQLKV6RhGmBuOSC3UUJTGcOQBVDes73c0w5LfepATXa3RErDstGixrUxvdn0w0N88J4d4nuFCBLK3wCk8zWT3)


<br>
<br>
After this lesson, the page will look like this (after selecting a file to upload)<br>

![](https://lh4.googleusercontent.com/yYkYs5NBwp4o3Y8rRvRfEri1hFMjYsOH7UA11SoIFHonNmndD46MoOGGGWUvCCEL4E77hkjz8zTYEua4E9g7U2pEIFxHhOgLOiYJALvvzIk369TCGfH-AxcESZE0tWWRa7iw4GoH)

Notice that we displayed the user's uploaded filename (but we have not uploaded it yet)
- We give the user the option to Reset it or Upload the File.

<br>
<br>

```
Procedure
---------
    1. Add some additional information to the upload-report.component.ts
        a. Edit upload-report.component.ts

        b. Add these 2 instance variables:
              public  selectedFileToUpload:  FileItem | null = null;
              private lastFileItemAddedToQueue: FileItem;


        c. Make sure the uploader object has a queueLimit of 2:
              public uploader: FileUploader = new FileUploader({url: backendUploadUrl,
                                                                        queueLimit: 2,  
                                                                        itemAlias: 'file'});


        d. Add this method:  clearAll()

              public clearAll(): void {
                this.uploader.clearQueue();
                this.selectedFileToUpload = null;
              }
            


        e. Add this method:  onAfterAddingFile()
            
              /*
               * When using the FileUploader, there is an order of operations
               *  1) User selects file
               *  2) The FileUploader adds it to the queue
               *  3) onAfterAddingFile() is called
               *  4) onFileSelected() is called
               */
              private onAfterAddingFile(aFileItem: FileItem) {
                // This line is required to make upload work with spring security
                aFileItem.withCredentials = false;
            
                // Get a reference to the last FileItem object added to the queue
                // NOTE:  This reference is used in onFileSelected()
                this.lastFileItemAddedToQueue = aFileItem;
              }



        f. Add this method:  onFileSelected()
            
              public onFileSelected(aFiles: File[]) {
                if (aFiles.length == 0) {
                    // The user cancelled selecting a file -- so stop here
                    return;
                }
            
                if (this.selectedFileToUpload != null) {
                    // Remove the old file from the queue
                    this.uploader.removeFromQueue(this.selectedFileToUpload)
                }
            
                this.selectedFileToUpload = this.lastFileItemAddedToQueue;
              }
            



        g. Adjust the ngOnInit() so the onAfterAddingFile event calls our own method:
            
              public ngOnInit(): void {
                // Do other stuff in this method
            
                this.uploader.onAfterAddingFile = (item: FileItem) => this.onAfterAddingFile(item);
            
              }


        h. Remove this block of code from the ngOnInit()   (because this is now done in our own method)
            
             this.uploader.onAfterAddingFile = (file) => {
                  file.withCredentials = false;
                };



    2. Update the HTML to show the new upload-file button
        a. Edit upload-report.component.html

        b. Remove this code:
                <input type="file" name="file" ng2FileSelect [uploader]="uploader" />

        c. Remove this code:
                <button type="button" class="btn btn-success btn-s"
                            (click)="uploader.uploadAll()"
                            [disabled]="!uploader.getNotUploadedItems().length" >
                    Upload a file
                </button>



        d. Insert this code:
                
                <div style="text-align: center; display: block; margin-top: 10px">
                
                    <!-- Upload Button -->
                    <label for="file-upload" class="custom-file-upload">
                            <i class="fas fa-cloud-upload-alt"></i>&nbsp;&nbsp;Select File to Upload
                    </label>
                    <input id="file-upload" type="file" name="file" ng2FileSelect
                            [uploader]="uploader"
                                    (onFileSelected)="this.onFileSelected($event)" />
                
                    <!-- Show information about selected file -->
                    <div *ngIf="this.selectedFileToUpload != null"  style="margin-top: 10px;">
                            Ready to upload <b>{{this.selectedFileToUpload.file.name}}</b>
                    </div>
                
                    <!-- Page Buttons -->
                    <div style="display: block; margin-top: 25px">
                
                            <!-- Clear Button -->
                            <button type="button" mat-raised-button 
                            [disabled]="this.uploader.queue.length == 0" (click)="this.clearAll()">
                                    Reset
                            </button>
                
                            <!-- Begin Upload Button -->
                            <button type="button" mat-raised-button style="margin-left: 15px" color="primary"
                            [disabled]="this.uploader.queue.length == 0"
                             (click)="this.uploader.uploadAll()">
                                    Upload File
                            </button>
                    </div>
                
                </div>


    3. Update the CSS so that the new upload-file button is pretty
        a. Edit upload-report.component.css

        b. Add these CSS classes
                
                input[type="file"] {
                  /* Hide the ugly "Choose File" upload label */
                  display: none;
                }
                
                .custom-file-upload {
                  border: 1px solid #2579af;
                  border-radius: 6px;
                  display: inline-block;
                  padding: 7px 15px 7px 15px;
                  cursor: pointer;
                }
                
                .custom-file-upload:hover {
                  border: 1px solid #1CB6E0;
                  border-radius: 6px;
                  display: inline-block;
                  padding: 7px 15px 7px 15px;
                  cursor: pointer;
                  color: white;
                  background: #2579af;
                  white-space: nowrap;
                }
                


    4. Try it out
        a. Startup the Full WebApp Debugger
        b. Go to the http://localhost:8080/app1
        c. Click on "Upload Reports"
           -- Place the mouse over the "Select File to Upload"



When finished, upload-report.component.html looks like this:
------------------------------------------------------------
<mat-card>
  <mat-card-title>Upload Report</mat-card-title>

  <mat-card-content>
	<br/>
	<div style="text-align: center; display: block; margin-top: 10px">

  	<!-- Upload Button -->
  	<label for="file-upload" class="custom-file-upload">
    	<i class="fas fa-cloud-upload-alt"></i>&nbsp;&nbsp;Select File to Upload
  	</label>
  	<input id="file-upload" type="file" name="file" ng2FileSelect
         	[uploader]="uploader"
         	(onFileSelected)="this.onFileSelected($event)" />

  	<!-- Show information about selected file -->
  	<div *ngIf="this.selectedFileToUpload != null"  style="margin-top: 10px;">
    	Ready to upload <b>{{this.selectedFileToUpload.file.name}}</b>
  	</div>

  	<!-- Page Buttons -->
  	<div style="display: block; margin-top: 25px">

     	<!-- Clear Button -->
     	<button type="button" mat-raised-button [disabled]="this.uploader.queue.length == 0" (click)="this.clearAll()">
        	Reset
     	</button>

      	<!-- Begin Upload Button -->
      	<button type="button" mat-raised-button style="margin-left: 15px" color="primary" [disabled]="this.uploader.queue.length == 0" (click)="this.uploader.uploadAll()">
        	Upload File
      	</button>
   	</div>

	</div>


	<!-- Progress Bar -->
	<mat-progress-bar *ngIf="uploader.progress > 0" style="margin-top: 15px" [value]="uploader.progress"></mat-progress-bar>

  </mat-card-content>
</mat-card>



When finished, upload-report.component.ts looks like this:
----------------------------------------------------------
import { Component, OnInit } from '@angular/core';
import {FileItem, FileUploader} from "ng2-file-upload";
import {environment} from "../../../environments/environment";
import {MessageService} from "../../services/message.service";


const backendUploadUrl =  environment.baseUrl + '/api/reports/upload';

@Component({
  selector: 'app-upload-report',
  templateUrl: './upload-report.component.html',
  styleUrls: ['./upload-report.component.css']
})
export class UploadReportComponent implements OnInit {

  public  selectedFileToUpload:  FileItem | null = null;
  private lastFileItemAddedToQueue: FileItem;

  // Make sure the itemAlias matches the @RequestParam(value = "file" in the REST endpoint
  // Set the queueLimit to be 1 to allow single file uploads only
  public uploader: FileUploader = new FileUploader({url: backendUploadUrl,
                                                        	queueLimit: 2,   // NOTE:  The real queue size limit is 1, but I need it to be 2 to allow user to change it
                                                        	itemAlias: 'file'});

  constructor(private messageService: MessageService) { }

  ngOnInit(): void {
	this.uploader.onAfterAddingFile = (file) => {
  	file.withCredentials = false;
	};

	this.uploader.onCompleteItem = (item: any, response: any, status: any, headers: any ) => {
  	console.log('File uploaded:  item=', item, '  status=', status, '  response=', response, '  headers=', headers);

  	// Send a message to the user letting him know if it worked
  	let message = " status=" + status + "   response=" + response;
  	this.messageService.showSuccessMessage(message);
	};

	this.uploader.onProgressItem = (progress: any) => {
  	console.log('progress=', progress['progress']);
	};

	this.uploader.onAfterAddingFile = (item: FileItem) => this.onAfterAddingFile(item);
  }

  /*
   * When using the FileUploader, there is an order of operations
   *  1) User selects file
   *  2) The FileUploader adds it to the queue
   *  3) onAfterAddingFile() is called
   *  4) onFileSelected() is called
   */
  private onAfterAddingFile(aFileItem: FileItem) {
	// This line is required to make upload work with spring security
	aFileItem.withCredentials = false;

	// Get a reference to the last FileItem object added to the queue
	// NOTE:  This reference is used in onFileSelected()
	this.lastFileItemAddedToQueue = aFileItem;
  }

  public onFileSelected(aFiles: File[]) {
	if (aFiles.length == 0) {
  	// The user cancelled selecting a file -- so stop here
  	return;
	}

	if (this.selectedFileToUpload != null) {
  	// Remove the old file from the queue
  	this.uploader.removeFromQueue(this.selectedFileToUpload)
	}

	this.selectedFileToUpload = this.lastFileItemAddedToQueue;
  }


  public clearAll(): void {
	this.uploader.clearQueue();
	this.selectedFileToUpload = null;
  }
}



When finished, upload-report.component.css looks like this:
-----------------------------------------------------------
input[type="file"] {
  /* Hide the ugly "Choose File" upload label */
  display: none;
}

.custom-file-upload {
  border: 1px solid #2579af;
  border-radius: 6px;
  display: inline-block;
  padding: 7px 15px 7px 15px;
  cursor: pointer;
}

.custom-file-upload:hover {
  border: 1px solid #1CB6E0;
  border-radius: 6px;
  display: inline-block;
  padding: 7px 15px 7px 15px;
  cursor: pointer;
  color: white;
  background: #2579af;
  white-space: nowrap;
}





```
