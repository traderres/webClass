```
Exercise 26ai / Chips / User Chips with a Text Box
--------------------------------------------------
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
        



 3. Add real HTML form fields
 
 
 4. Put the modern "2020 style" labels above the HTML form fields


 5. Setup a Reactive Form and bind the controls to the form


 6. Add the remaining HTML controls:  Add the textboxes and buttons


 7. Pressing Submit displays  *ALL* validation errors (if there are any)
    Pressing Reset  clears    *ALL* validation errors and reset the entire form

   
   
           


Part 2 / Change the Aliases Text Box to a Text Box with Chips
-------------------------------------------------------------
 1. In the TypeScript / Add a class variable:  aliases
    -- This is an array of strings
    -- Initialize this to an empty array
    -- As the user types-in aliases, this array will hold them
    
            public aliases: string[] = [];
    
 
 2. In the TypeScript / The resetClicked() method should reset the array of aliases back to an empty string
 
 
 3. In the TypeScript / add a public class variable:  separatorKeysCodes
    -- Initialize it to an array that holds the constant ENTER and the constant COMMA
   

  
   
 4. In the TypeScript / Add a method:  addAlias()
    -- It takes in a event that has the type of MatChipInputEvent
    a. Get a reference to the input box (we need this to get the user entered text)
    b. Get the entered value
    
    c. If the user typed-in anything, then
           1) Add the entered alias to the array of aliases
           2) Sync the array of aliases with your form field called "aliases"
         
    d. Clear the textbox (so the user can enter another textbox)
    
    e. Make the form field as dirty (to hide the hint)
    
    
 5. In the TypeScript / add a method:  removeAlias()
    -- It takesn an index-to-remove / that's a number
    a. Remove this item from the array
    b. Sync the array of aliases with your form field called "aliases"
    
 
 6. In the HTML, mat-form-field with this format
    -- STOP HERE and we'll talk about filling-in this crazy shit!
    
        <mat-form-field>
        
             <mat-chip-grid #chipGrid aria-label="Enter country aliases">
             
                    <!-- Loop through the array of aliases creating mat-chip-row records -->
                    <mat-chip-row....>
                    
                    
                    </mat-chip-row>
             
                     <!-- The text input for typing out a new chip -->
                     <input placeholder="Enter Alias..."
                     [matChipInputFor]="chipGrid"
                     [matChipInputSeparatorKeyCodes]="separatorKeysCodes"
                     [matChipInputAddOnBlur]="true"
                     (matChipInputTokenEnd)="this.addAlias($event)"/>

             </mat-chip-grid>
        
        </mat-form-field>
 
 
      
 7. Inside the <mat-form-field>, make sure you have a hint and error message
 
 
 
 8. Beneath your div, add a <pre> tag and display the aliases (so you can see them change in real time)
 
        <div>
            <pre>
            this.aliases={{ this.aliases | json }}
            </pre>
        </div> 



```