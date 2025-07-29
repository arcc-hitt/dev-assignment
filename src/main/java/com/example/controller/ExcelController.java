//package com.example.controller;
//
//import com.example.model.Prefix;
//import com.example.service.PrefixService;
//import com.example.util.ExcelUtil;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.http.HttpHeaders;
//import org.springframework.http.MediaType;
//import org.springframework.http.ResponseEntity;
//import org.springframework.stereotype.Controller;
//import org.springframework.web.bind.annotation.*;
//import org.springframework.web.multipart.MultipartFile;
//
//import java.io.IOException;
//import java.util.*;
//
//@RestController
//@RequestMapping("/excel")
//public class ExcelController {
//
//    @Autowired
//    private PrefixService prefixService;
//
//    @Autowired
//    private ExcelUtil excelUtil;
//
//    /**
//     * Download all prefix records in Excel format
//     */
//    @GetMapping("/download")
//    public ResponseEntity<byte[]> downloadExcel() {
//        try {
//            List<Prefix> prefixes = prefixService.listAll();
//            byte[] excelData = excelUtil.exportToExcel(prefixes);
//
//            HttpHeaders headers = new HttpHeaders();
//            headers.setContentType(MediaType.parseMediaType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"));
//            headers.setContentDispositionFormData("attachment", "prefix_records.xlsx");
//
//            return ResponseEntity.ok()
//                    .headers(headers)
//                    .body(excelData);
//        } catch (Exception e) {
//            e.printStackTrace();
//            return ResponseEntity.internalServerError().build();
//        }
//    }
//
//    /**
//     * Download empty Excel template for data entry
//     */
//    @GetMapping("/template")
//    public ResponseEntity<byte[]> downloadTemplate() {
//        try {
//            byte[] templateData = excelUtil.createEmptyTemplate();
//
//            HttpHeaders headers = new HttpHeaders();
//            headers.setContentType(MediaType.parseMediaType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"));
//            headers.setContentDispositionFormData("attachment", "prefix_template.xlsx");
//
//            return ResponseEntity.ok()
//                    .headers(headers)
//                    .body(templateData);
//        } catch (Exception e) {
//            e.printStackTrace();
//            return ResponseEntity.internalServerError().build();
//        }
//    }
//
//    /**
//     * Upload Excel file and import data
//     */
//    @PostMapping(
//            value = "/upload",
//            consumes = MediaType.MULTIPART_FORM_DATA_VALUE,
//            produces = MediaType.APPLICATION_JSON_VALUE
//    )
//    @ResponseBody
//    public ResponseEntity<Map<String, Object>> uploadExcel(
//            @RequestPart("file") MultipartFile file
//    ) {
//        Map<String, Object> response = new HashMap<>();
//
//        try {
//            // Validate file
//            if (file.isEmpty()) {
//                response.put("success", false);
//                response.put("message", "Please select a file to upload");
//                return ResponseEntity.badRequest().body(response);
//            }
//
//            String filename = file.getOriginalFilename();
//            if (filename == null || (!filename.toLowerCase().endsWith(".xlsx") && !filename.toLowerCase().endsWith(".xls"))) {
//                response.put("success", false);
//                response.put("message", "Please upload a valid Excel file (.xlsx or .xls)");
//                return ResponseEntity.badRequest().body(response);
//            }
//
//            // Parse Excel file
//            List<Prefix> prefixes = excelUtil.importFromExcel(file);
//
//            if (prefixes.isEmpty()) {
//                response.put("success", false);
//                response.put("message", "No valid data found in the Excel file");
//                return ResponseEntity.badRequest().body(response);
//            }
//
//            // Save to database
//            int successCount = 0;
//            int errorCount = 0;
//            StringBuilder errorMessages = new StringBuilder();
//
//            for (Prefix prefix : prefixes) {
//                try {
//                    prefixService.save(prefix);
//                    successCount++;
//                } catch (Exception e) {
//                    errorCount++;
//                    errorMessages.append("Row with prefix '")
//                            .append(prefix.getSearchPrefix())
//                            .append("': ")
//                            .append(e.getMessage())
//                            .append("; ");
//                }
//            }
//
//            // Prepare response
//            response.put("success", true);
//            response.put("totalRecords", prefixes.size());
//            response.put("successCount", successCount);
//            response.put("errorCount", errorCount);
//
//            if (errorCount > 0) {
//                response.put("message", String.format("Upload completed with %d successful and %d failed records. Errors: %s",
//                        successCount, errorCount, errorMessages.toString()));
//            } else {
//                response.put("message", String.format("Successfully imported %d records from Excel file", successCount));
//            }
//
//            return ResponseEntity.ok(response);
//
//        } catch (IOException e) {
//            // handle Excel parsing errors as bad requests
//            response.put("success", false);
//            response.put("message", "Invalid Excel file: " + e.getMessage());
//            return ResponseEntity.badRequest().body(response);
//        } catch (Exception e) {
//            e.printStackTrace();
//            response.put("success", false);
//            response.put("message", "Error processing Excel file: " + e.getMessage());
//            return ResponseEntity.internalServerError().body(response);
//        }
//    }
//
//    /**
//     * Get current prefix count for display
//     */
//    @GetMapping("/count")
//    @ResponseBody
//    public ResponseEntity<Map<String, Object>> getRecordCount() {
//        try {
//            List<Prefix> prefixes = prefixService.listAll();
//            Map<String, Object> response = new HashMap<>();
//            response.put("count", prefixes.size());
//            return ResponseEntity.ok(response);
//        } catch (Exception e) {
//            e.printStackTrace();
//            return ResponseEntity.internalServerError().build();
//        }
//    }
//}