trigger vehicleUpdateTrigger on Vehicle__c (before insert, before update) {
    for (Vehicle__c vehicle : Trigger.new) {
        // This is hack to avoid 2 vehicles claiming the same Unique External ID
        if (vehicle.SAP_ID__c != null) {
            System.debug('Vehicle ID: ' + vehicle.Id);
            System.debug('SAP ID: ' + vehicle.SAP_ID__c);
            List<Vehicle__c> vehicles2 = [SELECT Id, SAP_ID__c FROM Vehicle__c WHERE Id != :vehicle.Id AND SAP_ID__c = :vehicle.SAP_ID__c];
            for (Vehicle__c vehicle2 : vehicles2) {
                System.debug('Vehicle2 ID: ' + vehicle2.Id);
                vehicle2.SAP_ID__c = null;
                update vehicle2;
            }
        }
        
        // Set the Price is zero or null
        Integer price = 0;
        
        switch on vehicle.Model__c {
            when 'Flint' {
                price = 30000;
            }
            when 'Flare' {
                price = 40000;
            }
            when 'Flash' {
                price = 50000;
            }
        }
        
        switch on vehicle.Battery__c {
            when '75 kWh' {
                price = price + 5000;
            }
            when '100 kWh' {
                price = price + 10000;
            }
            when '100P kWh' {
                price = price + 12000;
            }
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
        
        vehicle.Price__c = price;
    }
}