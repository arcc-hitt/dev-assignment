/*
 * This file launches the application by asking Ext JS to create
 * and launch() the Application class.
 */
Ext.application({
    extend: 'extjs.Application',

    name: 'extjs',

    requires: [
        // This will automatically load all classes in the extjs namespace
        // so that application classes do not need to require each other.
        'extjs.*'
    ],

    // The name of the initial view to create.
    mainView: 'extjs.view.main.Main'
});
