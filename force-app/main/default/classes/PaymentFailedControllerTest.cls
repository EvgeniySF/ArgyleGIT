@isTest
public class PaymentFailedControllerTest {
    
        @testSetup
    public static void setup(){
        Argyle_Group_Event__c event = new Argyle_Group_Event__c(Name='Test');
        insert event;
        
        Coupon_Code__c coupon = new Coupon_Code__c(Name = 'TestCoupon', Argyle_Group_Event__c = event.Id);
        insert coupon;
        
        Stripe_Integration_Extended__c setting = new Stripe_Integration_Extended__c();
        setting.Name  = 'DataX'; 
        setting.X1_Day_Pass_Price_Id__c  = 'price_1HIXquIAJJKm4vZ4xMu88Ut4';
        setting.All_Access_Pass_Price_Id__c  = 'price_1HIIvGIAJJKm4vZ4s8eOC18U';
        setting.Limited_Pass_Price_Id__c  = ''; 
        setting.Public_Site_Url__c  = 'http://nixdev-eventregistrationtest.cs125.force.com/DataX';
        setting.Stripe_Publishable_Key__c  = 'pk_test_8fGsF5QgzVyFCAa6aheJHQq9';
        setting.Stripe_Secret_Key__c  = 'sk_test_xSJUc1JGBDtPAmEwhgpdZUn5'; 
        setting.All_Access_Pass_Cost__c = 99;
        setting.Limited_Pass_Cost__c = 0;
        setting.X1_Day_Pass_Cost__c = 49;
        setting.All_Access_Cost_Crossed_Out__c = 189;
        setting.X1_Day_Pass_Cost_Crossed_Out__c = 99;
        setting.Salesforce_Event_Id__c = event.Id;
        setting.Confirmation_Email_Sender_Name__c = 'DataX';
        setting.Confirmation_Email_Developer_Name__c = 'DataX_Registration_Confirmation';
        setting.Success_Page_URL__c = 'http://nixdev-eventregistrationtest.cs125.force.com/DataXConfirmation';
        setting.Cancel_Page_URL__c = 'http://nixdev-eventregistrationtest.cs125.force.com/DataXPaymentFailed';
        
        insert setting;
         
    }
    
     @isTest
    private static void positiveTest(){ 
        PageReference testPage = Page.DataXPaymentFailed;
        testPage.getParameters().put('event', 'DataX');   
        Test.setCurrentPage(testPage);
        
        Test.startTest();
        PaymentFailedController controller = new PaymentFailedController();
        Test.stopTest();
        
        System.assertEquals('http://nixdev-eventregistrationtest.cs125.force.com/DataX', controller.registrationPageUrl);
    }

}