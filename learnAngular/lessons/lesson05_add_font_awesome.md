Lesson X: Add Report Page
-------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1knmHYiJz3tDn0u1twBdtLHyWPS_r-25x-GPQU9117Nc/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson5/add-font-awesome
<br>
<br>




```
Agenda
    • What is Font Awesome
    • How to install Font Awesome to the Angular front-end
    • How to add icons to Angular pages/components


What is Font Awesome
    • It's the biggest icon library
    • It's the arguably the most popular way to add font icons to a web app
    • The Font Awesome icons are created using scalable vectors, so they work well on any screen size
    • No JavaScript required.  It's all CSS.
    • Icons are created using <i>...</i> tag
    • Icon behavior is modified with CSS class



How to Install Font Awesome
    1. Use the Node Package Manager (NPM) to install the latest version of font awesome
unix> cd ~/intellijProjects/angularApp1/frontend
unix> npm install @fortawesome/fontawesome-free

    2. Verify that NPM added font awesome to the package.json
        a. Edit frontend/package.json
        b. Make sure you see this entry in the "dependencies" section:  [version may vary]
	"@fortawesome/fontawesome-free": "5.15.1",


    3. Change the frontend/angular.json "styles" section to include the font-awesome css file
        a. Edit frontend/angular.json
        b. Add the font-awesome all.css to the "styles" section
            [add the code in bold only]
            
              "architect": {
                    "build": {
            
                    …
            
                        "styles": [
                         "./node_modules/@angular/material/prebuilt-themes/deeppurple-amber.css",
                         "./node_modules/@fortawesome/fontawesome-free/css/all.css",
                         "src/styles.css"
                        ],


    4. Add icons to the "Reset" and  "Save" buttons on the "Add-Reports" page
        a. Edit add-report.component.html


        b. Update the "Reset" button by adding the "backspace" icon to it
            [add the code in bold]
            
            Change this:
                   <button type="button" (click)="reset()" style="margin-top: 20px"                mat-raised-button>Reset</button>
            
            To this:
                <button type="button" (click)="reset()" style="margin-top: 20px"
                           mat-raised-button>
                         <i class="fa fa-backspace"></i>
                         Reset
                    </button>



        c. Update the "Save" button to have a "plus sign" icon inside of it:
            Change this:
                    <button type="button" (click)="save()" mat-raised-button color="primary">Save</button>
            
            To this:
                   <button type="button" (click)="save()" mat-raised-button color="primary">
                        <i class="fa fa-plus"></i>
                            Save
                   </button>




    5. Activate the debugger
        a. Pull Run -> Debug 'Full WebApp'
        b. Verify that you see the "Add a Report" page
        c. Verify that you see the pretty icons in the buttons






General Rules for Adding Font Awesome Icons
If you want a larger icon, add these classe
	<i class="fa fa-check fa-2x"></i>     This icon is 2x larger than the regular icon
	<i class="fa fa-check fa-3x"></i>     This icon is 3x larger than the regular icon
	<i class="fa fa-check fa-5x"></i>     This icon is 5x larger than the regular icon

If you want an icon to spin, add the fa-spin class
	<i class="fa fa-spinner fa-spin"></i>       	Add the fa-spinner icon and make it spin
 	<i class="fa fa-plus fa-spin"></i>            	Add the plus sign icon and make it spin



Exercise 1:  Add a spinner icon to the page




Exercise 2:  How would you increase the font size to something between fa-1x and fa-2x?

   <i class="fa fa-check" style="font-size: 20px"></i>
 


```
