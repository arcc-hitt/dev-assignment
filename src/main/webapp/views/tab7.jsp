<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h3 id="tab7-title">Tab 7: PDF Generation</h3>

<div class="card">
    <div class="card-header">
        <h5 id="pdfSampleHeader">Sample PDF Generation using Puppeteer Library</h5>
    </div>
    <div class="card-body">
        <p id="pdfSampleDescription">Simple Hello World PDF Generation:</p>
        <a href="<c:url value='/pdf/hello-world'/>" class="btn btn-primary" id="generatePdfBtn" target="_blank" onclick="handlePdfGeneration(event)">
            Generate Hello World PDF
        </a>
        <!-- Status/Error message container -->
        <div id="tab7StatusMessage" class="mt-3" aria-live="polite"></div>
    </div>
</div>

<script>
// Handle PDF generation with user feedback
function handlePdfGeneration(event) {
    const statusDiv = document.getElementById('tab7StatusMessage');
    if (statusDiv) {
        statusDiv.innerHTML = '<span class="text-info"><i class="fas fa-spinner fa-spin"></i> Generating PDF...</span>';
    }
    
    // Clear the status message after a delay
    setTimeout(function() {
        if (statusDiv) {
            statusDiv.innerHTML = '';
        }
    }, 3000);
}

// Add error handling for PDF link
document.addEventListener('DOMContentLoaded', function() {
    const pdfLink = document.getElementById('generatePdfBtn');
    if (pdfLink) {
        pdfLink.addEventListener('error', function() {
            const statusDiv = document.getElementById('tab7StatusMessage');
            if (statusDiv) {
                statusDiv.innerHTML = '<span class="text-danger"><i class="fas fa-exclamation-triangle"></i> Failed to generate PDF. Please try again.</span>';
            }
        });
    }
});
</script>