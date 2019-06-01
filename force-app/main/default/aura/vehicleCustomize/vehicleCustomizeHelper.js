({
    saveRecord : function(component) {
        component.find("recordLoader").saveRecord($A.getCallback(function(saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                // handle component related logic in event handler
            } else if (saveResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                console.log('Problem saving record, error: ' + JSON.stringify(saveResult.error));
            } else {
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        }));		
    },
    createNewVehicle : function(component, callback) {
        var model = readCookie('model');
        if (model != 'Flint' && model != 'Flare' && model != 'Flash') {
            model = 'Flint';
        }
        
        var action = component.get("c.createEvaluationVehicleForCurrentUser");
        action.setParams({
            model : model
        });
        
        action.setCallback(this, function(response) {         
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnVal = response.getReturnValue();
                callback(returnVal);
            } else if (state === "INCOMPLETE") {
                console.log("INCOMPLETE");
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    fireVehicleIdSetEvent: function(vehicleId) {
        var appEvent = $A.get("e.c:webVehicleIdSetEvent");
        appEvent.setParams({
            "vehicleId": vehicleId
        });
        appEvent.fire();        
    }    
})