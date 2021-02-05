@isTest
public class SuccessPageControllerTest {
    
    @testSetup
    public static void setup(){
        Argyle_Group_Event__c event = new Argyle_Group_Event__c(Name='Test');
        insert event;
        
        Event_Participant__c eventParticipant= new Event_Participant__c();
        eventParticipant.Participant_Type__c = 'Audience';
        eventParticipant.Participation_Status__c = 'Registered';
        eventParticipant.Argyle_Group_Event__c = event.Id;
        eventParticipant.Zapier_Company__c = 'Company';
        eventParticipant.Zapier_Email__c = 'test@gmail.com';
        eventParticipant.Zapier_First_Name__c = 'fname';
        eventParticipant.Zapier_Last_Name__c = 'lname';
        eventParticipant.Zapier_integration_flag__c = true; //in order to use the logic for records which come from Zappier
        eventParticipant.Registration_Date__c = Date.today();
        eventParticipant.Zapier_phone__c = '0500403928';
        eventParticipant.Zapier_title__c = 'jobTitle'; 
        eventParticipant.Stripe_Session_Id__c  = 'cs_wei3_39fm20ig20ieg2iejqosdjg0923ngkl34ogihj9fw04n2';
        eventParticipant.Custom_Id__c = '29jf39rnf029pjtfna09jgigklsgq23fgregs';
        eventParticipant.Ticket_Access_Type__c = 'Limited Pass';
        eventParticipant.Ticket_Payment_Status__c  = 'Unpaid'; 
        eventParticipant.Confirmation_Email_is_Sent__c = false; 
        eventParticipant.Confirmation_Email_Dev_Name__c  = 'DataX_Registration_Confirmation';
        eventParticipant.Confirmation_Email_Sender_Name__c = 'DataX';
        
        insert eventParticipant;
    }
    
    @isTest
    public static void testPositive(){
        //Given
        PageReference myVfPage = Page.SuccessPage;
        Test.setCurrentPage(myVfPage);
        String customId = '29jf39rnf029pjtfna09jgigklsgq23fgregs'; 
        ApexPages.currentPage().getParameters().put('id', customId);
        
        //When
        SuccessPageController sc = new SuccessPageController();  
        Test.startTest();
        sc.updateStatus();
        system.assertEquals(1, Limits.getEmailInvocations());
        Test.stopTest();
        
        //Then
        Event_Participant__c eventParticipant = [SELECT Custom_Id__c, Ticket_Payment_Status__c FROM Event_Participant__c LIMIT 1];
        System.assert(eventParticipant.Custom_Id__c == customId);
        System.assert(eventParticipant.Ticket_Payment_Status__c == 'Paid'); 
    }
    
    @isTest
    public static void testNegative(){
        //Given
        PageReference myVfPage = Page.SuccessPage;
        Test.setCurrentPage(myVfPage);
        String customId = '29jf39rnf029pjtfna09jgigklsgq23fgregs'; 
        ApexPages.currentPage().getParameters().put('id', customId);
        
        //When
        SuccessPageController sc = new SuccessPageController();  
        SuccessPageController.throwEx = true; 
        Test.startTest();
        sc.updateStatus(); 
        //Then  
        system.assertEquals(1, Limits.getEmailInvocations());
        Test.stopTest(); 
    }
    
}