public class TestingNewLogic {
    
    public static void webinarRegistrant1(){
        
        Event_Participant__c eventParticipant= new Event_Participant__c();
        eventParticipant.Participant_Type__c = 'Audience';
        eventParticipant.Participation_Status__c = 'Registered';
        eventParticipant.Argyle_Group_Event__c = 'a053K000000b9zEQAQ'; 
        eventParticipant.ON24_Registrant_Id__c = '9393939393';
        eventParticipant.Engagement_Hub_Participant__c = false;
        eventParticipant.Zapier_Company__c = 'TESTIgor';
        eventParticipant.Zapier_Email__c = 'igor@gmail.com';
        eventParticipant.Zapier_First_Name__c = 'Igor';
        eventParticipant.Zapier_Last_Name__c = 'Sanko';
        eventParticipant.Zapier_integration_flag__c = true; //in order to use the logic for records which come from Zappier
        eventParticipant.Registration_Date__c = Date.today();
        eventParticipant.Zapier_phone__c = '0500403928';
        eventParticipant.Zapier_title__c = 'igorTitle';  
        
        insert eventParticipant;
        
    }
    
    public static void webinarRegistrant2(){
        
        List<Event_Participant__c> temp = new List<Event_Participant__c>();
        
        
        Event_Participant__c eventParticipant= new Event_Participant__c();
        eventParticipant.Participant_Type__c = 'Audience';
        eventParticipant.Participation_Status__c = 'Registered';
        eventParticipant.Argyle_Group_Event__c = 'a053K000000b9zEQAQ'; 
        eventParticipant.ON24_Registrant_Id__c = '9393939393';
        eventParticipant.Engagement_Hub_Participant__c = false;
        eventParticipant.Zapier_Company__c = 'TESTDiana';
        eventParticipant.Zapier_Email__c = 'diana@gmail.com';
        eventParticipant.Zapier_First_Name__c = 'Diana';
        eventParticipant.Zapier_Last_Name__c = 'Testing';
        eventParticipant.Zapier_integration_flag__c = true; //in order to use the logic for records which come from Zappier
        eventParticipant.Registration_Date__c = Date.today();
        eventParticipant.Zapier_phone__c = '0500403928';
        eventParticipant.Zapier_title__c = 'dianaTitle';  
        
        
        Event_Participant__c eventParticipant1= new Event_Participant__c();
        eventParticipant1.Participant_Type__c = 'Audience';
        eventParticipant1.Participation_Status__c = 'Registered';
        eventParticipant1.Argyle_Group_Event__c = 'a053K000000b9zEQAQ'; 
        eventParticipant1.ON24_Registrant_Id__c = '9494949494';
        eventParticipant1.Engagement_Hub_Participant__c = false;
        eventParticipant1.Zapier_Company__c = 'TESTIgor';
        eventParticipant1.Zapier_Email__c = 'igor@gmail.com';
        eventParticipant1.Zapier_First_Name__c = 'Igor';
        eventParticipant1.Zapier_Last_Name__c = 'Sanko';
        eventParticipant1.Zapier_integration_flag__c = true; //in order to use the logic for records which come from Zappier
        eventParticipant1.Registration_Date__c = Date.today();
        eventParticipant1.Zapier_phone__c = '0500403928';
        eventParticipant1.Zapier_title__c = 'igorTitle';  
        
        temp.add(eventParticipant); 
        temp.add(eventParticipant1);
        
        insert temp;
        
    }
    
    public static void EngagementHubRegistrantWithoutExisting1(){
        
        Event_Participant__c eventParticipant= new Event_Participant__c();
        eventParticipant.Participant_Type__c = 'Audience';
        eventParticipant.Participation_Status__c = 'Registered';
        eventParticipant.Argyle_Group_Event__c = 'a053K000000b9zEQAQ'; 
        eventParticipant.ON24_Registrant_Id__c = '5555555555';
        eventParticipant.Engagement_Hub_Participant__c = true;
        eventParticipant.Zapier_Company__c = 'TESTIgor';
        eventParticipant.Zapier_Email__c = 'igor@gmail.com';
        eventParticipant.Zapier_First_Name__c = 'Igor';
        eventParticipant.Zapier_Last_Name__c = 'Sanko';
        eventParticipant.Zapier_integration_flag__c = true; //in order to use the logic for records which come from Zappier
        eventParticipant.Registration_Date__c = Date.today();
        eventParticipant.Zapier_phone__c = '0500403928';
        eventParticipant.Zapier_title__c = 'igorTitle';  
        
        insert eventParticipant;
        
    }
    
        public static void EngagementHubRegistrantWithoutExisting3(){
        
        List<Event_Participant__c> temp = new List<Event_Participant__c>();
        
        
        Event_Participant__c eventParticipant= new Event_Participant__c();
        eventParticipant.Participant_Type__c = 'Audience';
        eventParticipant.Participation_Status__c = 'Registered';
        eventParticipant.Argyle_Group_Event__c = 'a053K000000b9zEQAQ'; 
        eventParticipant.ON24_Registrant_Id__c = '6666666666';
        eventParticipant.Engagement_Hub_Participant__c = true;
        eventParticipant.Zapier_Company__c = 'TESTIgor';
        eventParticipant.Zapier_Email__c = 'igor@gmail.com';
        eventParticipant.Zapier_First_Name__c = 'Igor';
        eventParticipant.Zapier_Last_Name__c = 'Sanko';
        eventParticipant.Zapier_integration_flag__c = true; //in order to use the logic for records which come from Zappier
        eventParticipant.Registration_Date__c = Date.today();
        eventParticipant.Zapier_phone__c = '0500403928';
        eventParticipant.Zapier_title__c = 'igorTitle';  
        
        
        Event_Participant__c eventParticipant1= new Event_Participant__c();
        eventParticipant1.Participant_Type__c = 'Audience';
        eventParticipant1.Participation_Status__c = 'Registered';
        eventParticipant1.Argyle_Group_Event__c = 'a053K000000b9zEQAQ'; 
        eventParticipant1.ON24_Registrant_Id__c = '7777777777';
        eventParticipant1.Engagement_Hub_Participant__c = true;
        eventParticipant1.Zapier_Company__c = 'TESTIgor';
        eventParticipant1.Zapier_Email__c = 'igor@gmail.com';
        eventParticipant1.Zapier_First_Name__c = 'Igor';
        eventParticipant1.Zapier_Last_Name__c = 'Sanko';
        eventParticipant1.Zapier_integration_flag__c = true; //in order to use the logic for records which come from Zappier
        eventParticipant1.Registration_Date__c = Date.today();
        eventParticipant1.Zapier_phone__c = '0500403928';
        eventParticipant1.Zapier_title__c = 'igorTitle'; 
            
            Event_Participant__c eventParticipant2= new Event_Participant__c();
        eventParticipant2.Participant_Type__c = 'Audience';
        eventParticipant2.Participation_Status__c = 'Registered';
        eventParticipant2.Argyle_Group_Event__c = 'a053K000000b9zEQAQ'; 
        eventParticipant2.ON24_Registrant_Id__c = '5555555555';
        eventParticipant2.Engagement_Hub_Participant__c = true;
        eventParticipant2.Zapier_Company__c = 'TESTIgor';
        eventParticipant2.Zapier_Email__c = 'igor@gmail.com';
        eventParticipant2.Zapier_First_Name__c = 'Igor';
        eventParticipant2.Zapier_Last_Name__c = 'Sanko';
        eventParticipant2.Zapier_integration_flag__c = true; //in order to use the logic for records which come from Zappier
        eventParticipant2.Registration_Date__c = Date.today();
        eventParticipant2.Zapier_phone__c = '0500403928';
        eventParticipant2.Zapier_title__c = 'igorTitle';  
        
        temp.add(eventParticipant); 
        temp.add(eventParticipant1);
        temp.add(eventParticipant2);
        
        insert temp;
        
    }
    
}