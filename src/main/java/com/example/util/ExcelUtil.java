package com.example.util;

import com.example.model.Prefix;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

@Component
public class ExcelUtil {

    /**
     * Export prefix list to Excel format
     */
    public byte[] exportToExcel(List<Prefix> prefixes) throws IOException {
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Prefix Records");

            // Create header style
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

            // Create data style
            CellStyle dataStyle = workbook.createCellStyle();
            dataStyle.setBorderBottom(BorderStyle.THIN);
            dataStyle.setBorderTop(BorderStyle.THIN);
            dataStyle.setBorderLeft(BorderStyle.THIN);
            dataStyle.setBorderRight(BorderStyle.THIN);

            // Create header row
            Row headerRow = sheet.createRow(0);

            Cell cell1 = headerRow.createCell(0);
            cell1.setCellValue("Search Prefix");
            cell1.setCellStyle(headerStyle);

            Cell cell2 = headerRow.createCell(1);
            cell2.setCellValue("Gender");
            cell2.setCellStyle(headerStyle);

            Cell cell3 = headerRow.createCell(2);
            cell3.setCellValue("Prefix Of");
            cell3.setCellStyle(headerStyle);

            // Create data rows
            int rowNum = 1;
            for (Prefix prefix : prefixes) {
                Row row = sheet.createRow(rowNum++);

                Cell dataCell1 = row.createCell(0);
                dataCell1.setCellValue(prefix.getSearchPrefix() != null ? prefix.getSearchPrefix() : "");
                dataCell1.setCellStyle(dataStyle);

                Cell dataCell2 = row.createCell(1);
                dataCell2.setCellValue(prefix.getGender() != null ? prefix.getGender() : "");
                dataCell2.setCellStyle(dataStyle);

                Cell dataCell3 = row.createCell(2);
                dataCell3.setCellValue(prefix.getPrefixOf() != null ? prefix.getPrefixOf() : "");
                dataCell3.setCellStyle(dataStyle);
            }

            // Auto-size columns
            for (int i = 0; i < 3; i++) {
                sheet.autoSizeColumn(i);
                // Add some extra width for better appearance
                sheet.setColumnWidth(i, sheet.getColumnWidth(i) + 1000);
            }

            // Convert to byte array
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            workbook.write(outputStream);
            return outputStream.toByteArray();
        }
    }

    /**
     * Create an empty Excel template with sample data
     */
    public byte[] createEmptyTemplate() throws IOException {
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Prefix Template");

            // Create header style
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

            // Create sample data style
            CellStyle sampleStyle = workbook.createCellStyle();
            Font sampleFont = workbook.createFont();
            sampleFont.setItalic(true);
            sampleFont.setColor(IndexedColors.GREY_50_PERCENT.getIndex());
            sampleStyle.setFont(sampleFont);
            sampleStyle.setBorderBottom(BorderStyle.THIN);
            sampleStyle.setBorderTop(BorderStyle.THIN);
            sampleStyle.setBorderLeft(BorderStyle.THIN);
            sampleStyle.setBorderRight(BorderStyle.THIN);

            // Create instruction style
            CellStyle instructionStyle = workbook.createCellStyle();
            Font instructionFont = workbook.createFont();
            instructionFont.setBold(true);
            instructionFont.setColor(IndexedColors.DARK_RED.getIndex());
            instructionStyle.setFont(instructionFont);

            // Add instructions
            Row instructionRow = sheet.createRow(0);
            Cell instructionCell = instructionRow.createCell(0);
            instructionCell.setCellValue("INSTRUCTIONS: Fill in the data starting from row 3. Delete the sample data in row 3 before uploading.");
            instructionCell.setCellStyle(instructionStyle);
            sheet.addMergedRegion(new org.apache.poi.ss.util.CellRangeAddress(0, 0, 0, 2));

            // Create header row
            Row headerRow = sheet.createRow(1);

            Cell cell1 = headerRow.createCell(0);
            cell1.setCellValue("Search Prefix");
            cell1.setCellStyle(headerStyle);

            Cell cell2 = headerRow.createCell(1);
            cell2.setCellValue("Gender");
            cell2.setCellStyle(headerStyle);

            Cell cell3 = headerRow.createCell(2);
            cell3.setCellValue("Prefix Of");
            cell3.setCellStyle(headerStyle);

            // Add sample data row
            Row sampleRow = sheet.createRow(2);

            Cell sampleCell1 = sampleRow.createCell(0);
            sampleCell1.setCellValue("Mr.");
            sampleCell1.setCellStyle(sampleStyle);

            Cell sampleCell2 = sampleRow.createCell(1);
            sampleCell2.setCellValue("Male");
            sampleCell2.setCellStyle(sampleStyle);

            Cell sampleCell3 = sampleRow.createCell(2);
            sampleCell3.setCellValue("S/O,H/O,F/O");
            sampleCell3.setCellStyle(sampleStyle);

            // Auto-size columns
            for (int i = 0; i < 3; i++) {
                sheet.autoSizeColumn(i);
                sheet.setColumnWidth(i, sheet.getColumnWidth(i) + 2000);
            }

            // Convert to byte array
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            workbook.write(outputStream);
            return outputStream.toByteArray();
        }
    }

    /**
     * Import prefix data from Excel file
     */
    public List<Prefix> importFromExcel(MultipartFile file) throws IOException {
        List<Prefix> prefixes = new ArrayList<>();

        try (InputStream inputStream = file.getInputStream();
             Workbook workbook = WorkbookFactory.create(inputStream)) {

            Sheet sheet = workbook.getSheetAt(0);

            // Find the header row (skip instruction rows)
            int headerRowIndex = -1;
            for (int i = 0; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row != null) {
                    Cell firstCell = row.getCell(0);
                    if (firstCell != null && firstCell.getCellType() == CellType.STRING) {
                        String cellValue = firstCell.getStringCellValue().trim();
                        if ("Search Prefix".equalsIgnoreCase(cellValue)) {
                            headerRowIndex = i;
                            break;
                        }
                    }
                }
            }

            if (headerRowIndex == -1) {
                throw new IOException("Invalid Excel format. Header row not found. Expected 'Search Prefix' in the first column of header row.");
            }

            // Process data rows (start from header row + 1)
            for (int i = headerRowIndex + 1; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row != null) {
                    Prefix prefix = new Prefix();
                    boolean hasData = false;

                    // Search Prefix (required)
                    Cell searchPrefixCell = row.getCell(0);
                    if (searchPrefixCell != null) {
                        String searchPrefix = getCellValueAsString(searchPrefixCell).trim();
                        if (!searchPrefix.isEmpty() && !searchPrefix.toLowerCase().contains("sample")
                                && !searchPrefix.equals("Mr.")) { // Skip sample data
                            prefix.setSearchPrefix(searchPrefix);
                            hasData = true;
                        }
                    }

                    // Gender (optional)
                    Cell genderCell = row.getCell(1);
                    if (genderCell != null) {
                        String gender = getCellValueAsString(genderCell).trim();
                        prefix.setGender(gender.isEmpty() ? null : gender);
                    }

                    // Prefix Of (optional)
                    Cell prefixOfCell = row.getCell(2);
                    if (prefixOfCell != null) {
                        String prefixOf = getCellValueAsString(prefixOfCell).trim();
                        prefix.setPrefixOf(prefixOf.isEmpty() ? null : prefixOf);
                    }

                    // Only add if we have at least a search prefix
                    if (hasData && prefix.getSearchPrefix() != null && !prefix.getSearchPrefix().isEmpty()) {
                        prefixes.add(prefix);
                    }
                }
            }
        }

        return prefixes;
    }

    /**
     * Helper method to get cell value as string regardless of cell type
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