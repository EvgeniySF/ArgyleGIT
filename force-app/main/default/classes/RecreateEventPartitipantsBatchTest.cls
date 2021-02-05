@isTest
public class RecreateEventPartitipantsBatchTest {
    
    @testSetup
    public static void setup(){
        
        Argyle_Group_Event__c event = new Argyle_Group_Event__c(Name='Test');
        insert event;
        
        List<Account> accts = new List<Account>();
        accts.add(new Account(Name='SFDC Account1'));
        accts.add(new Account(Name='SFDC Account2'));
        insert accts;
        
        List<Contact> contacts = new List<Contact>();
        contacts.add(new Contact(FirstName='Test1', Email='test@gmail.com', LastName='Test1', Phone='555.555.5555', AccountId=accts.get(0).id)); 
        insert contacts;
        
        
        Campaign cmp = new Campaign(Name='Test', Argyle_Group_Event__c = event.Id);
        insert cmp;
        
        List<CampaignMember> members = new List<CampaignMember>();
        CampaignMember member = new CampaignMember(
            ContactId = contacts.get(0).Id,
            Status = 'sent',
            CampaignId = cmp.Id
        ); 
        members.add(member); 
         
        insert members;
        
        Event_Participant__c participant = new Event_Participant__c();
        participant.ON24_Registrant_Id__c = 'test';
        participant.Argyle_Group_Event__c = event.Id;
        participant.test_ids__c = members.get(0).Id;
        insert participant;
        
        
        Event_Participant_Updating__c setting = new Event_Participant_Updating__c();
        setting.Participant_Id__c  = participant.Id;
        setting.Event_Id__c = event.Id;
        insert setting;
    }
    
    @isTest
    public static void test(){
        Test.startTest();
        Id jobId = Database.executeBatch(new RecreateEventPartitipantsBatch(), 1); 
        Test.stopTest(); 
        System.assertEquals(2, [select count() from Event_Participant__c]);
    }
    
    
}