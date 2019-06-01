({
    handleVehicleIdSetEvent : function(component, event, helper) {
        var vehicleId = event.getParam("vehicleId");
        console.log('Handle Vehicle Id Set Event: ' + vehicleId);
        component.set('v.recordId', vehicleId);
        component.find("recordLoader").reloadRecord();
    },
    handleRecordUpdated : function(component, event, helper) {
        console.log('Purchase handleRecordUpdated');
        var price = helper.getPrice(component);
        component.set('v.price', price);
    },
    saveClick : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Saved!",
            "message": "Your customized vehicle has been saved.",
            "type": "success"
        });
        toastEvent.fire();        
    },
    purchaseClick : function(component, event, helper) {
        
    }
})