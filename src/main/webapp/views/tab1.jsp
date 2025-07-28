<h3>Tab 1: Dropdowns</h3>
<div class="row">
    <div class="col-md-6">
        <label for="htmlSelect">DEPARTMENT:</label>
        <select id="htmlSelect" class="form-control">
            <option value="">Select Department</option>
            <option value="IT">IT</option>
            <option value="HR">HR</option>
            <option value="Finance">Finance</option>
            <option value="Marketing">Marketing</option>
            <option value="Sales">Sales</option>
        </select>
    </div>
    <div class="col-md-6">
        <div id="extCombo"></div>
    </div>
</div>

<script>
    Ext.onReady(function(){
        // Define a simple in‑memory store for ExtJS ComboBox
        const staticStore = Ext.create('Ext.data.Store', {
            fields: ['text','value'],
            data: [
                { text: 'STATIC VALUE', value: 'static' },
                { text: 'Option 1', value: 'opt1' },
                { text: 'Option 2', value: 'opt2' },
                { text: 'Option 3', value: 'opt3' }
            ]
        });

        // Create the ExtJS ComboBox
        Ext.create('Ext.form.ComboBox', {
            renderTo: 'extCombo',
            fieldLabel: 'STATIC VALUE',
            labelAlign: 'top',
            store: staticStore,
            queryMode: 'local',
            displayField: 'text',
            valueField: 'value',
            width: 250,
            value: 'static',
            publishes: 'value',
        });
    });
</script>
