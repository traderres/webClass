Lesson 15a:  Kitchen Drawer / Add a New Font
--------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1Yi-KXLDbiRNwoh3UcN3ubf8ma4J5xufJ62XvX82mzQI/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson15a/add-new-font
<br>
<br>
<br>

<h3> Problem Set </h3>

Problem: My boss wants a prettier font for the &lt;pre>..&lt;/pre> tag than the default courrier font.<br>
Solution: Import a different mono font from google and use it in your proje<br>




<br>
<br>
<h3>Approach</h3>

1. Download a better looking proportional (or mono) font

   1. Go to Google's web fonts page:  
         <https://google-webfonts-helper.herokuapp.com/fonts>
   2. Select the jetbrains mono font
   3. Download the CSS
   4. Download the zip file
   5. Unzip the font.zip in the frontend/src/assets/fonts  

1. Use the font in your styles.css

<br>
<br>

```

Procedure
---------
Procedure
    1. Download a better looking proportional (or mono) font
        a. Go to Google's web fonts helper page:
           https://google-webfonts-helper.herokuapp.com/fonts

        b. In the search box (in the upper left corner), type-in mono and select "JetBrains Mono"
```
![](https://lh5.googleusercontent.com/6A4ojhmFGupF7FbKZAZt1yCo9NbI_PMk4YyInRAv5pWq-SEavIEqTmwGLqq38o9xbVipjSkoN5nEqQWHhm7pZt1V8DSJVsFM2_rZV86vqBiB5JF5PnxPjVTVrmdLfIXMw4VVpA31)
```

        c. Scroll down and press the "jetbrains-mono-v6-latin.zip" 
           -- Download the file to your Downloads/

        d. Create this directory:  ~/intellijProjects/angularApp1/src/assets/fonts
 
        e. Unzip the file to this directory:   ~/intellijProjects/angularApp1/src/assets/fonts    
           unix> cd ~/intellijProjects/angularApp1/frontend/src/assets/fonts/
           unix> mv ~/Downloads/jetbrains-mono-v6-latin.zip  .     # move the file to the fonts directory
           unix> unzip jetbrains-mono-v6-latin.zip
           unix> rm jetbrains-mono-v6-latin.zip

        f. Check off regular, 300, 500, and 700

        g. Scroll down to the "Customize folder prefix" and enter this:   ./assets/fonts/

           THIS IS IMPORTANT!!!  YOU MUST HAVE THE CORRECT PREFIX DIRECTORY

        h. Single-click in the CSS (so it's highlighted) and Right-click-Copy

        i. Append the CSS to your frontend/src/styles.css


    3. Verify that the web app still runs
       NOTE:  If the styles.css has invalid urls, then it will not compile
        a. Activate the Debugger Full WebApp
        b. Make sure the web app still runs
        c. Stop the debugger


    4. Use the "JetBrains Mono" font for your <pre> tag
        a. Edit add-report2.component.html

        b. Make sure you have a <pre>...</pre> tag at the bottom of the html.
           If you do not, then add this:
                
                <pre>
                myForm.valid={{this.myForm.valid}}
                  myForm.controls.report_name.errors={{this.myForm.controls?.report_name?.errors | json}}
                  myForm.controls.priority.errors={{this.myForm.controls?.priority?.errors | json}}
                  myForm.controls.source.errors={{this.myForm.controls?.source?.errors | json}}
                  myForm.controls.authors.errors={{this.myForm.controls?.authors?.errors | json}}
                </pre>

        c. Edit frontend/src/styles.css

        d. Add CSS class to the end:

            pre {
              font-family: 'JetBrains Mono';
              font-size: 1em;
              font-weight: 500;
            }


    5. Verify that the "JetBrains Mono" font shows::
        a. Activate the Debugger Full WebApp
        b. Go to "Add Report 2"
           -- Look at the text on the bottom

        c. Change the pre CSS class (in your styles.css) 
           -- Change the font-weight to 700
        d. Go to "Add Report 2"
           -- Look at the text on the bottom 


```
