@RestResource(urlMapping='/stripeService2')
global class StripeService2 {
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
        insert new Account(Name='stripeName', Description = requestString);
        
        //Do your magic
    }
}