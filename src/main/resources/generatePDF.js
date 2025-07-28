// generatePdf.js
// This script uses Puppeteer to convert HTML content, received via standard input,
// into a PDF document and outputs the PDF binary data to standard output.

const puppeteer = require('puppeteer'); // Import the Puppeteer library

(async () => {
    let htmlContent = ''; // Initialize an empty string to store incoming HTML content

    // Set stdin encoding to UTF-8 to correctly read HTML content
    process.stdin.setEncoding('utf8');

    // Read all HTML content from standard input asynchronously
    // This allows the Java application to pipe the HTML string into this Node.js script
    for await (const chunk of process.stdin) {
        htmlContent += chunk;
    }

    // Basic validation: Check if any HTML content was provided
    if (!htmlContent.trim()) {
        console.error('Error: No HTML content provided to the Puppeteer script.');
        process.exit(1); // Exit with an error code if content is missing
    }

    let browser; // Declare a variable for the Puppeteer browser instance
    try {
        // Launch a new headless browser instance.
        // "headless: 'new'" uses the modern headless mode which is more efficient.
        // 'args' array includes necessary arguments for running Puppeteer in various environments
        // (e.g., Docker, CI/CD pipelines) to prevent sandbox issues.
        browser = await puppeteer.launch({
            headless: "new",
            args: [
                '--no-sandbox',             // Required for some environments (e.g., Docker)
                '--disable-setuid-sandbox', // Required for some environments
                '--disable-dev-shm-usage'   // Overcomes limited resource problems in some environments
            ]
        });

        const page = await browser.newPage(); // Create a new page (tab) in the browser

        // Set the HTML content of the page.
        // 'waitUntil: 'networkidle0'' ensures that the page waits until there are no more
        // than 0 network connections for at least 500 ms, meaning all resources (CSS, JS, images)
        // have likely loaded before PDF generation. This is crucial for accurate rendering.
        await page.setContent(htmlContent, { waitUntil: 'networkidle0' });

        // Generate the PDF from the current page content.
        // 'format: 'A4'' sets the paper size to A4.
        // 'printBackground: true' ensures that background colors and images are included in the PDF.
        // 'margin' defines the page margins in millimeters.
        const pdfBuffer = await page.pdf({
            format: 'A4',
            printBackground: true,
            margin: {
                top: '20mm',
                right: '20mm',
                bottom: '20mm',
                left: '20mm'
            }
        });

        // Write the generated PDF buffer to standard output.
        // The Java application will read this binary data to send it back to the client.
        process.stdout.write(pdfBuffer);

    } catch (error) {
        // Log any errors that occur during the PDF generation process
        console.error('Error generating PDF with Puppeteer:', error);
        process.exit(1); // Exit with an error code
    } finally {
        // Ensure the browser instance is closed to free up system resources,
        // regardless of whether PDF generation was successful or failed.
        if (browser) {
            await browser.close();
        }
    }
})();
