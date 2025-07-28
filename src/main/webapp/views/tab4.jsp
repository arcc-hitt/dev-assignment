<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h3>Tab 4: Entry Screen with Delete and List Functionality</h3>

<!-- Entry Form -->
<div class="card mb-4">
    <div class="card-header">
        <h5>Add New Prefix</h5>
    </div>
    <div class="card-body">
        <div class="row">
            <div class="col-md-4">
                <div class="form-group">
                    <label for="searchPrefix">Search Prefix:</label>
                    <input type="text" id="searchPrefix" class="form-control" placeholder="e.g., Mr., Mrs., Dr.">
                </div>
            </div>
            <div class="col-md-4">
                <div class="form-group">
                    <label for="gender">Gender:</label>
                    <select id="gender" class="form-control">
                        <option value="">Select Gender</option>
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
            </div>
            <div class="col-md-4">
                <div class="form-group">
                    <label for="prefixOf">Prefix Of:</label>
                    <input type="text" id="prefixOf" class="form-control" placeholder="e.g., S/O,H/O,F/O">
                </div>
            </div>
        </div>
        <button id="addBtn" class="btn btn-primary mt-3">Add Prefix</button>
    </div>
</div>

<!-- Data Table -->
<div class="card">
    <div class="card-header d-flex justify-content-between align-items-center">
        <h5>Prefix List</h5>
        <button id="refreshBtn" class="btn btn-secondary btn-sm">Refresh</button>
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
                <tbody id="prefixList">
                    <!-- Data will be loaded here -->
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    // Wait until the DWR engine is ready
    dwr.engine.setAsync(true);
    dwr.engine.setErrorHandler(function(msg, ex) {
        console.error("DWR error:", msg, ex);
    });

    // Wrap in a small timeout to ensure dwr and prefixService are defined
    window.addEventListener("load", function(){
        if (typeof prefixService === "undefined") {
            console.error("prefixService is not defined—check your /dwr/* includes");
            return;
        }

        // Load the list
        function loadPrefixList(){
            prefixService.listAll(function(list){
                $('#prefixList').empty();
                if (list && list.length > 0) {
                    list.forEach(function(p){
                        $('#prefixList').append(
                            '<tr>' +
                            '<td>' + (p.searchPrefix || '') + '</td>' +
                            '<td>' + (p.gender || '') + '</td>' +
                            '<td>' + (p.prefixOf || '') + '</td>' +
                            '<td>' +
                            '<button class="btn btn-danger btn-sm" onclick="deletePrefix(' + p.id + ')">Delete</button>' +
                            '</td>' +
                            '</tr>'
                        );
                    });
                } else {
                    $('#prefixList').append('<tr><td colspan="4" class="text-center">No data available</td></tr>');
                }
            });
        }

        // Delete function
        window.deletePrefix = function(id){
            if (confirm('Are you sure you want to delete this prefix?')) {
                prefixService.delete(id, function(){
                    loadPrefixList();
                });
            }
        };

        // Add new prefix
        $('#addBtn').click(function(){
            var searchPrefix = $('#searchPrefix').val();
            var gender = $('#gender').val();
            var prefixOf = $('#prefixOf').val();
            
            if (!searchPrefix) {
                alert('Please enter a search prefix');
                return;
            }
            
            var prefix = {
                searchPrefix: searchPrefix,
                gender: gender,
                prefixOf: prefixOf
            };
            
            prefixService.create(prefix, function(){
                $('#searchPrefix').val('');
                $('#gender').val('');
                $('#prefixOf').val('');
                loadPrefixList();
            });
        });

        // Refresh button
        $('#refreshBtn').click(function(){
            loadPrefixList();
        });

        // Initial load
        loadPrefixList();
    });
</script>
