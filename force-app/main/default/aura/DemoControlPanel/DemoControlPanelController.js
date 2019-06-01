({
    resetAccounts : function(component, event, helper) {
        var action = component.get("c.deleteAll");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("From server: " + response.getReturnValue());
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
    
	createAccount : function(component, event, helper) {
        helper.createAccounts(component, 1);
	},
    
    createAccounts10 : function(component, event, helper) {
        helper.createAccounts(component, 10);
    },
    
    createAccounts100 : function(component, event, helper) {
        helper.createAccounts(component, 100);
    },    
})