package com.example.controller;

import com.example.util.PdfUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;

/**
 * REST Controller for PDF generation operations.
 * Handles PDF file generation using Puppeteer library as per assignment requirements.
 * 
 * @author Dev Assignment
 * @version 1.0
 */
@RestController
@RequestMapping("/pdf")
public class PdfController {

    private static final Logger logger = LoggerFactory.getLogger(PdfController.class);

    @Autowired
    private PdfUtil pdfUtil;

    /**
     * Generates a "Hello World" PDF file using Puppeteer library.
     * Creates a simple PDF document with "Hello World" content as specified in the assignment.
     *
     * @return ResponseEntity containing the generated PDF as byte array with appropriate headers
     */
    @GetMapping("/hello-world")
    public ResponseEntity<byte[]> generateHelloWorldPdf() {
        logger.info("Starting Hello World PDF generation");
        
        try {
            // Generate the "Hello World" PDF using PdfUtil
            byte[] generatedPdfData = pdfUtil.generateHelloWorldPdf();
            logger.debug("PDF generation completed successfully, size: {} bytes", generatedPdfData.length);

            // Set HTTP headers for PDF file download
            HttpHeaders responseHeaders = new HttpHeaders();
            responseHeaders.setContentType(MediaType.APPLICATION_PDF);
            responseHeaders.setContentDispositionFormData("attachment", "hello-world.pdf");

            logger.info("Hello World PDF generated and ready for download");
            return ResponseEntity.ok()
                    .headers(responseHeaders)
                    .body(generatedPdfData);
                    
        } catch (IOException ioException) {
            // Handle PDF generation errors
            logger.error("Failed to generate Hello World PDF: {}", ioException.getMessage(), ioException);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to generate PDF file".getBytes());
                    
        } catch (Exception unexpectedException) {
            // Handle unexpected errors
            logger.error("Unexpected error during PDF generation: {}", unexpectedException.getMessage(), unexpectedException);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("An unexpected error occurred while generating PDF".getBytes());
        }
    }
}