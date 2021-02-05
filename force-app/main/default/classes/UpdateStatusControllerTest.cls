@isTest
public class UpdateStatusControllerTest {
    
    @TestSetup
    public static void makeData(){
        
        Argyle_Group_Event__c event = new Argyle_Group_Event__c(Name='TestEmails');
        insert event;
        
        List<Event_Participant__c> participants = new List<Event_Participant__c>();
        for(Integer i = 0; i < 200; i++)
        {
            Event_Participant__c eventParticipant = new Event_Participant__c();
            eventParticipant.Argyle_Group_Event__c = event.Id; 
            eventParticipant.Participant_Type__c = 'Audience'; 
            eventParticipant.Participation_Status__c = 'Registered';  
            eventParticipant.Zapier_Company__c = 'Company' + i;
            eventParticipant.Zapier_Email__c = 'test@gmail.com' + i;
            eventParticipant.Zapier_First_Name__c = 'fname' + i;
            eventParticipant.Zapier_Last_Name__c = 'lname' + i;
            eventParticipant.Zapier_integration_flag__c = true; //in order to use the logic for records which come from Zappier
            eventParticipant.Registration_Date__c = Date.today(); 
            eventParticipant.Zapier_title__c = 'jobTitle' + i; 
            
            participants.add(eventParticipant);
        }
        
        insert participants; 
        
        List<StaticResource> sr = [Select body, name from StaticResource where Name = 'emailsForTest']; 
        
        ContentVersion contentVersionInsert = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.csv',
            VersionData = sr.get(0).body,
            IsMajorVersion = true
        );
        insert contentVersionInsert; 
        
        
        
    }
    
    
    @isTest
    public static void test()
    {
        //Given
        Argyle_Group_Event__c event = [Select Id FROM Argyle_Group_Event__c WHERE Name = 'TestEmails' LIMIT 1];
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        System.assertEquals(documents.size(), 1); 
        
        //When 
        Test.startTest();
        UpdateStatusController.readCSVFile(documents.get(0).Id, event.Id);
        Test.stopTest();
        
        //Then
        List<Event_Participant__c> updatedParticipants = [SELECT Id, Participation_Status__c FROM Event_Participant__c];
        System.assertEquals(updatedParticipants.size(), 200); 
        
        for(Event_Participant__c participant : updatedParticipants)
        {
            System.assertEquals('Attended', participant.Participation_Status__c, 'Status should be changed to Attended');
        }
        
        List<ContentDocument> existingDocuments = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        System.assertEquals(existingDocuments.size(), 0, 'Uploaded document should be deleted'); 
        
    }
    
}