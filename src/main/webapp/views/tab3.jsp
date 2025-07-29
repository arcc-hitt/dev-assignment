<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<h3 class="mb-3">Tab 3: List Page with Paging and Search Feature</h3>

<div class="card shadow-sm">
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-striped table-hover mb-0" id="itemTable">
                <thead>
                <!-- FILTER ROW -->
                <tr class="bg-light">
                    <th>
                        <div class="input-group input-group-sm">
                            <input
                                    type="text"
                                    id="searchInput"
                                    class="form-control form-control-sm"
                                    placeholder="Search Name"
                                    onkeypress="if(event.key==='Enter')loadItems(1)"
                            />
                            <div class="input-group-append">
                  <span class="input-group-text">
                    <i class="fa fa-search"></i>
                  </span>
                            </div>
                        </div>
                    </th>
                    <th>
                        <div class="input-group input-group-sm">
                            <input
                                    type="text"
                                    id="searchCode"
                                    class="form-control form-control-sm"
                                    placeholder="Search Code"
                                    onkeypress="if(event.key==='Enter')loadItems(1)"
                            />
                            <div class="input-group-append">
                  <span class="input-group-text">
                    <i class="fa fa-search"></i>
                  </span>
                            </div>
                        </div>
                    </th>
                    <th>
                        <select
                                id="categorySelect"
                                class="form-control form-control-sm"
                                onchange="loadItems(1)"
                        >
                            <option value="">All Types</option>
                            <option>Staff</option>
                            <option>Doctor</option>
                            <option>Consultant</option>
                        </select>
                    </th>
                    <th>Phone</th>
                    <th>
                        <input
                                type="text"
                                id="departmentFilter"
                                class="form-control form-control-sm"
                                placeholder="Department"
                                onkeypress="if(event.key==='Enter')loadItems(1)"
                        />
                    </th>
                    <th>
                        <select
                                id="statusFilter"
                                class="form-control form-control-sm"
                                onchange="loadItems(1)"
                        >
                            <option value="">All Status</option>
                            <option>Confirmed</option>
                            <option>Regular</option>
                            <option>Probationary</option>
                            <option>Contract</option>
                            <option>Trainee</option>
                        </select>
                    </th>
                    <th>Joining Date</th>
                </tr>
                <!-- COLUMN LABELS -->
                <tr class="thead-dark">
                    <th width="20%">Name</th>
                    <th width="15%">Code</th>
                    <th width="15%">User Type</th>
                    <th width="15%">Phone</th>
                    <th width="15%">Department</th>
                    <th width="10%">Status</th>
                    <th width="10%">Joining Date</th>
                </tr>
                </thead>
                <tbody id="itemTableBody">
                <tr>
                    <td colspan="7" class="text-center py-4">
                        <div class="spinner-border spinner-border-sm mr-2" role="status"></div>
                        Loading data...
                    </td>
                </tr>
                </tbody>
            </table>
        </div>

        <!-- FOOTER: Record count / PageSize / Pagination -->
        <div class="d-flex align-items-center justify-content-between p-3 border-top bg-white">
            <div>
                <span id="recordCount" class="badge badge-info">Total: 0 records</span>
            </div>

            <div class="form-inline">
                <label class="mr-2 mb-0" for="pageSizeSelect">Page Size:</label>
                <select
                        id="pageSizeSelect"
                        class="form-control form-control-sm"
                        onchange="changePageSize()"
                >
                    <option value="5">5</option>
                    <option value="10" selected>10</option>
                    <option value="20">20</option>
                    <option value="50">50</option>
                </select>
            </div>

            <div class="text-muted" id="pageInfo">Page 1 of 1</div>

            <nav>
                <ul class="pagination pagination-sm mb-0" id="paginationControls">
                    <!-- injected by JS -->
                </ul>
            </nav>
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
    var currentPage = 1,
        pageSize    = 10,
        totalPages  = 1,
        dwrLoaded   = false,
        isLoading   = false;

    function updateDebugInfo(message) {
        var debugDiv = document.getElementById('debugInfo');
        var timestamp = new Date().toLocaleTimeString();
        debugDiv.innerHTML = '[' + timestamp + '] ' + message + '<br>' + debugDiv.innerHTML;
        console.log('[Tab3 Debug]', message);
    }

    function initTab3() {
        updateDebugInfo('Initializing Tab 3...');

        // Check DWR availability with more detailed logging
        updateDebugInfo('Checking DWR availability...');
        if (typeof dwr === 'undefined') {
            updateDebugInfo('ERROR: DWR not loaded');
            showError('DWR not loaded. Please check server configuration.');
            return;
        }

        if (typeof itemService === 'undefined') {
            updateDebugInfo('ERROR: itemService not available');
            showError('ItemService not available. Please check DWR configuration.');
            return;
        }

        updateDebugInfo('DWR and itemService available');

        // Test DWR connection
        try {
            dwr.engine.setAsync(true);
            dwr.engine.setErrorHandler(function(msg, ex) {
                updateDebugInfo('DWR Error: ' + msg);
                console.error('DWR Error:', msg, ex);
                showError('Connection error: ' + msg);
            });

            dwr.engine.setWarningHandler(function(msg, ex) {
                updateDebugInfo('DWR Warning: ' + msg);
                console.warn('DWR Warning:', msg, ex);
            });

            dwrLoaded = true;
            updateDebugInfo('DWR initialized successfully');

        } catch (e) {
            updateDebugInfo('Error initializing DWR: ' + e.message);
            showError('Error initializing DWR: ' + e.message);
            return;
        }

        // Wire event listeners
        updateDebugInfo('Setting up event listeners...');
        ['searchInput','searchCode','categorySelect','departmentFilter','statusFilter'].forEach(function(id) {
            var el = document.getElementById(id);
            if (!el) {
                updateDebugInfo('WARNING: Element ' + id + ' not found');
                return;
            }

            el.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    updateDebugInfo('Filter triggered by Enter key on ' + id);
                    loadItems(1);
                }
            });

            if (el.tagName === 'SELECT') {
                el.addEventListener('change', function() {
                    updateDebugInfo('Filter triggered by change on ' + id);
                    loadItems(1);
                });
            }
        });

        document.getElementById('pageSizeSelect').addEventListener('change', function() {
            pageSize = +this.value;
            updateDebugInfo('Page size changed to: ' + pageSize);
            loadItems(1);
        });

        updateDebugInfo('Event listeners set up successfully');

        // Test itemService connection first
        updateDebugInfo('Testing itemService connection...');
        testItemService();
    }

    function testItemService() {
        updateDebugInfo('Calling itemService.getItemCount for connection test...');

        try {
            itemService.getItemCount("", "", "", "", "", {
                callback: function(count) {
                    updateDebugInfo('Connection test successful. Total items: ' + count);
                    loadItems(1);
                },
                errorHandler: function(msg, ex) {
                    updateDebugInfo('Connection test failed: ' + msg);
                    console.error('Connection test error:', msg, ex);
                    showError('Service connection failed: ' + msg);
                },
                timeout: 10000 // 10 second timeout
            });
        } catch (e) {
            updateDebugInfo('Exception calling itemService: ' + e.message);
            showError('Exception calling service: ' + e.message);
        }
    }

    function loadItems(page) {
        if (isLoading) {
            updateDebugInfo('Load already in progress, skipping...');
            return;
        }

        if (!dwrLoaded) {
            updateDebugInfo('DWR not loaded, cannot load items');
            showError('DWR service not available');
            return;
        }

        currentPage = page || 1;
        isLoading = true;

        var name   = document.getElementById('searchInput').value.trim();
        var code   = document.getElementById('searchCode').value.trim();
        var type   = document.getElementById('categorySelect').value;
        var dept   = document.getElementById('departmentFilter').value.trim();
        var status = document.getElementById('statusFilter').value;

        updateDebugInfo('Loading items - Page: ' + currentPage + ', Filters: name="' + name + '", code="' + code + '", type="' + type + '", dept="' + dept + '", status="' + status + '"');

        showLoading();

        // First get the count
        try {
            itemService.getItemCount(name, code, type, dept, status, {
                callback: function(count) {
                    updateDebugInfo('Got item count: ' + count);
                    totalPages = Math.ceil(count / pageSize) || 1;
                    document.getElementById('recordCount').textContent = 'Total: ' + count + ' records';
                    document.getElementById('pageInfo').textContent = 'Page ' + currentPage + ' of ' + totalPages;

                    // Then get the items for current page
                    updateDebugInfo('Getting items for page ' + currentPage + '...');

                    itemService.getItems(name, code, type, dept, status, currentPage, pageSize, {
                        callback: function(items) {
                            updateDebugInfo('Got ' + (items ? items.length : 0) + ' items');
                            isLoading = false;
                            renderTable(items);
                            renderPagination();
                        },
                        errorHandler: function(msg, ex) {
                            updateDebugInfo('Error loading items: ' + msg);
                            isLoading = false;
                            console.error('Error loading items:', msg, ex);
                            showError('Error loading data: ' + msg);
                        },
                        timeout: 15000
                    });
                },
                errorHandler: function(msg, ex) {
                    updateDebugInfo('Error loading item count: ' + msg);
                    isLoading = false;
                    console.error('Error loading item count:', msg, ex);
                    showError('Error loading count: ' + msg);
                },
                timeout: 15000
            });
        } catch (e) {
            updateDebugInfo('Exception in loadItems: ' + e.message);
            isLoading = false;
            showError('Exception: ' + e.message);
        }
    }

    function renderTable(items) {
        var tbody = document.getElementById('itemTableBody');
        tbody.innerHTML = '';

        updateDebugInfo('Rendering table with ' + (items ? items.length : 0) + ' items');

        if (!items || items.length === 0) {
            tbody.innerHTML = '<tr><td colspan="7" class="text-center text-muted py-4">No records found</td></tr>';
            return;
        }

        items.forEach(function(item, index) {
            var dateStr = '—';
            if (item.createdOn) {
                try {
                    var date = typeof item.createdOn === 'string' ? new Date(item.createdOn) : item.createdOn;
                    if (date && !isNaN(date.getTime())) {
                        dateStr = date.toLocaleDateString();
                    }
                } catch (e) {
                    console.warn('Date parsing error for item ' + index + ':', e);
                }
            }

            var row = '<tr>' +
                '<td>' + (item.name || '—') + '</td>' +
                '<td><strong>' + (item.code || '—') + '</strong></td>' +
                '<td>' + (item.category || '—') + '</td>' +
                '<td>' + (item.phone || '—') + '</td>' +
                '<td>' + (item.department || '—') + '</td>' +
                '<td>' + (item.status || '—') + '</td>' +
                '<td>' + dateStr + '</td>' +
                '</tr>';

            tbody.insertAdjacentHTML('beforeend', row);
        });

        updateDebugInfo('Table rendered successfully');
    }

    function renderPagination() {
        var ul = document.getElementById('paginationControls');
        ul.innerHTML = '';

        if (totalPages <= 1) return;

        function createPageItem(label, page, disabled, active) {
            var className = 'page-item';
            if (disabled) className += ' disabled';
            if (active) className += ' active';

            var onclick = disabled ? '' : ' onclick="loadItems(' + page + '); return false;"';

            return '<li class="' + className + '">' +
                '<a class="page-link" href="#"' + onclick + '>' + label + '</a>' +
                '</li>';
        }

        // Previous button
        ul.insertAdjacentHTML('beforeend', createPageItem('«', currentPage - 1, currentPage === 1, false));

        // Page numbers
        var start = Math.max(1, currentPage - 2);
        var end = Math.min(totalPages, currentPage + 2);

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

    function changePageSize() {
        pageSize = +document.getElementById('pageSizeSelect').value;
        updateDebugInfo('Page size changed to: ' + pageSize);
        loadItems(1);
    }

    function showLoading() {
        document.getElementById('itemTableBody').innerHTML =
            '<tr><td colspan="7" class="text-center py-4">' +
            '<div class="spinner-border spinner-border-sm mr-2" role="status"></div>' +
            'Loading data...' +
            '</td></tr>';
    }

    function showError(msg) {
        document.getElementById('itemTableBody').innerHTML =
            '<tr><td colspan="7" class="text-center text-danger py-4">' +
            '<i class="fas fa-exclamation-triangle mr-2"></i>' + msg +
            '</td></tr>';
    }

    // Initialize when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() {
            updateDebugInfo('DOM loaded, initializing...');
            initTab3();
        });
    } else {
        updateDebugInfo('DOM already loaded, initializing...');
        initTab3();
    }

    // Also initialize when tab becomes active
    $(document).on('shown.bs.tab', 'a[href="#tab3"]', function() {
        updateDebugInfo('Tab 3 became active');
        if (!dwrLoaded) {
            updateDebugInfo('DWR not loaded on tab activation, re-initializing...');
            initTab3();
        } else {
            updateDebugInfo('Refreshing data on tab activation...');
            loadItems(currentPage);
        }
    });
</script>