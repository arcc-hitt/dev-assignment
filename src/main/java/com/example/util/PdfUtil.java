package com.example.util;

import org.springframework.stereotype.Component;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Paths; // Import Paths for resolving script path

@Component
public class PdfUtil {

    // Define the path to the Node.js executable.
    // On Windows, this might be "node.exe". On Linux/macOS, typically "node".
    private static final String NODE_PATH = "node.exe";

    // Define the relative path to the Puppeteer script.
    // This assumes 'generatePdf.js' is located in 'src/main/resources/'
    // within your Spring Boot project structure.
    private static final String SCRIPT_RELATIVE_PATH = "src/main/resources/generatePDF.js";

    /**
     * Generates a PDF from the given HTML content by executing an external Puppeteer Node.js script.
     *
     * @param htmlContent The HTML string to convert to PDF.
     * @return A byte array containing the generated PDF.
     * @throws IOException If an I/O error occurs during process execution or PDF generation.
     */
    public byte[] generatePdfFromHtml(String htmlContent) throws IOException {
        return executePuppeteerScript(htmlContent);
    }

    /**
     * Generates a simple "Hello World" PDF.
     *
     * @return A byte array containing the "Hello World" PDF.
     * @throws IOException If an I/O error occurs during process execution or PDF generation.
     */
    public byte[] generateHelloWorldPdf() throws IOException {
        // Create a simple HTML string for the "Hello World" PDF
        String helloWorldHtml = "<!DOCTYPE html>" +
                "<html>" +
                "<head>" +
                "    <title>Hello World PDF</title>" +
                "    <style>" +
                "        body { font-family: Arial, sans-serif; margin: 20px; text-align: center; }" +
                "        h1 { color: #333; }" +
                "        p { font-size: 14px; line-height: 1.6; }" +
                "    </style>" +
                "</head>" +
                "<body>" +
                "<h1>Hello World!</h1>" +
                "<p>This is a simple PDF generated using Puppeteer.</p>" +
                "<p>Generated on: " + new java.util.Date() + "</p>" + // Include current date
                "</body>" +
                "</html>";
        return executePuppeteerScript(helloWorldHtml);
    }

    /**
     * Executes the Puppeteer Node.js script to convert HTML to PDF.
     *
     * @param htmlContent The HTML content to pass to the script.
     * @return The PDF content as a byte array.
     * @throws IOException If the process cannot be started or if the script returns an error.
     */
    private byte[] executePuppeteerScript(String htmlContent) throws IOException {
        // Resolve the absolute path to the Node.js script.
        // This is important because the current working directory of the Java process
        // might not be the project root when deployed.
        String scriptAbsolutePath = Paths.get(System.getProperty("user.dir"), SCRIPT_RELATIVE_PATH).toAbsolutePath().toString();

        // Create a ProcessBuilder to execute the Node.js script.
        // The first argument is the Node.js executable, the second is the script path.
        ProcessBuilder processBuilder = new ProcessBuilder(NODE_PATH, scriptAbsolutePath);

        // Redirect the error stream of the child process to its output stream.
        // This allows us to capture any errors printed by the Node.js script.
        processBuilder.redirectErrorStream(true);

        Process process = null;
        try {
            process = processBuilder.start(); // Start the Node.js process

            // Write the HTML content to the standard input (stdin) of the Node.js process.
            // The Puppeteer script will read this content.
            try (OutputStream os = process.getOutputStream()) {
                os.write(htmlContent.getBytes(StandardCharsets.UTF_8));
                os.flush(); // Ensure all data is written
            }

            // Read the PDF output from the standard output (stdout) of the Node.js process.
            // This is where the Puppeteer script writes the generated PDF binary data.
            ByteArrayOutputStream pdfOutputStream = new ByteArrayOutputStream();
            try (InputStream is = process.getInputStream()) {
                byte[] buffer = new byte[4096]; // Buffer for reading data
                int bytesRead;
                while ((bytesRead = is.read(buffer)) != -1) {
                    pdfOutputStream.write(buffer, 0, bytesRead);
                }
            }

            // Wait for the Node.js process to complete and get its exit code.
            int exitCode = process.waitFor();

            // Check the exit code of the Node.js script.
            // A non-zero exit code indicates an error.
            if (exitCode != 0) {
                // If there was an error, the output stream might contain error messages
                String errorOutput = new String(pdfOutputStream.toByteArray(), StandardCharsets.UTF_8);
                System.err.println("Puppeteer script exited with error code: " + exitCode);
                System.err.println("Puppeteer script output (error/debug): " + errorOutput);
                throw new IOException("Failed to generate PDF. Puppeteer script exited with code " + exitCode + ". Output: " + errorOutput);
            }

            return pdfOutputStream.toByteArray(); // Return the generated PDF bytes

        } catch (InterruptedException e) {
            // Handle cases where the current thread is interrupted while waiting for the process
            Thread.currentThread().interrupt(); // Restore the interrupted status
            throw new IOException("Puppeteer script execution interrupted", e);
        } finally {
            // Ensure the process resources are cleaned up
            if (process != null) {
                process.destroy(); // Terminate the process if it's still running
            }
        }
    }
}
