package com.example.controller;

import com.example.model.Prefix;
import com.example.service.PrefixService;
import com.example.util.ExcelUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.*;

/**
 * REST Controller for Excel file operations including download, upload, and template generation.
 * Handles Excel file processing for prefix data import/export functionality.
 * 
 * @author Dev Assignment
 * @version 1.0
 */
@RestController
@RequestMapping("/excel")
public class ExcelController {

    private static final Logger logger = LoggerFactory.getLogger(ExcelController.class);
    
    // Maximum file size in bytes (10MB)
    private static final long MAX_FILE_SIZE = 10 * 1024 * 1024;
    
    // Supported Excel file extensions
    private static final List<String> SUPPORTED_EXTENSIONS = Arrays.asList(".xlsx", ".xls");

    @Autowired
    private PrefixService prefixService;

    @Autowired
    private ExcelUtil excelUtil;

    /**
     * Downloads all prefix records from the database in Excel format.
     * 
     * @return ResponseEntity containing the Excel file as byte array with appropriate headers
     */
    @GetMapping("/download")
    public ResponseEntity<byte[]> downloadAllPrefixesAsExcel() {
        logger.info("Starting Excel download for all prefix records");
        
        try {
            // Retrieve all prefix records from database
            List<Prefix> allPrefixes = prefixService.listAll();
            logger.debug("Retrieved {} prefix records for Excel export", allPrefixes.size());
            
            // Generate Excel file from prefix data
            byte[] excelFileData = excelUtil.exportToExcel(allPrefixes);

            // Set HTTP headers for file download
            HttpHeaders responseHeaders = new HttpHeaders();
            responseHeaders.setContentType(MediaType.parseMediaType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"));
            responseHeaders.setContentDispositionFormData("attachment", "prefix_records.xlsx");

            logger.info("Excel download completed successfully with {} records", allPrefixes.size());
            return ResponseEntity.ok()
                    .headers(responseHeaders)
                    .body(excelFileData);
                    
        } catch (Exception exception) {
            logger.error("Failed to download Excel file: {}", exception.getMessage(), exception);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to generate Excel file".getBytes());
        }
    }

    /**
     * Downloads an empty Excel template for data entry.
     * 
     * @return ResponseEntity containing the empty Excel template as byte array
     */
    @GetMapping("/template")
    public ResponseEntity<byte[]> downloadExcelTemplate() {
        logger.info("Starting Excel template download");
        
        try {
            // Generate empty Excel template
            byte[] templateFileData = excelUtil.createEmptyTemplate();

            // Set HTTP headers for file download
            HttpHeaders responseHeaders = new HttpHeaders();
            responseHeaders.setContentType(MediaType.parseMediaType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"));
            responseHeaders.setContentDispositionFormData("attachment", "prefix_template.xlsx");

            logger.info("Excel template download completed successfully");
            return ResponseEntity.ok()
                    .headers(responseHeaders)
                    .body(templateFileData);
                    
        } catch (Exception exception) {
            logger.error("Failed to download Excel template: {}", exception.getMessage(), exception);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to generate Excel template".getBytes());
        }
    }

    /**
     * Uploads and processes an Excel file containing prefix data.
     * Validates the file, parses the data, and saves valid records to the database.
     * 
     * @param uploadedFile The Excel file to be processed
     * @return ResponseEntity containing upload results and statistics
     */
    @PostMapping(
            value = "/upload",
            consumes = MediaType.MULTIPART_FORM_DATA_VALUE,
            produces = MediaType.APPLICATION_JSON_VALUE
    )
    @ResponseBody
    public ResponseEntity<Map<String, Object>> uploadExcelFile(
            @RequestPart("file") MultipartFile uploadedFile
    ) {
        Map<String, Object> uploadResponse = new HashMap<>();
        logger.info("Starting Excel file upload: {}", uploadedFile.getOriginalFilename());

        try {
            // Validate uploaded file
            String validationError = validateUploadedFile(uploadedFile);
            if (validationError != null) {
                uploadResponse.put("success", false);
                uploadResponse.put("message", validationError);
                logger.warn("File validation failed: {}", validationError);
                return ResponseEntity.badRequest().body(uploadResponse);
            }

            // Parse Excel file and extract prefix data
            List<Prefix> parsedPrefixes = excelUtil.importFromExcel(uploadedFile);
            logger.debug("Parsed {} records from Excel file", parsedPrefixes.size());

            if (parsedPrefixes.isEmpty()) {
                uploadResponse.put("success", false);
                uploadResponse.put("message", "No valid data found in the Excel file");
                logger.warn("No valid data found in uploaded Excel file");
                return ResponseEntity.badRequest().body(uploadResponse);
            }

            // Process and save prefix records to database
            UploadResult uploadResult = processAndSavePrefixes(parsedPrefixes);

            // Prepare response with upload statistics
            uploadResponse.put("success", true);
            uploadResponse.put("totalRecords", parsedPrefixes.size());
            uploadResponse.put("successCount", uploadResult.getSuccessCount());
            uploadResponse.put("errorCount", uploadResult.getErrorCount());

            String responseMessage = buildUploadResponseMessage(uploadResult);
            uploadResponse.put("message", responseMessage);

            logger.info("Excel upload completed: {} successful, {} failed out of {} total records", 
                    uploadResult.getSuccessCount(), uploadResult.getErrorCount(), parsedPrefixes.size());

            return ResponseEntity.ok(uploadResponse);

        } catch (IOException ioException) {
            // Handle Excel parsing errors
            String errorMessage = "Invalid Excel file format: " + ioException.getMessage();
            uploadResponse.put("success", false);
            uploadResponse.put("message", errorMessage);
            logger.error("Excel parsing error: {}", errorMessage, ioException);
            return ResponseEntity.badRequest().body(uploadResponse);
            
        } catch (Exception exception) {
            // Handle unexpected errors
            String errorMessage = "Error processing Excel file: " + exception.getMessage();
            uploadResponse.put("success", false);
            uploadResponse.put("message", errorMessage);
            logger.error("Unexpected error during Excel upload: {}", errorMessage, exception);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(uploadResponse);
        }
    }

    /**
     * Retrieves the current count of prefix records in the database.
     * 
     * @return ResponseEntity containing the record count
     */
    @GetMapping("/count")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getPrefixRecordCount() {
        logger.debug("Retrieving prefix record count");
        
        try {
            List<Prefix> allPrefixes = prefixService.listAll();
            Map<String, Object> countResponse = new HashMap<>();
            countResponse.put("count", allPrefixes.size());
            
            logger.debug("Current prefix record count: {}", allPrefixes.size());
            return ResponseEntity.ok(countResponse);
            
        } catch (Exception exception) {
            logger.error("Failed to retrieve prefix record count: {}", exception.getMessage(), exception);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * Validates the uploaded file for size, format, and content.
     * 
     * @param uploadedFile The file to validate
     * @return Error message if validation fails, null if validation passes
     */
    private String validateUploadedFile(MultipartFile uploadedFile) {
        // Check if file is empty
        if (uploadedFile.isEmpty()) {
            return "Please select a file to upload";
        }

        // Check file size
        if (uploadedFile.getSize() > MAX_FILE_SIZE) {
            return String.format("File size too large. Maximum allowed size is %d MB", MAX_FILE_SIZE / (1024 * 1024));
        }

        // Check file extension
        String originalFilename = uploadedFile.getOriginalFilename();
        if (originalFilename == null) {
            return "Invalid file name";
        }

        String fileExtension = originalFilename.toLowerCase();
        boolean isValidExtension = SUPPORTED_EXTENSIONS.stream()
                .anyMatch(fileExtension::endsWith);
        
        if (!isValidExtension) {
            return "Please upload a valid Excel file (.xlsx or .xls)";
        }

        return null; // Validation passed
    }

    /**
     * Processes and saves prefix records to the database.
     * 
     * @param prefixRecords List of prefix records to process
     * @return UploadResult containing success and error statistics
     */
    private UploadResult processAndSavePrefixes(List<Prefix> prefixRecords) {
        int successfulSaves = 0;
        int failedSaves = 0;
        StringBuilder errorDetails = new StringBuilder();

        for (Prefix prefixRecord : prefixRecords) {
            try {
                prefixService.save(prefixRecord);
                successfulSaves++;
            } catch (Exception saveException) {
                failedSaves++;
                errorDetails.append("Row with prefix '")
                        .append(prefixRecord.getSearchPrefix())
                        .append("': ")
                        .append(saveException.getMessage())
                        .append("; ");
                logger.warn("Failed to save prefix '{}': {}", 
                        prefixRecord.getSearchPrefix(), saveException.getMessage());
            }
        }

        return new UploadResult(successfulSaves, failedSaves, errorDetails.toString());
    }

    /**
     * Builds a user-friendly response message based on upload results.
     * 
     * @param uploadResult The result of the upload operation
     * @return Formatted response message
     */
    private String buildUploadResponseMessage(UploadResult uploadResult) {
        if (uploadResult.getErrorCount() > 0) {
            return String.format("Upload completed with %d successful and %d failed records. Errors: %s",
                    uploadResult.getSuccessCount(), uploadResult.getErrorCount(), uploadResult.getErrorDetails());
        } else {
            return String.format("Successfully imported %d records from Excel file", uploadResult.getSuccessCount());
        }
    }

    /**
     * Inner class to hold upload operation results and statistics.
     */
    private static class UploadResult {
        private final int successCount;
        private final int errorCount;
        private final String errorDetails;

        public UploadResult(int successCount, int errorCount, String errorDetails) {
            this.successCount = successCount;
            this.errorCount = errorCount;
            this.errorDetails = errorDetails;
        }

        public int getSuccessCount() { return successCount; }
        public int getErrorCount() { return errorCount; }
        public String getErrorDetails() { return errorDetails; }
    }
}