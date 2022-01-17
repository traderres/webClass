Lesson 15b:  Kitchen Drawer / Add an Image
------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1Zxu1eXi58Ty5Od0GD0BhIyUT4XSKHFGO2DunnRhihc4/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson15b/add-image
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem: I want to add a logo image file to the webapp (that I can show in the header)<br>
Solution: Add the image to the frontend/src/assets and reference it with a regular img tag.<br>

<br>
<br>

![](https://lh4.googleusercontent.com/0lEFsaz-4qvgZ1hpy7oAzbLzWYrvu0qkpMNatLAByNHevsbMIGi_KqW9-UcuyQqiCFLbyU9bDVmJdh51nkCM7jl-baq79wra8JP4-45eSa4TcGUnFGe0j_Hzz7Xvx782CdiwEK85)

NOTE:  The "A" logo in the upper left corner is an image file<br>

<br>
<br>
<h3>Approach</h3>

1. Create an "images" directory under frontend/src/assets
1. Add an image to it
1. Reference the image using the &lt;img src="./assets/images/logo.png"> tag

<br>
<br>

```
Procedure
---------
Procedure
    1. Create this directory:  angularApp1/frontend/src/assets/images

    2. Download the logo from my github site:
       https://github.com/traderres/webClass/blob/master/learnAngular/lessons/logo.png

    3. Save the file to the new images directory
       Now, you have this file:
            frontend/src/assets/images/logo.png

    4. Edit header.component.html

       Change the left side of the header by 
           (a) removing the search glass, and
           (b) adding the logo


       When finished, the left-side looks like this:
        
            <!-- Left Side of the Header -->
            <div fxFlex fxLayoutAlign="left center" fxLayout="row" fxLayoutGap="10px">
        
                <!-- App Logo -->
                <img class="appLogo clickable" [routerLink]="'/'" 
                    src="./assets/images/logo.png" height="47px"
                     alt="Application Logo" title="Application Logo">
        
                <!-- App Navbar -->
                <a  class="button" (click)="toggleAppNavbar()">
                        <i class="fa fa-bars"></i>
                </a>
            </div>


    5. Verify the logo is visible in the header
        a. Activate the debugger Full WebApp
        b. Look at the main header:
           -- You should see the A logo in the upper left corner

```
