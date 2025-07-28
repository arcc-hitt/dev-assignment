<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h3>Tab 2: Popup with HTML Editor</h3>

<!-- Button trigger modal -->
<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#htmlEditorModal">
    Open HTML Editor
</button>

<!-- Modal -->
<div class="modal fade" id="htmlEditorModal" tabindex="-1" role="dialog" aria-labelledby="htmlEditorModalLabel"
     aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title" id="htmlEditorModalLabel">HTML Editor</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>

            <div class="modal-body">
                <div id="quillEditor" style="height: 300px;"></div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>

        </div>
    </div>
</div>

<!-- Quill Editor JS -->
<script>
    const quill = new Quill('#quillEditor', {
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

    // Optional: Set default content
    quill.root.innerHTML = 'Enter medical notes here...';
</script>
