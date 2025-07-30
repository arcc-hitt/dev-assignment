<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h3 id="tab2-title">Tab 2: HTML Editor Popup</h3>

<!-- Button to trigger HTML editor modal -->
<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#htmlEditorModalTab2" id="openHtmlEditorBtn">
    Open HTML Editor
</button>

<!-- Modal for HTML Editor -->
<div class="modal fade" id="htmlEditorModalTab2" tabindex="-1" role="dialog" aria-labelledby="htmlEditorModalLabelTab2" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="htmlEditorModalLabelTab2">HTML Editor</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <!-- Quill editor container -->
                <div id="quillEditorTab2" style="height: 300px;"></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- Status/Error message container -->
<div id="tab2StatusMessage" class="mt-2" aria-live="polite"></div>

<!-- Quill Editor JS initialization -->
<script>
// Initialize Quill editor for Tab 2 with error handling and comments
try {
    // Create a new Quill editor instance
    const quillTab2 = new Quill('#quillEditorTab2', {
        theme: 'snow',
        modules: {
            toolbar: [
                [{ header: [1, 2, false] }],
                ['bold', 'italic', 'underline'],
                ['link', 'blockquote', 'code-block'],
                [{ list: 'ordered' }, { list: 'bullet' }],
                ['clean']
            ]
        }
    });
    // Set default content for the editor
    quillTab2.root.innerHTML = 'Enter medical notes here...';
} catch (error) {
    // Display error message to user if Quill fails to initialize
    const statusDiv = document.getElementById('tab2StatusMessage');
    if (statusDiv) {
        statusDiv.innerHTML = '<span class="text-danger">Failed to initialize HTML editor: ' + error.message + '</span>';
    }
    // Optionally log error to console for debugging
    console.error('Quill initialization error:', error);
}
</script>
