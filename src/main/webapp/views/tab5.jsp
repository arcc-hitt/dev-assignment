<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h3>Tab 5: Excel Download and Upload Feature</h3>

<div class="row">
    <div class="col-md-6">
        <div class="card">
            <div class="card-header">
                <h5>Download Excel</h5>
            </div>
            <div class="card-body">
                <p>Download all prefix records in Excel format:</p>
                <a href="<c:url value='/excel/download'/>" class="btn btn-success">
                    <i class="fas fa-download"></i> Download All Records
                </a>
                
                <hr>
                
                <p>Download empty Excel template for data entry:</p>
                <a href="<c:url value='/excel/template'/>" class="btn btn-info">
                    <i class="fas fa-file-excel"></i> Download Template
                </a>
            </div>
        </div>
    </div>
    
    <div class="col-md-6">
        <div class="card">
            <div class="card-header">
                <h5>Upload Excel</h5>
            </div>
            <div class="card-body">
                <p>Upload Excel file with prefix data:</p>
                <form id="uploadForm" enctype="multipart/form-data">
                    <div class="form-group">
                        <input type="file" id="excelFile" name="file" class="form-control-file" accept=".xlsx,.xls" required>
                    </div>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-upload"></i> Upload Excel
                    </button>
                </form>
                
                <div id="uploadResult" class="mt-3"></div>
            </div>
        </div>
    </div>
</div>

<!-- Sample Data Table -->
<div class="card mt-4">
    <div class="card-header">
        <h5>Sample Data Structure</h5>
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-striped">
                <thead class="thead-dark">
                    <tr>
                        <th>Search Prefix</th>
                        <th>Gender</th>
                        <th>Prefix Of</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Mr.</td>
                        <td>Male</td>
                        <td>S/O,H/O,F/O</td>
                    </tr>
                    <tr>
                        <td>Mrs.</td>
                        <td>Female</td>
                        <td>D/O,W/O,M/O</td>
                    </tr>
                    <tr>
                        <td>Ms.</td>
                        <td>Female</td>
                        <td>D/O</td>
                    </tr>
                    <tr>
                        <td>Master.</td>
                        <td>Male</td>
                        <td>S/O</td>
                    </tr>
                    <tr>
                        <td>Baby boy of</td>
                        <td>Male</td>
                        <td>S/O</td>
                    </tr>
                    <tr>
                        <td>Baby girl of</td>
                        <td>Female</td>
                        <td>D/O</td>
                    </tr>
                    <tr>
                        <td>Mx.</td>
                        <td>Other</td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>Dr.</td>
                        <td></td>
                        <td>S/O,H/O,F/O,D/O,W/O,M/O</td>
                    </tr>
                    <tr>
                        <td>Prof.</td>
                        <td></td>
                        <td>S/O,H/O,F/O,D/O,W/O,M/O</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    $(function(){
        $('#uploadForm').on('submit', function(e){
            e.preventDefault();
            
            var formData = new FormData();
            var fileInput = $('#excelFile')[0];
            
            if (fileInput.files.length === 0) {
                alert('Please select a file');
                return;
            }
            
            formData.append('file', fileInput.files[0]);
            
            $.ajax({
                url: '<c:url value="/excel/upload"/>',
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                success: function(response){
                    $('#uploadResult').html('<div class="alert alert-success">' + response + '</div>');
                    $('#excelFile').val('');
                },
                error: function(xhr, status, error){
                    $('#uploadResult').html('<div class="alert alert-danger">Upload failed: ' + error + '</div>');
                }
            });
        });
    });
</script>
