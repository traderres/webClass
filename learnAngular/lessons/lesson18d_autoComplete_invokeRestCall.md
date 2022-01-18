Lesson 18d:  AutoComplete / Invoke REST Call
--------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1x_02M6O16podI3CmoxG8mDKEus_gRQX1K8_yAStrDBw/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson18d/autocomplete/invoke-rest-call
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem:  We have the REST call but need to invoke it when the user starts typing<br>
Solution:  Change the ElasticSearchService so it invokes the real REST end point.<br>
<br>
<br>

![](https://lh5.googleusercontent.com/0KO4ZaQ_KGYhkKuwBdu7iUuY7zpEfKwRgMEcx4diPmhCvEmt1So-U4J9swcrxwdR1mm49sYPExWYI606CogHeJTdkfAzCSM9gGR3en6WpopAD5BaPr-oGGdWzrAh4xAyGZt4RvUH)


<br>
<br>
<h3>Approach</h3>

1. Add an AutoCompleteDTO to the front-end  (used to pass-in information to the REST call)
1. Change ElasticSearchService.ts so that it invokes the REST call
1. Change SearchBoxDetailsComponent (because the id field is a string instead of a number)


<br>
<br>

```
Procedure
---------
Procedure
    1. Add an AutoCompleteDTO to the front-end  (used to pass-in information to the REST call)
        a. Create the front-end AutoCompleteDTO object

        b. Edit auto-complete-dto.ts

        c. Add these public fields to it:

            index_name      	text field
            returned_field		text field
            searched_field		text field
            raw_query		text field
            size			numeric field


    2. Change the ElasticSearchService to invoke the REST call
        a. Edit elastic-search.service.ts

        b. Inject the httpClient

        c. Change the runSearch() method by getting rid of the hard-coded observable

        d. Create an autoCompleteDTO object with information to pass-in to the REST call

        
            // Construct the DTO that has the information this REST call needs
            let autoCompleteDTO: AutoCompleteDTO = {
                index_name:		"reports",
                returned_field: 	"display_name",
                searched_field: 	"display_name.filtered",
                raw_query: 		aRawQuery,
                size: 			aTotalReturnsToReturn
            };


        e. Use the httpClient to invoke the REST call and pass-in the DTO
        
            // Construct the URL of the REST endpoint for the autocomplete search
            const restUrl = environment.baseUrl + '/api/search/autocomplete';
        
            // Return an observable (that runs an auto-complete search)
            return this.httpClient.post <AutoCompleteMatchDTO[]> (restUrl, autoCompleteDTO);


    3. Change SearchBoxDetailsComponent (because the id field is a string instead of a number)
        a. Edit search-box-details.component.ts

        b. Change the public id so it's now a string

        c. Change ngOnInit() so it only checks if the rawId == null

        d. Change ngOnInit() so it sets this.id = rawId;



    4. Verify that the auto-complete invokes the REST call and searches 1 million records in real-time
        a. Activate the Debugger on "Full WebApp"
        b. Type-in "123" in the search box
```
![](https://lh5.googleusercontent.com/0KO4ZaQ_KGYhkKuwBdu7iUuY7zpEfKwRgMEcx4diPmhCvEmt1So-U4J9swcrxwdR1mm49sYPExWYI606CogHeJTdkfAzCSM9gGR3en6WpopAD5BaPr-oGGdWzrAh4xAyGZt4RvUH)
```





        c. Type-in " 64"  (with a space before 64"
```
![](https://lh3.googleusercontent.com/fcwdSCm8IC7N4hpKVAAqc8-rO5KFR9BSf7abnvHxX8F61s9hP8BeRE4EC8FCk5db2pEURGiSvC6PDODFHhrF-xKRBRbSxzaMNvIrGc4PyMwjo07MmCL8uKYvatPlDZH7uVoxokrZ)

	


```
