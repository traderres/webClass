Angular 16 Lesson Plan
-----------------------

<pre>
 1. Setup the Development Env
    <a href="https://docs.google.com/document/d/1-vutLIaIN0A3WDm0P4gf9yFRLNyVVX8s2RZLWrbdT-o/edit" title="Setup Development Env (Unix)">Setup Development Env (Unix)</a>
    <a href="https://docs.google.com/document/d/1-vutLIaIN0A3WDm0P4gf9yFRLNyVVX8s2RZLWrbdT-o/edit" title="Setup Development Env (Windows)">Setup Development Env (Windows)</a>
    <a href="./howToDebugExistingWebapp.txt" title="Setup debugging in IntelliJ Ultimate">Setup debugging in IntelliJ Ultimate</a>

 2. Boring Lectures
    a. <a href="./lectures/boring.lecture.overallArchitecture.txt"              title="Overall Architecture">Overall Architecture (snooze)</a>
    b. <a href="./lectures/boring.lecture.terminology.txt"                      title="Terminology">Terminology (wake me up when it's done!)</a>
    c. <a href="./lectures/boring.lecture.what.is.tailwind.txt"                 title="What is Tailwind?">What is Tailwind?</a>
    d. <a href="./lectures/boring.lecture.component.lifecycle.txt"              title="Component Life Cycle">Component Life Cycle</a>
    e. One-way-binding and two-way-binding
    f. <a href="./lectures/boring.lecture.approaches.loading.data.txt"          title="Approaches to Loading Data">Approaches to Loading Data</a>
    g. <a href="./lectures/boring.lecture.what.is.observable.txt"               title="What is an Observable">What is an Observable?</a>
    h. <a href="./lectures/boring.lecture.flyway.auditing.bind.variables.txt"   title="Database Versioning">Database Versioning, Auditing, and Bind Variables?</a>
    i. <a href="./lectures/boring.lectures.waiting.for.rest.calls.txt"          title="Holding the user hostage while waiting for a REST call">Stopping users while waiting for a REST call to finish</a>
    j. <a href="./lectures/boring.lecture.all-rest-calls-are-ambiguous.txt"     title="The dirty secret w/form validation:  All REST call contracts are ambiguous">The dirty secret w/form validation:  All REST call contracts are ambigous</a>
    k. <a href="./lectures/boring.lecture.approaches-asking-many-questions.txt" title="Approaches to asking many question">Approaches to asking many questions</a>
    l. <a href="./lectures/what.is.the.contract.txt"    title="What is the Contract?">What is the contract?</a>
    m. <a href="./lectures/boring.lecture.angular.tricks.and.techniques.txt"    title="Angular Material Tricks & Techniques">Angular Material Tricks & Techniques</a>
    n. <a href="./lectures/boring.lecture.ag-grid.tricks.and.techniques.txt"    title="Ag-grid Tricks & Techniques">ag-grid Tricks & Techniques</a>
    
 3. Add Frontend Dependencies
    <a href="./lesson03_installTailwind.txt"    title="Install Tailwind">Install Tailwind</a>
    <a href="./lesson04_installFontAwesome.txt" title="Install Font Awesome Pro">Install Font Awesome Pro</a>

 4. Setup the project
    a. <a href="https://github.com/traderres/angularApp16/tree/lesson5a/setup-navbar-using-angular-material" title="Checkout AngularApp16 lesson5a">Checkout the App16 project</a> w/frontend, backend
    b. <a href="https://github.com/traderres/angularApp16/tree/lesson6/add-database-and-es"                  title="Checkout AngularApp16 lesson6">Checkout the App16 project</a> w/frontend, backend, db-migrations, sync-service
    c. <a href="https://github.com/traderres/angularApp16/tree/lesson7/setup-navbar-using-tailwind"          title="Checkout AngularApp16 lesson7">Checkout the App16 project</a> w/frontend, backend, db-migrations, sync-service, navbar   
    d. <a href="https://github.com/traderres/angularApp16/tree/lesson8/add-grid"                             title="Checkout AngularApp16 lesson8">Checkout the App16 project</a> w/frontend, backend, db-migrations, sync-service, navbar, ag-grid   

      At this point, you have a working Angular 16 web app / you can start adding page views to it
    

 5. Layouts (using Tailwind CSS)
    a. <a href="./lectures/boring.lecture.basic.layouts.txt"               title="Basic Layouts w/Tailwind">Basic Layouts w/Tailwind</a>            
       <a href="./howToSetupTopRow.txt"                                    title="How to Setup the Top Row">How to Setup the Top Row</a>
           <a href="./exercises/exercise01a.question.txt"                  title="Exercise 1a">Exercise 1a</a> / Three Boxes Page        (<a href="./exercises/exercise01a.answers.txt"                  title="Answer to 1a">Answers</a>)
           <a href="./exercises/exercise01b.question.txt"                  title="Exercise 1b">Exercise 1b</a> / Fixed & Variable Widths (<a href="./exercises/exercise01b.answers.txt"                  title="Answer to 1b">Answers</a>)
           <a href="./exercises/exercise01c.registration-completed.question.txt"   title="Exercise 1c">Exercise 1c</a> / Center Horiz and Vert   (<a href="./exercises/exercise01c.registration-completed.answers.txt"     title="Answer to 1c">Answers</a>)
           <a href="./exercises/exercise01d.html-over-image.question.txt"    title="Exercise 1d">Exercise 1d</a> / HTML Over Image         (<a href="./exercises/exercise01d.html-over-image.answers.txt"          title="Answer to 1c">Answers</a>)
           <a href="./exercises/exercise02.my-settings.question.txt"       title="Exercise 2 ">Exercise 2</a>  / My Settings             (<a href="./exercises/exercise02.my-settings.answers.txt"       title="Answer to 2">Answers</a>)
           <a href="./exercises/exercise03a.stock-trade.question.txt"      title="Exercise 3a">Exercise 3a</a> / Stock Trade             (<a href="./exercises/exercise03a.stock-trade.answers.txt"      title="Answer to 3a">Answers</a>)
           <a href="./exercises/exercise03b.stock-trade.question.txt"      title="Exercise 3b">Exercise 3b</a> / Limit Price Disappears  (<a href="./exercises/exercise03b.stock-trade.answers.txt"      title="Answer to 3b">Answers</a>)
           <a href="./exercises/exercise04.responsive.layout.question.txt" title="Exercise 4 ">Exercise 4</a>  / Responsive Layout       (<a href="./exercises/exercise04.responsive.layout.answers.txt" title="Answer to 4">Answers</a>)

    b. How to use overflow-y, set variable heights, and use fixed divs
           <a href="./exercises/exercise05a.overflow-y.question.txt"       title="Exercise 5a">Exercise 5a</a> / Overflow-y              (<a href="./exercises/exercise05a.overflow-y.answers.txt"       title="Answer to 5a">Answers</a>)
           <a href="./exercises/exercise05b.holy-grail.question.txt"       title="Exercise 5b">Exercise 5b</a> / Holy Grail (w/calc)     (<a href="./exercises/exercise05b.holy-grail.answers.txt"       title="Answer to 5b">Answers</a>)
           <a href="./exercises/exercise05c.scroll-into-view.question.txt" title="Exercise 5c">Exercise 5c</a> / Scroll Into View        (<a href="./exercises/exercise05c.scroll-into-view.answers.txt" title="Answer to 5c">Answers</a>)

    c. How to make DIVs appear/disappear using animation
           <a href="./exercises/exercise06a.howToDoTransitionsOnWidth.question.txt"                  title="Exercise 6a">Exercise 6a</a> / Transitions on width    (<a href="./exercises/exercise06a.howToDoTransitionsOnWidth.answers.txt"                  title="Answer to 6a">Answers</a>)
           <a href="./exercises/exercise06b.right-side-slide-out-drawer.question.txt"                title="Exercise 6b">Exercise 6b</a> / Setup Right Drawer      (<a href="./exercises/exercise06b.right-side-slide-out-drawer.answers.txt"                title="Answer to 6b">Answers</a>)
           <a href="./exercises/exercise06c.howToDoTransitionsOnHeightUsingTemplateVar.question.txt" title="Exercise 6c">Exercise 6c</a> / Transitions on Height   (<a href="./exercises/exercise06c.howToDoTransitionsOnHeightUsingTemplateVar.answers.txt" title="Answer to 6c">Answers</a> using template variable)
           <a href="./exercises/exercise06d.howToDoTransitionsOnHeightUsingTailwind.question.txt"    title="Exercise 6d">Exercise 6d</a> / Transitions on Height   (<a href="./exercises/exercise06d.howToDoTransitionsOnHeightUsingTailwind.answers.txt"    title="Answer to 6d">Answers</a> using pure tailwind approach)
  
 6. Forms
    a. Template-based Forms  (used for simpler forms)
    b. Reactive forms        (used for complex forms)
       <a href="./howToSetupReactiveForm.txt" title="Setup Reactive Forms">Setup Reactive Forms</a>
       Form Validation w/provided validators
       Form Validation w/custom validators (synchronous)
       Form Validation w/custom validators (asynchronous)

 7. Buttons, Text-Fields, and Controls (using Angular Material)
    a. <a href="./lectures/boring.lecture.dropdowns.and.textboxes.txt"       title="Intro to Textboxes & Dropdowns">Intro to Textboxes & Dropdowns</a> in Angular Material
    b. <a href="./lectures/boring.lecture.angular.tricks.and.techniques.txt" title="Angular Material Tricks">Angular Material Tricks & Techniques</a>
    c. <a href="./howToAddHyperlinks.txt" title="Hyperlinks">Hyperlinks</a>
    d. Date Pickers
       <a href="./exercises/exercise10a.add-date-picker.question.txt"                    title="Exercise 10a">Exercise 10a</a> / Add a Date Picker to the page                  (<a href="./exercises/exercise10a.add-date-picker.answers.txt"                      title="Exercise 10a">Answers</a>)
       <a href="./exercises/exercise10b.set-datepicker-using-date-string.question.txt"   title="Exercise 10b">Exercise 10b</a> / Set Date Picker with value from a date string  (<a href="./exercises/exercise10b.set-datepicker-using-date-string.answers.txt"     title="Exercise 10b">Answers</a>)
       <a href="./exercises/exercise10c.get-datepicker-value-and-format-it.question.txt" title="Exercise 10c">Exercise 10c</a> / Get selected date and format it as YYYY-MM-DD  (<a href="./exercises/exercise10c.get-datepicker-value-and-format-it.answers.txt"   title="Exercise 10c">Answers</a>)
    e. Radio Buttons
    f. Popup Menus
    g. AutoCompletes
    h. Derivative Dropdowns  [After selecting 1 dropdown value, change a 2nd dropdown's options]
    
 8. Client Side Grids (using ag-grid)
    <a href="./ag-grid.add-to-project.txt" title="Add ag-grid to the project">Add ag-grid to the project</a>
    <a href="./ag-grid.set-license-key.txt" title="Set ag-grid license key">Set ag-grid enterprise license key</a>
    <a href="./exercises/exercise11a.client-grid-add-grid-page.question.txt" title="Exercise 11a">Exercise 11a</a> / Client Grid / Add a Grid Page                             (<a href="./exercises/exercise11a.client-grid-add-grid-page.answers.txt"      title="Exercise 11c">Answers</a>)
    Exercise 11b / Client Grid / Load grid with a frontend service
    Exercise 11c / Client Grid / Cell Renderers / Format the rows with CSS
    Exercise 11d / Client Grid / Cell Renderers / Add HTML controls to rows
    Exercise 11e / Client Grid / Row Selection & checkboxes
    Exercise 11f / Client Grid / Open a dialog
    Exercise 11g / Client Grid / Remember grid columns & sorting

 9. Tabs Groups
    <a href="./exercises/exercise12a.setup-tab-group.question.txt" title="Exercise 12a">Exercise 12a</a> / Tab Group / Setup page w/tabs                     (<a href="./exercises/exercise12a.setup-tab-group.answers.txt"   title="Exercise 12a">Answers</a>)
    <a href="./exercises/exercise12b.make-tabs-pretty.question.md" title="Exercise 12b">Exercise 12b</a> / Tab Group / Make the tabs look pretty             (<a href="./exercises/exercise12b.make-tabs-pretty.answers.md"   title="Exercise 12b">Answers</a>)
    Exercise 12c / Tab Group / Add navbar links to different tabs
    Exercise 12d / Tab Group / Switching tabs and scrolling down
    Exercise 12e / Tab Group / Open tab group in a dialog
    <a href="./exercises/exercise12f.tab-caching.question.txt" title="Exercise 12f">Exercise 12f</a> / Tab Group / Cache vs non-caching of tabs          (<a href="./exercises/exercise12f.tab-caching.answers.txt"   title="Exercise 12f">Answers</a>)

10. Loading Data using Observables
    a. Load a dropdown from a REST call
       <a href="./exercises/exercise13a.load-dropdown-with-subscribe.question.txt"      title="Exercise 13a">Exercise 13a</a> / Loading Dropdown w/subscribe                   (<a href="./exercises/exercise13a.load-dropdown-with-subscribe.answers.txt"      title="Answer to 13a">Answers</a>)
       <a href="./exercises/exercise13b.load-dropdown-with-async-pipe.question.txt"     title="Exercise 13b">Exercise 13b</a> / Loading Dropdown w/async pipe                  (<a href="./exercises/exercise13b.load-dropdown-with-async-pipe.answers.txt"     title="Answer to 13b">Answers</a>)
       <a href="./exercises/exercise13c.add-rest-call-to-get-priorities.question.txt"   title="Exercise 13c">Exercise 13c</a> / Create the REST call                           (<a href="./exercises/exercise13c.add-rest-call-to-get-priorities.answers.txt"   title="Answer to 13c">Answers</a>)
       <a href="./exercises/exercise13d.integrate-rest-call-with-frontend.question.txt" title="Exercise 13d">Exercise 13d</a> / Integrate the REST call w/the frontend         (<a href="./exercises/exercise13d.integrate-rest-call-with-frontend.answers.txt" title="Answer to 13d">Answers</a>)
       <a href="./exercises/exercise13e.multiple-async-pipes.question.txt"              title="Exercise 13e">Exercise 13e</a> / Loading w/multiple async pipes                 (<a href="./exercises/exercise13e.multiple-async-pipes.answers.txt"              title="Answer to 13e">Answers</a>)
       <a href="./exercises/exercise13f.show-loading-message.question.txt"              title="Exercise 13f">Exercise 13f</a> / Show loading message while waiting             (<a href="./exercises/exercise13f.show-loading-message.answers.txt"              title="Answer to 13f">Answers</a>)

    b. Advanced Stock Trade  (putting async pipes into practice)
       <a href="./exercises/exercise14a.advanced-stock-trade.layout.question.txt"              title="Exercise 14a">Exercise 14a</a> / AST / Setup Layout                             (<a href="./exercises/exercise14a.advanced-stock-trade.layout.answers.txt"              title="Answer to 14a">Answers</a>)
       <a href="./exercises/exercise14b.advanced-stock-trade.press.quote.btn.question.txt"              title="Exercise 14b">Exercise 14b</a> / AST / Pressing Quote loads data                (<a href="./exercises/exercise14b.advanced-stock-trade.press.quote.btn.answers.txt"              title="Answer to 14b">Answers</a>)
       <a href="./exercises/exercise14c.advanced-stock-trade.press.listen.for.quotes.question.txt"              title="Exercise 14c">Exercise 14c</a> / AST / Listen on the Quote Text Box             (<a href="./exercises/exercise14c.advanced-stock-trade.press.listen.for.quotes.answers.txt"              title="Answer to 14c">Answers</a>)
       <a href="./exercises/exercise14d.advanced-stock-trade.autocomplete.question.txt"              title="Exercise 14d">Exercise 14d</a> / AST / Use Autocomplete Text Box                (<a href="./exercises/exercise14d.advanced-stock-trade.autocomplete.answers.txt"              title="Answer to 14d">Answers</a>)
   
    c. Edit Stock Trade
       Exercise 15a / EST / Create "List Stock Trades" Page          (Answers)
       Exercise 15b / EST / Setup "Edit Stock Trade" Layout          (Answers)
       Exercise 15c / EST / Get tradeId from the url                 (Answers)
       Exercise 15d / EST / Add Reactive Form                        (Answers)
       Exercise 15e / EST / Load Form with Saved Trade               (Answers)
       
    d. Misc Techniques ("kitchen sink")
       <a href="./exercises/exercise16a.cache.observables.in.service.question.txt"    title="Exercise 16a">Exercise 16a</a> / Cache data in frontend service                 (<a href="./exercises/exercise16a.cache.observables.in.service.answers.txt"  title="Answer to 16a">Answers</a>)
       <a href="./exercises/exercise16b.format-numbers-with-pipes.question.txt"    title="Exercise 16b">Exercise 16b</a> / Format Numbers with Pipes                      (<a href="./exercises/exercise16b.format-numbers-with-pipes.answers.txt"        title="Answer to 16b">Answers</a>)
       Exercise 16c / Simulate a slow REST call                      (Answers)
       Exercise 16d / Listen on autocomplete                         (Answers)

11. Saving Data 
    <a href="./exercises/exercise17a.submit-button-invokes-REST-call.question.txt"   title="Exercise 17a">Exercise 17a</a> / Setup "Add Report" Page w/fake REST call          (<a href="./exercises/exercise17a.submit-button-invokes-REST-call.answers.txt"  title="Answer to 17a">Answers</a>)
    <a href="./exercises/exercise17b.add-db-changes-and-REST-call.question.txt"      title="Exercise 17b">Exercise 17b</a> / Add database changes & Build REST call            (<a href="./exercises/exercise17b.add-db-changes-and-REST-call.answers.txt"     title="Answer to 17b">Answers</a>)
    <a href="./exercises/exercise17c.use-audit-manager-in-transaction.question.txt"               title="Exercise 17c">Exercise 17c</a> / Use AuditManager in a SQL Transaction             (<a href="./exercises/exercise17c.use-audit-manager-in-transaction.answers.txt" title="Answer to 17c">Answers</a>)
    <a href="./exercises/exercise17d.use-dialog-to-freeze-user.question.txt"         title="Exercise 17d">Exercise 17d</a> / Use dialog to freeze user while waiting           (<a href="./exercises/exercise17d.use-dialog-to-freeze-user.answers.txt"        title="Answer to 17d">Answers</a>)

12. Asking the user many questions
    <a href="./exercises/exercise18a.ask-questions-with-mat-step.questions.txt"                    title="Exercise 18a">Exercise 18a</a> / Ask questions w/single-page and mat-step / Setup Layout        (<a href="./exercises/exercise18a.ask-questions-with-mat-step.answers.txt"  title="Answer to 18a">Answers</a>)
    <a href="./exercises/exercise18b.ask-questions-with-mat-step-rest-call.questions.txt"          title="Exercise 18b">Exercise 18b</a> / Ask questions w/single-page and mat-step / Add REST call       (<a href="./exercises/exercise18b.ask-questions-with-mat-step-rest-call.answers.txt"  title="Answer to 18b">Answers</a>)
    <a href="./exercises/exercise18c.ask-questions-with-mat-step-prevent-going-back.questions.txt" title="Exercise 18c">Exercise 18c</a> / Ask questions w/single-page and mat-step / Stop Double Submit  (<a href="./exercises/exercise18c.ask-questions-with-mat-step-prevent-going-back.answers.txt"  title="Answer to 18c">Answers</a>)
    <a href="./exercises/exercise19a.ask-questions-with-multiple-pages-layout.question.txt" title="Exercise 19a">Exercise 19a</a> / Ask questions w/multiple pages / Setup Layout                  (<a href="./exercises/exercise19a.ask-questions-with-multiple-pages-layout.answers.txt"  title="Answer to 19a">Answers</a>)
    Exercise 19b / Ask questions w/multiple pages / REST calls
    Exercise 19c / Ask questions w/multiple pages / Auto-save when leaving page
    Exercise 19d / Ask questions w/multiple pages / Auto-save every N seconds 

13. Sending Messages using Observables, Subjects, and Arrow Functions
    a. How to send messages from one part of the web app to another
    b. How to listen for messages across the web app

14. Services
    a. Router service:   Used to navigate to another page view
    b. Lookup Service:   Used to populate dropdowns
    c. Message Service:  Used to display messages
 
15. TypeScript
    a. <a href="./howToReferenceEnumClass.txt" title="How to Use Enumerated Classes in HTML">How to Use Enumerated Classes in HTML</a>  (constants.ts)

16. Server Side Grids (using ag-grid)
    a. <a href="./lectures/boring.lecture.grids.txt" title="Client-Side vs Server-Side Grids">Client-Side vs Server-Side Grids</a>

17. HighCharts

18. The Extended PDF Viewer (using an embedded PDF viewer)

</pre>