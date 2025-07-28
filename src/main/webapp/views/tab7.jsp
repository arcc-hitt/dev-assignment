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
                <a href="<c:url value='/pdf/hello-world'/>" class="btn btn-success" target="_blank">
                    <i class="fas fa-file-pdf"></i> Generate Hello World PDF
                </a>
                
                <hr>
                
                <p>Generate PDF from custom HTML:</p>
                <div class="form-group">
                    <label for="customHtml">HTML Content:</label>
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
                <button id="generateCustomPdf" class="btn btn-primary mt-2">
                    <i class="fas fa-file-pdf"></i> Generate Custom PDF
                </button>
            </div>
        </div>
    </div>
    
    <div class="col-md-6">
        <div class="card">
            <div class="card-header">
                <h5>PDF Generation Info</h5>
            </div>
            <div class="card-body">
                <h6>Features:</h6>
                <ul>
                    <li>Generate PDF from HTML content</li>
                    <li>Support for custom styling</li>
                    <li>Hello World sample PDF</li>
                    <li>Real-time PDF generation</li>
                </ul>
                
                <h6>Technical Details:</h6>
                <ul>
                    <li>Uses HTML to PDF conversion</li>
                    <li>Supports CSS styling</li>
                    <li>Generates downloadable files</li>
                    <li>Cross-browser compatible</li>
                </ul>
                
                <div class="alert alert-info">
                    <strong>Note:</strong> This implementation uses HTML to PDF conversion. 
                    In a production environment, you would use a proper PDF library like iText, 
                    Apache PDFBox, or a headless browser solution.
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Sample HTML Preview -->
<div class="card mt-4">
    <div class="card-header">
        <h5>HTML Preview</h5>
    </div>
    <div class="card-body">
        <div id="htmlPreview" class="border p-3 bg-light">
            <!-- Preview will be shown here -->
        </div>
    </div>
</div>

<script>
    $(function(){
        // Set current date in the textarea
        var currentDate = new Date().toLocaleDateString();
        $('#customHtml').val($('#customHtml').val().replace('<span id="currentDate"></span>', currentDate));
        
        // Update preview when textarea changes
        $('#customHtml').on('input', function(){
            $('#htmlPreview').html($(this).val());
        });
        
        // Initial preview
        $('#htmlPreview').html($('#customHtml').val());
        
        // Generate custom PDF
        $('#generateCustomPdf').click(function(){
            var htmlContent = $('#customHtml').val();
            
            if (!htmlContent.trim()) {
                alert('Please enter some HTML content');
                return;
            }
            
            $.ajax({
                url: '<c:url value="/pdf/generate"/>',
                type: 'POST',
                contentType: 'text/plain',
                data: htmlContent,
                success: function(response){
                    // Create a download link
                    var blob = new Blob([response], {type: 'text/html'});
                    var url = window.URL.createObjectURL(blob);
                    var a = document.createElement('a');
                    a.href = url;
                    a.download = 'generated.html';
                    document.body.appendChild(a);
                    a.click();
                    window.URL.revokeObjectURL(url);
                    document.body.removeChild(a);
                },
                error: function(xhr, status, error){
                    alert('PDF generation failed: ' + error);
                }
            });
        });
    });
</script>
