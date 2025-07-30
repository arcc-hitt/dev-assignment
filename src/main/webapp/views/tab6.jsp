<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h3 id="tab6-title" class="mb-4">Tab 6: Entry Screen with Delete & List (REST API)</h3>

<!-- ===== Entry Form Card ===== -->
<div class="card mb-5">
    <div class="card-header bg-success text-white d-flex justify-content-between align-items-center">
        <h5 class="mb-0"><i class="fas fa-plus-circle"></i> Add New Prefix</h5>
    </div>
    <div class="card-body">
        <form id="prefixEntryFormTab6" class="form">
            <div class="form-row">
                <div class="form-group col-md-4">
                    <label for="searchPrefixTab6"><span class="text-danger">*</span> Search Prefix</label>
                    <input
                            type="text"
                            id="searchPrefixTab6"
                            name="searchPrefixTab6"
                            class="form-control form-control-sm"
                            placeholder="e.g., Mr., Mrs., Dr."
                            maxlength="50"
                            required>
                    <small class="form-text text-muted">Enter the prefix (e.g., Mr., Mrs., Dr.)</small>
                </div>
                <div class="form-group col-md-4">
                    <label for="genderTab6">Gender</label>
                    <select id="genderTab6" name="genderTab6" class="form-control form-control-sm">
                        <option value="">Any</option>
                        <option>Male</option>
                        <option>Female</option>
                        <option>Other</option>
                    </select>
                    <small class="form-text text-muted">Optional</small>
                </div>
                <div class="form-group col-md-4">
                    <label for="prefixOfTab6">Prefix Of</label>
                    <input
                            type="text"
                            id="prefixOfTab6"
                            name="prefixOfTab6"
                            class="form-control form-control-sm"
                            placeholder="e.g., S/O,H/O,F/O"
                            maxlength="100">
                    <small class="form-text text-muted">Comma-separated relations</small>
                </div>
            </div>
            <div class="form-group">
                <button type="submit" id="addBtnTab6" class="btn btn-success btn-sm mr-2">
                    <i class="fas fa-save"></i> Add Prefix
                </button>
                <button type="button" id="clearBtnTab6" class="btn btn-secondary btn-sm">
                    <i class="fas fa-eraser"></i> Clear
                </button>
            </div>
            <!-- Status/Error message container -->
            <div id="tab6StatusMessage" class="mt-2" aria-live="polite"></div>
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
            <table class="table table-striped mb-0" id="prefixTableTab6">
                <thead>
                <!-- filter row -->
                <tr class="bg-light">
                    <th class="px-2" style="width:20%">
                        <div class="input-group input-group-sm">
                            <input
                                    type="text"
                                    id="searchFilterTab6"
                                    class="form-control form-control-sm"
                                    placeholder="Search Prefix"
                                    onkeypress="if(event.key==='Enter')applyFilterTab6()">
                            <div class="input-group-append">
                                <button class="btn btn-outline-secondary btn-sm" onclick="applyFilterTab6()">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                        </div>
                    </th>
                    <th style="width:20%">
                        <select
                                id="genderFilterTab6"
                                class="form-control form-control-sm"
                                onchange="applyFilterTab6()">
                            <option value="">All Genders</option>
                            <option>Male</option>
                            <option>Female</option>
                            <option>Other</option>
                        </select>
                    </th>
                    <th style="width:40%">
                        <input
                                type="text"
                                id="prefixOfFilterTab6"
                                class="form-control form-control-sm"
                                placeholder="Prefix Of"
                                onkeypress="if(event.key==='Enter')applyFilterTab6()">
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
                <tbody id="prefixTableBodyTab6">
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
            <span id="recordCountTab6" class="badge badge-info">Total: 0 records</span>
        </div>
        <div class="form-inline">
            <label class="mr-2 mb-0" for="pageSizeSelectTab6">Page Size:</label>
            <select id="pageSizeSelectTab6" class="form-control form-control-sm" onchange="changePageSizeTab6()">
                <option value="5">5</option>
                <option value="10" selected>10</option>
                <option value="20">20</option>
                <option value="50">50</option>
            </select>
        </div>
    
    <!-- Page info -->
        <div id="pageInfoTab6" class="text-muted">Page 1 of 1</div>
        
        <!-- Pagination controls -->
        <nav>
            <ul class="pagination pagination-sm mb-0" id="paginationControlsTab6">
                <!-- Injected by JS -->
            </ul>
        </nav>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteConfirmModalTab6" tabindex="-1">
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
                <div id="deleteDetailsTab6" class="alert alert-info p-2"></div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary btn-sm" data-dismiss="modal">Cancel</button>
                <button id="confirmDeleteBtnTab6" class="btn btn-danger btn-sm">
                    <i class="fas fa-trash"></i> Delete
                </button>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
// State variables for pagination, filtering, and REST API operations
let currentPageRestTab6 = 1;
let pageSizeRestTab6 = 10;
let totalRecordsRestTab6 = 0;
let totalPagesRestTab6 = 1;
let currentSearchRestTab6 = '';
let currentGenderRestTab6 = '';
let currentPrefixOfRestTab6 = '';
let isAddingRestTab6 = false;
let isDeletingRestTab6 = false;
let deleteIdRestTab6 = null;

// Initialize Tab 6: wire up filters, page size, and form events for REST API
function initTab6Rest() {
    // Attach event listeners to filter inputs and page size selector
    ['searchFilterTab6', 'genderFilterTab6', 'prefixOfFilterTab6'].forEach(function (id) {
        const el = document.getElementById(id);
        if (el) {
            el.addEventListener('keypress', function (e) {
                if (e.key === 'Enter') applyFilterTab6();
            });
            el.addEventListener('change', applyFilterTab6);
        }
    });
    const pageSizeSelect = document.getElementById('pageSizeSelectTab6');
    if (pageSizeSelect) {
        pageSizeSelect.addEventListener('change', function () {
            pageSizeRestTab6 = parseInt(this.value);
            currentPageRestTab6 = 1;
            loadRestPrefixListTab6(1);
        });
    }
    // Form submit and clear
    const form = document.getElementById('prefixEntryFormTab6');
    if (form) {
        form.addEventListener('submit', function (e) {
            e.preventDefault();
            addRestPrefixTab6();
        });
    }
    const clearBtn = document.getElementById('clearBtnTab6');
    if (clearBtn) {
        clearBtn.addEventListener('click', clearFormTab6);
    }
    // Delete confirmation
    const confirmDeleteBtn = document.getElementById('confirmDeleteBtnTab6');
    if (confirmDeleteBtn) {
        confirmDeleteBtn.addEventListener('click', function () {
            executeDeleteRestTab6(deleteIdRestTab6);
        });
    }
    // Initial data load
    loadRestPrefixListTab6(1);
}

// Load prefix list with current filters and pagination using REST API
function loadRestPrefixListTab6(page) {
    currentPageRestTab6 = page || 1;
    currentSearchRestTab6 = document.getElementById('searchFilterTab6') ? document.getElementById('searchFilterTab6').value.trim() : '';
    currentGenderRestTab6 = document.getElementById('genderFilterTab6') ? document.getElementById('genderFilterTab6').value : '';
    currentPrefixOfRestTab6 = document.getElementById('prefixOfFilterTab6') ? document.getElementById('prefixOfFilterTab6').value.trim() : '';
    showLoadingTab6();
    // Fetch all data and handle pagination client-side
    $.ajax({
        url: '${pageContext.request.contextPath}/api/prefix/all',
        type: 'GET',
        dataType: 'json',
        success: function (data) {
            if (data && Array.isArray(data)) {
                // Apply filters
                const filteredData = data.filter(function (item) {
                    const matchesSearch = !currentSearchRestTab6 ||
                        (item.searchPrefix && item.searchPrefix.toLowerCase().includes(currentSearchRestTab6.toLowerCase()));
                    const matchesGender = !currentGenderRestTab6 || item.gender === currentGenderRestTab6;
                    const matchesPrefixOf = !currentPrefixOfRestTab6 ||
                        (item.prefixOf && item.prefixOf.toLowerCase().includes(currentPrefixOfRestTab6.toLowerCase()));
                    return matchesSearch && matchesGender && matchesPrefixOf;
                });
                totalRecordsRestTab6 = filteredData.length;
                totalPagesRestTab6 = Math.max(1, Math.ceil(totalRecordsRestTab6 / pageSizeRestTab6));
                // Ensure current page is valid
                if (currentPageRestTab6 > totalPagesRestTab6) {
                    currentPageRestTab6 = totalPagesRestTab6;
                }
                updateRecordCountTab6();
                updatePaginationTab6();
                // Get current page data
                const startIndex = (currentPageRestTab6 - 1) * pageSizeRestTab6;
                const endIndex = startIndex + pageSizeRestTab6;
                const pageData = filteredData.slice(startIndex, endIndex);
                renderRestPrefixTableTab6(pageData);
            } else {
                showMessageTab6('Invalid data format received', 'error');
                showLoadingTab6();
            }
        },
        error: function (xhr, status, error) {
            showMessageTab6('Load error: ' + error, 'error');
            showLoadingTab6();
        }
    });
}

// Render the prefix table
function renderRestPrefixTableTab6(data) {
    const tbody = document.getElementById('prefixTableBodyTab6');
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
            'onclick="confirmDeleteRest(' + item.id + ',\'' + spEscaped + '\')">' +
            '<i class="fas fa-trash"></i>' +
            '</button>' +
            '</td>' +
            '</tr>'
        );
    });
}

// Update record count and page info
function updateRecordCountTab6() {
    const recordCountEl = document.getElementById('recordCountTab6');
    const pageInfoEl = document.getElementById('pageInfoTab6');
    if (recordCountEl) {
        recordCountEl.textContent = 'Total: ' + totalRecordsRestTab6 + ' records';
    }
    if (pageInfoEl) {
        pageInfoEl.textContent = 'Page ' + currentPageRestTab6 + ' of ' + totalPagesRestTab6;
    }
}

// Update pagination controls
function updatePaginationTab6() {
    const ul = document.getElementById('paginationControlsTab6');
    if (!ul) return;
    ul.innerHTML = '';
    function mkLi(label, page, disabled, active) {
        return '<li class="page-item' + (disabled ? ' disabled' : '') + (active ? ' active' : '') + '">' +
            '<a class="page-link" href="#"' +
            (disabled ? '' : ' onclick="loadRestPrefixListTab6(' + page + ');return false;"') +
            '>' + label + '</a></li>';
    }
    ul.insertAdjacentHTML('beforeend', mkLi('<<', currentPageRestTab6 - 1, currentPageRestTab6 === 1, false));
    const start = Math.max(1, currentPageRestTab6 - 2);
    const end = Math.min(totalPagesRestTab6, start + 4);
    if (start > 1) {
        ul.insertAdjacentHTML('beforeend', mkLi('1', 1, false, false));
        if (start > 2) ul.insertAdjacentHTML('beforeend', mkLi('...', 1, true, false));
    }
    for (let p = start; p <= end; p++) {
        ul.insertAdjacentHTML('beforeend', mkLi(p, p, false, p === currentPageRestTab6));
    }
    if (end < totalPagesRestTab6) {
        if (end < totalPagesRestTab6 - 1) ul.insertAdjacentHTML('beforeend', mkLi('...', 1, true, false));
        ul.insertAdjacentHTML('beforeend', mkLi(totalPagesRestTab6, totalPagesRestTab6, false, false));
    }
    ul.insertAdjacentHTML('beforeend', mkLi('>>', currentPageRestTab6 + 1, currentPageRestTab6 === totalPagesRestTab6, false));
}

// Show loading spinner in the table
function showLoadingTab6() {
    const tbody = document.getElementById('prefixTableBodyTab6');
    if (tbody) {
        tbody.innerHTML =
            '<tr><td colspan="4" class="text-center py-4">' +
            '<div class="spinner-border spinner-border-sm mr-2"></div>Loading data...' +
            '</td></tr>';
    }
}

// Add a new prefix using REST API
function addRestPrefixTab6() {
    if (isAddingRestTab6) return;
    const sp = document.getElementById('searchPrefixTab6') ? document.getElementById('searchPrefixTab6').value.trim() : '';
    if (!sp) {
        showMessageTab6('Prefix is required', 'error');
        return;
    }
    isAddingRestTab6 = true;
    const prefixData = {
        searchPrefix: sp,
        gender: document.getElementById('genderTab6') ? document.getElementById('genderTab6').value : '',
        prefixOf: document.getElementById('prefixOfTab6') ? document.getElementById('prefixOfTab6').value.trim() : ''
    };
    $.ajax({
        url: '${pageContext.request.contextPath}/api/prefix',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(prefixData),
        success: function (response) {
            showMessageTab6('Added ' + sp, 'success');
            clearFormTab6();
            loadRestPrefixListTab6(1);
            isAddingRestTab6 = false;
        },
        error: function (xhr, status, error) {
            showMessageTab6('Add failed: ' + error, 'error');
            isAddingRestTab6 = false;
        }
    });
}

// Show delete confirmation modal
function confirmDeleteRest(id, prefixName) {
    deleteIdRestTab6 = id;
    const nameDisplay = prefixName || '';
    const deleteDetailsEl = document.getElementById('deleteDetailsTab6');
    if (deleteDetailsEl) {
        deleteDetailsEl.innerHTML = '<strong>' + nameDisplay + '</strong> (ID ' + id + ')';
    }
    $('#deleteConfirmModalTab6').modal('show');
}

// Execute delete using REST API
function executeDeleteRestTab6(id) {
    if (isDeletingRestTab6) return;
    isDeletingRestTab6 = true;
    $.ajax({
        url: '${pageContext.request.contextPath}/api/prefix/' + id,
        type: 'DELETE',
        success: function (response) {
            $('#deleteConfirmModalTab6').modal('hide');
            showMessageTab6('Deleted', 'success');
            loadRestPrefixListTab6(currentPageRestTab6);
            isDeletingRestTab6 = false;
        },
        error: function (xhr, status, error) {
            showMessageTab6('Delete failed: ' + error, 'error');
            isDeletingRestTab6 = false;
        }
    });
}

// Apply filter and reload list
function applyFilterTab6() {
    currentPageRestTab6 = 1;
    loadRestPrefixListTab6(1);
}
// Clear all filters
function clearFilterTab6() {
    ['searchFilterTab6', 'genderFilterTab6', 'prefixOfFilterTab6'].forEach(function (id) {
        const el = document.getElementById(id);
        if (el) el.value = '';
    });
    applyFilterTab6();
}
// Change page size and reload list
function changePageSizeTab6() {
    currentPageRestTab6 = 1;
    loadRestPrefixListTab6(1);
}
// Clear the entry form and status message
function clearFormTab6() {
    const form = document.getElementById('prefixEntryFormTab6');
    if (form) form.reset();
    const statusMessages = document.getElementById('tab6StatusMessage');
    if (statusMessages) statusMessages.innerHTML = '';
}
// Show a message in the status container
function showMessageTab6(msg, type) {
    const div = document.createElement('div');
    div.className = 'alert alert-' + (type === 'error' ? 'danger' : 'success') + ' alert-sm';
    div.textContent = msg;
    const container = document.getElementById('tab6StatusMessage');
    if (container) {
        container.innerHTML = '';
        container.appendChild(div);
        setTimeout(function () { container.innerHTML = ''; }, 4000);
    }
}
// Initialize when DOM is ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initTab6Rest);
} else {
    initTab6Rest();
}
</script>
