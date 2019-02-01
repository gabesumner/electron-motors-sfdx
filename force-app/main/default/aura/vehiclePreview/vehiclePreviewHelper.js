({
    getPhotoUrl: function (model) {
        var photoUrl;
        switch (model) {
            case "Flint":
                photoUrl = $A.get('$Resource.flint');
                break;
            case "Flare":
                photoUrl = $A.get('$Resource.flare');
                break;
            case "Flash":
                photoUrl = $A.get('$Resource.flash');
                break;
        }
        return photoUrl;
    },
    driveOff: function (model, component, helper) {
        component.set('v.photoStyle', 'animation-name: driveOff');
    },
    driveIn: function (model, component, helper) {
        setCookie('model', model);
        var photoUrl = helper.getPhotoUrl(model);
        var img = new Image();
        img.src = photoUrl;
        img.onload = function () {
            component.set('v.photoUrl', photoUrl);
            component.set('v.photoStyle', 'animation-name: driveIn');
            // This small delay prevents stutters during the animation
            setTimeout(function () {
                helper.preloadImages();
            }, 2000);
        }
    },
    preloadImages: function () {
        var background = new Image();
        background.src = 'https://s3.amazonaws.com/platformers/cityscape.png';
        var flint = new Image();
        flint.src = $A.get('$Resource.flint');
        var flare = new Image();
        flare.src = $A.get('$Resource.flare');
        var flash = new Image();
        flash.src = $A.get('$Resource.flash');
    },
    swapVehicle: function (model, component, helper) {
        helper.driveOff(model, component, helper);
        setTimeout(function () {
            helper.driveIn(model, component, helper);
        }, 500);
    },
    getEvaluationVehicle: function (component, helper, callback) {
        var action = component.get("c.getCurrentUsersEvaluationVehicleID");
        action.setCallback(this, function (response) {
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
    fireVehicleIdSetEvent: function (vehicleId) {
        console.log('fireVehicleIdSetEvent');
        var appEvent = $A.get("e.c:vehicleIdSetEvent");
        appEvent.setParams({
            "vehicleId": vehicleId
        });
        appEvent.fire();
    }
})