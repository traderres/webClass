```
Exercise 26ai / Chips / User Chips with a Text Box  (Answers)
-------------------------------------------------------------
Problem:  I want a user to enter multiple discrete things in a text box
          I want the user to know that each selected item is removable
          

```
![](../images/exercise26a_image1.png)

![](../images/exercise26a_image2.png)
```


Part 1 / Setup the Page
-----------------------
 1. Create the Page
    a. Generate the component                 ChipsWithTextboxPage
    b. Add the route to constants.ts:         the route will be this:   page/chips-with-textbox
    c. Register the route
    d. Add the route to the database table:  ui_controls        (if using real security)
    e. Add a link to the navbar (using that route)
    f. Use the debugger to verify that the navbar link works



 2. Setup the layout
    NOTE:  Do *NOT* add form controls yet

    +----------------------------------------------------------------------+
    | Add Country                                                     Help |
    +----------------------------------------------------------------------+ 
    | <Three Character Country Code Text Box>                              |  textbox has width of 200px
    |                                                                      |
    | <Country Name Text Box>                                              |  textbox has width of 400px
    |                                                                      |
    | <Aliases Text Box>                                                   |  textbox has width of 75% of page width
    | Hint:  Press 'Enter' to add an alias                                 |
    |                                                                      |
    | <Checkbox> Is it a country of special concern?                       |
    |                                                                      |
    |                        <Reset Btn>  <Submit Btn>                     |
    +----------------------------------------------------------------------+
    NOTE:  All fields are required field
        

        At this point, the HTML looks like this:
        ---------------------------------------
        <div class="m-2.5">
          <div class="grid grid-cols-2">
            <div><span class="text-xl">Add Country Page</span></div>
        
            <div class="flex place-content-end">Help</div>
          </div>
        
          <div class="overflow-y-auto mt-2.5" style="height: calc(100vh - 150px)">
        
            <div class="flex flex-col gap-y-2.5">
 
              <div>
                Three Character Country Code Text Box
              </div>
                     
              <div>
                Country Name Text Box
              </div>
 
              <div>
                Aliases Text Box
              </div>
                           
              <div>
                Checkbox> Is it COSC?
              </div>
              

        
              <!-- Button Row -->
              <div class="flex place-content-center gap-x-5">
                <div>Reset Btn</div>
                <div>Submit Btn</div>
              </div>
            </div>
        
          </div>
        </div>


 3. Add real HTML form fields w/
 
 
 
 4. Put the modern "2020 style" labels above the HTML form fields


    At this point, the HTML lools like this:
    ----------------------------------------
    <div class="m-2.5">
      <div class="grid grid-cols-2">
        <div><span class="text-xl">Add Country Page</span></div>
    
        <div class="flex place-content-end">
          <!-- Help Button -->
          <button mat-raised-button type="button" title="Help" aria-label="Help">Help</button>
        </div>
      </div>
    
      <div class="overflow-y-auto mt-2.5" style="height: calc(100vh - 150px)">
    
        <div class="flex flex-col gap-y-2.5">
      
          <div>
            <!-- Three Character Country Code Text Box -->
            <span class="app-form-label">Three Character Country Code</span>
            <mat-form-field class="max-reduced-density [w-200px]">
              <input type="text" matInput title="Three Character Country Code"/>
            </mat-form-field>
          </div>
            
          <div>
            <!-- Country Name Text Box-->
            <span class="app-form-label">Enter Country Name</span>
            <mat-form-field class="max-reduced-density w-[400px]">
              <input type="text" matInput title="Enter Country Name"/>
            </mat-form-field>
          </div>

    
          <div>
            <!-- A L I A S E S      T E X T     B O X    -->
            <span class="app-form-label">Enter Aliases</span>
            <mat-form-field class="max-reduced-density w-3/4">
              <input type="text" matInput title="Enter Aliases"/>
            </mat-form-field>
          </div>
    
          <div>
            <!-- Is it a COSC? -->
            <span class="app-form-label">Is it Country of Special Concern?</span>
            <mat-checkbox>Is it COSC?</mat-checkbox>
          </div>
    
          <!-- Button Row -->
          <div class="flex place-content-center gap-x-5">
            <div>
                <!-- Reset Button -->
                <button type="button" mat-raised-button title="Reset" aria-label="Reset">Reset</button>
            </div>
            <div>
                <!-- Submit Button -->
                <button type="button" mat-raised-button color="primary" title="Submit" aria-label="Submit">Submit</button>
            </div>
          </div>
        </div>
    
    
      </div>
    </div>




 5. Setup a Reactive Form and bind the controls to the form


 6. Add the remaining HTML controls:  Add the textboxes and buttons


 7. Pressing Submit displays  *ALL* validation errors (if there are any)
    Pressing Reset  clears    *ALL* validation errors and reset the entire form


    The HTML so far
    ---------------
    <form [formGroup]="this.myForm" novalidate autocomplete="off">
    
      <div class="m-2.5">
        <div class="grid grid-cols-2">
          <div><span class="text-xl">Add Country Page</span></div>
    
          <div class="flex place-content-end">
            <!-- Help Button -->
            <button mat-raised-button type="button" title="Help" aria-label="Help">Help</button>
          </div>
        </div>
    
        <div class="overflow-y-auto mt-2.5" style="height: calc(100vh - 150px)">
    
          <div class="flex flex-col gap-y-2.5">
      
            <div>
              <!-- Three Character Country Code Text Box -->
              <span class="app-form-label">Three Character Country Code</span>
              <mat-form-field class="max-reduced-density [w-200px]">
                <input type="text" matInput formControlName="countryName" title="Three Character Country Code"/>
    
                <mat-error>This field is required</mat-error>
              </mat-form-field>
            </div>
              
            <div>
              <!-- Country Name Text Box-->
              <span class="app-form-label">Enter Country Name</span>
              <mat-form-field class="max-reduced-density w-[400px]">
                <input type="text" matInput formControlName="threeCharCode"  title="Enter Country Name"/>
    
                <mat-error>This field is required</mat-error>
              </mat-form-field>
            </div>

    
            <div>
              <!-- A L I A S E S      T E X T     B O X -->
              <span class="app-form-label">Enter Aliases</span>
              <mat-form-field class="max-reduced-density w-3/4">
                <input type="text" matInput formControlName="aliasText" title="Enter Aliases"/>
    
    
                <mat-hint>Press 'Enter' to add an alias</mat-hint>
    
                <mat-error>This field is required</mat-error>
              </mat-form-field>
            </div>
    
            <div>
              <!-- Is it a COSC? -->
              <span class="app-form-label">Is it Country of Special Concern?</span>
              <div>
                <mat-checkbox formControlName="isCosc" >Is it COSC?</mat-checkbox>
              </div>
    
    
              <div class="mat-mdc-form-field-subscript-wrapper pl-[16px]"
                   *ngIf="(this.myForm.controls.isCosc.errors != null) && (this.myForm.controls.isCosc.touched)">
                <mat-error>This field is required</mat-error>
              </div>
            </div>
    
            <!-- Button Row -->
            <div class="flex place-content-center gap-x-5">
              <div>
                <!-- Reset Button -->
                <button type="button" (click)="this.resetClicked()" mat-raised-button title="Reset" aria-label="Reset">Reset</button>
              </div>
              <div>
                <!-- Submit Button -->
                <button type="button" (click)="this.submitClicked()" mat-raised-button color="primary" title="Submit" aria-label="Submit">Submit</button>
              </div>
            </div>
          </div>
    
    
        </div>
      </div>
    
    </form>

   
    
    The TypeScript so far
    ---------------------
    import {Component, OnInit} from '@angular/core';
    import {FormBuilder, FormGroup, Validators} from "@angular/forms";
    
    @Component({
      selector: 'app-chips-with-textbox-page',
      templateUrl: './chips-with-textbox-page.component.html',
      styleUrls: ['./chips-with-textbox-page.component.scss']
    })
    export class ChipsWithTextboxPageComponent implements OnInit {
    
      public myForm: FormGroup;
    
      public constructor(private formBuilder: FormBuilder) {   }
    
      public ngOnInit(): void {
        // Initialize the form
        this.myForm = this.formBuilder.group({
          threeCharCode: [null, Validators.required ],
          countryName:   [null, Validators.required],
          aliases:       [null, Validators.required],
          isCosc:        [null, Validators.required]
        });
    
      }
    
      public resetClicked(): void {
        this.myForm.reset();
      }
    
    
      public submitClicked(): void {
        // Touch all form fields (to show any errors)
        this.myForm.markAllAsTouched();
    
        if (this.myForm.invalid) {
          // There are form validations.  So, stop here
          return;
        }
    
      }
    }
           


Part 2 / Change the Aliases Text Box to a Text Box with Chips
-------------------------------------------------------------
 1. In the TypeScript / Add a class variable:  aliases
    -- This is an array of strings
    -- Initialize this to an empty array
    -- As the user types-in aliases, this array will hold them
    
            public aliases: string[] = [];
    
 
 2. In the TypeScript / The resetClicked() method should reset the array of aliases back to an empty string
 
           public resetClicked(): void {
            // Reset the array of aliases
            this.aliases = [];
        
            // Reset the form
            this.myForm.reset();
          }
 
 
 3. In the TypeScript / add a public class variable:  separatorKeysCodes
    -- Initialize it to an array that holds the constant ENTER and the constant COMMA
   
            // Separator keys (for handling different ways to separate the chips)
            public separatorKeysCodes: number[] = [ENTER, COMMA];
  
   
 4. In the TypeScript / Add a method:  addAlias()
    -- It takes in a event that has the type of MatChipInputEvent
    a. Get a reference to the input box (we need this to get the user entered text)
    b. Get the entered value
    
    c. If the user typed-in anything, then
           1) Add the entered alias to the array of aliases
           2) Sync the array of aliases with your form field called "aliases"
         
    d. Clear the textbox (so the user can enter another textbox)
    
    e. Make the form field as dirty (to hide the hint)
        
          public addAlias(event: MatChipInputEvent): void {
            const input: MatChipInput = event.chipInput;
            const value: string = event.value.trim();
        
            if (value) {
              // Add the alias to the array
              this.aliases.push(value);
        
              // Sync the class variable this.aliases with the form field
              this.myForm.controls.aliases.setValue(this.aliases);
            }
        
            if (input) {
              // Clear the text box
              input.inputElement.value = '';
            }
        
            // Make this form field as dirty (to hide the hint)
            this.myForm.controls.aliases.markAsDirty();
          }
            
    
 5. In the TypeScript / add a method:  removeAlias()
    -- It takesn an index-to-remove / that's a number
    a. Remove this item from the array
    b. Sync the array of aliases with your form field called "aliases"
    
          public removeAlias(aArrayIndexToRemove: number): void {
            if (aArrayIndexToRemove < 0) {
              // The array index is invalid.  So, stop here.
              return;
            }
        
            // Remove this element from the array
            this.aliases.splice(aArrayIndexToRemove, 1);
        
            // Sync the class variable this.aliases with the form field
            this.myForm.controls.aliases.setValue(this.aliases);
          }

 
 
 6. In the HTML, replace the <mat-form-field> with this:
 
          <!-- A L I A S E S      T E X T     B O X -->
          <mat-form-field class="max-reduced-density w-3/4">

            <mat-chip-grid #chipGrid aria-label="Enter country aliases" formControlName="aliases">

              <!-- Loop through the array of aliases, creating chips -->
              <mat-chip-row
                *ngFor="let alias of this.aliases; let index=index"
                (removed)="this.removeAlias(index)"
                [aria-description]="'Press enter to edit ' + alias">

                <!-- The chip text -->
                {{ alias }}

                <!-- Add a button to remove this chip -->
                <button matChipRemove [attr.aria-label]="'Remove ' + alias">
                  <i class="fa-solid fa-circle-xmark text-black"></i>
                </button>
              </mat-chip-row>

              <!-- The text input for typing out a new chip -->
              <input placeholder="Enter Alias..."
                     [matChipInputFor]="chipGrid"
                     [matChipInputSeparatorKeyCodes]="separatorKeysCodes"
                     [matChipInputAddOnBlur]="true"
                     (matChipInputTokenEnd)="this.addAlias($event)"/>

            </mat-chip-grid>

            <!-- Show the hint if the form is not dirty -->
            <mat-hint *ngIf="this.myForm.controls.aliases.pristine">Press 'Enter' to add an alias</mat-hint>

            <mat-error>This field is required</mat-error>
          </mat-form-field>
 
 
 
 
 7. Inside the <mat-form-field>, make sure you have a hint and error message
 
 
 
 8. Beneath your div, add a <pre> tag and display the aliases (so you can see them change in real time)
 
        <div>
            <pre>
            this.aliases={{ this.aliases | json }}
            </pre>
        </div> 



    The Completed HTML looks like this
    ----------------------------------
    <form [formGroup]="this.myForm" novalidate autocomplete="off">
    
      <div class="m-2.5">
        <div class="grid grid-cols-2">
          <div><span class="text-xl">Add Country Page</span></div>
    
          <div class="flex place-content-end">
            <!-- Help Button -->
            <button mat-raised-button type="button" title="Help" aria-label="Help">Help</button>
          </div>
        </div>
    
        <div class="overflow-y-auto mt-2.5" style="height: calc(100vh - 150px)">
    
          <div class="flex flex-col gap-y-2.5">
    
            <div>
              <!-- Three Character Country Code Text Box -->
              <span class="app-form-label">Three Character Country Code</span>
              <mat-form-field class="max-reduced-density [w-200px]">
                <input type="text" matInput formControlName="countryName" title="Three Character Country Code"/>
    
                <mat-error>This field is required</mat-error>
              </mat-form-field>
            </div>
    
            <div>
              <!-- Country Name Text Box-->
              <span class="app-form-label">Enter Country Name</span>
              <mat-form-field class="max-reduced-density w-[400px]">
                <input type="text" matInput formControlName="threeCharCode"  title="Enter Country Name"/>
    
                <mat-error>This field is required</mat-error>
              </mat-form-field>
            </div>
    
    
            <div>
              <!-- A L I A S E S      T E X T     B O X -->
              <span class="app-form-label">Enter Aliases</span>
              <mat-form-field class="max-reduced-density w-3/4">
    
                <mat-chip-grid #chipGrid aria-label="Enter country aliases" formControlName="aliases">
    
                  <!-- Loop through the array of aliases, creating chips -->
                  <mat-chip-row
                    *ngFor="let alias of this.aliases; let index=index"
                    (removed)="this.removeAlias(index)"
                    [aria-description]="'Press enter to edit ' + alias">
    
                    <!-- The chip text -->
                    {{ alias }}
    
                    <!-- Add a button to remove this chip -->
                    <button matChipRemove [attr.aria-label]="'Remove ' + alias">
                      <i class="fa-solid fa-circle-xmark text-black"></i>
                    </button>
                  </mat-chip-row>
    
                  <!-- The text input for typing out a new chip -->
                  <input placeholder="Enter Alias..."
                         [matChipInputFor]="chipGrid"
                         [matChipInputSeparatorKeyCodes]="separatorKeysCodes"
                         [matChipInputAddOnBlur]="true"
                         (matChipInputTokenEnd)="this.addAlias($event)"/>
    
                </mat-chip-grid>
    
                <!-- Show the hint if the form is not dirty -->
                <mat-hint *ngIf="this.myForm.controls.aliases.pristine">Press 'Enter' to add an alias</mat-hint>
    
                <mat-error>This field is required</mat-error>
              </mat-form-field>
            </div>
    
            <div>
              <!-- Is it a COSC? -->
              <span class="app-form-label">Is it Country of Special Concern?</span>
              <div>
                <mat-checkbox formControlName="isCosc" >Is it COSC?</mat-checkbox>
              </div>
    
    
              <div class="mat-mdc-form-field-subscript-wrapper pl-[16px]"
                   *ngIf="(this.myForm.controls.isCosc.errors != null) && (this.myForm.controls.isCosc.touched)">
                <mat-error>This field is required</mat-error>
              </div>
            </div>
    
            <!-- Button Row -->
            <div class="flex place-content-center gap-x-5">
              <div>
                <!-- Reset Button -->
                <button type="button" (click)="this.resetClicked()" mat-raised-button title="Reset" aria-label="Reset">Reset</button>
              </div>
              <div>
                <!-- Submit Button -->
                <button type="button" (click)="this.submitClicked()" mat-raised-button color="primary" title="Submit" aria-label="Submit">Submit</button>
              </div>
            </div>
          </div>
    
    
        </div>
    
    
    
      </div>
    
    
    </form>

    
    
    The Completed TypeScript looks like this
    ----------------------------------------
    import {Component, OnInit} from '@angular/core';
    import {FormBuilder, FormGroup, Validators} from "@angular/forms";
    import {COMMA, ENTER} from "@angular/cdk/keycodes";
    import {MatChipInput, MatChipInputEvent} from "@angular/material/chips";
    
    @Component({
      selector: 'app-chips-with-textbox-page',
      templateUrl: './chips-with-textbox-page.component.html',
      styleUrls: ['./chips-with-textbox-page.component.scss']
    })
    export class ChipsWithTextboxPageComponent implements OnInit {
    
      public myForm: FormGroup;
      public aliases: string[] = [];
    
      // Separator keys (for handling different ways to separate the chips)
      public separatorKeysCodes: number[] = [ENTER, COMMA];
    
      public constructor(private formBuilder: FormBuilder) {   }
    
      public ngOnInit(): void {
        // Initialize the form
        this.myForm = this.formBuilder.group({
          threeCharCode: [null, Validators.required ],
          countryName:   [null, Validators.required],
          aliases:       [null, Validators.required],
          isCosc:        [null, Validators.required]
        });
    
      }
    
      public resetClicked(): void {
        // Reset the array of aliases
        this.aliases = [];
    
        // Reset the form
        this.myForm.reset();
      }
    
    
    
      public submitClicked(): void {
        // Touch all form fields (to show any errors)
        this.myForm.markAllAsTouched();
    
        if (this.myForm.invalid) {
          // There are form validations.  So, stop here
          return;
        }
      }
    
    
    
      /*
       * The user pressed Enter or Comma in the chip textbox
       *  1) Store the alias in the array of aliases
       *  2) Clear the text box (so the user can enter another alias)
       *  3) Mark this form as dirty (so the hint is not visible)
       */
      public addAlias(event: MatChipInputEvent): void {
        const input: MatChipInput = event.chipInput;
        const value: string = event.value.trim();
    
        if (value) {
          // Add the alias to the array
          this.aliases.push(value);
    
          // Sync the class variable this.aliases with the form field
          this.myForm.controls.aliases.setValue(this.aliases);
        }
    
        if (input) {
          // Clear the text box
          input.inputElement.value = '';
        }
    
        // Make this form field as dirty (to hide the hint)
        this.myForm.controls.aliases.markAsDirty();
      }
    
    
      /*
       * The user wishes to remove an alias
       *  1) Remove the alias item from the array
       *  2) Sync the class variable with the form field
       */
      public removeAlias(aArrayIndexToRemove: number): void {
        if (aArrayIndexToRemove < 0) {
          // The array index is invalid.  So, stop here.
          return;
        }
    
        // Remove this element from the array
        this.aliases.splice(aArrayIndexToRemove, 1);
    
        // Sync the class variable this.aliases with the form field
        this.myForm.controls.aliases.setValue(this.aliases);
      }
    
    }


```