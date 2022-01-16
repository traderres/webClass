Lesson 6e:  Add Navigation Bar 2 / Left and Right Side Bars
-----------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1TXH5PFoTKe4f3A3vxnTK3jbjCZCsNBVlBZSKvXuf4hU/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson6e/left-and-right-animated-navbars
<br>
<br>






In this lesson, we will change the nav bar to look like this:

Left side nav-bar has application-specific features
![](https://lh4.googleusercontent.com/G3jSG3DfeOhHwH4JW7r7DcfPQbaFf_1ZkJ908N2BUT4jXaaNCy6KXZtA_s_QfWiMtcM4AS3j9tm_cb4C41F4dKpvlp8pV3i_Gk0z0gJtnT4hA0e37jgeZC9ZO366rBJZlWc0Xxg6)
<br>
<br>
<br>
Right-side nav bar has user-specific features -- e.g., My Account, My Profile features
![](https://lh5.googleusercontent.com/vusr9mh2RXaXDQ3_GgGw1U5_bWfCwaeIfEI7GiwG7NSOhfbq99yACmoXLjAGbyzY-50GpRZFI5NE1gyu0rpR9py8yTzSjSa4lm85Omvns54Gy475Eipvg5V2ORVih1UVLvIz75Pu)
<br>
<br>
<br>
Clicking on the "Sections" button or "Search Hourglass" icon makes the left-side nav animate in/out<br>
Clicking on the "John Smith" name makes the right-side nav animate in/out<br>
![](https://lh6.googleusercontent.com/N-ysbhvMpRPlJ8530zpuKi7ICt7rLd07Ns74WQEZ5wbwRV_LYLX6BhDlb0Vj7tIa3ENZ_muxLejO4LSneLuECghAgFXu71bSZ-DNGadoqgLn6x9nWFmPpGpRcmLSxom14-kgcuM9)
<br>
<br>
<br>
Placing the cursor over the icons in the header causes a border to grow [look closely at the "Sections"]<br>
![](https://lh6.googleusercontent.com/SxFbNU8Rm4AvdKtS4VHO6vAXwNNDYK0_m3rzGFrUXEkV3c6v-WCGGRDnZeOu6dyhAUt_pdd8EEwsIsGPYBXHT5N3kCzbfnqOEjPf4JFAGy3f7G8KNa1xfOIBT2bCQZ5tfdOwZgof)


```
Assumptions
    1.  Your navbar.component.ts looks like this:
            
            import { Component, OnInit } from '@angular/core';
            
            @Component({
              selector: 'app-navbar',
              templateUrl: './navbar.component.html',
              styleUrls: ['./navbar.component.css']
            })
            
            export class NavbarComponent implements OnInit {
              public reportsNavGroupClosed: boolean = false;
              public analyticsGroupClosed: boolean = true;
            
              constructor() { }
            
              ngOnInit(): void { }
            
              public toggleNavGroup(aNavGroupNumber: number) {
                if (aNavGroupNumber == 1) {
                   // User clicked on the Reports navgroup (so hide the other navgroup)
                   this.analyticsGroupClosed = true;
            
                   // Toggle the Reports navgroup (So, it switches from opened to close)
                   this.reportsNavGroupClosed = ! this.reportsNavGroupClosed;
                }
                else if (aNavGroupNumber == 2) {
                   // User clicked on the Analytics navgroup (so hide the other navgroups)
                   this.reportsNavGroupClosed = true;
            
                   // Toggle the Analytics navgroup
                   this.analyticsGroupClosed = ! this.analyticsGroupClosed;
                }
            
              }
            
            }


    2. Your navbar.component.html looks like this:
            
            <mat-sidenav-container autosize>
              <mat-sidenav class="navbar" style="width:200px" mode="side" opened="true" [fixedInViewport]="true" [fixedTopGap]="75" [fixedBottomGap]="0">
                <mat-nav-list style="margin-top: 0; padding-top: 0">
            
                  <!-- Menu Group 1 -->
                  <div class='navHeader clickable'  (click)="toggleNavGroup(1)">
                 <i class="fa fa-file-alt navHeaderIcon"></i>
                 <span class="navHeaderTitle">Reports</span>
                  </div>
            
                  <!-- Menu Group 1 Items -->
                  <div class='navGroup' [ngClass]="{'navGroupClosed': reportsNavGroupClosed == true}">
            
                 <!-- View Reports -->
                 <mat-list-item class="navItem" [routerLink]="'page/viewReports'" routerLinkActive="active">
                   <a title="View Reports">View Reports</a>
                   <div fxFlex fxLayoutAlign="end end">
                     <a [routerLink]="'page/viewReports'" target="_blank">
                       <i class="fas fa-external-link-alt navItemIcon" title="Open View Reports in a new window"></i>
                     </a>
                   </div>
                 </mat-list-item>
            
                 <!-- Add Report -->
                 <mat-list-item class="navItem" [routerLink]="'page/addReport'" routerLinkActive="active">
                   <a title="Add Report">Add Report</a>
                   <div fxFlex fxLayoutAlign="end end">
                     <a [routerLink]="'page/addReport'" target="_blank">
                       <i class="fas fa-external-link-alt navItemIcon" title="Open Add Report in a new window"></i>
                     </a>
                   </div>
                 </mat-list-item>
            
                 <!-- Audit History -->
                 <mat-list-item class="navItem" [routerLink]="'page/auditHistory'" routerLinkActive="active">
                   <a title="Audit History">Audit History</a>
                   <div fxFlex fxLayoutAlign="end end" >
                     <a [routerLink]="'page/auditHistory'" target="_blank">
                       <i class="fas fa-external-link-alt navItemIcon" title="Open Audit History in a new window"></i>
                     </a>
                   </div>
                 </mat-list-item>
                  </div>  <!-- End of navMenuGroup -->
            
                  <!-- Menu Group 2 -->
                  <div class='navHeader clickable'   (click)="toggleNavGroup(2)">
                 <i class="fa fa-file-alt navHeaderIcon"></i>
                 <span class="navHeaderTitle">Analytics</span>
                  </div>
            
                  <!-- Menu Group 2 Items -->
                  <div class='navGroup' [ngClass]="{'navGroupClosed': analyticsGroupClosed == true}">
            
                  <!-- Chart 1 -->
                 <mat-list-item class="navItem" [routerLink]="'page/chart1'" routerLinkActive="active">
                   <a title="Chart 1">Chart 1</a>
                   <div fxFlex fxLayoutAlign="end end">
                     <a [routerLink]="'page/chart1'" target="_blank">
                       <i class="fas fa-external-link-alt navItemIcon" title="Open Chart 1 in a new
            window"></i>
                     </a>
                   </div>
                 </mat-list-item>
            
                 <!-- Chart 2 -->
                 <mat-list-item class="navItem" [routerLink]="'page/chart2'" routerLinkActive="active">
                   <a title="Chart 2">Chart 2</a>
                   <div fxFlex fxLayoutAlign="end end">
                     <a [routerLink]="'page/chart2'" target="_blank">
                       <i class="fas fa-external-link-alt navItemIcon" title="Open Chart 2 in a new
            window"></i>
                     </a>
                   </div>
                 </mat-list-item>
            
                  </div>  <!-- End of Menu Group 2 Items -->
            
                </mat-nav-list>
              </mat-sidenav>
            </mat-sidenav-container>
            


    3. Your navbar.component.css looks like this:
            .navbar {
              background: #364150;
              color: white;
            }
            
            .mat-list-item {
              font-family: Verdana, sans-serif;
              font-size: 13px;
              color: white;
              height: 25px;
            }
            
            .mat-list-item.active{
              /* Set the color for the actively clicked navbar item */
              /* Active mat-list-item has a background gradient that goes to the right */
              color: #fff;
              background: linear-gradient(to right, #5e6b7b, rgba(94, 107, 123, 0));
              font-weight: bold;
            }
            
            .navHeader{
              /* The navHeader as a gradient that goes to the left */
              background: linear-gradient(to left, #5e6b7b, rgba(94, 107, 123, 0));
              font-family: Verdana, sans-serif;
              font-size: 16px;
              font-weight:bold;
              padding: 0;
              margin-top: 0;
              height: 44px;
              display: flex;
              align-items: center;
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
              background: linear-gradient(to right, #5e6b7b, rgba(94, 107, 123, 0));
              font-weight: bold;
            }
            
            .navItemIcon {
              /* By default, the navItemIcon is invisible (It's the same color as navbar background) */
              color: #364150
            }
            
            .navItem:hover .navItemIcon {
              /* When hovering over navItem change the color of the navItemIcon so it appears */
              color: #999
            }
            
            .navGroupClosed {
              display: none;
            }
            
            .clickable {
              cursor: pointer;
            }
            
            



Procedure
---------
    1. Update the browser tab to show the Application title
        a. Edit frontend/src/index.dev.html
            
            Change this:
                <title>Frontend</title>
            
            To this:
                <title>Angular App1</title> 

        b. Repeat for frontend/src/index.prod.html



    2. Change the header so it's only 60 pixels
        a. Edit app.component.html 

            Change the header div from this:
                <div fxFlex="75px">
                        <!-- Header is 75 pixels high -->
                        <app-header></app-header>
                </div>
            
            To this:
                <div fxFlex="60px">
                    <!-- Header is 60 pixels high -->
                    <app-header></app-header>
                </div> 

        
        When completed, the app.component.html will look like this:
        
        <div fxFlexFill fxLayout="column">
        
          <div fxFlex="60px">
            <!-- Header is 60 pixels high -->
            <app-header></app-header>
          </div>
        
          <div fxFlex fxLayout="row" fxLayoutGap="0px">
            <div fxFlex="200px" style="padding: 0" *ngIf="this.isSideNavVisible">
                <!-- Left Side Navigation -->
                <app-navbar></app-navbar>
            </div>
        
            <div fxFlex>
                <!-- Main Viewing Area -->
                <router-outlet></router-outlet>
            </div>
          </div>
        
        </div>
        




        b. When completed, the app.component.ts looks like this:
            
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
            
              public  isSideNavVisible = true;	   // The left nav starts out as visible
              private showSideNavSubscription: Subscription;
            
              constructor(private navbarService: NavbarService)
              { }
            
              public ngOnInit(): void {
                // This app-component listens for messages from the navbarService
                this.showSideNavSubscription =
                     this.navbarService.get().subscribe(sideNav => {
                    // We received a message from the navbarService
                    // -- Someone has toggled the navbar.
            
                    // Switch the flag (which causes the navbar to show/hide
                    this.isSideNavVisible = sideNav
                });
              }
            
              public ngOnDestroy() {
                this.showSideNavSubscription.unsubscribe();
              }
            }
            

        c. Edit navbar.component.html
            Change fixedTopGap="75" to fixedTopGap="60"

            
            When done, the tag should look like this:
                 <mat-sidenav class="navbar" style="width:200px" mode="side" 
                    opened="true" [fixedInViewport]="true" [fixedTopGap]="60" [fixedBottomGap]="0"> 
            
            

        d. When completed, the navbar.component.html looks like this:
            <mat-sidenav-container autosize>
              <mat-sidenav class="navbar" style="width:200px" mode="side" opened="true" [fixedInViewport]="true" [fixedTopGap]="60" [fixedBottomGap]="0">
                <mat-nav-list style="margin-top: 0; padding-top: 0">
            
                  <!-- Menu Group 1 -->
                  <div class='navHeader clickable'  (click)="toggleNavGroup(1)">
                 <i class="fa fa-file-alt navHeaderIcon"></i>
                 <span class="navHeaderTitle">Reports</span>
                  </div>
            
                  <!-- Menu Group 1 Items -->
                  <div class='navGroup' [ngClass]="{'navGroupClosed': reportsNavGroupClosed == true}">
            
                 <!-- View Reports -->
                 <mat-list-item class="navItem" [routerLink]="'page/viewReports'" routerLinkActive="active">
                   <a title="View Reports">View Reports</a>
                   <div fxFlex fxLayoutAlign="end end">
                     <a [routerLink]="'page/viewReports'" target="_blank">
                       <i class="fas fa-external-link-alt navItemIcon" title="Open View Reports in a new window"></i>
                     </a>
                   </div>
                 </mat-list-item>
            
                 <!-- Add Report -->
                 <mat-list-item class="navItem" [routerLink]="'page/addReport'" routerLinkActive="active">
                   <a title="Add Report">Add Report</a>
                   <div fxFlex fxLayoutAlign="end end">
                     <a [routerLink]="'page/addReport'" target="_blank">
                       <i class="fas fa-external-link-alt navItemIcon" title="Open Add Report in a new window"></i>
                     </a>
                   </div>
                 </mat-list-item>
            
                 <!-- Audit History -->
                 <mat-list-item class="navItem" [routerLink]="'page/auditHistory'" routerLinkActive="active">
                   <a title="Audit History">Audit History</a>
                   <div fxFlex fxLayoutAlign="end end" >
                     <a [routerLink]="'page/auditHistory'" target="_blank">
                       <i class="fas fa-external-link-alt navItemIcon" title="Open Audit History in a new window"></i>
                     </a>
                   </div>
                 </mat-list-item>
                  </div>  <!-- End of navMenuGroup -->
            
                  <!-- Menu Group 2 -->
                  <div class='navHeader clickable'   (click)="toggleNavGroup(2)">
                 <i class="fa fa-file-alt navHeaderIcon"></i>
                 <span class="navHeaderTitle">Analytics</span>
                  </div>
            
                  <!-- Menu Group 2 Items -->
                  <div class='navGroup' [ngClass]="{'navGroupClosed': analyticsGroupClosed == true}">
            
                  <!-- Chart 1 -->
                 <mat-list-item class="navItem" [routerLink]="'page/chart1'" routerLinkActive="active">
                   <a title="Chart 1">Chart 1</a>
                   <div fxFlex fxLayoutAlign="end end">
                     <a [routerLink]="'page/chart1'" target="_blank">
                       <i class="fas fa-external-link-alt navItemIcon" title="Open Chart 1 in a new window"></i>
                     </a>
                   </div>
                 </mat-list-item>
            
                 <!-- Chart 2 -->
                 <mat-list-item class="navItem" [routerLink]="'page/chart2'" routerLinkActive="active">
                   <a title="Chart 2">Chart 2</a>
                   <div fxFlex fxLayoutAlign="end end">
                     <a [routerLink]="'page/chart2'" target="_blank">
                       <i class="fas fa-external-link-alt navItemIcon" title="Open Chart 2 in a new window"></i>
                     </a>
                   </div>
                 </mat-list-item>
            
                  </div>  <!-- End of Menu Group 2 Items -->
            
                </mat-nav-list>
              </mat-sidenav>
            </mat-sidenav-container>

        e. Change the header background so it's near-black #111  (which is the same as #111111)
            Edit header.component.css
            Change the .header CSS class so the background is #111 and add the padding to it

                .header {
                  background: #111;
                  color: white;
                  height: 100%;
                  padding-left: 16px;
                  padding-right: 16px;
                }

        f. Move the title to the center part of the header 
            Edit header.component.html
            
            Move the Application Title to the center part of the header
            So, the Center Part of the Header looks like this:
            
            Change this:
                <div fxFlex  fxLayoutAlign="center center" style="border: 1px solid blue">
                    <!-- Center Part of the Header -->
                    Center
                </div>
            
            To this:
                <div fxFlex fxLayoutAlign="center center">
                    <!-- Center Part of the Header -->
                    <div fxFlex fxLayoutAlign="center center">
            
                            <!-- Application Title -->
                            <h1 style="display: inline" class="app1Logo">Angular App1</h1>
                    </div>
                </div>


        g. Add a [routerLink="'/'" to the title (so clicking on the title takes you to the default page)
            Change this:
                <!-- Application Title -->
                <h1 style="display: inline" class="app1Logo">Angular App1</h1>
            
            To this:
                <!-- Application Title -->
                <h1 class="app1Logo clickable" [routerLink]="'/'">Angular App1</h1>
            
            

        h. When finished, the header.component.html should look like this:
            
            <div class="header">
            
                <div fxFlex fxLayout="row" fxLayoutGap="0">
            
                        <!-- Left Side of the Header -->
                        <div fxFlex fxLayout="row" fxLayoutGap="0">
                        <div fxFlex="45px">
                            <!-- Navbar Toggle Button -->
                            <button type="button">
                                <i class="fa fa-bars"></i>
                            </button>
                        </div>
                    </div>
            
            
                        <!-- Center Part of the Header -->
                        <div fxFlex  fxLayoutAlign="center center">
                    
                        <!-- Application Title -->
                        <h1 class="app1Logo clickable" [routerLink]="'/'">
                            Angular App1
                        </h1>
                        </div>
            
                    <!-- Right Part of the Header -->
                        <div fxFlex fxLayoutAlign="end end"
                                                 style="border: 1px solid white">
                          Right
                        </div>
            
                </div>
            
            </div>
            


        i. Add a search hourglass to the left side of the header
            Edit header.component.html
            Update the left side of the header so it looks like this:
                
                <!-- Left Side of the Header -->
                <div fxFlex fxLayoutAlign="left center" fxLayout="row" fxLayoutGap="0">
                
                    <!-- Search Hourglass -->
                    <a class="button">
                            <i class="fa fa-search"></i>
                    </a>
                
                    <!-- Separator -->
                    &nbsp;&nbsp;&nbsp;&nbsp;
                
                    <!-- App Navbar -->
                    <a  class="button">
                            Sections
                            <i class="fa fa-bars"></i>
                    </a>
                </div>


        j. Add a "User Menu" and person icon to the right side of the header
            Edit header.component.html
            Update the Right Side of the Header so it looks like this:
                
                <!-- Right Side of the Header -->
                <div fxFlex fxLayoutAlign="end center">
                    <!-- fxLayoutAlign="end center" is right-aligned and centered vertically   -->
                
                    <!-- User Menu -->
                    <a class="button">
                        <span class="username">John.Smith</span>&nbsp;
                        <span class="fa fa-user"></span>
                    </a>
                </div>


        k. When completed header.component.html should look like this:
            <div class="header">
            
               <div fxFlex fxLayout="row" fxLayoutGap="0">
            
                    <!-- Left Side of the Header -->
                    <div fxFlex fxLayoutAlign="left center" fxLayout="row" fxLayoutGap="0">
            
                        <!-- Search Hourglass -->
                        <a class="button">
                            <i class="fa fa-search"></i>
                        </a>
            
                        <!-- Separator -->
                        &nbsp;&nbsp;&nbsp;&nbsp;
            
                        <!-- App Navbar -->
                        <a  class="button">
                            Sections
                            <i class="fa fa-bars"></i>
                        </a>
                    </div>
            
            
                    <!-- Center Part of the Header -->
                    <div fxFlex  fxLayoutAlign="center center">
                
                        <!-- Application Title -->
                        <h1 class="app1Logo clickable" [routerLink]="'/'">Angular App1</h1>
                    </div>
            
            
                    <!-- Right Side of the Header -->
                    <div fxFlex fxLayoutAlign="end center">
                        <!-- fxLayoutAlign="end center" is right-aligned and centered vertically -->
            
                        <!-- User Menu -->
                        <a class="button">
                            <span class="username">John.Smith</span>&nbsp;
                            <span class="fa fa-user"></span>
                        </a>
                    </div>
            
                </div>
            </div>


        l. Change the header icon buttons so they look pretty
            
            Edit header.component.css so that
            -- The header links are in a box
            -- The header links have a white border appear when hovered over
            -- Each button box has a margin-top: 11px
            -- Each button box has: background-color: #1f1f1f;


            Append these to header.component.css
                
                a.button {
                      background-color: #1f1f1f;
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
                  background-color: black;
                  color: white;
                  border-color: #f9f9f9;
                }


        m. When completed, the header.component.css looks like this:
            .header {
              background: #111;
              color: white;
              height: 100%;
              padding-left: 16px;
              padding-right: 16px;
            }
            
            .app1Logo {
              color: #fff;
              padding: 3px 0 5px 5px;
              font-size: 1.7em;
              margin: 0;
              font-family: "Verdana", san-serif;
              text-decoration: none;
            
              /* Outline of zero gets rid of the annoying box around the link */
              outline: 0;
            }
            
            a.button {
              background-color: #1f1f1f;
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
              background-color: black;
              color: white;
              border-color: #f9f9f9;
            }


    3. Change the header.component.html and header.component.ts to call toggleAppNavBar() and toggleUserNavbar()
        a. Edit header.component.ts
            i. Rename toggle() to toggleAppNavbar()

            ii. Add a new method in the header.component.ts called toggleUserNavbar()
                
                public toggleUserNavbar(): void {
                    this.navbarService.toggleUserNavbar();
                }


        b. When finished, header.component.ts looks like this:
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
            
              ngOnInit(): void {
              }
            
              public toggleAppNavbar(): void {
                // Send a message to the navbarService (to tell it to toggle)
                this.navbarService.toggleAppNavbar();
              }
            
              public toggleUserNavbar(): void {
                this.navbarService.toggleUserNavbar();
              }
            }


        c. Edit header.component.html
            i.  Add (click)="toggleAppNavbar()" to the search hourglass and Sections  [see bold below]
            ii. Add (click)="toggleUserNavbar()" to the User Menu area  [see bold below]

            
            When finished, header.component.html looks like this:
            <div class="header">
            
                <div fxFlex fxLayout="row" fxLayoutGap="0">
            
                        <!-- Left Side of the Header -->
                    <div fxFlex fxLayoutAlign="left center" fxLayout="row" fxLayoutGap="0">
            
                        <!-- Search Hourglass -->
                        <a class="button" (click)="toggleAppNavbar()">
                            <i class="fa fa-search"></i>
                        </a>
            
                        <!-- Separator -->
                        &nbsp;&nbsp;&nbsp;&nbsp;
            
                        <!-- App Navbar -->
                        <a  class="button" (click)="toggleAppNavbar()">
                            Sections
                            <i class="fa fa-bars"></i>
                        </a>
                        </div>
            
            
                        <!-- Center Part of the Header -->
                        <div fxFlex  fxLayoutAlign="center center">
                        
                        <!-- Application Title -->
                        <h1 class="app1Logo clickable" [routerLink]="'/'">
                            Angular App1
                        </h1>
                        </div>
            
                        <!-- Right Side of the Header -->
                        <div fxFlex fxLayoutAlign="end center">
                        
                        <!-- User Menu -->
                        <a class="button" (click)="toggleUserNavbar()">
                            <span class="username">John.Smith</span>&nbsp;
                            <span class="fa fa-user"></span>
                        </a>
                        </div>
            
                </div>
            </div>
            

    4. Change the navbar.service.ts so that it holds 2 boolean properties
       -- One is for the app-navbar (on the left)
       -- One is for the user-navbar (on the right)
        a. Edit navbar.service.ts

        b. Add this class to the top (after the import statements but before the @Injectable):
            
            class NavbarState {
              isAppNavbarDisplayed: boolean;
              isUserNavbarDisplayed: boolean;
            } 
            
            [see next page for what the file will look like]

        c. When completed, navbar.service.ts looks like this:
                
                import {Injectable} from '@angular/core';
                import {Observable, Subject} from "rxjs";
                
                class NavbarState {
                  isAppNavbarDisplayed: boolean;
                  isUserNavbarDisplayed: boolean;
                }
                
                @Injectable({
                  providedIn: 'root'
                })
                export class NavbarService  {
                
                  private navbarStateSubject = new Subject<NavbarState>();
                  private navbarState: NavbarState = new NavbarState();
                
                
                  public constructor() {
                    // Initialize the navbarState
                
                    // The AppNavBar will be visible on startup
                    this.navbarState.isAppNavbarDisplayed = true;
                
                    // The UserNavBar will not be visible on startup
                    this.navbarState.isUserNavbarDisplayed = false;
                  }
                
                
                  public getNavbarStateAsObservable(): Observable<NavbarState> {
                    return this.navbarStateSubject.asObservable();
                  }
                
                  public toggleUserNavbar(): void {
                    this.navbarState.isUserNavbarDisplayed = !this.navbarState.isUserNavbarDisplayed;
                
                    // Send a message to the app-component (to tell it to show/hide navbars)
                    this.navbarStateSubject.next(this.navbarState);
                  }
                
                
                 public toggleAppNavbar(): void {
                    this.navbarState.isAppNavbarDisplayed = !this.navbarState.isAppNavbarDisplayed;
                
                    // Send a message to the app-component (to tell it to show/hide navbars)
                    this.navbarStateSubject.next(this.navbarState);
                  }
                }

    5. Add the User Navbar (for the right side)
        a. Create the userNavbar component
            unix> cd ~/intellijProjects/angularApp1/frontend
            unix> ng generate component userNavbar

        b. Replace the user-navbar.component.html with this:
            
            <mat-sidenav-container autosize>
              <mat-sidenav class="navbar" style="width:200px; margin-top: 60px" mode="side"
            opened="true"
                        [fixedInViewport]="true" [fixedTopGap]="0" [fixedBottomGap]="0">
                <mat-nav-list style="margin-top: 0; padding-top: 0">
            
                 <!-- View Reports -->
                 <mat-list-item class="navItem" [routerLink]="'page/viewReports'"
            routerLinkActive="active">
                   <a title="View Reports">View Reports</a>
                   <div fxFlex fxLayoutAlign="end end">
                     <a [routerLink]="'page/viewReports'" target="_blank">
                       <i class="fas fa-external-link-alt navItemIcon" title="Open View Reports in a
            new window"></i>
                     </a>
                   </div>
                 </mat-list-item>
            
                 <!-- Add Report -->
                 <mat-list-item class="navItem" [routerLink]="'page/addReport'"
            routerLinkActive="active">
                   <a title="Add Report">Add Report</a>
                   <div fxFlex fxLayoutAlign="end end">
                     <a [routerLink]="'page/addReport'" target="_blank">
                       <i class="fas fa-external-link-alt navItemIcon" title="Open Add Report in a new
            window"></i>
                     </a>
                   </div>
                 </mat-list-item>
            
                </mat-nav-list>
              </mat-sidenav>
            </mat-sidenav-container>


        c. Replace the user-navbar.component.css with this:
            
            .navbar {
              background: #364150;
              color: white;
            }
            
            .mat-list-item {
              font-family: Verdana, sans-serif;
              font-size: 13px;
              color: white;
              height: 25px;
            }
            
            .mat-list-item.active{
              /* Set the color for the actively clicked navbar item */
              /* Active mat-list-item has a background gradient that goes to the right */
              color: #fff;
              background: linear-gradient(to right, #5e6b7b, rgba(94, 107, 123, 0));
              font-weight: bold;
            }
            
            
            .navHeader{
              /* The navHeader as a gradient that goes to the left */
              background: linear-gradient(to left, #5e6b7b, rgba(94, 107, 123, 0));
              font-family: Verdana, sans-serif;
              font-size: 16px;
              font-weight:bold;
              padding: 0;
              margin-top: 0;
              height: 44px;
              display: flex;
              align-items: center;
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
              background: linear-gradient(to right, #5e6b7b, rgba(94, 107, 123, 0));
              font-weight: bold;
            }
            
            .navItemIcon {
              /* By default, the navItemIcon is invisible (It's the same color as the navbar background) */
              color: #364150
            }
            
            .navItem:hover .navItemIcon {
              /* When hovering over navItem change the color of the navItemIcon so it appears */
              color: #999
            }


    6. Change the app.component.ts to listen for the navbar properties
        a. Edit app.component.ts

        b. Rename isSideNavVisible to isAppNavVisible 

        c. Rename showSideNavSubscription to showAppNavSubscription

        d. Add a 2nd public boolean:
             public isUserNavVisible = false; // The right nav starts out as not visible

        e. Change the ngOnInit() so that it subscribes to the observable and returns a NavbarState object
           NOTE: This NavbarState object holds 2 booleans
                
                public ngOnInit(): void {
                
                    // This app-component will listen for messages from the navbarService
                    this.showNavSubscription =
                         this.navbarService.getNavbarStateAsObservable()
                            .subscribe((navbarState) => {
                
                           // We received a message from the navbarService
                           // -- Someone has toggled the one of the navbars
                
                           // Set the public properties based on properties returned
                           this.isAppNavVisible = navbarState.isAppNavbarDisplayed;
                           this.isUserNavVisible = navbarState.isUserNavbarDisplayed;
                
                           });
                }


        f. When finished, app.component.ts looks like this:
            import {Component, OnDestroy, OnInit} from '@angular/core';
            import {Subscription} from "rxjs";
            import {NavbarService} from "./services/navbar.service";
            
            @Component({
              selector: 'app-root',
              templateUrl: './app.component.html',
              styleUrls: ['./app.component.css']
            })
            export class AppComponent implements OnInit, OnDestroy {
              title = 'AngularApp1';
            
              public isAppNavVisible = true;   	// The left nav starts out as visible
              public isUserNavVisible = false;	// The right nav starts out as not visible
            
              private showNavSubscription: Subscription;
            
              constructor(private navbarService: NavbarService)
              { }
            
            
              public ngOnInit(): void {
            
                // This app-component will listen for messages from the navbarService
                this.showNavSubscription =
            this.navbarService.getNavbarStateAsObservable().subscribe((navbarState) => {
                  // We received a message from the navbarService
                  // -- Someone has toggled the one of the navbars
            
                  // Set the public properties based on the navbarState properties returned
                  this.isAppNavVisible = navbarState.isAppNavbarDisplayed;
                  this.isUserNavVisible = navbarState.isUserNavbarDisplayed;
                });
              }
            
            
              public ngOnDestroy() {
                this.showNavSubscription.unsubscribe();
              }
            
            }


    7. Add the right-side navbar to the app.component.html 
        a. Edit the app.component.html

        b. Add the right-side navigation
            <div fxFlex="200px" style="padding: 0" *ngIf="this.isUserNavVisible">
                <!-- Right Side Navigation -->
                <app-user-navbar></app-user-navbar>
            </div>

        c. When finished, app.component.html looks like this:
            <div fxFlexFill fxLayout="column">
            
                  <div fxFlex="60px">
                    <!-- Header is 60 pixels high -->
                    <app-header></app-header>
                  </div>
            
            
                  <div fxFlex fxLayout="row" fxLayoutGap="0px">
                    <div fxFlex="200px" style="padding: 0"
                               *ngIf="this.isAppNavVisible">
            
                        <!-- Left Side Navigation -->
                        <app-navbar></app-navbar>
                    </div>
            
            
                    <div fxFlex>
                        <!-- Main Viewing Area -->
                        <router-outlet></router-outlet>
                    </div>
            
            
                    <div fxFlex="200px" style="padding: 0"
                         *ngIf="this.isUserNavVisible">
            
                        <!-- Right Side Navigation -->
                        <app-user-navbar></app-user-navbar>
                    </div>
                  </div>
            
            </div>



    8. Move the .clickable .css class from navbar.component.css to styles.css
        a. Edit styles.css and add this
            
            .clickable {
              cursor: pointer;
            }

        b. Remove this clickable class from navbar.component.css


    9. Change the navbar.service.ts so that only *one* navbar appears at a time
        a. Edit navbar.service.ts
        b. Change the toggleAppNavbar() method by adding this if statement
            
             public toggleAppNavbar(): void {
                this.navbarState.isAppNavbarDisplayed = !this.navbarState.isAppNavbarDisplayed;
            
                if ((this.navbarState.isUserNavbarDisplayed) && (this.navbarState.isAppNavbarDisplayed)) {
                  // The user is showing the App Navbar and the User Navbar is presently visible
            
                  // So, hide the User Navbar (so that only *ONE* navbar is visible at a time)
                  this.navbarState.isUserNavbarDisplayed = false;
                }
            
                // Send a message to the user-navbar (to tell the navbar to show or hide)
                this.navbarStateSubject.next(this.navbarState);
              }

        c. Change the toggleUserNavbar() method by adding this if statement
            public toggleUserNavbar(): void {
                this.navbarState.isUserNavbarDisplayed = !this.navbarState.isUserNavbarDisplayed;
            
                if ((this.navbarState.isUserNavbarDisplayed) && (this.navbarState.isAppNavbarDisplayed)) {
                  // The user is showing the User Navbar and the App Navbar is presently visible
            
                  // So, hide the App Navbar (so that only *ONE* navbar is visible at a time)
                  this.navbarState.isAppNavbarDisplayed = false;
                }
            
                // Send a message to the user-navbar (to tell the navbar to show or hide)
                this.navbarStateSubject.next(this.navbarState);
              }


        d. When completed, the navbar.services.ts looks like this:
            import {Injectable} from '@angular/core';
            import {Observable, Subject} from "rxjs";
            
            class NavbarState {
              isAppNavbarDisplayed: boolean;
              isUserNavbarDisplayed: boolean;
            }
            
            @Injectable({
              providedIn: 'root'
            })
            export class NavbarService  {
            
              private navbarStateSubject = new Subject<NavbarState>();
              private navbarState: NavbarState = new NavbarState();
            
              public constructor() {
                // Initialize the navbarState
            
                // The AppNavBar will be visible on startup
                this.navbarState.isAppNavbarDisplayed = true;
            
                // The UserNavBar will not be visible on startup
                this.navbarState.isUserNavbarDisplayed = false;
              }
            
            
              public getNavbarStateAsObservable(): Observable<NavbarState> {
                return this.navbarStateSubject.asObservable();
              }
            
            
             public toggleUserNavbar(): void {
                this.navbarState.isUserNavbarDisplayed = !this.navbarState.isUserNavbarDisplayed;
            
                if ((this.navbarState.isUserNavbarDisplayed) && (this.navbarState.isAppNavbarDisplayed)) {
                  // The user is showing the User Navbar and the App Navbar is presently visible
            
                  // So, hide the App Navbar (so that only *ONE* navbar is visible at a time)
                  this.navbarState.isAppNavbarDisplayed = false;
                }
            
                // Send a message to the app-component (to tell it to show/hide navbars)
                this.navbarStateSubject.next(this.navbarState);
              }
            
              public toggleAppNavbar(): void {
                this.navbarState.isAppNavbarDisplayed = !this.navbarState.isAppNavbarDisplayed;
            
                if ((this.navbarState.isUserNavbarDisplayed) && (this.navbarState.isAppNavbarDisplayed)) {
                  // The user is showing the App Navbar and the User Navbar is presently visible
            
                  // So, hide the User Navbar (so that only *ONE* navbar is visible at a time)
                  this.navbarState.isUserNavbarDisplayed = false;
                }
            
                // Send a message to the app-component (to tell it to show/hide navbars)
                this.navbarStateSubject.next(this.navbarState);
              }
            }
            

    10. Make the header fixed. 
        -- We want the header to not move if a user scrolls down or if there is not enough vertical space in the browser window
        -- The fix is to add style="overflow: auto" to the row beneath the header

        The overflow CSS property has 4 states:
        overflow: visible | hidden | scroll | auto
        NOTE:  overflow only works on a a block level element that has a defined height
        
        visible: Default.  If the content overflows, we will still be able to see it:
        hidden:  Content is clipped and the overflow is hidden:
        scroll:  Show scrollbars all of the time
        auto:	Show scrollbars when needed


        a. Edit app.component.html

        b. Change the content window from this:
                <div fxFlex fxLayout="row" fxLayoutGap="0px">
           To this:
                <div fxFlex fxLayout="row" fxLayoutGap="0px" style="overflow: auto">
        

        c. When finished, app.component.html looks like this:
                
                <div fxFlexFill fxLayout="column">
                
                    <div fxFlex="60px">
                            <!-- Header is 60 pixels high -->
                            <app-header></app-header>
                    </div>
                
                
                    <!-- Use overflow: auto so that the header is fixed and the content window gets the scrollbars (when needed) -->
                    <div fxFlex fxLayout="row" fxLayoutGap="0px" style="overflow: auto">
                            <!-- This Div holds the Content Window -->
                
                            <div fxFlex="200px" style="padding: 0"
                                               *ngIf="this.isAppNavVisible">
                            <!-- Left Side Navigation -->
                            <app-navbar></app-navbar>
                            </div>
                
                
                            <div fxFlex>
                            <!-- Main Viewing Area -->
                            <router-outlet></router-outlet>
                            </div>
                
                
                            <div fxFlex="200px" style="padding: 0"
                                     *ngIf="this.isUserNavVisible">
                            <!-- Right Side Navigation -->
                            <app-user-navbar></app-user-navbar>
                            </div>
                  </div>
                
                </div>



    11. Try it out
        a. Activate the debugger -> Full WebApp
        b. Press the "Hamburger" icon and the "John Smith" buttons
           -- The left and right-side navbars should appear/disappear
```
![](https://lh3.googleusercontent.com/OEsmWEodG6lTgZXkrs9N8p0D3l8MDo7AnDwQm0q4SNC4QDpnJ-VB_8ZC0rlOmFjZGcD3ZZ7doxCUVvdl7Ph5qKp08IBpZvHx2iTSAe6UmBmmkHGffaZUtnKkqLlNIrD8R9UIDNUz)
```




    12. Add animation to the navigation bars by moving the <mat-sidenav-container> to app.component.html
        NOTES
        1) Use mat-sidenav with mode="side" so that the sidenav appears side-by-side with the main content, shrinking the main content's width to make space for the sidenav.
        2) Use style="overflow: auto" to ensure that the scrollbar only appears in the content window (and not the header)
        3) Use [opened]= to control opening/closing of the sidenavs
        4) Use position="start" for the left sidenav and positoin="end" for the right sidenav

        a. Change app.component.html to this:
            
            <div fxFlexFill fxLayout="column">
            
              <div fxFlex="60px">
                <!-- Header is 60 pixels high -->
                <app-header></app-header>
              </div>
            
            
              <!-- The overflow: auto ensures that the scrollbars
                   appear only in the content window if needed -->
              <div fxFlex fxLayout="row" fxLayoutGap="0px" style="overflow: auto">
            
                <!-- The sidenav container must have fxFlexFill to use 
                     the entire width -->
                  <mat-sidenav-container fxFlexFill hasBackdrop="false" >
            
                    <mat-sidenav position="start" mode="side"
            [opened]="this.isAppNavVisible">
                        <!-- Left Side Navigation -->
                        <app-navbar></app-navbar>
                    </mat-sidenav>
            
            
                    <div>
                        <!-- Main Viewing Area -->
                        <router-outlet></router-outlet>
                    </div>
            
            
                    <mat-sidenav position="end" mode="side"
            [opened]="this.isUserNavVisible">
                        <!-- Right Side Navigation -->
                        <app-user-navbar></app-user-navbar>
                    </mat-sidenav>
            
                  </mat-sidenav-container>
              </div>
            
            </div>


        b. Edit navbar.component.html
            i. Remove <mat-sidenav> and <mat-sidenav-container> tags from the navbar.component.html
            ii. Add a surrounding div to the top and closing </div> at the bottom:
                   <div class="navbar" style="width:200px">
                   ...
                   </div>


        c. When finished, navbar.component.html looks like this:
                
                <div class="navbar" style="width:200px">
                  <mat-nav-list style="margin-top: 0; padding-top: 0">
                
                    <!-- Menu Group 1 -->
                    <div class='navHeader clickable'  (click)="toggleNavGroup(1)">
                      <i class="fa fa-file-alt navHeaderIcon"></i>
                      <span class="navHeaderTitle">Reports</span>
                    </div>
                
                    <!-- Menu Group 1 Items -->
                    <div class='navGroup' [ngClass]="{'navGroupClosed': reportsNavGroupClosed == true}">
                
                      <!-- View Reports -->
                      <mat-list-item class="navItem" [routerLink]="'page/viewReports'" routerLinkActive="active">
                     <a title="View Reports">View Reports</a>
                     <div fxFlex fxLayoutAlign="end end">
                       <a [routerLink]="'page/viewReports'" target="_blank">
                         <i class="fas fa-external-link-alt navItemIcon" title="Open View Reports in a new
                window"></i>
                       </a>
                     </div>
                      </mat-list-item>
                
                      <!-- Add Report -->
                      <mat-list-item class="navItem" [routerLink]="'page/addReport'" routerLinkActive="active">
                     <a title="Add Report">Add Report</a>
                     <div fxFlex fxLayoutAlign="end end">
                       <a [routerLink]="'page/addReport'" target="_blank">
                         <i class="fas fa-external-link-alt navItemIcon" title="Open Add Report in a new
                window"></i>
                       </a>
                     </div>
                      </mat-list-item>
                
                      <!-- Audit History -->
                      <mat-list-item class="navItem" [routerLink]="'page/auditHistory'" routerLinkActive="active">
                     <a title="Audit History">Audit History</a>
                     <div fxFlex fxLayoutAlign="end end" >
                       <a [routerLink]="'page/auditHistory'" target="_blank">
                         <i class="fas fa-external-link-alt navItemIcon" title="Open Audit History in a new
                window"></i>
                       </a>
                     </div>
                      </mat-list-item>
                    </div>  <!-- End of navMenuGroup -->
                
                    <!-- Menu Group 2 -->
                    <div class='navHeader clickable'   (click)="toggleNavGroup(2)">
                      <i class="fa fa-file-alt navHeaderIcon"></i>
                      <span class="navHeaderTitle">Analytics</span>
                    </div>
                
                    <!-- Menu Group 2 Items -->
                    <div class='navGroup' [ngClass]="{'navGroupClosed': analyticsGroupClosed == true}">
                
                    <!-- Chart 1 -->
                      <mat-list-item class="navItem" [routerLink]="'page/chart1'" routerLinkActive="active">
                     <a title="Chart 1">Chart 1</a>
                     <div fxFlex fxLayoutAlign="end end">
                       <a [routerLink]="'page/chart1'" target="_blank">
                         <i class="fas fa-external-link-alt navItemIcon" title="Open Chart 1 in a new
                 window"></i>
                       </a>
                     </div>
                      </mat-list-item>
                
                      <!-- Chart 2 -->
                      <mat-list-item class="navItem" [routerLink]="'page/chart2'" routerLinkActive="active">
                     <a title="Chart 2">Chart 2</a>
                     <div fxFlex fxLayoutAlign="end end">
                       <a [routerLink]="'page/chart2'" target="_blank">
                         <i class="fas fa-external-link-alt navItemIcon" title="Open Chart 2 in a new
                window"></i>
                       </a>
                     </div>
                      </mat-list-item>
                
                    </div>  <!-- End of Menu Group 2 Items -->
                
                  </mat-nav-list>
                </div>    



        d. Edit user-navbar.component.html
            i. Remove <mat-sidenav> and </mat-sidenav> tags from the user-navbar.component.html
            ii. Insert a surrounding div at the top:
                   <div class="navbar">
                
                   </div>

        e. When finished, user-navbar.component.html looks like this:
            
            <div class="navbar">
              <mat-nav-list style="margin-top: 0; padding-top: 0">
            
                <!-- View Reports -->
                <mat-list-item class="navItem" [routerLink]="'page/viewReports'" routerLinkActive="active">
                  <a title="View Reports">View Reports</a>
                  <div fxFlex fxLayoutAlign="end end">
                 <a [routerLink]="'page/viewReports'" target="_blank">
                   <i class="fas fa-external-link-alt navItemIcon" title="Open View Reports in a new
            window"></i>
                 </a>
                  </div>
                </mat-list-item>
            
                <!-- Add Report -->
                <mat-list-item class="navItem" [routerLink]="'page/addReport'" routerLinkActive="active">
                  <a title="Add Report">Add Report</a>
                  <div fxFlex fxLayoutAlign="end end">
                 <a [routerLink]="'page/addReport'" target="_blank">
                   <i class="fas fa-external-link-alt navItemIcon" title="Open Add Report in a new
            window"></i>
                 </a>
                  </div>
                </mat-list-item>
            
              </mat-nav-list>
            </div>    
            

        f. Change the "navbar" css class in user-navbar.component.css so that it has overflow: hidden
            .navbar {
              background: #364150;
              color: white;
              height: 100%;
              overflow: hidden;
            }

        g. Change the "navbar" css class in navbar.component.css so that it has overflow: hidden
           NOTE:  This ensures that scrollbars do *not* appear in the navbar
                .navbar {
                  background: #364150;
                  color: white;
                  height: 100%;
                  overflow: hidden;
                }


    13. Try it out
        a. Activate the debugger using "Full WebApp"
        b. Verify that opening the left navbar closes the right navbar
        c. Verify that opening the right navbar closes the left navbar
        d. Verify that the navbar open/close using animation
```
![](https://lh5.googleusercontent.com/fWKV5NwrEYsE3ax_bLUdOc2k0yjggtk3lAZIHtx_Vdc4rVA-E-DJumL1FL5aHiWJKpC-DuTKSDkGhuI1LoIffD2_MMWOrsJokJk8ZXHYZz7DmbsdYP3YQ8EHm7C0J1qHu64sppC_)
```


OPTIONAL:  If you want to disable the mat-sidenav animations
    • Approach 1:  Add [@.disabled]="true" to the <mat-sidenav> tags
        
        Edit app.component.html
        Change this:
            <mat-sidenav position="start" mode="side" [opened]="this.isAppNavVisible"> 
        To this:
            <mat-sidenav [@.disabled]="true" position="start" mode="side" [opened]="this.isAppNavVisible"> 
        
        **OR**

    • Approach 2:  Add a @HostBinding directive in your TypeScript code
        Edit app.component.ts
        Add this line of code above the constructor
           @HostBinding('@.disabled') disabled = true;


```
