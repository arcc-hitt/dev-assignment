<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h3 class="mb-4">Tab 4: Entry Screen with Delete &amp; List (DWR + Hibernate)</h3>

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
    </div>

    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-sm table-striped mb-0" id="prefixTable">
                <thead>
                <!-- filter row -->
                <tr class="bg-light">
                    <th class="px-2" style="width:20%">
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
                    <th style="width:40%">
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
                </tr>
                <!-- header row -->
                <tr class="thead-dark">
                    <th>Search Prefix</th>
                    <th>Gender</th>
                    <th>Prefix Of</th>
                    <th class="text-right">Actions</th>
                </tr>
                </thead>

                <tbody id="prefixList">
                <tr>
                    <td colspan="5" class="text-center py-4">
                        <div class="spinner-border spinner-border-sm mr-2" role="status"></div>
                        Loading…
                    </td>
                </tr>
                </tbody>
            </table>
        </div>

        <!-- Pagination Footer (Tab 3 style) -->
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
            <div id="pageInfo" class="text-muted">Page 1 of 1</div>

            <!-- Pagination controls -->
            <nav>
                <ul class="pagination pagination-sm mb-0" id="paginationControls">
                    <!-- Injected by JS -->
                </ul>
            </nav>
        </div>
    </div>
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
        deleteId        = null;

    function initTab4(){
        if(window.dwr && window.prefixService){
            dwr.engine.setAsync(true);
            dwr.engine.setErrorHandler(function(msg,ex){
                showMessage('Server error: '+msg,'error');
            });
            dwrLoaded = true;
        }

        // filter inputs + pageSize selector
        ['searchFilter','genderFilter','prefixOfFilter'].forEach(function(id){
            var el = document.getElementById(id);
            el.addEventListener('keypress',function(e){
                if(e.key==='Enter') applyFilter();
            });
            el.addEventListener('change',applyFilter);
        });
        document.getElementById('pageSizeSelect')
            .addEventListener('change',function(){
                pageSize = +this.value;
                loadPrefixList(1);
            });

        // form buttons
        document.getElementById('prefixEntryForm').addEventListener('submit',function(e){
            e.preventDefault(); addPrefix();
        });
        document.getElementById('clearBtn').addEventListener('click',clearForm);
        document.getElementById('confirmDeleteBtn').addEventListener('click',function(){
            executeDelete(deleteId);
        });

        loadPrefixList(1);
    }

    function loadPrefixList(page){
        currentPage     = page || 1;
        currentSearch   = document.getElementById('searchFilter').value.trim();
        currentGender   = document.getElementById('genderFilter').value;
        currentPrefixOf = document.getElementById('prefixOfFilter').value.trim();

        showLoading();

        if(!dwrLoaded){
            return; // no DWR? handle mock if you like
        }

        // 1) fetch total count
        prefixService.count(
            currentSearch, currentGender, currentPrefixOf,
            {
                callback: function(count){
                    totalRecords = count;
                    totalPages   = Math.max(1, Math.ceil(count / pageSize));
                    updateRecordCount();
                    updatePagination();

                    // 2) fetch current page
                    prefixService.getPrefixes(
                        currentSearch, currentGender, currentPrefixOf,
                        currentPage, pageSize,
                        {
                            callback: function(list){
                                renderTable(list);
                            },
                            errorHandler: function(m,e){
                                showMessage('Load error: '+m,'error');
                            }
                        }
                    );
                },
                errorHandler: function(m,e){
                    showMessage('Count error: '+m,'error');
                }
            }
        );
    }

    function renderTable(data){
        var tbody = document.getElementById('prefixList');
        tbody.innerHTML = '';
        if(!data || data.length===0){
            tbody.innerHTML =
                '<tr><td colspan="5" class="text-center text-muted">No records found</td></tr>';
            return;
        }
        var start = (currentPage - 1) * pageSize;
        data.forEach(function(item,i){
            // ensure strings are defined
            var sp = item.searchPrefix || '';
            var gender = item.gender || '<span class="text-muted">—</span>';
            var po = item.prefixOf || '<span class="text-muted">—</span>';

            // escape any single‐quotes before injecting into onclick
            var spEscaped = sp.replace(/'/g, "\\'");

            tbody.insertAdjacentHTML('beforeend',
                '<tr>'+
                '<td><strong>' + sp + '</strong></td>'+
                '<td>' + gender + '</td>'+
                '<td>' + po + '</td>'+
                '<td class="text-right">'+
                '<button class="btn btn-danger btn-sm" '+
                'onclick="confirmDelete(' + item.id + ',\''+ spEscaped + '\')">'+
                '<i class="fas fa-trash"></i>'+
                '</button>'+
                '</td>'+
                '</tr>'
            );
        });
    }

    function updateRecordCount(){
        document.getElementById('recordCount').textContent =
            'Total: '+ totalRecords +' records';
        document.getElementById('pageInfo').textContent =
            'Page '+ currentPage +' of '+ totalPages;
    }

    function updatePagination(){
        var ul = document.getElementById('paginationControls');
        ul.innerHTML = '';
        function mkLi(label,page,disabled,active){
            return '<li class="page-item'+(disabled?' disabled':'')+(active?' active':'')+'">'+
                '<a class="page-link" href="#"'+
                (disabled?'':' onclick="loadPrefixList('+page+');return false;"')+
                '>'+label+'</a></li>';
        }
        // prev
        ul.insertAdjacentHTML('beforeend', mkLi('«',currentPage-1,currentPage===1,false));
        // pages window
        var start = Math.max(1, currentPage-2),
            end   = Math.min(totalPages, start+4);
        if(start>1){
            ul.insertAdjacentHTML('beforeend', mkLi('1',1,false,false));
            if(start>2) ul.insertAdjacentHTML('beforeend', mkLi('…',1,true,false));
        }
        for(var p=start;p<=end;p++){
            ul.insertAdjacentHTML('beforeend', mkLi(p,p,false,p===currentPage));
        }
        if(end<totalPages){
            if(end<totalPages-1) ul.insertAdjacentHTML('beforeend', mkLi('…',1,true,false));
            ul.insertAdjacentHTML('beforeend', mkLi(totalPages,totalPages,false,false));
        }
        // next
        ul.insertAdjacentHTML('beforeend', mkLi('»',currentPage+1,currentPage===totalPages,false));
    }

    function showLoading(){
        document.getElementById('prefixList').innerHTML =
            '<tr><td colspan="5" class="text-center py-4">'+
            '<div class="spinner-border spinner-border-sm mr-2"></div>Loading…'+
            '</td></tr>';
    }

    function addPrefix(){
        if(isAdding) return;
        var sp = document.getElementById('searchPrefix').value.trim();
        if(!sp){ showMessage('Prefix is required','error'); return; }
        isAdding = true;
        prefixService.create(
            { searchPrefix: sp,
                gender: document.getElementById('gender').value,
                prefixOf: document.getElementById('prefixOf').value.trim()
            },
            {
                callback: function(){
                    showMessage('Added '+sp,'success');
                    clearForm(); loadPrefixList(1);
                    isAdding=false;
                },
                errorHandler: function(m,e){
                    showMessage('Add failed: '+m,'error'); isAdding=false;
                }
            }
        );
    }

    function confirmDelete(id, prefixName){
        deleteId = id;
        var nameDisplay = prefixName || '';
        document.getElementById('deleteDetails').innerHTML =
            '<strong>' + nameDisplay + '</strong> (ID ' + id + ')';
        $('#deleteConfirmModal').modal('show');
    }

    function executeDelete(id){
        if(isDeleting) return;
        isDeleting = true;
        prefixService.deletePrefix(
            id,
            {
                callback: function(){
                    $('#deleteConfirmModal').modal('hide');
                    showMessage('Deleted','success');
                    loadPrefixList(currentPage);
                    isDeleting=false;
                },
                errorHandler: function(m,e){
                    showMessage('Delete failed: '+m,'error');
                    isDeleting=false;
                }
            }
        );
    }

    function applyFilter(){
        currentPage=1;
        loadPrefixList(1);
    }
    function clearFilter(){
        ['searchFilter','genderFilter','prefixOfFilter'].forEach(function(id){
            document.getElementById(id).value='';
        });
        applyFilter();
    }
    function changePageSize(){
        currentPage=1;
        loadPrefixList(1);
    }
    function clearForm(){
        document.getElementById('prefixEntryForm').reset();
        document.getElementById('statusMessages').innerHTML='';
    }
    function showMessage(msg,type){
        var div=document.createElement('div');
        div.className='alert alert-'+(type==='error'?'danger':'success')+' alert-sm';
        div.textContent=msg;
        var container=document.getElementById('statusMessages');
        container.innerHTML=''; container.appendChild(div);
        setTimeout(function(){ container.innerHTML=''; },4000);
    }

    document.addEventListener('DOMContentLoaded',initTab4);
</script>

