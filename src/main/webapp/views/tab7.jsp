<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h3>Tab 7: PDF Generation from HTML Code using Puppeteer Library</h3>

<div class="row">
    <div class="col-md-6">
        <div class="card">
            <div class="card-header">
                <h5>Generate PDF</h5>
            </div>
            <div class="card-body">
                <p>Generate a simple "Hello World" PDF:</p>
                <!-- Link to generate "Hello World" PDF. target="_blank" opens it in a new tab. -->
                <a href="<c:url value='/pdf/hello-world'/>" class="btn btn-success" target="_blank">
                    <i class="fas fa-file-pdf"></i> Generate Hello World PDF
                </a>

                <hr>

                <p>Generate PDF from custom HTML:</p>
                <div class="form-group">
                    <label for="customHtml">HTML Content:</label>
                    <!-- Textarea for user to input custom HTML -->
                    <textarea id="customHtml" class="form-control" rows="8" placeholder="Enter HTML content here...">
<h1>Custom PDF Content</h1>
<p>This is a sample HTML content that will be converted to PDF.</p>
<ul>
    <li>Item 1</li>
    <li>Item 2</li>
    <li>Item 3</li>
</ul>
<p>Generated on: <span id="currentDate"></span></p>
                    </textarea>
                </div>
                <!-- Button to trigger custom PDF generation -->
                <button id="generateCustomPdf" class="btn btn-primary mt-2">
                    <i class="fas fa-file-pdf"></i> Generate Custom PDF
                </button>
            </div>
        </div>
    </div>
    <div class="col-md-6">
        <div class="card">
            <div class="card-header">
                <h5>HTML Preview</h5>
            </div>
            <div class="card-body">
                <!-- Live preview of the HTML content entered in the textarea -->
                <div id="htmlPreview" style="border: 1px solid #ddd; padding: 15px; min-height: 200px; overflow: auto;">
                    <!-- HTML content will be previewed here -->
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Custom Message Box Modal (replaces alert() for better UX) -->
<div class="modal fade" id="messageModal" tabindex="-1" aria-labelledby="messageModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="messageModalLabel">Message</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="messageModalBody">
                <!-- Message content will be inserted here by JavaScript -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function(){
        // Set current date in the initial HTML content of the textarea
        const today = new Date();
        const dateOptions = { year: 'numeric', month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit' };
        $('#currentDate').text(today.toLocaleDateString('en-US', dateOptions));

        // Update HTML preview dynamically as the textarea content changes
        $('#customHtml').on('input', function(){
            $('#htmlPreview').html($(this).val());
        });

        // Perform an initial preview when the page loads
        $('#htmlPreview').html($('#customHtml').val());

        // Function to display custom messages using the Bootstrap modal
        function showMessage(title, message) {
            $('#messageModalLabel').text(title); // Set modal title
            $('#messageModalBody').text(message); // Set modal body message
            var messageModal = new bootstrap.Modal(document.getElementById('messageModal'));
            messageModal.show(); // Show the modal
        }

        // Event listener for the "Generate Custom PDF" button click
        $('#generateCustomPdf').click(function(){
            var htmlContent = $('#customHtml').val(); // Get HTML content from the textarea

            // Validate if the HTML content is empty
            if (!htmlContent.trim()) {
                showMessage('Input Error', 'Please enter some HTML content to generate PDF.');
                return; // Stop execution if content is empty
            }

            // Show a loading indicator on the button for better user feedback
            const $button = $(this);
            const originalButtonText = $button.html(); // Store original button text
            $button.prop('disabled', true).html('<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Generating PDF...');

            // Make an AJAX POST request to the Spring Boot backend
            $.ajax({
                url: '<c:url value="/pdf/generate"/>', // URL to the PDF generation endpoint
                type: 'POST',
                contentType: 'text/plain', // Send HTML content as plain text
                data: htmlContent,
                xhrFields: {
                    responseType: 'blob' // Crucial: Expect a binary blob response (the PDF file)
                },
                success: function(response){
                    // On successful response, create a Blob from the received binary data
                    // and trigger a download for the PDF file.
                    var blob = new Blob([response], {type: 'application/pdf'}); // Set MIME type to PDF
                    var url = window.URL.createObjectURL(blob); // Create a temporary URL for the blob
                    var a = document.createElement('a'); // Create a temporary anchor element
                    a.href = url;
                    a.download = 'generated.pdf'; // Set the download filename
                    document.body.appendChild(a); // Append the anchor to the body (necessary for click)
                    a.click(); // Programmatically click the anchor to trigger download
                    window.URL.revokeObjectURL(url); // Clean up the temporary URL
                    document.body.removeChild(a); // Remove the temporary anchor
                    showMessage('Success', 'PDF generated successfully!'); // Show success message
                },
                error: function(xhr, status, error){
                    // Handle errors during the AJAX request or PDF generation
                    let errorMessage = 'PDF generation failed: ' + (error || 'Unknown error');
                    if (xhr.responseText) {
                        try {
                            // Attempt to parse error response if it's JSON (e.g., from server-side errors)
                            const errorJson = JSON.parse(xhr.responseText);
                            if (errorJson.message) {
                                errorMessage = 'PDF generation failed: ' + errorJson.message;
                            }
                        } catch (e) {
                            // If not JSON, use the raw response text
                            errorMessage = 'PDF generation failed: ' + xhr.responseText;
                        }
                    }
                    showMessage('Error', errorMessage); // Show error message
                },
                complete: function() {
                    // This callback runs regardless of success or error, used for cleanup
                    $button.prop('disabled', false).html(originalButtonText); // Restore button state and text
                }
            });
        });
    });
</script>
