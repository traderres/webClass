Lesson 24a:  Add Dark Mode / Add Theme Changer
----------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1vhbZjzghg4jpA7R9EACMsCWwRC6jLsWNJTY0oHG2uaU/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson24a
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem:  My customers want to change the color scheme but I don't want to change CSS everywhere<br>
Solution:  Add a theme changer<br>
<br>
<br>
The Theme Changer is the popup in the upper right corner with the "Light Mode" and "Dark Mode" options

![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson24a_image1.png)
<br>
<br>
<br>
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson24a_image2.png)
<br>
<br>
<br>

```
Approach
--------
    1. Setup light mode as a dark-blue/light-blue theme in the header and navbar

    2. Add the StyleManagerService  (copied from Angular Material's repository)

    3. Add the ThemeService
        a. This has a list of available themes
        b. This has a setTheme() method that sends a message out to let other components know that the theme has changed
        c. This has a getThemeStateAsObservable() method that allows other components to listen for theme changes
        d. Add the deep-purple light theme to src/assets/themes  (used for light mode in Angular Material)
        e. Add the purple-green dark theme to src/assets/thtmes  (used for dark mode in Angular Material)

    4. Add a ThemeChangerMenuComponent
(This lets users changes the theme)

    5. Change the header component so it listens for theme changes

    6. Change the navbar so it listens for theme changes

    7. Change the pdf-viewer component so it listens for theme changes

    8. Change the grid component so it listens for theme changes

    9. Change the markdown editor page so it listens for theme changes


Procedure
---------
    1. Setup light mode as a dark-blue/light-blue theme in the header and navbar
        a. Edit header.component.css

        b. Replace its contents with this:
            
            .header {
              color: white;
              height: 100%;
              padding-left: 16px;
              padding-right: 16px;
            
              /* Dark Blue longer....Light Blue....Dark Blue longer */
              /* Permalink - use to edit and share this gradient:
            https://colorzilla.com/gradient-editor/#19134b+0,19134b+13,257aaf+50,19134b+87,19134b+100 */
              background: #19134b; /* Old browsers */
              background: -moz-linear-gradient(left,  #19134b 0%, #19134b 13%, #257aaf 50%, #19134b 87%, #19134b 100%); /* FF3.6-15 */
              background: -webkit-linear-gradient(left,  #19134b 0%,#19134b 13%,#257aaf 50%,#19134b 87%,#19134b 100%); /* Chrome10-25,Safari5.1-6 */
              background: linear-gradient(to right,  #19134b 0%,#19134b 13%,#257aaf 50%,#19134b 87%,#19134b 100%); /* W3C, IE10+, FF16+, Chrome26+, Opera12+, Safari7+ */
              filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#19134b', endColorstr='#19134b',GradientType=1 ); /* IE6-9 */
            }
            
            .appLogo {
              color: #fff;
              padding: 0;
              margin: 0;
              text-decoration: none;
            
              font-size: 1.7em;
              font-weight: 400;
              font-family: Roboto, "Helvetica Neue", sans-serif;
            
              /* Outline of zero gets rid of the annoying box around the link */
              outline: 0;
            
              white-space: nowrap;
            }
            
            a.button {
              background-color: #19134b;   /* dark blue */
              border: 1px solid #444;
              border-radius: 4px;
              font-size: 14px;
              line-height: 20px;
              color: #f7f7f7;
              padding: 7px 14px 7px 14px;
              height: 20px;
              cursor: pointer;
              -webkit-transition: 200ms all linear;
              -moz-transition: 200ms all linear;
              -o-transition: 200ms all linear;
              transition: 200ms all linear;
              background-image: none;
            }
            
            a.button:hover {
              background-color: #2579af;   /* light blue */
              color: white;
              border-color: #f9f9f9;
            }
            
            



        c. Edit navbar.component.css

        d. Replace its contents with this:
            
            .navbar {
              /* Set the colors for the navbar */
              background: #19134b;   /* dark blue so it blends with the header */
              color: white;
              height: 100%;
              overflow: hidden;
            }
            
            .mat-list-item {
              font-family: 'Open Sans', sans-serif;
              font-style: normal;
              font-size: 14px;
              font-weight: normal;
              color: white !important;
              height: 25px;
              white-space: nowrap;   /* stop wrapping of text */
            }
            
            .navHeader{
              /* The navHeader has a background gradient that goes to the left */
              background: linear-gradient(to left, #5e6b7b, rgba(94, 107, 123, 0));
            
              font-family: 'Open Sans', sans-serif;
              font-style: normal;
              font-weight: 400;
              font-size: 17px;
            
              padding: 0;
              margin-top: 0;
              height: 44px;
              display: flex;
              align-items: center;
              white-space: nowrap;   /* stop wrapping of text */
            }
            
            .navHeaderIcon {
              margin-left: 7px;
            }
            
            .navHeaderTitle {
              margin-left: 8px;
            }
            
            .mat-list-item.navItem {
              height: 40px;
            }
            
            .navItem:hover  {
              color: #fff;
              background: linear-gradient(to right, #5e6b7b, rgba(94, 107, 123, 0)) !important;
              font-weight: bold;
            }
            
            .navItemIcon {
              /* By default, the navItemIcon is invisible (It's same color as the navbar background) */
              color: #19134b
            }
            
            .mat-list-item.active .navItemIcon {
              /* User is not hoving over an active navItemIcon.  So, set it's background as the same color as the background so it's invisible */
              color: #5e6bd5;
            }
            
            .navItem:hover .navItemIcon {
              /* User is hovering over navItem on a non-active route */
              color: #999
            }
            
            .mat-list-item.active{
              /* Set the color for the actively clicked navbar item */
              /* Active mat-list-item has a background gradient that goes to the right */
              color: #fff;
              background: #5e6bd5 !important;
              font-weight: 700;
            }
            
            .navGroupClosed {
              display: none;
            }
            




        e. Verify that the webapp has the dark-blue/light-blue theme
            i. Activate the Debugger on "Full WebApp"
            ii. Verify that the page looks like this:
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson24a_image3.png)
```
This is our "light mode"



    2. Add the StyleManagerService  (copied from Angular Material's repository)
       a. Generate the service
          unix> cd ~/intellijProjects/angularApp1/frontend
          unix> ng generate service services/StyleManager --skipTests

        b. Edit style-manager.service.ts

        c. Replace its contents with this:
                
                import { Injectable } from '@angular/core';
                
                @Injectable({
                  providedIn: 'root'
                })
                export class StyleManagerService {
                  constructor() {}
                
                  /**
                   * Set the stylesheet with the specified key.
                   */
                  setStyle(key: string, href: string) {
                    getLinkElementForKey(key).setAttribute("href", href);
                  }
                
                  /**
                   * Remove the stylesheet with the specified key.
                   */
                  removeStyle(key: string) {
                    const existingLinkElement = getExistingLinkElementByKey(key);
                    if (existingLinkElement) {
                    document.head.removeChild(existingLinkElement);
                    }
                  }
                
                }  // end of class

                
                // ------------- JavaScript functions below -------------
                
                function getLinkElementForKey(key: string) {
                  return getExistingLinkElementByKey(key) || createLinkElementWithKey(key);
                }
                
                function getExistingLinkElementByKey(key: string) {
                  return document.head.querySelector(
                    `link[rel="stylesheet"].${getClassNameForKey(key)}`
                  );
                }
                
                function createLinkElementWithKey(key: string) {
                  const linkEl = document.createElement("link");
                  linkEl.setAttribute("rel", "stylesheet");
                  linkEl.classList.add(getClassNameForKey(key));
                  document.head.appendChild(linkEl);
                  return linkEl;
                }
                
                function getClassNameForKey(key: string) {
                  return `app-${key}`;
                }




    3. Add the ThemeService
        a. Add this model class:  ThemeOptionDTO
           i.   Generate the ThemeOptionDTO
                unix> ng generate class models/ThemeOptionDTO --skipTests

           ii.  Edit theme-option-dto.ts

           iii. Replace its contents with this:
    
                    export class ThemeOptionDTO {
                      label: string;
                      themeName: string;
                      isLightMode: boolean;
                    }



        b. Add this service:  ThemeService
           i.   Generate the ThemeService
                unix> ng generate service services/theme --skipTests

           ii.  Edit theme.service.ts

           iii. Replace its contents with this:
                    
                    import { Injectable } from '@angular/core';
                    import {ThemeOptionDTO} from "../models/theme-option-dto";
                    import {BehaviorSubject, Observable, of} from "rxjs";
                    import {StyleManagerService} from "./style-manager.service";
                    
                    @Injectable({
                      providedIn: 'root'
                    })
                    export class ThemeService {
                    
                      private themeStateSubject: BehaviorSubject<ThemeOptionDTO>;
                    
                      private readonly DEFAULT_THEME_NAME: string = "deeppurple-amber-light1";
                    
                      private options: ThemeOptionDTO[] = [
                        {
                        label: "Light Mode",
                        themeName: "deeppurple-amber-light1",
                        isLightMode: true
                        },
                        {
                        label: "Dark Mode",
                        themeName: "purple-green-dark1",
                        isLightMode: false
                        }
                      ];
                    
                      constructor(private styleManagerService: StyleManagerService) {  }
                    
                    
                      public getThemeStateAsObservable(): Observable<ThemeOptionDTO> {
                        return this.themeStateSubject.asObservable();
                      }
                    
                    
                      /*
                       * Initialize the theme service by setting an initial theme name
                       * And, then use the BehaviorSubject to emit that new value to the header, navbar, grids, ....
                       */
                      public initialize(aThemeName: string) {
                    
                        for (const option of this.options) {
                        if (option.themeName == aThemeName) {
                            // Use the StyleManagerService to tell Angular Material to change the theme
                            this.styleManagerService.setStyle(
                            "theme",
                            `assets/themes/${option.themeName}.css`
                            );
                    
                            this.themeStateSubject = new BehaviorSubject<ThemeOptionDTO>(option);
                            return;
                        }
                        }
                    
                        // I did not find the theme name from the database.  So, emit the default theme
                        for (const option of this.options) {
                        if (option.themeName == this.DEFAULT_THEME_NAME) {
                            // Use the StyleManagerService to tell Angular Material to change the theme
                            this.styleManagerService.setStyle(
                            "theme",
                            `assets/themes/${option.themeName}.css`
                            );
                    
                            this.themeStateSubject = new BehaviorSubject<ThemeOptionDTO>(option);
                            return;
                        }
                        }
                    
                      }
                    
                    
                      /*
                       * Get a list of themes to display in the popup menu
                       */
                      public getThemeOptions(): Observable<ThemeOptionDTO[]> {
                        return of(this.options);
                      }
                    
                    
                      /*
                       * The user has clicked on a different theme
                       */
                      public setTheme(aNewTheme: ThemeOptionDTO): void {
                    
                        // Use the StyleManagerService to tell Angular Material to change the theme
                        this.styleManagerService.setStyle(
                        "theme",
                        `assets/themes/${aNewTheme.themeName}.css`
                        );
                    
                        // Send a message out to the header/navbar/grid pages (telling them that the theme has changed)
                        this.themeStateSubject.next(aNewTheme);
                      }
                    
                    
                    }
                    
                    



        c. Install your light theme Angular Material Theme
           NOTE:  This file sets Angular Material's light theme
            i.   Create this directory:  angularApp1/frontend/src/assets/themes

            ii.  Copy the deeppurple-amber.css from

                 From here:
                    angularApp1/frontend/node_modules/@angular/material/prebuilt-themes/deeppurple-amber.css
                
                 To here:
                    angularApp1/frontend/src/assets/themes/

            iii. Rename deeppurple-amber.css to deeppurple-amber-light1.css



        d. Install your dark theme Angular Material Theme
           NOTE:  This file sets Angular Material's dark theme
            i.   Copy the purple-green.css from
                
                 From here:
                    angularApp1/frontend/node_modules/@angular/material/prebuilt-themes/purple-green.css
                
                 To here:
                    angularApp1/frontend/src/assets/themes/

            ii.  Rename purple-green.css to purple-green-dark1.css






    4. Add a ThemeChangerMenuComponent
       a. Edit app.module.ts

       b. Add MatMenuModule to the imports

       c. Add MatRadioModule to the imports

       d. Generate the component
          unix> cd ~/intellijProjects/angularApp1/frontend
          unix> ng generate component ThemeChangerMenu --skipTests

       e. Edit theme-changer-menu.component.ts

       f. Replace its contents with this:
            
            import {Component, OnInit} from '@angular/core';
            import {ThemeService} from "../services/theme.service";
            import {Observable} from "rxjs";
            import {ThemeOptionDTO} from "../models/theme-option-dto";
            import {first} from "rxjs/operators";
            
            @Component({
              selector: 'app-theme-changer-menu',
              templateUrl: './theme-changer-menu.component.html',
              styleUrls: ['./theme-changer-menu.component.css']
            })
            export class ThemeChangerMenuComponent implements OnInit {
            
              public selectedThemeName: string;
              public themeOptionsObs: Observable<ThemeOptionDTO[]>;
            
            
              constructor(private themeService: ThemeService) {
                this.themeOptionsObs = this.themeService.getThemeOptions();
            
                // This component is initializing.  So, get the *frst* value from the themeService
                // (so we can show the correct radio button pre-selected)
                this.themeService.getThemeStateAsObservable().pipe(
                first()).subscribe( (aNewTheme: ThemeOptionDTO) => {
                    // We got a first value from the theme service
            
                    // Use that initial value to set the selected theme name (so the radio button is selected in the html)
                    this.selectedThemeName = aNewTheme.themeName;
                });
              }
            
              ngOnInit(): void {
              }
            
              public changeTheme(aThemeName: ThemeOptionDTO) {
                this.selectedThemeName = aThemeName.themeName;
            
                this.themeService.setTheme(aThemeName);
              }
            
            }


        g. Edit theme-changer-menu.component.html

        h. Replace its contents with this:
                
                <button class="header-button" [matMenuTriggerFor]="menu" mat-raised-button aria-label="Choose your theme" title="Choose your theme">
                  <i class="fas fa-fill-drip" style="font-size: 20px"></i>
                </button>
                
                <mat-menu #menu="matMenu">
                  <mat-radio-group>
                
                    <ng-container *ngIf="(this.themeOptionsObs | async) as options">
                
                    <button *ngFor="let option of this.options" mat-menu-item style="height: fit-content;">
                        <mat-radio-button [value]="option.label"
                                        (click)="changeTheme(option)"
                                        [checked]="this.selectedThemeName == option.themeName">
                        {{ option.label}}
                        </mat-radio-button>
                    </button>
                    </ng-container>
                
                  </mat-radio-group>
                
                </mat-menu>



        i. Edit theme-chanager-menu.component.css

        j. Replace its contents with this:
            
            .header-button {
              background-color: #111111;   /* dark black */
              border: 1px solid #444;
              border-radius: 4px;
              line-height: 20px;
              color: #f7f7f7;
              padding: 7px 2px 7px 2px;
              margin-left: 0;
              margin-right: 0;
              height: 35px;
              cursor: pointer;
              -webkit-transition: 200ms all linear;
              -moz-transition: 200ms all linear;
              -o-transition: 200ms all linear;
              transition: 200ms all linear;
              background-image: none;
            }
            
            .header-button:hover {
              background-color: #303030;   /* light grey */
              color: white;
              border-color: #f9f9f9;
            }


    5. Edit app.component.ts so that it initialized the themeService
       a. Edit app.component.ts

       b. Inject the themeService 

       c. Add these lines to the ngOnInit():
        
            // Normally, we would get this value from a database lookup
            // If the theme name is not found, then the default light mode theme is displayed
            this.themeService.initialize("theme-from-database");


    6. Remove deeppurple-amber.css from the angular.json
       a. Edit angular.json

       b. Change the styles section

       c. Remove this line:
            "./node_modules/@angular/material/prebuilt-themes/deeppurple-amber.css",



    7. Add the theme changer to the header
       a. Edit header.component.html

       b. Change the right side of the header  [with changes in bold]

            <!-- Right Side of the Header -->
            <div fxFlex fxLayoutAlign="end center">
        
            <!-- Theme Changer -->
            <app-theme-changer-menu style="margin-right:5px">
            </app-theme-changer-menu>
        
            <!-- User Menu -->
            <a class="button" (click)="toggleUserNavbar()">
                <span class="username">John.Smith</span>&nbsp;
                <span class="fa fa-user"></span>
            </a>
            </div>



    8. Verify that the theme changer changes the Angular Material theme
       NOTE:  It does not change the header or navbar at this point
       a. Activate the Debugger on "Full WebApp"
       b. Click on the bucket icon
       c. Change from dark mode to light mode
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson24a_image4.png)
```
Light mode should look like this:



```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson24a_image5.png)
```
Dark mode should look like this:


    9. Change the header component so it listens for theme changes
       a. Edit header.component.ts

       b. Make sure the HeaderComponent implements OnInit, OnDestroy

       c. Inject the themeService

       d. Add these 2 variables:
            private themeStateSubscription: Subscription;
            public currentTheme: ThemeOptionDTO;


       e. Add these lines to the ngOnInit() so it listens for theme changes

            // Listen for changes from the theme service
            this.themeStateSubscription = this.themeService.getThemeStateAsObservable().subscribe( (aNewTheme: ThemeOptionDTO) => {
            // The theme has changed.
            this.currentTheme = aNewTheme;
            });



        f. Add the ngOnDestroy() method that will unsubscribe

          public ngOnDestroy(): void {
            if (this.themeStateSubscription) {
            this.themeStateSubscription.unsubscribe();
            }
          }


        g. Edit header.component.html
             i. Change the div on line 1 
        
                From this:
                   <div class="header">
                
                To this:
                
                <div  [ngClass]="{
                         'light':   this.currentTheme.isLightMode == true,
                         'dark':	this.currentTheme.isLightMode == false
                        }">



            ii. Verify that the application title is using class="appLogo clickable"

                <!-- Application Title -->
                <h1 class="appLogo clickable" [routerLink]="'/'">
                        Angular App1
                </h1> 




        h. Edit header.component.css

        i. Replace its contents with this:
            
            /*********** L I G H T  	M O D E  *************/
            .light {
              color: white;
              height: 100%;
              padding-left: 16px;
              padding-right: 16px;
            
              /* Dark Blue longer....Light Blue....Dark Blue longer */
              /* Permalink - use to edit and share this gradient:
            https://colorzilla.com/gradient-editor/#19134b+0,19134b+13,257aaf+50,19134b+87,19134b+100 */
              background: #19134b; /* Old browsers */
              background: -moz-linear-gradient(left,  #19134b 0%, #19134b 13%, #257aaf 50%, #19134b 87%, #19134b 100%); /* FF3.6-15 */
              background: -webkit-linear-gradient(left,  #19134b 0%,#19134b 13%,#257aaf 50%,#19134b 87%,#19134b 100%); /* Chrome10-25,Safari5.1-6 */
              background: linear-gradient(to right,  #19134b 0%,#19134b 13%,#257aaf 50%,#19134b 87%,#19134b 100%); /* W3C, IE10+, FF16+, Chrome26+, Opera12+, Safari7+ */
              filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#19134b', endColorstr='#19134b',GradientType=1 ); /* IE6-9 */
            }
            
            .light .appLogo {
              color: #fff;
              padding: 0;
              margin: 0;
              text-decoration: none;
            
              font-size: 1.7em;
              font-weight: 400;
              font-family: Roboto, "Helvetica Neue", sans-serif;
            
              /* Outline of zero gets rid of the annoying box around the link */
              outline: 0;
            
              white-space: nowrap;
            }
            
            .light a.button {
              background-color: #19134b;   /* dark blue */
              border: 1px solid #444;
              border-radius: 4px;
              font-size: 14px;
              line-height: 20px;
              color: #f7f7f7;
              padding: 7px 14px 7px 14px;
              height: 20px;
              cursor: pointer;
              -webkit-transition: 200ms all linear;
              -moz-transition: 200ms all linear;
              -o-transition: 200ms all linear;
              transition: 200ms all linear;
              background-image: none;
            }
            
            .light a.button:hover {
              background-color: #2579af;   /* light blue */
              color: white;
              border-color: #f9f9f9;
            }
            
            
            
            /***********  D A R K  	M O D E  *************/
            .dark {
              color: white;
              height: 100%;
              padding-left: 16px;
              padding-right: 16px;
            
              /* Colors:   extra dark is 111111,  dark grey is 303030,  Light grey is 424242 */
            
              /* Extra Dark 111111.....dark grey 303030....Light grey 424242 ....dark grey 303030...Extra Dark 111111 */
              /* Permalink - use to edit and share this gradient: https://colorzilla.com/gradient-editor/#303030+0,303030+20,111111+50,303030+83,303030+100 */
              background: #303030; /* Old browsers */
              background: -moz-linear-gradient(left,  #303030 0%, #303030 20%, #111111 50%, #303030 83%, #303030 100%); /* FF3.6-15 */
              background: -webkit-linear-gradient(left,  #303030 0%,#303030 20%,#111111 50%,#303030 83%,#303030 100%); /* Chrome10-25,Safari5.1-6 */
              background: linear-gradient(to right,  #303030 0%,#303030 20%,#111111 50%,#303030 83%,#303030 100%); /* W3C, IE10+, FF16+, Chrome26+, Opera12+, Safari7+ */
              filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#303030', endColorstr='#303030',GradientType=1 ); /* IE6-9 */
            }
            
            .dark .appLogo {
              color: #fff;
              padding: 0;
              margin: 0;
              text-decoration: none;
            
              font-size: 1.7em;
              font-weight: 400;
              font-family: Roboto, "Helvetica Neue", sans-serif;
            
              /* Outline of zero gets rid of the annoying box around the link */
              outline: 0;
            
              white-space: nowrap;
            }
            
            .dark a.button {
              background-color: #111111;   /* dark black */
              border: 1px solid #444;
              border-radius: 4px;
              font-size: 14px;
              line-height: 20px;
              color: #f7f7f7;
              padding: 7px 14px 7px 14px;
              height: 20px;
              cursor: pointer;
              -webkit-transition: 200ms all linear;
              -moz-transition: 200ms all linear;
              -o-transition: 200ms all linear;
              transition: 200ms all linear;
              background-image: none;
            }
            
            .dark  a.button:hover {
              background-color: #303030;   /* light grey */
              color: white;
              border-color: #f9f9f9;
            }

        j. Verify that the header changes color in dark mode
            i.  Activate the Debugger on "Full WebApp"
            ii. Switch from light mode to dark mode
               -- You should see the header change


In Light Mode, the header is a dark-blue to light-blue gradient
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson24a_image6.png)
```

In Dark Mode, the header is a light-grey-to-black-light-grey gradient
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson24a_image7.png)
```



    10. Change the navbar so it listens for theme changes
        a. Edit navbar.component.ts

        b. Make sure the NavbarComponent implements OnInit, OnDestroy

        c. Inject the themeService

        d. Add these 2 variables:
            private themeStateSubscription: Subscription;
            public currentTheme: ThemeOptionDTO;


        e. Add these lines to the ngOnInit() so it listens for theme changes
            
            // Listen for changes from the theme service
            this.themeStateSubscription = this.themeService.getThemeStateAsObservable().subscribe( (aNewTheme: ThemeOptionDTO) => {
            // The theme has changed.
            this.currentTheme = aNewTheme;
            });



        f. Add the ngOnDestroy() method that will unsubscribe

             public ngOnDestroy(): void {
                if (this.themeStateSubscription) {
                this.themeStateSubscription.unsubscribe();
                }
             }


        g. Edit navbar.component.html

        h. Change the top div

           From this:
               <div class="navbar" style="width:200px">
            
           To this:
              <div  style="width:200px"
                [ngClass]="{
                     'light':   this.currentTheme.isLightMode == true,
                     'dark':	this.currentTheme.isLightMode == false
                    }">




        i. Edit navbar.component.css

        j. Replace its contents with this:
            
            .navGroupClosed {
              display: none;
            }
            
            /*********** L I G H T  	M O D E  *************/
            .light {
              /* Set the colors for the navbar */
              background: #19134b;   /* dark blue so it blends with the header */
              color: white;
              height: 100%;
              overflow: hidden;
            }
            
            .light .mat-list-item {
              font-family: 'Open Sans', sans-serif;
              font-style: normal;
              font-size: 14px;
              font-weight: normal;
              color: white !important;
              height: 25px;
            
              white-space: nowrap;   /* stop wrapping of text */
            }
            
            .light .navHeader{
              /* The navHeader has a background gradient that goes to the left */
              background: linear-gradient(to left, #5e6b7b, rgba(94, 107, 123, 0));
            
              font-family: 'Open Sans', sans-serif;
              font-style: normal;
              font-weight: 400;
              font-size: 17px;
            
              padding: 0;
              margin-top: 0;
              height: 44px;
              display: flex;
              align-items: center;
              white-space: nowrap;   /* stop wrapping of text */
            }
            
            .light .navHeaderIcon {
              margin-left: 7px;
            }
            
            .light .navHeaderTitle {
              margin-left: 8px;
            }
            
            .light .mat-list-item.navItem {
              height: 40px;
            }
            
            .light .navItem:hover  {
              color: #fff;
              background: linear-gradient(to right, #5e6b7b, rgba(94, 107, 123, 0)) !important;
              font-weight: bold;
            }
            
            .light .navItemIcon {
              /* By default, the navItemIcon is invisible (It's same color as the navbar background) */
              color: #19134b
            }
            
            .light .mat-list-item.active .navItemIcon {
              /* User is not hovering over an active navItemIcon.  So, set it's background as the same color as the background so it's invisible */
              color: #5e6bd5;
            }
            
            .light .navItem:hover .navItemIcon {
              /* User is hovering over navItem on a non-active route */
              color: #999
            }
            
            .light .mat-list-item.active{
              /* Set the color for the actively clicked navbar item */
              /* Active mat-list-item has a background gradient that goes to the right */
              color: #fff;
              background: #5e6bd5 !important;
              font-weight: 700;
            }
            
            
            /***********  D A R K  	M O D E  *************/
            .dark  {
              /* Set the colors for the navbar */
              background: #303030;   /* dark grey is 303030....Light grey is 424242 */
              color: white;
              height: 100%;
              overflow: hidden;
            }
            
            .dark .mat-list-item {
              font-family: 'Open Sans', sans-serif;
              font-style: normal;
              font-size: 14px;
              font-weight: normal;
              color: white !important;
              height: 25px;
            
              white-space: nowrap;   /* stop wrapping of text */
            }
            
            .dark .navHeader{
              /* The navHeader has a background gradient that goes to the left */
              background: linear-gradient(to left, #5e6b7b, rgba(94, 107, 123, 0));
            
              font-family: 'Open Sans', sans-serif;
              font-style: normal;
              font-weight: 400;
              font-size: 17px;
            
              padding: 0;
              margin-top: 0;
              height: 44px;
              display: flex;
              align-items: center;
              white-space: nowrap;   /* stop wrapping of text */
            }
            
            .dark .navHeaderIcon {
              margin-left: 7px;
            }
            
            .dark .navHeaderTitle {
              margin-left: 8px;
            }
            
            .dark .mat-list-item.navItem {
              height: 40px;
            }
            
            .dark .navItem:hover  {
              color: #fff;
              background: linear-gradient(to right, #5e6b7b, rgba(94, 107, 123, 0)) !important;
              font-weight: bold;
            }
            
            .dark .navItemIcon {
              /* By default, the navItemIcon is invisible (It's same color as the navbar background) */
              color: #303030
            }
            
            
            .dark .mat-list-item.active .navItemIcon {
              /* User is not hoving over an active navItemIcon.  So, set it's background as the same color as
            the background so it's invisible */
              color: #111111;
            }
            
            .dark .navItem:hover .navItemIcon {
              /* User is hovering over navItem on a non-active route */
              color: #999
            }
            
            .dark .mat-list-item.active{
              /* Set the color for the actively clicked navbar item */
              /* Active mat-list-item has a background gradient that goes to the right */
              color: #fff;
              background: #111111 !important;   /* light blue is 5e6bd5 */
              font-weight: 700;
            }


        k. Verify the navbar looks good in dark mode
            i. Activate the debugger on "Full WebApp"
            ii. Click on the light mode/dark mode button
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson24a_image8.png)
```
Navbar in light mode





```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson24a_image9.png)
```
Navbar in dark mode




    11. Change the pdf-viewer component so it listens for theme changes
        NOTE:  For the pdf-viewer, we just change the background color property

        a. Edit pdf-viewer.component.ts

        b. Make sure the NavbarComponent implements OnInit, OnDestroy

        c. Inject the themeService

        d. Add these 2 variables:
            private themeStateSubscription: Subscription;
            public  pdfViewerBackgroundColor: string;


        e. Add these lines to the ngOnInit() so it listens for theme changes
            
                // Listen for changes from the theme service
                this.themeStateSubscription =
            this.themeService.getThemeStateAsObservable().subscribe( (aNewTheme: ThemeOptionDTO) => {
                // The theme has changed.
            
                if (aNewTheme.isLightMode) {
                        // Set a light background color for PDF Viewer
                    this.pdfViewerBackgroundColor = "#dcdcdc";
                }
                else {
                        // Set a dark background color for PDF Viewer
                        this.pdfViewerBackgroundColor = "#303030";
                }
                });



        f. Add the ngOnDestroy() method that will unsubscribe

              public ngOnDestroy(): void {
                if (this.themeStateSubscription) {
                    this.themeStateSubscription.unsubscribe();
                }
              }


        g. Edit pdf-viewer.component.html

        h. Add this property to the <ngx-extended-pdf-viewer>....</ngx-extended-pdf-viewer

        	 [backgroundColor]="this.pdfViewerBackgroundColor"



        i. Verify that the background color of the pdf-viewer changes in dark mode
            i. Activate the Debugger on "Full WebApp"
            ii. Click on "PDF Viewer"
            iii. Select Light Mode / Dark Mode

```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson24a_image10.png)
```
PDF Viewer Page in Light Mode


```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson24a_image11.png)
```
PDF Viewer Page in Dark Mode




    12. Change the report-grid-view component so it listens for theme changes
        a. Edit report-grid-view.component.ts

        b. Make sure the ReportGridViewComponent implements OnInit, OnDestroy

        c. Inject the themeService

        d. Add these 2 variables:
            private themeStateSubscription: Subscription;
            public currentTheme: ThemeOptionDTO;


        e. Add these lines to the ngOnInit() so it listens for theme changes

            // Listen for changes from the theme service
            this.themeStateSubscription = this.themeService.getThemeStateAsObservable().subscribe( (aNewTheme: ThemeOptionDTO) => {
            // The theme has changed.
            this.currentTheme = aNewTheme;
            });



        f. Add the ngOnDestroy() method that will unsubscribe

              public ngOnDestroy(): void {
                if (this.themeStateSubscription) {
                this.themeStateSubscription.unsubscribe();
                }
              }

        g. Edit report-grid-view.component.html

        h. Change the <ag-grid-angular>...</ag-grid-angular> 
            
           Remove this line:
               class="ag-theme-alpine"
            
            
           Add this line:
                [[ngClass]="{   'ag-theme-alpine':    	this.currentTheme.isLightMode == true,
                            'ag-theme-alpine-dark':   this.currentTheme.isLightMode == false
                        }"


        When finished, the <ag-grid-angular> tag should look like this:
        
        <ag-grid-angular
             style="width: 100%; height: 100%"
              [ngClass]="{   'ag-theme-alpine':    	this.currentTheme.isLightMode == true,
                                 'ag-theme-alpine-dark':   this.currentTheme.isLightMode == false
                            }"
              [rowData]="this.rowData"
             [defaultColDef]="this.defaultColDefs"
             [columnDefs]="this.columnDefs"
              [gridOptions]="this.gridOptions"
             [frameworkComponents]="this.frameworkComponents"
             (selectionChanged)="this.generateDerivedValuesOnUserSelection()"
             (gridReady)="this.onGridReady($event)">
        </ag-grid-angular>



        i. We need to include both the ag-theme-alpine.css and ag-theme-alpine-dark.css
           Edit angular.json

        j. Change the projects -> frontend -> architecture -> build -> options -> styles

           Add the ag-theme-alpine-dark
               "./node_modules/ag-grid-community/dist/styles/ag-theme-alpine-dark.css",

            
           When finished, the styles section should look like this:
            
            "styles": [
              "./node_modules/@fortawesome/fontawesome-free/css/all.css",
              "./node_modules/ag-grid-enterprise/dist/styles/ag-grid.css",
              "./node_modules/ag-grid-community/dist/styles/ag-theme-alpine.css",
              "./node_modules/ag-grid-community/dist/styles/ag-theme-alpine-dark.css",
              "./node_modules/quill/dist/quill.core.css",
              "./node_modules/quill/dist/quill.bubble.css",
              "./node_modules/quill/dist/quill.snow.css",
              "./node_modules/quill-emoji/dist/quill-emoji.css",
              "./node_modules/quill-mention/dist/quill.mention.min.css",
              "src/styles.css"
            ],


        k. Verify that the grid page looks good in dark mode
            i.  Activate the Debugger on "Full WebApp"
            ii. Click on "Report Grid View" in the navbar

```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson24a_image12.png)
```
The Report Grid View in Light Mode


```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson24a_image13.png)
```
The Report Grid View in Dark Mode



    13. Adjust Angular Material in Dark Mode
        PROBLEM:  The <mat-error> are really hard to read in dark mode
        SOLUTION:  Adjust the purple-green-dark1.css so that the <mat-error> is brighter
        
        a. Go to purple-green-dark1.css

        b. Copy the CSS

        c. Change the CSS so it's not minified
           i.   Go to https://beautifytools.com/css-beautifier.php
           ii.  Copy the CSS into the left side
           iii. Copy the formatted CSS on the right side
           iv.  Paste-in the CSS into purple-green-dark1.css

        d. Look for the mat-error tag and find the color
            
            .mat-error {
              color: #f44336;
            }

        e. In the file, do a search replace:
           Press Control R
           Find:      #f44336;
           Replace: orange
           Press "Replace All


        f. Verify that the error is easier to read in a regular page that uses Angular Material
            i.   Activate the Debugger on "Full WebApp"
            ii.  Click on "Add Reports"
            iii. Turn on Dark Mode
            iv.  Press the "Save" button
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson24a_image14.png)
```
Add Report Page in Light Mode


```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson24a_image15.png)
```
Add Report Page in Dark Mode   (the error is a bright orange now)





        g. Minify the css in purple-green-dark1.css
           i.   Go to https://beautifytools.com/css-beautifier.php
           ii.  Copy the updated CSS from purple-green-dark1.css in the left side
           iii. Press "Minify CSS"
           iv.  Copy the CSS from the right side
           v.   Paste the CSS into the purple-green-dark1.css


        h. Verify that the error is easier to read in a regular page that uses Angular Material
            i.   Activate the Debugger on "Full WebApp"
            ii.  Click on "Add Reports"
            iii. Turn on Dark Mode
            iv.  Press the "Save" button
                 -- You should see the Orange color


    14. Change the Quill Markdown Editor so it looks good in dark mode
        a. Edit report-submit-markdown.component.ts

        b. Make sure the ReportSubmitMarkdownComponent implements OnInit, OnDestroy

        c. Inject the themeService

        d. Add these 2 variables:
            private themeStateSubscription: Subscription;
            public currentTheme: ThemeOptionDTO;


        e. Add these lines to the ngOnInit() so it listens for theme changes

            // Listen for changes from the theme service
            this.themeStateSubscription = this.themeService.getThemeStateAsObservable().subscribe( (aNewTheme: ThemeOptionDTO) => {
            // The theme has changed.
            this.currentTheme = aNewTheme;
            });



        f. Add the ngOnDestroy() method that will unsubscribe

              public ngOnDestroy(): void {
                if (this.themeStateSubscription) {
                this.themeStateSubscription.unsubscribe();
                }
              }

        g. Edit report-submit-markdown.component.html

        h. Change the <div> around the markdown editor
            
           From this:
                <div style="margin-left: 10px; margin-top: 5px">
            
           To this:
               <div style="margin-left: 10px; margin-top: 5px"
                        [ngClass]="{ 'light':  this.currentTheme.isLightMode == true,
                                              'dark':  this.currentTheme.isLightMode == false
                                    }">
            

        i. Edit report-submit-markdown.component.css

        j. Remove all CSS related to .ql-toolbar or .ql-container

        k. Edit styles.css

        l. Add this CSS:
                
                /**************** LIGHT MODE for Quill Markdown Editor CSS Customizations ****************/
                .light .ql-toolbar {
                  /* Permalink - use to edit and share this gradient:
                https://colorzilla.com/gradient-editor/#ffffff+20,ffffff+40,009ffd+100 */
                  background: #ffffff; /* Old browsers */
                  background: -moz-linear-gradient(-45deg,  #ffffff 20%, #ffffff 40%, #009ffd 100%); /* FF3.6-15 */
                  background: -webkit-linear-gradient(-45deg,  #ffffff 20%,#ffffff 40%,#009ffd 100%); /* Chrome10-25,Safari5.1-6 */
                  background: linear-gradient(135deg,  #ffffff 20%,#ffffff 40%,#009ffd 100%); /* W3C, IE10+, FF16+, Chrome26+, Opera12+, Safari7+ */
                  filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#ffffff', endColorstr='#009ffd',GradientType=1 ); /* IE6-9 fallback on horizontal gradient */
                
                  border: 1px solid #6294CF;
                }
                
                .light .ql-container {
                  border: 1px solid #6294CF;
                }
                
                
                /**************** DARK MODE for Quill Markdown Editor CSS Customizations ****************/
                .dark .ql-toolbar {
                  color: white;
                
                  /* Permalink - use to edit and share this gradient:
                https://colorzilla.com/gradient-editor/#ffffff+20,ffffff+40,009ffd+100 */
                  background: #303030; /* Old browsers */
                  background: -moz-linear-gradient(-45deg,  #303030 20%, #303030 40%, #111111 100%); /* FF3.6-15 */
                  background: -webkit-linear-gradient(-45deg,  #303030 20%,#303030 40%,#111111 100%); /* Chrome10-25,Safari5.1-6 */
                  background: linear-gradient(135deg,  #303030 20%,#303030 40%,#111111 100%); /* W3C, IE10+, FF16+, Chrome26+, Opera12+, Safari7+ */
                  filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#303030', endColorstr='#111111',GradientType=1 ); /* IE6-9 fallback on horizontal gradient */
                
                  border: 1px solid #6294CF;
                }
                
                .dark .ql-container {
                  border: 1px solid #6294CF;
                }
                
                .dark .ql-toolbar .ql-stroke {
                  stroke: #fff;
                  fill: none;
                }
                
                .dark .ql-toolbar .ql-fill {
                  fill: #fff;
                  stroke: none;
                }
                
                .dark  .ql-toolbar .ql-picker {
                  color: #fff;
                  fill: none;
                }
                
                .dark  .ql-toolbar .ql-picker-options {
                  color: #fff;
                  fill: none;
                }
                
                .dark .ql-toolbar .ql-picker-options .ql-picker-item {
                  color: #303030;
                  fill: white;
                }


        m. Verify that the markdown editor looks good in light mode and dark mode
           i.   Activate the Debugger on "Full WebApp"
           ii.  Click on "Report Submit Markdown"
           iii. Switch from Light Mode to Dark Mode
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson24a_image16.png)
```
Report Submit Markdown Page in Light Mode



```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson24a_image17.png)
```
Report Submit Markdown Page in Dark Mode





    15. Change the HighCharts charts so they look good in dark mode
        a. Edit dashboard.component.ts

        b. Make sure the DashboardComponent implements OnInit, OnDestroy

        c. Inject the themeService

        d. Add these 2 variables:
             private themeStateSubscription: Subscription;
             public currentTheme: ThemeOptionDTO;


        e. Add these lines to the ngOnInit() so it listens for theme changes

            // Listen for changes from the theme service
            this.themeStateSubscription = this.themeService.getThemeStateAsObservable().subscribe( (aNewTheme: ThemeOptionDTO) => {
            this.currentTheme = aNewTheme;
        
            this.reloadData()
            });



        f. Update the ngOnDestroy() method so that it will unsubscribe from themeStateSubscription

              public ngOnDestroy(): void {
            
                if (this.themeStateSubscription) {
                    this.themeStateSubscription.unsubscribe();
                }
              }

        g. Add this private variable with the dark-mode-theme
           Where did this darkTheme come from?
           -- This code was pulled from frontend/node_modules/highcharts/themes/dark-unica.src.js
           -- This code came from lines 49 to 241

                
                  private darkTheme: Options = {
                    colors: ['#2b908f', '#90ee7e', '#f45b5b', '#7798BF', '#aaeeee', '#ff0066',
                    '#eeaaee', '#55BF3B', '#DF5353', '#7798BF', '#aaeeee'],
                    chart: {
                    backgroundColor: {
                        linearGradient: { x1: 0, y1: 0, x2: 1, y2: 1 },
                        stops: [
                        [0, '#2a2a2b'],
                        [1, '#3e3e40']
                        ]
                    },
                    style: {
                        fontFamily: '\'Unica One\', sans-serif'
                    },
                    plotBorderColor: '#606063'
                    },
                    title: {
                    style: {
                        color: '#E0E0E3',
                        textTransform: 'uppercase',
                        fontSize: '20px'
                    }
                    },
                    subtitle: {
                    style: {
                        color: '#E0E0E3',
                        textTransform: 'uppercase'
                    }
                    },
                    xAxis: {
                    gridLineColor: '#707073',
                    labels: {
                        style: {
                        color: '#E0E0E3'
                        }
                    },
                    lineColor: '#707073',
                    minorGridLineColor: '#505053',
                    tickColor: '#707073',
                    title: {
                        style: {
                        color: '#A0A0A3'
                        }
                    }
                    },
                    yAxis: {
                    gridLineColor: '#707073',
                    labels: {
                        style: {
                        color: '#E0E0E3'
                        }
                    },
                    lineColor: '#707073',
                    minorGridLineColor: '#505053',
                    tickColor: '#707073',
                    tickWidth: 1,
                    title: {
                        style: {
                        color: '#A0A0A3'
                        }
                    }
                    },
                    tooltip: {
                    backgroundColor: 'rgba(0, 0, 0, 0.85)',
                    style: {
                        color: '#F0F0F0'
                    }
                    },
                    plotOptions: {
                    series: {
                        dataLabels: {
                        color: '#F0F0F3',
                        style: {
                            fontSize: '13px'
                        }
                        },
                        marker: {
                        lineColor: '#333'
                        }
                    },
                    boxplot: {
                        fillColor: '#505053'
                    },
                    candlestick: {
                        lineColor: 'white'
                    },
                    errorbar: {
                        color: 'white'
                    }
                    },
                    legend: {
                    backgroundColor: 'rgba(0, 0, 0, 0.5)',
                    itemStyle: {
                        color: '#E0E0E3'
                    },
                    itemHoverStyle: {
                        color: '#FFF'
                    },
                    itemHiddenStyle: {
                        color: '#606063'
                    },
                    title: {
                        style: {
                        color: '#C0C0C0'
                        }
                    }
                    },
                    credits: {
                    style: {
                        color: '#666'
                    }
                    },
                    drilldown: {
                    activeAxisLabelStyle: {
                        color: '#F0F0F3'
                    },
                    activeDataLabelStyle: {
                        color: '#F0F0F3'
                    }
                    },
                    navigation: {
                    buttonOptions: {
                        symbolStroke: '#DDDDDD',
                        theme: {
                        fill: '#505053'
                        }
                    }
                    },
                    // scroll charts
                    rangeSelector: {
                    buttonTheme: {
                        fill: '#505053',
                        stroke: '#000000',
                        style: {
                        color: '#CCC'
                        },
                        states: {
                        hover: {
                            fill: '#707073',
                            stroke: '#000000',
                            style: {
                            color: 'white'
                            }
                        },
                        select: {
                            fill: '#000003',
                            stroke: '#000000',
                            style: {
                            color: 'white'
                            }
                        }
                        }
                    },
                    inputBoxBorderColor: '#505053',
                    inputStyle: {
                        backgroundColor: '#333',
                        color: 'silver'
                    },
                    labelStyle: {
                        color: 'silver'
                    }
                    },
                    navigator: {
                    handles: {
                        backgroundColor: '#666',
                        borderColor: '#AAA'
                    },
                    outlineColor: '#CCC',
                    maskFill: 'rgba(255,255,255,0.1)',
                    series: {
                        color: '#7798BF',
                        lineColor: '#A6C7ED'
                    },
                    xAxis: {
                        gridLineColor: '#505053'
                    }
                    },
                    scrollbar: {
                    barBackgroundColor: '#808083',
                    barBorderColor: '#808083',
                    buttonArrowColor: '#CCC',
                    buttonBackgroundColor: '#606063',
                    buttonBorderColor: '#606063',
                    rifleColor: '#FFF',
                    trackBackgroundColor: '#404043',
                    trackBorderColor: '#404043'
                    }
                  };


        h. Replace reloadData() with this:
                
                public reloadData(): void {
                   this.dataIsLoading = true;
                
                   this.dashboardService.getAllChartData().subscribe( (aData: DashboardDataDTO) => {
                        // The REST call came back with data
                
                        if (this.currentTheme.isLightMode) {
                    // Render the charts in light mode
                
                    // Set the data for chart 1 and *render* chart 1
                    this.chartOptions1.series[0].data = aData.chartData1;
                    Highcharts.chart('chart1', this.chartOptions1);
                
                    this.chartOptions2.series = aData.chartData2;
                    Highcharts.chart('chart2', this.chartOptions2);
                
                    this.chartOptions3.series = aData.chartData3;
                    Highcharts.chart('chart3', this.chartOptions3);
                    }
                       else {
                    // Render the charts in dark mode
                
                    // Set the data for chart 1 and *render* chart 1
                    this.chartOptions1.series[0].data = aData.chartData1;
                    Highcharts.chart('chart1',  Highcharts.merge(this.chartOptions1, this.darkTheme));
                
                    this.chartOptions2.series = aData.chartData2;
                    Highcharts.chart('chart2',  Highcharts.merge(this.chartOptions2, this.darkTheme));
                
                    this.chartOptions3.series = aData.chartData3;
                    Highcharts.chart('chart3',  Highcharts.merge(this.chartOptions3, this.darkTheme));
                    }
                
                     }).add(  () => {
                    // REST call finally block
                
                     // Redraw all charts on this page (so they fit perfectly in the <mat-card> tags)
                     Highcharts.charts.forEach(function (chart: Chart | undefined) {
                        chart?.reflow();
                    });
                
                    this.dataIsLoading = false;
                    });
                
                }

        i. Verify that the charts look good
            i. Activate the Debugger on "Full WebApp"
            ii. Click on Analytics / Dashboard
            iii. Look at the dashboard page in light mode and dark mode
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson24a_image18.png)
```
Dashboard Page in Light Mode


```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson24a_image19.png)
```
Dashboard Page in Dark Mode



    16. Verify that the light mode/dark mode works when compiled from the command-line
        a. Stop the debugger

        b. Compile the webapp
           unix> cd ~/intellijProjects/angularApp1
           unix> mvn clean package -Pprod

        c. Run the webapp
           unix> java -jar ./backend/target/backend-1.0-SNAPSHOT-exec.jar

        d. Connect to the webapp at http://localhost:8080/app1

        e. Try light-mode and dark mode on different pages
           -- Verify that the Reports Grid View page		looks good in dark mode
           -- Verify that the Report Submit Markdown page 	looks good in dark mode
           -- Verify that the PDF Viewer page 			    looks good in dark mode
           -- Verify that the "Add Reports" page 		    looks good in dark mode
           -- Verify that the Dashboard -> Analytics page	looks good in dark mode 

```
