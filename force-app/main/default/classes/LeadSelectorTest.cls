@isTest
public without sharing class LeadSelectorTest 
{
    @isTest
    public static void getLeadsByEmailTest()
    {
        //Given
        ILeadSelector selector = new LeadSelector();
        String leadEmail = 'testemail@gmail.com';
        Lead leadToInsert = new Lead(Email = leadEmail, LastName = 'Last Name', Status = 'New', Company = 'Test Company');
        insert leadToInsert;

        //When
        Map<Id, Lead> returnedLeads = selector.getLeadsByEmail(new List<String>{leadEmail});

        //Then
        System.assertEquals(1, returnedLeads.values().size());
        System.assertEquals(leadEmail, returnedLeads.values().get(0).Email);
    }

    @isTest
    public static void getLeadsByIds()
    {
        //Given
        ILeadSelector selector = new LeadSelector();
        String leadEmail = 'testemail@gmail.com';
        Lead leadToInsert = new Lead(Email = leadEmail, LastName = 'Last Name', Status = 'New', Company = 'Test Company');
        insert leadToInsert;

        //When
        Map<Id, Lead> returnedLeads = selector.getLeadsByIds(new List<Id>{leadToInsert.Id});

        //Then
        System.assertEquals(1, returnedLeads.values().size());
    }
}