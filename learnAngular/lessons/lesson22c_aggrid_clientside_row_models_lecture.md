Lesson 22c:  Ag Grid / Row Models Lecture
-----------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/1pZ91oZHX_6lHWLgLnP7P-R3jaoUCc3hTWjGklkeoF-0/edit?usp=sharing
      

<br>
<br>
<br>

```

The ag-grid comes with 4 row models:
    1. Client-Side:  This is the default. 
       The grid will load all of the data into the grid in one go.
       The grid can then perform filtering, sorting, grouping, pivoting and aggregation all in memory. 
        + Appropriate when you have small data sets (under 5000 records)

    2. Infinite
       This will present the data to the user and load more data as the user scrolls down.
       Use this if you want to display a large, flat (not grouped) list of data.
       + Appropriate when you have larger data sets (over 5000 records)

    3. Server-Side
       The Server-Side Row Model builds on the Infinite Row Model. 
       In addition to lazy-loading the data as the user scrolls down, it allows lazy-loading of grouped data with server-side grouping and aggregation. 
       + Advanced users will use Server-Side Row Model to do ad-hoc slice and dice of data with server-side aggregations.
       + Appropriate when you have larger data sets (over 5000 records)

    4. Viewport
       The grid will inform the server exactly what data it is displaying (first and last row)
       The server will provide data for exactly those rows only.
       + Use this if you want the server to know exactly what the user is viewing
       + Useful for updates in very large live datastreams where the server only sends updates to clients viewing the impacted rows.


In general, the author recommends
    • Use the Client-Side row model for simple grids w/few records
    • Use the Server-side row models for larger data sets  (as it gives you the most capability)

```
