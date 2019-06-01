({
    getPrice : function(component) {
        var price = 0;
        var vehicle = component.get('v.vehicle');
        
        if (!vehicle) {
            return price;
        }

        switch (vehicle.Model__c) {
            case "Flint":
                price = 30000;
                break;
            case "Flare":
                price = 40000;
                break;
            case "Flash":
                price = 50000;
                break;
        }
        
        switch (vehicle.Battery__c) {
            case "75 kWh":
                price = price + 5000;
                break;
            case "100 kWh":
                price = price + 10000;
                break;
            case "100P kWh":
                price = price + 12000;
                break;
        }
        
        if (vehicle.Self_Driving__c == true) {
            price = price + 3000;
        }
        
        if (vehicle.Autopilot__c == true) {
            price = price + 5000;
        }
        
        if (vehicle.Sunroof__c == true) {
            price = price + 1500;
        }
        
        if (vehicle.Spoiler__c == true) {
            price = price + 775;
        }
        
        if (vehicle.Rear_Seats__c == true) {
            price = price + 1300;
        }
        
        if (vehicle.Hydraulic_System__c == true) {
            price = price + 1100;
        }
        
		return price;
    },
    recalc : function(component, event, helper) {
        var price = component.get("v.Price");
        if (isNaN(price) || price == null) { price = 0; }
        
        var downpayment = component.get("v.Downpayment");
        if (isNaN(downpayment) || downpayment == null) { downpayment = 0; }
        
        var rate = parseInt(component.get("v.Rate")) / 100;
        if (isNaN(rate) || rate == null) { rate = 0.06; }
        
        var terms = parseInt(component.get("v.Terms"));
        if (isNaN(terms) || terms == null) { terms = 60; }
        
        var principle = price - downpayment;
        var interest = (rate * 100) / 1200;
        var monthlyPayment = principle * interest / (1 - (Math.pow(1/(1 + interest), terms)));
        var totalPayment = monthlyPayment * terms;
        
        component.set("v.Price", price.toString());
        component.get("v.Downpayment", downpayment.toString());
        component.get("v.Rate", rate.toString());
        component.get("v.Terms", terms.toString());
        component.set("v.MonthlyPayment", monthlyPayment);
        component.set("v.TotalPayment", totalPayment);
        component.set("v.TotalInterest", totalPayment - principle);
    }    
})