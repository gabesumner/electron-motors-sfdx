({
    doInit : function(component, event, helper) {
    },
    scriptsLoaded : function(component, event, helper) {
        component.set('v.scriptsLoaded', true);
        
        // Only initialize the carousel if record loaded has also completed.
        if (component.get('v.recordLoaded') == true) {
            helper.initCarousel(component, event, helper);
        }
    },
    recordLoaded: function(component, event, helper) {
        component.set('v.color',component.get('v.simpleRecord.Paint__c'));
        
        // Only initialize the carousel if scripts loaded has also completed.
        if (component.get('v.scriptsLoaded') == true && component.get('v.recordLoaded') == false) {
            helper.initCarousel(component, event, helper);
        }
        component.set('v.recordLoaded', true);
        
        var changeType = event.getParams().changeType;
        if (changeType === "CHANGED") {
            component.find("recordEdit").reloadRecord();
        }
    },
    colorClick: function(component, event, helper) {
        var value = event.currentTarget.dataset.value;
        component.set('v.color', value);
        helper.saveRecord(component, event, helper);
    }
})