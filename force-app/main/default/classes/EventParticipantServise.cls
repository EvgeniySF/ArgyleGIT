public class EventParticipantServise {
    
    
    public static void createEventParticipant( EventParticipantWrapper participantWrapper){
        Event_Participant__c eventParticipant= new Event_Participant__c();
        eventParticipant.Participant_Type__c = 'Audience';
        eventParticipant.Participation_Status__c = 'Registered';
        eventParticipant.Argyle_Group_Event__c = participantWrapper.argyleGroupEventId;
        eventParticipant.Zapier_Company__c = participantWrapper.company;
        eventParticipant.Zapier_Email__c = participantWrapper.email;
        eventParticipant.Zapier_First_Name__c = participantWrapper.firstName;
        eventParticipant.Zapier_Last_Name__c = participantWrapper.lastName;
        eventParticipant.Zapier_integration_flag__c = true; //in order to use the logic for records which come from Zappier
        eventParticipant.Registration_Date__c = Date.today();
        eventParticipant.Zapier_phone__c = participantWrapper.phone;
        eventParticipant.Zapier_title__c = participantWrapper.jobTitle; 
        eventParticipant.Stripe_Session_Id__c  = participantWrapper.sessionId;
        eventParticipant.Custom_Id__c = participantWrapper.customId;
        eventParticipant.Ticket_Access_Type__c = participantWrapper.ticketAccessType;
        eventParticipant.Ticket_Payment_Status__c  = 'Unpaid';
        eventParticipant.Stripe_Payment_Intent__c = participantWrapper.paymentIntent; 
        eventParticipant.Ticket_Revenue__c = participantWrapper.ticketRevenue; 
        eventParticipant.Confirmation_Email_Dev_Name__c = participantWrapper.confirmationEmailDevName;
        eventParticipant.Confirmation_Email_Sender_Name__c = participantWrapper.confirmationEmailSenderName; 
        system.debug('participantWrapper.utmData = ' + participantWrapper.utmData);
        eventParticipant.utm_source__c = participantWrapper.utmData.utm_source;
        eventParticipant.utm_medium__c  = participantWrapper.utmData.utm_medium;
        eventParticipant.utm_campaign__c  = participantWrapper.utmData.utm_campaign;
        eventParticipant.utm_content__c  = participantWrapper.utmData.utm_content; 
        
        insert eventParticipant;
        
        
    }
    
}