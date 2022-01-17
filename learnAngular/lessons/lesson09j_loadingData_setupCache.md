Lesson 9j:  Loading Data / Setup Cache
--------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1fKzSds6BgP3VqXMTIMvH7oTj-sme8ZMgrg3HxsoVyws/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson9j/loading-cache
<br>
<br>




Problem: Every time a user clicks on "Add Report 2", we wait 5 seconds to load the dropdowns  

- Most lookup values do \*NOT\* change very often
- It would reduce overhead tocache these calls within the front-end

<br>
<br>

Solution 1: Change the lookupService to <b>cache the values</b> <br>
Weakness of Approach 1:
- We put the value into the cache asynchronously
- All asynchronous code will be executed after the synchronous code.

  
  
<br>
<br>

Solution 2: Change the LookupService to <b>cache the observables</b>  
- This way, both function calling and caching will be synchronous
- We must use the shareReplay operator (which allows the subscribers to view the result of the HTTP call)
- NOTE: shareReplay() returns a hot, reference-counted observable, but replays the specified number of next notification

<br>
Solution 2 has some advantages, so when in doubt, cache the observable (not the value!)

<br>
<br>

<h5>References</h5>
- https://medium.com/better-programming/how-to-create-a-caching-service-for-angular-bfad6cbe82b0
  
<br>
<br>

```

Procedure for Caching Values (Solution 1)
-----------------------------------------
    1. Verify that the current lookup.service.ts (with no caching) makes REST calls and returns the observable.  It should look like this:

		import { Injectable } from '@angular/core';
		import {LookupDTO} from "../models/lookup-dto";
		import {HttpClient} from "@angular/common/http";
		import {environment} from "../../environments/environment";
		import {Observable} from "rxjs";

		@Injectable({
		  providedIn: 'root'
		})
		export class LookupService {

		  constructor(private httpClient: HttpClient) { }

		  /*
		   * Return a list of LookupDTO objects that correspond to the passed-in type name -- e.g, 'priority'
		   */
		  public getLookupWithType(aType: string): Observable<LookupDTO[]>  {

			const restUrl = environment.baseUrl + '/api/lookups/' + aType;

			return this.httpClient.get <LookupDTO[]>(restUrl);
		  }


		  /*
		   * Return a sorted list of LookupDTO objects that correspond to the passed-in type name -- e.g, 'priority'
		   */
		  public getLookupWithTypeAndOrder(aType: string, aOrderBy: string): Observable<LookupDTO[]>  {

			const restUrl = environment.baseUrl + '/api/lookups/' + aType + '/' + aOrderBy;

			return this.httpClient.get <LookupDTO[]>(restUrl);
		  }
		}


    2. Change the lookup.service.ts to this (to cache the values but still returns observable):
        
        import { Injectable } from '@angular/core';
        import {HttpClient} from "@angular/common/http";
        import {environment} from "../../environments/environment";
        import {Observable, of} from "rxjs";
        import {tap} from "rxjs/operators";
        import {LookupDTO} from "../models/lookup-dto";
        
        @Injectable({
          providedIn: 'root'
        })
        export class LookupService {
        
          constructor(private httpClient: HttpClient)
          { }
        
          // The cache holds key=type value=list of LookupDTO objects
          private cache: any = {};
        
          /*
           * Return a list of LookupDTO objects that correspond to the passed-in type name -- e.g, 'priority'
           */
          public getLookupWithType(aType: string): Observable<LookupDTO[]>  {
        
            if (this.cache[aType]) {
                // This lookup is in the cache.  So, return it from the cache
                console.log('Returning cached value for ', aType);
        
                // Return an observable with this data in it
                return of(this.cache[aType])
            }
        
            console.log('getLookupWithType() requesting value for ', aType);
            const restUrl = environment.baseUrl + '/api/lookups/' + aType;
        
            return this.httpClient.get <LookupDTO[]>(restUrl).pipe(
                tap(resolvedValue => {
                        // Add this information to the cache
                        this.cache[aType] = resolvedValue;
                })
            );
          }
        
        
          /*
           * Return a sorted list of LookupDTO objects that correspond to the passed-in type name -- e.g, 'priority'
           */
          public getLookupWithTypeAndOrder(aType: string, aOrderBy: string): Observable<LookupDTO[]>  {
            let cacheKey = aType + ',' + aOrderBy;
        
            if (this.cache[cacheKey]) {
                // This lookup is in the cache.  So, return it from the cache
                console.log('Returning cached value for ', cacheKey);
        
                // Return an observable with this data in it
                return of(this.cache[cacheKey])
            }
        
            console.log('getLookupWithType() requesting value for ', cacheKey);
            const restUrl = environment.baseUrl + '/api/lookups/' + aType + '/' + aOrderBy;
        
            // Invoke the REST call and add the resolved values to the cache.
            return this.httpClient.get <LookupDTO[]>(restUrl).pipe(
                tap(resolvedValue => {
                        // Add this information to the cache
                        this.cache[cacheKey] = resolvedValue;
                })
            );
          }
        }
        
        
    3. Verify that the slow REST calls only happen the first time
        a. Pull Run -> Debug 'Full WebApp'
        b. Click on "Add Report 2"
           -- You should wait 5 seconds for the dropdowns to load
        c. Navigate to a different page
        d. Return to "Add Report 2"
           -- The dropdowns should load immediately (because it's using the cached values)
        
        
        



Procedure for Caching Observables (Solution 2)
----------------------------------------------
    1. Change the lookup.service.ts to this:
        
        import { Injectable } from '@angular/core';
        import {LookupDTO} from "../models/lookup-dto";
        import {HttpClient} from "@angular/common/http";
        import {environment} from "../../environments/environment";
        import {EMPTY, Observable} from "rxjs";
        import {catchError, shareReplay} from "rxjs/operators";
        
        @Injectable({
          providedIn: 'root'
        })
        export class LookupService {
        
              constructor(private httpClient: HttpClient)
              { }
        
              // The cache holds key=type value=replayable observable 
              private cache: any = {};
        
              /*
               * Return a list of LookupDTO objects that correspond to the passed-in name -- e.g, 'priority'
               */
              public getLookupWithType(aType: string): Observable<LookupDTO[]>  {
        
                if (this.cache[aType]) {
                  // This observable is in the cache.  So, return it from the cache
                  return this.cache[aType];
                }
        
                const restUrl = environment.baseUrl + '/api/lookups/' + aType;
        
                this.cache[aType] = this.httpClient.get <LookupDTO[]>(restUrl).pipe(
                    shareReplay(1),
                    catchError(err => {
                      console.error('There was an error getting lookup value ' + aType + '.  Error is ', err);
                      delete this.cache[aType];
                      return EMPTY;
                }));
        
                return this.cache[aType];
              }
        
        
              /*
               * Return a sorted list of LookupDTO objects that correspond to the passed-in type name -- e.g, 'priority'
               */
              public getLookupWithTypeAndOrder(aType: string, aOrderBy: string): Observable<LookupDTO[]>  {
                let cacheKey = aType + ',' + aOrderBy;
        
                if (this.cache[cacheKey]) {
                  // This observable is in the cache.  So, return it from the cache
                  return this.cache[cacheKey];
                }
        
                const restUrl = environment.baseUrl + '/api/lookups/' + aType + '/' + aOrderBy;
        
                // Invoke the REST call and add this observable to the cache.         
                this.cache[cacheKey] = this.httpClient.get <LookupDTO[]>(restUrl).pipe(
                  shareReplay(1),
                  catchError(err => {
                        console.error('There was an error getting lookup value ' + aType + '.  Error is ', err);
                        delete this.cache[aType];
                        return EMPTY;
                  }));
        
                return this.cache[cacheKey];
              }
        }



    2. Verify that the slow REST calls only happen the first time
        a. Pull Run -> Debug 'Full WebApp'
        b. Click on "Add Report 2"
           -- You should wait 5 seconds for the dropdowns to load
        c. Navigate to a different page
        d. Return to "Add Report 2"
           -- The dropdowns should load immediately (because it's using the cache)


```

  
