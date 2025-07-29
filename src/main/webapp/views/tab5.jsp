<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h3>Tab 5: Excel Download and Upload Feature</h3>

<!-- Current Records Display -->
<div class="row mb-4">
    <div class="col-12">
        <div class="alert alert-info">
            <h5><i class="fas fa-info-circle"></i> Current Database Status</h5>
            <p class="mb-2">Total records in database: <span id="recordCount" class="badge badge-primary">Loading...</span></p>
            <button id="refreshCountBtn" class="btn btn-sm btn-outline-info">
                <i class="fas fa-sync-alt"></i> Refresh Count
            </button>
        </div>
    </div>
</div>

<!-- Download Section -->
<div class="row mb-4">
    <div class="col-md-6">
        <div class="card">
            <div class="card-header bg-success text-white">
                <h5 class="mb-0"><i class="fas fa-download"></i> Excel Download</h5>
            </div>
            <div class="card-body">
                <p class="card-text">Download all prefix records from the database in Excel format.</p>
                <a href="<c:url value='/excel/download'/>"
                   class="btn btn-success btn-lg btn-block"
                   id="downloadBtn">
                    <i class="fas fa-file-excel"></i> Download All Records
                </a>

                <hr>

                <p class="card-text">Download an empty Excel template for data entry.</p>
                <a href="<c:url value='/excel/template'/>"
                   class="btn btn-info btn-lg btn-block"
                   id="templateBtn">
                    <i class="fas fa-file-download"></i> Download Template
                </a>

                <div class="mt-3">
                    <small class="text-muted">
                        <i class="fas fa-lightbulb"></i>
                        <strong>Tip:</strong> Use the template to prepare your data before uploading.
                    </small>
                </div>
            </div>
        </div>
    </div>

    <!-- Upload Section -->
    <div class="col-md-6">
        <div class="card">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0"><i class="fas fa-upload"></i> Excel Upload</h5>
            </div>
            <div class="card-body">
                <form id="uploadForm" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="excelFile">Select Excel File:</label>
                        <input type="file"
                               id="excelFile"
                               name="file"
                               class="form-control-file"
                               accept=".xlsx,.xls"
                               required>
                        <small class="form-text text-muted">
                            Supported formats: .xlsx, .xls (Max size: 10MB)
                        </small>
                    </div>

                    <button type="submit"
                            class="btn btn-primary btn-lg btn-block"
                            id="uploadBtn">
                        <i class="fas fa-cloud-upload-alt"></i> Upload Excel File
                    </button>
                </form>

                <!-- Upload Progress -->
                <div id="uploadProgress" class="mt-3" style="display: none;">
                    <div class="progress">
                        <div class="progress-bar progress-bar-striped progress-bar-animated"
                             role="progressbar"
                             style="width: 100%">
                            Processing...
                        </div>
                    </div>
                </div>

                <!-- Upload Result -->
                <div id="uploadResult" class="mt-3"></div>
            </div>
        </div>
    </div>
</div>

<!-- Data Preview Table -->
<div class="card">
    <div class="card-header bg-info text-white d-flex justify-content-between align-items-center">
        <h5 class="mb-0"><i class="fas fa-table"></i> Current Database Records</h5>
        <button id="refreshDataBtn" class="btn btn-sm btn-light">
            <i class="fas fa-sync-alt"></i> Refresh Data
        </button>
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-striped table-hover" id="dataTable">
                <thead class="thead-dark">
                <tr>
                    <th width="5%">#</th>
                    <th width="25%">Search Prefix</th>
                    <th width="20%">Gender</th>
                    <th width="50%">Prefix Of</th>
                </tr>
                </thead>
                <tbody id="dataTableBody">
                <tr>
                    <td colspan="4" class="text-center">
                        <div class="spinner-border spinner-border-sm" role="status">
                            <span class="sr-only">Loading...</span>
                        </div>
                        Loading data...
                    </td>
                </tr>
                </tbody>
            </table>
        </div>

        <!-- Pagination for large datasets -->
        <div id="paginationInfo" class="mt-3 text-center text-muted">
            Showing first 50 records. Use Excel download for complete data.
        </div>
    </div>
</div>

<!-- Sample Data Structure -->
<div class="card mt-4">
    <div class="card-header bg-warning text-dark">
        <h5 class="mb-0"><i class="fas fa-info"></i> Excel File Format Guide</h5>
    </div>
    <div class="card-body">
        <h6>Required Format:</h6>
        <p>Your Excel file should have the following columns in this exact order:</p>

        <div class="table-responsive">
            <table class="table table-sm table-bordered">
                <thead class="thead-light">
                <tr>
                    <th>Column A</th>
                    <th>Column B</th>
                    <th>Column C</th>
                </tr>
                </thead>
                <tbody>
                <tr class="table-success">
                    <td><strong>Search Prefix</strong></td>
                    <td><strong>Gender</strong></td>
                    <td><strong>Prefix Of</strong></td>
                </tr>
                </tbody>
            </table>
        </div>

        <h6 class="mt-3">Sample Data:</h6>
        <div class="table-responsive">
            <table class="table table-sm table-striped">
                <thead class="thead-dark">
                <tr>
                    <th>Search Prefix</th>
                    <th>Gender</th>
                    <th>Prefix Of</th>
                </tr>
                </thead>
                <tbody>
                <tr><td>Dr.</td><td></td><td>S/O,H/O,F/O,D/O,W/O,M/O</td></tr>
                <tr><td>Prof.</td><td></td><td>S/O,H/O,F/O,D/O,W/O,M/O</td></tr>
                <tr><td>Mrs.</td><td>Female</td><td>D/O,W/O,M/O</td></tr>
                <tr><td>Master</td><td>Male</td><td>S/O</td></tr>
                <tr><td>Baby boy of</td><td>Male</td><td>S/O</td></tr>
                <tr><td>Baby girl of</td><td>Female</td><td>D/O</td></tr>
                <tr><td>Mx.</td><td>Other</td><td></td></tr>
                </tbody>
            </table>
        </div>

        <div class="alert alert-warning mt-3">
            <i class="fas fa-exclamation-triangle"></i>
            <strong>Important Notes:</strong>
            <ul class="mb-0 mt-2">
                <li>Search Prefix column is required and cannot be empty</li>
                <li>Gender and Prefix Of columns are optional</li>
                <li>Duplicate Search Prefix values will be rejected</li>
                <li>The first row should contain column headers</li>
                <li>Sample data in the template should be deleted before uploading</li>
            </ul>
        </div>
    </div>
</div>

<style>
    .card {
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        border: none;
        margin-bottom: 1.5rem;
    }

    .card-header {
        font-weight: 600;
        border-bottom: none;
    }

    .btn-lg {
        padding: 0.75rem 1.5rem;
        font-size: 1.1rem;
    }

    .table th {
        border-top: none;
        font-weight: 600;
    }

    .table tbody tr:hover {
        background-color: #f8f9fa;
    }

    #uploadProgress .progress {
        height: 25px;
    }

    #uploadProgress .progress-bar {
        font-size: 14px;
        line-height: 25px;
    }

    .alert-success {
        border-left: 4px solid #28a745;
    }

    .alert-danger {
        border-left: 4px solid #dc3545;
    }

    .alert-warning {
        border-left: 4px solid #ffc107;
    }

    .spinner-border-sm {
        width: 1rem;
        height: 1rem;
    }

    @media (max-width: 768px) {
        .btn-lg {
            padding: 0.5rem 1rem;
            font-size: 1rem;
        }

        .card-body {
            padding: 1rem;
        }
    }
</style>

<script>
    $(document).ready(function(){

        // Load initial data
        loadRecordCount();
        loadDataPreview();

        // Refresh count button
        $('#refreshCountBtn').click(function(){
            loadRecordCount();
        });

        // Refresh data button
        $('#refreshDataBtn').click(function(){
            loadDataPreview();
            loadRecordCount();
        });

        // Download button click tracking
        $('#downloadBtn').click(function(){
            showMessage('Download started...', 'info');
        });

        $('#templateBtn').click(function(){
            showMessage('Template download started...', 'info');
        });

        // File upload form submission
        $('#uploadForm').on('submit', function(e){
            e.preventDefault();

            var fileInput = $('#excelFile')[0];
            var uploadBtn = $('#uploadBtn');
            var uploadProgress = $('#uploadProgress');
            var uploadResult = $('#uploadResult');

            // Validate file selection
            if (fileInput.files.length === 0) {
                showUploadResult('Please select a file to upload', 'danger');
                return;
            }

            var file = fileInput.files[0];
            var fileName = file.name.toLowerCase();

            // Validate file type
            if (!fileName.endsWith('.xlsx') && !fileName.endsWith('.xls')) {
                showUploadResult('Please select a valid Excel file (.xlsx or .xls)', 'danger');
                return;
            }

            // Validate file size (10MB limit)
            if (file.size > 10 * 1024 * 1024) {
                showUploadResult('File size too large. Please select a file smaller than 10MB', 'danger');
                return;
            }

            // Prepare form data
            var formData = new FormData();
            formData.append('file', $('#excelFile')[0].files[0]);

            // Show upload progress
            uploadBtn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Uploading...');
            uploadProgress.show();
            uploadResult.empty();

            // Upload file
            $.ajax({
                url: '${pageContext.request.contextPath}/excel/upload',
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                success: function(response){
                    uploadProgress.hide();
                    uploadBtn.prop('disabled', false).html('<i class="fas fa-cloud-upload-alt"></i> Upload Excel File');

                    if (response.success) {
                        var message = response.message;
                        if (response.errorCount > 0) {
                            showUploadResult(message, 'warning');
                        } else {
                            showUploadResult(message, 'success');
                        }

                        // Clear file input
                        $('#excelFile').val('');

                        // Refresh data display
                        loadDataPreview();
                        loadRecordCount();
                    } else {
                        showUploadResult(response.message, 'danger');
                    }
                },
                error: function(xhr, status, error){
                    uploadProgress.hide();
                    uploadBtn.prop('disabled', false).html('<i class="fas fa-cloud-upload-alt"></i> Upload Excel File');

                    var errorMessage = 'Upload failed: ';
                    if (xhr.responseJSON && xhr.responseJSON.message) {
                        errorMessage += xhr.responseJSON.message;
                    } else {
                        errorMessage += error || 'Unknown error occurred';
                    }

                    showUploadResult(errorMessage, 'danger');
                }
            });
        });

        // Load record count
        function loadRecordCount() {
            $('#recordCount').html('<i class="fas fa-spinner fa-spin"></i>');

            $.getJSON('<c:url value="/excel/count"/>')
                .done(function(data) {
                    $('#recordCount').text(data.count);
                })
                .fail(function() {
                    $('#recordCount').text('Error loading count');
                });
        }

        // Load data preview (first 50 records)
        function loadDataPreview() {
            var tableBody = $('#dataTableBody');
            tableBody.html('<tr><td colspan="4" class="text-center">' +
                '<div class="spinner-border spinner-border-sm" role="status">' +
                '<span class="sr-only">Loading...</span></div> Loading data...</td></tr>');

            $.getJSON('<c:url value="/api/prefix/all"/>')
                .done(function(data) {
                    tableBody.empty();

                    if (data && data.length > 0) {
                        // Show first 50 records
                        var displayData = data.slice(0, 50);

                        $.each(displayData, function(index, prefix) {
                            var row = '<tr>' +
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
                })
                .fail(function(xhr, status, error) {
                    tableBody.html('<tr><td colspan="4" class="text-center text-danger">' +
                        '<i class="fas fa-exclamation-triangle"></i> Error loading data: ' + error + '</td></tr>');
                    $('#paginationInfo').html('Error loading data.');
                });
        }

        // Show upload result message
        function showUploadResult(message, type) {
            var alertClass = 'alert-' + type;
            var icon = '';

            switch(type) {
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

            var alertDiv = '<div class="alert ' + alertClass + ' alert-dismissible fade show" role="alert">' +
                icon + message +
                '<button type="button" class="close" data-dismiss="alert" aria-label="Close">' +
                '<span aria-hidden="true">&times;</span>' +
                '</button>' +
                '</div>';

            $('#uploadResult').html(alertDiv);

            // Auto-hide success messages after 5 seconds
            if (type === 'success') {
                setTimeout(function() {
                    $('#uploadResult .alert').alert('close');
                }, 5000);
            }
        }

        // Show general messages
        function showMessage(message, type) {
            var alertClass = 'alert-' + type;
            var icon = type === 'info' ? '<i class="fas fa-info-circle"></i> ' : '';

            var alertDiv = '<div class="alert ' + alertClass + ' alert-dismissible fade show" role="alert">' +
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
            setTimeout(function() {
                $('#tempMessageArea .alert').alert('close');
            }, 3000);
        }

        // File input change event for validation feedback
        $('#excelFile').on('change', function() {
            var file = this.files[0];
            var uploadResult = $('#uploadResult');

            if (file) {
                var fileName = file.name.toLowerCase();
                var fileSize = file.size;

                // Clear previous messages
                uploadResult.empty();

                // Validate file type
                if (!fileName.endsWith('.xlsx') && !fileName.endsWith('.xls')) {
                    showUploadResult('Invalid file type. Please select an Excel file (.xlsx or .xls)', 'warning');
                    $(this).val('');
                    return;
                }

                // Validate file size
                if (fileSize > 10 * 1024 * 1024) {
                    showUploadResult('File too large (' + Math.round(fileSize / (1024 * 1024)) + 'MB). Maximum size is 10MB.', 'warning');
                    $(this).val('');
                    return;
                }

                // Show file info if valid
                var fileSizeText = fileSize < 1024 * 1024 ?
                    Math.round(fileSize / 1024) + ' KB' :
                    Math.round(fileSize / (1024 * 1024) * 10) / 10 + ' MB';

                showUploadResult('File selected: ' + file.name + ' (' + fileSizeText + '). Ready to upload.', 'info');
            }
        });
    });
</script>