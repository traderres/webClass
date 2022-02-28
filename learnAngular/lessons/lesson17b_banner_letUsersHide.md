Lesson 17b:  Add Banner / Let Users Hide It
-------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1nAFRb6JJ2ZqEAlANpMotTpEiqbcoC9UHEdGM4QEh4M4/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson17b/hide-banner
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem:  I really hate banners (as they take precious vertical space)<br>

- The client says you have to have a banner (but says nothing about hiding it)
- So, let's add a "Hide" button

<br>
<br>

![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson17b_image1.png)

<br>

![](https://lh4.googleusercontent.com/K5Nf-SC7IG5dfoazLPjk_ef_eO1yBwKUObTSRfumtLBHYAIQqMPj-OFYruxnXH9Ye5yiK1r3hH3Vrr3U2Ech0l7PqVq0JShyDf1z2TPP_XEmLBeUWtHk4mT_lT4maC6i8emwsHbF) <br>
We will add a "Hide" hyperlink that lets users hide the banner
<br>
<br>

<h3>Approach</h3>

1. Move the banner html to its own component

   1. Create a new component called banner  

   1. Copy the HTML for the banner to banner.component.html  
      NOTE: Replace fxFlex="50px" with fxFlex  
      LESSON: We want heights set in app.component.html (not in banner.component.html)  

   1. Change app.component.html to use a banner  
      NOTE: banner should be set to be 50px tall  
      ```
      <app-banner fxFlex="50px">
      
      <div fxFlex="50px">
         <app-banner></app-banner>
      </div>
      ```

   1. Verify that the banner appears  

1. Add a Banner Service w/BehaviorSubject  

1. Change the Banner Component so it can send messages (to show/hide banner)  

1. Change the App.Component so it will listen for message (to show/hide banner)

![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson17b_image2.png)

<br>
<br>

```
Procedure
---------
    1. Create the banner component
        a. Create a new component called banner
	
        b. Copy the HTML for the banner to banner.component.html
           NOTE:  Replace fxFlex="50px" with fxFlex 
               LESSON:  We want heights set in app.component.html (not in banner.component.html)
             
        c. Change app.component.html to use a banner
           NOTE:  banner should be set to be 50px tall

                <app-banner fxFlex="50px">
                
                
                *OR*
                
                
                <div fxFlex="50px">
                   <app-banner fxFlex></app-banner>
                </div>


    2. Adjust the banner component so that the 2nd row has a left, center, and right parts
 
        a. Edit banner.component.html

        b. Change the 2nd row so that it has a left, center, and right rows
           Hint:  Take a look at header.component.html  (as it has a left, center, and right parts)
```
![](https://github.com/traderres/webClass/raw/angularAppLessons/learnAngular/lessons/images/lesson17b_image3.png)
```
        c. The left part will be blank

        d. The center will have the label "You really should be aware"

        e. The right part will have a label "Hide"




    3. Verify that you see the "Hide" button in the banner
        a. Activate the Debugger on "Full WebApp"
        b. Verify that you see the banner (and the "Hide" label is right-aligned)
```
![](https://lh4.googleusercontent.com/K5Nf-SC7IG5dfoazLPjk_ef_eO1yBwKUObTSRfumtLBHYAIQqMPj-OFYruxnXH9Ye5yiK1r3hH3Vrr3U2Ech0l7PqVq0JShyDf1z2TPP_XEmLBeUWtHk4mT_lT4maC6i8emwsHbF)
```
NOTE:  At this point, clicking on "Hide" does nothing




    4. Create a banner service and set it up with a BehaviorSubject
        a. Create the banner service


        b. Add this private BehaviorSubject variable:
               private bannerStateSubject = new BehaviorSubject<boolean>(true);   
            
               NOTE:  This initializes the BannerService with a state of true (show banner)


        c. Add these 3 public methods:
            
              public getStateAsObservable(): Observable<boolean> {
                return this.bannerStateSubject.asObservable();
              }
            
              public hideBanner(): void {
                // Send a message with false  (to tell anyone listening to hide the banner)
                this.bannerStateSubject.next(false);
              }
            
              public showBanner(): void {
                // Send a message with true  (to tell anyone listening to show the banner)
                this.bannerStateSubject.next(true);
              }


    5. Adjust the Banner Component to send messages with the banner service
        a. Edit banner.component.ts

        b. Inject the banner service  (and make it public)

        c. Edit banner.component.html

        d. Change your "Hide" label so it has a (click)="this.bannerService.hideBanner()"

            When someone clicks "Hide", the BannerComponent is sending a message to hide the banner



    6. Adjust app.component.ts to listen for messages from the banner service
        a. Edit app.component.ts

        b. Inject the banner service  (and make it private)

        c. Add these variables to app.component.ts:
                private bannerSubscription: Subscription;
                public showBannerOnPage: boolean;

        d. Adjust the ngOnInit() so it listens for messages from the bannerService

                this.bannerSubscription =
                    this.bannerService.getStateAsObservable().subscribe( (aShowBanner: boolean) => {
                        // We received a message from the Banner Service
            
                        // If we receive false, then set the flag to false
                        // If we receive true,  then set the flag to true
                        this.showBannerOnPage = aShowBanner;
                });



    7. Adjust app.component.html to show/hide the banner
        a. Edit app.component.html

        b. Add an *ngIf on your banner
            
              <div fxFlex="50px" *ngIf="this.showBannerOnPage">
                <!-- Banner is 50 pixels high -->
                <app-banner fxFlex></app-banner>
              </div> 



    8. Verify your banner will disappear when the user presses "Hide:"
        a. Activate the Debugger on "Full WebApp"
        b. Click the "hide" button
           -- The banner should disappear


```
