({
    doInit : function(component, event, helper) {
        setTimeout(function() {
            helper.recalc(component, event, helper);
        }, 250);
    },
    inputUpdated : function(component, event, helper) {
        helper.recalc(component, event, helper);
    }
})