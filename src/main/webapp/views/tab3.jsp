<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Tab 3 - List</n<title>
        <script src="${pageContext.request.contextPath}/dwr/engine.js"></script>
        <script src="${pageContext.request.contextPath}/dwr/util.js"></script>
        <script src="${pageContext.request.contextPath}/dwr/interface/ItemService.js"></script>
        <style>
        /* basic table and pagination styling */
        .pagination { margin-top: 10px; }
        .pagination span, .pagination a { margin: 0 2px; cursor: pointer; }
        </style>
        </head>
        <body>
        <h2>Item List</h2>
        <div>
        Search: <input type="text" id="searchInput" />
        Category:
        <select id="categorySelect">
        <option value="">-- All --</option>
        <option value="A">A</option>
        <option value="B">B</option>
        <!-- add more as needed -->
        </select>
        <button onclick="loadItems(1)">Go</button>
        </div>
        <table border="1" width="100%" id="itemTable">
        <thead>
        <tr><th>ID</th><th>Code</th><th>Name</th><th>Category</th><th>Created On</th></tr>
        </thead>
        <tbody></tbody>
        </table>
        <div class="pagination" id="pager"></div>

        <script>
        const pageSize = 10;
        function loadItems(page) {
        const search = document.getElementById('searchInput').value;
        const category = document.getElementById('categorySelect').value;
        ItemService.getItemCount(search, category, {
        callback: function(count) {
        renderPager(count, page);
        ItemService.getItems(search, category, page, pageSize, {
        callback: function(list) {
        renderTable(list);
        }
        });
        }
        });
        }

        function renderTable(list) {
        const tbody = document.querySelector('#itemTable tbody');
        tbody.innerHTML = '';
        list.forEach(item => {
        const tr = document.createElement('tr');
        tr.innerHTML = `<td>${item.id}</td><td>${item.code}</td><td>${item.name}</td><td>${item.category}</td><td>${new Date(item.createdOn).toLocaleString()}</td>`;
        tbody.appendChild(tr);
        });
        }

        function renderPager(totalCount, currentPage) {
        const totalPages = Math.ceil(totalCount / pageSize);
        const pager = document.getElementById('pager');
        pager.innerHTML = '';
        for (let i = 1; i <= totalPages; i++) {
        if (i === currentPage) {
        pager.innerHTML += `<span><strong>${i}</strong></span>`;
        } else {
        pager.innerHTML += `<a onclick="loadItems(${i})">${i}</a>`;
        }
        }
        }

        // initial load
        loadItems(1);
        </script>

        </body>
        </html>
