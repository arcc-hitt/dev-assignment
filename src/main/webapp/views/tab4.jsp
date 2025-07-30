<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h3 id="tab4-title" class="mb-4">Tab 4: Entry Screen with Delete & List (DWR + Hibernate)</h3>

<!-- ===== Entry Form Card ===== -->
<div class="card mb-5">
    <div class="card-header bg-success text-white d-flex justify-content-between align-items-center">
        <h5 class="mb-0"><i class="fas fa-plus-circle"></i> Add New Prefix</h5>
    </div>
    <div class="card-body">
        <form id="prefixEntryFormTab4" class="form">
            <div class="form-row">
                <div class="form-group col-md-4">
                    <label for="searchPrefixTab4"><span class="text-danger">*</span> Search Prefix</label>
                    <input
                            type="text"
                            id="searchPrefixTab4"
                            name="searchPrefixTab4"
                            class="form-control form-control-sm"
                            placeholder="e.g., Mr., Mrs., Dr."
                            maxlength="50"
                            required>
                    <small class="form-text text-muted">Enter the prefix (e.g., Mr., Mrs., Dr.)</small>
                </div>
                <div class="form-group col-md-4">
                    <label for="genderTab4">Gender</label>
                    <select id="genderTab4" name="genderTab4" class="form-control form-control-sm">
                        <option value="">Any</option>
                        <option>Male</option>
                        <option>Female</option>
                        <option>Other</option>
                    </select>
                    <small class="form-text text-muted">Optional</small>
                </div>
                <div class="form-group col-md-4">
                    <label for="prefixOfTab4">Prefix Of</label>
                    <input
                            type="text"
                            id="prefixOfTab4"
                            name="prefixOfTab4"
                            class="form-control form-control-sm"
                            placeholder="e.g., S/O,H/O,F/O"
                            maxlength="100">
                    <small class="form-text text-muted">Comma-separated relations</small>
                </div>
            </div>
            <div class="form-group">
                <button type="submit" id="addBtnTab4" class="btn btn-success btn-sm mr-2">
                    <i class="fas fa-save"></i> Add Prefix
                </button>
                <button type="button" id="clearBtnTab4" class="btn btn-secondary btn-sm">
                    <i class="fas fa-eraser"></i> Clear
                </button>
            </div>
            <!-- Status/Error message container -->
            <div id="tab4StatusMessage" class="mt-2" aria-live="polite"></div>
        </form>
    </div>
</div>

<!-- ===== List & Filters Card ===== -->
<div class="card">
    <div class="card-header bg-info text-white d-flex justify-content-between align-items-center">
        <h5 class="mb-0"><i class="fas fa-list"></i> Prefix List</h5>
    </div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-striped table-hover mb-0" id="prefixTableTab4">
                <thead>
                <!-- filter row -->
                <tr class="bg-light">
                    <th class="px-2" style="width:20%">
                        <div class="input-group input-group-sm">
                            <input
                                    type="text"
                                    id="searchFilterTab4"
                                    class="form-control form-control-sm"
                                    placeholder="Search Prefix"
                                    onkeypress="if(event.key==='Enter')applyFilterTab4()">
                            <div class="input-group-append">
                                <button class="btn btn-outline-secondary btn-sm" onclick="applyFilterTab4()">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                        </div>
                    </th>
                    <th style="width:20%">
                        <select
                                id="genderFilterTab4"
                                class="form-control form-control-sm"
                                onchange="applyFilterTab4()">
                            <option value="">All Genders</option>
                            <option>Male</option>
                            <option>Female</option>
                            <option>Other</option>
                        </select>
                    </th>
                    <th style="width:40%">
                        <input
                                type="text"
                                id="prefixOfFilterTab4"
                                class="form-control form-control-sm"
                                placeholder="Prefix Of"
                                onkeypress="if(event.key==='Enter')applyFilterTab4()">
                    </th>
                    <th style="width:20%; text-align:right">Actions</th>
                </tr>
                <tr class="thead-dark">
                    <th>Search Prefix</th>
                    <th>Gender</th>
                    <th>Prefix Of</th>
                    <th style="text-align:right">Actions</th>
                </tr>
                </thead>
                <tbody id="prefixTableBodyTab4">
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
            <span id="recordCountTab4" class="badge badge-info">Total: 0 records</span>
        </div>
        <div class="form-inline">
            <label class="mr-2 mb-0" for="pageSizeSelectTab4">Page Size:</label>
            <select id="pageSizeSelectTab4" class="form-control form-control-sm" onchange="changePageSize()">
                <option value="5">5</option>
                <option value="10" selected>10</option>
                <option value="20">20</option>
                <option value="50">50</option>
            </select>
        </div>
    
    <!-- Page info -->
    <div id="pageInfoTab4" class="text-muted">Page 1 of 1</div>
        
    <!-- Pagination controls -->
    <nav>
        <ul class="pagination pagination-sm mb-0" id="paginationControlsTab4">
            <!-- Injected by JS -->
        </ul>
    </nav>
</div>

<!-- Delete Confirmation Modal (unchanged) -->
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
                <p>Are you sure?</p>
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

<script type="text/javascript">
// State variables for pagination, filtering, and DWR
let currentPageTab4 = 1;
let pageSizeTab4 = 10;
let totalRecordsTab4 = 0;
let totalPagesTab4 = 1;
let currentSearchTab4 = '';
let currentGenderTab4 = '';
let currentPrefixOfTab4 = '';
let dwrLoadedTab4 = false;
let isAddingTab4 = false;
let isDeletingTab4 = false;
let deleteIdTab4 = null;

// Initialize Tab 4: wire up filters, page size, DWR, and form events
function initTab4() {
    // Check if DWR is available
    if (window.dwr && window.prefixService) {
        dwr.engine.setAsync(true);
        dwr.engine.setErrorHandler(function (msg, ex) {
            showMessageTab4('Server error: ' + msg, 'error');
            console.error('DWR Error:', msg, ex);
        });
        dwrLoadedTab4 = true;
    } else {
        showMessageTab4('DWR service not available. Please refresh the page.', 'error');
        return;
    }
    // Attach event listeners to filter inputs and page size selector
    ['searchFilterTab4', 'genderFilterTab4', 'prefixOfFilterTab4'].forEach(function (id) {
        const el = document.getElementById(id);
        if (el) {
            el.addEventListener('keypress', function (e) {
                if (e.key === 'Enter') applyFilterTab4();
            });
            el.addEventListener('change', applyFilterTab4);
        }
    });
    const pageSizeSelect = document.getElementById('pageSizeSelectTab4');
    if (pageSizeSelect) {
        pageSizeSelect.addEventListener('change', function () {
            pageSizeTab4 = parseInt(this.value);
            currentPageTab4 = 1;
            loadPrefixListTab4(1);
        });
    }
    // Form submit and clear
    const form = document.getElementById('prefixEntryFormTab4');
    if (form) {
        form.addEventListener('submit', function (e) {
            e.preventDefault();
            addPrefixTab4();
        });
    }
    const clearBtn = document.getElementById('clearBtnTab4');
    if (clearBtn) {
        clearBtn.addEventListener('click', clearFormTab4);
    }
    // Delete confirmation
    const confirmDeleteBtn = document.getElementById('confirmDeleteBtn');
    if (confirmDeleteBtn) {
        confirmDeleteBtn.addEventListener('click', function () {
            executeDeleteTab4(deleteIdTab4);
        });
    }
    // Initial data load
    loadPrefixListTab4(1);
}

// Load prefix list with current filters and pagination
function loadPrefixListTab4(page) {
    if (!dwrLoadedTab4 || !window.prefixService) {
        showMessageTab4('DWR service not available', 'error');
        return;
    }
    currentPageTab4 = page || 1;
    currentSearchTab4 = document.getElementById('searchFilterTab4') ? document.getElementById('searchFilterTab4').value.trim() : '';
    currentGenderTab4 = document.getElementById('genderFilterTab4') ? document.getElementById('genderFilterTab4').value : '';
    currentPrefixOfTab4 = document.getElementById('prefixOfFilterTab4') ? document.getElementById('prefixOfFilterTab4').value.trim() : '';
    showLoadingTab4();
    // 1) fetch total count
    prefixService.count(
        currentSearchTab4, currentGenderTab4, currentPrefixOfTab4,
        {
            callback: function (count) {
                totalRecordsTab4 = count;
                totalPagesTab4 = Math.max(1, Math.ceil(count / pageSizeTab4));
                updateRecordCountTab4();
                updatePaginationTab4();
                // 2) fetch current page
                prefixService.getPrefixes(
                    currentSearchTab4, currentGenderTab4, currentPrefixOfTab4,
                    currentPageTab4, pageSizeTab4,
                    {
                        callback: function (list) {
                            renderPrefixTableTab4(list);
                        },
                        errorHandler: function (msg, e) {
                            showMessageTab4('Load error: ' + msg, 'error');
                            showLoadingTab4();
                        }
                    }
                );
            },
            errorHandler: function (msg, e) {
                showMessageTab4('Count error: ' + msg, 'error');
                showLoadingTab4();
            }
        }
    );
}

// Render the prefix table
function renderPrefixTableTab4(data) {
    const tbody = document.getElementById('prefixTableBodyTab4');
    if (!tbody) return;
    tbody.innerHTML = '';
    if (!data || data.length === 0) {
        tbody.innerHTML = '<tr><td colspan="4" class="text-center text-muted">No records found</td></tr>';
        return;
    }
    data.forEach(function (item) {
        const sp = item.searchPrefix || '';
        const gender = item.gender || '<span class="text-muted">—</span>';
        const po = item.prefixOf || '<span class="text-muted">—</span>';
        // Escape single quotes for JS injection
        const spEscaped = sp.replace(/'/g, "\\'");
        tbody.insertAdjacentHTML('beforeend',
            '<tr>' +
            '<td><strong>' + sp + '</strong></td>' +
            '<td>' + gender + '</td>' +
            '<td>' + po + '</td>' +
            '<td class="text-right">' +
            '<button class="btn btn-danger btn-sm" ' +
            'onclick="confirmDelete(' + item.id + ',\'' + spEscaped + '\')">' +
            '<i class="fas fa-trash"></i>' +
            '</button>' +
            '</td>' +
            '</tr>'
        );
    });
}

// Update record count and page info
function updateRecordCountTab4() {
    const recordCountEl = document.getElementById('recordCountTab4');
    const pageInfoEl = document.getElementById('pageInfoTab4');
    if (recordCountEl) {
        recordCountEl.textContent = 'Total: ' + totalRecordsTab4 + ' records';
    }
    if (pageInfoEl) {
        pageInfoEl.textContent = 'Page ' + currentPageTab4 + ' of ' + totalPagesTab4;
    }
}

// Update pagination controls
function updatePaginationTab4() {
    const ul = document.getElementById('paginationControlsTab4');
    if (!ul) return;
    ul.innerHTML = '';
    function mkLi(label, page, disabled, active) {
        return '<li class="page-item' + (disabled ? ' disabled' : '') + (active ? ' active' : '') + '">' +
            '<a class="page-link" href="#"' +
            (disabled ? '' : ' onclick="loadPrefixListTab4(' + page + ');return false;"') +
            '>' + label + '</a></li>';
    }
    ul.insertAdjacentHTML('beforeend', mkLi('«', currentPageTab4 - 1, currentPageTab4 === 1, false));
    const start = Math.max(1, currentPageTab4 - 2);
    const end = Math.min(totalPagesTab4, start + 4);
    if (start > 1) {
        ul.insertAdjacentHTML('beforeend', mkLi('1', 1, false, false));
        if (start > 2) ul.insertAdjacentHTML('beforeend', mkLi('…', 1, true, false));
    }
    for (let p = start; p <= end; p++) {
        ul.insertAdjacentHTML('beforeend', mkLi(p, p, false, p === currentPageTab4));
    }
    if (end < totalPagesTab4) {
        if (end < totalPagesTab4 - 1) ul.insertAdjacentHTML('beforeend', mkLi('…', 1, true, false));
        ul.insertAdjacentHTML('beforeend', mkLi(totalPagesTab4, totalPagesTab4, false, false));
    }
    ul.insertAdjacentHTML('beforeend', mkLi('»', currentPageTab4 + 1, currentPageTab4 === totalPagesTab4, false));
}

// Show loading spinner in the table
function showLoadingTab4() {
    const tbody = document.getElementById('prefixTableBodyTab4');
    if (tbody) {
        tbody.innerHTML =
            '<tr><td colspan="4" class="text-center py-4">' +
            '<div class="spinner-border spinner-border-sm mr-2"></div>Loading data...' +
            '</td></tr>';
    }
}

// Add a new prefix
function addPrefixTab4() {
    if (isAddingTab4) return;
    if (!dwrLoadedTab4 || !window.prefixService) {
        showMessageTab4('DWR service not available', 'error');
        return;
    }
    const sp = document.getElementById('searchPrefixTab4') ? document.getElementById('searchPrefixTab4').value.trim() : '';
    if (!sp) {
        showMessageTab4('Prefix is required', 'error');
        return;
    }
    isAddingTab4 = true;
    const prefixData = {
        searchPrefix: sp,
        gender: document.getElementById('genderTab4') ? document.getElementById('genderTab4').value : '',
        prefixOf: document.getElementById('prefixOfTab4') ? document.getElementById('prefixOfTab4').value.trim() : ''
    };
    prefixService.create(
        prefixData,
        {
            callback: function (result) {
                showMessageTab4('Added ' + sp, 'success');
                clearFormTab4();
                loadPrefixListTab4(1);
                isAddingTab4 = false;
            },
            errorHandler: function (msg, e) {
                showMessageTab4('Add failed: ' + msg, 'error');
                isAddingTab4 = false;
            }
        }
    );
}

// Show delete confirmation modal
function confirmDelete(id, prefixName) {
    deleteIdTab4 = id;
    const nameDisplay = prefixName || '';
    const deleteDetailsEl = document.getElementById('deleteDetails');
    if (deleteDetailsEl) {
        deleteDetailsEl.innerHTML = '<strong>' + nameDisplay + '</strong> (ID ' + id + ')';
    }
    $('#deleteConfirmModal').modal('show');
}

// Execute delete
function executeDeleteTab4(id) {
    if (isDeletingTab4) return;
    if (!dwrLoadedTab4 || !window.prefixService) {
        showMessageTab4('DWR service not available', 'error');
        return;
    }
    isDeletingTab4 = true;
    prefixService.deletePrefix(
        id,
        {
            callback: function () {
                $('#deleteConfirmModal').modal('hide');
                showMessageTab4('Deleted', 'success');
                loadPrefixListTab4(currentPageTab4);
                isDeletingTab4 = false;
            },
            errorHandler: function (msg, e) {
                showMessageTab4('Delete failed: ' + msg, 'error');
                isDeletingTab4 = false;
            }
        }
    );
}

// Apply filter and reload list
function applyFilterTab4() {
    currentPageTab4 = 1;
    loadPrefixListTab4(1);
}
// Clear all filters
function clearFilterTab4() {
    ['searchFilterTab4', 'genderFilterTab4', 'prefixOfFilterTab4'].forEach(function (id) {
        const el = document.getElementById(id);
        if (el) el.value = '';
    });
    applyFilterTab4();
}
// Change page size and reload list
function changePageSizeTab4() {
    currentPageTab4 = 1;
    loadPrefixListTab4(1);
}
// Clear the entry form and status message
function clearFormTab4() {
    const form = document.getElementById('prefixEntryFormTab4');
    if (form) form.reset();
    const statusMessages = document.getElementById('tab4StatusMessage');
    if (statusMessages) statusMessages.innerHTML = '';
}
// Show a message in the status container
function showMessageTab4(msg, type) {
    const div = document.createElement('div');
    div.className = 'alert alert-' + (type === 'error' ? 'danger' : 'success') + ' alert-sm';
    div.textContent = msg;
    const container = document.getElementById('tab4StatusMessage');
    if (container) {
        container.innerHTML = '';
        container.appendChild(div);
        setTimeout(function () { container.innerHTML = ''; }, 4000);
    }
}
// Initialize when DOM is ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initTab4);
} else {
    initTab4();
}
</script>

