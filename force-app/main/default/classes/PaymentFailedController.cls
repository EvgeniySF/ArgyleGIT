public class PaymentFailedController {
    
    @TestVisible public String registrationPageUrl {get;set;}
    
    public PaymentFailedController()
    { 
        String eventName = ApexPages.currentPage().getParameters().get('event');
        Stripe_Integration_Extended__c eventSettings = Stripe_Integration_Extended__c.getAll().get(eventName);
        registrationPageUrl = (String)eventSettings.get('Public_Site_Url__c');  
    }

}