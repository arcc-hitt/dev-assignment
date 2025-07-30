<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<h3 id="tab3-title" class="mb-3">Tab 3: List Page with Paging and Search Feature</h3>

<!-- Card for table and filters -->
<div class="card shadow-sm">
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-striped table-hover mb-0" id="userListTable">
                <thead>
                <!-- FILTER ROW -->
                <tr class="bg-light">
                    <th>
                        <div class="input-group input-group-sm">
                            <input
                                    type="text"
                                    id="nameSearchInput"
                                    class="form-control form-control-sm"
                                    placeholder="Search Name"
                                    aria-label="Search Name"
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
                                    id="codeSearchInput"
                                    class="form-control form-control-sm"
                                    placeholder="Search Code"
                                    aria-label="Search Code"
                                    onkeypress="if(event.key==='Enter')loadUserList(1)"
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
                                id="userTypeSelect"
                                class="form-control form-control-sm"
                                aria-label="User Type Filter"
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
                                id="departmentSearchInput"
                                class="form-control form-control-sm"
                                placeholder="Department"
                                aria-label="Department Filter"
                                onkeypress="if(event.key==='Enter')loadUserList(1)"
                        />
                    </th>
                    <th>
                        <select
                                id="statusSelect"
                                class="form-control form-control-sm"
                                aria-label="Status Filter"
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
                <tbody id="userListTableBody">
                <tr>
                    <td colspan="7" class="text-center py-4">
                        <div class="spinner-border spinner-border-sm mr-2" role="status"></div>
                        Loading data...
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>
<!-- Status/Error message container -->
<div id="tab3StatusMessage" class="mt-2" aria-live="polite"></div>

<!-- FOOTER: Record count / PageSize / Pagination -->
<div
        class="d-flex align-items-center justify-content-between p-3 border-top bg-white"
>
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

<script type="text/javascript">
// State variables for pagination and filtering
let currentPage = 1;
let pageSize = 10;
let totalPages = 1;

// Initialize Tab 3: wire up filters, page size, and DWR
function initTab3() {
    // Attach event listeners to all filter inputs and page size selector
    [
        'nameSearchInput',
        'codeSearchInput',
        'userTypeSelect',
        'departmentSearchInput',
        'statusSelect'
    ].forEach(function (id) {
        const el = document.getElementById(id);
        if (!el) return;
        el.addEventListener('keypress', function (e) {
            if (e.key === 'Enter') loadUserList(1);
        });
        el.addEventListener('change', function () {
            loadUserList(1);
        });
    });
    document.getElementById('pageSizeSelect')
        .addEventListener('change', function () {
            pageSize = +this.value;
            loadUserList(1);
        });

    // Initialize DWR error handler for robust error reporting
    if (typeof dwr !== 'undefined' && typeof itemService !== 'undefined') {
        dwr.engine.setAsync(true);
        dwr.engine.setErrorHandler(function (msg, ex) {
            showStatusError('A server error occurred: ' + msg);
            console.error('DWR Error:', msg, ex);
        });
    }

    // Initial data load
    loadUserList(1);
}

// Load user list with current filters and pagination
function loadUserList(page) {
    currentPage = page || 1;
    const name = document.getElementById('nameSearchInput').value.trim();
    const code = document.getElementById('codeSearchInput').value.trim();
    const type = document.getElementById('userTypeSelect').value;
    const dept = document.getElementById('departmentSearchInput').value.trim();
    const status = document.getElementById('statusSelect').value;

    showLoading();
    clearStatusError();

    // Get total count first, then fetch paginated data
    itemService.getItemCount(
        name, code, type, dept, status,
        {
            callback: function (count) {
                totalPages = Math.ceil(count / pageSize) || 1;
                document.getElementById('recordCount').textContent = 'Total: ' + count + ' records';
                document.getElementById('pageInfo').textContent = 'Page ' + currentPage + ' of ' + totalPages;

                itemService.getItems(
                    name, code, type, dept, status,
                    currentPage, pageSize,
                    {
                        callback: function (items) {
                            renderTable(items);
                            renderPagination();
                        },
                        errorHandler: function (msg, e) {
                            showStatusError('Failed to load items: ' + msg);
                            showError(msg);
                        }
                    }
                );
            },
            errorHandler: function (msg, e) {
                showStatusError('Failed to get record count: ' + msg);
                showError(msg);
            }
        }
    );
}

// Render the user table with the given items
function renderTable(items) {
    const tbody = document.getElementById('userListTableBody');
    tbody.innerHTML = '';
    if (!items || items.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" class="text-center text-muted">No records found</td></tr>';
        return;
    }
    items.forEach(function (it) {
        const joiningDate = it.createdOn ? new Date(it.createdOn).toLocaleDateString() : '—';
        tbody.insertAdjacentHTML('beforeend',
            '<tr>' +
            '<td>' + (it.name || '—') + '</td>' +
            '<td><strong>' + (it.code || '—') + '</strong></td>' +
            '<td>' + (it.category || '—') + '</td>' +
            '<td>' + (it.phone || '—') + '</td>' +
            '<td>' + (it.department || '—') + '</td>' +
            '<td>' + (it.status || '—') + '</td>' +
            '<td>' + joiningDate + '</td>' +
            '</tr>'
        );
    });
}

// Render pagination controls
function renderPagination() {
    const ul = document.getElementById('paginationControls');
    ul.innerHTML = '';
    if (totalPages <= 1) return;
    function mkLi(label, page, disabled, active) {
        return '<li class="page-item' +
            (disabled ? ' disabled' : '') +
            (active ? ' active' : '') +
            '"><a class="page-link" href="#"' +
            (!disabled ? (' onclick="loadUserList(' + page + ');return false;"') : '') +
            '>' + label + '</a></li>';
    }
    ul.insertAdjacentHTML('beforeend', mkLi('«', currentPage - 1, currentPage === 1, false));
    const start = Math.max(1, currentPage - 2);
    const end = Math.min(totalPages, currentPage + 2);
    if (start > 1) ul.insertAdjacentHTML('beforeend', mkLi('1', 1, false, false));
    if (start > 2) ul.insertAdjacentHTML('beforeend', mkLi('…', 1, true, false));
    for (let i = start; i <= end; i++) {
        ul.insertAdjacentHTML('beforeend', mkLi(i, i, false, i === currentPage));
    }
    if (end < totalPages - 1) ul.insertAdjacentHTML('beforeend', mkLi('…', 1, true, false));
    if (end < totalPages) ul.insertAdjacentHTML('beforeend', mkLi(totalPages, totalPages, false, false));
    ul.insertAdjacentHTML('beforeend', mkLi('»', currentPage + 1, currentPage === totalPages, false));
}

// Show loading spinner in the table
function showLoading() {
    document.getElementById('userListTableBody').innerHTML =
        '<tr><td colspan="7" class="text-center py-4">' +
        '<div class="spinner-border spinner-border-sm mr-2" role="status"></div>Loading...' +
        '</td></tr>';
}
// Show error message in the table
function showError(msg) {
    document.getElementById('userListTableBody').innerHTML =
        '<tr><td colspan="7" class="text-center text-danger">' + msg + '</td></tr>';
}
// Show error message in the status container
function showStatusError(msg) {
    const statusDiv = document.getElementById('tab3StatusMessage');
    if (statusDiv) {
        statusDiv.innerHTML = '<span class="text-danger">' + msg + '</span>';
    }
}
// Clear the status error message
function clearStatusError() {
    const statusDiv = document.getElementById('tab3StatusMessage');
    if (statusDiv) {
        statusDiv.innerHTML = '';
    }
}

// Initialize the tab when DOM is ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initTab3);
} else {
    initTab3();
}
</script>