trigger EventParticipantTrigger on Event_Participant__c (before insert, after insert) 
{
    EventParticipantTriggerHelper helper = new EventParticipantTriggerHelper();
    if(Trigger.isBefore && Trigger.isInsert)
    {
        System.debug('EventParticipantTrigger before insert');
        helper.handleBeforeInsert(Trigger.new);
      //  helper.preventEngagementHubDuplicates(Trigger.new); 
    } 
    
  /*  if(Trigger.isAfter && Trigger.isInsert)
    { 
        helper.deleteEngagementHubDuplicates(Trigger.new);
        helper.createRelatedON24IdRecords(Trigger.new);  
    } */
}