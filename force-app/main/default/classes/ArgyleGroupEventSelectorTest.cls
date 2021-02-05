@isTest
public without sharing class ArgyleGroupEventSelectorTest 
{
    private static final String ON24_EVENT_ID = '123456';
    private static final String EVENT_NAME = 'Event name';

    @isTest
    public static void getEventsByON24IdTest()
    {
        //Given
        IArgyleGroupEventSelector eventSelector = new ArgyleGroupEventSelector();
        Argyle_Group_Event__c event = new Argyle_Group_Event__c(Name = EVENT_NAME, ON24_Event_Id__c = ON24_EVENT_ID);
        insert event;

        //When
        Map<Id, Argyle_Group_Event__c> eventFromList = eventSelector.getEventsByON24Id(new List<String>{ON24_EVENT_ID});
        Map<Id, Argyle_Group_Event__c> eventFromSet = eventSelector.getEventsByON24Id(new Set<String>{ON24_EVENT_ID});

        //Then
        System.assertEquals(ON24_EVENT_ID, eventFromList.values().get(0).ON24_Event_Id__c);
        System.assertEquals(ON24_EVENT_ID, eventFromSet.values().get(0).ON24_Event_Id__c);
    }


}