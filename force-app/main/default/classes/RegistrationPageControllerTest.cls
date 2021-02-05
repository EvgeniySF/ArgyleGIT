@IsTest
private class RegistrationPageControllerTest {
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
    
    
    // Case 1: Valid HttpRequest using a Continuation
    @IsTest private static void testApexContinuation() {
        StaticResource testq = [select id,body from StaticResource Where Name = 'ContinuationResponse']; 
        String mockResponseBody = testq.body.toString();
        
        //String mockResponseBody = 'cs_test_PuqPc7ube0maYjNZNI22Zaoh0tsoPXx3B2eUGfz0q478qxneLkj4avp7';
        Test.startTest();
        Continuation con = (Continuation) RegistrationPageController.startRequest('TestFirstName', 'TestLastName', 'zhenyamotalygin@gmail.com', 'jobTitle', 'company', '05003049384', 'allDay', 'All Access Pass', 'DataX', '{"utm_source":"test3","utm_medium":"test3","utm_content":"test3","utm_campaign":"test3"}');
        
        // Verify that the continuation has the correct number of requests
        Map<String, HttpRequest> requests = con.getRequests();
        system.debug('requests = ' + requests);
        System.assertEquals(1, requests.size(), 'The number of requests associated to the Continuation is not correct');
        
        // Create a mock response
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setBody(mockResponseBody);
        
        // Assign the mock response to the variable created for testing - for keeping the reference to the correct Continuation
        Test.setContinuationResponse(RegistrationPageController.continuationState.httpRequestString, response);
        
        String result = (String) RegistrationPageController.processResponse(RegistrationPageController.continuationState);
        Test.stopTest();
        system.debug(mockResponseBody);
        system.debug(result);
        StripeSessionWrapper session = (StripeSessionWrapper)JSON.deserialize(mockResponseBody, StripeSessionWrapper.class);
        
        System.assertEquals(session.Id, result, 'Continuation failed: response body not valid');
    }
    
    // Case 2: Exception caused by a problem with the continuation
    @IsTest private static void testContinuationExceptionCaptured() {
        Test.startTest();
        Continuation con = (Continuation) (Continuation) RegistrationPageController.startRequest('TestFirstName', 'TestLastName', 'zhenyamotalygin@gmail.com', 'jobTitle', 'company', '05003049384', 'allDay', 'All Access Pass', 'DataX', '{"utm_source":"test3","utm_medium":"test3","utm_content":"test3","utm_campaign":"test3"}');
        
        // Verify that the continuation has the correct number of requests
        Map<String, HttpRequest> requests = con.getRequests();
        System.assertEquals(1, requests.size(), 'The number of requests associated to the continuation is not correct');
        
        // Create a mock response
        HttpResponse response = new HttpResponse();
        response.setStatusCode(2000);
        Test.setContinuationResponse(RegistrationPageController.continuationState.httpRequestString, response);
        
        Boolean exceptionThrown = false;
        
        Object result = RegistrationPageController.processResponse(RegistrationPageController.continuationState);
        
        Test.stopTest();  
        
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean b = false;
        for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains('Registration failed. Please refresh the page and register again.')) b = true;
        }
        system.assert(b);
    }
    
    // Case 3: Exception caused by a bad HTTP response
    @IsTest private static void testHttpRequestExceptionCaptured() {
        PageReference testPage = Page.DataX;
        //testPage.getParameters().put('oid', '12345');   
        Test.setCurrentPage(testPage);
        RegistrationPageController controller = new RegistrationPageController();
        Test.startTest();
        Continuation con = (Continuation) (Continuation) RegistrationPageController.startRequest('TestFirstName', 'TestLastName', 'zhenyamotalygin@gmail.com', 'jobTitle', 'company', '05003049384', 'allDay', 'All Access Pass', 'DataX', '{"utm_source":"test3","utm_medium":"test3","utm_content":"test3","utm_campaign":"test3"}');
        
        // Verify that the continuation has the correct number of requests
        Map<String, HttpRequest> requests = con.getRequests();
        System.assertEquals(1, requests.size(), 'The number of requests associated to the continuation is not correct');
        
        // Create a mock response
        HttpResponse response = new HttpResponse();
        response.setStatusCode(400);
        Test.setContinuationResponse(RegistrationPageController.continuationState.httpRequestString, response);
        
        Boolean exceptionThrown = false;
        
        Object result = RegistrationPageController.processResponse(RegistrationPageController.continuationState);
        
        Test.stopTest();  
        
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean b = false;
        for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains('Registration failed. Please refresh the page and register again.')) b = true;
        }
        system.assert(b);
    } 
    
    
    @isTest
    private static void checkIsNotBlankAndCoupon(){ 
        PageReference testPage = Page.DataX;
        //testPage.getParameters().put('oid', '12345');   
        Test.setCurrentPage(testPage);
        RegistrationPageController controller = new RegistrationPageController();
        
        RegistrationPageController.CouponWrapper wrapperTest1 = RegistrationPageController.checkIsNotBlankAndCoupon('allDay', 'TestCoupon', 'DataX');
        system.assert(wrapperTest1.isNotBlank == false);
        system.assert(wrapperTest1.hasCoupon == true); 
        RegistrationPageController.CouponWrapper wrapperTest2 = RegistrationPageController.checkIsNotBlankAndCoupon('limited', 'notExistingCoupon', 'DataX');
        system.assert(wrapperTest2.isNotBlank == true);
        system.assert(wrapperTest2.hasCoupon == false); 
    }
    
    @isTest
    private static void testPageReference() {
        //Your test data logics
        PageReference testPage = Page.DataX;
        //testPage.getParameters().put('oid', '12345');   
        Test.setCurrentPage(testPage);
        Test.StartTest();
        PageReference pgRef = RegistrationPageController.insertEventParticipant('TestFirstName', 'TestLastName', 'zhenyamotalygin@gmail.com', 'jobTitle', 'company', '05003049384', 'allDay', 'All Access Pass', 'DataX', '{"utm_source":"test3","utm_medium":"test3","utm_content":"test3","utm_campaign":"test3"}');
        //Other Method logics
        Test.StopTest();
        system.debug('pgRef = ' + pgRef.getUrl());
        System.assert(pgRef.getUrl().contains('http://nixdev-eventregistrationtest.cs125.force.com/DataXConfirmation?id=')); 
    }
}