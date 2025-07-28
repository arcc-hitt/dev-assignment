<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<h3>Tab 3: List Page with Paging and Search Feature</h3>

<!-- Search and Filter Controls -->
<div class="card mb-4">
    <div class="card-header">
        <h5>Search &amp; Filter</h5>
    </div>
    <div class="card-body">
        <div class="row">
            <div class="col-md-4">
                <div class="form-group">
                    <label for="searchInput">Search (Code/Name):</label>
                    <input type="text" id="searchInput" class="form-control" placeholder="Enter code or name...">
                </div>
            </div>
            <div class="col-md-4">
                <div class="form-group">
                    <label for="categorySelect">Category:</label>
                    <select id="categorySelect" class="form-control">
                        <option value="">-- All Categories --</option>
                        <option value="A">Category A</option>
                        <option value="B">Category B</option>
                        <option value="C">Category C</option>
                        <option value="D">Category D</option>
                    </select>
                </div>
            </div>
            <div class="col-md-4">
                <div class="form-group">
                    <label>&nbsp;</label>
                    <div>
                        <button onclick="loadItems(1)" class="btn btn-primary">Search</button>
                        <button onclick="clearFilters()" class="btn btn-secondary ml-2">Clear</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Results Table -->
<div class="card">
    <div class="card-header d-flex justify-content-between align-items-center">
        <h5>Item List</h5>
        <div>
            <span id="recordCount" class="badge badge-info">Total: 0 records</span>
            <button onclick="loadItems(currentPage)" class="btn btn-secondary btn-sm ml-2">Refresh</button>
        </div>
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-striped table-hover" id="itemTable">
                <thead class="thead-dark">
                <tr>
                    <th width="10%">ID</th>
                    <th width="20%">Code</th>
                    <th width="30%">Name</th>
                    <th width="20%">Category</th>
                    <th width="20%">Created On</th>
                </tr>
                </thead>
                <tbody id="itemTableBody">
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

        <!-- Pagination Controls -->
        <div class="d-flex justify-content-between align-items-center mt-3">
            <div>
                <select id="pageSizeSelect" class="form-control" style="width: auto; display: inline-block;" onchange="changePageSize()">
                    <option value="5">5 per page</option>
                    <option value="10" selected>10 per page</option>
                    <option value="20">20 per page</option>
                    <option value="50">50 per page</option>
                </select>
            </div>
            <div>
                <span id="pageInfo" class="text-muted">Page 1 of 1</span>
            </div>
            <div class="pagination-container">
                <nav aria-label="Page navigation">
                    <ul class="pagination pagination-sm mb-0" id="paginationControls">
                        <!-- Pagination buttons will be inserted here -->
                    </ul>
                </nav>
            </div>
        </div>
    </div>
</div>

<style>
    /* Custom styling for the table */
    #itemTable {
        box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }

    #itemTable thead th {
        border-top: none;
        font-weight: 600;
    }

    #itemTable tbody tr:hover {
        background-color: #f8f9fa;
    }

    .pagination-container {
        margin-left: auto;
    }

    .badge {
        font-size: 0.875em;
    }

    .spinner-border-sm {
        width: 1rem;
        height: 1rem;
    }

    /* Responsive adjustments */
    @media (max-width: 768px) {
        .table-responsive {
            font-size: 0.875rem;
        }

        .pagination-sm .page-link {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
        }
    }
</style>

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