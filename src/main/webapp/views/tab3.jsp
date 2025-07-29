<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<h3 class="mb-3">Tab 3: List Page with Paging and Search Feature</h3>

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

        <!-- FOOTER: Record count / Refresh / PageSize / Pagination -->
        <div
                class="d-flex align-items-center justify-content-between p-3 border-top bg-white"
        >
            <div>
                <span id="recordCount" class="badge badge-info">Total: 0 records</span>
                <button
                        onclick="loadItems(currentPage)"
                        class="btn btn-outline-secondary btn-sm ml-2"
                >
                    Refresh
                </button>
            </div>

            <div class="form-inline">
                <label class="mr-2 mb-0" for="pageSizeSelect">Page Size:</label>
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

            <div class="text-muted" id="pageInfo">Page 1 of 1</div>

            <nav>
                <ul class="pagination pagination-sm mb-0" id="paginationControls">
                    <!-- injected by JS -->
                </ul>
            </nav>
        </div>
    </div>
</div>

<script type="text/javascript">
    // Global variables
    var currentPage = 1;
    var pageSize = 10;
    var totalCount = 0;
    var totalPages = 0;

    // Check if DWR is loaded
    var dwrLoaded = false;

    // Initialize when page loads
    function initTab3() {
        // Check if DWR and ItemService are available
        if (typeof dwr !== 'undefined' && typeof itemService !== 'undefined') {
            dwrLoaded = true;
            dwr.engine.setAsync(true);
            dwr.engine.setErrorHandler(function(msg, ex) {
                console.error("DWR error:", msg, ex);
                showError("Error connecting to server: " + msg);
            });
        }

        // Load initial data
        loadItems(1);

        // Setup event listeners
        setupEventListeners();
    }

    // Setup event listeners
    function setupEventListeners() {
        // Enter key support for search
        var searchInput = document.getElementById('searchInput');
        if (searchInput) {
            searchInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    loadItems(1);
                }
            });

            searchInput.addEventListener('keydown', function(e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    loadItems(1);
                }
            });
        }
    }

    // Load items function
    function loadItems(page) {
        currentPage = page || 1;
        var search = document.getElementById('searchInput').value.trim();
        var category = document.getElementById('categorySelect').value;

        // Show loading state
        showLoading();

        if (dwrLoaded) {
            // Use DWR service
            try {
                itemService.getItemCount(search, category, {
                    callback: function(count) {
                        totalCount = count;
                        totalPages = Math.ceil(totalCount / pageSize);
                        updateRecordCount();
                        updatePageInfo();

                        // Get the actual data
                        itemService.getItems(search, category, currentPage, pageSize, {
                            callback: function(items) {
                                renderTable(items);
                                renderPagination();
                            },
                            errorHandler: function(message, exception) {
                                console.error("Error loading items:", message, exception);
                                showError("Error loading items: " + message);
                            }
                        });
                    },
                    errorHandler: function(message, exception) {
                        console.error("Error getting item count:", message, exception);
                        showError("Error getting item count: " + message);
                    }
                });
            } catch (e) {
                console.error("DWR call failed:", e);
                loadMockData(search, category, currentPage);
            }
        } else {
            // Use mock data
            console.warn("DWR/ItemService not available, using mock data");
            loadMockData(search, category, currentPage);
        }
    }

    // Mock data for demonstration
    function loadMockData(search, category, page) {
        var mockItems = [
            {id: 1, code: "ITM001", name: "Medical Equipment - Stethoscope", category: "A", createdOn: new Date()},
            {id: 2, code: "ITM002", name: "Pharmaceutical - Paracetamol 500mg", category: "B", createdOn: new Date()},
            {id: 3, code: "ITM003", name: "Surgical Instrument - Forceps", category: "A", createdOn: new Date()},
            {id: 4, code: "ITM004", name: "Laboratory - Blood Test Kit", category: "C", createdOn: new Date()},
            {id: 5, code: "ITM005", name: "Pharmaceutical - Aspirin 100mg", category: "B", createdOn: new Date()},
            {id: 6, code: "ITM006", name: "Medical Equipment - Thermometer", category: "A", createdOn: new Date()},
            {id: 7, code: "ITM007", name: "Disposable - Surgical Gloves", category: "D", createdOn: new Date()},
            {id: 8, code: "ITM008", name: "Laboratory - Urine Test Strip", category: "C", createdOn: new Date()},
            {id: 9, code: "ITM009", name: "Medical Equipment - Blood Pressure Monitor", category: "A", createdOn: new Date()},
            {id: 10, code: "ITM010", name: "Pharmaceutical - Amoxicillin 250mg", category: "B", createdOn: new Date()},
            {id: 11, code: "ITM011", name: "Surgical Instrument - Scalpel", category: "A", createdOn: new Date()},
            {id: 12, code: "ITM012", name: "Laboratory - Glucose Test Kit", category: "C", createdOn: new Date()},
            {id: 13, code: "ITM013", name: "Disposable - Face Mask", category: "D", createdOn: new Date()},
            {id: 14, code: "ITM014", name: "Pharmaceutical - Ibuprofen 400mg", category: "B", createdOn: new Date()},
            {id: 15, code: "ITM015", name: "Medical Equipment - Pulse Oximeter", category: "A", createdOn: new Date()}
        ];

        // Filter mock data
        var filteredItems = mockItems.filter(function(item) {
            var matchesSearch = !search ||
                item.code.toLowerCase().indexOf(search.toLowerCase()) !== -1 ||
                item.name.toLowerCase().indexOf(search.toLowerCase()) !== -1;
            var matchesCategory = !category || item.category === category;
            return matchesSearch && matchesCategory;
        });

        totalCount = filteredItems.length;
        totalPages = Math.ceil(totalCount / pageSize);

        // Paginate
        var startIndex = (page - 1) * pageSize;
        var paginatedItems = filteredItems.slice(startIndex, startIndex + pageSize);

        updateRecordCount();
        updatePageInfo();
        renderTable(paginatedItems);
        renderPagination();
    }

    // Render table data
    function renderTable(items) {
        var tbody = document.getElementById('itemTableBody');
        tbody.innerHTML = '';

        if (!items || items.length === 0) {
            tbody.innerHTML = '<tr><td colspan="5" class="text-center text-muted">No records found</td></tr>';
            return;
        }

        for (var i = 0; i < items.length; i++) {
            var item = items[i];
            var tr = document.createElement('tr');
            var createdDate = item.createdOn ? new Date(item.createdOn).toLocaleDateString() : 'N/A';

            tr.innerHTML = '<td>' + (item.id || 'N/A') + '</td>' +
                '<td><strong>' + (item.code || 'N/A') + '</strong></td>' +
                '<td>' + (item.name || 'N/A') + '</td>' +
                '<td><span class="badge badge-secondary">' + (item.category || 'N/A') + '</span></td>' +
                '<td>' + createdDate + '</td>';
            tbody.appendChild(tr);
        }
    }

    // Render pagination controls
    function renderPagination() {
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
            prevLink.onclick = function() { loadItems(currentPage - 1); return false; };
        }
        prevLi.appendChild(prevLink);
        paginationControls.appendChild(prevLi);

        // Page numbers
        var startPage = Math.max(1, currentPage - 2);
        var endPage = Math.min(totalPages, currentPage + 2);

        if (startPage > 1) {
            var firstLi = document.createElement('li');
            firstLi.className = 'page-item';
            var firstLink = document.createElement('a');
            firstLink.className = 'page-link';
            firstLink.href = '#';
            firstLink.innerHTML = '1';
            firstLink.onclick = function() { loadItems(1); return false; };
            firstLi.appendChild(firstLink);
            paginationControls.appendChild(firstLi);

            if (startPage > 2) {
                var ellipsisLi = document.createElement('li');
                ellipsisLi.className = 'page-item disabled';
                var ellipsisSpan = document.createElement('span');
                ellipsisSpan.className = 'page-link';
                ellipsisSpan.innerHTML = '...';
                ellipsisLi.appendChild(ellipsisSpan);
                paginationControls.appendChild(ellipsisLi);
            }
        }

        for (var i = startPage; i <= endPage; i++) {
            var li = document.createElement('li');
            li.className = 'page-item' + (i === currentPage ? ' active' : '');
            var link = document.createElement('a');
            link.className = 'page-link';
            link.href = '#';
            link.innerHTML = i;
            (function(pageNum) {
                link.onclick = function() { loadItems(pageNum); return false; };
            })(i);
            li.appendChild(link);
            paginationControls.appendChild(li);
        }

        if (endPage < totalPages) {
            if (endPage < totalPages - 1) {
                var ellipsisLi = document.createElement('li');
                ellipsisLi.className = 'page-item disabled';
                var ellipsisSpan = document.createElement('span');
                ellipsisSpan.className = 'page-link';
                ellipsisSpan.innerHTML = '...';
                ellipsisLi.appendChild(ellipsisSpan);
                paginationControls.appendChild(ellipsisLi);
            }

            var lastLi = document.createElement('li');
            lastLi.className = 'page-item';
            var lastLink = document.createElement('a');
            lastLink.className = 'page-link';
            lastLink.href = '#';
            lastLink.innerHTML = totalPages;
            lastLink.onclick = function() { loadItems(totalPages); return false; };
            lastLi.appendChild(lastLink);
            paginationControls.appendChild(lastLi);
        }

        // Next button
        var nextLi = document.createElement('li');
        nextLi.className = 'page-item' + (currentPage === totalPages ? ' disabled' : '');
        var nextLink = document.createElement('a');
        nextLink.className = 'page-link';
        nextLink.href = '#';
        nextLink.innerHTML = 'Next';
        if (currentPage < totalPages) {
            nextLink.onclick = function() { loadItems(currentPage + 1); return false; };
        }
        nextLi.appendChild(nextLink);
        paginationControls.appendChild(nextLi);
    }

    // Update record count display
    function updateRecordCount() {
        var recordCountEl = document.getElementById('recordCount');
        if (recordCountEl) {
            recordCountEl.textContent = 'Total: ' + totalCount + ' records';
        }
    }

    // Update page info display
    function updatePageInfo() {
        var pageInfoEl = document.getElementById('pageInfo');
        if (pageInfoEl) {
            pageInfoEl.textContent = 'Page ' + currentPage + ' of ' + totalPages;
        }
    }

    // Change page size
    function changePageSize() {
        var pageSizeSelect = document.getElementById('pageSizeSelect');
        if (pageSizeSelect) {
            pageSize = parseInt(pageSizeSelect.value);
            loadItems(1); // Reset to first page
        }
    }

    // Clear filters
    function clearFilters() {
        document.getElementById('searchInput').value = '';
        document.getElementById('categorySelect').value = '';
        loadItems(1);
    }

    // Show loading state
    function showLoading() {
        var tbody = document.getElementById('itemTableBody');
        if (tbody) {
            tbody.innerHTML = '<tr><td colspan="5" class="text-center">' +
                '<div class="spinner-border spinner-border-sm" role="status">' +
                '<span class="sr-only">Loading...</span></div> Loading data...</td></tr>';
        }
    }

    // Show error message
    function showError(message) {
        var tbody = document.getElementById('itemTableBody');
        if (tbody) {
            tbody.innerHTML = '<tr><td colspan="5" class="text-center text-danger">' +
                '<i class="fas fa-exclamation-triangle"></i> ' + message + '</td></tr>';
        }
    }

    // Initialize when DOM is loaded
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initTab3);
    } else {
        // DOM already loaded
        setTimeout(initTab3, 100);
    }
</script>