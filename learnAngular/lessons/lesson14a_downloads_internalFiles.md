Lesson 14a:  Downloads / Download File Inside Web App
-----------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/16giausywh2qa55yQk7ZEBNI1TZbFfRfJGheLizPpNQQ/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson14a/download/internal-file
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem:  I have a help.pdf file that I want users to download<br>
Solution:  Add the help.pdf file to your frontend/src/app/asset<br>

<br>
<br>
Lesson:  Users can download files directly from your frontend/src/assets/


<br>
<br>
<br>

```
Procedure
---------
    1. Create a word document and export it to PDF


    2. Copy the help.pdf to your angularApp1/frontend/src/assets directory


    3. Add a Navigation Icon that will open the help.pdf file
        a. Edit navbar.component.ts

        b. Add a public method called downloadHelpFile()
            
              public downloadHelpFile(): void {
                // Open the help.pdf in another tab
                window.open('./assets/help.pdf', "_blank");
              }



        c. Edit navbar.component.html

        d. Add a navigator option that has a click handler
            
            <!-- Help -->
            <mat-list-item class="navItem" (click)="this.downloadHelpFile()">
                    <a title="Show Help File">Help</a>
                    <div fxFlex fxLayoutAlign="end end">
                    <a (click)="this.downloadHelpFile()" target="_blank">
                        <i class="fas fa-external-link-alt navItemIcon" title="Show Help File in new window"></i>
                    </a>
                    </div>
            </mat-list-item>


    4. Try it out
        a. Activate the Debugger - Full WebApp
        b. Click on the "Help" icon
           -- Verify that you see the help.pdf

```
