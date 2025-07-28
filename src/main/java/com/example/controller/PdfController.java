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

    @GetMapping("/hello-world")
    public ResponseEntity<byte[]> generateHelloWorldPdf() throws IOException {
        byte[] pdfData = pdfUtil.generateHelloWorldPdf();
        
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.TEXT_HTML);
        headers.setContentDispositionFormData("attachment", "hello-world.html");
        
        return ResponseEntity.ok()
                .headers(headers)
                .body(pdfData);
    }

    @PostMapping("/generate")
    @ResponseBody
    public ResponseEntity<byte[]> generatePdfFromHtml(@RequestBody String htmlContent) throws IOException {
        byte[] pdfData = pdfUtil.generatePdfFromHtml(htmlContent);
        
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.TEXT_HTML);
        headers.setContentDispositionFormData("attachment", "generated.html");
        
        return ResponseEntity.ok()
                .headers(headers)
                .body(pdfData);
    }
} 