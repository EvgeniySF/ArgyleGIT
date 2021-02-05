public interface IEventParticipantSelector 
{
    List<Event_Participant__c> getExistingParticipantsByEvent(Set<Id> argyleGroupEventIds);
    List<Event_Participant__c> getParticipantsToDelete(Set<Id> eventParticipantIdsToDelete);
}