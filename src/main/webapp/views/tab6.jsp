<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h3>Tab 6: Entry Screen with Delete and List Functionality using Web Service</h3>

<!-- Entry Form -->
<div class="card mb-4">
    <div class="card-header">
        <h5>Add New Prefix (REST API)</h5>
    </div>
    <div class="card-body">
        <div class="row">
            <div class="col-md-4">
                <div class="form-group">
                    <label for="restSearchPrefix">Search Prefix:</label>
                    <input type="text" id="restSearchPrefix" class="form-control" placeholder="e.g., Mr., Mrs., Dr.">
                </div>
            </div>
            <div class="col-md-4">
                <div class="form-group">
                    <label for="restGender">Gender:</label>
                    <select id="restGender" class="form-control">
                        <option value="">Select Gender</option>
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
            </div>
            <div class="col-md-4">
                <div class="form-group">
                    <label for="restPrefixOf">Prefix Of:</label>
                    <input type="text" id="restPrefixOf" class="form-control" placeholder="e.g., S/O,H/O,F/O">
                </div>
            </div>
        </div>
        <button id="restAddBtn" class="btn btn-primary mt-3">Add Prefix</button>
    </div>
</div>

<!-- Data Table -->
<div class="card">
    <div class="card-header d-flex justify-content-between align-items-center">
        <h5>Prefix List (REST API)</h5>
        <button id="restRefreshBtn" class="btn btn-secondary btn-sm">Refresh</button>
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-striped">
                <thead class="thead-dark">
                    <tr>
                        <th>Search Prefix</th>
                        <th>Gender</th>
                        <th>Prefix Of</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="restPrefixList">
                    <!-- Data will be loaded here -->
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    $(function(){
        // Load the list using REST API
        function loadRestPrefixList(){
            $.getJSON('<c:url value="/api/prefix/all"/>', function(data){
                $('#restPrefixList').empty();
                if (data && data.length > 0) {
                    data.forEach(function(p){
                        $('#restPrefixList').append(
                            '<tr>' +
                            '<td>' + (p.searchPrefix || '') + '</td>' +
                            '<td>' + (p.gender || '') + '</td>' +
                            '<td>' + (p.prefixOf || '') + '</td>' +
                            '<td>' +
                            '<button class="btn btn-danger btn-sm" onclick="deleteRestPrefix(' + p.id + ')">Delete</button>' +
                            '</td>' +
                            '</tr>'
                        );
                    });
                } else {
                    $('#restPrefixList').append('<tr><td colspan="4" class="text-center">No data available</td></tr>');
                }
            }).fail(function(xhr, status, error){
                $('#restPrefixList').append('<tr><td colspan="4" class="text-center text-danger">Error loading data: ' + error + '</td></tr>');
            });
        }

        // Delete function using REST API
        window.deleteRestPrefix = function(id){
            if (confirm('Are you sure you want to delete this prefix?')) {
                $.ajax({
                    url: '<c:url value="/api/prefix/"/>' + id,
                    type: 'DELETE',
                    success: function(response){
                        loadRestPrefixList();
                    },
                    error: function(xhr, status, error){
                        alert('Delete failed: ' + error);
                    }
                });
            }
        };

        // Add new prefix using REST API
        $('#restAddBtn').click(function(){
            var searchPrefix = $('#restSearchPrefix').val();
            var gender = $('#restGender').val();
            var prefixOf = $('#restPrefixOf').val();
            
            if (!searchPrefix) {
                alert('Please enter a search prefix');
                return;
            }
            
            var prefix = {
                searchPrefix: searchPrefix,
                gender: gender,
                prefixOf: prefixOf
            };
            
            $.ajax({
                url: '<c:url value="/api/prefix"/>',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(prefix),
                success: function(response){
                    $('#restSearchPrefix').val('');
                    $('#restGender').val('');
                    $('#restPrefixOf').val('');
                    loadRestPrefixList();
                },
                error: function(xhr, status, error){
                    alert('Add failed: ' + error);
                }
            });
        });

        // Refresh button
        $('#restRefreshBtn').click(function(){
            loadRestPrefixList();
        });

        // Initial load
        loadRestPrefixList();
    });
</script>
