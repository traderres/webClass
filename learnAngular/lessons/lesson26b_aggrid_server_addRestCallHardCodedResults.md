Lesson 26b:  AG Grid / Server Side / Add REST Call returns Hard-coded Results
-----------------------------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/18RIXqsjsxzFZ1QNC2pvRhCvkNdRPaVOiQJ96MfaUlUI/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson26b/server-side-grid/rest-call
<br>
<br>
<br>

<h3> Problem Set </h3>
Problem: The server side Ag-grid has its own REST endpoint contract.  We need to implement that contract.<br>
Solution: Add a REST endpoint (that ag-grid will call) and return hard-coded results.<br>
<br>
<br>
<br>

```

Procedure
---------
    1. Add the Model Classes to the back-end
       a. Right-click on backend/src/main/java/com/lessons/models -> New Package
          Package Name:  grid

       b. Add this model class:  ColumnFilter
          i.  Right-click on backend/src/main/java/com/lessons/models/grid -> New Java Class
              Class Name:  ColumnFilter

          ii. Copy this to your new class:
                
                package com.lessons.models.grid;
                
                import com.fasterxml.jackson.annotation.JsonSubTypes;
                import com.fasterxml.jackson.annotation.JsonTypeInfo;
                
                @JsonTypeInfo(use = JsonTypeInfo.Id.NAME,
                            include = JsonTypeInfo.As.PROPERTY,
                            property = "filterType")
                @JsonSubTypes({
                        @JsonSubTypes.Type(value = NumberColumnFilter.class, name = "number"),
                        @JsonSubTypes.Type(value = TextColumnFilter.class, name = "text"),
                        @JsonSubTypes.Type(value = SetColumnFilter.class, name = "set") })
                public abstract class ColumnFilter {
                    String filterType;
                }



        c. Add this model class:  ColumnVO
            i.  Right-click on backend/src/main/java/com/lessons/models/grid -> New Java Class
                Class Name:  ColumnVO
	
            ii. Copy this to your new class:
                
                package com.lessons.models.grid;
                
                import java.util.Objects;
                
                public class ColumnVO  {
                    private String id;
                    private String displayName;
                    private String field;
                    private String aggFunc;
                
                    public ColumnVO() {
                    }
                
                    public ColumnVO(String id, String displayName, String field, String aggFunc) {
                        this.id = id;
                        this.displayName = displayName;
                        this.field = field;
                        this.aggFunc = aggFunc;
                    }
                
                    public String getId() {
                        return id;
                    }
                
                    public void setId(String id) {
                        this.id = id;
                    }
                
                    public String getDisplayName() {
                        return displayName;
                    }
                
                    public void setDisplayName(String displayName) {
                        this.displayName = displayName;
                    }
                
                    public String getField() {
                        return field;
                    }
                
                    public void setField(String field) {
                        this.field = field;
                    }
                
                    public String getAggFunc() {
                        return aggFunc;
                    }
                
                    public void setAggFunc(String aggFunc) {
                        this.aggFunc = aggFunc;
                    }
                
                    @Override
                    public boolean equals(Object o) {
                        if (this == o) return true;
                        if (o == null || getClass() != o.getClass()) return false;
                        ColumnVO columnVO = (ColumnVO) o;
                        return Objects.equals(id, columnVO.id) &&
                                Objects.equals(displayName, columnVO.displayName) &&
                                Objects.equals(field, columnVO.field) &&
                                Objects.equals(aggFunc, columnVO.aggFunc);
                    }
                
                    @Override
                    public int hashCode() {
                        return Objects.hash(id, displayName, field, aggFunc);
                    }
                }




        d. Add this model class:  FilterRequest
            i.  Right-click on backend/src/main/java/com/lessons/models/grid -> New Java Class
                Class Name:  FilterRequest
	
            ii. Copy this to your new class:
                
                package com.lessons.models.grid;
                
                import java.util.Map;
                
                public class FilterRequest {
                
                    private Map<String, ColumnFilter> filterModel;
                
                    public FilterRequest() {}
                
                    public FilterRequest(Map<String, ColumnFilter> filterModel) {
                        this.filterModel = filterModel;
                    }
                
                    public Map<String, ColumnFilter> getFilterModel() {
                        return filterModel;
                    }
                
                    public void setFilterModel(Map<String, ColumnFilter> filterModel) {
                        this.filterModel = filterModel;
                    }
                
                    @Override
                    public String toString() {
                        return "FilterRequest{" +
                                "filterModel=" + filterModel +
                                '}';
                    }
                }




        e. Add this model class:  NumberColumnFilter
            i.  Right-click on backend/src/main/java/com/lessons/models/grid -> New Java Class
                Class Name:  NumberColumnFilter
	
            ii. Copy this to your new class:
                    
                    package com.lessons.models.grid;
                    
                    public class NumberColumnFilter extends ColumnFilter {
                        private String type;
                        private Integer filter;
                        private Integer filterTo;
                    
                        public NumberColumnFilter() {}
                    
                        public NumberColumnFilter(String type, Integer filter, Integer filterTo) {
                            this.type = type;
                            this.filter = filter;
                            this.filterTo = filterTo;
                        }
                    
                        public String getFilterType() {
                            return filterType;
                        }
                    
                        public String getType() {
                            return type;
                        }
                    
                        public Integer getFilter() {
                            return filter;
                        }
                    
                        public Integer getFilterTo() {
                            return filterTo;
                        }
                    }




        f. Add this model class:  SetColumnFilter
            i. Right-click on backend/src/main/java/com/lessons/models/grid -> New Java Class
               Class Name:  SetColumnFilter
	
            ii. Copy this to your new class:
                    
                    package com.lessons.models.grid;
                    
                    import java.util.List;
                    
                    public class SetColumnFilter extends ColumnFilter {
                        private List<String> values;
                    
                        public SetColumnFilter() {}
                    
                        public SetColumnFilter(List<String> values) {
                            this.values = values;
                        }
                    
                        public List<String> getValues() {
                            return values;
                        }
                    }




        g. Add this model class:  SortModel
            i. Right-click on backend/src/main/java/com/lessons/models/grid -> New Java Class
               Class Name:  SortModel
	
            ii. Copy this to your new class:
                    
                    package com.lessons.models.grid;
                    
                    import java.io.Serializable;
                    
                    public class SortModel implements Serializable {
                    
                        private String colId;
                        private String sort;
                    
                        public SortModel() {}
                    
                        public SortModel(String colId, String sort) {
                            this.colId = colId;
                            this.sort = sort;
                        }
                    
                        public String getColId() {
                            return colId;
                        }
                    
                        public void setColId(String colId) {
                            this.colId = colId;
                        }
                    
                        public String getSort() {
                            return sort;
                        }
                    
                        public void setSort(String sort) {
                            this.sort = sort;
                        }
                    
                    }




        h. Add this model class:  TextColumnFilter
            i. Right-click on backend/src/main/java/com/lessons/models/grid -> New Java Class
               Class Name:  TextColumnFilter
	
            ii. Copy this to your new class:
                
                package com.lessons.models.grid;
                
                public class TextColumnFilter extends ColumnFilter {
                    private String type;
                    private String filter;
                    private String filterTo;
                
                    public TextColumnFilter() {}
                
                    public TextColumnFilter(String type, String filter, String filterTo) {
                        this.type = type;
                        this.filter = filter;
                        this.filterTo = filterTo;
                    }
                
                    public String getFilterType() {
                        return filterType;
                    }
                
                    public String getType() {
                        return type;
                    }
                
                    public String getFilter() {
                        return filter;
                    }
                
                    public String getFilterTo() {
                        return filterTo;
                    }
                }




        i. Add this model class:  GridGetRowsRequestDTO
            i. Right-click on backend/src/main/java/com/lessons/models/grid -> New Java Class
               Class Name:  GridGetRowsRequestDTO
	
            ii. Copy this to your new class:
                
                package com.lessons.models.grid;
                
                import com.fasterxml.jackson.annotation.JsonProperty;
                import java.util.List;
                import java.util.Map;
                import static java.util.Collections.emptyList;
                import static java.util.Collections.emptyMap;
                
                public class GridGetRowsRequestDTO {
                
                    @JsonProperty("startRow")
                    private int startRow;
                
                    @JsonProperty("endRow")
                    private int endRow;
                
                    // row group columns
                    @JsonProperty("rowGroupCols")
                    private List<ColumnVO> rowGroupCols;
                
                    // value columns
                    @JsonProperty("valueCols")
                    private List<ColumnVO> valueCols;
                
                    // pivot columns
                    @JsonProperty("pivotCols")
                    private List<ColumnVO> pivotCols;
                
                    // true if pivot mode is one, otherwise false
                    @JsonProperty("pivotMode")
                    private boolean pivotMode;
                
                    // what groups the user is viewing
                    @JsonProperty("groupKeys")
                    private List<String> groupKeys;
                
                    // if filtering, what the filter model is
                    @JsonProperty("filterModel")
                    private Map<String, ColumnFilter> filterModel;
                
                    // if sorting, what the sort model is
                    @JsonProperty("sortModel")
                    private List<SortModel> sortModel;
                
                    @JsonProperty("rawSearchQuery")
                    private String rawSearchQuery;
                
                    @JsonProperty("searchAfterClause")
                    private String searchAfterClause;
                
                
                    // ------------------- Constructor, Getters, and Setters -----------------------------
                
                    public GridGetRowsRequestDTO() {
                        this.rowGroupCols = emptyList();
                        this.valueCols = emptyList();
                        this.pivotCols = emptyList();
                        this.groupKeys = emptyList();
                        this.filterModel = emptyMap();
                        this.sortModel = emptyList();
                    }
                
                
                    public int getStartRow() {
                        return startRow;
                    }
                
                    public void setStartRow(int startRow) {
                        this.startRow = startRow;
                    }
                
                    public int getEndRow() {
                        return endRow;
                    }
                
                    public void setEndRow(int endRow) {
                        this.endRow = endRow;
                    }
                
                    public List<ColumnVO> getRowGroupCols() {
                        return rowGroupCols;
                    }
                
                    public void setRowGroupCols(List<ColumnVO> rowGroupCols) {
                        this.rowGroupCols = rowGroupCols;
                    }
                
                    public List<ColumnVO> getValueCols() {
                        return valueCols;
                    }
                
                    public void setValueCols(List<ColumnVO> valueCols) {
                        this.valueCols = valueCols;
                    }
                
                    public List<ColumnVO> getPivotCols() {
                        return pivotCols;
                    }
                
                    public void setPivotCols(List<ColumnVO> pivotCols) {
                        this.pivotCols = pivotCols;
                    }
                
                    public boolean isPivotMode() {
                        return pivotMode;
                    }
                
                    public void setPivotMode(boolean pivotMode) {
                        this.pivotMode = pivotMode;
                    }
                
                    public List<String> getGroupKeys() {
                        return groupKeys;
                    }
                
                    public void setGroupKeys(List<String> groupKeys) {
                        this.groupKeys = groupKeys;
                    }
                
                    public Map<String, ColumnFilter> getFilterModel() {
                        return filterModel;
                    }
                
                    public void setFilterModel(Map<String, ColumnFilter> filterModel) {
                        this.filterModel = filterModel;
                    }
                
                    public List<SortModel> getSortModel() {
                        return sortModel;
                    }
                
                    public void setSortModel(List<SortModel> sortModel) {
                        this.sortModel = sortModel;
                    }
                
                    public String getSearchAfterClause() {
                        return searchAfterClause;
                    }
                
                    public void setSearchAfterClause(String searchAfterClause) {
                        this.searchAfterClause = searchAfterClause;
                    }
                
                    public String getRawSearchQuery() {
                        return rawSearchQuery;
                    }
                
                    public void setRawSearchQuery(String rawSearchQuery) {
                        this.rawSearchQuery = rawSearchQuery;
                    }
                }


        j. Add this model class:  GridGetRowsResponseDTO
            i. Right-click on backend/src/main/java/com/lessons/models/grid -> New Java Class
               Class Name:  GridGetRowsResponseDTO
	
            ii. Copy this to your new class:
                
                package com.lessons.models.grid;
                
                import com.fasterxml.jackson.annotation.JsonProperty;
                import java.util.List;
                import java.util.Map;
                
                public class GridGetRowsResponseDTO {
                
                    @JsonProperty("data")
                    private List<Map<String, Object>> data;
                
                    @JsonProperty("lastRow")
                    private Integer lastRow;
                
                    @JsonProperty("totalMatches")
                    private Integer totalMatches;
                
                    @JsonProperty("secondaryColumnFields")
                    private List<String> secondaryColumnFields;
                
                    @JsonProperty("searchAfterClause")
                    private String searchAfterClause;
                
                    // --------------- Constructor, Getters, and Setters -------------------------------/
                
                    public GridGetRowsResponseDTO(List<Map<String, Object>> data, Integer totalMatches, Integer aLastRow, String aSearchAfterClause) {
                        this.data = data;
                        this.totalMatches = totalMatches;
                        this.lastRow = aLastRow;
                        this.searchAfterClause = aSearchAfterClause;
                    }
                
                    public List<Map<String, Object>> getData() {
                        return data;
                    }
                
                    public void setData(List<Map<String, Object>> data) {
                        this.data = data;
                    }
                
                    public Integer getLastRow() {
                        return lastRow;
                    }
                
                    public void setLastRow(Integer lastRow) {
                        this.lastRow = lastRow;
                    }
                
                    public Integer getTotalMatches() {
                        return totalMatches;
                    }
                
                    public void setTotalMatches(Integer totalMatches) {
                        this.totalMatches = totalMatches;
                    }
                
                    public List<String> getSecondaryColumnFields() {
                        return secondaryColumnFields;
                    }
                
                    public void setSecondaryColumnFields(List<String> secondaryColumnFields) {
                        this.secondaryColumnFields = secondaryColumnFields;
                    }
                
                    public String getSearchAfterClause() {
                        return searchAfterClause;
                    }
                
                    public void setSearchAfterClause(String searchAfterClause) {
                        this.searchAfterClause = searchAfterClause;
                    }
                }
                





    2. Add this java class:  GridService
       a. Right-click on backend/src/main/java/com/lessons/services -> New Java Class
          Class Name:  GridService
	
       b. Copy this to your new class:
            
            package com.lessons.services;
            
            import com.lessons.models.grid.*;
            import org.slf4j.Logger;
            import org.slf4j.LoggerFactory;
            import org.springframework.stereotype.Service;
            import java.util.Arrays;
            import java.util.HashMap;
            import java.util.List;
            import java.util.Map;
            
            
            @Service
            public class GridService {
                private static final Logger logger = LoggerFactory.getLogger(GridService.class);
            
            
                /**
                *  1. Run a search
                *  2. Put the results into a list
                *  3. Create a GridGetRowsResponseDTO object
                *  4. Return the GridGetRowsResponseDTO object
                *
                * @param aGridRequestDTO holds information about the request
                * @return holds the response object (that holds the list of data and meta data)
                */
            public GridGetRowsResponseDTO getPageOfData(String aIndexName, List<String> aFieldsToSearch, GridGetRowsRequestDTO aGridRequestDTO) throws Exception {
            
                    logger.debug("getPageOfData()  startRow={}   endRow={}", aGridRequestDTO.getStartRow(), aGridRequestDTO.getEndRow() );
            
            
                    Map<String, Object> map1 = new HashMap<>();
                    map1.put("id", 1);
                    map1.put("display_name", "Report 1");
                    map1.put("priority", "low");
                    map1.put("description", "This is the description of report 1");
            
                    Map<String, Object> map2 = new HashMap<>();
                    map2.put("id", 2);
                    map2.put("display_name", "Report 2");
                    map2.put("priority", "low");
                    map2.put("description", "This is the description of report 2");
            
                    Map<String, Object> map3 = new HashMap<>();
                    map3.put("id", 3);
                    map3.put("display_name", "Report 3");
                    map3.put("priority", "medium");
                    map3.put("description", "This is the description of report 3");
            
                    List<Map<String, Object>> listOfData = Arrays.asList(map1, map2, map3);
            
                    int totalMatches = 3;
            
            
                    int agGridLastRow;
            
                    // Set the lastRow  (so the ag-grid's infinite scrolling works correctly)
                    if (aGridRequestDTO.getEndRow() < totalMatches ) {
                        // This is not the last page.  So, set lastRow=-1  (which turns on infinite scrolling)
                        agGridLastRow = -1;
                    }
                    else {
                        // This is the last page.  So, set lastRow=totalMatches (which turns off infinite scrolling)
                        agGridLastRow = totalMatches;
                    }
            
            
                    // Create a responseDTO object that has the information that ag-grid needs
                    GridGetRowsResponseDTO responseDTO = new GridGetRowsResponseDTO(listOfData, totalMatches, agGridLastRow, null);
            
                    return responseDTO;
                }
            
            }



    3. Add this java class:  GridController    (holds the REST endpoint that ag-grid invokes)
       a. Right-click on backend/src/main/java/com/lessons/controllers -> New Java Class
          Class Name:  GridController
	
       b. Copy this to your new class:
            
            package com.lessons.controllers;
            
            import com.lessons.models.grid.GridGetRowsRequestDTO;
            import com.lessons.models.grid.GridGetRowsResponseDTO;
            import com.lessons.services.GridService;
            import org.slf4j.Logger;
            import org.slf4j.LoggerFactory;
            import org.springframework.http.HttpStatus;
            import org.springframework.http.ResponseEntity;
            import org.springframework.stereotype.Controller;
            import org.springframework.web.bind.annotation.RequestBody;
            import org.springframework.web.bind.annotation.RequestMapping;
            import org.springframework.web.bind.annotation.RequestMethod;
            import javax.annotation.Resource;
            import java.util.Arrays;
            import java.util.List;
            
            @Controller
            public class GridController {
                private static final Logger logger = LoggerFactory.getLogger(GridController.class);
            
                @Resource
                private GridService gridService;
            
            
                /**
                * The AG-Grid calls this REST endpoint to load the grid in server-side mode
                *
                * @param aGridRequestDTO holds the Request information
                * @return ResponseEntity that holds a GridGetRowsResponseDTO object
                * @throws Exception if something bad happens
                */
                @RequestMapping(value = "/api/grid/getRows", method = RequestMethod.POST, produces = "application/json")
                public ResponseEntity<?> getRows(@RequestBody GridGetRowsRequestDTO aGridRequestDTO) throws Exception {
                    logger.debug("getRows() started.");
            
                    // Create an array of ES fields to search
                    List<String> esFieldsToSearch = Arrays.asList("id.sort", "description", "display_name.sort", "priority.sort");
            
                    // Invoke the GridService to run a search
                    GridGetRowsResponseDTO responseDTO = gridService.getPageOfData("reports", esFieldsToSearch, aGridRequestDTO);
            
                    // Return the responseDTO object and a 200 status code
                    return ResponseEntity
                            .status(HttpStatus.OK)
                            .body(responseDTO);
                }
            
            }


    4. Make sure the webapp still compiles
       Pull Build -> Rebuild Project



```
