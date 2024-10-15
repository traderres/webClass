<style>
        .container-lg {
          max-width: inherit !important;
        }
</style>

```
Exercise 1ba / Make the Tabs Pretty (Answers)
---------------------------------------------
Problem:  The standard mat-tab looks pretty boring
Solution: Use CSS to make it look better


Exercise
--------
 1. Setup the Page
    a. Generate the component:                Call it PrettyTabsPage
    b. Add the route to constants.ts:         the route will be this:   page/pretty-tabs
    c. Register the route
    d. Add the route to the database table:  ui_controls        (if using real security)
    e. Add a link to the navbar (using that route)
    f. Use the debugger to verify that the navbar link works



 2. Setup this page layout w/4 tabs

     Showing the "Enrichment" tab
     +--------------------------------------------------------------------------+
     | Pretty Tabs Page                                                    Help |
     +--------------------------------------------------------------------------+
     |                                                                          |
     | Enrichment Tab  | Original submission Tab | Documents Tab  | History Tab |
     | -------------------------------------------------------------------------+
     | Enrichment                                                               |
     |   This is the Enrichment Tab                                             |
     |                                                                          |
     +--------------------------------------------------------------------------+



     Showing the "Original Submission" tab
     +--------------------------------------------------------------------------+
     | Pretty Tabs Page                                                    Help |
     +--------------------------------------------------------------------------+
     |                                                                          |
     | Enrichment Tab  | Original submission Tab | Documents Tab  | History Tab |
     | -------------------------------------------------------------------------+
     | Original Submission                                                      |
     |   This is the Original Submission Tab                                    |
     |                                                                          |
     +--------------------------------------------------------------------------+



     Showing the "Documents" tab
     +--------------------------------------------------------------------------+
     | Pretty Tabs Page                                                    Help |
     +--------------------------------------------------------------------------+
     |                                                                          |
     | Enrichment Tab  | Original submission Tab | Documents Tab  | History Tab |
     | -------------------------------------------------------------------------+
     | Documents                                                                |
     |   This is the Documents Tab                                              |
     |                                                                          |
     +--------------------------------------------------------------------------+


     Showing the "History" tab
     +--------------------------------------------------------------------------+
     | Pretty Tabs Page                                                    Help |
     +--------------------------------------------------------------------------+
     |                                                                          |
     | Enrichment Tab  | Original submission Tab | Documents Tab  | History Tab |
     | -------------------------------------------------------------------------+
     | History                                                                  |
     |   This is the History Tab                                                |
     |                                                                          |
     +--------------------------------------------------------------------------+


 3. Make sure that each tab uses the *REMAINING VISIBLE HEIGHT* of the web browser

	SCSS looks like this
	--------------------
	:host ::ng-deep .mat-mdc-tab-header {
      // Indent the Tab Headers
      margin-left: 10px;
    }


	HTML looks like this
	--------------------
		<div class="m-2.5">
		  <div class="grid grid-cols-2">
			<div>
			  <span class="text-xl">Pretty Tabs Page</span>
			</div>

			<div class="flex place-content-end">
			  Help
			</div>
		  </div>


		  <div class="mt-2.5">

			<mat-tab-group class="mt-2.5">

			  <!-- E N R I C H M E N T       T A B -->
			  <mat-tab label="Enrichment">
				<div class="mx-2.5 mb-1 p-2.5 mat-elevation-z6 overflow-y-auto" style="height: calc(100vh - 195px)">
				  <div class="flex flex-col">
					<div>
					  <span class="text-xl">Enrichment</span>
					</div>
					<div class="mt-2.5">
					  This is the Enrichment Tab
					</div>
				  </div>
				</div>


			  </mat-tab>

			  <!-- O R I G I N A L        S U B M I S S I O N       T A B -->
			  <mat-tab label="Original Submission">
				<div class="mx-2.5 mb-1 p-2.5 mat-elevation-z6 overflow-y-auto" style="height: calc(100vh - 195px)">
				  <div class="flex flex-col">
					<div>
					  <span class="text-xl">Original Submission</span>
					</div>
					<div class="mt-2.5">
					  This is the Original Submission Tab
					</div>
				  </div>
				</div>
			  </mat-tab>

			  <!-- D O C U M E N T S     T A B -->
			  <mat-tab label="Documents">
				<div class="mx-2.5 mb-1 p-2.5 mat-elevation-z6 overflow-y-auto" style="height: calc(100vh - 195px)">
				  <div class="flex flex-col">
					<div>
					  <span class="text-xl">Documents</span>
					</div>
					<div class="mt-2.5">
					  This is the Documents Tab
					</div>
				</div>
			  </div>
			  </mat-tab>


			  <!-- H I S T O R Y     T A B -->
			  <mat-tab label="History">
				<div class="mx-2.5 mb-1 p-2.5 mat-elevation-z6 overflow-y-auto" style="height: calc(100vh - 195px)">
				  <div class="flex flex-col">
					<div>
					  <span class="text-xl">History</span>
					</div>
					<div class="mt-2.5">
					  This is the History Tab
					</div>
				  </div>
				</div>
			  </mat-tab>

			</mat-tab-group>

		  </div>
		</div>

```
![](../images/exercise12b_image1.png)
```




