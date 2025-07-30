<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h3 id="tab2-title mb-2">Tab 2: HTML Editor Popup</h3>

<!-- Trigger button -->
<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#htmlEditorModal">
    Open Patient Details
</button>

<!-- Modal -->
<div class="modal fade" id="htmlEditorModal" tabindex="-1" role="dialog" aria-labelledby="htmlEditorModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">

            <!-- Header -->
            <div class="modal-header">
                <h5 class="modal-title" id="htmlEditorModalLabel">Patient Details</h5>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>

            <!-- Body -->
            <div class="modal-body">
                <div class="row">
                    <!-- Details column -->
                    <div class="col-md-6">
                        <table class="table table-borderless table-sm">
                            <tbody>
                            <tr><td>Name: <span id="patientName">${patient.name}</span></td></tr>
                            <tr><td>MRN: <span id="patientMrn">${patient.mrn}</span></td></tr>
                            <tr><td>Date Of Birth: <span id="patientDob">${patient.dob}</span></td></tr>
                            <tr><td>Age: <span id="patientAge">${patient.age}</span></td></tr>
                            <tr><td>Gender: <span id="patientGender">${patient.gender}</span></td></tr>
                            <tr><td>Address: <span id="patientAddress"></span>${patient.address}</span></td></tr>
                            <tr><td>Req Date: <span id="patientRequestDate">${patient.requestDate}</span></td></tr>
                            <tr><td>Status: <span id="patientStatus">${patient.status}</span></td></tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- Live preview column -->
                    <div class="col-md-6">
                        <label class="font-weight-bold">Live Preview</label>
                        <div id="livePreview"
                             style="height: 300px; border: 1px solid #ccc; padding: 10px; overflow-y: auto; background: #fafafa;">
                            <!-- rendered HTML will appear here -->
                        </div>
                    </div>
                </div>

                <hr/>

                <!-- Editor toolbar -->
                <div id="quillToolbar" class="mb-2">
          <span class="ql-formats">
            <button class="ql-bold"></button>
            <button class="ql-italic"></button>
            <button class="ql-underline"></button>
          </span>
                    <span class="ql-formats">
            <button class="ql-list" value="ordered"></button>
            <button class="ql-list" value="bullet"></button>
          </span>
                    <span class="ql-formats">
            <button class="ql-align" value=""></button>
            <button class="ql-align" value="center"></button>
            <button class="ql-align" value="right"></button>
          </span>
                    <span class="ql-formats">
            <button class="ql-clean"></button>
          </span>
                </div>

                <!-- Editor -->
                <div id="quillEditor" style="height: 200px; border: 1px solid #ddd;"></div>
                <div id="wordCount" class="text-right text-muted small mt-1">0 Words</div>
            </div>

            <!-- Footer -->
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>

        </div>
    </div>
</div>

<script>
    const patients = [
        {
            name: 'Alice Smith',
            mrn: 'MRN1001',
            dob: '1982-11-23',
            age: 42,
            gender: 'Female',
            address: '123 Elm Street, Springfield',
            requestDate: '2025-07-25',
            status: 'HISTOPATHOLOGY'
        },
        {
            name: 'Bob Johnson',
            mrn: 'MRN1002',
            dob: '1975-04-02',
            age: 49,
            gender: 'Male',
            address: '456 Oak Avenue, Metropolis',
            requestDate: '2025-07-26',
            status: 'CYTOLOGY'
        },
        {
            name: 'Carol Lee',
            mrn: 'MRN1003',
            dob: '1990-09-15',
            age: 34,
            gender: 'Female',
            address: '789 Pine Road, Gotham',
            requestDate: '2025-07-27',
            status: 'HAEMATOLOGY'
        }
    ];

    // Example: populate patient #1 when you open the modal
    $('#htmlEditorModal').on('show.bs.modal', function (e) {
        const patient = patients[0];  // pick 0, 1 or 2
        $('#patientName').text(patient.name);
        $('#patientMrn').text(patient.mrn);
        $('#patientDob').text(patient.dob);
        $('#patientAge').text(patient.age);
        $('#patientGender').text(patient.gender);
        $('#patientAddress').text(patient.address);
        $('#patientRequestDate').text(patient.requestDate);
        $('#patientStatus').text(patient.status);
    });

    $('#htmlEditorModal').on('shown.bs.modal', function () {
        if (!window.quill) {
            window.quill = new Quill('#quillEditor', {
                modules: { toolbar: '#quillToolbar' },
                theme: 'snow',
                placeholder: 'Enter medical notes here...'
            });

            quill.on('text-change', function() {
                // Word count
                const text = quill.getText().trim();
                const count = text ? text.split(/\s+/).length : 0;
                document.getElementById('wordCount').innerText = count + ' Words';

                // Live HTML preview
                document.getElementById('livePreview').innerHTML = quill.root.innerHTML;
            });
        }
        quill.focus();
    });

    $('#htmlEditorModal').on('hidden.bs.modal', function () {
        if (window.quill) {
            quill.setText('');
            document.getElementById('wordCount').innerText = '0 Words';
            document.getElementById('livePreview').innerHTML = '';
        }
    });
</script>
