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
    }
})