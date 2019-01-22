({
    createAccount : function(component) {
        var action = component.get("c.generateAccount");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("Created account: " + response.getReturnValue());
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
    },
    
    createAccounts: function(component, helper, count, max) {
        var action = component.get("c.generateAccount");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("Created account: " + response.getReturnValue());
                count++;
                if (count < max) {
                    helper.createAccounts(component, helper, count, max);
                }
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
    }
})