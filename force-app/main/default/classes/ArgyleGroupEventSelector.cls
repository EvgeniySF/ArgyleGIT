public without sharing class ArgyleGroupEventSelector implements IArgyleGroupEventSelector
{
    public Map<Id, Argyle_Group_Event__c> getEventsByON24Id(List<String> on24Ids)
    {
        Map<Id, Argyle_Group_Event__c> mapToReturn = new Map<Id, Argyle_Group_Event__c>([SELECT ON24_Event_Id__c
                                                                                         FROM Argyle_Group_Event__c
                                                                                         WHERE ON24_Event_Id__c IN: on24Ids]);
        return mapToReturn;                                                                                
    }
    public Map<Id, Argyle_Group_Event__c> getEventsByON24Id(Set<String> on24Ids)
    {
        return getEventsByON24Id(new List<String>(on24Ids));
    }
}