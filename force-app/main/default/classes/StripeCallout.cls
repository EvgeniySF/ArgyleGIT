public with sharing class StripeCallout {
    
    public static httpResponse callOut () {
        HTTP h = new HTTP();
        String httpMethod = 'POST'; 
        String endpoint = 'https://api.stripe.com/v1/checkout/sessions';
        httpRequest req = new httpRequest(); 
        String authorizationHeader = 'Bearer sk_test_xSJUc1JGBDtPAmEwhgpdZUn5';
        req.setHeader('Authorization',authorizationHeader);
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
      
        String body = 'success_url=https://google.com&cancel_url=https://google.com&payment_method_types[]=card&mode=payment&line_items[][price]=price_1HEtMPIAJJKm4vZ4J4wJ4F7r&line_items[][quantity]=1';       
        req.setBody(body);
         
        req.setMethod(httpMethod);
        req.setEndpoint(endpoint); 
        httpResponse res = h.send(req);
        System.debug('response' + res.getBody());
        return res;
    }
}