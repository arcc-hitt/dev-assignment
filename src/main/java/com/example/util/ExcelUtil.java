package com.example.util;

import com.example.model.Prefix;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

@Component
public class ExcelUtil {

    public byte[] exportToExcel(List<Prefix> prefixes) throws IOException {
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Prefixes");

            // Create header row
            Row headerRow = sheet.createRow(0);
            headerRow.createCell(0).setCellValue("Search Prefix");
            headerRow.createCell(1).setCellValue("Gender");
            headerRow.createCell(2).setCellValue("Prefix Of");

            // Create data rows
            int rowNum = 1;
            for (Prefix prefix : prefixes) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(prefix.getSearchPrefix());
                row.createCell(1).setCellValue(prefix.getGender());
                row.createCell(2).setCellValue(prefix.getPrefixOf());
            }

            // Auto-size columns
            for (int i = 0; i < 3; i++) {
                sheet.autoSizeColumn(i);
            }

            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            workbook.write(outputStream);
            return outputStream.toByteArray();
        }
    }

    public byte[] createEmptyTemplate() throws IOException {
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Prefixes");

            // Create header row
            Row headerRow = sheet.createRow(0);
            headerRow.createCell(0).setCellValue("Search Prefix");
            headerRow.createCell(1).setCellValue("Gender");
            headerRow.createCell(2).setCellValue("Prefix Of");

            // Add sample data row
            Row sampleRow = sheet.createRow(1);
            sampleRow.createCell(0).setCellValue("Mr.");
            sampleRow.createCell(1).setCellValue("Male");
            sampleRow.createCell(2).setCellValue("S/O,H/O,F/O");

            // Auto-size columns
            for (int i = 0; i < 3; i++) {
                sheet.autoSizeColumn(i);
            }

            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            workbook.write(outputStream);
            return outputStream.toByteArray();
        }
    }

    public List<Prefix> importFromExcel(MultipartFile file) throws IOException {
        List<Prefix> prefixes = new ArrayList<>();
        
        try (InputStream inputStream = file.getInputStream();
             Workbook workbook = WorkbookFactory.create(inputStream)) {
            
            Sheet sheet = workbook.getSheetAt(0);
            
            // Skip header row, start from row 1
            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row != null) {
                    Prefix prefix = new Prefix();
                    
                    Cell searchPrefixCell = row.getCell(0);
                    Cell genderCell = row.getCell(1);
                    Cell prefixOfCell = row.getCell(2);
                    
                    if (searchPrefixCell != null && searchPrefixCell.getStringCellValue() != null && 
                        !searchPrefixCell.getStringCellValue().trim().isEmpty()) {
                        prefix.setSearchPrefix(searchPrefixCell.getStringCellValue().trim());
                        prefix.setGender(genderCell != null ? genderCell.getStringCellValue() : "");
                        prefix.setPrefixOf(prefixOfCell != null ? prefixOfCell.getStringCellValue() : "");
                        prefixes.add(prefix);
                    }
                }
            }
        }
        
        return prefixes;
    }
}
