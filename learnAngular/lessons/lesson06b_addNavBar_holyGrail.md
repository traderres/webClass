Lesson 6b:  Add Navigation Bar 2 / Holy Grail Layout w/Angular Flex
-------------------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1dFS3un1LeuHGoDZki8fbEX6KGJ2IeSyyA0hTndd4qag/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson6b/navbar-holy-grail-layout
<br>
<br>



In this lesson, we will create a navigation bar that looks like this:

![](https://lh6.googleusercontent.com/wkQBLY6eETKSAyoJaPgafFFfzE09ecxJINY0Ix8xr4xbOAZpeStZPR1i2l7Hb6h98EVO1uD-N97cnF-zLjfIjsmPgzwZoV6UwUtdxe54sk8tCvCMEy3YOw4jjJeWiVBz64X2X7p_)

```

Notes
    • Clicking on the hamburger makes the left-side nav appear/disappear


Procedure
---------
    1. Install Flex Layout
        unix> cd ~/intellijProjects/angularApp1/frontend
        unix> npm install @angular/flex-layout@9.0.0-beta.31   @angular/cdk

        NOTES:
           a. The angular compiler fails when using flex-layout 10.0.0-beta.32
           b. The angular compiler succeeds when using flex-layout 9.0.0-beta.31
        
          To see a list of angular flex layout versions, use this url:
            https://github.com/angular/flex-layout/releases

        My guess is that....
        if you are using Angular 9, then use flex-layout 9
        if you are using Angular10, then use flex-layout 10

    2. Clear and Reload your node_modules cache from inside IntelliJ
        a. Delete the node_modules directory
            unix> cd ~/intellijProjects/angularApp1/frontend
            unix> rm -rf node_modules

        b. Within Intellij, single-click on frontend/package.json -> Right Click -> Run 'npm install'

        c. Wait for IntelliJ to finish the "Indexing..." operation
            NOTE:  This may take a few minutes

    3. Import the FlexLayoutModule module
        a. Go to the app.module.ts
        b. Add FlexLayoutModule to the app.module.ts
            
            import { FlexLayoutModule } from '@angular/flex-layout';
            
            imports: [
            
                FlexLayoutModule,
                    
                    ]

    4. Activate the debugger (to cause the webapp to be compiled and deployed locally)
        a. Wait for Angular to finish compiling the CDK modules (may take a minute or two)
        b. Connect to http://localhost:4200
        c. Make sure the existing navbar still works
        d. Stop the debugger


    5. Create a header, footer, and navbar components
        unix> cd ~/intellijProjects/angularApp1/frontend
        unix> ng generate component header 
        unix> ng generate component footer
        unix> ng generate component navbar

    6. Configure the app-navbar
        a. Edit navbar.component.html

        b. Replace its contents with this:
            <mat-sidenav-container autosize>
            
             <mat-sidenav style="width:220px" mode="side" opened="true"
                            [fixedInViewport]="true"  
                            [fixedTopGap]="100" 
                            [fixedBottomGap]="50">
            
                <mat-nav-list>
                  
                  <h3 mat-subheader>Reports</h3>
                  <a mat-list-item [routerLink]="'page/addReport'">Add Report</a>
                  <a mat-list-item [routerLink]="'page/viewReports'">View Reports</a>
                  
                  <mat-divider>&nbsp;</mat-divider>
            
                  <h3 mat-subheader>Analytics</h3>
                  <a mat-list-item [routerLink]="'page/totalLogins'">Total Logins</a>
            
               </mat-nav-list>
            
              </mat-sidenav>
            
            </mat-sidenav-container>


        c. Change  the navbar.component.css to this:
            
            .mat-list-item {
              font-family: Verdana, sans-serif;
              font-size: 13px;
            }
            
            .mat-subheader{
              font-family: Verdana, sans-serif;
              font-size: 16px;
              font-weight:bold;
              background-color: #f2f4f7;
              height:8px;
              margin-top:5px;
            }


    7. Change the app.component.html
        a. Edit app.component.html

        b. Replace its contents with this:
            
            <div fxFlexFill fxLayout="column">
              <div fxFlex="100px" style="border: 2px solid black;">
                <!-- Header -->
                <app-header></app-header>
              </div>
            
            
                <div fxFlex fxLayout="row" fxLayoutGap="10px">
                  <div fxFlex="225px" style="border: 1px solid blue; padding: 0">
                 <!-- Left Side Navigation -->
                 <app-navbar></app-navbar>
                  </div>
            
                  <div fxFlex style="border: 1px solid blue; padding: 0">
                 <!-- Main Viewing Area -->
                 <router-outlet></router-outlet>
                  </div>
                </div>
            
              <div fxFlex="50px" style="border:2px solid black;">
                <!-- Footer -->
                <app-footer></app-footer>
              </div>
            </div>


    8. Verify that the navbar appears on the left side
        a. Pull Run -> Debug 'Full WebApp'
        b. You should see version 1 of the Holy Grail Layout 

```
![](https://lh6.googleusercontent.com/_OQzYpTz7zEelovaypw6JXQbtN7ewsWlzxWowJwbEcRMu2A_BLmqvBeKIJZNg9blHqytsvYMeVNLENTse1380N26IOsxF5liekt_KwuOzETL033LPQVFp5TM-NInH0OTZxJ8r4yt)
```
Version 1: Holy Grail Layout is Established







    9. Add a button to the header that will hide/show the left navbar
        a. Create a navbar.service.ts
            unix> cd intellijProjects/angularApp1/frontend
            unix> ng generate service services/navbar


        b. Replace the navbar.service.ts with this:
            
            import { Injectable } from '@angular/core';
            import {Observable, Subject} from "rxjs";
            
            @Injectable({
              providedIn: 'root'
            })
            export class NavbarService {
            
              public isNavbarDisplayed = true;
              private showSideNavSubject = new Subject<boolean>();
            
              public constructor() { }
            
              public toggleNavbar(): void {
                this.isNavbarDisplayed = !this.isNavbarDisplayed;
            
                // Send a message to the navbar (to tell the navbar to show or hide)
                this.showSideNavSubject.next(this.isNavbarDisplayed);
              }
            
              public get(): Observable<boolean> {
                return this.showSideNavSubject.asObservable();
              }
            }
            



        c. Adjust the header.component.ts so that it injects the navbarService and has a toggle() function
            i. Edit header.component.ts

            ii. Replace its contents with this:
                
                import { Component, OnInit } from '@angular/core';
                import {NavbarService} from "../services/navbar.service";
                
                @Component({
                  selector: 'app-header',
                  templateUrl: './header.component.html',
                  styleUrls: ['./header.component.css']
                })
                export class HeaderComponent implements OnInit {
                
                  constructor(private navbarService: NavbarService)
                  {}
                
                  ngOnInit(): void {   }
                
                  public toggle(): void {
                    // Send a message to the navbarService (to tell it to toggle)
                    this.navbarService.toggleNavbar();
                  }
                }


        d. Add a button to the header.component.html
            Replace header.component.html with this:
            
            <button type="button" (click)="this.toggle()">
                <i class="fa fa-bars"></i>
            </button>



        e. Change the app.component.ts to listen on the navbarService
            
            import {Component, OnDestroy, OnInit} from '@angular/core';
            import {NavbarService} from "./services/navbar.service";
            import {Subscription} from "rxjs";
            
            @Component({
              selector: 'app-root',
              templateUrl: './app.component.html',
              styleUrls: ['./app.component.css']
            })
            export class AppComponent implements OnInit, OnDestroy {
              title = 'frontend';
            
              public  isSideNavVisible = true;	// The left nav starts out as visible
              private showSideNavSubscription: Subscription;
            
            
              constructor(private navbarService: NavbarService)
              { }
            
            
              public ngOnInit(): void {
                // This app-component will listen for messages from the navbarService
                this.showSideNavSubscription =
                     this.navbarService.get().subscribe(sideNav => {
                       // We received a message from the navbarService
                       // -- Someone has toggled the navbar.
            
                      // Switch the flag (which causes the navbar to show/hide
                      this.isSideNavVisible = sideNav;
                });
              }
            
              public ngOnDestroy() {
                this.showSideNavSubscription.unsubscribe();
              }
            }

        f. Add an *ngIf to the app.component.html (to show/hide the navbar div)
            i. Edit app.component.html
            ii. Replace its contents with this:  NOTE:  We added a <div fxFlexFill to it
            
            <div fxFlexFill fxLayout="column">
              <div fxFlex="100px" style="border: 2px solid black;">
                <!-- Header -->
                <app-header></app-header>
              </div>
            
              <div fxFlex fxLayout="row" fxLayoutGap="10px">
                <div fxFlex="225px" style="border: 1px solid blue; padding: 0"
                                           *ngIf="this.isSideNavVisible">
                  <!-- Left Side Navigation -->
                  <app-navbar></app-navbar>
                </div>
            
                <div fxFlex style="border: 1px solid blue; padding: 0">
                  <!-- Main Viewing Area -->
                  <router-outlet></router-outlet>
                </div>
              </div>
            
              <div fxFlex="50px" style="border:2px solid black;">
                <!-- Footer -->
                <app-footer></app-footer>
              </div>
            </div>
            


    10. Verify that the navbar appears on the left side
        a. Pull Run -> Debug 'Full WebApp'
        b. You should see version 2 of the Holy Grail Layout 
        c. Press the "Hamburger" button in the header:  It should make the left-bar appear/disappear


```
![](https://lh6.googleusercontent.com/e22DwocFnFgFLK4_CqKgJmxGoH-39lTvujlNJV2J0tyRyXUMvCUAE_sSEqR887-3YsEYP_s29y5rY-pvk0aRRA8s1acQPZfhDxe5l61hGloQC1sojhrum6gityLhp7eV4cLUpK2n)
```
Version 2:  Hamburger icon makes the left side nav appear/disappear





    11. Make the navbar look better
        a. Remove the borders from app.component.html
            
            <div fxFlexFill fxLayout="column">
              <div fxFlex="100px">
                <!-- Header -->
                <app-header></app-header>
              </div>
            
            
              <div fxFlex fxLayout="row" fxLayoutGap="10px">
                <div fxFlex="225px" style="padding: 0" *ngIf="this.isSideNavVisible">
                  <!-- Left Side Navigation -->
                  <app-navbar></app-navbar>
                </div>
            
                <div fxFlex>
                  <!-- Main Viewing Area -->
                  <router-outlet></router-outlet>
                </div>
              </div>
            
              <div fxFlex="50px">
                <!-- Footer -->
                <app-footer></app-footer>
              </div>
            </div>

        b. Add a background color to the *HEADER*
            i. Change the header.component.html so that it's a in a div with a class called "header"
                
                <div class="header">
                  <button type="button" (click)="toggle()">
                    <i class="fa fa-bars"></i>
                  </button>
                </div>

            ii. Change the header.component.css to this:
                .header {
                  background: #364150;
                  color: white;
                  height: 100%;
                }
                

        c. Add a background color to the *NAVBAR*
            i. Apply a class="navbar" to the <mat-sidenav> element in navbar.component.html:
                Update navbar.component.html with this:
                
                <mat-sidenav-container autosize>
                  <mat-sidenav class="navbar" style="width:200px"
                                       mode="side" opened="true"
                                       [fixedInViewport]="true"
                                       [fixedTopGap]="100" 
                                       [fixedBottomGap]="50">
                    <mat-nav-list>
                      <h3 mat-subheader>Reports</h3>
                      <a mat-list-item [routerLink]="'page/addReport'">Add Report</a>
                      <a mat-list-item [routerLink]="'page/viewReports'">View Reports</a>
                      <mat-divider>&nbsp;</mat-divider>
                
                      <h3 mat-subheader>Analytics</h3>
                      <a mat-list-item [routerLink]="'page/totalLogins'">Total Logins</a>
                    </mat-nav-list>
                  </mat-sidenav>
                </mat-sidenav-container>


            ii. Change the navbar.component.css to this:
                NOTE:  I removed the background color from the mat-subheader tag
                
                .navbar {
                  background: #364150;
                  color: white;
                }
                
                .mat-list-item {
                  font-family: Verdana, sans-serif;
                  font-size: 13px;
                  color: white
                }
                
                .mat-subheader{
                  font-family: Verdana, sans-serif;
                  font-size: 16px;
                  font-weight:bold;
                  height:8px;
                  margin-top:5px;
                }


        d. Remove the footer from the app.component.html
            i. Remove this from the app.component.html
                <div fxFlex="50px">
                     <!-- Footer -->
                    <app-footer></app-footer>
                 </div>



When finished, the app.component.html should look like this:
    
    <div fxFlexFill fxLayout="column">
          <div fxFlex="100px">
            <!-- Header -->
            <app-header></app-header>
          </div>
    
    
          <div fxFlex fxLayout="row" fxLayoutGap="10px">
            <div fxFlex="225px" style="padding: 0" *ngIf="this.isSideNavVisible">
                <!-- Left Side Navigation -->
                <app-navbar></app-navbar>
            </div>
    
            <div fxFlex>
                <!-- Main Viewing Area -->
                <router-outlet></router-outlet>
            </div>
          </div>
    </div>




            ii. Adjust the navbar so that it has no bottom gap
                Edit navbar.component.html
                    Change this property from the mat-sidenav:
                        [fixedBottomGap]="50"
                    To this:
                            [fixedBottomGap]="0"

            iii. Remove the footer component
                -- Delete the frontend/src/app/footer directory
                -- Remove the FooterComponent from the app.module.ts


    12. Verify that the navbar appears on the left side
        a. Pull Run -> Debug 'Full WebApp'
        b. You should see version 3 of the Holy Grail Layout 

```
![](https://lh3.googleusercontent.com/FR5Dfrqi3wDP-mkEzkYYbZFIDGitFzzMpej4OVy8NIQpA0Rrh5Lxflh9f06rwhzawNRyktB1ZOGKxz7Te249wap8nb-RO8f0Z41pKlPOO37_l_xYdAfI9ZmctxI1jv0fYs3uQVyJ)
```
Version 3:  Header and left-side navbar have some color.  Also, the footer has been removed.




    13. Change the header so it's only 75 pixels high
        a. Change the app.component.html
            Change this:
                <div fxFlex="100px">
                 <!-- Header -->
                 <app-header></app-header>
                </div>
            
            To this:
                <div fxFlex="75px">
                 <!-- Header -->
                 <app-header></app-header>
                </div>

        b. Change the navbar so it starts 75 pixels from the top (instead of 100)
            Edit the navbar.component.html
            Change the  <mat-sidenav> tag
            
            Change this:
               [fixedTopGap]="100"
            
            To this:
               [fixedTopGap]="75"	


    14. Run the debugger
        a. Pull Run -> Debug 'Full WebApp'
        b. You should see version 4 of the Holy Grail Layout 


```
![](https://lh6.googleusercontent.com/uo-TWrQJQICkHd86tsGzWJAugeixr1yy7dJ9mMfEcx_S-Tozez8kAYSr83GGNNmMiWkOErF1lz2kcTW_ejjn_up8RF27bgss6bnqUnW81F-KxJkukWmYhDbpljyqGM4vw-xoZDZr)
```
Version 4:  The header has been reduced from 100px to 75px high




    15. Create 3 columns in the header
        a. Change the header.component.html to this:
            
            <div class="header">
              <div fxFlex fxLayout="row" fxLayoutGap="0">
            
                <div fxFlex>
                  <!-- Left Side of the Header -->
                  <div fxFlex fxLayout="row" fxLayoutGap="0">
                   <div fxFlex="45px">
                     <!-- Navbar Toggle Button -->
                     <button type="button" (click)="toggle()">
                       <i class="fa fa-bars"></i>
                     </button>
                   </div>
            
                   <div fxFlex fxFlexAlign="start start">
                     <!-- Application Title -->
                     <h1 style="display: inline" class="app1Logo">Angular App1</h1>
                   </div>
                 </div>
                </div>
            
                <div fxFlex  fxLayoutAlign="center center" style="border: 1px solid blue">
                  <!-- Center Part of the Header -->
                  Center
                </div>
            
                <div fxFlex fxLayoutAlign="end end" style="border: 1px solid white">
                  <!-- Right Part of the Header -->
                  Right
                </div>
            
              </div>
            
            </div>


        b. Change the header.component.css to this:
            
            .header {
              background: #364150;
              color: white;
              height: 100%;
            }
            
            
            .app1Logo {
              color: #fff;
              padding: 3px 0 5px 5px;
              font-size: 1.7em;
              margin: 0;
              font-family: "Verdana", san-serif;
              text-decoration: none;
            }
            
            

    16. Run the debugger
        a. Pull Run -> Debug 'Full WebApp'
        b. You should see version 5 of the Holy Grail Layout 


```
![](https://lh6.googleusercontent.com/wkQBLY6eETKSAyoJaPgafFFfzE09ecxJINY0Ix8xr4xbOAZpeStZPR1i2l7Hb6h98EVO1uD-N97cnF-zLjfIjsmPgzwZoV6UwUtdxe54sk8tCvCMEy3YOw4jjJeWiVBz64X2X7p_)
```
Version 5:  Header is divided into 3 parts (left, center, and right sections)

 


```
