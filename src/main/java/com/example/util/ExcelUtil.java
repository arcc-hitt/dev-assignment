package com.example.util;

import com.example.model.Prefix;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

/**
 * Utility class for Excel file operations including import, export, and template generation.
 * Handles Apache POI operations for prefix data management.
 */
@Component
public class ExcelUtil {
    
    private static final Logger logger = LoggerFactory.getLogger(ExcelUtil.class);
    
    // Excel column indices
    private static final int SEARCH_PREFIX_COLUMN = 0;
    private static final int GENDER_COLUMN = 1;
    private static final int PREFIX_OF_COLUMN = 2;
    
    // Expected header values
    private static final String EXPECTED_HEADER_SEARCH_PREFIX = "Search Prefix";
    private static final String EXPECTED_HEADER_GENDER = "Gender";
    private static final String EXPECTED_HEADER_PREFIX_OF = "Prefix Of";
    
    // Sample data identifiers to skip during import
    private static final String SAMPLE_DATA_INDICATOR = "sample";
    private static final String SAMPLE_PREFIX_VALUE = "Mr.";

    /**
     * Exports a list of prefixes to Excel format with proper styling.
     * 
     * @param prefixList List of prefixes to export
     * @return Byte array containing the Excel file data
     * @throws IOException if there's an error writing the Excel file
     */
    public byte[] exportToExcel(List<Prefix> prefixList) throws IOException {
        logger.info("Starting Excel export for {} prefix records", prefixList.size());
        
        try (Workbook excelWorkbook = new XSSFWorkbook()) {
            Sheet dataSheet = excelWorkbook.createSheet("Prefix Records");

            // Create and apply styles
            CellStyle headerCellStyle = createHeaderStyle(excelWorkbook);
            CellStyle dataCellStyle = createDataStyle(excelWorkbook);

            // Create header row
            Row headerRow = dataSheet.createRow(0);
            createHeaderCells(headerRow, headerCellStyle);

            // Create data rows
            int currentRowNumber = 1;
            for (Prefix prefixRecord : prefixList) {
                Row dataRow = dataSheet.createRow(currentRowNumber++);
                populateDataRow(dataRow, prefixRecord, dataCellStyle);
            }

            // Auto-size columns for better appearance
            autoSizeColumns(dataSheet);

            // Convert workbook to byte array
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            excelWorkbook.write(outputStream);
            
            logger.info("Excel export completed successfully, file size: {} bytes", outputStream.size());
            return outputStream.toByteArray();
        } catch (Exception exception) {
            logger.error("Failed to export Excel file: {}", exception.getMessage(), exception);
            throw new IOException("Failed to generate Excel file", exception);
        }
    }

    /**
     * Creates an empty Excel template with sample data and instructions.
     * 
     * @return Byte array containing the Excel template data
     * @throws IOException if there's an error writing the Excel template
     */
    public byte[] createEmptyTemplate() throws IOException {
        logger.info("Creating Excel template with sample data");
        
        try (Workbook templateWorkbook = new XSSFWorkbook()) {
            Sheet templateSheet = templateWorkbook.createSheet("Prefix Template");

            // Create styles for different elements
            CellStyle headerStyle = createTemplateHeaderStyle(templateWorkbook);
            CellStyle sampleDataStyle = createSampleDataStyle(templateWorkbook);
            CellStyle instructionStyle = createInstructionStyle(templateWorkbook);

            // Add instruction row
            Row instructionRow = templateSheet.createRow(0);
            Cell instructionCell = instructionRow.createCell(0);
            instructionCell.setCellValue("INSTRUCTIONS: Fill in the data starting from row 3. Delete the sample data in row 3 before uploading.");
            instructionCell.setCellStyle(instructionStyle);
            templateSheet.addMergedRegion(new org.apache.poi.ss.util.CellRangeAddress(0, 0, 0, 2));

            // Create header row
            Row headerRow = templateSheet.createRow(1);
            createHeaderCells(headerRow, headerStyle);

            // Add sample data row
            Row sampleDataRow = templateSheet.createRow(2);
            createSampleDataRow(sampleDataRow, sampleDataStyle);

            // Auto-size columns
            autoSizeColumns(templateSheet);

            // Convert to byte array
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            templateWorkbook.write(outputStream);
            
            logger.info("Excel template created successfully, file size: {} bytes", outputStream.size());
            return outputStream.toByteArray();
        } catch (Exception exception) {
            logger.error("Failed to create Excel template: {}", exception.getMessage(), exception);
            throw new IOException("Failed to generate Excel template", exception);
        }
    }

    /**
     * Imports prefix data from an uploaded Excel file.
     * 
     * @param uploadedFile The Excel file to import
     * @return List of parsed prefix objects
     * @throws IOException if there's an error reading the Excel file
     */
    public List<Prefix> importFromExcel(MultipartFile uploadedFile) throws IOException {
        logger.info("Starting Excel import from file: {}", uploadedFile.getOriginalFilename());
        
        List<Prefix> importedPrefixes = new ArrayList<>();

        try (InputStream fileInputStream = uploadedFile.getInputStream();
             Workbook excelWorkbook = WorkbookFactory.create(fileInputStream)) {

            Sheet dataSheet = excelWorkbook.getSheetAt(0);
            logger.debug("Processing Excel sheet: {}", dataSheet.getSheetName());

            // Find the header row
            int headerRowIndex = findHeaderRowIndex(dataSheet);
            if (headerRowIndex == -1) {
                throw new IOException("Invalid Excel format. Header row not found. Expected 'Search Prefix' in the first column of header row.");
            }

            // Process data rows starting from header row + 1
            int processedRows = 0;
            for (int rowIndex = headerRowIndex + 1; rowIndex <= dataSheet.getLastRowNum(); rowIndex++) {
                Row currentRow = dataSheet.getRow(rowIndex);
                if (currentRow != null) {
                    Prefix parsedPrefix = parseRowToPrefix(currentRow);
                    if (parsedPrefix != null && isValidPrefixData(parsedPrefix)) {
                        importedPrefixes.add(parsedPrefix);
                        processedRows++;
                    }
                }
            }
            
            logger.info("Excel import completed: {} valid records processed out of {} total rows", 
                    processedRows, dataSheet.getLastRowNum() - headerRowIndex);
        } catch (Exception exception) {
            logger.error("Failed to import Excel file: {}", exception.getMessage(), exception);
            throw new IOException("Failed to process Excel file: " + exception.getMessage(), exception);
        }

        return importedPrefixes;
    }

    /**
     * Creates a header style for Excel cells with blue background and bold font.
     * 
     * @param workbook The workbook to create the style in
     * @return Configured cell style
     */
    private CellStyle createHeaderStyle(Workbook workbook) {
        CellStyle headerStyle = workbook.createCellStyle();
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerFont.setFontHeightInPoints((short) 12);
        headerStyle.setFont(headerFont);
        headerStyle.setFillForegroundColor(IndexedColors.LIGHT_BLUE.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        headerStyle.setBorderBottom(BorderStyle.THIN);
        headerStyle.setBorderTop(BorderStyle.THIN);
        headerStyle.setBorderLeft(BorderStyle.THIN);
        headerStyle.setBorderRight(BorderStyle.THIN);
        return headerStyle;
    }

    /**
     * Creates a template header style with green background.
     * 
     * @param workbook The workbook to create the style in
     * @return Configured cell style
     */
    private CellStyle createTemplateHeaderStyle(Workbook workbook) {
        CellStyle headerStyle = workbook.createCellStyle();
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerFont.setFontHeightInPoints((short) 12);
        headerStyle.setFont(headerFont);
        headerStyle.setFillForegroundColor(IndexedColors.LIGHT_GREEN.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        headerStyle.setBorderBottom(BorderStyle.THIN);
        headerStyle.setBorderTop(BorderStyle.THIN);
        headerStyle.setBorderLeft(BorderStyle.THIN);
        headerStyle.setBorderRight(BorderStyle.THIN);
        return headerStyle;
    }

    /**
     * Creates a data style for regular data cells.
     * 
     * @param workbook The workbook to create the style in
     * @return Configured cell style
     */
    private CellStyle createDataStyle(Workbook workbook) {
        CellStyle dataStyle = workbook.createCellStyle();
        dataStyle.setBorderBottom(BorderStyle.THIN);
        dataStyle.setBorderTop(BorderStyle.THIN);
        dataStyle.setBorderLeft(BorderStyle.THIN);
        dataStyle.setBorderRight(BorderStyle.THIN);
        return dataStyle;
    }

    /**
     * Creates a sample data style with italic grey font.
     * 
     * @param workbook The workbook to create the style in
     * @return Configured cell style
     */
    private CellStyle createSampleDataStyle(Workbook workbook) {
        CellStyle sampleStyle = workbook.createCellStyle();
        Font sampleFont = workbook.createFont();
        sampleFont.setItalic(true);
        sampleFont.setColor(IndexedColors.GREY_50_PERCENT.getIndex());
        sampleStyle.setFont(sampleFont);
        sampleStyle.setBorderBottom(BorderStyle.THIN);
        sampleStyle.setBorderTop(BorderStyle.THIN);
        sampleStyle.setBorderLeft(BorderStyle.THIN);
        sampleStyle.setBorderRight(BorderStyle.THIN);
        return sampleStyle;
    }

    /**
     * Creates an instruction style with bold red font.
     * 
     * @param workbook The workbook to create the style in
     * @return Configured cell style
     */
    private CellStyle createInstructionStyle(Workbook workbook) {
        CellStyle instructionStyle = workbook.createCellStyle();
        Font instructionFont = workbook.createFont();
        instructionFont.setBold(true);
        instructionFont.setColor(IndexedColors.DARK_RED.getIndex());
        instructionStyle.setFont(instructionFont);
        return instructionStyle;
    }

    /**
     * Creates header cells with appropriate labels.
     * 
     * @param headerRow The row to create headers in
     * @param headerStyle The style to apply to header cells
     */
    private void createHeaderCells(Row headerRow, CellStyle headerStyle) {
        Cell searchPrefixHeader = headerRow.createCell(SEARCH_PREFIX_COLUMN);
        searchPrefixHeader.setCellValue(EXPECTED_HEADER_SEARCH_PREFIX);
        searchPrefixHeader.setCellStyle(headerStyle);

        Cell genderHeader = headerRow.createCell(GENDER_COLUMN);
        genderHeader.setCellValue(EXPECTED_HEADER_GENDER);
        genderHeader.setCellStyle(headerStyle);

        Cell prefixOfHeader = headerRow.createCell(PREFIX_OF_COLUMN);
        prefixOfHeader.setCellValue(EXPECTED_HEADER_PREFIX_OF);
        prefixOfHeader.setCellStyle(headerStyle);
    }

    /**
     * Populates a data row with prefix information.
     * 
     * @param dataRow The row to populate
     * @param prefixRecord The prefix data to use
     * @param dataStyle The style to apply to data cells
     */
    private void populateDataRow(Row dataRow, Prefix prefixRecord, CellStyle dataStyle) {
        Cell searchPrefixCell = dataRow.createCell(SEARCH_PREFIX_COLUMN);
        searchPrefixCell.setCellValue(prefixRecord.getSearchPrefix() != null ? prefixRecord.getSearchPrefix() : "");
        searchPrefixCell.setCellStyle(dataStyle);

        Cell genderCell = dataRow.createCell(GENDER_COLUMN);
        genderCell.setCellValue(prefixRecord.getGender() != null ? prefixRecord.getGender() : "");
        genderCell.setCellStyle(dataStyle);

        Cell prefixOfCell = dataRow.createCell(PREFIX_OF_COLUMN);
        prefixOfCell.setCellValue(prefixRecord.getPrefixOf() != null ? prefixRecord.getPrefixOf() : "");
        prefixOfCell.setCellStyle(dataStyle);
    }

    /**
     * Creates a sample data row for the template.
     * 
     * @param sampleRow The row to populate with sample data
     * @param sampleStyle The style to apply to sample cells
     */
    private void createSampleDataRow(Row sampleRow, CellStyle sampleStyle) {
        Cell sampleSearchPrefix = sampleRow.createCell(SEARCH_PREFIX_COLUMN);
        sampleSearchPrefix.setCellValue(SAMPLE_PREFIX_VALUE);
        sampleSearchPrefix.setCellStyle(sampleStyle);

        Cell sampleGender = sampleRow.createCell(GENDER_COLUMN);
        sampleGender.setCellValue("Male");
        sampleGender.setCellStyle(sampleStyle);

        Cell samplePrefixOf = sampleRow.createCell(PREFIX_OF_COLUMN);
        samplePrefixOf.setCellValue("S/O,H/O,F/O");
        samplePrefixOf.setCellStyle(sampleStyle);
    }

    /**
     * Auto-sizes columns for better appearance.
     * 
     * @param sheet The sheet to auto-size columns in
     */
    private void autoSizeColumns(Sheet sheet) {
        for (int columnIndex = 0; columnIndex < 3; columnIndex++) {
            sheet.autoSizeColumn(columnIndex);
            // Add extra width for better appearance
            int currentWidth = sheet.getColumnWidth(columnIndex);
            sheet.setColumnWidth(columnIndex, currentWidth + 1000);
        }
    }

    /**
     * Finds the index of the header row in the Excel sheet.
     * 
     * @param sheet The sheet to search in
     * @return The row index of the header, or -1 if not found
     */
    private int findHeaderRowIndex(Sheet sheet) {
        for (int rowIndex = 0; rowIndex <= sheet.getLastRowNum(); rowIndex++) {
            Row currentRow = sheet.getRow(rowIndex);
            if (currentRow != null) {
                Cell firstCell = currentRow.getCell(0);
                if (firstCell != null && firstCell.getCellType() == CellType.STRING) {
                    String cellValue = firstCell.getStringCellValue().trim();
                    if (EXPECTED_HEADER_SEARCH_PREFIX.equalsIgnoreCase(cellValue)) {
                        return rowIndex;
                    }
                }
            }
        }
        return -1;
    }

    /**
     * Parses a row from Excel into a Prefix object.
     * 
     * @param row The Excel row to parse
     * @return Parsed Prefix object, or null if no valid data
     */
    private Prefix parseRowToPrefix(Row row) {
        Prefix parsedPrefix = new Prefix();
        boolean hasValidData = false;

        // Parse Search Prefix (required field)
        Cell searchPrefixCell = row.getCell(SEARCH_PREFIX_COLUMN);
        if (searchPrefixCell != null) {
            String searchPrefixValue = getCellValueAsString(searchPrefixCell).trim();
            if (!searchPrefixValue.isEmpty() && !isSampleData(searchPrefixValue)) {
                parsedPrefix.setSearchPrefix(searchPrefixValue);
                hasValidData = true;
            }
        }

        // Parse Gender (optional field)
        Cell genderCell = row.getCell(GENDER_COLUMN);
        if (genderCell != null) {
            String genderValue = getCellValueAsString(genderCell).trim();
            parsedPrefix.setGender(genderValue.isEmpty() ? null : genderValue);
        }

        // Parse Prefix Of (optional field)
        Cell prefixOfCell = row.getCell(PREFIX_OF_COLUMN);
        if (prefixOfCell != null) {
            String prefixOfValue = getCellValueAsString(prefixOfCell).trim();
            parsedPrefix.setPrefixOf(prefixOfValue.isEmpty() ? null : prefixOfValue);
        }

        return hasValidData ? parsedPrefix : null;
    }

    /**
     * Validates if the parsed prefix data is valid for import.
     * 
     * @param prefixRecord The prefix record to validate
     * @return true if valid, false otherwise
     */
    private boolean isValidPrefixData(Prefix prefixRecord) {
        return prefixRecord.getSearchPrefix() != null && 
               !prefixRecord.getSearchPrefix().isEmpty() &&
               !isSampleData(prefixRecord.getSearchPrefix());
    }

    /**
     * Checks if a value represents sample data that should be skipped.
     * 
     * @param value The value to check
     * @return true if it's sample data, false otherwise
     */
    private boolean isSampleData(String value) {
        return value.toLowerCase().contains(SAMPLE_DATA_INDICATOR) || 
               SAMPLE_PREFIX_VALUE.equals(value);
    }

    /**
     * Extracts string value from an Excel cell regardless of its type.
     * 
     * @param cell The cell to extract value from
     * @return String representation of the cell value
     */
    private String getCellValueAsString(Cell cell) {
        if (cell == null) {
            return "";
        }

        switch (cell.getCellType()) {
            case STRING:
                return cell.getStringCellValue();
            case NUMERIC:
                if (DateUtil.isCellDateFormatted(cell)) {
                    return cell.getDateCellValue().toString();
                } else {
                    return String.valueOf((long) cell.getNumericCellValue());
                }
            case BOOLEAN:
                return String.valueOf(cell.getBooleanCellValue());
            case FORMULA:
                return cell.getCellFormula();
            case BLANK:
                return "";
            default:
                return "";
        }
    }
}