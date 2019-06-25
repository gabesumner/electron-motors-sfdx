public with sharing class DemoController {
    @AuraEnabled
    public static void GenerateAccount() {
        GenerateAccounts(1, false);
    }

    @AuraEnabled
    public static void GeneratePredictionAccount(Integer NumberofAccounts) {
        GenerateAccounts(1, true);      
    }

    @AuraEnabled
    public static void GenerateAccounts(Integer NumberofAccounts) {
        GenerateAccounts(NumberofAccounts, false);      
    }

    @AuraEnabled
    public static void GeneratePredictionAccounts(Integer NumberofAccounts) {
        GenerateAccounts(NumberofAccounts, true);      
    }

    @AuraEnabled
    public static void DeleteAll() {
        List<Account> accounts = [SELECT Id FROM Account];
        List<Contact> contacts = [SELECT Id FROM Contact];
        List<Case> cases = [SELECT Id FROM Case];
        List<Opportunity> opportunities = [SELECT Id FROM Opportunity];
        List<Vehicle__c> vehicles = [SELECT Id FROM Vehicle__c];
        List<Loan__c> loans = [SELECT Id FROM Loan__c];
        
        delete loans;
        delete vehicles;
        delete cases;
        delete opportunities;
        delete contacts;
        delete accounts;
    }

    @AuraEnabled
    public static String GetCurrentUsersFirstName() {
        return UserInfo.getFirstName();
    }

    @AuraEnabled
    public static String getCurrentUsersEvaluationVehicleID() {
        String contactId = getContactIDForCurrentUser();
        if (contactId == null) {
            return null;
        }
        Vehicle__c[] vehicles = [SELECT Id FROM Vehicle__c WHERE Owner__c = :contactId AND Status__c = 'Evaluation'];
        if (vehicles.size() > 0) {
            return vehicles[0].Id;
        } else {
            return null;
        }
    }
    
    @AuraEnabled  
    public static String createEvaluationVehicleForCurrentUser(String model) {
        String contactId = getContactIDForCurrentUser();
        if (contactId == null) {
            return null;
        }
        
        Vehicle__c vehicle = new Vehicle__c();
        vehicle.Model__c = model;
        vehicle.Owner__c = contactId;
        insert vehicle;
        return vehicle.Id;
    }

    @AuraEnabled
    public static String createLoanForUser(String vehicleID, String price, String terms, String downpayment) {
        Contact contact = getContactForCurrentUser();
        Loan__c loan = new Loan__c();
        loan.Price__c = integer.valueof(price);
        loan.Terms__c = integer.valueof(terms);
        loan.Interest__c = 6.00;
        loan.Downpayment__c = integer.valueof(downpayment);
        loan.Status__c = 'Pending';
        loan.Customer__c = contact.Id;
        loan.Vehicle__c = vehicleID;
        loan.FirstName__c = contact.FirstName;
        loan.LastName__c = contact.LastName;
        loan.Employer__c = contact.Employer__c;
        insert loan;
        
        Vehicle__c vehicle = [SELECT Id, Status__c FROM Vehicle__c WHERE Id = :vehicleID LIMIT 1];
        vehicle.Status__c = 'Purchase';
        update vehicle;
        
        return loan.Id;        
    }

    @AuraEnabled
    public static void CreateReema() {        
        List<Account> accounts = [SELECT ID FROM Account WHERE Name = 'Reema Karr'];
        for (Account account : accounts) {
            List<Contact> contacts = [SELECT ID From Contact WHERE AccountId = :account.Id];
            List<Vehicle__c> vehicles = [SELECT ID From Vehicle__c WHERE Account__c = :account.Id];
            List<Loan__c> loans = [SELECT ID From Loan__c WHERE Account__c = :account.Id];
            delete loans;
            delete vehicles;
            delete contacts;
        }
        delete accounts;

        Account account = new Account();
        account.Name = 'Reema Karr';
        account.Type = 'Customer';
        account.Username__c = 'reemakarr';
        account.Phone = '(555) ' + String.valueOf(randomInt(111, 999)) + '-' + String.valueOf(randomInt(1111, 9999));
        account = GetRandomAddress(account);
        insert account;

        Contact contact = CreateContact(account);
        contact.LeadSource = 'Web';
        contact.Username__c = UserInfo.getUserName();
        insert contact;
    }

    @AuraEnabled
    public static void CreateJake() {
        List<Account> accounts = [SELECT ID FROM Account WHERE Name = 'Jake Hagans'];
        for (Account account : accounts) {
            List<Contact> contacts = [SELECT ID From Contact WHERE AccountId = :account.Id];
            List<Vehicle__c> vehicles = [SELECT ID From Vehicle__c WHERE Account__c = :account.Id];
            List<Loan__c> loans = [SELECT ID From Loan__c WHERE Account__c = :account.Id];
            delete loans;
            delete vehicles;
            delete contacts;
        }
        delete accounts;

        Account account = new Account();
        account.Name = 'Jake Hagans';
        account.Type = 'Customer';
        account.Username__c = 'jakehagans';
        account.Phone = '(555) ' + String.valueOf(randomInt(111, 999)) + '-' + String.valueOf(randomInt(1111, 9999));
        account = GetRandomAddress(account);
        insert account;

        Contact contact = CreateContact(account);
        contact.LeadSource = 'Phone Inquiry';
        insert contact;

        Vehicle__c vehicle = CreateVehicle(contact, false);
        vehicle.Model__c = 'Flare';
        vehicle.Paint__c = '1000';
        vehicle.Status__c = 'Evaluation';
        vehicle.SAP_ID__c = 'V-00001';
        insert vehicle;
    }
    public static Contact getContactForCurrentUser() {
        String contactId = getContactIDForCurrentUser();
        Contact contact = [SELECT Id, FirstName, LastName, Employer__c FROM Contact WHERE Id = :contactId LIMIT 1];
        return contact;
    }
    
    public static String getContactIDForCurrentUser() {
        User[] users = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()];
        if (users.size() > 0) {
            if (users[0].ContactId != null) {
                return users[0].ContactId;
            } else {
                // If we have a User, but no associated Contact...
                Contact[] contacts = [SELECT Id FROM Contact WHERE Username__c = :UserInfo.getUserName() ORDER BY LastModifiedDate DESC];
                if (contacts.size() > 0) {
                    return contacts[0].Id;
                }
            }
        }
        return null;
    }

    private static void GenerateAccounts(Integer NumberofAccounts, Boolean IsPredictionSample) {
        List<String> FirstNames = getFirstNames();
        List<String> LastNames = getLastNames();

        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < NumberofAccounts; i++) {
            accounts.add(CreateAccount(GetRandomName(FirstNames) + ' ' + GetRandomName(LastNames)));
        }
        insert accounts;

        List<Contact> contacts = new List<Contact>();
        for (Account account : accounts) {
            contacts.add(CreateContact(account));
        }
        insert contacts;

        List<Vehicle__c> vehicles = new List<Vehicle__c>();
        for (Contact contact : contacts) {
            Vehicle__c vehicle = CreateVehicle(contact, IsPredictionSample);
            vehicles.add(vehicle);
        }
        insert vehicles;

        List<Loan__c> loans = new List<Loan__c>();
        for (Integer i = 0; i < vehicles.size(); i++) {
            if (vehicles[i].Status__c != 'Evaluation') {
                vehicles[i].Price__c = GetPrice(vehicles[i]);
                if (vehicles[i].Payment_Type__c == 'Loan') {
                    Loan__c loan = CreateLoan(vehicles[i], contacts[i]);
                    loans.add(loan);
                }
            }
        }
        update vehicles;
        insert loans;
    }

    private static Account CreateAccount(String name) {
        Account account = new Account();
        account.Name = name;
        account.Type = 'Customer';
        account.Phone = '(555) ' + String.valueOf(randomInt(111, 999)) + '-' + String.valueOf(randomInt(1111, 9999));
        account.Username__c = name.toLowerCase().replaceAll(' ', '.');
        account = GetRandomAddress(account);
        return account;
    }

    private static Contact CreateContact(Account account) {
        Contact contact = new Contact();
        List<String> names = account.Name.split(' ');
        contact.FirstName = names[0];
        contact.LastName = names[1];
        contact.Email = contact.FirstName.toLowerCase() + '.' + contact.LastName.toLowerCase() + '@example.com';
        contact.AccountId = account.Id;
        contact.Phone = account.Phone;
        contact.HomePhone = '(555) ' + String.valueOf(randomInt(111, 999)) + '-' + String.valueOf(randomInt(1111, 9999));
        contact.MobilePhone = '(555) ' + String.valueOf(randomInt(111, 999)) + '-' + String.valueOf(randomInt(1111, 9999));
        contact.MailingStreet = account.BillingStreet;
        contact.MailingCity = account.BillingCity;
        contact.MailingState = account.BillingState;
        contact.MailingPostalCode = account.BillingPostalCode;
        contact.MailingCountry = account.BillingCountry;
        contact.OtherStreet = account.BillingStreet;
        contact.OtherCity = account.BillingCity;
        contact.OtherState = account.BillingState;
        contact.OtherPostalCode = account.BillingPostalCode;
        contact.OtherCountry = account.BillingCountry;
        contact.Birthdate = GetRandomBirthDate();
        contact.LeadSource = randomString(new string[]{'Web', 'Phone Inquiry', 'Partner Referral', 'Other'});
        return contact;
    }

    public static Vehicle__c CreateVehicle(Contact contact, Boolean IsPredictionSample) {
        Vehicle__c vehicle = new Vehicle__c();
        vehicle.Year__c = String.valueOf(System.Today().year());
        vehicle.Model__c = randomString(new string[]{'Flint', 'Flare', 'Flash'});
        vehicle.Paint__c = randomString(new string[]{'0', '230', '130', '1000', '4150', '55'});
        vehicle.Wheels__c = randomString(new string[]{'19" Silver Wheels', '19" Sonic Carbon Wheels', '19" Onyx Black Spinners'});
        vehicle.Interior__c = randomString(new string[]{'White Premium', 'Black Premium', 'Light Premium', 'Cream Premium', 'Black Textile'});
        vehicle.Autopilot__c = randomBoolean();
        vehicle.Sunroof__c = randomBoolean();
        vehicle.Rear_Seats__c = randomBoolean();
        vehicle.Self_Driving__c = randomBoolean();
        vehicle.Spoiler__c = randomBoolean();
        vehicle.Hydraulic_System__c = randomBoolean();
        vehicle.Battery__c = randomString(new string[]{'75 kWh', '100 kWh', '100P kWh'});
        vehicle.Owner__c = contact.Id;
        vehicle.Account__c = contact.AccountId;
        vehicle.Cancelled__c = false;
        vehicle.Prediction_Sample__c = false;

        if (IsPredictionSample == true) {
            vehicle.Status__c = 'Purchase';
            vehicle.Prediction_Sample__c = true;
        } else {
            vehicle.Status__c = randomString(new string[]{'Evaluation', 'Purchase', 'Manufacturing', 'Delivery', 'Ownership'});
        }
        
        if (vehicle.Status__c != 'Evaluation') {
            vehicle.Payment_Type__c = randomString(new string[]{'Cash', 'Loan'});
        }

        if (vehicle.Status__c == 'Purchase') {
            vehicle.Cancelled__c = randomBoolean();
            if (vehicle.Cancelled__c == true) {
                vehicle.Cancelled__c = randomBoolean();
            }
            
            // Give Einstein some signals he can find for Cancelled accounts.
            if (vehicle.Cancelled__c == true) {
                // Cancelled vehicles are MORE likely to have 75 kWh batteries.
                if (vehicle.Battery__c != '75 kWh') {
                    vehicle.Battery__c = randomString(new string[]{'75 kWh', '75 kWh', '100 kWh', '100P kWh'});
                }
                // Cancelled vehicles are MORE likely to be paying by cash.
                if (vehicle.Payment_Type__c == 'Loan') {
                    vehicle.Payment_Type__c = randomString(new string[]{'Cash', 'Cash', 'Cash', 'Loan', 'Loan'});
                }
                // Cancelled vehicles are MORE likely to be a Flash.
                if (vehicle.Model__c != 'Flash') {
                    vehicle.Model__c = randomString(new string[]{'Flint', 'Flare', 'Flash'});
                }
                // Cancelled vehicles are LESS likely to have rear seats
                if (vehicle.Rear_Seats__c == true) {
                    vehicle.Rear_Seats__c = randomBoolean();
                }
            } else {
                if (vehicle.Battery__c == '75 kWh') {
                    vehicle.Battery__c = randomString(new string[]{'75 kWh', '75 kWh', '100 kWh', '100P kWh'});
                }
            }
        }
        
        if (vehicle.Status__c == 'Manufacturing') {
            vehicle.Manufacturing_Status__c = randomString(new string[]{'Backlog', 'Stamping', 'Welding', 'Painting', 'Assembly', 'Shipping', 'Delivered'});
        }
        
        return vehicle;
    }

    private static Loan__c CreateLoan(Vehicle__c vehicle, Contact contact) {
        Loan__c loan = new Loan__c();
        loan.Account__c = vehicle.Account__c;
        loan.Customer__c = vehicle.Owner__c;
        loan.Downpayment__c = Decimal.ValueOf(randomString(new string[]{'1000', '3000', '5000', '10000', '15000'}));
        loan.Price__c = vehicle.Price__c - loan.Downpayment__c;
        loan.Terms__c = Integer.ValueOf(randomString(new string[]{'12', '24', '36', '48', '60', '72', '84'}));
        loan.Interest__c = Decimal.ValueOf(String.ValueOf(randomInt(1, 8)) + '.' + String.ValueOf(randomInt(0, 99)));
        loan.Vehicle__c = vehicle.Id;
        loan.FirstName__c = contact.FirstName;
        loan.LastName__c = contact.LastName;
        loan.Employer__c = randomString(new string[]{'Northern Trail Outfitters', 'E-Bikes', 'DreamHouse', 'Pure Aloe', 'DreamInvest', 'Easy Spaces', 'Redwoods Insurance'});
        loan.SSN__c = String.ValueOf('55555' + String.ValueOf(randomInt(1111, 9999)));

        if (vehicle.Status__c == 'Purchase') {
            loan.Status__c = randomString(new string[]{'Pending', 'Pending', 'Declined'});
        } else {
            loan.Status__c = randomString(new string[]{'Approved'});
        }
        return loan;
    }

    private static Decimal GetPrice(Vehicle__c vehicle) {
        Map<String, Object> params = new Map<String, Object>();
        params.put('vehicle', vehicle);
        Flow.Interview.Price_Quote priceQuote = new Flow.Interview.Price_Quote(params);
        priceQuote.start();
        return (Decimal) priceQuote.getVariableValue('price');
    }

    private static String GetRandomName(List<String> names) {
        return names[randomInt(0, names.size() - 1)].replaceAll('\r', '');
    }

    public static Account GetRandomAddress(Account account) {
        List<Map<String, String>> addresses = new List<Map<String, String>>();
        addresses.add(addAddress('950 East Paces Ferry Road NE', 'Atlanta', 'GA', '30326', 'USA'));
        addresses.add(addAddress('929 108th Ave NE', 'Bellevue', 'WA', '98004', 'USA'));
        addresses.add(addAddress('500 Boylston Street', 'Boston', 'MA', '02116', 'USA'));
        addresses.add(addAddress('111 West Illinois Street', 'Chicago', 'IL', '60654', 'USA'));
        addresses.add(addAddress('2550 Wasser Terrace', 'Herndon', 'VA', '20171', 'USA'));
        addresses.add(addAddress('2035 NE Cornelius Pass Road', 'Hillsboro', 'OR', '97124', 'USA'));
        addresses.add(addAddress('111 Monument Circle', 'Indianapolis', 'IN', '46204', 'USA'));
        addresses.add(addAddress('300 Spectrum Center Drive', 'Irvine', 'CA', '92618', 'USA'));
        addresses.add(addAddress('361 Centennial Parkway', 'Louisville', 'CO', '80027', 'USA'));
        addresses.add(addAddress('1095 Avenue of the Americas', 'New York', 'NY', '10036', 'USA'));
        addresses.add(addAddress('1442 2nd Street', 'Santa Monica', 'CA', '90401', 'USA'));
        addresses.add(addAddress('12825 East Mirabeau Parkway', 'Spokane', 'WA', '99216', 'USA'));
        addresses.add(addAddress('4301 West Boy Scout Blvd', 'Tampa', 'FL', '33607', 'USA'));
        addresses.add(addAddress('10 Bay Street', 'Toronto', 'ON', 'M5J 2R8', 'Canada'));
        addresses.add(addAddress('900 Bulldog Run', 'Rolla', 'MO', '65401', 'USA'));
        addresses.add(addAddress('818 Sparta Hwy', 'Milledgeville', 'GA', '31061', 'USA'));
        addresses.add(addAddress('1541 E 4th St', 'Casper', 'WY', '82601', 'USA'));
        addresses.add(addAddress('2012 Northern Plains Dr', 'Bismarck', 'ND', '58504', 'USA'));
        addresses.add(addAddress('22655 Fairfield Rd', 'St Augusta', 'MN', '56301', 'USA'));
        addresses.add(addAddress('206 De Korra Ln', 'Wisconsin Dells', 'WI', '53965', 'USA'));
        addresses.add(addAddress('1012 Grand River Dr NE', 'Ada', 'MI', '49301', 'USA'));
        addresses.add(addAddress('400 Grant Ave', 'Duquesne', 'PA', '15110', 'USA'));
        addresses.add(addAddress('551 Oakdale Rd', 'Jamestown', 'NC', '27282', 'USA'));
        addresses.add(addAddress('4561 Springdale Rd', 'Millbrook', 'AL', '36054', 'USA'));
        addresses.add(addAddress('22750 N May Ave', 'Edmond', 'OK', '73025', 'USA'));
        addresses.add(addAddress('7139 Kilback Mountains', 'Antonito', 'CO', '81120', 'USA'));
        addresses.add(addAddress('175 Dunlap Road', 'Craigmont', 'ID', '83523', 'USA'));
        addresses.add(addAddress('174 Unnamed Road', 'Youngstown', 'FL', '32466', 'USA'));
        addresses.add(addAddress('84 Ocean Drive', 'Forest Home', 'AL', '36030', 'USA'));
        addresses.add(addAddress('87 Arizona 87', 'Coolidge', 'AZ', '85128', 'USA'));
        addresses.add(addAddress('8629 238th Road', 'Nortonville', 'KS', '66060', 'USA'));
        addresses.add(addAddress('7926 Droege Road', 'Decatur', 'IN', '46733', 'USA'));
        addresses.add(addAddress('7452 30th Avenue Northeast', 'Willow City', 'ND', '58384', 'USA'));
        addresses.add(addAddress('145 County Road 88', 'Guffey', 'CO', '80820', 'USA'));
        addresses.add(addAddress('3392 North Huron Road', 'Tawas City', 'MI', '48763', 'USA'));
        addresses.add(addAddress('14878 Lost River Court', 'Hughesville', 'MD', '20637', 'USA'));
        addresses.add(addAddress('2084 Waelchi Road', 'Denton', 'MT', '59430', 'USA'));
        addresses.add(addAddress('77820 Vineyard Canyon Road', 'San Miguel', 'CA', '93451', 'USA'));
        addresses.add(addAddress('542 Candido Hills', 'Miles City', 'MT', '59301', 'USA'));
        addresses.add(addAddress('23 Browns Lake Road', 'Helmville', 'MT', '59843', 'USA'));
        addresses.add(addAddress('5167 Pauline Field', 'Challis', 'ID', '83226', 'USA'));
        addresses.add(addAddress('30208 Lookout Road', 'Paola', 'KS', '66071', 'USA'));
        addresses.add(addAddress('301 Sherman Street', 'Huntington', 'IN', '46750', 'USA'));
        addresses.add(addAddress('620 N Westmoreland Rd', 'DeSoto', 'TX', '75115', 'USA'));
        addresses.add(addAddress('307 Bentley Manor', 'Shavano Park', 'TX', '78249', 'USA'));
        addresses.add(addAddress('6010 London Dr', 'Sunset Valley', 'TX', '78745', 'USA'));
        addresses.add(addAddress('10105 Propps St NE', 'Albuquerque', 'NM', '87112', 'USA'));
        addresses.add(addAddress('112 N El Rancho Rd', 'Santa Fe', 'NM', '87501', 'USA'));
        addresses.add(addAddress('1335 Madison St NE', 'Salem', 'OR', '97301', 'USA'));
        addresses.add(addAddress('6 Morningview Cir', 'Lake Oswego', 'OR', '97035', 'USA'));
        addresses.add(addAddress('541 SW Georgetown Way', 'Beaverton', 'OR', '97006', 'USA'));
        addresses.add(addAddress('30303 SE Lusted Rd', 'Gresham', 'OR', '97080', 'USA'));
        addresses.add(addAddress('3604 84th St E', 'Tacoma', 'WA', '98446', 'USA'));
        addresses.add(addAddress('658 Gibraltar Ct', 'Milpitas', 'CA', '95035', 'USA'));
        addresses.add(addAddress('4766 E Whitmore Ave', 'Ceres', 'CA', '95307', 'USA'));

        Map<String, String> address = addresses[DemoController.randomInt(0, addresses.size() - 1)];

        account.BillingStreet = address.get('street');
        account.BillingCity = address.get('city');
        account.BillingState = address.get('state');
        account.BillingPostalCode = address.get('postcode');
        account.BillingCountry = address.get('country');
        account.ShippingStreet = address.get('street');
        account.ShippingCity = address.get('city');
        account.ShippingState = address.get('state');
        account.ShippingPostalCode = address.get('postcode');
        account.ShippingCountry = address.get('country');

        return account;
    }

    public static Date GetRandomBirthDate() {
        return randomDate(Date.newInstance(1940, 1, 1), Date.newInstance(2005, 31, 12));
    }

    private static Integer randomInt(Integer lowerLimit, Integer upperLimit){
        Integer rand = Math.round(Math.random() * (upperLimit - lowerLimit)) + lowerLimit;
        return rand;
    }

    private static String randomString(string[] Strings) {
        return Strings[randomInt(0, Strings.size()-1)];
    }
    
    private static Boolean randomBoolean() {
        if (randomInt(0,1) == 0) {
            return false;
        } else {
            return true;
        }
    }

    private static Map<String, String> addAddress(String street, String city, String state, String postcode, String country) {
        return new Map<String, String>{'street' => street, 'city' => city, 'state' => state, 'postcode' => postcode, 'country' => country};
    }

    private static Date randomDate(Date min, Date max) {
        // Convert to DateTime values
        DateTime mint = min, maxt = max.addDays(1);
        // Then convert to milliseconds since Jan 1, 1970, and get difference in ms
        Long minms = mint.getTime(), maxms = maxt.getTime(), diff = maxms - minms;
        // Return a date between minms and maxms.
        return DateTime.newInstance(
            minms + Math.mod(Math.abs(Crypto.getRandomLong()), diff)
        ).date();
    }

    private static List<String> getFirstNames() {
        StaticResource sr = [SELECT id,body FROM StaticResource WHERE Name = 'first_names'];
        List<String> allNames = sr.body.toString().split('\n');
        return allNames;
    }

    private static List<String> getLastNames() {
        StaticResource sr = [SELECT id,body FROM StaticResource WHERE Name = 'last_names'];
        List<String> allNames = sr.body.toString().split('\n');
        return allNames;
    }
}