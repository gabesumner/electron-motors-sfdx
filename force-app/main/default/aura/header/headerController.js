({
    doInit: function (component, event, helper) {
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        if (userId) {
            component.set("v.login", '');
            var action = component.get("c.GetCurrentUsersFirstName");
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var firstname = response.getReturnValue();
                    //component.set("v.login", 'Hi, ' + firstname);
                    component.set("v.login", 'Account');
                }
            });
            $A.enqueueAction(action);
        }
    },
    clickedModel: function (component, event, helper) {
        var src = event.getSource();
        var model = src.get("v.value");
        document.cookie = "model=" + model;
        var appEvent = $A.get("e.c:modelSelectedEvent");
        appEvent.setParams({
            "model": model
        });
        appEvent.fire();
    }
})