package com.example.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import java.io.*;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;

/**
 * Utility class for PDF generation using Puppeteer library.
 * Handles HTML to PDF conversion through Node.js and Puppeteer.
 * 
 * @author Dev Assignment
 * @version 1.0
 */
@Component
public class PdfUtil {
    
    private static final Logger logger = LoggerFactory.getLogger(PdfUtil.class);

    // Node.js and script configuration
    private static final String NODE_EXECUTABLE = "node";             // or "node.exe" on Windows
    private static final String PUPPETEER_SCRIPT_DIR = "puppeteer";   // matches resources/puppeteer
    private static final String PDF_GENERATION_SCRIPT = "generatePdf.js";
    
    // Buffer size for reading process output
    private static final int BUFFER_SIZE = 4096;
    
    // Timeout for process execution (in milliseconds)
    private static final long PROCESS_TIMEOUT_MS = 30000; // 30 seconds

    /**
     * Generates a simple "Hello World" PDF using Puppeteer.
     * Creates a basic HTML document and converts it to PDF format.
     * 
     * @return Byte array containing the generated PDF data
     * @throws IOException if there's an error during PDF generation
     */
    public byte[] generateHelloWorldPdf() throws IOException {
        logger.info("Starting Hello World PDF generation using Puppeteer");
        
        String htmlContent = createHelloWorldHtml();
        logger.debug("HTML content created, length: {} characters", htmlContent.length());
        
        try {
            byte[] pdfData = runPuppeteerScript(htmlContent);
            logger.info("PDF generation completed successfully, size: {} bytes", pdfData.length);
            return pdfData;
        } catch (Exception exception) {
            logger.error("Failed to generate Hello World PDF: {}", exception.getMessage(), exception);
            throw new IOException("Failed to generate PDF using Puppeteer", exception);
        }
    }

    /**
     * Creates the HTML content for the Hello World PDF.
     * 
     * @return HTML string with styling
     */
    private String createHelloWorldHtml() {
        return "<!DOCTYPE html>" +
               "<html>" +
               "<head>" +
               "<meta charset='utf-8'>" +
               "<title>Hello World</title>" +
               "<style>" +
               "body { font-family: Arial, sans-serif; margin: 50px; text-align: center; }" +
               "h1 { color: #333; }" +
               "</style>" +
               "</head>" +
               "<body>" +
               "<h1>Hello World!</h1>" +
               "<p>This is a simple PDF generated using Puppeteer library.</p>" +
               "</body>" +
               "</html>";
    }

    /**
     * Executes the Puppeteer script to convert HTML to PDF.
     * 
     * @param htmlContent The HTML content to convert
     * @return Byte array containing the generated PDF
     * @throws IOException if there's an error during script execution
     */
    private byte[] runPuppeteerScript(String htmlContent) throws IOException {
        logger.debug("Executing Puppeteer script for HTML to PDF conversion");
        
        // Step 1: Locate the puppeteer script folder in the classpath
        Path scriptFolderPath = locatePuppeteerScriptFolder();
        Path scriptFilePath = scriptFolderPath.resolve(PDF_GENERATION_SCRIPT);
        
        logger.debug("Using script path: {}", scriptFilePath);

        // Step 2: Build the Node.js process
        ProcessBuilder processBuilder = createProcessBuilder(scriptFilePath, scriptFolderPath);
        
        // Step 3: Start the process and feed HTML content
        Process puppeteerProcess = startPuppeteerProcess(processBuilder, htmlContent);
        
        // Step 4: Capture the process output (PDF bytes or error text)
        byte[] processOutput = captureProcessOutput(puppeteerProcess);
        
        // Step 5: Check process exit code and handle errors
        validateProcessExecution(puppeteerProcess, processOutput);
        
        return processOutput;
    }

    /**
     * Locates the Puppeteer script folder in the classpath.
     * 
     * @return Path to the script folder
     * @throws IOException if the script folder cannot be found
     */
    private Path locatePuppeteerScriptFolder() throws IOException {
        URL scriptFolderUrl = getClass().getClassLoader().getResource(PUPPETEER_SCRIPT_DIR);
        if (scriptFolderUrl == null) {
            String errorMessage = "Cannot locate Puppeteer script folder in classpath: " + PUPPETEER_SCRIPT_DIR;
            logger.error(errorMessage);
            throw new IOException(errorMessage);
        }

        try {
            // Convert URL to URI so that Windows drive letters work correctly
            Path scriptFolderPath = Paths.get(scriptFolderUrl.toURI());
            logger.debug("Found Puppeteer script folder: {}", scriptFolderPath);
            return scriptFolderPath;
        } catch (URISyntaxException uriException) {
            String errorMessage = "Invalid script folder URI: " + scriptFolderUrl;
            logger.error(errorMessage, uriException);
            throw new IOException(errorMessage, uriException);
        }
    }

    /**
     * Creates a ProcessBuilder for the Puppeteer script execution.
     * 
     * @param scriptFilePath Path to the Puppeteer script
     * @param workingDirectory Working directory for the process
     * @return Configured ProcessBuilder
     */
    private ProcessBuilder createProcessBuilder(Path scriptFilePath, Path workingDirectory) {
        ProcessBuilder processBuilder = new ProcessBuilder(NODE_EXECUTABLE, scriptFilePath.toString());
        processBuilder.directory(workingDirectory.toFile());
        processBuilder.redirectErrorStream(true);
        
        logger.debug("ProcessBuilder created with working directory: {}", workingDirectory);
        return processBuilder;
    }

    /**
     * Starts the Puppeteer process and feeds HTML content to its stdin.
     * 
     * @param processBuilder The configured ProcessBuilder
     * @param htmlContent HTML content to feed to the process
     * @return Started Process object
     * @throws IOException if there's an error starting the process
     */
    private Process startPuppeteerProcess(ProcessBuilder processBuilder, String htmlContent) throws IOException {
        logger.debug("Starting Puppeteer process");
        
        Process puppeteerProcess = processBuilder.start();
        
        // Feed HTML content to the process stdin
        try (OutputStream processOutputStream = puppeteerProcess.getOutputStream()) {
            byte[] htmlBytes = htmlContent.getBytes(StandardCharsets.UTF_8);
            processOutputStream.write(htmlBytes);
            processOutputStream.flush();
            logger.debug("HTML content written to process stdin, {} bytes", htmlBytes.length);
        } catch (IOException ioException) {
            logger.error("Failed to write HTML content to process stdin", ioException);
            puppeteerProcess.destroy();
            throw new IOException("Failed to feed HTML content to Puppeteer process", ioException);
        }
        
        return puppeteerProcess;
    }

    /**
     * Captures the output from the Puppeteer process.
     * 
     * @param puppeteerProcess The running process
     * @return Byte array containing the process output
     * @throws IOException if there's an error reading the process output
     */
    private byte[] captureProcessOutput(Process puppeteerProcess) throws IOException {
        logger.debug("Capturing process output");
        
        ByteArrayOutputStream outputBuffer = new ByteArrayOutputStream();
        try (InputStream processInputStream = puppeteerProcess.getInputStream()) {
            byte[] buffer = new byte[BUFFER_SIZE];
            int bytesRead;
            while ((bytesRead = processInputStream.read(buffer)) != -1) {
                outputBuffer.write(buffer, 0, bytesRead);
            }
        } catch (IOException ioException) {
            logger.error("Failed to read process output", ioException);
            throw new IOException("Failed to capture Puppeteer process output", ioException);
        }
        
        byte[] outputData = outputBuffer.toByteArray();
        logger.debug("Process output captured, {} bytes", outputData.length);
        return outputData;
    }

    /**
     * Validates the process execution and handles errors.
     * 
     * @param puppeteerProcess The completed process
     * @param processOutput The process output
     * @throws IOException if the process failed or was interrupted
     */
    private void validateProcessExecution(Process puppeteerProcess, byte[] processOutput) throws IOException {
        try {
            // Wait for process completion
            int exitCode = puppeteerProcess.waitFor();
            
            if (exitCode != 0) {
                String errorOutput = new String(processOutput, StandardCharsets.UTF_8);
                String errorMessage = String.format("Puppeteer script failed with exit code %d: %s", exitCode, errorOutput);
                logger.error(errorMessage);
                throw new IOException(errorMessage);
            }
            
            logger.debug("Puppeteer process completed successfully with exit code: {}", exitCode);
            
        } catch (InterruptedException interruptedException) {
            Thread.currentThread().interrupt();
            logger.error("Puppeteer process was interrupted", interruptedException);
            throw new IOException("PDF generation was interrupted", interruptedException);
        }
    }
}
