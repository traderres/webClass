Lesson 24b:  Add Dark Mode / Remember Settings
----------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1oPV4jokLM6Kg1XppMCnKFasVMYZ3l0HF51-vUeyzLuA/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson24b
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem:      The web app does not remember the user's dark mode (when the user clicks on dark mode)<br>
Solution:     Save the selected theme name in the user preferences and load it (when the main page loads)<br>
<br>
<br>
<br>

```

Assumptions
-----------
    • You have followed the steps in 22i to create a REST endpoint to get/set preferences
    • You have a front-end preferenceService
    • You have a front-thd themeService



Approach
--------
    1. Change the ThemeChangerMenuComponent to save the user's preference 

    2. Change the app.component.ts so it
        a. Initialize an observable to get the user's preferences for theme  
        b. Use pipe and tap and initialize the themeService

    3. Change the app.component.html so it has an async pipe around the page



Procedure
---------
    1. Edit constants.ts so that there is a common preference name:

        Add this constant:
          THEME_PREFERENCE_NAME = "theme",                  	// Preference name for the theme



    2. Edit theme-changer-menu.component.ts

        a. Inject the preferenceService into the constructor:
              private preferenceService: PreferenceService


        b. Change the changeTheme() method so it saves the preference
            
              /*
               * The user selected to change the theme
               */
              public changeTheme(aNewThemeOption: ThemeOptionDTO) {
                // Invoke a REST call to set the new theme name
            
            this.preferenceService.setPreferenceValueWithoutPage(Constants.THEME_PREFERENCE_NAME, aNewThemeOption.themeName).subscribe(() => {
                // The REST call finished successfully
            
                // Store the selected-theme-name (so we can show the correct radio button)
                this.selectedThemeName = aNewThemeOption.themeName;
            
                // Tell the theme service to change the theme (the themeService will send a message to other components)
                this.themeService.setTheme(aNewThemeOption);
                });
            
              }  // end of changeTheme()
            




    3. Edit app.component.ts to load the user's preference on page-load

        a. Add this public observable:
             public preferencesObs: Observable<GetOnePreferenceDTO>;

        b. Inject the preferenceService

        c. Initialize the observable in ngOnInit()
            
            // Setup the preferences observable  (the async pipe will invoke this REST call to get the light-mode/dark-mode preference)
            this.preferencesObs = this.preferenceService.getPreferenceValueWithoutPage(Constants.THEME_PREFERENCE_NAME).pipe(
              tap((aData: GetOnePreferenceDTO) => {
                // The REST call came back with some data
            
                // Initialize the theme service
                this.themeService.initialize(aData.value);
              })
            );



    4. Edit app.component.html

        Add this ng-container around the page:
       <ng-container *ngIf="this.preferencesObs | async">
    
       </ng-container>





    5. Verify it works
        a. Activate the Debugger on "Full WebApp"
        b. Click to change the theme from light-mode to dark mode
        c. Open a new browser
           -- The new browser should show the app in dark mode



```
