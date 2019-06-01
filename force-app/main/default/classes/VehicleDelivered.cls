public class VehicleDelivered {    
    @InvocableMethod(label='Vehicle Delivered')
    public static void vehicleDelivered(List<ID> vehicleIds) {
        for (ID vehicleId : vehicleIds) {
            ConnectApi.FeedItem fi = (ConnectApi.FeedItem) ConnectApiHelper.postFeedItemWithRichText(
                Network.getNetworkId(),
                vehicleId, 
                '<p>Vehicle delivered and another happy customer! Thanks everyone!</p>'
            );
        }
    }
}