public class EventParticipantSelector implements IEventParticipantSelector
{ 
    public List<Event_Participant__c> getExistingParticipantsByEvent(Set<Id> argyleGroupEventIds)
    {
        List<Event_Participant__c> existingParticipantsByArgyleEvent = [SELECT ON24_Registrant_Id__c, Zapier_First_Name__c, Zapier_Last_Name__c, Zapier_Company__c, Argyle_Group_Event__c, Zapier_title__c, Zapier_Email__c FROM Event_Participant__c WHERE Argyle_Group_Event__c IN : argyleGroupEventIds];
        return existingParticipantsByArgyleEvent;
    }
    
    public List<Event_Participant__c> getParticipantsToDelete(Set<Id> eventParticipantIdsToDelete)
    {
        List<Event_Participant__c> existingParticipantsToDelete = [SELECT Id FROM Event_Participant__c WHERE Id IN : eventParticipantIdsToDelete];
        return existingParticipantsToDelete;
    } 
}