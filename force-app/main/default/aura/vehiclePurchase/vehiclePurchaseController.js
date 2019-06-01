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
        component.set('v.Price', price);
        helper.recalc(component, event, helper);
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
    updatePayment : function(component, event, helper) {
        helper.recalc(component, event, helper);
    },
    applyClick : function(component, event, helper) {
        var vehicleID = component.get('v.recordId');
        var price = component.get('v.Price');
        var terms = component.get('v.Terms');
        var downpayment = component.get('v.Downpayment');
        
        var action = component.get("c.createLoanForUser");
        action.setParams({
            vehicleID : vehicleID,
            price : price,
            terms : terms,
            downpayment : downpayment
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
        
        var paymentContainer = component.find("paymentContainer").getElement();
        var successContainer = component.find("successContainer").getElement();
        var buttonsContainer = component.find("buttonsContainer").getElement();
        paymentContainer.style.display = 'none';
        buttonsContainer.style.display = 'none';
        successContainer.style.display = 'block';
        
    }
})