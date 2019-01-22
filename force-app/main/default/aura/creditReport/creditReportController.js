({
    checkCredit : function(component, event, helper) {
        var spinner = component.find("spinner").getElement();
        var creditDetails = component.find("creditDetails").getElement();
        spinner.style.display = 'block';
        creditDetails.style.display = 'none';
        
        setTimeout(function() {
            component.set("v.applicationId", "438938549");
            component.set("v.terms", component.get("v.simpleRecord.Terms__c") + " months");
            component.set("v.creditRequested", "$" + component.get("v.simpleRecord.Price__c").toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, "$1,"));
            component.set("v.creditLimit", "$500,000.00");
            
            var date = new Date();
            var n = date.toDateString();
            component.set("v.createdDate", n);
            component.set("v.modifiedDate", n);
            
            spinner.style.display = 'none';
            creditDetails.style.display = 'block';
            
        }, 3000);
    }
})