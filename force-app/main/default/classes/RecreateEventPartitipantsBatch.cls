public with sharing class RecreateEventPartitipantsBatch implements Database.Batchable<CampaignMember> { 
    
    public static Event_Participant_Updating__c  settings = Event_Participant_Updating__c.getOrgDefaults();
        
    public Iterable<CampaignMember> start(Database.BatchableContext BC) { 
        Event_Participant__c participant = [SELECT test_ids__c FROM Event_Participant__c WHERE Id =: settings.Participant_Id__c]; 
        List<Id> cmpIds = participant.test_ids__c.split(','); 
        List<CampaignMember> members = [SELECT Id, Qualified__c, Phone, Title, Contact.LastName, Lead.LastName,  Contact.FirstName, Lead.FirstName, Campaign.Name, Lead.Utm_Campaign__c, Lead.Utm_Content__c, Lead.Utm_Medium__c, Lead.Utm_Source__c, Contact.Utm_Campaign__c, Contact.Utm_Content__c, Contact.Utm_Medium__c, Contact.Utm_Source__c, CampaignId, Registration_Source_From_WFR__c, Contact.Name, Buy_Side_or_Sell_Side_Event_Participant__c, Lead.Email, Contact.Email, CreatedDate FROM CampaignMember WHERE Id IN : cmpIds Order By CreatedDate DESC];
        system.debug('members = ' + members);
        return members;
        
    } 
    
    public void execute(Database.BatchableContext info, List<CampaignMember> members) {
         
        CampaignMember cmpMember = members[0];  
        Event_Participant__c eventParticipant = new Event_Participant__c(); 
        eventParticipant.Argyle_Group_Event__c = settings.Event_Id__c; 
        eventParticipant.CampaignMember_Id__c = cmpMember.Id; 
        eventParticipant.Contact__c = cmpMember.ContactId; 
        eventParticipant.Lead__c = cmpMember.LeadId; 
        eventParticipant.Participant_Type__c = 'Audience'; 
        eventParticipant.Engagement_Hub_Participant__c = true; 
        eventParticipant.Participation_Status__c = 'Registered'; 
        eventParticipant.Qualified__c = cmpMember.Qualified__c; 
        eventParticipant.Registration_Date__c = Date.newinstance(cmpMember.CreatedDate.year(), cmpMember.CreatedDate.month(), cmpMember.CreatedDate.day());
        eventParticipant.Registration_Source__c = cmpMember.Registration_Source_From_WFR__c;
        eventParticipant.Source_Campaign_Name__c = cmpMember.Campaign.Name; 
        eventParticipant.utm_Campaign__c = String.isBlank(cmpMember.Contact.Utm_Campaign__c) ? cmpMember.Lead.Utm_Campaign__c : cmpMember.Contact.Utm_Campaign__c; 
        eventParticipant.utm_content__c = String.isBlank(cmpMember.Contact.utm_content__c) ? cmpMember.Lead.utm_content__c : cmpMember.Contact.utm_content__c;  
        eventParticipant.utm_medium__c = String.isBlank(cmpMember.Contact.utm_medium__c) ? cmpMember.Lead.utm_medium__c : cmpMember.Contact.utm_medium__c;  
        eventParticipant.utm_source__c = String.isBlank(cmpMember.Contact.utm_source__c) ? cmpMember.Lead.utm_source__c : cmpMember.Contact.utm_source__c;  
        eventParticipant.Zapier_Email__c = String.isBlank(cmpMember.Contact.Email) ? cmpMember.Lead.Email : cmpMember.Contact.Email; 
        eventParticipant.Zapier_First_Name__c = String.isBlank(cmpMember.Contact.FirstName) ? cmpMember.Lead.FirstName : cmpMember.Contact.FirstName; 
        eventParticipant.Zapier_Last_Name__c = String.isBlank(cmpMember.Contact.LastName) ? cmpMember.Lead.LastName : cmpMember.Contact.LastName; 
        eventParticipant.Zapier_integration_flag__c = true; //in order to use the logic for records which come from Zappier  
        eventParticipant.Zapier_phone__c = cmpMember.Phone; 
        eventParticipant.Zapier_title__c = cmpMember.Title;  
        insert eventParticipant; 
        system.debug('Inserted -> ' + cmpMember.Contact.FirstName + ' ' + cmpMember.Contact.LastName);
    }
    
    
    
    
    public void finish(Database.BatchableContext info){
        Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {'evgeniy.motalygin@nixsolutions.com'};
                mail.setToAddresses(toAddresses);
                mail.setReplyTo('argyle@gmail.com');
                mail.setSenderDisplayName('Creating missing event participants');
                mail.setSubject('Batch is finished');
                mail.setPlainTextBody('Batch is finished');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
}