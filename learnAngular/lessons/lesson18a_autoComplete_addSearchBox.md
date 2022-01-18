Lesson 18a:  Auto-Complete / Add Search Box to Front-End
--------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1kC4eHORGoRm4iMWO9UnCJJfI-SaJe40cxSrM88oUMec/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson18a/autocomplete/front-end
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem:  I want a search box in the header to auto-complete on report names (so the user can get to the details page without going to a search results page)<br>
Solution:  Use an Auto-Complete

<br>
<br>
<br>

![](https://lh4.googleusercontent.com/XU2llWuSiFcmQLPnZQ7yB4vSV4V_814JZ3E55tEQ0XBRq6rjB1OIQBjwgMuBImW1eDliYwTB4nKwvTHS7-7X5Mc9BhXFIftlUQsJadEfssCrVowRrjAQ1F_LzOnSfDxaCh3y9fCn)


<br>
<br>
<h3>Design Decision</h3>

1. Build the auto-complete into the header  
     
   \*OR\*  

1. Create a separate component and add it to the header

  
<br>
<br>
 
<h3>Approach</h3> 

1. Add the MatAutocompleteModule module to app.module.ts  

1. Create a new component called "SearchBox"  

1. Add the app-search-box to the header  

1. Add to the search-box HTML

   1. Add the text search-box
   1. Add a search icon (that looks pretty)
   1. Format the search box and icon so they look pretty (with CSS and a wrapper div)  

1. Add this DTO: AutoCompleteMatchDTO class (holds information about each match  

1. Add this service: ElasticSearchService

   1. Inject the httpClient
   1. Add a public method: runSearch() that returns an observable to an array of AutoCompleteMatchDTO  
      NOTE : This returns hard-coded data (for now)  

1. Add logic to the header.component.ts

   1. Initialize the reactive form with the one text box  
   1. Add a private method getMatchingNames() that returns an Observable&lt;AutoCompleteMatchDTO\[]>  
   1. Add a public method called "goToDetailsPage() that takes a reportId  
      NOTE: It clears the textbox, then navigates to the new page  
   1. Change ngOnInit() subscribe to the textbox valueChanges (to listen for changes)  
      -- which will call  

1. Add the &lt;mat-autocomplete> to the header.component.html


<br>
<br>

```

Procedure
---------
    1. Verify that MatAutocompleteModule is in your app.module.ts
        a. Edit app.module.ts

        b. Add MatAutocompleteModule to your imports section
           HINT:  It's easy to tell if your imports lists is already sorted


    2. Create a SearchBoxComponent (in the search/ directory)


    3. Add the SearchBoxComponent to your header
        a. Edit header.component.html

        b. Add the component so it appears to the right of the app-navbar toggle button
           (in the left side of the header)


    4. Verify that the search box appears in the header
        a. Activate the Debugger on "Full WebApp"
        b. Examine the header
```
![](https://lh4.googleusercontent.com/A8NslO4CKCJyplOue6z9Vw-WkaPrNrnTdeY6Gy2CRCbpKPLKNzs7A02Pzsvlko7AFjbK4G5CJNri8ClxYmQhvKx1_XIy_5YWunoKYg1xrZkuBJHmEWNGkV03D9e2yPo3W62RGV_i)
```
Search Box V1:  You should see "search-box works!" on the left side of the header





    5. Add to the search-box HTML
        a. Edit search-box.component.html

        b. Add the text search-box 

            <!-- Search Box -->
            <input matInput type="text" id="searchBox" placeholder="Enter Criteria..." 
                aria-label="search box" />

        c. Add the Search icon

            <!-- Search Icon -->
            <span class="searchBoxIcon">
              <i class="fa fa-search"></i>
            </span>

        d. Let's see how it looks:
```
![](https://lh4.googleusercontent.com/-xjBsxAhtEVnJL2YBQN1uQ8-QMDRifyz23Uruc2PSaudrieYNTfPOdP1O5WFftdEJ6CFvh9-JGgPFqiYUFpYxsU__su9qx6FkhJq5mPswQ4_qJi0jIJrGvS_f1s05mRcJ4A6b54p)
```
Search Box v2  (looks butt ugly, but at least there is a search box and search icon)





    6. Add a wrapper div to smooth out the corners (around the textbox and icon) 
        a. Edit search-box.component.html

        b. Add a wrapper div with 

                <div class="searchBoxWrapper fa-border">
                
                  <!-- Search Box -->
                  <input matInput type="text" id="searchBox" placeholder="Enter Criteria..." aria-label="search box" />
                
                  <!-- Search Icon -->
                  <span class="searchBoxIcon">
                    <i class="fa fa-search"></i>
                  </span>
                
                </div>

        c. Edit search-box.component.css

        d. Add the searchBoxWrapper CSS class  (to smooth out the edges and combine the 2 elements)
                
                .searchBoxWrapper {
                  background-color: #f7f7f7;
                  border-radius: 4px;
                  border: 0;
                
                  /* Center the search box and the icon */
                  display: flex;
                  flex-direction: row;
                  align-items: center;
                
                  margin-left: 10px;
                }

        e. Take a look
```
![](https://lh3.googleusercontent.com/OWAq8Czb8qabbuDWVwmrKA6SLC_4YSXPyzTysNKlP0ub74d_-IvaHfveyky7_qOxhDwBqxCAT_rjp4a5znhu9nRVZR0HJkLNHhOMzp6-DdmHe1pOkxBK5-Vwlq5pigt6sFHrZBbr)
```
Search Box V3:  We use the wrapper to combine the text-box and icon into one continuous box.
                Also, the wrapper will center the search box and the icon





    7. Make the search box and search icon look more polished
        a. Edit search-box.component.css

        b. Add these 2 CSS items

            #searchBox {
              width: 145px; 	/* Set the width of the search box */
              padding: 6px 0 6px 10px;
              background-color: #f7f7f7;   /* light white color */
              border: 0;
              color: #111;			/* Text color is almost black */
            
              /* Remove the outline that appears when clicking in textbox */
              outline: none;
            }
            
            .searchBoxIcon {
              color: black;
              padding: 6px 1px 6px 1px;
              cursor: pointer;
              border: 0;
              background-color: transparent;
            }

        c. Take a look:
```
![](https://lh6.googleusercontent.com/bhZh6uaFaZXBEC1IljdbprQWQQbkloHUH6-AQ10xO8yaZYj02Y7vdAt_MJpMshVT-jks33_AWcLhm7wNOlROH173jOAc8wAldfvkNHFP6-aQo_aqUHWYYwhTWysMDUfLdbtqIliV)
```
Search Box V4:  We add 6px of top/bottom padding around the box and icon 










    8. Add a front-end model:  AutoCompleteMatchDTO
        a. Add the DTO class to the front-end

        b. Add these 2 public properties:
                id   (it's a numeric value)
               name  (it's a string)


    9. Add a front-end service:  ElasticSearch   (so the generated service name is ElasticSearchService)
        a. Create the ElasticSearchService


        b. Add a public method:  runSearch() that returns an observable to an array of AutoCompleteMatchDTO
           NOTE : This returns hard-coded data (for now)
                
                public runSearch(aRawQuery: string, aTotalReturnsToReturn: number): 		
                                        Observable<AutoCompleteMatchDTO[]> {
                    if (aRawQuery == '') {
                    // The search box is empty so return an empty list (and do not run a search)
                    return of( [] );
                    }
                    
                    else if (aRawQuery.startsWith('a')) {
                
                    // Return hard-coded observable with 3 strings that start with A
                    return of([
                        {
                        id: 1,
                        name: "Amazon"
                        },
                        {
                        id: 2,
                        name: "Apple",
                        },
                        {
                        id: 3,
                        name: "American Airlines"
                        }]);
                    }
                
                    else if (aRawQuery.startsWith('b')) {
                
                    // Return hard-coded observable with 3 strings that start with B
                    return of([
                        {
                        id: 10,
                        name: "Best Buy"
                        },
                        {
                        id: 11,
                        name: "Boeing",
                        },
                        {
                        id: 12,
                        name: "Bed, Bath, and Beyond"
                        }]);
                    }
                    
                    else {
                    // No matches were found, so return an observable with an empty array
                    return of( [] );
                    }
                
                  }  // end of runSearch()



    10. Link the search box to a searchTextBox variable in the component
        a. Edit search-box.component.ts

        b. Link the search-box component with the text box
           NOTE:  There's only one textbox so we do not need to make an entire reactive form:

           Add this public variable:
                   public searchTextBox: FormControl = new FormControl();


        c. Edit search-box.component.html

        d. Change the search box so it has  [formControl]"this.searchTextBox:

              <!-- Search Box -->
              <input [formControl]="this.searchTextBox" matInput type="text" id="searchBox"
                        placeholder="Enter Criteria..." aria-label="search box" />


    11. Adjust the search-box component class to (a) listen for changes and run searches
        a. Edit search-box.component.ts


        b. Inject the ElasticSearchService


        c. Add this public variable:
                public searchMatchesToShowObs: Observable<AutoCompleteMatchDTO[]>;


        d. Add this block of code to ngOnInit() so it will listen for changes on the search-box

                // Listen for changes on the search text box
                this.searchMatchesToShowObs = this.searchTextBox.valueChanges
                .pipe(
                    startWith(''),
                    debounceTime(250),              		// Wait 250 msecs to give the user some time to type
                    switchMap((aRawQuery: string) => {   // Use switchMap for its cancelling effect:  On each observable, the previous observable is cancelled
                        // The user has typed-in something
            
                        // Return an observable to the search (but only return up to 5 results)
                        // NOTE:  The <mat-options> tag has an async pipe that will invoke this REST call
                        return this.elasticSearchService.runSearch(aRawQuery, 5);
                    })
                );



    12. Add the popup auto-complete to search box html
        a. Edit search-box.component.html

        b. Add the auto-complete tag after the "Search Icon"  (but within the searchBoxWrapper div)
            
              <!-- Show Popup autocomplete entries for matching search results -->
              <mat-autocomplete #autocomplete1="matAutocomplete"  >
                <mat-option *ngFor="let match of this.searchMatchesToShowObs | async"
                                                    [value]="match">
                    {{match.name}}
                </mat-option>
              </mat-autocomplete>




        c. Adjust the search-box text control so it has this in it:
            [matAutocomplete]="autocomplete1"


            When finished, the search-box text control looks like this:
            
              <!-- Search Box -->
              <input [formControl]="this.searchTextBox"   [matAutocomplete]="autocomplete1"
                    matInput type="text" id="searchBox" placeholder="Enter Criteria..." 
                aria-label="search box" />
            




    13. Verify it works
        a. Activate the Debugger on "Full WebApp"
        b. Type-in letter A in the search box
```
![](https://lh5.googleusercontent.com/ocAeVZKWN_Ppq5tlrVz7-hG-8mMKG7QugNpf6Nmhpr1Y52x0gER_zbCR92CdREYCjpRiCP9u8Pn1SLKCTxPXcrKr-w9jjK0GICdk3BLHm88-zXLOM9dhUs-WMVd4fGK4cAiRJDUF)
```
NOTE:  The user typed-in A and the matching entries appeared beneath the search text box








    14. Problem:  The "American Airlines" matching entry got abbreviated.  How can I increase the size of the auto-complete entries so they are always 300 pixels wide?

        There are 2 solutions:

		
        a. Edit search-box.component.css

        b. Add this CSS:

                ::ng-deep .cdk-overlay-pane {
                  /* Change the width of the auto-popup to be 300px */
                  min-width:300px;
                }
                
                Weakness of this approach:  This changes *ALL* auto-completes to have a width of 300px
                


       **OR**



        c. Edit search-box.component.html

        d. Change the <mat-autocomplete.... so it has panelWidth="300px">
            
              <!-- Show Popup autocomplete entries for matching search results -->
              <mat-autocomplete #autocomplete1="matAutocomplete" panelWidth="300px" >
                <mat-option *ngFor="let match of this.searchMatchesToShowObs | async" [value]="match">
                {{match.name}}
                </mat-option>
              </mat-autocomplete>





    15. Verify that the auto-complete matches are always 300px wide
        a. Activate the Debugger on "Full WebApp"
        b. Enter "a" in the search box
```
![](https://lh4.googleusercontent.com/Sl0kokv7WkCAv7F2RG_oQtgAlfJE0ouAMFAQK4UPB-eTt7MQefcR67yhH93WbxpCZnoDRzDO_7ACrVJTFVuK4Mz7lw4Ii2j8meKfBAa1UEaAlmmqRuYyhTEB3e1ZiQv_wGYRlE5w)
```
NOTE:  "American Airlines" fits because the auto-complete is 300px wide.  Now, it's too wide.







    16. Problem:   The matching entries have lots of extra space (because I hard-coded it to 300px)
        Solution:  Set the panel width to "auto"
        
        There are 2 solutions:
        
                a. Edit search-box.component.css
        
                b. Add this CSS:
        
                    ::ng-deep .cdk-overlay-pane {
                      /* Change the width of the auto-popup fit the widest entry */
                      width: auto !important;
                    }
                    
                   Weakness of this approach:  This changes *ALL* auto-completes to have a width of auto-size

                
                **OR**
                
                c. Edit search-box.component.ts
        
                d. Change the <mat-autocomplete.... so it has panelWidth="auto">
       
                  <!-- Show Popup autocomplete entries for matching search results -->
                  <mat-autocomplete #autocomplete1="matAutocomplete" panelWidth="auto" >
                    <mat-option *ngFor="let match of this.searchMatchesToShowObs | async" [value]="match">
                    {{match.name}}
                    </mat-option>
                  </mat-autocomplete>


    17. Verify that the auto-complete matches fit:
        a. Activate the Debugger on "Full WebApp"
        b. Enter "a" in the search box
```
![](https://lh3.googleusercontent.com/H_rVaeXS_996CizXhBfNESZbGxPOk9tgsiNq4X0NhyBHuEb_PHwlr8kPMKtGpY5lJJV077cRrhZDA0JXnApmRGPDICh1tNzzT-y6Pns1bLCoPlHNh4IfIGyqDCgMJMLh4ZbvkLwi)
```
Now, "American Airlines" fits -- the auto-complete expands as needed





        c. Enter "b" in the search box
```
![](https://lh4.googleusercontent.com/XU2llWuSiFcmQLPnZQ7yB4vSV4V_814JZ3E55tEQ0XBRq6rjB1OIQBjwgMuBImW1eDliYwTB4nKwvTHS7-7X5Mc9BhXFIftlUQsJadEfssCrVowRrjAQ1F_LzOnSfDxaCh3y9fCn)
```
Now, "Bed, Bath, and Beyond" fits -- it expands as needed.
	


```
