({
    initCarousel: function(component, event, helper) {
        var photoWrapper = component.find('photoWrapper');
        $A.util.removeClass(photoWrapper, 'hide');        
        
        var startIndex = 0;
        var model = component.get("v.simpleRecord.Model__c");
        if (model == 'Flint') {
            startIndex = 0;
        } else if (model == 'Flare') {
            startIndex = 1;
        } else {
            startIndex = 2;
        }
        
        const siema = component.find("siema").getElement();
        const Simea = new Siema({
            selector: siema,
            startIndex: startIndex,
            onChange: function() {
                switch(this.currentSlide) {
                    case 0:
                        component.set("v.simpleRecord.Model__c", 'Flint');
                        break;
                    case 1:
                        component.set("v.simpleRecord.Model__c", 'Flare');
                        break;
                    case 2:
                        component.set("v.simpleRecord.Model__c", 'Flash');
                        break;
                }
                helper.saveRecord(component, event, helper);
            }
        });
    },
    
    saveRecord: function(component, event, helper) {
        var color = component.get("v.color");
        component.set("v.simpleRecord.Paint__c", color);
        
        component.find("recordEdit").saveRecord($A.getCallback(function(saveResult) {
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
    },
    
    initFlow: function(component, event, helper) {
        /*
        var flow = component.find("flow");
        var inputVariables = [
            {
                name : 'recordId',
                type : 'String',
                value : component.get('v.recordId')
            }
        ];
        flow.startFlow("Price_Quote", inputVariables);        
        console.log('initFlow');
        */
    }    
})