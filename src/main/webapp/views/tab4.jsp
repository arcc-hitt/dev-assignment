<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h3>Tab 4: Entry Screen with Delete and List Functionality (DWR + Hibernate)</h3>

<!-- Entry Form -->
<div class="card mb-4">
    <div class="card-header bg-primary text-white">
        <h5 class="mb-0"><i class="fas fa-plus-circle"></i> Add New Prefix</h5>
    </div>
    <div class="card-body">
        <form id="prefixEntryForm">
            <div class="row">
                <div class="col-md-4">
                    <div class="form-group">
                        <label for="searchPrefix"><span class="text-danger">*</span> Search Prefix:</label>
                        <input type="text"
                               id="searchPrefix"
                               name="searchPrefix"
                               class="form-control"
                               placeholder="e.g., Mr., Mrs., Dr."
                               maxlength="50"
                               required>
                        <small class="form-text text-muted">Enter the prefix (e.g., Mr., Mrs., Dr.)</small>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label for="gender">Gender:</label>
                        <select id="gender" name="gender" class="form-control">
                            <option value="">Select Gender</option>
                            <option value="Male">Male</option>
                            <option value="Female">Female</option>
                            <option value="Other">Other</option>
                        </select>
                        <small class="form-text text-muted">Optional: Select applicable gender</small>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label for="prefixOf">Prefix Of:</label>
                        <input type="text"
                               id="prefixOf"
                               name="prefixOf"
                               class="form-control"
                               placeholder="e.g., S/O,H/O,F/O"
                               maxlength="100">
                        <small class="form-text text-muted">Relationship indicators (comma separated)</small>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <button type="submit" id="addBtn" class="btn btn-success mr-2">
                        <i class="fas fa-save"></i> Add Prefix
                    </button>
                    <button type="button" id="clearBtn" class="btn btn-secondary mr-2">
                        <i class="fas fa-eraser"></i> Clear Form
                    </button>
                    <button type="button" id="refreshBtn" class="btn btn-info">
                        <i class="fas fa-sync-alt"></i> Refresh List
                    </button>
                </div>
            </div>
        </form>

        <!-- Status Messages -->
        <div id="statusMessages" class="mt-3"></div>
    </div>
</div>

<!-- Data Table -->
<div class="card">
    <div class="card-header bg-info text-white d-flex justify-content-between align-items-center">
        <h5 class="mb-0"><i class="fas fa-list"></i> Prefix List</h5>
        <div>
            <span id="recordCount" class="badge badge-light">Total: 0 records</span>
        </div>
    </div>
    <div class="card-body">
        <!-- Search and Filter -->
        <div class="row mb-3">
            <div class="col-md-6">
                <div class="input-group">
                    <input type="text"
                           id="searchFilter"
                           class="form-control"
                           placeholder="Search by prefix name...">
                    <div class="input-group-append">
                        <button class="btn btn-outline-secondary" type="button" onclick="applyFilter()">
                            <i class="fas fa-search"></i> Search
                        </button>
                        <button class="btn btn-outline-secondary" type="button" onclick="clearFilter()">
                            <i class="fas fa-times"></i> Clear
                        </button>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="input-group">
                    <div class="input-group-prepend">
                        <span class="input-group-text">Gender:</span>
                    </div>
                    <select id="genderFilter" class="form-control" onchange="applyFilter()">
                        <option value="">All Genders</option>
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
            </div>
        </div>

        <!-- Data Table -->
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead class="thead-dark">
                <tr>
                    <th width="5%">#</th>
                    <th width="20%">Search Prefix</th>
                    <th width="15%">Gender</th>
                    <th width="40%">Prefix Of</th>
                    <th width="20%">Actions</th>
                </tr>
                </thead>
                <tbody id="prefixList">
                <tr>
                    <td colspan="5" class="text-center">
                        <div class="spinner-border" role="status">
                            <span class="sr-only">Loading...</span>
                        </div>
                        Loading data...
                    </td>
                </tr>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <div class="d-flex justify-content-between align-items-center mt-3">
            <div>
                <select id="pageSizeSelect" class="form-control" style="width: auto; display: inline-block;" onchange="changePageSize()">
                    <option value="5">5 per page</option>
                    <option value="10" selected>10 per page</option>
                    <option value="20">20 per page</option>
                </select>
            </div>
            <div>
                <span id="pageInfo" class="text-muted">Page 0 of 0</span>
            </div>
            <div>
                <nav aria-label="Prefix pagination">
                    <ul class="pagination pagination-sm mb-0" id="paginationControls">
                        <!-- Pagination will be inserted here -->
                    </ul>
                </nav>
            </div>
        </div>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteConfirmModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title">Confirm Delete</h5>
                <button type="button" class="close text-white" data-dismiss="modal">
                    <span>&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete this prefix?</p>
                <div id="deleteDetails" class="alert alert-info">
                    <!-- Details will be shown here -->
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <button type="button" id="confirmDeleteBtn" class="btn btn-danger">
                    <i class="fas fa-trash"></i> Delete
                </button>
            </div>
        </div>
    </div>
</div>

<style>
    /* Custom styling */
    .card-header {
        font-weight: 600;
    }

    .table th {
        border-top: none;
        font-weight: 600;
    }

    .table tbody tr:hover {
        background-color: #f8f9fa;
    }

    .btn-action {
        padding: 0.25rem 0.5rem;
        font-size: 0.875rem;
        margin: 0 0.125rem;
    }

    .status-message {
        padding: 0.75rem 1rem;
        margin-bottom: 0.5rem;
        border-radius: 0.25rem;
    }

    .status-success {
        color: #155724;
        background-color: #d4edda;
        border: 1px solid #c3e6cb;
    }

    .status-error {
        color: #721c24;
        background-color: #f8d7da;
        border: 1px solid #f5c6cb;
    }

    .required-field {
        border-left: 3px solid #dc3545;
    }

    .form-control:focus {
        border-color: #80bdff;
        box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
    }

    @media (max-width: 768px) {
        .table-responsive {
            font-size: 0.875rem;
        }

        .btn-action {
            display: block;
            margin: 0.125rem 0;
            width: 100%;
        }
    }
</style>

<script type="text/javascript">
    // Global variables
    var currentPage = 1;
    var pageSize = 10;
    var totalRecords = 0;
    var totalPages = 0;
    var currentFilter = '';
    var currentGenderFilter = '';
    var deleteId = null;

    // Check if DWR is loaded
    var dwrLoaded = false;

    // Initialize Tab 4
    function initTab4() {
        console.log("Initializing Tab 4...");

        // Check if DWR and prefixService are available
        if (typeof dwr !== 'undefined' && typeof prefixService !== 'undefined') {
            dwrLoaded = true;
            console.log("DWR loaded successfully");

            // Configure DWR
            dwr.engine.setAsync(true);
            dwr.engine.setErrorHandler(function(msg, ex) {
                console.error("DWR error:", msg, ex);
                showMessage("Error connecting to server: " + msg, 'error');
            });
        } else {
            console.warn("DWR or prefixService not available");
        }

        // Setup event listeners
        setupEventListeners();

        // Load initial data
        loadPrefixList();
    }

    // Setup event listeners
    function setupEventListeners() {
        // Form submission
        var form = document.getElementById('prefixEntryForm');
        if (form) {
            form.addEventListener('submit', function(e) {
                e.preventDefault();
                addPrefix();
            });
        }

        // Clear button
        var clearBtn = document.getElementById('clearBtn');
        if (clearBtn) {
            clearBtn.addEventListener('click', clearForm);
        }

        // Refresh button
        var refreshBtn = document.getElementById('refreshBtn');
        if (refreshBtn) {
            refreshBtn.addEventListener('click', function() {
                loadPrefixList();
            });
        }

        // Search filter enter key
        var searchFilter = document.getElementById('searchFilter');
        if (searchFilter) {
            searchFilter.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    applyFilter();
                }
            });
        }

        // Delete confirmation
        var confirmDeleteBtn = document.getElementById('confirmDeleteBtn');
        if (confirmDeleteBtn) {
            confirmDeleteBtn.addEventListener('click', function() {
                if (deleteId) {
                    executeDelete(deleteId);
                }
            });
        }
    }

    // Load prefix list
    function loadPrefixList() {
        showLoading();

        if (dwrLoaded) {
            try {
                // Get filtered data
                prefixService.list(currentPage - 1, pageSize, currentFilter, {
                    callback: function(data) {
                        console.log("Received data:", data);
                        renderPrefixTable(data);

                        // Get total count for pagination
                        prefixService.listAll({
                            callback: function(allData) {
                                // Apply client-side filtering for count
                                var filteredData = filterData(allData);
                                totalRecords = filteredData.length;
                                totalPages = Math.ceil(totalRecords / pageSize);
                                updatePagination();
                                updateRecordCount();
                            },
                            errorHandler: function(message, exception) {
                                console.error("Error getting total count:", message);
                                showMessage("Error loading data count: " + message, 'error');
                            }
                        });
                    },
                    errorHandler: function(message, exception) {
                        console.error("Error loading prefix list:", message, exception);
                        showMessage("Error loading prefix list: " + message, 'error');
                        loadMockData();
                    }
                });
            } catch (e) {
                console.error("DWR call failed:", e);
                loadMockData();
            }
        } else {
            console.warn("Using mock data");
            loadMockData();
        }
    }

    // Mock data for testing
    function loadMockData() {
        var mockData = [
            {id: 1, searchPrefix: "Mr.", gender: "Male", prefixOf: "S/O,H/O,F/O"},
            {id: 2, searchPrefix: "Mrs.", gender: "Female", prefixOf: "D/O,W/O,M/O"},
            {id: 3, searchPrefix: "Ms.", gender: "Female", prefixOf: "D/O"},
            {id: 4, searchPrefix: "Dr.", gender: "", prefixOf: "S/O,H/O,F/O,D/O,W/O,M/O"},
            {id: 5, searchPrefix: "Master", gender: "Male", prefixOf: "S/O"},
            {id: 6, searchPrefix: "Miss", gender: "Female", prefixOf: "D/O"},
            {id: 7, searchPrefix: "Prof.", gender: "", prefixOf: "S/O,H/O,F/O,D/O,W/O,M/O"},
            {id: 8, searchPrefix: "Baby boy of", gender: "Male", prefixOf: "S/O"},
            {id: 9, searchPrefix: "Baby girl of", gender: "Female", prefixOf: "D/O"},
            {id: 10, searchPrefix: "Mx.", gender: "Other", prefixOf: ""}
        ];

        // Apply filtering
        var filteredData = filterData(mockData);

        // Apply pagination
        var startIndex = (currentPage - 1) * pageSize;
        var paginatedData = filteredData.slice(startIndex, startIndex + pageSize);

        totalRecords = filteredData.length;
        totalPages = Math.ceil(totalRecords / pageSize);

        renderPrefixTable(paginatedData);
        updatePagination();
        updateRecordCount();
    }

    // Filter data based on current filters
    function filterData(data) {
        return data.filter(function(item) {
            var matchesSearch = !currentFilter ||
                (item.searchPrefix && item.searchPrefix.toLowerCase().indexOf(currentFilter.toLowerCase()) !== -1);
            var matchesGender = !currentGenderFilter || item.gender === currentGenderFilter;
            return matchesSearch && matchesGender;
        });
    }

    // Render prefix table
    function renderPrefixTable(data) {
        var tbody = document.getElementById('prefixList');
        tbody.innerHTML = '';

        if (!data || data.length === 0) {
            tbody.innerHTML = '<tr><td colspan="5" class="text-center text-muted">No records found</td></tr>';
            return;
        }

        var startIndex = (currentPage - 1) * pageSize;

        for (var i = 0; i < data.length; i++) {
            var item = data[i];
            var tr = document.createElement('tr');

            tr.innerHTML =
                '<td>' + (startIndex + i + 1) + '</td>' +
                '<td><strong>' + (item.searchPrefix || '') + '</strong></td>' +
                '<td>' + (item.gender ? '<span class="badge badge-info">' + item.gender + '</span>' : '<span class="text-muted">Not specified</span>') + '</td>' +
                '<td>' + (item.prefixOf || '<span class="text-muted">Not specified</span>') + '</td>' +
                '<td>' +
                '<button class="btn btn-danger btn-sm btn-action" onclick="confirmDelete(' + item.id + ', \'' +
                (item.searchPrefix || '').replace(/'/g, "\\'") + '\')" title="Delete">' +
                '<i class="fas fa-trash"></i> Delete' +
                '</button>' +
                '</td>';

            tbody.appendChild(tr);
        }
    }

    // Add new prefix
    function addPrefix() {
        var searchPrefix = document.getElementById('searchPrefix').value.trim();
        var gender = document.getElementById('gender').value;
        var prefixOf = document.getElementById('prefixOf').value.trim();

        // Validation
        if (!searchPrefix) {
            showMessage('Please enter a search prefix', 'error');
            document.getElementById('searchPrefix').focus();
            return;
        }

        // Disable submit button
        var addBtn = document.getElementById('addBtn');
        addBtn.disabled = true;
        addBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Adding...';

        var prefix = {
            searchPrefix: searchPrefix,
            gender: gender,
            prefixOf: prefixOf
        };

        if (dwrLoaded) {
            try {
                prefixService.create(prefix, {
                    callback: function(result) {
                        console.log("Prefix added successfully:", result);
                        showMessage('Prefix "' + searchPrefix + '" added successfully!', 'success');
                        clearForm();
                        loadPrefixList();

                        // Re-enable button
                        addBtn.disabled = false;
                        addBtn.innerHTML = '<i class="fas fa-save"></i> Add Prefix';
                    },
                    errorHandler: function(message, exception) {
                        console.error("Error adding prefix:", message, exception);
                        showMessage('Error adding prefix: ' + message, 'error');

                        // Re-enable button
                        addBtn.disabled = false;
                        addBtn.innerHTML = '<i class="fas fa-save"></i> Add Prefix';
                    }
                });
            } catch (e) {
                console.error("DWR call failed:", e);
                showMessage('Error: Unable to connect to server', 'error');

                // Re-enable button
                addBtn.disabled = false;
                addBtn.innerHTML = '<i class="fas fa-save"></i> Add Prefix';
            }
        } else {
            // Mock success for demo
            setTimeout(function() {
                showMessage('Prefix "' + searchPrefix + '" added successfully! (Mock)', 'success');
                clearForm();
                loadPrefixList();

                // Re-enable button
                addBtn.disabled = false;
                addBtn.innerHTML = '<i class="fas fa-save"></i> Add Prefix';
            }, 1000);
        }
    }

    // Confirm delete
    function confirmDelete(id, prefixName) {
        deleteId = id;
        document.getElementById('deleteDetails').innerHTML =
            '<strong>Prefix:</strong> ' + prefixName + '<br><strong>ID:</strong> ' + id;

        // Show modal using jQuery if available, otherwise native
        if (typeof $ !== 'undefined') {
            $('#deleteConfirmModal').modal('show');
        } else {
            // Fallback confirmation
            if (confirm('Are you sure you want to delete the prefix "' + prefixName + '"?')) {
                executeDelete(id);
            }
        }
    }

    // Execute delete
    function executeDelete(id) {
        var confirmBtn = document.getElementById('confirmDeleteBtn');
        confirmBtn.disabled = true;
        confirmBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Deleting...';

        if (dwrLoaded) {
            try {
                prefixService.delete(id, {
                    callback: function(result) {
                        console.log("Prefix deleted successfully:", result);
                        showMessage('Prefix deleted successfully!', 'success');
                        loadPrefixList();

                        // Hide modal and reset button
                        if (typeof $ !== 'undefined') {
                            $('#deleteConfirmModal').modal('hide');
                        }
                        confirmBtn.disabled = false;
                        confirmBtn.innerHTML = '<i class="fas fa-trash"></i> Delete';
                        deleteId = null;
                    },
                    errorHandler: function(message, exception) {
                        console.error("Error deleting prefix:", message, exception);
                        showMessage('Error deleting prefix: ' + message, 'error');

                        // Reset button
                        confirmBtn.disabled = false;
                        confirmBtn.innerHTML = '<i class="fas fa-trash"></i> Delete';
                    }
                });
            } catch (e) {
                console.error("DWR call failed:", e);
                showMessage('Error: Unable to connect to server', 'error');

                // Reset button
                confirmBtn.disabled = false;
                confirmBtn.innerHTML = '<i class="fas fa-trash"></i> Delete';
            }
        } else {
            // Mock success for demo
            setTimeout(function() {
                showMessage('Prefix deleted successfully! (Mock)', 'success');
                loadPrefixList();

                // Hide modal and reset button
                if (typeof $ !== 'undefined') {
                    $('#deleteConfirmModal').modal('hide');
                }
                confirmBtn.disabled = false;
                confirmBtn.innerHTML = '<i class="fas fa-trash"></i> Delete';
                deleteId = null;
            }, 1000);
        }
    }

    // Apply filter
    function applyFilter() {
        currentFilter = document.getElementById('searchFilter').value.trim();
        currentGenderFilter = document.getElementById('genderFilter').value;
        currentPage = 1; // Reset to first page
        loadPrefixList();
    }

    // Clear filter
    function clearFilter() {
        document.getElementById('searchFilter').value = '';
        document.getElementById('genderFilter').value = '';
        currentFilter = '';
        currentGenderFilter = '';
        currentPage = 1;
        loadPrefixList();
    }

    // Change page size
    function changePageSize() {
        pageSize = parseInt(document.getElementById('pageSizeSelect').value);
        currentPage = 1; // Reset to first page
        loadPrefixList();
    }

    // Clear form
    function clearForm() {
        document.getElementById('prefixEntryForm').reset();
        clearMessages();
    }

    // Show loading state
    function showLoading() {
        var tbody = document.getElementById('prefixList');
        tbody.innerHTML = '<tr><td colspan="5" class="text-center">' +
            '<div class="spinner-border spinner-border-sm" role="status">' +
            '<span class="sr-only">Loading...</span></div> Loading data...</td></tr>';
    }

    // Show message
    function showMessage(message, type) {
        var messagesDiv = document.getElementById('statusMessages');
        var messageDiv = document.createElement('div');
        messageDiv.className = 'status-message status-' + (type === 'error' ? 'error' : 'success');
        messageDiv.innerHTML = '<i class="fas fa-' + (type === 'error' ? 'exclamation-triangle' : 'check-circle') + '"></i> ' + message;

        // Clear existing messages
        messagesDiv.innerHTML = '';
        messagesDiv.appendChild(messageDiv);

        // Auto-hide after 5 seconds
        setTimeout(function() {
            if (messageDiv.parentNode) {
                messageDiv.parentNode.removeChild(messageDiv);
            }
        }, 5000);
    }

    // Clear messages
    function clearMessages() {
        document.getElementById('statusMessages').innerHTML = '';
    }

    // Update pagination
    function updatePagination() {
        var paginationControls = document.getElementById('paginationControls');
        paginationControls.innerHTML = '';

        if (totalPages <= 1) {
            return;
        }

        // Previous button
        var prevLi = document.createElement('li');
        prevLi.className = 'page-item' + (currentPage === 1 ? ' disabled' : '');
        var prevLink = document.createElement('a');
        prevLink.className = 'page-link';
        prevLink.href = '#';
        prevLink.innerHTML = 'Previous';
        if (currentPage > 1) {
            prevLink.onclick = function() {
                currentPage = currentPage - 1;
                loadPrefixList();
                return false;
            };
        }
        prevLi.appendChild(prevLink);
        paginationControls.appendChild(prevLi);

        // Page numbers
        var startPage = Math.max(1, currentPage - 2);
        var endPage = Math.min(totalPages, currentPage + 2);

        for (var i = startPage; i <= endPage; i++) {
            var li = document.createElement('li');
            li.className = 'page-item' + (i === currentPage ? ' active' : '');
            var link = document.createElement('a');
            link.className = 'page-link';
            link.href = '#';
            link.innerHTML = i;
            (function(pageNum) {
                link.onclick = function() {
                    currentPage = pageNum;
                    loadPrefixList();
                    return false;
                };
            })(i);
            li.appendChild(link);
            paginationControls.appendChild(li);
        }

        // Next button
        var nextLi = document.createElement('li');
        nextLi.className = 'page-item' + (currentPage === totalPages ? ' disabled' : '');
        var nextLink = document.createElement('a');
        nextLink.className = 'page-link';
        nextLink.href = '#';
        nextLink.innerHTML = 'Next';
        if (currentPage < totalPages) {
            nextLink.onclick = function() {
                currentPage = currentPage + 1;
                loadPrefixList();
                return false;
            };
        }
        nextLi.appendChild(nextLink);
        paginationControls.appendChild(nextLi);

        // Update page info
        document.getElementById('pageInfo').textContent = 'Page ' + currentPage + ' of ' + totalPages;
    }

    // Update record count
    function updateRecordCount() {
        document.getElementById('recordCount').textContent = 'Total: ' + totalRecords + ' records';
    }

    // Initialize when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initTab4);
    } else {
        // DOM already loaded, initialize with delay to ensure DWR is loaded
        setTimeout(initTab4, 500);
    }
</script>