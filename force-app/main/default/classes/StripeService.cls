@RestResource(urlMapping='/stripeService')
global class StripeService {
    @HttpGet
    global static String doGet() {
        String name = RestContext.request.params.get('name');
        return 'Hello '+name;
    }
    
    @HttpPost
    global static void doPost() {
        RestRequest req = RestContext.request;
        Blob body = req.requestBody;
        String requestString = body.toString();
        //Now as you have the request string You can parse it in APex
        system.debug(requestString);
        
        //Do your magic
    }
}