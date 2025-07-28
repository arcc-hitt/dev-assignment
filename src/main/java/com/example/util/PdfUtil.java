package com.example.util;

import org.springframework.stereotype.Component;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;

@Component
public class PdfUtil {

    public byte[] generatePdfFromHtml(String htmlContent) throws IOException {
        // For now, we'll create a simple HTML file that can be converted to PDF
        // In a real implementation, you would use a proper PDF library like iText or Apache PDFBox
        String fullHtml = "<!DOCTYPE html>\n" +
            "<html>\n" +
            "<head>\n" +
            "    <title>Generated PDF</title>\n" +
            "    <style>\n" +
            "        body { font-family: Arial, sans-serif; margin: 20px; }\n" +
            "        h1 { color: #333; }\n" +
            "        p { font-size: 14px; line-height: 1.6; }\n" +
            "    </style>\n" +
            "</head>\n" +
            "<body>\n" +
            htmlContent +
            "\n</body>\n" +
            "</html>";
        
        return fullHtml.getBytes(StandardCharsets.UTF_8);
    }

    public byte[] generateHelloWorldPdf() throws IOException {
        String htmlContent = "<h1>Hello World!</h1>\n" +
            "<p>This is a simple PDF generated using HTML to PDF conversion.</p>\n" +
            "<p>Generated on: " + java.time.LocalDateTime.now() + "</p>\n" +
            "<p>Note: This is a simplified implementation. In production, use a proper PDF library.</p>";
        
        return generatePdfFromHtml(htmlContent);
    }
} 