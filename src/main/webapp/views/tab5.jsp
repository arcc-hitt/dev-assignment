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

<!-- Data Preview Table with Filters -->
<div class="card">
    <div class="card-header bg-info text-white d-flex justify-content-between align-items-center">
        <h5 class="mb-0"><i class="fas fa-table"></i> Database Records</h5>
        <button type="button" class="btn btn-outline-light btn-sm" onclick="clearAllFiltersTab5()">
            <i class="fas fa-eraser"></i> Clear All Filters
        </button>
    </div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-sm table-striped mb-0" id="excelDataTable">
                <thead>
                <!-- filter row -->
                <tr class="bg-light">
                    <th width="5%">#</th>
                    <th width="25%">
                        <div class="input-group input-group-sm">
                            <input
                                    type="text"
                                    id="searchPrefixFilterTab5"
                                    class="form-control form-control-sm"
                                    placeholder="Search Prefix">
                            <div class="input-group-append">
                                <button class="btn btn-outline-secondary btn-sm" onclick="applyFilterTab5()">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                        </div>
                    </th>
                    <th width="20%">
                        <select
                                id="genderFilterTab5"
                                class="form-control form-control-sm">
                            <option value="">All Genders</option>
                            <option>Male</option>
                            <option>Female</option>
                            <option>Other</option>
                        </select>
                    </th>
                    <th width="50%">
                        <input
                                type="text"
                                id="prefixOfFilterTab5"
                                class="form-control form-control-sm"
                                placeholder="Search Prefix Of">
                    </th>
                </tr>
                <tr class="thead-dark">
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

<!-- Pagination Footer -->
<div class="d-flex justify-content-between align-items-center p-3 border-top bg-white">
    <!-- Total records and Page size -->
    <div>
        <span id="recordCountTab5" class="badge badge-info">Total: 0 records</span>
    </div>
    <div class="form-inline">
        <label class="mr-2 mb-0" for="pageSizeSelectTab5">Page Size:</label>
        <select id="pageSizeSelectTab5" class="form-control form-control-sm" onchange="changePageSizeTab5()">
            <option value="5">5</option>
            <option value="10" selected>10</option>
            <option value="20">20</option>
            <option value="50">50</option>
        </select>
    </div>

    <!-- Page info -->
    <div id="pageInfoTab5" class="text-muted">Page 1 of 1</div>

    <!-- Pagination controls -->
    <nav>
        <ul class="pagination pagination-sm mb-0" id="paginationControlsTab5">
            <!-- Injected by JS -->
        </ul>
    </nav>
</div>

<script>
    // State variables for pagination and filtering
    let currentPageTab5 = 1;
    let pageSizeTab5 = 10;
    let totalRecordsTab5 = 0;
    let totalPagesTab5 = 1;
    let currentSearchTab5 = '';
    let currentGenderTab5 = '';
    let currentPrefixOfTab5 = '';
    let searchTimeoutTab5 = null; // For debouncing search input
    let allDataTab5 = []; // Store all data for client-side filtering

    // Initialize Tab 5: Excel download and upload functionality with pagination and filters
    $(document).ready(function () {
        // Initialize filters and pagination
        initFiltersTab5();

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

    // Initialize filters and pagination
    function initFiltersTab5() {
        // Attach event listeners to filter inputs with real-time search
        [
            'searchPrefixFilterTab5',
            'prefixOfFilterTab5'
        ].forEach(function (id) {
            const el = document.getElementById(id);
            if (el) {
                // Add input event listener for real-time search with debouncing
                el.addEventListener('input', function () {
                    // Clear existing timeout
                    if (searchTimeoutTab5) {
                        clearTimeout(searchTimeoutTab5);
                    }
                    // Set new timeout for debounced search
                    searchTimeoutTab5 = setTimeout(function() {
                        applyFilterTab5();
                    }, 300); // 300ms delay
                });

                // Keep enter key functionality
                el.addEventListener('keypress', function (e) {
                    if (e.key === 'Enter') {
                        // Clear timeout and search immediately
                        if (searchTimeoutTab5) {
                            clearTimeout(searchTimeoutTab5);
                        }
                        applyFilterTab5();
                    }
                });
            }
        });

        // For select dropdown, use change event
        const genderFilter = document.getElementById('genderFilterTab5');
        if (genderFilter) {
            genderFilter.addEventListener('change', applyFilterTab5);
        }

        const pageSizeSelect = document.getElementById('pageSizeSelectTab5');
        if (pageSizeSelect) {
            pageSizeSelect.addEventListener('change', function () {
                pageSizeTab5 = parseInt(this.value);
                currentPageTab5 = 1;
                renderFilteredDataTab5();
            });
        }
    }

    // Clear all filters function
    function clearAllFiltersTab5() {
        // Clear all filter inputs
        [
            'searchPrefixFilterTab5',
            'genderFilterTab5',
            'prefixOfFilterTab5'
        ].forEach(function (id) {
            const el = document.getElementById(id);
            if (el) {
                el.value = '';
            }
        });

        // Clear any pending search timeout
        if (searchTimeoutTab5) {
            clearTimeout(searchTimeoutTab5);
        }

        // Reset to first page and reload
        currentPageTab5 = 1;
        renderFilteredDataTab5();
    }

    // Apply filter and render data
    function applyFilterTab5() {
        currentPageTab5 = 1;
        renderFilteredDataTab5();
    }

    // Change page size and reload data
    function changePageSizeTab5() {
        currentPageTab5 = 1;
        renderFilteredDataTab5();
    }

    // Load data preview with pagination and filtering support
    function loadDataPreviewTab5() {
        const tableBody = $('#excelDataTableBody');
        showLoadingTab5();

        $.ajax({
            url: '${pageContext.request.contextPath}/api/prefix/all',
            type: 'GET',
            dataType: 'json',
            success: function (data) {
                if (data && Array.isArray(data)) {
                    allDataTab5 = data; // Store all data
                    renderFilteredDataTab5();
                } else {
                    showErrorTab5('Invalid data format received');
                }
            },
            error: function (xhr, status, error) {
                console.error('Error loading data preview:', error);
                showErrorTab5('Error loading data: ' + error);
            }
        });
    }

    // Render filtered and paginated data
    function renderFilteredDataTab5() {
        currentSearchTab5 = document.getElementById('searchPrefixFilterTab5') ? document.getElementById('searchPrefixFilterTab5').value.trim() : '';
        currentGenderTab5 = document.getElementById('genderFilterTab5') ? document.getElementById('genderFilterTab5').value : '';
        currentPrefixOfTab5 = document.getElementById('prefixOfFilterTab5') ? document.getElementById('prefixOfFilterTab5').value.trim() : '';

        // Apply filters
        const filteredData = allDataTab5.filter(function (item) {
            const matchesSearch = !currentSearchTab5 ||
                (item.searchPrefix && item.searchPrefix.toLowerCase().includes(currentSearchTab5.toLowerCase()));
            const matchesGender = !currentGenderTab5 || item.gender === currentGenderTab5;
            const matchesPrefixOf = !currentPrefixOfTab5 ||
                (item.prefixOf && item.prefixOf.toLowerCase().includes(currentPrefixOfTab5.toLowerCase()));
            return matchesSearch && matchesGender && matchesPrefixOf;
        });

        totalRecordsTab5 = filteredData.length;
        totalPagesTab5 = Math.max(1, Math.ceil(totalRecordsTab5 / pageSizeTab5));

        // Ensure current page is valid
        if (currentPageTab5 > totalPagesTab5) {
            currentPageTab5 = totalPagesTab5;
        }

        updateRecordCountTab5();
        updatePaginationTab5();

        // Get current page data
        const startIndex = (currentPageTab5 - 1) * pageSizeTab5;
        const endIndex = startIndex + pageSizeTab5;
        const pageData = filteredData.slice(startIndex, endIndex);

        renderTableTab5(pageData);
    }

    // Render the table with paginated data
    function renderTableTab5(data) {
        const tableBody = $('#excelDataTableBody');
        tableBody.empty();

        if (!data || data.length === 0) {
            tableBody.html('<tr><td colspan="4" class="text-center text-muted">' +
                '<i class="fas fa-info-circle"></i> No records found.</td></tr>');
            return;
        }

        const startIndex = (currentPageTab5 - 1) * pageSizeTab5;
        $.each(data, function (index, prefix) {
            const rowNumber = startIndex + index + 1;
            const row = '<tr>' +
                '<td>' + rowNumber + '</td>' +
                '<td><strong>' + (prefix.searchPrefix || '') + '</strong></td>' +
                '<td>' + (prefix.gender ?
                    '<span>' + prefix.gender + '</span>' :
                    '<span>--</span>') + '</td>' +
                '<td>' + (prefix.prefixOf || '<span class="text-muted">Not specified</span>') + '</td>' +
                '</tr>';
            tableBody.append(row);
        });
    }

    // Update record count and page info
    function updateRecordCountTab5() {
        const recordCountEl = document.getElementById('recordCountTab5');
        const pageInfoEl = document.getElementById('pageInfoTab5');
        if (recordCountEl) {
            recordCountEl.textContent = 'Total: ' + totalRecordsTab5 + ' records';
        }
        if (pageInfoEl) {
            pageInfoEl.textContent = 'Page ' + currentPageTab5 + ' of ' + totalPagesTab5;
        }
    }

    // Update pagination controls
    function updatePaginationTab5() {
        const ul = document.getElementById('paginationControlsTab5');
        if (!ul) return;
        ul.innerHTML = '';

        if (totalPagesTab5 <= 1) return;

        function mkLi(label, page, disabled, active) {
            return '<li class="page-item' + (disabled ? ' disabled' : '') + (active ? ' active' : '') + '">' +
                '<a class="page-link" href="#"' +
                (disabled ? '' : ' onclick="loadPageTab5(' + page + ');return false;"') +
                '>' + label + '</a></li>';
        }

        ul.insertAdjacentHTML('beforeend', mkLi('<<', currentPageTab5 - 1, currentPageTab5 === 1, false));
        const start = Math.max(1, currentPageTab5 - 2);
        const end = Math.min(totalPagesTab5, start + 4);

        if (start > 1) {
            ul.insertAdjacentHTML('beforeend', mkLi('1', 1, false, false));
            if (start > 2) ul.insertAdjacentHTML('beforeend', mkLi('...', 1, true, false));
        }

        for (let p = start; p <= end; p++) {
            ul.insertAdjacentHTML('beforeend', mkLi(p, p, false, p === currentPageTab5));
        }

        if (end < totalPagesTab5) {
            if (end < totalPagesTab5 - 1) ul.insertAdjacentHTML('beforeend', mkLi('...', 1, true, false));
            ul.insertAdjacentHTML('beforeend', mkLi(totalPagesTab5, totalPagesTab5, false, false));
        }

        ul.insertAdjacentHTML('beforeend', mkLi('>>', currentPageTab5 + 1, currentPageTab5 === totalPagesTab5, false));
    }

    // Load specific page
    function loadPageTab5(page) {
        currentPageTab5 = page || 1;
        renderFilteredDataTab5();
    }

    // Show loading spinner in the table
    function showLoadingTab5() {
        $('#excelDataTableBody').html('<tr><td colspan="4" class="text-center py-4">' +
            '<div class="spinner-border spinner-border-sm mr-2" role="status"></div>Loading data...</td></tr>');
    }

    // Show error in the table
    function showErrorTab5(message) {
        $('#excelDataTableBody').html('<tr><td colspan="4" class="text-center text-danger">' +
            '<i class="fas fa-exclamation-triangle"></i> ' + message + '</td></tr>');
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
</script>