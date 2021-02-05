public class StripeController {
    public static String firstName{get;set;}
    public static String lastName{get;set;}
    public static String email{get;set;}
    public static String company{get;set;}
    public static String sessionId{get;set;}
    
    public StripeController(){
       // sessionId = 'cs_test_nyaXsxHbRk4WPuFYAX1OcwqIxyO5fZxdUSP0gbNlY5W5vSf4YUutUDZG';
    }
    
    public void save(){
        
        HttpResponse response = StripeCallout.callOut();
        String test = response.getBody();
        StripeSessionWrapper session = (StripeSessionWrapper )JSON.deserialize(test, StripeSessionWrapper.class);
        
        system.debug('sessionId1 = ' + sessionId);
        sessionId = session.Id;
        system.debug('sessionId2 = ' + sessionId);
    }

}