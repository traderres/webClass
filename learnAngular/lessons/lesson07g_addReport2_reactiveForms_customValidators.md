Lesson 7g: Add Report2 / Form Validation / Reactive Forms / Custom Validators
-----------------------------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1K-Oo-Ujlj7bRCZ5LyXHgTGYZjj8TejEvseM3ukZdAbU/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson7g/reactive-forms-custom-validator
<br>
<br>
<br>

<h3> Problem Set </h3>

Problem: We want to require uses to select ONE or TWO authors from the multiple-select-authors<br>
Solution: Create a custom validator
<br>
<br>

![](https://lh6.googleusercontent.com/_-0wWKTeWZOhZOjaR7i_WDnu97mkf7DZR3Z7D1g0dDvCFCAQZuQpMFNvKviFrF2V9BdNX6sodqd9dB4UcggZuoEiqrLI90v7cf8_9f9ljiwuinl0EsJ6_VDYgeyrRrs84BmQ3GDe)
On page load, the hint appears under the "Choose Authors"  
<br>
<br>
<br>


![](https://lh3.googleusercontent.com/u63O1NIGqb2ybu-rDLDf-15qExdds6p6X8mQoRXFjUsBHrbM_V9hZfGy9mS7BY9HDehqRFaXY_mYqoyq_oI4uBERR2oG4NTmkDeOwcx5dwh5E_n7dys49gXkOBQhDmsdcIThbjnL)
If the user selects 3 authors, then the custom error message appears<br>
NOTE: The custom error is set in the validatorMultipleSelect() method.
<br>
<br>
<br>
```
Procedure
    1. Add some hints to let the user know that they have to select 1 *or 2 authors
        a. Edit the add-report2.component.html

        b. Add  a hint and set it so it only appears when the control is pristine
           NOTE:  Add this WITHIN the <mat-form-field>...</mat-form-field> tag

            <mat-hint *ngIf="myForm.controls?.authors?.pristine">
                Hint: Select 1 or 2 authors
            </mat-hint>     

        c. Remove the old <mat-error> tag

        d. Add  these 2 <mat-error> tags:
            <mat-error *ngIf="myForm.controls?.authors?.errors?.required">
              Authors are required
            </mat-error>
    
            <mat-error *ngIf="myForm.controls?.authors?.errors?.custom_error">
               <!-- Display the custom error set in the custom validator -->
               {{myForm.controls?.authors?.errors?.custom_error}}
            </mat-error>


        e. When completed, the multiple-select authors looks like this:
              <mat-form-field>
                <mat-label>Choose Authors</mat-label>
    
                <mat-hint *ngIf="myForm.controls?.authors?.pristine">
                    Hint: Select 1 or 2 authors
                </mat-hint>
    
                <!-- Authors -->
                <mat-select multiple formControlName="authors">
                  <mat-option [value]=10>Adam</mat-option>
                  <mat-option [value]=11>Ben</mat-option>
                  <mat-option [value]=12>Peter</mat-option>
                  <mat-option [value]=13>Justin</mat-option>
                </mat-select>
    
                <mat-error *ngIf="myForm.controls?.authors?.errors?.required">
                  Authors are required
                </mat-error>
    
                <mat-error *ngIf="myForm.controls?.authors?.errors?.custom_error">
                  <!-- Display the custom error set in the custom validator -->
                  {{myForm.controls?.authors?.errors?.custom_error}}
                </mat-error>
    
              </mat-form-field>


    2. Create a custom validator that lets the user know if the user selects more than N items
        a. Create this class:  validatorUtils
           unix> cd ~/intellijProjects/angularApp1/frontend
           unix> ng generate class validators/validatorUtils --skip-tests

        b. Replace validate-utils.ts with this:
             
                import {FormControl, ValidatorFn} from "@angular/forms";
        
                export class ValidatorUtils {
        
        
                public static validateMultipleSelect(aMinSelected: number, aMaxSelected: number):
        ValidatorFn {
                    return (aControl: FormControl) => {
        
                      if (aControl.value == null) {
                        // The user has not selected any values -- so assume everything is valid
                        return null;
                      }
        
                      let totalValuesSelected: number = aControl.value.length;
                      if (totalValuesSelected < aMinSelected) {
                        return {'custom_error': `You must select at least ${aMinSelected} entries.`};
                      }
                      else if (totalValuesSelected > aMaxSelected) {
                        return {'custom_error': `You must select at most ${aMaxSelected} entries.`};
                      }
                      else {
                        // The user selected a valid number of values -- so no error is returned
                        return null;
                      }
        
                    }
                  }  // end of static method
        
                }
          

    3. Change the formBuilder.group so that authors uses the newly-created custom validator:
        a. Edit add-report 2.component.ts

        b. Adjust the authors section so it looks like this:
                 authors:  ['',
                               [
                                    Validators.required,
                                    ValidatorUtils.validateMultipleSelect(1,2)
                              ]]
     

        c. When finished, the ngOnInit() method should look this:
        
                  public ngOnInit() {
        
                    this.myForm = this.formBuilder.group({
                      report_name: [null,
                        [
                          Validators.required,
                          Validators.minLength(2),
                          Validators.maxLength(100)
                        ]],
        
                      source: ['', null],
        
                      priority:  ['', Validators.required],
        
                      authors:  ['',
                          [
                            Validators.required,
                            ValidatorUtils.validateMultipleSelect(1,2)
                          ]]
                    });
        
                  }

    4. Try it out
        a. Activate the debugger
        b. Go to the "Add Report 2" page
        c. In the Add Report 2 page, you should see this behavior:
           -- The authors hint should only appear if the form is pristine (never been touched)
           -- Once you click on authors, the hint disappears
           -- If you select 1 or 2 entries, then the authors field should be valid
```
