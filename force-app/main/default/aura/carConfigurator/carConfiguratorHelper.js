({
    preloadImages: function (component) {
        var flintImage = new Image();
        flintImage.src = $A.get('$Resource.flint');
        var flareImage = new Image();
        flareImage.src = $A.get('$Resource.flare');
        var flashImage = new Image();
        flashImage.src = $A.get('$Resource.flahs');
    },

    setPhotoUrl: function (component, event, helper) {
        var model = component.get('v.model');
        switch (model) {
            case 'Flint':
                component.set('v.photoUrl', $A.get('$Resource.flint'));
                break;
            case 'Flare':
                component.set('v.photoUrl', $A.get('$Resource.flare'));
                break;
            case 'Flash':
                component.set('v.photoUrl', $A.get('$Resource.flash'));
                break;
        }
    },

    saveRecord: function (component, event, helper) {
        var color = component.get("v.color");
        component.set("v.simpleRecord.Paint__c", color);

        var model = component.get("v.model");
        component.set("v.simpleRecord.Model__c", model);

        var battery = component.get("v.battery");
        component.set("v.simpleRecord.Battery__c", battery);

        component.find("recordEdit").saveRecord($A.getCallback(function (saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                console.log("Save completed successfully.");
            } else if (saveResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                console.log('Problem saving record, error: ' + JSON.stringify(saveResult.error));
            } else {
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        }));
    }
})