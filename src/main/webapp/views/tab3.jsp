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
    </div>
</div>

<script type="text/javascript">
    var currentPage = 1,
        pageSize    = 10,
        totalPages  = 1;

    function initTab3() {
        // wire all filters + pageSize
        ['searchInput','searchCode','categorySelect','departmentFilter','statusFilter']
            .forEach(function(id){
                var el = document.getElementById(id);
                if (!el) return;
                el.addEventListener('keypress', function(e){
                    if (e.key==='Enter') loadItems(1);
                });
                el.addEventListener('change', function(){
                    loadItems(1);
                });
            });
        document.getElementById('pageSizeSelect')
            .addEventListener('change', function(){
                pageSize = +this.value;
                loadItems(1);
            });

        // init DWR
        if (typeof dwr!=='undefined' && typeof itemService!=='undefined') {
            dwr.engine.setAsync(true);
            dwr.engine.setErrorHandler(function(msg,ex){
                console.error(msg,ex);
            });
        }

        loadItems(1);
    }

    function loadItems(page) {
        currentPage = page||1;
        var name   = document.getElementById('searchInput').value.trim(),
            code   = document.getElementById('searchCode').value.trim(),
            type   = document.getElementById('categorySelect').value,
            dept   = document.getElementById('departmentFilter').value.trim(),
            status = document.getElementById('statusFilter').value;

        showLoading();

        itemService.getItemCount(
            name, code, type, dept, status,
            {
                callback: function(count){
                    totalPages = Math.ceil(count/pageSize);
                    document.getElementById('recordCount')
                        .textContent = 'Total: '+count+' records';
                    document.getElementById('pageInfo')
                        .textContent = 'Page '+currentPage+' of '+totalPages;

                    itemService.getItems(
                        name, code, type, dept, status,
                        currentPage, pageSize,
                        {
                            callback: function(items){
                                renderTable(items);
                                renderPagination();
                            },
                            errorHandler: function(m,e){ showError(m); }
                        }
                    );
                },
                errorHandler: function(m,e){ showError(m); }
            }
        );
    }

    function renderTable(items){
        var tbody = document.getElementById('itemTableBody');
        tbody.innerHTML = '';
        if (!items || items.length===0) {
            tbody.innerHTML = '<tr><td colspan="7" class="text-center text-muted">No records found</td></tr>';
            return;
        }
        items.forEach(function(it){
            var d = it.createdOn ? new Date(it.createdOn).toLocaleDateString() : '—';
            tbody.insertAdjacentHTML('beforeend',
                '<tr>'+
                '<td>'+ (it.name||'—')         +'</td>'+
                '<td><strong>'+ (it.code||'—') +'</strong></td>'+
                '<td>'+ (it.category||'—')     +'</td>'+
                '<td>'+ (it.phone||'—')        +'</td>'+
                '<td>'+ (it.department||'—')  +'</td>'+
                '<td>'+ (it.status||'—')      +'</td>'+
                '<td>'+ d +'</td>'+
                '</tr>'
            );
        });
    }

    function renderPagination(){
        var ul = document.getElementById('paginationControls');
        ul.innerHTML = '';
        if (totalPages<=1) return;
        function mkLi(label,page,disabled,active){
            return '<li class="page-item'
                +(disabled?' disabled':'')+
                (active? ' active':'')+
                '"><a class="page-link" href="#"'
                +(!disabled?(' onclick="loadItems('+page+');return false;"'):'')+
                '>'+label+'</a></li>';
        }
        ul.insertAdjacentHTML('beforeend', mkLi('«',currentPage-1, currentPage===1,false));
        var start = Math.max(1,currentPage-2),
            end   = Math.min(totalPages,currentPage+2);
        if (start>1) ul.insertAdjacentHTML('beforeend', mkLi('1',1,false,false));
        if (start>2) ul.insertAdjacentHTML('beforeend', mkLi('…',1,true,false));
        for(var i=start;i<=end;i++){
            ul.insertAdjacentHTML('beforeend', mkLi(i,i,false,i===currentPage));
        }
        if (end<totalPages-1) ul.insertAdjacentHTML('beforeend', mkLi('…',1,true,false));
        if (end<totalPages)   ul.insertAdjacentHTML('beforeend', mkLi(totalPages,totalPages,false,false));
        ul.insertAdjacentHTML('beforeend', mkLi('»',currentPage+1, currentPage===totalPages,false));
    }

    function showLoading(){
        document.getElementById('itemTableBody').innerHTML =
            '<tr><td colspan="7" class="text-center py-4">'+
            '<div class="spinner-border spinner-border-sm mr-2" role="status"></div>Loading...'+
            '</td></tr>';
    }
    function showError(msg){
        document.getElementById('itemTableBody').innerHTML =
            '<tr><td colspan="7" class="text-center text-danger">'+msg+'</td></tr>';
    }

    if (document.readyState==='loading') {
        document.addEventListener('DOMContentLoaded', initTab3);
    } else {
        initTab3();
    }
</script>