Lesson 6f:  Add Navigation Bar 2 / Gradients
--------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/12WAHBTuZCf7PTrKU-TUyfHw0cjyVVKkXkPCgTDpmaPk/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson6f/add-gradient-to-header
<br>
<br>
<br>

<h3> Problem Set </h3>

Problem:  I'm not a graphics artist but I want the nav bars to look professional<br>
Solution:  Use gradients
<br>
<br>
In this screenshot, we have replaced the dark header with a light-dark-light gradient:
![](https://lh6.googleusercontent.com/l7zzm5fH1FtSK4U8yKAgUbHRD8M9C12l6HTIMvSP7nqf3oll2Er5lFdtlVgvlfyYTeYcEpXQqOIt51DZlsPtv5lNf7lSEplr7XG7As9h5btXSfJAiRi-XvYGZCgJk0qdNqN7dRqM)

```
This header has 2 gradients inside of it:
    • Left side of the header is a gradient from #364150 to #111111
    • Right side of the header is a gradient from #111111 to #364150

Because  the left side navbar has the background of #364150, the header blends in with the left navbar.
(which looks cool!)



Approach
--------
    • You need 2 colors to create a gradient  (starting- and ending-color)
        -- You will probably be provided a logo that has some colors
        -- You can grab some colors from the logo

        You can use free software to get the RGB color of any point of an image
        ◦ Use GIMP (linux) to get the color of any pixel of an image
            https://github.com/traderres/webClass/blob/master/learnGIMP/howToGetColorsCoordinatesFromImage.txt

        ◦ Use Paint.net (windows) to get the color of any pixel of an image
            https://github.com/traderres/webClass/blob/master/learnPaintNet/howToGetColorsCoordinatesFromImage.txt



    • Once you have the 2 colors, experiment with some gradients
        Color 1 --> Color 2
        Color 2 --> Color 1
        Color1 --> Color 2 --> Color 1
        Color2 --> Color1 --> Color 2          (Gradient has 3 colors but we reuse the colors)
        



Procedure
---------
    1. Get 2 color points
        a. Get the background color of the header

        b. Go to header.component.css, you should see this:
            
            .header {
              background: #111;
              color: white;
              height: 100%;
              padding-left: 5px;
              padding-right: 16px;
            }

        c. Go to navbar.component.css, you should see this:
            
             .navbar {
              background: #364150;
              color: white;
              height: 100%;
              overflow: hidden;
            }

    2. Generate some gradients using this url:
        https://colorzilla.com/gradient-editor
        
        So, your web app is already using 2 color points:  #111111 and #364150
        
        /* Permalink - use to edit and share this gradient: https://colorzilla.com/gradient-editor/#111111+0,364150+100 */
        background: #111111; /* Old browsers */
        background: -moz-linear-gradient(left,  #111111 0%, #364150 100%); /* FF3.6-15 */
        background: -webkit-linear-gradient(left,  #111111 0%,#364150 100%); /* Chrome10-25,Safari5.1-6 */
        background: linear-gradient(to right,  #111111 0%,#364150 100%); /* W3C, IE10+, FF16+, Chrome26+, Opera12+, Safari7+ */
        filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#111111', endColorstr='#364150',GradientType=1 ); /* IE6-9 */



    3. Setup the header as a gradient from #111111 to #364150  (left to right)
        a. Edit header.component.css

        b. Adjust the header class
            
            Change this:
            
                .header {
                background: #111;
                color: white;
                height: 100%;
                padding-left: 16px;
                padding-right: 16px;
                }
            
            To this:
            
                .header {
                color: white;
                height: 100%;
                padding-left: 16px;
                padding-right: 16px;
            
                /* Permalink - use to edit and share this gradient:
                https://colorzilla.com/gradient-editor/#111111+0,364150+100 */
                background: #111111; /* Old browsers */
                background: -moz-linear-gradient(left,  #111111 0%, #364150 100%); /* FF3.6-15 */
                background: -webkit-linear-gradient(left,  #111111 0%,#364150 100%); /* Chrome10-25,Safari5.1-6 */
                background: linear-gradient(to right,  #111111 0%,#364150 100%); /* W3C, IE10+, FF16+, Chrome26+, Opera12+, Safari7+ */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#111111', endColorstr='#364150',GradientType=1 ); /* IE6-9 */
                }



    4. Try it out
        a. Activate the debugger -> Full WebApp
        b. Look at the header:  There is a gradient
```
![](https://lh5.googleusercontent.com/cEujnsAojkHhB1wQOsCSOkiU7rqo-NkDiJfKEHf54Mvbx8ZaPnvmz9xi3AQljOKnPNTG3OF0zgByTBEDFMNl44EFHM096ag_FutljBlUxdVTEM_eskH1NiLbEcLTA9VIk_pbZ13M)
```



    5. Setup the header as a gradient from #364150 to #111111    (reverse direction)
        a. Edit header.component.css

        b. Replace the header class with this:
            .header {
                color: white;
                height: 100%;
                padding-left: 16px;
                padding-right: 16px;
            
                /* Permalink - use to edit and share this gradient:
                https://colorzilla.com/gradient-editor/#364150+0,111111+100 */
                background: #364150; /* Old browsers */
                background: -moz-linear-gradient(left,  #364150 0%, #111111 100%); /* FF3.6-15 */
                background: -webkit-linear-gradient(left,  #364150 0%,#111111 100%); /* Chrome10-25,Safari5.1-6 */
                background: linear-gradient(to right,  #364150 0%,#111111 100%); /* W3C, IE10+, FF16+, Chrome26+, Opera12+, Safari7+ */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#364150', endColorstr='#111111',GradientType=1 ); /* IE6-9 */
            }

        c. Examine the results
```
![](https://lh3.googleusercontent.com/6HYu5tW9zGr4XzgcUuuRLxal_qmP7TmEYNr0q0f8WT9lx95dguTiNvbDtHC5hCV9w7c2OpMqCVMlLZdm7NWIMp5kk6VgG9R_fi53S-bK6EJIuHY1uCvfnaQPNqI2YD8Hx_xh39NS)
```
NOTE:  The left-side gradient blends in with the left-side nav bar (but header buttons look bad) 
        



        d. Change the header buttons by removing the background and changing the border
            In header.component.css change the 
            
            Set the a.button so it has this  (changes in bold)
            
            a.button {
              background-color: inherit;
              border: 1px solid #919191;
              border-radius: 4px;
              font-size: 14px;
              line-height: 20px;
              color: #f7f7f7;
              padding: 7px 14px 7px 14px;
              height: 20px;
              cursor: pointer;
              -webkit-transition: 200ms all linear;
              -moz-transition: 200ms all linear;
              -o-transition: 200ms all linear;
              transition: 200ms all linear;
              background-image: none;
            }


        e. When finished, header.component.css looks like this:
            
            .header {
              color: white;
              height: 100%;
              padding-left: 16px;
              padding-right: 16px;
            
              /* Permalink - use to edit and share this gradient:  https://colorzilla.com/gradient-editor/#364150+0,111111+100 */
              background: #364150; /* Old browsers */
              background: -moz-linear-gradient(left,  #364150 0%, #111111 100%); /* FF3.6-15 */
              background: -webkit-linear-gradient(left,  #364150 0%,#111111 100%); /*
            Chrome10-25,Safari5.1-6 */
              background: linear-gradient(to right,  #364150 0%,#111111 100%); /* W3C, IE10+, FF16+, Chrome26+, Opera12+, Safari7+ */
              filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#364150', endColorstr='#111111',GradientType=1 ); /* IE6-9 */
            
            }
            
            .app1Logo {
              color: #fff;
              padding: 3px 0 5px 5px;
              font-size: 1.7em;
              margin: 0;
              font-family: "Verdana", san-serif;
              text-decoration: none;
            
              /* Outline of zero gets rid of the annoying box around the link */
              outline: 0;
            }
            
            a.button {
              background-color: inherit;
              border: 1px solid #919191;
              border-radius: 4px;
              font-size: 14px;
              line-height: 20px;
              color: #f7f7f7;
              padding: 7px 14px 7px 14px;
              height: 20px;
              cursor: pointer;
              -webkit-transition: 200ms all linear;
              -moz-transition: 200ms all linear;
              -o-transition: 200ms all linear;
              transition: 200ms all linear;
              background-image: none;
            }
            
            a.button:hover {
              background-color: black;
              color: white;
              border-color: #f9f9f9;
            }
            


        f. Examine the results:
```
![](https://lh4.googleusercontent.com/sv1kY16Qi1H7EAwjtayV_EMsgfTB-zj3mW5fq9NKuzl-RuKoFARzJ3O9e_jnEpn3wNOKOGPwSbNE8jKXJ2yqHKLEmnVw4YSk5G1GEqnL3xQ-AN-8KRIfVtaHU430ZPRo8n2xT7bn)
```
NOTE:  Now, the header buttons look better -- They also blend in
-- This looks more professional




    6. Make a left-right-left gradient
        +--------------------------------------------------------------+
        |  Lighter Color     |     Darker Color    |   Lighter Color   |
        |  #364150           |     #111111         |   #364150         |
        +--------------------------------------------------------------+
 

        a. Go to https://www.colorzilla.com/gradient-editor/
            i.   Double-click on the left color-stop and set the color to #364150
            ii.  Double-click on the right color-stop and set the color to #364150
            iii. Click at the 50% and add a new color-stop and set it to #111111
            iv.  Set the orientation to horizontal
                
                You should get this:
                
                /* Permalink - use to edit and share this gradient:
                https://colorzilla.com/gradient-editor/#364150+0,111111+50,364150+100 */
                background: #364150; /* Old browsers */
                background: -moz-linear-gradient(left,  #364150 0%, #111111 50%, #364150 100%); /* FF3.6-15 */
                background: -webkit-linear-gradient(left,  #364150 0%,#111111 50%,#364150 100%); /* Chrome10-25,Safari5.1-6 */
                background: linear-gradient(to right,  #364150 0%,#111111 50%,#364150 100%); /* W3C, IE10+, FF16+, Chrome26+, Opera12+, Safari7+ */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#364150', endColorstr='#364150',GradientType=1 ); /* IE6-9 */

        b. Add this to the header.component.css
                
                Change the header class to this:
                
                .header {
                  color: white;
                  height: 100%;
                  padding-left: 16px;
                  padding-right: 16px;
                
                  /* Permalink - use to edit and share this gradient:
                  https://colorzilla.com/gradient-editor/#364150+0,111111+50,364150+100 */
                  background: #364150; /* Old browsers */
                  background: -moz-linear-gradient(left,  #364150 0%, #111111 50%, #364150 100%); /* FF3.6-15 */
                  background: -webkit-linear-gradient(left,  #364150 0%,#111111 50%,#364150 100%); /* Chrome10-25,Safari5.1-6 */
                  background: linear-gradient(to right,  #364150 0%,#111111 50%,#364150 100%); /* W3C, IE10+, FF16+, Chrome26+, Opera12+, Safari7+ */
                  filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#364150', endColorstr='#364150',GradientType=1 ); /* IE6-9 */
                }


        c. Examine the Results	
```
![](https://lh3.googleusercontent.com/ythhtsNzzLdfOqs1Nv-7y1NEt1chv-EnMR2mA2no0xv9Opo3RFqJMniHa3xcpDqkJwpPfYlLe4sFcmo3Azx4jYGccnwHuVNDmGke6-pAV-C1aVQVVuSOtrabGyCHT1oxVYXKLemj)
```
Now, the navbar has a light-dark-light gradient





Exercise 1:  Make a 2-color gradient going dark to light
--------------------------------------------------------
Use these 2 colors to make a gradient:
	Light Blue:  #2579af
	Dark Blue:  #19134b

So, the gradient looks like this:
        +-------------------------------------------------------------+
        |  Dark Blue                                      Light Blue  |
        |  #19134b                                        #2579af     |
        +-------------------------------------------------------------+
 

    1. Use the CSS Gradient Generator to make the gradient CSS class:
        https://www.colorzilla.com/gradient-editor/

    2. Insert the CSS class in the header.component.css .header class

    3. Try it out

    4. Replace the left-side navbar so it has the same dar kblue
        a. Edit navbar.component.css

        b. Change the .navbar class from this:
            
            .navbar {
              background: #364150;
              color: white;
              height: 100%;
              overflow: hidden;
            }
            
            To this:
            
            .navbar {
              background: #19134b;
              color: white;
              height: 100%;
              overflow: hidden;
            }






Exercise 2:  Make a 2-color gradient going light to dark
--------------------------------------------------------
So, the gradient looks like this:

        +-------------------------------------------------------------+
        |  Light Blue                                      Dark Blue  |
        |  #2579af                                        #19134b     |
        +-------------------------------------------------------------+
 





Exercise 3:  Make a left-right-left gradient with the 2 colors
--------------------------------------------------------------

        +--------------------------------------------------------------+
        |  Dark Blue         |     Light Blue      |   Dark Blue       |
        |  #2579af           |     #19134b         |   #2579af         |
        |  0 - 20%           |     20% - 80%       |   80% - 100%      |
        +--------------------------------------------------------------+
 



``` 


