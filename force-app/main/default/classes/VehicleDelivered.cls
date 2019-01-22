public class VehicleDelivered {    
    @InvocableMethod(label='Vehicle Delivered')
    public static void vehicleDelivered(List<ID> vehicleIds) {
        for (ID vehicleId : vehicleIds) {
            ContentDocument image = [SELECT Id, Title FROM ContentDocument WHERE Title='happy_buyer' LIMIT 1];
            CollaborationGroup marketing = [SELECT Id FROM CollaborationGroup WHERE Name='Marketing Team'];
            CollaborationGroup sales = [SELECT Id FROM CollaborationGroup WHERE Name='Sales Team'];
            CollaborationGroup finance = [SELECT Id FROM CollaborationGroup WHERE Name='Finance Team'];
            CollaborationGroup manufacturing = [SELECT Id FROM CollaborationGroup WHERE Name='Manufacturing Team'];
            CollaborationGroup inspections = [SELECT Id FROM CollaborationGroup WHERE Name='Inspections Team'];
            CollaborationGroup delivery = [SELECT Id FROM CollaborationGroup WHERE Name='Delivery Team'];
            
            ConnectApi.FeedItem fi = (ConnectApi.FeedItem) ConnectApiHelper.postFeedItemWithRichText(
                Network.getNetworkId(),
                vehicleId, 
                '<p>Vehicle delivered and another happy customer! Thanks everyone! ' + 
                ' {' + marketing.Id + '} ' +
                ' {' + sales.Id + '} ' +
                ' {' + finance.Id + '} ' +
                ' {' + manufacturing.Id + '} ' +
                ' {' + inspections.Id + '} ' +
                ' {' + delivery.Id + '} </p><p>&nbsp;</p>' +
                '{img:' + image.Id + ':Image}' 
            );
        }
    }
}