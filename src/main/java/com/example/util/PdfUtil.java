package com.example.util;

import org.springframework.stereotype.Component;

import java.io.*;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;

@Component
public class PdfUtil {

    private static final String NODE_CMD    = "node";             // or "node.exe"
    private static final String SCRIPT_DIR  = "puppeteer";        // matches resources/puppeteer
    private static final String SCRIPT_NAME = "generatePdf.js";

    /**
     * Generates a simple "Hello World" PDF.
     */
    public byte[] generateHelloWorldPdf() throws IOException {
        String html = "<!DOCTYPE html><html><head><meta charset='utf-8'>"
                + "<title>Hello World</title>"
                + "<style>body{font-family:Arial,sans-serif;margin:50px;text-align:center;}h1{color:#333;}</style>"
                + "</head><body>"
                + "<h1>Hello World!</h1>"
                + "<p>This is a simple PDF generated using Puppeteer library.</p>"
                + "</body></html>";

        return runPuppeteerScript(html);
    }

    private byte[] runPuppeteerScript(String htmlContent) throws IOException {
        // 1) Locate the puppeteer folder in the classpath
        URL dirUrl = getClass().getClassLoader().getResource(SCRIPT_DIR);
        if (dirUrl == null) {
            throw new IOException("Cannot locate resource folder: " + SCRIPT_DIR);
        }

        Path scriptFolder;
        try {
            // Convert URL to URI so that Windows drive letters work correctly
            scriptFolder = Paths.get(dirUrl.toURI());
        } catch (URISyntaxException e) {
            throw new IOException("Invalid script directory URI: " + dirUrl, e);
        }

        Path scriptPath = scriptFolder.resolve(SCRIPT_NAME);

        // 2) Build the process
        ProcessBuilder pb = new ProcessBuilder(NODE_CMD, scriptPath.toString());
        pb.directory(scriptFolder.toFile());
        pb.redirectErrorStream(true);

        // 3) Start & feed HTML to stdin
        Process proc = pb.start();
        try (OutputStream os = proc.getOutputStream()) {
            os.write(htmlContent.getBytes(StandardCharsets.UTF_8));
            os.flush();
        }

        // 4) Capture stdout (PDF bytes or error text)
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        try (InputStream is = proc.getInputStream()) {
            byte[] buf = new byte[4096];
            int r;
            while ((r = is.read(buf)) != -1) {
                baos.write(buf, 0, r);
            }
        }

        // 5) Check exit code
        try {
            int exit = proc.waitFor();
            if (exit != 0) {
                String err = new String(baos.toByteArray(), StandardCharsets.UTF_8);
                throw new IOException("Puppeteer script failed (exit " + exit + "):\n" + err);
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new IOException("PDF generation interrupted", e);
        }

        return baos.toByteArray();
    }
}
