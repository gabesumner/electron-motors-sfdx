({
    doInit: function (component, event, helper) {
        var background = component.get('v.background');
        if (background == 'Cityscape') {
            component.set("v.componentStyle", "background-image: url('https://s3.amazonaws.com/platformers/cityscape.png')");
        }
    },

    afterScriptsLoaded: function (component, event, helper) {
        console.log('afterScriptsLoaded');
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var model = readCookie('model');
        if (model != 'Flint' && model != 'Flare' && model != 'Flash') {
            model = 'Flint';
        }

        // If this an unauthenticated user.
        if (!userId) {
            helper.driveIn(model, component, helper);
            return;
        }

        // If this is an authenticated user.
        if (userId != null) {
            helper.getEvaluationVehicle(component, helper, function (vehicleId) {
                // Let other components know the result
                helper.fireVehicleIdSetEvent(vehicleId);
                // If no Vehicle Id was found, then default to new vehicle.
                if (!vehicleId) {
                    helper.driveIn(model, component, helper);
                    return;
                }
                // Let the dataLoader do it's thing, handleRecordUpdated will be called when it loads
                component.set('v.recordId', vehicleId);
                component.find("recordLoader").reloadRecord();
                return;
            });
            return;
        }
    },
    handleModelSelectedEvent: function (component, event, helper) {
        var model = event.getParam("model");
        helper.swapVehicle(model, component, helper);
    },
    handleVehicleIdSetEvent: function (component, event, helper) {
        var vehicleId = event.getParam("vehicleId");
        console.log('handleVehicleIdSetEvent: ' + vehicleId);
        component.set('v.recordId', vehicleId);
        component.find("recordLoader").reloadRecord();
    },
    handleRecordUpdated: function (component, event, helper) {
        var model = component.get('v.vehicle.Model__c');
        helper.driveIn(model, component, helper);
    }
})