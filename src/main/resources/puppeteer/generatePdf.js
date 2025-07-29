#!/usr/bin/env node
import puppeteer from 'puppeteer';

async function readStdin() {
    let html = '';
    process.stdin.setEncoding('utf8');
    for await (const chunk of process.stdin) {
        html += chunk;
    }
    return html.trim();
}

(async () => {
    const htmlContent = await readStdin();
    if (!htmlContent) {
        console.error('Error: No HTML content provided.');
        process.exit(1);
    }

    let browser;
    try {
        console.log('Launching Puppeteer browser...');
        browser = await puppeteer.launch({
            headless: 'new', // use the new unified headless mode
            args: [
                '--no-sandbox',
                '--disable-setuid-sandbox',
                '--disable-dev-shm-usage', // This is crucial for environments with limited /dev/shm
                '--disable-gpu',
                '--no-first-run',
                '--no-zygote'
                // The '--single-process' argument has been removed as it can cause instability.
            ]
        });
        console.log('Browser launched successfully.');

        // There’s always at least one page open by default
        const [page] = await browser.pages();
        console.log('Navigating to data URI...');

        // Navigate to a data: URL so that all resources (images, styles) load, then wait for true idle
        const dataUri = `data:text/html;charset=UTF-8,${encodeURIComponent(htmlContent)}`;
        // Increased timeout for navigation to 60 seconds (60000 ms)
        await page.goto(dataUri, { waitUntil: 'networkidle0', timeout: 60000 }); // wait for no network for 500 ms
        console.log('Navigation complete. Generating PDF...');

        // Generate PDF
        // Increased timeout for PDF generation to 60 seconds (60000 ms)
        const pdfBuffer = await page.pdf({
            format: 'A4',
            printBackground: true,
            margin: {
                top: '20mm',
                right: '20mm',
                bottom: '20mm',
                left: '20mm'
            },
            timeout: 60000 // Timeout for PDF generation
        });
        console.log('PDF generated successfully.');

        // Output PDF bytes to stdout
        process.stdout.write(pdfBuffer);

    } catch (error) {
        console.error(`Error generating PDF with Puppeteer: ${error.message}`);
        if (error.stack) {
            console.error(error.stack);
        }
        process.exit(1); // Exit with error code
    } finally {
        if (browser) {
            console.log('Closing browser...');
            await browser.close();
            console.log('Browser closed.');
        }
    }
})();