Lesson 14b:  Downloads / Download File Outside Web App
------------------------------------------------------
The Google Drive link is here:<br>
&nbsp;&nbsp;&nbsp;https://docs.google.com/document/d/16A_flxRXCxBCHQ7yd05T75WiwUwYL1evvmp0loBCZeY/edit?usp=sharing
      

The source code for this lesson is here:<br>
&nbsp;&nbsp;&nbsp;https://github.com/traderres/angularApp1Lessons/tree/lesson14b/download/external-file
<br>
<br>
<br>

<h3>Types of External Downloads</h3>

1. Download a string: Create a string and return the string (as bytes)
1. Download an existing file: locate an existing file and return the file contents (as bytes)
1. Create an excel workbook in memory and return that (as bytes)

  
  

<br>
<br>

<h3>Approach</h3>

1. Change the "View Reports" so that each report has a download button

   1. Edit "View Reports"
   1. Add a "Download" button icon
   1. Clicking on the "Download" button icon should call a method with 2 lines:  
      ```    
      public download(aReportId: number): void {  
         const url = environment.baseUrl + \`/api/reports/download/${aReportId}\`;  
         window.open(url);  
      }  
      ```

1. Create a back-end REST call that will build a file from a string and return the bytes  

1. Create a back-end REST call that will locate an existing file and return the contents as bytes  

1. Create a back-end REST call that will create a spreadsheet in memory and return the bytes

  


<br>
<br>

```
Procedure
---------
    1. Change the "View Reports" so that each report has a download button
        a. Edit view-reports.component.ts

        b. Add this method:

              public download(aReportId: number): void {
                    const url = environment.baseUrl + `/api/reports/download/${aReportId}`;
                    window.open(url);
              }



        c. Edit view-reports.component.html

        d. Add a button icon next to the "Edit" button that will call the new download() method
           -- So, we're using the mat-icon-button directive on the button tag
           -- We're using Font Awesome's download icon   

                <button mat-icon-button (click)="this.download(report.id)"  title="Download File">
                            <i class="fa fa-download"></i>
                </button>



    2. Verify that you can see "Download" icon
        a. Activate the Debugger -> Full WebApp

        b. Go to View Reports
           NOTE:  If "View Reports" is empty, then go to "Add Report 2" to add some reports

        c. On the "View Reports" page, you should see an icon button next to the "Edit" button
```
![](https://lh4.googleusercontent.com/SW_RL3iYinhlJ8Z4nM2TpUxMxh7TfTCq2NfeBxZtXMPNGqnciYcRKJPkyTtgkbKZtOJ-ehduJ-DfiBSKMNZc5qDgKfRKIC_cx-ZSdhJ2fmueyG4hRMR1tJMCGxmnTbOfQHW32W5H)

```






    3. Create a back-end REST call that will build a file from a string and return the bytes
        a. Edit ReportController.java

        b. Add this method:
            
            /*
             * Download Report REST Endpoint that returns a string as a file
             * GET /api/reports/download/{reportId}
             */
            @RequestMapping(value = "/api/reports/download/{reportId}", method = RequestMethod.GET)
            public  ResponseEntity<?>  downloadFileFromString(@PathVariable(value="reportId") Integer aReportId) {
                logger.debug("downloadFileFromString started.");
            
                // Create a string (that will hold the downloaded text file contents)
                String fileContents = "Report is here and it's a really long reports....";
            
                // Set the default file name (that the browser will save as....)
                String defaultFileName = "something.txt";
            
                // Create an HttpHeaders object  (this holds your list of headers)
                HttpHeaders headers = new HttpHeaders();
            
                // Set a header with the default name to save this file as
                // -- So, the browser will do a Save As….
                headers.setContentDispositionFormData("attachment", defaultFileName);
            
            
                // Return the ResponseEntity object with the special headers
                // -- This will cause the browser to do a Save File As.... operation
                return ResponseEntity
                        .status(HttpStatus.OK)
                        .headers(headers)
                        .body(fileContents.getBytes(StandardCharsets.UTF_8));
            }


    4. Verify it works
        a. Activate the Debugger -> Full WebApp
        b. Go to View Reports
        c. Click the "Download" icon
           -- You should be prompted to open/save as a small text file


    5. Create a back-end REST call that will locate an existing file and return the contents as bytes
        a. Get the path of a file on your filesystem -- e.g., "/tmp/stuff2.txt"  or  "c:/temp/stuff3.txt"

        b. Edit ReportController.java

        c. Add this method:
            
            /*
             * Download Report REST Endpoint that returns an existing file to the front-end
             * GET /api/reports/download/file/{reportId}
             */
            @RequestMapping(value = "/api/reports/download/file/{reportId}", method = RequestMethod.GET)
            public  ResponseEntity<?>  downloadFileLocatedInFileSystem(@PathVariable(value="reportId") Integer aReportId) throws Exception {
                logger.debug("downloadFileLocatedInFileSystem started.");
            
                // Get the a string that holds all of the bytes of an *EXISTING FILE* in the file system
                String filePath = "/tmp/stuff2.txt";
                String fileContents = new String(Files.readAllBytes(Paths.get(filePath)));
            
                // Set the default file name (that the browser will save as....)
                String defaultFileName = "stuff2.txt";
            
                // Create an HttpHeaders object  (this holds your list of headers)
                HttpHeaders headers = new HttpHeaders();
            
                // Set a header with the default name to save this file as
                // -- So, the browser will do a Save As….
                headers.setContentDispositionFormData("attachment", defaultFileName);
            
            
                // Return the ResponseEntity object with the special headers
                // -- This will cause the browser to do a Save File As.... operation
                return ResponseEntity
                        .status(HttpStatus.OK)
                        .headers(headers)
                        .body(fileContents.getBytes(StandardCharsets.UTF_8));
            }


        d. Edit view-reports.component.ts

        e. Change the download() method so it uses a new REST endpoint
            
              public download(aFileId: number): void {
                const url = environment.baseUrl + `/api/reports/download/file/${aFileId}`;
                window.open(url);
              }


    6. Verify it works
        a. Activate the Debugger -> Full WebApp
        b. Go to View Reports
        c. Click the "Download" icon
           -- You should be prompted to open/save as a small text file that exists on your filesystem


    7. Create a back-end REST call that will create a spreadsheet in memory and return the bytes
        a. Add the apache poi dependency to your backend/pom.xml

            <dependency>
                <!-- Apache POI dependency (used to generate xlsx files) -->
                <groupId>org.apache.poi</groupId>
                <artifactId>poi-ooxml</artifactId>
                <version>4.1.2</version>
            </dependency>


        b. Right-click on pom.xml -> Maven -> Reload Project


    8. Add this service:  Excel Service
        a. Right-click on backend/src/java/com/lessons/services -> New Java Class
           Class Name:  ExcelService

        b. Copy this to your newly-created class:
            
            package com.lessons.services;
            
            import org.apache.poi.hssf.usermodel.HSSFPalette;
            import org.apache.poi.hssf.usermodel.HSSFWorkbook;
            import org.apache.poi.hssf.util.HSSFColor;
            import org.apache.poi.ss.usermodel.*;
            import org.apache.poi.ss.util.CellRangeAddress;
            import org.apache.poi.ss.util.CellUtil;
            import org.apache.poi.xssf.streaming.SXSSFSheet;
            import org.apache.poi.xssf.streaming.SXSSFWorkbook;
            import org.slf4j.Logger;
            import org.slf4j.LoggerFactory;
            import org.springframework.stereotype.Service;
            
            import java.io.ByteArrayOutputStream;
            
            @Service("com.lessons.service.ExcelService")
            public class ExcelService {
                private static final Logger logger = LoggerFactory.getLogger(ExcelService.class);
            
            
                public byte[] generateExcelFileAsByteArray() throws Exception {
                    logger.debug("generateExcelFileAsByteArray() started.");
            
                    // Creating a Streaming Workbook instance
                    //    	Keep 100 rows in memory.  The remaining rows will be written to disk
                    //    	+ This does not increase or decrease the time it takes to generate the XLSX file
                    //    	+ This reduces memory consumption
                    SXSSFWorkbook streamingWorkBook = new SXSSFWorkbook(100);
            
                    // Create the worksheet (within this excel workbook)
                    SXSSFSheet sheet = streamingWorkBook.createSheet("Sheet 1");
            
                    // Create the styles (for various cells)
                    CellStyle headerCellStyle  	= getHeaderCellStyle(sheet);
                    CellStyle greenHeaderCellStyle = getGreenHeaderCellStyle(sheet);
                    CellStyle greenCellStyle = getBorderedGreenTextStyle(sheet);
                    CellStyle dataCellStyle = getBorderAndCenteredTextStyle(sheet);
            
                    // Set column widths
                    sheet.setColumnWidth(0, 4000);
                    sheet.setColumnWidth(1, 6000);
                    sheet.setColumnWidth(2, 8000);
                    sheet.setColumnWidth(3, 4000);
            
                    // Row 1:  Title Row
                    int currentRowNumber = 0;
                    Row row = sheet.createRow(currentRowNumber);
                    row.setHeight((short) 600);
            
                    // Create the cells in this row
                    CellUtil.createCell(row, 0, "Bogus Employee List", headerCellStyle);
                    sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 3));	// Merge cells (0,0) to (0,3)
            
                    // Row 2:  Note
                    currentRowNumber++;
                    row = sheet.createRow(currentRowNumber);
                    row.setHeight((short) 400);
                    CellUtil.createCell(row, 0, "NOTE: This shows the salaries of all employees in the company");
            
                    // Row 3:  Empty row
                    currentRowNumber++;
            
            
                    // Row 4:  Header row
                    currentRowNumber++;
                    row = sheet.createRow(currentRowNumber);
                    CellUtil.createCell(row, 0, "Employee ID",  headerCellStyle);
                    CellUtil.createCell(row, 1, "Full Name",	headerCellStyle);
                    CellUtil.createCell(row, 2, "Title",    	headerCellStyle);
                    CellUtil.createCell(row, 3, "Salary",   	greenHeaderCellStyle);
            
                    // Row 5:  Data row
                    currentRowNumber++;
                    row = sheet.createRow(currentRowNumber);
                    CellUtil.createCell(row, 0, "1000",             	dataCellStyle);
                    CellUtil.createCell(row, 1, "Emmet Brown",      	dataCellStyle);
                    CellUtil.createCell(row, 2, "Science & Technology", dataCellStyle);
                    createCell(row,      	3, 80000,              	greenCellStyle);
            
            
                    // Row 6:  Data row
                    currentRowNumber++;
                    row = sheet.createRow(currentRowNumber);
                    CellUtil.createCell(row, 0, "1001",    	dataCellStyle);
                    CellUtil.createCell(row, 1, "Marty McFly", dataCellStyle);
                    CellUtil.createCell(row, 2, "Slacker", 	dataCellStyle);
                    createCell(row,      	3, 30000,     	greenCellStyle);
            
                    // Save the information to the byteArrayOutputStream
                    ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
                    streamingWorkBook.write(byteArrayOutputStream);
            
                    // Dispose of the temporary file (used by the streaming workbook)
                    streamingWorkBook.dispose();
            
                    logger.debug("generateExcelFileAsByteArray() finished.");
            
                    // Convert the byteArrayOutputStream into an array of bytes
                    return byteArrayOutputStream.toByteArray();
                }
            
            
                private CellStyle getBorderedGreenTextStyle(SXSSFSheet aSheet) {
            
                    CellStyle style = aSheet.getWorkbook().createCellStyle();
                    style.setBorderBottom(BorderStyle.HAIR);
                    style.setBorderLeft(BorderStyle.HAIR);
                    style.setBorderRight(BorderStyle.HAIR);
                    style.setBorderTop(BorderStyle.HAIR);
                    style.setAlignment(HorizontalAlignment.CENTER);
            
                    // Get the color index closes to the RGB coordinates
                    short colorIndexForGreen = getGreenColorIndex(aSheet);
            
                    style.setFillForegroundColor(colorIndexForGreen);
                    style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            
                    Font boldFont11 = aSheet.getWorkbook().createFont();
                    boldFont11.setBold(true);
                    boldFont11.setFontHeightInPoints((short) 11);
                    boldFont11.setFontName("Calibri");
                    style.setFont(boldFont11);
            
                    return style;
                }
            
                public short getGreenColorIndex(SXSSFSheet aSheet) {
                    HSSFWorkbook hwb = new HSSFWorkbook();
                    HSSFPalette palette = hwb.getCustomPalette();
                    HSSFColor myColor = palette.findSimilarColor(224, 224, 180);
                    short colorIndexForGreen = myColor.getIndex();
            
                    return colorIndexForGreen;
                }
            
            
                private CellStyle getBorderAndCenteredTextStyle(SXSSFSheet aSheet) {
                    CellStyle style = aSheet.getWorkbook().createCellStyle();
                    style.setBorderBottom(BorderStyle.HAIR);
                    style.setBorderLeft(BorderStyle.HAIR);
                    style.setBorderRight(BorderStyle.HAIR);
                    style.setBorderTop(BorderStyle.HAIR);
            
                    // Center horizontally
                    style.setAlignment(HorizontalAlignment.CENTER);
            
                    // Vertically, push to the bottom
                    style.setVerticalAlignment(VerticalAlignment.BOTTOM);
            
                    return style;
                }
            
            
                private CellStyle getHeaderCellStyle(SXSSFSheet aSheet) {
                    // Build the Header cell style
                    CellStyle style = aSheet.getWorkbook().createCellStyle();
                    Font font = aSheet.getWorkbook().createFont();
                    font.setBold(true);
                    font.setFontHeightInPoints((short) 12);
                    style.setFont(font);
            
                    // Center horizontally
                    style.setAlignment(HorizontalAlignment.CENTER);
            
                    // Vertically, push to the bottom
                    style.setVerticalAlignment(VerticalAlignment.BOTTOM);
            
                    return style;
                }
            
            
                private CellStyle getGreenHeaderCellStyle(SXSSFSheet aSheet) {
                    // Build the Header cell style
                    CellStyle style = aSheet.getWorkbook().createCellStyle();
                    Font font = aSheet.getWorkbook().createFont();
                    font.setBold(true);
                    font.setFontHeightInPoints((short) 12);
                    style.setFont(font);
            
                    // Center horizontally
                    style.setAlignment(HorizontalAlignment.CENTER);
            
                    // Vertically, push to the bottom
                    style.setVerticalAlignment(VerticalAlignment.BOTTOM);
            
                    // Get the color index closes to the RGB coordinates
                    short colorIndexForGreen = getGreenColorIndex(aSheet);
            
                    style.setFillForegroundColor(colorIndexForGreen);
                    style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            
                    return style;
                }
            
                public void createCell(Row aRow, int aColumnNumber, Integer aValue, CellStyle aCellStyle) {
                    Cell cell = aRow.createCell(aColumnNumber);
                    cell.setCellValue(aValue);
            
                    if (aCellStyle != null) {
                        cell.setCellStyle(aCellStyle);
                    }
                }
            
            
            }
            



    9. Add the REST endpoint to your ReportController
        a. Edit ReportController.java


        b. Inject the Excel Service

            @Resource
            private ExcelService excelService;
        

   
        c. Add the REST endpoint that will return a generated excel file::
            
            @RequestMapping(value = "/api/reports/download/excel/{reportId}", 
                                                                                                  method =RequestMethod.GET)
            public ResponseEntity<?> downloadExcelFile(
                                              @PathVariable(value="reportId") Integer aReportId) throws Exception {
                logger.debug("downloadExcelFile() started.");
            
                // Generate an excel file as a byte array
                byte[] excelFileAsByteArray = excelService.generateExcelFileAsByteArray();
            
                // Set a header to tell the browser to prompt the user to save as 'something.xlsx'
                // -- So, the browser will do a Save As….
                HttpHeaders headers = new HttpHeaders();
                headers.setContentDispositionFormData("attachment", "something.xlsx");
            
                // Set a header with the length of the file
                // -- so the browser will know total file size is -- and be able to show download %
                headers.setContentLength(excelFileAsByteArray.length);
            
                // Return the byte-array back to the front-end
                return ResponseEntity
                        .status(HttpStatus.OK)
                        .headers(headers)
                        .body(excelFileAsByteArray);
            }


    10. Change the front-end so it uses the new rest endpoint
        a. Edit view-reports.component.ts

        b. Change the download() method so it uses a new REST endpoint
            
              public download(aFileId: number): void {
                const url = environment.baseUrl + `/api/reports/download/excel/${aFileId}`;
                window.open(url);
              }


    11. Verify it works
        a. Activate the Debugger -> Full WebApp
        b. Go to View Reports
        c. Click the "Download" icon
           -- You should be prompted to open/save as a spreadsheet file



```
