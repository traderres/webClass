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
    j. <a href="./lectures/boring.lecture.all-rest-calls-are-ambiguous.txt"     title="The dirty secret w/form validation:  All REST call contracts are ambiguous">The dirty secret w/form validation:  All REST call contracts are ambiguous</a>
    k. <a href="./lectures/boring.lecture.approaches-asking-many-questions.txt" title="Approaches to asking many question">Approaches to asking many questions</a>
    l. <a href="./lectures/what.is.the.contract.txt"    title="What is the Contract?">What is the contract?</a>
    m. <a href="./lectures/boring.lecture.angular.tricks.and.techniques.txt"    title="Angular Material Tricks & Techniques">Angular Material Tricks & Techniques</a>
    n. <a href="./lectures/boring.lecture.ag-grid.tricks.and.techniques.txt"    title="Ag-grid Tricks & Techniques">ag-grid Tricks & Techniques</a>
    o. <a href="./lectures/boring.lecture.observable-linked-to-rest-call.txt"   title="Use httpClient to create observable">Use httpClient to link an observable to a REST call</a>
    p. <a href="lectures/boring.lecture.evolution.of.the.label.md"              title="Evolution of the label">Evolution of the Label</a>
    
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
           <a href="./exercises/exercise01a.question.txt"                  title="Exercise 1a">Exercise 1a</a> / Three Boxes Page               (<a href="./exercises/exercise01a.answers.txt"                  title="Answer to 1a">Answers</a>)
           <a href="./exercises/exercise01b.question.txt"                  title="Exercise 1b">Exercise 1b</a> / Fixed & Variable Widths        (<a href="./exercises/exercise01b.answers.txt"                  title="Answer to 1b">Answers</a>)
           <a href="./exercises/exercise01c.registration-completed.question.txt"   title="Exercise 1c">Exercise 1c</a> / Center Horiz and Vert          (<a href="./exercises/exercise01c.registration-completed.answers.txt"     title="Answer to 1c">Answers</a>)
           <a href="./exercises/exercise01d.html-over-image.question.txt"    title="Exercise 1d">Exercise 1d</a> / HTML Over Image                (<a href="./exercises/exercise01d.html-over-image.answers.txt"          title="Answer to 1c">Answers</a>)
           <a href="./exercises/exercise02.my-settings.question.txt"       title="Exercise 2 ">Exercise 2</a>  / My Settings                    (<a href="./exercises/exercise02.my-settings.answers.txt"       title="Answer to 2">Answers</a>)
           <a href="./exercises/exercise03a.stock-trade.question.txt"      title="Exercise 3a">Exercise 3a</a> / Stock Trade                    (<a href="./exercises/exercise03a.stock-trade.answers.txt"      title="Answer to 3a">Answers</a>)
           <a href="./exercises/exercise03b.stock-trade.question.txt"      title="Exercise 3b">Exercise 3b</a> / Limit Price Disappears         (<a href="./exercises/exercise03b.stock-trade.answers.txt"      title="Answer to 3b">Answers</a>)
           <a href="./exercises/exercise04.responsive.layout.question.txt" title="Exercise 4 ">Exercise 4</a>  / Responsive Layout              (<a href="./exercises/exercise04.responsive.layout.answers.txt" title="Answer to 4">Answers</a>)

    b. How to use overflow-y, set variable heights, and use fixed divs
           <a href="./exercises/exercise05a.overflow-y.question.txt"                           title="Exercise 5a">Exercise 5a</a> / Overflow-y                     (<a href="./exercises/exercise05a.overflow-y.answers.txt"       title="Answer to 5a">Answers</a>)
           <a href="./exercises/exercise05b.holy-grail.question.txt"                           title="Exercise 5b">Exercise 5b</a> / Holy Grail (w/calc)            (<a href="./exercises/exercise05b.holy-grail.answers.txt"       title="Answer to 5b">Answers</a>)
           <a href="./exercises/exercise05c.scroll-into-view.question.txt"                     title="Exercise 5c">Exercise 5c</a> / Scroll Into View               (<a href="./exercises/exercise05c.scroll-into-view.answers.txt" title="Answer to 5c">Answers</a>)
           <a href="./exercises/exercise05d.calc-vs-flex-grow-for-height.question.txt"         title="Exercise 5d">Exercise 5d</a> / Using Remaining Height         (<a href="./exercises/exercise05d.calc-vs-flex-grow-for-height.answers.txt" title="Answer to 5d">Answers</a>)
           <a href="./exercises/exercise05e.calc-vs-flex-grow-for-height-on-tabs.question.md"  title="Exercise 5e">Exercise 5e</a> / Using Remaining Height on Tabs (<a href="./exercises/exercise05e.calc-vs-flex-grow-for-height-on-tabs.answers.md" title="Answer to 5e">Answers</a>)
           <a href="./exercises/exercise05f.calc-vs-flex-grow-for-height-on-tabs-with-ag-grid.answers.md"  title="Exercise 5f">Exercise 5f</a> / Using Remaining Height on Tabs w/ag-grid (<a href="./exercises/exercise05f.calc-vs-flex-grow-for-height-on-tabs-with-ag-grid.answers.md" title="Answer to 5f;">Answers</a>)

    c. How to make DIVs appear/disappear using animation
           <a href="./exercises/exercise06a.howToDoTransitionsOnWidth.question.txt"                  title="Exercise 6a">Exercise 6a</a> / Transitions on width           (<a href="./exercises/exercise06a.howToDoTransitionsOnWidth.answers.txt"                  title="Answer to 6a">Answers</a>)
           <a href="./exercises/exercise06b.right-side-slide-out-drawer.question.txt"                title="Exercise 6b">Exercise 6b</a> / Setup Right Drawer for help    (<a href="./exercises/exercise06b.right-side-slide-out-drawer.answers.txt"                title="Answer to 6b">Answers</a>)
           <a href="./exercises/exercise06c.howToDoTransitionsOnHeightUsingTemplateVar.question.txt" title="Exercise 6c">Exercise 6c</a> / Transitions on Height          (<a href="./exercises/exercise06c.howToDoTransitionsOnHeightUsingTemplateVar.answers.txt" title="Answer to 6c">Answers</a> using template variable)
           <a href="./exercises/exercise06d.howToDoTransitionsOnHeightUsingTailwind.question.txt"    title="Exercise 6d">Exercise 6d</a> / Transitions on Height          (<a href="./exercises/exercise06d.howToDoTransitionsOnHeightUsingTailwind.answers.txt"    title="Answer to 6d">Answers</a> using pure tailwind approach)
  
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
    i. <a href="./howToMakeNarrowDropdown.txt" title="Narrow Dropdowns">Narrow dropdowns</a>      (often used for navigation)

 8. Client Side Grids (using ag-grid)
    <a href="./ag-grid.add-to-project.txt"   title="Add ag-grid to the project">Add ag-grid to the project</a>
    <a href="./ag-grid.set-license-key.txt"  title="Set ag-grid license key">Set ag-grid enterprise license key</a>
    <a href="./exercises/exercise11a.client-grid-add-grid-page.question.md"                title="Exercise 11a">Exercise 11a</a> / Client Grid / Add a Grid Page                     (<a href="./exercises/exercise11a.client-grid-add-grid-page.answers.md"       title="Exercise 11a">Answers</a>)
    <a href="./exercises/exercise11b.client-grid-load-using-service.question.md"           title="Exercise 11b">Exercise 11b</a> / Client Grid / Load grid using a frontend service  (<a href="./exercises/exercise11b.client-grid-load-using-service.answers.md"  title="Exercise 11b">Answers</a>)
    <a href="./exercises/exercise11c.client-grid-add-text-filters.question.md"             title="Exercise 11c">Exercise 11c</a> / Client Grid / Add Text Filters                    (<a href="./exercises/exercise11c.client-grid-add-text-filters.answers.md"    title="Exercise 11c">Answers</a>)
    <a href="./exercises/exercise11d.client-grid-sorting.question.md"                      title="Exercise 11d">Exercise 11d</a> / Client Grid / Sorting                             (<a href="./exercises/exercise11d.client-grid-sorting.answers.md"             title="Exercise 11d">Answers</a>)
    <a href="./exercises/exercise11e.client-grid-cell-renderers.question.md"               title="Exercise 11e">Exercise 11e</a> / Client Grid / Format cells w/cell renderers       (<a href="./exercises/exercise11e.client-grid-cell-renderers.answers.md"      title="Exercise 11e">Answers</a>)
    <a href="./exercises/exercise11f.client-grid-with-html-controls.question.md"           title="Exercise 11f">Exercise 11f</a> / Client Grid / Add HTML controls w/cell renderers  (<a href="./exercises/exercise11f.client-grid-with-html-controls.answers.md"  title="Exercise 11f">Answers</a>)
    <a href="./exercises/exercise11g.client-grid-search-box-applies-filters.question.md"   title="Exercise 11g">Exercise 11g</a> / Client Grid / Add search box that applies filters (<a href="./exercises/exercise11g.client-grid-search-box-applies-filters.answers.md"  title="Exercise 11g">Answers</a>)
    <a href="./exercises/exercise11h.client-grid-row-selection.question.md"                title="Exercise 11h">Exercise 11h</a> / Client Grid / Row Selection & Checkboxes          (<a href="./exercises/exercise11h.client-grid-row-selection.answers.md"  title="Exercise 11h">Answers</a>)
    <a href="./exercises/exercise11i.client-grid-with-custom-dropdown-filter.question.md"  title="Exercise 11i">Exercise 11i</a> / Client Grid / Build a Custom Dropdown Filter      (<a href="./exercises/exercise11i.client-grid-with-custom-dropdown-filter.answers.md"  title="Exercise 11i">Answers</a>)
    <a href="./exercises/exercise11j.client-grid-remembers-settings.question.md"           title="Exercise 11j">Exercise 11j</a> / Client Grid / Remember grid columns settings      (<a href="./exercises/exercise11j.client-grid-remembers-settings.answers.md"  title="Exercise 11j">Answers</a>)
    <a href="./exercises/exercise11k.client-grid-with-one-million-records.question.md"     title="Exercise 11k">Exercise 11k</a> / Client Grid / Load 1 million records into it      (<a href="./exercises/exercise11k.client-grid-with-one-million-records.answers.md"  title="Exercise 11k">Answers</a>)

 9. Tabs Groups
    <a href="./exercises/exercise12a.setup-tab-group.question.txt" title="Exercise 12a">Exercise 12a</a> / Tab Group / Setup page w/tabs                     (<a href="./exercises/exercise12a.setup-tab-group.answers.txt"   title="Exercise 12a">Answers</a>)
    <a href="./exercises/exercise12b.make-tabs-pretty.question.md" title="Exercise 12b">Exercise 12b</a> / Tab Group / Make the tabs look pretty             (<a href="./exercises/exercise12b.make-tabs-pretty.answers.md"   title="Exercise 12b">Answers</a>)
    Exercise 12c / Tab Group / Add navbar links to different tabs
    Exercise 12d / Tab Group / Switching tabs and scrolling down
    Exercise 12e / Tab Group / Open tab group in a dialog

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
    Exercise 20a / How to send messages from one part of the web app to another
    Exercise 20b / How to listen for messages across the web app
    Exercise 20c / Refresh Notifications in the navbar / using timer
    Exercise 20d / Refresh Notifications in the navbar / listening for message

14. Acknowledgement / Hide or disable all pages until the user acknowledges a message
    <a href="./exercises/exercise21a.acknowledgement-page.add-rest-calls.question.txt"    title="Exercise 21a">Exercise 21a</a> / Add Acknowledgement Page / Add REST Calls                      (<a href="./exercises/exercise21a.acknowledgement-page.add-rest-calls.answers.txt"  title="Answer to 21a">Answers</a>)
    <a href="./exercises/exercise21b.acknowledgement-page.add-html-page.question.txt"     title="Exercise 21b">Exercise 21b</a> / Add Acknowledgement Page / Add HTML Page over main page        (<a href="./exercises/exercise21b.acknowledgement-page.add-html-page.answers.txt"  title="Answer to 21b">Answers</a>)
    Exercise 21c / Add Acknowledgement Dialog

15. Responsive Design Strikes Back
    Exercise 22a / Show a message if web browser is too small or too short
    Exercise 22b / Update individual pages to fit your user's browser sizes

16. TypeScript / Kitchen Sink
    <a href="./howToReferenceEnumClass.txt" title="How to Use Enumerated Classes in HTML">How to Use Enumerated Classes in HTML</a>  (constants.ts)

17. Server Side Grids (using ag-grid)
    <a href="./lectures/boring.lecture.ag-grid.server-vs-client-grids.txt" title="Client-Side vs Server-Side Grids">Client-Side vs Server-Side Grids</a>

18. HighCharts 
    <a href="./howToSetupHighcharts.txt" title="Add HighCharts to the project">Add Highcharts to the project</a>
    <a href="./exercises/exercise25a.charts.create-responsive-dashboard.question.md"      title="Exercise 25a">Exercise 25a</a> / Charts / Setup Responsive Dashboard Page     (<a href="./exercises/exercise25a.charts.create-responsive-dashboard.answers.md" title="Answer to 25a">Answers</a>)
    <a href="./exercises/exercise25b.charts.add-small-pie-chart.question.md"              title="Exercise 25b">Exercise 25b</a> / Charts / Add a pie chart to the Dashboard    (<a href="./exercises/exercise25b.charts.add-small-pie-chart.answers.md" title="Answer to 25b">Answers</a>)
    <a href="./exercises/exercise25c.charts.add-large-pie-chart.question.md"              title="Exercise 25c">Exercise 25c</a> / Charts / Make a full-size chart page         (<a href="./exercises/exercise25c.charts.add-large-pie-chart.answers.md" title="Answer to 25c">Answers</a>)
    <a href="./exercises/exercise25d.charts.load-chart-with-frontend-service.question.md" title="Exercise 25d">Exercise 25d</a> / Charts / Load chart w/front-end service      (<a href="./exercises/exercise25d.charts.load-chart-with-frontend-service.answers.md" title="Answer to 25d">Answers</a>)
    <a href="./exercises/exercise25e.charts.load-chart-with-rest-call.question.md"        title="Exercise 25e">Exercise 25e</a> / Charts / Add REST call to get data           (<a href="./exercises/exercise25e.charts.load-chart-with-rest-call.answers.md" title="Answer to 25e">Answers</a>)
    <a href="./exercises/exercise25f.charts.drill-down-capability.question.md"            title="Exercise 25f">Exercise 25f</a> / Charts / Add column chart w/drill-down       (<a href="./exercises/exercise25f.charts.drill-down-capability.answers.md" title="Answer to 25f">Answers</a>)
    <a href="./exercises/exercise25g.charts.customize-the-context-menu.question.md"       title="Exercise 25g">Exercise 25g</a> / Charts / Zoomable Chart & Context menu       (<a href="./exercises/exercise25g.charts.customize-the-context-menu.answers.md" title="Answer to 25g">Answers</a>)
    <a href="./exercises/exercise25h.charts.add-usa-map.question.md"                      title="Exercise 25h">Exercise 25h</a> / Charts / Add Map of the USA                  (<a href="./exercises/exercise25h.charts.add-usa-map.answers.md" title="Answer to 25h">Answers</a>)
    <a href="./exercises/exercise25i.charts.gotchas.question.md"                          title="Exercise 25i">Exercise 25i</a> / Charts / Gotchas & Good Practices            (<a href="./exercises/exercise25i.charts.gotchas.answers.md" title="Answer to 25i">Answers</a>)
    <a href="./exercises/exercise25j.charts.gauge.question.md"                            title="Exercise 25j">Exercise 25j</a> / Charts / Gauge Chart                         (<a href="./exercises/exercise25j.charts.gauge.answers.md" title="Answer to 25j">Answers</a>)
    <a href="./exercises/exercise25k.charts.change-theme-dynamically.question.md"         title="Exercise 25k">Exercise 25k</a> / Charts / Change the theme dynamically        (<a href="./exercises/exercise25k.charts.change-theme-dynamically.answers.md" title="Answer to 25k">Answers</a>)
    Exercise 25l / Charts / Send messages to the charts

19. Chips
    <a href="./exercises/exercise26a.chips.use-with-textbox.question.md"            title="Exercise 26a">Exercise 26a</a> / Chips / Use chips with a text box            (<a href="./exercises/exercise26a.chips.use-with-textbox.answers.md" title="Answer to 26a">Answers</a>)
    <a href="./exercises/exercise26b.chips.use-with-autocomplete.question.md"       title="Exercise 26b">Exercise 26b</a> / Chips / Use chips with an autocomplete       (<a href="./exercises/exercise26b.chips.use-with-autocomplete.answers.md" title="Answer to 26b">Answers</a>)
    <a href="./exercises/exercise26c.chips.use-with-grid.question.md"               title="Exercise 26c">Exercise 26c</a> / Chips / Use chips with a grid                (<a href="./exercises/exercise26c.chips.use-with-grid.answers.md" title="Answer to 26c">Answers</a>)
    <a href="./exercises/exercise26d.chips.use-with-grid.solve-height.question.md"  title="Exercise 26d">Exercise 26d</a> / Chips / Make grid smaller dynamically        (<a href="./exercises/exercise26d.chips.use-with-grid.solve-height.answers.md" title="Answer to 26d">Answers</a>)

20. Downloads

21. Uploads
    <a href="./howToInstallNg2FileUpload.txt"            title="How to Install ng2-file-upload">How to Install ng2-file-upload</a> 
 
22. The Extended PDF Viewer (using an embedded PDF viewer)

</pre>