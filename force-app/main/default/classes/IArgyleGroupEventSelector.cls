public interface IArgyleGroupEventSelector 
{
    Map<Id, Argyle_Group_Event__c> getEventsByON24Id(List<String> on24Ids);
    Map<Id, Argyle_Group_Event__c> getEventsByON24Id(Set<String> on24Ids);
    
}