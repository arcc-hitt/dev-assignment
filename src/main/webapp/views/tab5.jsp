<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h3 id="tab5-title" class="mb-4">Tab 5: Excel Download and Upload Feature</h3>

<!-- Download Section -->
<div class="card mb-4">
    <div class="card-header bg-success text-white">
        <h5 class="mb-0"><i class="fas fa-download"></i> Excel Download</h5>
    </div>
    <div class="card-body">
        <div class="row">
            <div class="col-md-6 mb-3">
                <p class="card-text">Download all prefix records from the database in Excel format.</p>
                <a href="<c:url value='/excel/download'/>"
                   class="btn btn-success btn-block"
                   id="downloadAllRecordsBtn">
                    <i class="fas fa-file-excel"></i> Download All Records
                </a>
            </div>
            <div class="col-md-6 mb-3">
                <p class="card-text">Download an empty Excel template for data entry.</p>
                <a href="<c:url value='/excel/template'/>"
                   class="btn btn-info btn-block"
                   id="downloadTemplateBtn">
                    <i class="fas fa-file-download"></i> Download Template
                </a>
            </div>
        </div>
        <div class="mt-3">
            <small class="text-muted">
                <i class="fas fa-lightbulb"></i>
                <strong>Tip:</strong> Use the template to prepare your data before uploading.
            </small>
        </div>
    </div>
</div>

<!-- Upload Section -->
<div class="card mb-4">
    <div class="card-header bg-primary text-white">
        <h5 class="mb-0"><i class="fas fa-upload"></i> Excel Upload</h5>
    </div>
    <div class="card-body">
        <form id="excelUploadForm" enctype="multipart/form-data">
            <div class="form-group">
                <label for="excelFileInput">Select Excel File:</label>
                <input type="file"
                       id="excelFileInput"
                       name="file"
                       class="form-control-file"
                       accept=".xlsx,.xls"
                       required>
                <small class="form-text text-muted">
                    Supported formats: .xlsx, .xls (Max size: 10MB)
                </small>
            </div>
            <button type="submit"
                    class="btn btn-primary btn-block"
                    id="uploadExcelBtn">
                <i class="fas fa-cloud-upload-alt"></i> Upload Excel File
            </button>
        </form>
        <!-- Upload Progress -->
        <div id="excelUploadProgress" class="mt-3" style="display: none;">
            <div class="progress">
                <div class="progress-bar progress-bar-striped progress-bar-animated"
                     role="progressbar"
                     style="width: 100%">
                    Processing...
                </div>
            </div>
        </div>
        <!-- Status/Error message container -->
        <div id="tab5StatusMessage" class="mt-3" aria-live="polite"></div>
    </div>
</div>

<!-- Data Preview Table -->
<div class="card">
    <div class="card-header bg-info text-white">
        <h5 class="mb-0"><i class="fas fa-table"></i> Current Database Records</h5>
    </div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-sm table-striped mb-0" id="excelDataTable">
                <thead class="thead-dark">
                <tr>
                    <th width="5%">#</th>
                    <th width="25%">Search Prefix</th>
                    <th width="20%">Gender</th>
                    <th width="50%">Prefix Of</th>
                </tr>
                </thead>
                <tbody id="excelDataTableBody">
                <tr>
                    <td colspan="4" class="text-center py-4">
                        <div class="spinner-border spinner-border-sm mr-2" role="status"></div>
                        Loading data...
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
// Initialize Tab 5: Excel download and upload functionality
$(document).ready(function () {
    // Load initial data preview
    loadDataPreviewTab5();
    // Download button click tracking with user feedback
    $('#downloadAllRecordsBtn').click(function () {
        showMessageTab5('Download started...', 'info');
    });
    $('#downloadTemplateBtn').click(function () {
        showMessageTab5('Template download started...', 'info');
    });
    // File upload form submission with validation and error handling
    $('#excelUploadForm').on('submit', function (e) {
        e.preventDefault();
        const fileInput = $('#excelFileInput')[0];
        const uploadBtn = $('#uploadExcelBtn');
        const uploadProgress = $('#excelUploadProgress');
        const uploadResult = $('#tab5StatusMessage');
        // Validate file selection
        if (fileInput.files.length === 0) {
            showUploadResultTab5('Please select a file to upload', 'danger');
            return;
        }
        const file = fileInput.files[0];
        const fileName = file.name.toLowerCase();
        // Validate file type
        if (!fileName.endsWith('.xlsx') && !fileName.endsWith('.xls')) {
            showUploadResultTab5('Please select a valid Excel file (.xlsx or .xls)', 'danger');
            return;
        }
        // Validate file size (10MB limit)
        if (file.size > 10 * 1024 * 1024) {
            showUploadResultTab5('File size too large. Please select a file smaller than 10MB', 'danger');
            return;
        }
        // Prepare form data
        const formData = new FormData();
        formData.append('file', $('#excelFileInput')[0].files[0]);
        // Show upload progress
        uploadBtn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Uploading...');
        uploadProgress.show();
        uploadResult.empty();
        // Upload file with error handling
        $.ajax({
            url: '${pageContext.request.contextPath}/excel/upload',
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function (response) {
                uploadProgress.hide();
                uploadBtn.prop('disabled', false).html('<i class="fas fa-cloud-upload-alt"></i> Upload Excel File');
                if (response.success) {
                    const message = response.message;
                    if (response.errorCount > 0) {
                        showUploadResultTab5(message, 'warning');
                    } else {
                        showUploadResultTab5(message, 'success');
                    }
                    // Clear file input
                    $('#excelFileInput').val('');
                    // Auto refresh data display after successful upload
                    setTimeout(function () {
                        loadDataPreviewTab5();
                    }, 1000);
                } else {
                    showUploadResultTab5(response.message, 'danger');
                }
            },
            error: function (xhr, status, error) {
                uploadProgress.hide();
                uploadBtn.prop('disabled', false).html('<i class="fas fa-cloud-upload-alt"></i> Upload Excel File');
                let errorMessage = 'Upload failed: ';
                if (xhr.responseJSON && xhr.responseJSON.message) {
                    errorMessage += xhr.responseJSON.message;
                } else {
                    errorMessage += error || 'Unknown error occurred';
                }
                showUploadResultTab5(errorMessage, 'danger');
            }
        });
    });
    // Load data preview (first 50 records) with error handling
    function loadDataPreviewTab5() {
        const tableBody = $('#excelDataTableBody');
        tableBody.html('<tr><td colspan="4" class="text-center py-4">' +
            '<div class="spinner-border spinner-border-sm mr-2" role="status"></div>Loading data...</td></tr>');
        $.ajax({
            url: '${pageContext.request.contextPath}/api/prefix/all',
            type: 'GET',
            dataType: 'json',
            success: function (data) {
                tableBody.empty();
                if (data && data.length > 0) {
                    // Show first 50 records
                    const displayData = data.slice(0, 50);
                    $.each(displayData, function (index, prefix) {
                        const row = '<tr>' +
                            '<td>' + (index + 1) + '</td>' +
                            '<td><strong>' + (prefix.searchPrefix || '') + '</strong></td>' +
                            '<td>' + (prefix.gender ?
                                '<span class="badge badge-info">' + prefix.gender + '</span>' :
                                '<span class="text-muted">Not specified</span>') + '</td>' +
                            '<td>' + (prefix.prefixOf || '<span class="text-muted">Not specified</span>') + '</td>' +
                            '</tr>';
                        tableBody.append(row);
                    });
                    // Update pagination info
                    if (data.length > 50) {
                        $('#paginationInfo').html('Showing first 50 of ' + data.length + ' records. ' +
                            '<a href="<c:url value="/excel/download"/>">Download Excel</a> for complete data.');
                    } else {
                        $('#paginationInfo').html('Showing all ' + data.length + ' records.');
                    }
                } else {
                    tableBody.html('<tr><td colspan="4" class="text-center text-muted">' +
                        '<i class="fas fa-info-circle"></i> No records found. Upload an Excel file to add data.</td></tr>');
                    $('#paginationInfo').html('No records available.');
                }
            },
            error: function (xhr, status, error) {
                console.error('Error loading data preview:', error);
                tableBody.html('<tr><td colspan="4" class="text-center text-danger">' +
                    '<i class="fas fa-exclamation-triangle"></i> Error loading data: ' + error + '</td></tr>');
                $('#paginationInfo').html('Error loading data.');
            }
        });
    }
    // Show upload result message with appropriate styling
    function showUploadResultTab5(message, type) {
        const alertClass = 'alert-' + type;
        let icon = '';
        switch (type) {
            case 'success':
                icon = '<i class="fas fa-check-circle"></i> ';
                break;
            case 'danger':
                icon = '<i class="fas fa-exclamation-triangle"></i> ';
                break;
            case 'warning':
                icon = '<i class="fas fa-exclamation-circle"></i> ';
                break;
            case 'info':
                icon = '<i class="fas fa-info-circle"></i> ';
                break;
        }
        const alertDiv = '<div class="alert ' + alertClass + ' alert-dismissible fade show" role="alert">' +
            icon + message +
            '<button type="button" class="close" data-dismiss="alert" aria-label="Close">' +
            '<span aria-hidden="true">&times;</span>' +
            '</button>' +
            '</div>';
        $('#tab5StatusMessage').html(alertDiv);
        // Auto-hide success messages after 5 seconds
        if (type === 'success') {
            setTimeout(function () {
                $('#tab5StatusMessage .alert').alert('close');
            }, 5000);
        }
    }
    // Show general messages at the top of the page
    function showMessageTab5(message, type) {
        const alertClass = 'alert-' + type;
        const icon = type === 'info' ? '<i class="fas fa-info-circle"></i> ' : '';
        const alertDiv = '<div class="alert ' + alertClass + ' alert-dismissible fade show" role="alert">' +
            icon + message +
            '<button type="button" class="close" data-dismiss="alert" aria-label="Close">' +
            '<span aria-hidden="true">&times;</span>' +
            '</button>' +
            '</div>';
        // Show message at the top of the page
        if ($('#tempMessageArea').length === 0) {
            $('<div id="tempMessageArea"></div>').insertAfter('h3').first();
        }
        $('#tempMessageArea').html(alertDiv);
        // Auto-hide after 3 seconds
        setTimeout(function () {
            $('#tempMessageArea .alert').alert('close');
        }, 3000);
    }
    // File input change event for validation feedback
    $('#excelFileInput').on('change', function () {
        const file = this.files[0];
        const uploadResult = $('#tab5StatusMessage');
        if (file) {
            const fileName = file.name.toLowerCase();
            const fileSize = file.size;
            // Clear previous messages
            uploadResult.empty();
            // Validate file type
            if (!fileName.endsWith('.xlsx') && !fileName.endsWith('.xls')) {
                showUploadResultTab5('Invalid file type. Please select an Excel file (.xlsx or .xls)', 'warning');
                $(this).val('');
                return;
            }
            // Validate file size
            if (fileSize > 10 * 1024 * 1024) {
                showUploadResultTab5('File too large (' + Math.round(fileSize / (1024 * 1024)) + 'MB). Maximum size is 10MB.', 'warning');
                $(this).val('');
                return;
            }
            // Show file info if valid
            const fileSizeText = fileSize < 1024 * 1024 ?
                Math.round(fileSize / 1024) + ' KB' :
                Math.round(fileSize / (1024 * 1024) * 10) / 10 + ' MB';
            showUploadResultTab5('File selected: ' + file.name + ' (' + fileSizeText + '). Ready to upload.', 'info');
        }
    });
});
</script>