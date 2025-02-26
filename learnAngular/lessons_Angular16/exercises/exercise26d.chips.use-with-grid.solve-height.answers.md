```
Problem:  When I select lots of chips, I have 2 scrollbars  (Answers)
---------------------------------------------------------------------

     +-------------------------------------------------------------------+
     | Select Contract Reviewers                                    Help |
     +-------------------------------------------------------------------+        
     |   <chip>  <chip>  <chip>  <chip>  <chip>  <chip>  <chip>  <chip>  |    Height is 32px
     +-------------------------------------------------------------------+
     | Grid is here                                                      |
     |                                                                   |
     |                                                                   |   Height is set with a calculation
     |                                                                   |   -- and looks good because we assume chips uses height of 32px
     |                                                                   |
     |                                                                   |
     +-------------------------------------------------------------------+




     +-------------------------------------------------------------------+
     | Select Contract Reviewers                                    Help |
     +-------------------------------------------------------------------+        
     |   <chip>  <chip>  <chip>  <chip>  <chip>  <chip>  <chip>  <chip>  |  Height is 64px
     |   <chip>  <chip>                                                  |  
     +-------------------------------------------------------------------+
     | Grid is here                                                      |
     |                                                                   |
     |                                                                   |  Height is set with a calculation
     |                                                                   |  -- and looks bad because we assume chips uses height of 32px
     |                                                                   |  -- but actual height of chips div is 64px
     |                                                                   |
     +-------------------------------------------------------------------+





 Solution using CSS
 ------------------

   Put a wrapper div around chips and grid and set the height

     +-------------------------------------------------------------------+        
     |   <chip>  <chip>  <chip>  <chip>  <chip>  <chip>  <chip>  <chip>  |  Initial height is 32px / but may grow to 64px or more!!
     |   <chip>  <chip>                                                  |  
     +-------------------------------------------------------------------+
     | Grid is here                                                      |
     |                                                                   |
     |                                                                   |  Height uses the *REMAINING HEIGHT* of the flex-col
     |                                                                   |  
     |                                                                   |  
     |                                                                   |
     +-------------------------------------------------------------------+







 Implementation Outline
 ----------------------

    <div class="p-2.5">

            <!--   P A G E         T I T L E -->
            <div>

            </div>


            <div class="overflow-y-auto" style="height: calc(100vh - 150px)">
                <div class="flex flex-col h-full">

                    <!--   D I S P L A Y     C H I P S   -->
                    <div class="min-h-[32px]">
                        Chips has an initial height of 32px
                    </div>

                    <!--   D I S P L A Y     G R I D   -->
                    <div class="flex flex-grow h-full mt-5">
                        Grid uses *REMAINING HEIGHT* / which is dynamic
                    </div>
                
                </div>
            </div>
    </div>



      Better Page Outline
     -------------------
     <div class="p-2.5 flex flex-col h-full">


            <!--   P A G E         T I T L E -->
            <div>

            </div>


            <!--   D I S P L A Y     C H I P S   -->
            <div class="min-h-[32px]">
                Chips has an initial height of 32px
            </div>


            <!--   D I S P L A Y     G R I D   -->
            <div class="flex flex-grow h-full mt-5">
                Grid uses *REMAINING HEIGHT* / which is dynamic
            </div>
        
     </div>






 Completed HTML
 --------------
 <div class="m-2.5">
 
   <div class="grid grid-cols-2">
     <div>
       <span class="text-xl">Select Contract Reviewers</span>
 
       <span *ngIf="this.addReviewerInProgress">
         <!-- We're waiting for the Add-Reviewer REST call to finish -->
         <i class="fa fa-spin fa-spinner text-[18px] ml-2.5"></i>
       </span>
 
     </div>
 
     <div class="flex place-content-end">
       Help
     </div>
   </div>
 
   <div class="mt-2.5">
     <!-- P A G E    C O N T E N T S -->
 
     <div class="overflow-y-auto" style="height: calc(100vh - 150px)">
       <div class="flex flex-col h-full">
 
         <!--  D I S P L A Y       C H I P S   -->
         <div class="ml-[25px]">
           <div class="flex flex-row flex-wrap gap-5">
 
             <ng-container *ngIf="this.selectedReviewers.length == 0">
               <!-- No Reviewers are Selected -->
               <span class="text-xl">No Reviewers are Selected</span>
             </ng-container>
 
             <ng-container *ngIf="this.selectedReviewers.length > 0">
               <!-- One or more Reviewers are Selected -->
               <mat-chip-row  *ngFor="let reviewer of this.selectedReviewers; let index=index"
                              (removed)="this.removeReviewer(index)">
 
                 <div>
                   <!-- The chip text -->
                   {{ reviewer.full_name }}
 
 
                   <ng-container *ngIf="! reviewer.remove_in_progress">
                     <!-- Chip is not being removed.  So, show the "Remove" button -->
 
                     <!-- Add a button to remove this chip -->
                     <button matChipRemove [attr.aria-label]="'Remove ' + reviewer.full_name">
                       <i class="fa-solid fa-circle-xmark text-black"></i>
                     </button>
                   </ng-container>
 
                   <ng-container *ngIf="reviewer.remove_in_progress">
                     <!-- Chip is being removed.  So, show the spinner -->
                     <i class="fa fa-spin fa-spinner text-[18px] ml-2.5"></i>
                   </ng-container>
 
                 </div>
               </mat-chip-row>
             </ng-container>
           </div>
         </div>
 
 
         <!--   D I S P L A Y     G R I D   -->
         <div class="flex flex-grow h-full mt-2.5">
           <ag-grid-angular
             class="ag-theme-balham w-full h-full"
             [gridOptions]="this.gridOptions"
             [columnDefs]="this.columnDefs"
             [defaultColDef]="this.defaultColumnDef"
             (gridReady)="this.onGridReady($event)"
           ></ag-grid-angular>
 
         </div>
 
       </div>
     </div>
 
   </div>
 
 
 
 
 </div>

```