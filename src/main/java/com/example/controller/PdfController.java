package com.example.controller;

import com.example.util.PdfUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;

@Controller
@RequestMapping("/pdf")
public class PdfController {

    @Autowired
    private PdfUtil pdfUtil;

    /**
     * Handles GET requests to generate a "Hello World" PDF.
     * Simple hello world page using puppeteer as per assignment requirements.
     *
     * @return ResponseEntity containing the PDF byte array and appropriate headers.
     * @throws IOException If there's an error during PDF generation.
     */
    @GetMapping("/hello-world")
    public ResponseEntity<byte[]> generateHelloWorldPdf() throws IOException {
        // Generate the "Hello World" PDF using PdfUtil
        byte[] pdfData = pdfUtil.generateHelloWorldPdf();

        // Set HTTP headers for PDF response
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_PDF);
        headers.setContentDispositionFormData("attachment", "hello-world.pdf");

        return ResponseEntity.ok()
                .headers(headers)
                .body(pdfData);
    }
}