public class RegistrationPageController { 
    public static String requestLabel; 
    public static String API_KEY{get; set;}   
    @TestVisible private static StateInfo continuationState;
    
    public static final String CALLBACK_NAME = 'processResponse';
    public static final String REGISTRATION_ERROR = 'Registration failed. Please refresh the page and register again.';
    private static final String SERVICE_URL = 'https://api.stripe.com/v1/checkout/sessions'; 
    public static final Map<String, String> ticketTypesMapping = new Map<String, String>{'allDay' => 'All_Access_Pass_Price_Id__c', '1day' => 'X1_Day_Pass_Price_Id__c', 'limited' => 'Limited_Pass_Price_Id__c'}; 
    public static final Map<String, String> ticketRevenues = new Map<String, String>{'limited' => 'Limited_Pass_Cost__c', 'allDay' => 'All_Access_Pass_Cost__c', '1day' => 'X1_Day_Pass_Cost__c'}; 

    private static final String AUTHORIZATION = 'Bearer ' + Stripe_Integration__c.getOrgDefaults().Stripe_Secret_Key__c; 
    public static final Stripe_Integration__c stripeCustomSettings = Stripe_Integration__c.getOrgDefaults();
    public static final Map<String, Stripe_Integration_Extended__c> stripeExtendedSettings = Stripe_Integration_Extended__c.getAll();  
    public static Stripe_Integration_Extended__c eventSettings{get;set;}   
    public static String utmDataJSON {get;set;}
    
    public RegistrationPageController(){
        API_KEY = String.valueOf(stripeCustomSettings.get('Stripe_Publishable_Key__c'));  
        UTMDataWrapper utmData = new UTMDataWrapper(ApexPages.currentPage().getParameters());  
        utmDataJSON = JSON.serialize(utmData);
        determineRegistrationPage();
    }    
    
    public static void determineRegistrationPage() {
        String pageName = ApexPages.currentPage().getUrl();  
        
        if(pageName.contains('CFOLive'))
        {
            eventSettings = stripeExtendedSettings.get('CFOLive'); 
        } else if(pageName.contains('DataX')){ 
            eventSettings = stripeExtendedSettings.get('DataX');  
        } else {
            eventSettings = stripeExtendedSettings.get('CMOVirtual');  
        }
    }
    
    @RemoteAction
    public static CouponWrapper checkIsNotBlankAndCoupon(String ticketType, String coupon, String eventName){  
        Boolean isNotBlank = String.IsBlank((String)stripeExtendedSettings.get(eventName).get(ticketTypesMapping.get(ticketType)));
        Boolean hasCoupon = false;
        
        if(coupon != null)
        {
            List<Coupon_Code__c> existingCoupons = [SELECT ID, Name FROM Coupon_Code__c WHERE Argyle_Group_Event__c =: (String)stripeExtendedSettings.get(eventName).get('Salesforce_Event_Id__c') AND Name =: coupon LIMIT 1]; 
            if(existingCoupons.size() > 0)
            {
                hasCoupon = true;
            }
        } 
         
        CouponWrapper response = new CouponWrapper(isNotBlank, hasCoupon); 
        return response;
    }
      
    @RemoteAction
    public static PageReference insertEventParticipant(String fname, String lname, String email, String jobTitle, String company, String phone, String ticketType, String ticketAccessType, String eventName, String utmDataFromJsString){
       System.debug('utmDataFromJsString = ' + utmDataFromJsString); 
        UTMDataWrapper utmDataFromJs = (UTMDataWrapper)JSON.deserialize(utmDataFromJsString, UTMDataWrapper.class); 
        Stripe_Integration_Extended__c eventSettings = stripeExtendedSettings.get(eventName);
        String eventId = (String)eventSettings.get('Salesforce_Event_Id__c');
        String priceId = (String)eventSettings.get(ticketTypesMapping.get(ticketType)); 
        String confirmationEmailDevName = (String)eventSettings.get('Confirmation_Email_Developer_Name__c'); 
        String confirmationEmailSenderName = (String)eventSettings.get('Confirmation_Email_Sender_Name__c'); 
        Decimal ticketRevenue = (Decimal)eventSettings.get(ticketRevenues.get(ticketType)); 
        String tempCustomId = EncodingUtil.convertToHex(Crypto.generateAesKey(128)); 
         
        EventParticipantWrapper participant = new EventParticipantWrapper(fname, lname, email, jobTitle, company, phone, eventId, tempCustomId, ticketAccessType, ticketRevenue, confirmationEmailDevName, confirmationEmailSenderName, utmDataFromJs);
        participant.customId = tempCustomId;
        EventParticipantServise.createEventParticipant(participant);
        
        return urlRedirection(eventSettings, tempCustomId);
    }
    
    public static PageReference urlRedirection(Stripe_Integration_Extended__c eventSettings, String customId) { 
        String url = (String)eventSettings.get('Success_Page_URL__c') + '?id=' + customId;			 
        PageReference page = new PageReference(url);
        page.setRedirect(true);
        return page;
    }
    
    
    @RemoteAction
    public static Object startRequest(String fname, String lname, String email, String jobTitle, String company, String phone, String ticketType, String ticketAccessType, String eventName, String utmDataFromJsString) {  
        
        UTMDataWrapper utmDataFromJs = (UTMDataWrapper)JSON.deserialize(utmDataFromJsString, UTMDataWrapper.class);
        Stripe_Integration_Extended__c eventSettings = stripeExtendedSettings.get(eventName);
        String eventId = (String)eventSettings.get('Salesforce_Event_Id__c');
        String confirmationEmailDevName = (String)eventSettings.get('Confirmation_Email_Developer_Name__c');
        String confirmationEmailSenderName = (String)eventSettings.get('Confirmation_Email_Sender_Name__c');  
        String customId = EncodingUtil.convertToHex(Crypto.generateAesKey(128)); 
        
        
        Decimal ticketRevenue = (Decimal)eventSettings.get(ticketRevenues.get(ticketType)); 
        HttpRequest req = new HttpRequest();
        req.setMethod('POST'); 
        req.setHeader('Authorization', AUTHORIZATION);
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setEndpoint(SERVICE_URL);   
        req.setBody(getBody(customId, email, ticketType, eventSettings));
        
        Continuation con = new Continuation(40);  
        con.continuationMethod = CALLBACK_NAME;  
        continuationState = new StateInfo(con.addHttpRequest(req), new EventParticipantWrapper(fname, lname, email, jobTitle, company, phone, eventId, customId, ticketAccessType, ticketRevenue, confirmationEmailDevName, confirmationEmailSenderName, utmDataFromJs));
        con.state = continuationState;
        return con;  
    }
    
    public static Object processResponse(Object state) {    
        StateInfo data = (StateInfo)state; 
        HttpResponse response = Continuation.getResponse((String)data.httpRequestString); 
        Integer statusCode = response.getStatusCode();
        
        if (statusCode == 200) {
            StripeSessionWrapper session = (StripeSessionWrapper)JSON.deserialize(response.getBody(), StripeSessionWrapper.class);
            data.participant.sessionId = session.id;
            data.participant.paymentIntent = session.payment_intent; 
            EventParticipantServise.createEventParticipant(data.participant); 
            return session.id;
        } else if(statusCode >= 2000) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, REGISTRATION_ERROR));
            return null;
        } else { 
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, REGISTRATION_ERROR));
            return null;
        }
    } 
    
    public static String getBody(String customId, String email, String ticketType, Stripe_Integration_Extended__c eventSettings){
        SYstem.debug('getBody');
        Map<String, String> requestParams = new Map<String, String>();
        requestParams.put('successUrl', 'success_url=' + (String)eventSettings.get('Success_Page_URL__c') + '?id=' + customId);
        requestParams.put('cancelUrl', 'cancel_url=' + (String)eventSettings.get('Cancel_Page_URL__c') + '?event=' + (String)eventSettings.get('Name'));
        requestParams.put('paymentMethodTypes', 'payment_method_types[]=card');
        requestParams.put('mode', 'mode=payment');
        requestParams.put('lineItemsPrice', 'line_items[][price]=' + (String)eventSettings.get(ticketTypesMapping.get(ticketType))); 
        requestParams.put('lineItemsQuantity', 'line_items[][quantity]=1');
        requestParams.put('customer_email', 'customer_email=' + email);  
        
        return String.join(requestParams.values(), '&');
        
    }

    
    public class StateInfo {
        public String httpRequestString { get; set; } 
        EventParticipantWrapper participant;
        StateInfo(String httpRequestString, EventParticipantWrapper participant) {
            this.httpRequestString = httpRequestString;
            this.participant = participant;
        }
    }
    
    public class CouponWrapper {
        public Boolean isNotBlank;
        public Boolean hasCoupon;
        CouponWrapper(Boolean isNotBlank, Boolean hasCoupon) {
            this.isNotBlank = isNotBlank;
            this.hasCoupon = hasCoupon;
        }
    }
    
    
    
}