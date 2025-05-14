```
Exercise 5f / I want my ag-grid-angular (in a mat-tab) to use the entire height of the tab
-------------------------------------------------------------------------------------------

    Approach #1 / The grid has a height but it will not stretch to fill the entire height
                  If the grid has lots of rows, then the scrollbar appears (without the height-calc trick)
    +----------------------------------------------------------------------+
    | Tab Group Page                                                  Help |   <-- Use the tailwind h-full trick 
    +----------------------------------------------------------------------+
    |                                                                      |
    |  +------------------+-----------------------+---------------------+  |
    |  | User Profile Tab | Open Requests Tab     | All Requests Tab    |  |
    |  +------------------+-----------------------+---------------------+  |
    |  | Open Requests                                                  |  |
    |  |                                                                |  |
    |  | +----------------------------+---------------------+           |  |
    |  | |   A G - G R I D                                  |           |  |
    |  | |   A G - G R I D      Row 2                       |           |  |
    |  | |   A G - G R I D      Row 3                       |           |  |
    |  | +--------------------------------------------------+           |  |
    |  |                                                                |  |
    |  |                                                                |  |   <--- PROBLEM:  We have empty space here
    |  |                                                                |  |        If you use domLayout='autoHeight', 
    |  |                                                                |  |          Then you have empty space beneath
    |  |                                                                |  |          as the grid does NOT use the full height
    |  |                                                                |  |
    |  |                                                                |  |
    |  +----------------------------------------------------------------+  |
    +----------------------------------------------------------------------+




    Approach #2 / Use the height-calc trick so set the height of a wrapper div around the <ag-grid-angular>

    +----------------------------------------------------------------------+
    | Tab Group Page                                                  Help |
    +----------------------------------------------------------------------+
    |                                                                      |
    |  +------------------+-----------------------+---------------------+  |
    |  | User Profile Tab | Open Requests Tab     | All Requests Tab    |  |
    |  +------------------+-----------------------+---------------------+  |
    |  | Open Requests                                                  |  |
    |  |                                                                |  |
    |  | +----------------------------+---------------------+           |  |
    |  | |   A G - G R I D                                  |           |  |  Good news:  The ag-grid has a height that fills the tab
    |  | |   A G - G R I D      Row 2                       |           |  |  Bad news:   We had to manually set the height using the height-calc
    |  | |   A G - G R I D      Row 3                       |           |  |
    |  | |                                                  |           |  |
    |  | |                                                  |           |  |  Using domLayout='normal'
    |  | |                                                  |           |  |  
    |  | |                                                  |           |  |
    |  | |                                                  |           |  |
    |  | |                                                  |           |  |
    |  | |                                                  |           |  |
    |  | |                                                  |           |  |
    |  | |                                                  |           |  |
    |  | +--------------------------------------------------+           |  |
    |  +----------------------------------------------------------------+  |
    +----------------------------------------------------------------------+

```