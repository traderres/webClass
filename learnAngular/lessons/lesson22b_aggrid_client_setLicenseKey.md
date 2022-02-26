Lesson 22b:  Ag Grid / Client Side / Set License Key
----------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1OIUgUxKLXJrCj_SErV4BoXgAD_JT5IUkdfuvW1Ysxh4/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson22b/grid/install-license
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem:  I got a license key from ag-grid.  How do I install it?<br>
Solution:  Use the ag-grid's LicenseManager.setLicenseKey() method<br>



<br>
<br>

```
Assumptions
-----------
    • You have a trial or full-fledged license key
      NOTE:  If you need a trial license, send an email to info@ag-grid.com requesting a trial license
      They will will respond within a business day and send you a trial license that's good for 2 months
        


Procedure
---------
    1. Change the ag-grid version to be 25.1.0 in your package.json  
       Or use 25.3.0 if using the real license key

        NOTE:  The trial license in this document only works for ag-grid version 25.1.0
        NOTE:  If you got a NEW LICENSE from ag-grid.com, then you must use the current version of ag-grid

        a. Stop your Debugger

        b. Edit package.json

            i. Change the ag-grid-angular, ag-grid-community, and ag-grid-enterprise to be 25.1.0

        c. Delete the node_modules directory

        d. Right-click on package.json -> Run NPM install



    2. Turn on ag-grid debug mode
        a. Edit report-grid-view.component.ts

        b. Add this public variable:
 
              public gridOptions: GridOptions = {
                debug: true
              };



        c. Edit report-grid-view.component.html

        d. Change the <ag-grid-angular> so that gridOptions is set   (changes in bold)

        	<!-- AG-Grid -->
        	<ag-grid-angular
          		style="width: 100%; height: 100%"
          		class="ag-theme-alpine"
          		[rowData]="this.rowData"
         	 	[defaultColDef]="this.defaultColDefs"
          		[columnDefs]="this.columnDefs"
          		[gridOptions]="this.gridOptions">
        	</ag-grid-angular>


    3. Configure the LicenseManager in the Report Grid View page
        a. Edit report-grid-view.component.ts

        b. Add this import:
        	import "ag-grid-enterprise";                    	// Give us access to the License Manager

        c. In the constructor, set the license key

            // Set the license key for ag-grid-enterprise
            LicenseManager.setLicenseKey('For_Trialing_ag-Grid_Only-Not_For_Real_Development_Or_Production_Projects-Valid_Until-18_March_2021_[v2]_MTYxNjAyNTYwMDAwMA==948d8f51e73a17b9d78e03e12b9bf934');

            
            The real license key is:
            
            'CompanyName=RBR Technologies,LicensedGroup=RBRDev01,LicenseType=MultipleApplications,LicensedConcurrentDeveloperCount=1,LicensedProductionInstancesCount=0,AssetReference=AG-017601,ExpiryDate=28_July_2022_[v2]_MTY1ODk2MjgwMDAwMA==5bf889a6d35999955c2ab2fab4ec4cb3'
            

  



    4. Verify the license is valid
        a. Activate your debugger on "Full WebApp"
        b. Press F12 in your browser (to view the browser console)
        c. Go to the Report Grid View page
        d. Look at the console
            
            If the ag-grid-enterprise license is INVALID then the console will show this:
                 
            *****************************************************************************************
            *************************** ag-Grid Enterprise License        ***************************
            ***************************     Invalid License               ***************************
            * Your license for ag-Grid Enterprise is not valid - please contact info@ag-grid.com to obtain a valid license. *
            *****************************************************************************************
            *****************************************************************************************
            

            
            If the ag-grid enterprise license is VALID, then the console will show this:
            
            AG Grid.Context: >> ag-Application Context ready - component is alive
            ag-grid-community.cjs.js:32757 AG Grid.GridCore: ready
            ag-grid-community.cjs.js:32757 AG Grid.ColumnFactory: Number of levels for grouped columns is 0
            ag-grid-community.cjs.js:32757 AG Grid.SelectionController: reset
            ag-grid-community.cjs.js:32757 AG Grid.AG Grid: initialised successfully, enterprise = true
            


    5. Move the license key to the frontend/src/environments/environment.prod.ts and environment.ts

        a. environment.prod.ts

        b. Add the license key to the environment map
              	agGridLicenseKey: 'my license key'
   	    
            
           When done, the file should look something like this:
               
                 export const environment = {
                   production: true,
                   baseUrl: '.',
                   agGridLicenseKey: 'my-license-key'
                 };
        
        
        
         c. Edit environment.ts
        
         d. Add the license key to the environment map.
                agGridLicenseKey: 'my license key'
   	    
            When done, the file should look something like this:
       
                export const environment = {
                   production: false,
                   baseUrl: 'http://localhost:8080/app1',
                   agGridLicenseKey: 'my-license-key'
                 };
   		

        e. Edit report-grid-view.component.ts


        f. Change the constructor so that it calls LicenseManager.setLicenseKey()
 
               constructor() {
                 // Set the license key for ag-grid-enterprise
                 LicenseManager.setLicenseKey(environment.agGridLicenseKey);
               }


    6. Verify the license (set in environment.ts) is valid
        a. Activate your debugger on "Full WebApp"
        b. Press F12 in your browser (to view the browser console)
        c. Go to the Report Grid View page
        d. Look at the console

            If the ag-grid-enterprise license is INVALID then the console will show this:
                 
            *****************************************************************************************
            *************************** ag-Grid Enterprise License        ***************************
            ***************************     Invalid License               ***************************
            * Your license for ag-Grid Enterprise is not valid - please contact info@ag-grid.com to obtain a valid license. *
            *****************************************************************************************
            *****************************************************************************************
            

            
            If the ag-grid enterprise license is VALID, then the console will show this:
            
            AG Grid.Context: >> ag-Application Context ready - component is alive
            ag-grid-community.cjs.js:32757 AG Grid.GridCore: ready
            ag-grid-community.cjs.js:32757 AG Grid.ColumnFactory: Number of levels for grouped columns is 0
            ag-grid-community.cjs.js:32757 AG Grid.SelectionController: reset
            ag-grid-community.cjs.js:32757 AG Grid.AG Grid: initialised successfully, enterprise = true
            


    7. Problem:  If we have 3 grid pages, then we need to call LicenseManager.setLicenseKey() in 3 places
       (As we do not know which grid page the user will hit first).
       Solution:  Set the license key in the main.ts    (so it is setup before any page is hit)

        a. Remove these lines from report-grid-view.component.ts

             // Set the license key for ag-grid-enterprise
             LicenseManager.setLicenseKey(environment.agGridLicenseKey);

        b. Set the license key in the frontend/src/main.ts
            i. Edit main.ts

            ii. Add these lines to the top of the main.ts 
                 import "ag-grid-enterprise";              	// Give us access to the License Manager
                 import {LicenseManager} from "ag-grid-enterprise";    

            iii. Add these 2 lines after the if statement
                 // Set the license key for ag-grid-enterprise
                 LicenseManager.setLicenseKey(environment.agGridLicenseKey);
	
        

        When finished, the main.ts should look like this:
        
        import { enableProdMode } from '@angular/core';
        import { platformBrowserDynamic } from '@angular/platform-browser-dynamic';
        import { AppModule } from './app/app.module';
        import { environment } from './environments/environment';
        
        import "ag-grid-enterprise";              	// Give us access to the License Manager
        import {LicenseManager} from "ag-grid-enterprise";
        
        if (environment.production) {
          enableProdMode();
        }
        
        // Set the license key for ag-grid-enterprise
        LicenseManager.setLicenseKey(environment.agGridLicenseKey);
        
        platformBrowserDynamic().bootstrapModule(AppModule)
          .catch(err => console.error(err));
        


    8. Verify the license (set in main.ts) is valid
        a. Activate your debugger on "Full WebApp"
        b. Press F12 in your browser (to view the browser console)
        c. Go to the Report Grid View page
        d. Look at the console

            If the ag-grid-enterprise license is INVALID then the console will show this:
                 
            *****************************************************************************************
            *************************** ag-Grid Enterprise License        ***************************
            ***************************     Invalid License               ***************************
            * Your license for ag-Grid Enterprise is not valid - please contact info@ag-grid.com to obtain a valid license. *
            *****************************************************************************************
            *****************************************************************************************
            
                        
            
            If the ag-grid enterprise license is VALID, then the console will show this:
            
            AG Grid.Context: >> ag-Application Context ready - component is alive
            ag-grid-community.cjs.js:32757 AG Grid.GridCore: ready
            ag-grid-community.cjs.js:32757 AG Grid.ColumnFactory: Number of levels for grouped columns is 0
            ag-grid-community.cjs.js:32757 AG Grid.SelectionController: reset
            ag-grid-community.cjs.js:32757 AG Grid.AG Grid: initialised successfully, enterprise = true
            

```
