Lesson 9b:  Loading Data / Approaches
-------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1eYFV56bR62UqviBanrjXsirZIFHasgsHLh5iSIi139k/edit?usp=sharing


<br>
<br>


<h5>References</h5>

- https://medium.com/@luukgruijs/understanding-creating-and-subscribing-to-observables-in-angular-426dbf0b04a3
- https://medium.com/angular-in-depth/angular-question-rxjs-subscribe-vs-async-pipe-in-component-templates-c956c8c0c794
- https://alligator.io/angular/async-pipe/
- https://www.concretepage.com/angular-2/angular-2-async-pipe-example

  
  

<br>
<br>
<h3>Approach 1: Use routes to make the lookup call **synchronous** [BAD PRACTICE]</h3>
The idea is that the entire page does not show until *ALL* data is loaded

- The REST call is synchronous
- The entire page view \*WAITS\* for the REST call to resolve
- No spinner
<br>
NOTE: This approach is a really fucking bad practice

  
<br>
<br>
<br>
<h3>Approach 2: Manually subscribe to an Observable within ngOnInit() [BETTER PRACTICE]</h3>
In this approach, you would
1. The add-report.component.ts has a public list of priorities (used by the html page)

1. Inject the lookupService

1. Have The add-report.component.ts ngOnInit() method subscribe to the REST call

   1. Add a flag indicating the REST call is running
   1. Clear the flag when the REST call finishes

1. Add a method in ngOnDestroy() to clean up

<br>
<br>
<h5>Advantages to Approach 2</h5>

- The REST call is asynchronous
- We can show a spinner while the REST call is running

<br>
<h5>Disadvantages to Approach 2</h5>

- Need to unsubscribe from the observable at the end of the component life-cycle to avoid memory leaks
- Subscribing to an observable manually in ngOnInit() does not work with OnPush change detection \[out of the box]
- Complex to implement: You need to maintain a subscription variable and flags

  
<br>
<br>
<br>

<h3>Approach 3: Automatically subscribe to an Observable using Async Pipe [BEST PRACTICE]</h3>
In this approach, there is only one variable in the typescript class:  
  public priorities: Observable\[DTO];

1. The ngOnInit() gets an observable to the data
1. The HTML template automatically subscribes and unsubscribes

<br>

<h5>Advantages</h5> 

- The REST call is asynchronous
- We can show a spinner (if needed)
- Automatically clean-up: No need to unsubscribe
- Works with OnPush change detection
- Less complex than approach 2
- For promises, the async pipe automatically calls the then method.
- For observables, the async pipe automatically calls subscribe and unsubscribe.

  

<br>
<br>
<h3>What is an observable?</h3>

- An observable is a stream of data.
- We can push things onto the stream 
- We can listen for events in the stream.
- We can transform the stream to another stream



<br>
<br>  
<h3>Characteristics of an observable</h3>

1. Observables are lazy: They only send to subscribers  
   If you don't subscribe, then nothing happens  
     
2. Observables can have multiple values over time  
   The sender decides when you get it but all you have to do is just wait until it comes out  
   -- User clicking on keys in a textbox is an observable we can listen on  
     Click "A" --> Click "B" --> Click "C"  

3. Observables are cancelable (using the unsubscribe() method)  
   You can't cancel a promise  

4. Observables are producers of multiple items, "pushing" them to subscribers
  

<br>
<br>
<h3>Observable Functions</h3>

next() sends any value to its subscribers

error() sends a Javascript error or exception

complete() does not send any value

  
  
  
  
  
