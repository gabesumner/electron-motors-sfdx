({
    createAccounts : function(component, helper, NumberofAccounts) {
        var action = component.get("c.GenerateAccounts");
        action.setParams({ NumberofAccounts : NumberofAccounts });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("Created accounts.");
            }
            else if (state === "INCOMPLETE") {
                console.log("INCOMPLETE");
            }
                else if (state === "ERROR") {
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
        helper.showSuccess('Account(s) generated');
    },

    showSuccess : function(message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: message,
            type: 'success'
        });
        toastEvent.fire();        
    }
})