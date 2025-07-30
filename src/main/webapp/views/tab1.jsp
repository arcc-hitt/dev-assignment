<h3 id="tab1-title">Tab 1: Department Dropdowns</h3>
<!-- Department selection row -->
<div class="row">
    <div class="col-md-6">
        <!-- Department dropdown label and select -->
        <label for="departmentSelect" class="font-weight-bold">Department:</label>
        <select id="departmentSelect" class="form-control" aria-label="Select Department">
            <option value="">Select Department</option>
            <option value="IT">IT</option>
            <option value="HR">HR</option>
            <option value="Finance">Finance</option>
            <option value="Marketing">Marketing</option>
            <option value="Sales">Sales</option>
        </select>
    </div>
    <div class="col-md-6">
        <!-- ExtJS ComboBox placeholder -->
        <div id="staticComboContainer"></div>
    </div>
</div>
<!-- Status/Error message container -->
<div id="tab1StatusMessage" class="mt-2" aria-live="polite"></div>

<script>
// ExtJS ComboBox initialization for static values
Ext.onReady(function() {
    // In-memory store for ComboBox
    const staticComboStore = Ext.create('Ext.data.Store', {
        fields: ['label', 'value'],
        data: [
            { label: 'STATIC VALUE', value: 'static' },
            { label: 'Option 1', value: 'opt1' },
            { label: 'Option 2', value: 'opt2' },
            { label: 'Option 3', value: 'opt3' }
        ]
    });

    try {
        // Create the ComboBox
        Ext.create('Ext.form.ComboBox', {
            renderTo: 'staticComboContainer',
            fieldLabel: 'Static Value',
            labelAlign: 'top',
            store: staticComboStore,
            queryMode: 'local',
            displayField: 'label',
            valueField: 'value',
            width: 250,
            value: 'static',
            publishes: 'value',
            // Add ARIA label for accessibility
            ariaLabel: 'Static Value Dropdown'
        });
    } catch (error) {
        // Display error message to user if ComboBox fails to render
        const statusDiv = document.getElementById('tab1StatusMessage');
        if (statusDiv) {
            statusDiv.innerHTML = '<span class="text-danger">Failed to initialize dropdown: ' + error.message + '</span>';
        }
        // Optionally log error to console for debugging
        console.error('ComboBox initialization error:', error);
    }
});
</script>
