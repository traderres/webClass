```
How to run Webpack Analyzer on Angular 16 Web App
-------------------------------------------------
It will show you a graphical representation of your modules

```
![](./images/webpack.before.png)
```

Procedure
---------
 1. Add the webpack-bundle-analyzer as a development dependency
    terminal> cd frontend
    terminal> npm install --save-dev webpack-bundle-analyzer


 2. Add a build-stats and "analyze-stats" to the package.json
    a. Edit the frontend/package.json

    b. Add these entries
       ASSUMPTION:  We have a "production" configuration defined in the angular.json

        "build-stats": "ng build --configuration=production --stats-json",
        "analyze-stats": "webpack-bundle-analyzer dist/static/stats.json",


 3. Generate the stats file
    terminal> npm run build-stats       # Run this command from the directory that has your package.json


 4. Analyze the bundle
    terminal> npm run analyze-stats     # Run this command from the directory that has your package.json

    -- You will see a web page appear with the analysis


 5. On the left side of the page
    Click the Left Arrow
    Check "Show content of concatenated modules (inaccurate)
    
```
