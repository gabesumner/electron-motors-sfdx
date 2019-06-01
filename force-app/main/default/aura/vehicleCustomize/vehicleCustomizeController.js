({
    doInit : function(component, event, helper) {
    },
    afterScriptsLoaded : function(component, event, helper) {
    },
    selectOption : function(component, event, helper) {
        var dataValue = event.currentTarget.dataset.value;
        dataValue = dataValue.split(",");
        var field = dataValue[0];
        var value = dataValue[1];
        component.set('v.vehicle.' + field, value);
        helper.saveRecord(component);
    },
    checkOption : function(component, event, helper) {
        var checkbox = event.getSource();
        var field = checkbox.get("v.name");
        var value = checkbox.get("v.value");
        component.set('v.vehicle.' + field, value);
        helper.saveRecord(component);
	},
    handleVehicleIdSetEvent : function(component, event, helper) {
        var vehicleId = event.getParam("vehicleId");
        console.log('handleVehicleIdSetEvent: ' + vehicleId);
        // If we have a vehicleId, then use it.
        if (vehicleId) {
			component.set('v.recordId', vehicleId);
            component.find("recordLoader").reloadRecord();
			return;            
        }
        // If we don't have a VehicleId and aren't actively creating one, then create a new vehicle
        if (vehicleId == null && component.get("v.creatingVehicle") == false) {
            component.set("v.creatingVehicle", true);
            console.log('Creating new vehicle');
            helper.createNewVehicle(component, function(vehicleId) {
                if (vehicleId != null) {
                    component.set('v.recordId', vehicleId);
                    component.find("recordLoader").reloadRecord();
                    component.set("v.creatingVehicle", false);
                    console.log('Created vehicle: ' + vehicleId);
                    helper.fireVehicleIdSetEvent(vehicleId);
                }
            });
        }
    },
    handleModelSelectedEvent : function(component, event, helper) {
        var model = event.getParam("model");
		component.set('v.vehicle.Model__c', model);
        helper.saveRecord(component);
    }    
})