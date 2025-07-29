<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h3 class="mb-4">Tab 4: Entry Screen with Delete &amp; List (DWR + Hibernate)</h3>

<!-- ===== Entry Form Card ===== -->
<div class="card mb-5">
    <div class="card-header bg-success text-white d-flex justify-content-between align-items-center">
        <h5 class="mb-0"><i class="fas fa-plus-circle"></i> Add New Prefix</h5>
    </div>
    <div class="card-body">
        <form id="prefixEntryForm" class="form">
            <div class="form-row">
                <div class="form-group col-md-4">
                    <label for="searchPrefix"><span class="text-danger">*</span> Search Prefix</label>
                    <input
                            type="text"
                            id="searchPrefix"
                            name="searchPrefix"
                            class="form-control form-control-sm"
                            placeholder="e.g., Mr., Mrs., Dr."
                            maxlength="50"
                            required>
                    <small class="form-text text-muted">Enter the prefix (e.g., Mr., Mrs., Dr.)</small>
                </div>
                <div class="form-group col-md-4">
                    <label for="gender">Gender</label>
                    <select id="gender" name="gender" class="form-control form-control-sm">
                        <option value="">Any</option>
                        <option>Male</option>
                        <option>Female</option>
                        <option>Other</option>
                    </select>
                    <small class="form-text text-muted">Optional</small>
                </div>
                <div class="form-group col-md-4">
                    <label for="prefixOf">Prefix Of</label>
                    <input
                            type="text"
                            id="prefixOf"
                            name="prefixOf"
                            class="form-control form-control-sm"
                            placeholder="e.g., S/O,H/O,F/O"
                            maxlength="100">
                    <small class="form-text text-muted">Comma‑separated relations</small>
                </div>
            </div>

            <div class="form-group">
                <button type="submit" id="addBtn" class="btn btn-success btn-sm mr-2">
                    <i class="fas fa-save"></i> Add Prefix
                </button>
                <button type="button" id="clearBtn" class="btn btn-secondary btn-sm">
                    <i class="fas fa-eraser"></i> Clear
                </button>
            </div>

            <div id="statusMessages"></div>
        </form>
    </div>
</div>

<!-- ===== List & Filters Card ===== -->
<div class="card">
    <div class="card-header bg-info text-white d-flex justify-content-between align-items-center">
        <h5 class="mb-0"><i class="fas fa-list"></i> Prefix List</h5>
        <button id="clearFilterBtn" class="btn btn-sm btn-light" onclick="clearFilter()">
            <i class="fas fa-times"></i> Clear Filters
        </button>
    </div>

    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-sm table-striped mb-0" id="prefixTable">
                <thead>
                <!-- filter row -->
                <tr class="bg-light">
                    <th class="px-2" style="width:25%">
                        <div class="input-group input-group-sm">
                            <input
                                    type="text"
                                    id="searchFilter"
                                    class="form-control form-control-sm"
                                    placeholder="Search Prefix"
                                    onkeypress="if(event.key==='Enter')applyFilter()">
                            <div class="input-group-append">
                                <button class="btn btn-outline-secondary btn-sm" onclick="applyFilter()">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                        </div>
                    </th>
                    <th style="width:20%">
                        <select
                                id="genderFilter"
                                class="form-control form-control-sm"
                                onchange="applyFilter()">
                            <option value="">All Genders</option>
                            <option>Male</option>
                            <option>Female</option>
                            <option>Other</option>
                        </select>
                    </th>
                    <th style="width:35%">
                        <div class="input-group input-group-sm">
                            <input
                                    type="text"
                                    id="prefixOfFilter"
                                    class="form-control form-control-sm"
                                    placeholder="Prefix Of"
                                    onkeypress="if(event.key==='Enter')applyFilter()">
                            <div class="input-group-append">
                                <button class="btn btn-outline-secondary btn-sm" onclick="applyFilter()">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                        </div>
                    </th>
                    <th style="width:20%" class="text-center">Actions</th>
                </tr>
                <!-- header row -->
                <tr class="thead-dark">
                    <th>Search Prefix</th>
                    <th>Gender</th>
                    <th>Prefix Of</th>
                    <th class="text-center">Actions</th>
                </tr>
                </thead>

                <tbody id="prefixList">
                <tr>
                    <td colspan="4" class="text-center py-4">
                        <div class="spinner-border spinner-border-sm mr-2" role="status"></div>
                        Loading…
                    </td>
                </tr>
                </tbody>
            </table>
        </div>

        <!-- Pagination Footer -->
        <div class="d-flex justify-content-between align-items-center p-2 border-top bg-white">
            <!-- Total records -->
            <div>
                <span id="recordCount" class="badge badge-info">Total: 0 records</span>
            </div>

            <!-- Page size selector -->
            <div class="form-inline">
                <label class="mr-2 mb-0" for="pageSizeSelect">Page Size:</label>
                <select id="pageSizeSelect" class="form-control form-control-sm" onchange="changePageSize()">
                    <option value="5">5</option>
                    <option value="10" selected>10</option>
                    <option value="20">20</option>
                    <option value="50">50</option>
                </select>
            </div>

            <!-- Page info -->
            <div id="pageInfo" class="text-muted">Page 1 of 1</div>

            <!-- Pagination controls -->
            <nav>
                <ul class="pagination pagination-sm mb-0" id="paginationControls">
                    <!-- Injected by JS -->
                </ul>
            </nav>
        </div>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteConfirmModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title">Confirm Delete</h5>
                <button type="button" class="close text-white" data-dismiss="modal">
                    &times;
                </button>
            </div>
            <div class="modal-body">
                <p>Are you sure you want to delete this prefix?</p>
                <div id="deleteDetails" class="alert alert-info p-2"></div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary btn-sm" data-dismiss="modal">Cancel</button>
                <button id="confirmDeleteBtn" class="btn btn-danger btn-sm">
                    <i class="fas fa-trash"></i> Delete
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Debug Info Panel -->
<div class="card mt-3">
    <div class="card-header">
        <h6 class="mb-0">Debug Information</h6>
    </div>
    <div class="card-body">
        <div id="debugInfo" class="small text-muted">
            Initializing...
        </div>
    </div>
</div>

<script type="text/javascript">
    var currentPage     = 1,
        pageSize        = 10,
        totalRecords    = 0,
        totalPages      = 1,
        currentSearch   = '',
        currentGender   = '',
        currentPrefixOf = '',
        dwrLoaded       = false,
        isAdding        = false,
        isDeleting      = false,
        isLoading       = false,
        deleteId        = null;

    function updateDebugInfo(message) {
        var debugDiv = document.getElementById('debugInfo');
        var timestamp = new Date().toLocaleTimeString();
        debugDiv.innerHTML = '[' + timestamp + '] ' + message + '<br>' + debugDiv.innerHTML;
        console.log('[Tab4 Debug]', message);
    }

    function initTab4() {
        updateDebugInfo('Initializing Tab 4...');

        // Check DWR availability with detailed logging
        updateDebugInfo('Checking DWR availability...');
        if (typeof dwr === 'undefined') {
            updateDebugInfo('ERROR: DWR not loaded');
            showMessage('DWR not loaded. Please check server configuration.', 'error');
            return;
        }

        if (typeof prefixService === 'undefined') {
            updateDebugInfo('ERROR: prefixService not available');
            showMessage('PrefixService not available. Please check DWR configuration.', 'error');
            return;
        }

        updateDebugInfo('DWR and prefixService available');

        // Test DWR connection
        try {
            dwr.engine.setAsync(true);
            dwr.engine.setErrorHandler(function(msg, ex) {
                updateDebugInfo('DWR Error: ' + msg);
                console.error('DWR Error:', msg, ex);
                showMessage('Connection error: ' + msg, 'error');
            });

            dwr.engine.setWarningHandler(function(msg, ex) {
                updateDebugInfo('DWR Warning: ' + msg);
                console.warn('DWR Warning:', msg, ex);
            });

            dwrLoaded = true;
            updateDebugInfo('DWR initialized successfully');

        } catch (e) {
            updateDebugInfo('Error initializing DWR: ' + e.message);
            showMessage('Error initializing DWR: ' + e.message, 'error');
            return;
        }

        // Wire event listeners
        updateDebugInfo('Setting up event listeners...');
        ['searchFilter', 'genderFilter', 'prefixOfFilter'].forEach(function(id) {
            var el = document.getElementById(id);
            if (!el) {
                updateDebugInfo('WARNING: Element ' + id + ' not found');
                return;
            }

            el.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    updateDebugInfo('Filter triggered by Enter key on ' + id);
                    applyFilter();
                }
            });

            if (el.tagName === 'SELECT') {
                el.addEventListener('change', function() {
                    updateDebugInfo('Filter triggered by change on ' + id);
                    applyFilter();
                });
            }
        });

        document.getElementById('pageSizeSelect').addEventListener('change', function() {
            pageSize = +this.value;
            updateDebugInfo('Page size changed to: ' + pageSize);
            loadPrefixList(1);
        });

        // Form event listeners
        document.getElementById('prefixEntryForm').addEventListener('submit', function(e) {
            e.preventDefault();
            updateDebugInfo('Form submitted');
            addPrefix();
        });

        document.getElementById('clearBtn').addEventListener('click', function() {
            updateDebugInfo('Clear form clicked');
            clearForm();
        });

        document.getElementById('confirmDeleteBtn').addEventListener('click', function() {
            updateDebugInfo('Delete confirmed for ID: ' + deleteId);
            executeDelete(deleteId);
        });

        updateDebugInfo('Event listeners set up successfully');

        // Test prefixService connection first
        updateDebugInfo('Testing prefixService connection...');
        testPrefixService();
    }

    function testPrefixService() {
        updateDebugInfo('Calling prefixService.count for connection test...');

        try {
            prefixService.count("", "", "", {
                callback: function(count) {
                    updateDebugInfo('Connection test successful. Total prefixes: ' + count);
                    loadPrefixList(1);
                },
                errorHandler: function(msg, ex) {
                    updateDebugInfo('Connection test failed: ' + msg);
                    console.error('Connection test error:', msg, ex);
                    showMessage('Service connection failed: ' + msg, 'error');
                },
                timeout: 10000 // 10 second timeout
            });
        } catch (e) {
            updateDebugInfo('Exception calling prefixService: ' + e.message);
            showMessage('Exception calling service: ' + e.message, 'error');
        }
    }

    function loadPrefixList(page) {
        if (isLoading) {
            updateDebugInfo('Load already in progress, skipping...');
            return;
        }

        if (!dwrLoaded) {
            updateDebugInfo('DWR not loaded, cannot load prefixes');
            showMessage('DWR service not available', 'error');
            return;
        }

        currentPage     = page || 1;
        currentSearch   = document.getElementById('searchFilter').value.trim();
        currentGender   = document.getElementById('genderFilter').value;
        currentPrefixOf = document.getElementById('prefixOfFilter').value.trim();
        isLoading       = true;

        updateDebugInfo('Loading prefixes - Page: ' + currentPage + ', Filters: search="' + currentSearch + '", gender="' + currentGender + '", prefixOf="' + currentPrefixOf + '"');

        showLoading();

        // First get the count
        try {
            prefixService.count(currentSearch, currentGender, currentPrefixOf, {
                callback: function(count) {
                    updateDebugInfo('Got prefix count: ' + count);
                    totalRecords = count;
                    totalPages   = Math.max(1, Math.ceil(count / pageSize));
                    updateRecordCount();
                    updatePagination();

                    // Then get the data for current page
                    updateDebugInfo('Getting prefixes for page ' + currentPage + '...');

                    prefixService.getPrefixes(currentSearch, currentGender, currentPrefixOf, currentPage, pageSize, {
                        callback: function(list) {
                            updateDebugInfo('Got ' + (list ? list.length : 0) + ' prefixes');
                            isLoading = false;
                            renderTable(list || []);
                        },
                        errorHandler: function(msg, ex) {
                            updateDebugInfo('Error loading prefixes: ' + msg);
                            isLoading = false;
                            console.error('Error loading prefixes:', msg, ex);
                            showMessage('Error loading data: ' + msg, 'error');
                            renderTable([]);
                        },
                        timeout: 15000
                    });
                },
                errorHandler: function(msg, ex) {
                    updateDebugInfo('Error loading prefix count: ' + msg);
                    isLoading = false;
                    console.error('Error loading prefix count:', msg, ex);
                    showMessage('Error loading count: ' + msg, 'error');
                    renderTable([]);
                },
                timeout: 15000
            });
        } catch (e) {
            updateDebugInfo('Exception in loadPrefixList: ' + e.message);
            isLoading = false;
            showMessage('Exception: ' + e.message, 'error');
        }
    }

    function renderTable(data) {
        var tbody = document.getElementById('prefixList');
        tbody.innerHTML = '';

        updateDebugInfo('Rendering table with ' + (data ? data.length : 0) + ' prefixes');

        if (!data || data.length === 0) {
            tbody.innerHTML = '<tr><td colspan="4" class="text-center text-muted py-4">No records found</td></tr>';
            return;
        }

        data.forEach(function(item, index) {
            // Safely handle null/undefined values
            var searchPrefix = item.searchPrefix || '';
            var gender = item.gender || '<span class="text-muted">—</span>';
            var prefixOf = item.prefixOf || '<span class="text-muted">—</span>';

            // Escape quotes for onclick attribute
            var searchPrefixEscaped = searchPrefix.replace(/'/g, "\\'").replace(/"/g, "&quot;");

            var row = '<tr>' +
                '<td><strong>' + searchPrefix + '</strong></td>' +
                '<td>' + gender + '</td>' +
                '<td>' + prefixOf + '</td>' +
                '<td class="text-center">' +
                '<button class="btn btn-danger btn-sm" ' +
                'onclick="confirmDelete(' + item.id + ', \'' + searchPrefixEscaped + '\')" ' +
                'title="Delete this prefix">' +
                '<i class="fas fa-trash"></i>' +
                '</button>' +
                '</td>' +
                '</tr>';

            tbody.insertAdjacentHTML('beforeend', row);
        });

        updateDebugInfo('Table rendered successfully');
    }

    function updateRecordCount() {
        document.getElementById('recordCount').textContent = 'Total: ' + totalRecords + ' records';
        document.getElementById('pageInfo').textContent = 'Page ' + currentPage + ' of ' + totalPages;
    }

    function updatePagination() {
        var ul = document.getElementById('paginationControls');
        ul.innerHTML = '';

        if (totalPages <= 1) return;

        function createPageItem(label, page, disabled, active) {
            var className = 'page-item';
            if (disabled) className += ' disabled';
            if (active) className += ' active';

            var onclick = disabled ? '' : ' onclick="loadPrefixList(' + page + '); return false;"';

            return '<li class="' + className + '">' +
                '<a class="page-link" href="#"' + onclick + '>' + label + '</a>' +
                '</li>';
        }

        // Previous button
        ul.insertAdjacentHTML('beforeend', createPageItem('«', currentPage - 1, currentPage === 1, false));

        // Page numbers
        var start = Math.max(1, currentPage - 2);
        var end = Math.min(totalPages, start + 4);

        if (start > 1) {
            ul.insertAdjacentHTML('beforeend', createPageItem('1', 1, false, false));
            if (start > 2) {
                ul.insertAdjacentHTML('beforeend', createPageItem('…', 1, true, false));
            }
        }

        for (var i = start; i <= end; i++) {
            ul.insertAdjacentHTML('beforeend', createPageItem(i, i, false, i === currentPage));
        }

        if (end < totalPages) {
            if (end < totalPages - 1) {
                ul.insertAdjacentHTML('beforeend', createPageItem('…', 1, true, false));
            }
            ul.insertAdjacentHTML('beforeend', createPageItem(totalPages, totalPages, false, false));
        }

        // Next button
        ul.insertAdjacentHTML('beforeend', createPageItem('»', currentPage + 1, currentPage === totalPages, false));
    }

    function showLoading() {
        document.getElementById('prefixList').innerHTML =
            '<tr><td colspan="4" class="text-center py-4">' +
            '<div class="spinner-border spinner-border-sm mr-2" role="status"></div>' +
            'Loading data...' +
            '</td></tr>';
    }

    function addPrefix() {
        if (isAdding || !dwrLoaded) {
            updateDebugInfo('Cannot add - already adding or DWR not loaded');
            return;
        }

        var searchPrefixValue = document.getElementById('searchPrefix').value.trim();
        if (!searchPrefixValue) {
            updateDebugInfo('Validation failed - search prefix is empty');
            showMessage('Search Prefix is required', 'error');
            return;
        }

        isAdding = true;
        var addBtn = document.getElementById('addBtn');
        var originalText = addBtn.innerHTML;
        addBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Adding...';
        addBtn.disabled = true;

        var prefixData = {
            searchPrefix: searchPrefixValue,
            gender: document.getElementById('gender').value || null,
            prefixOf: document.getElementById('prefixOf').value.trim() || null
        };

        updateDebugInfo('Adding prefix: ' + JSON.stringify(prefixData));

        try {
            prefixService.create(prefixData, {
                callback: function(result) {
                    updateDebugInfo('Prefix added successfully: ' + JSON.stringify(result));
                    isAdding = false;
                    addBtn.innerHTML = originalText;
                    addBtn.disabled = false;

                    showMessage('Successfully added: ' + searchPrefixValue, 'success');
                    clearForm();
                    loadPrefixList(1); // Reload to show new record
                },
                errorHandler: function(msg, ex) {
                    updateDebugInfo('Error adding prefix: ' + msg);
                    isAdding = false;
                    addBtn.innerHTML = originalText;
                    addBtn.disabled = false;

                    console.error('Error adding prefix:', msg, ex);
                    showMessage('Failed to add prefix: ' + msg, 'error');
                },
                timeout: 15000
            });
        } catch (e) {
            updateDebugInfo('Exception adding prefix: ' + e.message);
            isAdding = false;
            addBtn.innerHTML = originalText;
            addBtn.disabled = false;
            showMessage('Exception: ' + e.message, 'error');
        }
    }

    function confirmDelete(id, prefixName) {
        deleteId = id;
        var displayName = prefixName || 'Unknown';
        updateDebugInfo('Delete confirmation for ID: ' + id + ', Name: ' + displayName);
        document.getElementById('deleteDetails').innerHTML =
            '<strong>Prefix:</strong> ' + displayName + '<br>' +
            '<strong>ID:</strong> ' + id;
        $('#deleteConfirmModal').modal('show');
    }

    function executeDelete(id) {
        if (isDeleting || !dwrLoaded) {
            updateDebugInfo('Cannot delete - already deleting or DWR not loaded');
            return;
        }

        isDeleting = true;
        var confirmBtn = document.getElementById('confirmDeleteBtn');
        var originalText = confirmBtn.innerHTML;
        confirmBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Deleting...';
        confirmBtn.disabled = true;

        updateDebugInfo('Deleting prefix ID: ' + id);

        try {
            prefixService.deletePrefix(id, {
                callback: function() {
                    updateDebugInfo('Prefix deleted successfully');
                    isDeleting = false;
                    confirmBtn.innerHTML = originalText;
                    confirmBtn.disabled = false;

                    $('#deleteConfirmModal').modal('hide');
                    showMessage('Successfully deleted prefix', 'success');
                    loadPrefixList(currentPage);
                },
                errorHandler: function(msg, ex) {
                    updateDebugInfo('Error deleting prefix: ' + msg);
                    isDeleting = false;
                    confirmBtn.innerHTML = originalText;
                    confirmBtn.disabled = false;

                    console.error('Error deleting prefix:', msg, ex);
                    showMessage('Failed to delete prefix: ' + msg, 'error');
                },
                timeout: 15000
            });
        } catch (e) {
            updateDebugInfo('Exception deleting prefix: ' + e.message);
            isDeleting = false;
            confirmBtn.innerHTML = originalText;
            confirmBtn.disabled = false;
            showMessage('Exception: ' + e.message, 'error');
        }
    }

    function applyFilter() {
        currentPage = 1;
        updateDebugInfo('Applying filters...');
        loadPrefixList(1);
    }

    function clearFilter() {
        updateDebugInfo('Clearing filters...');
        document.getElementById('searchFilter').value = '';
        document.getElementById('genderFilter').value = '';
        document.getElementById('prefixOfFilter').value = '';
        applyFilter();
    }

    function changePageSize() {
        pageSize = +document.getElementById('pageSizeSelect').value;
        currentPage = 1;
        updateDebugInfo('Page size changed to: ' + pageSize);
        loadPrefixList(1);
    }

    function clearForm() {
        document.getElementById('prefixEntryForm').reset();
        document.getElementById('statusMessages').innerHTML = '';
        updateDebugInfo('Form cleared');
    }

    function showMessage(msg, type) {
        var alertType = type === 'error' ? 'danger' : (type === 'success' ? 'success' : 'info');
        var icon = type === 'error' ? 'fas fa-exclamation-triangle' :
            (type === 'success' ? 'fas fa-check-circle' : 'fas fa-info-circle');

        var div = document.createElement('div');
        div.className = 'alert alert-' + alertType + ' alert-sm alert-dismissible fade show';
        div.innerHTML = '<i class="' + icon + ' mr-2"></i>' + msg +
            '<button type="button" class="close" data-dismiss="alert">' +
            '<span>&times;</span></button>';

        var container = document.getElementById('statusMessages');
        container.innerHTML = '';
        container.appendChild(div);

        updateDebugInfo('Message shown: ' + msg + ' (type: ' + type + ')');

        // Auto-hide after 5 seconds
        setTimeout(function() {
            if (div.parentNode) {
                $(div).alert('close');
            }
        }, 5000);
    }

    // Initialize when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() {
            updateDebugInfo('DOM loaded, initializing...');
            initTab4();
        });
    } else {
        updateDebugInfo('DOM already loaded, initializing...');
        initTab4();
    }

    // Also initialize when tab becomes active
    $(document).on('shown.bs.tab', 'a[href="#tab4"]', function() {
        updateDebugInfo('Tab 4 became active');
        if (!dwrLoaded) {
            updateDebugInfo('DWR not loaded on tab activation, re-initializing...');
            initTab4();
        } else {
            updateDebugInfo('Refreshing data on tab activation...');
            loadPrefixList(currentPage);
        }
    });
</script>