@isTest
public with sharing class EventParticipantTriggerHelperTest 
{
    @isTest
    public static void handleBeforeInsert_LeadExists_Test()
    {
        //Given
        EventParticipantTriggerHelper helper = new EventParticipantTriggerHelper();
        String leadEmail = 'testemail@gmail.com';
        Lead leadToInsert = new Lead(Email = leadEmail, Company = 'Test company', Status = 'New', LastName = 'Test Last Name');
        insert leadToInsert;
        Argyle_Group_Event__c eventToInsert = new Argyle_Group_Event__c(ON24_Event_Id__c = 'Event Id');
        insert eventToInsert;
        
        Event_Participant__c triggeredParticipant = new Event_Participant__c(Zapier_Email__c = leadEmail, 
                                                                             ON24_Registrant_Id__c = 'registrant ID', 
                                                                             Argyle_Group_Event__c = eventToInsert.Id,
                                                                             Zapier_integration_flag__c = true);

        //When
        insert triggeredParticipant; 

        //Then
        List<Event_Participant__c> participantAfterFlow = [SELECT Contact__r.Email FROM Event_Participant__c WHERE Id =: triggeredParticipant.Id];
        List<Lead> leadAfterFlow = [SELECT IsConverted FROM Lead WHERE Id =: leadToInsert.Id];
        System.assertEquals(true, leadAfterFlow.get(0).IsConverted);
        System.assertEquals(leadEmail, participantAfterFlow.get(0).Contact__r.Email);
    }

    @isTest
    public static void handleBeforeInsert_ContactExists_AccountDoesnotExist_Test()
    {
        //Given
        EventParticipantTriggerHelper helper = new EventParticipantTriggerHelper();
        String contactEmail = 'testemail@gmail.com';
        String company = 'Test Company';
        Contact contactToInsert = new Contact(Email = contactEmail, LastName = 'Test Last Name');
        insert contactToInsert;
        Argyle_Group_Event__c eventToInsert = new Argyle_Group_Event__c(ON24_Event_Id__c = 'Event Id');
        insert eventToInsert;
        
        Event_Participant__c triggeredParticipant = new Event_Participant__c(Zapier_Email__c = contactEmail, 
                                                                             Zapier_Company__c = company,
                                                                             ON24_Registrant_Id__c = 'registrant ID', 
                                                                             Argyle_Group_Event__c = eventToInsert.Id,
                                                                             Zapier_integration_flag__c = true);

        //When
        insert triggeredParticipant; 

        //Then
        List<Event_Participant__c> participantAfterFlow = [SELECT Contact__c, Contact__r.Account.Name FROM Event_Participant__c WHERE Id =: triggeredParticipant.Id];
        System.assertEquals(contactToInsert.Id, participantAfterFlow.get(0).Contact__c);
        System.assertEquals(company,  participantAfterFlow.get(0).Contact__r.Account.Name);
    }

    @isTest
    public static void handleBeforeInsert_ContactExists_AppropriateAccountExists_Test()
    {
        //Given
        EventParticipantTriggerHelper helper = new EventParticipantTriggerHelper();
        String contactEmail = 'testemail@gmail.com';
        String company = 'Test Company';
        Account accountToInsert = new Account(Name = company);
        insert accountToInsert;
        Contact contactToInsert = new Contact(Email = contactEmail, LastName = 'Test Last Name', AccountId = accountToInsert.Id);
        insert contactToInsert;
        Argyle_Group_Event__c eventToInsert = new Argyle_Group_Event__c(ON24_Event_Id__c = 'Event Id');
        insert eventToInsert;
        
        Event_Participant__c triggeredParticipant = new Event_Participant__c(Zapier_Email__c = contactEmail, 
                                                                             Zapier_Company__c = company,
                                                                             ON24_Registrant_Id__c = 'registrant ID', 
                                                                             Argyle_Group_Event__c = eventToInsert.Id,
                                                                             Zapier_integration_flag__c = true);

        //When
        insert triggeredParticipant; 

        //Then
        List<Event_Participant__c> participantAfterFlow = [SELECT Contact__c, Contact__r.AccountId FROM Event_Participant__c WHERE Id =: triggeredParticipant.Id];
        List<Account> allAccounts = [SELECT Id FROM Account];
        System.assertEquals(contactToInsert.Id, participantAfterFlow.get(0).Contact__c);
        System.assertEquals(accountToInsert.Id,  participantAfterFlow.get(0).Contact__r.AccountId);
        System.assertEquals(1, allAccounts.size());
    }

    @isTest
    public static void handleBeforeInsert_ContactExists_DifferentAccountExists_Test()
    {
        //Given
        EventParticipantTriggerHelper helper = new EventParticipantTriggerHelper();
        String contactEmail = 'testemail@gmail.com';
        String company = 'Test Company';
        Account accountToInsert = new Account(Name = company);
        insert accountToInsert;
        Contact contactToInsert = new Contact(Email = contactEmail, LastName = 'Test Last Name');
        insert contactToInsert;
        Argyle_Group_Event__c eventToInsert = new Argyle_Group_Event__c(ON24_Event_Id__c = 'Event Id');
        insert eventToInsert;
        
        Event_Participant__c triggeredParticipant = new Event_Participant__c(Zapier_Email__c = contactEmail, 
                                                                             Zapier_Company__c = company,
                                                                             ON24_Registrant_Id__c = 'registrant ID', 
                                                                             Argyle_Group_Event__c = eventToInsert.Id,
                                                                             Zapier_integration_flag__c = true);

        //When
        insert triggeredParticipant; 

        //Then
        List<Event_Participant__c> participantAfterFlow = [SELECT Contact__c, Contact__r.AccountId FROM Event_Participant__c WHERE Id =: triggeredParticipant.Id];
        List<Account> allAccounts = [SELECT Id FROM Account];
        System.assertEquals(contactToInsert.Id, participantAfterFlow.get(0).Contact__c);
        System.assertEquals(accountToInsert.Id,  participantAfterFlow.get(0).Contact__r.AccountId);
        System.assertEquals(1, allAccounts.size());
    }

    @isTest
    public static void handleBeforeInsert_OnlyAccountExists_Test()
    {
        //Given
        EventParticipantTriggerHelper helper = new EventParticipantTriggerHelper();
        String contactEmail = 'testemail@gmail.com';
        String contactLastName = 'Test Last Name';
        String company = 'Test Company';
        Account accountToInsert = new Account(Name = company);
        insert accountToInsert;
        Argyle_Group_Event__c eventToInsert = new Argyle_Group_Event__c(ON24_Event_Id__c = 'Event Id');
        insert eventToInsert;
        
        Event_Participant__c triggeredParticipant = new Event_Participant__c(Zapier_Email__c = contactEmail, 
                                                                             Zapier_Company__c = company,
                                                                             Zapier_Last_Name__c = contactLastName,
                                                                             ON24_Registrant_Id__c = 'registrant ID', 
                                                                             Argyle_Group_Event__c = eventToInsert.Id,
                                                                             Zapier_integration_flag__c = true);

        //When
        insert triggeredParticipant; 

        //Then
        List<Event_Participant__c> participantAfterFlow = [SELECT Contact__r.Email, Contact__r.LastName, Contact__r.AccountId FROM Event_Participant__c WHERE Id =: triggeredParticipant.Id];
        List<Contact> allContacts = [SELECT Id FROM Contact];
        System.assertEquals(contactEmail, participantAfterFlow.get(0).Contact__r.Email);
        System.assertEquals(contactLastName, participantAfterFlow.get(0).Contact__r.LastName);
        System.assertEquals(accountToInsert.Id,  participantAfterFlow.get(0).Contact__r.AccountId);
        System.assertEquals(1, allContacts.size());
    }

    @isTest
    public static void handleBeforeInsert_NoRecordsMatch_Test()
    {
        //Given
        EventParticipantTriggerHelper helper = new EventParticipantTriggerHelper();
        String contactEmail = 'testemail@gmail.com';
        String contactLastName = 'Test Last Name';
        String company = 'Test Company';
        Argyle_Group_Event__c eventToInsert = new Argyle_Group_Event__c(ON24_Event_Id__c = 'Event Id');
        insert eventToInsert;
        
        Event_Participant__c triggeredParticipant = new Event_Participant__c(Zapier_Email__c = contactEmail, 
                                                                             Zapier_Company__c = company,
                                                                             Zapier_Last_Name__c = contactLastName,
                                                                             ON24_Registrant_Id__c = 'registrant ID', 
                                                                             Argyle_Group_Event__c = eventToInsert.Id,
                                                                             Zapier_integration_flag__c = true);

        //When
        insert triggeredParticipant; 

        //Then
        List<Event_Participant__c> participantAfterFlow = [SELECT Contact__r.Email, Contact__r.LastName, Contact__r.Account.Name FROM Event_Participant__c WHERE Id =: triggeredParticipant.Id];
        List<Contact> allContacts = [SELECT Id FROM Contact];
        List<Account> allAccounts = [SELECT Id FROM Account];
        System.assertEquals(contactEmail, participantAfterFlow.get(0).Contact__r.Email);
        System.assertEquals(contactLastName, participantAfterFlow.get(0).Contact__r.LastName);
        System.assertEquals(company, participantAfterFlow.get(0).Contact__r.Account.Name);
        System.assertEquals(1, allContacts.size());
        System.assertEquals(1, allAccounts.size());
    }

    @isTest
    public static void handleBeforeInsert_participantFromActOn_Test()
    {
        //Given
        EventParticipantTriggerHelper helper = new EventParticipantTriggerHelper();
        Argyle_Group_Event__c eventToInsert = new Argyle_Group_Event__c(ON24_Event_Id__c = 'Event Id');
        insert eventToInsert;
        Lead firstLead = new Lead(Email = 'testemail@gmail.com', LastName = 'Last Name', Status = 'New', Company = 'Test Company');
        Lead secondLead = new Lead(Email = 'testemail@gmail.com', LastName = 'Last Name', Status = 'New', Company = 'Test Company');
        insert new List<Lead>{firstLead, secondLead};
        Event_Participant__c firstParticipant = new Event_Participant__c(Lead__c = firstLead.Id, Argyle_Group_event__c = eventToInsert.Id, ON24_Registrant_Id__c = 'registrant id 1');
        Event_Participant__c secondParticipant = new Event_Participant__c(Lead__c = secondLead.Id, Argyle_Group_Event__c = eventToInsert.Id, ON24_Registrant_Id__c = 'registrant id 2');

        //When
        insert new List<Event_Participant__c>{firstParticipant, secondParticipant};

        //Then
        Map<Id, Event_Participant__c> participantsAfterTrigger = new Map<Id, Event_Participant__c>([SELECT Contact__c
                                                                                                    FROM Event_Participant__c
                                                                                                    WHERE Id IN: new Set<Id>{firstParticipant.Id, secondParticipant.Id}]);
        System.assertNotEquals(participantsAfterTrigger.get(firstParticipant.Id).Contact__c, null);
        System.assertNotEquals(participantsAfterTrigger.get(secondParticipant.Id).Contact__c, null);
    }

    @isTest
    public static void handleBeforeInsert_participantFromActOnDuplicatedAccount_Test()
    {
        //Given
        EventParticipantTriggerHelper helper = new EventParticipantTriggerHelper();
        String leadEmail = 'testemail@gmail.com';
        String company = 'Test Company';
        Account accToInsert = new Account(Name = company);
        insert accToInsert;
        Lead leadToInsert = new Lead(Email = leadEmail, LastName = 'Test Last Name', Company = company);
        insert leadToInsert;
        Argyle_Group_Event__c eventToInsert = new Argyle_Group_Event__c(ON24_Event_Id__c = 'Event Id');
        insert eventToInsert;
        
        Event_Participant__c triggeredParticipant = new Event_Participant__c(Zapier_Email__c = leadEmail, 
                                                                             Lead__c = leadToInsert.Id, 
                                                                             Argyle_Group_Event__c = eventToInsert.Id);

        //When
        insert triggeredParticipant; 

        //Then
        List<Event_Participant__c> participantAfterFlow = [SELECT Contact__c, Contact__r.Account.Name FROM Event_Participant__c WHERE Id =: triggeredParticipant.Id];
        List<Account> allAccounts = [SELECT Name FROM Account];
        System.assertEquals(1, allAccounts.size());
        System.assertEquals(company,  participantAfterFlow.get(0).Contact__r.Account.Name);
    }
    
   /* 
    @isTest
    public static void preventEngagementHubDuplicates_createSingleEngagementParticipant_Test()
    {
        //Given
        EventParticipantTriggerHelper helper = new EventParticipantTriggerHelper();
        Argyle_Group_Event__c eventToInsert = new Argyle_Group_Event__c(ON24_Event_Id__c = 'Event Id');
        insert eventToInsert;
        
        List<Event_Participant__c> triggeredParticipant = createEventParticipants(1, eventToInsert.Id, true, false);
        
        //When
        insert triggeredParticipant;
        
        //Then
        List<Participant_ON24_Registrant_Id__c> on24RegistrantIds = [SELECT Id, Name, ON24_Registrant_Id__c, Event_Participant__c FROM Participant_ON24_Registrant_Id__c];
        System.assertEquals(1, on24RegistrantIds.size(), ' One related Participant ON24 Registrant Id record should be created');
        System.assertEquals(triggeredParticipant.get(0).Id, on24RegistrantIds.get(0).Event_Participant__c, 'Participant ON24 Registrant Id record should be related to the triggered participant');
        System.assertEquals(triggeredParticipant.get(0).ON24_Registrant_Id__c, on24RegistrantIds.get(0).ON24_Registrant_Id__c, 'ON24 Registrant Ids should be the same');
    }
    
    @isTest
    public static void preventEngagementHubDuplicates_createFewEngagementParticipants_Test()
    {
        //Given
        EventParticipantTriggerHelper helper = new EventParticipantTriggerHelper();
        Argyle_Group_Event__c eventToInsert = new Argyle_Group_Event__c(ON24_Event_Id__c = 'Event Id');
        insert eventToInsert;
        
        List<Event_Participant__c> triggeredParticipants = createEventParticipants(3, eventToInsert.Id, true, false);
        
        //When
        insert triggeredParticipants;
        
        //Then
        List<Event_Participant__c> insertedParticipants = [SELECT Id FROM Event_Participant__c];
        List<Participant_ON24_Registrant_Id__c> on24RegistrantIds = [SELECT Id, Name, ON24_Registrant_Id__c, Event_Participant__c FROM Participant_ON24_Registrant_Id__c];
        System.assertEquals(1, insertedParticipants.size(), 'Only one Event Participant record should be created');
        System.assertEquals(3, on24RegistrantIds.size(), '3 related Participant ON24 Registrant Id record should be created');         
        for(Participant_ON24_Registrant_Id__c insertedRelatedON24Id : on24RegistrantIds)
        {
            System.assertEquals(insertedParticipants.get(0).Id, insertedRelatedON24Id.Event_Participant__c, 'Participant ON24 Registrant Id record should be related to the triggered participant');
        } 
    }
    
    @isTest
    public static void preventEngagementHubDuplicates_createFewEngagementParticipantsWhileEventParticipantExists_Test()
    {
        //Given
        EventParticipantTriggerHelper helper = new EventParticipantTriggerHelper();
        Argyle_Group_Event__c eventToInsert = new Argyle_Group_Event__c(ON24_Event_Id__c = 'Event Id');
        insert eventToInsert; 
        List<Event_Participant__c> existingParticipant = createEventParticipants(1, eventToInsert.Id, true, false);
        insert existingParticipant;
        
        List<Event_Participant__c> triggeredParticipants = createEventParticipants(3, eventToInsert.Id, true, false);
        
        //When
        insert triggeredParticipants;
        
        //Then
        List<Event_Participant__c> insertedParticipants = [SELECT Id FROM Event_Participant__c];
        List<Participant_ON24_Registrant_Id__c> on24RegistrantIds = [SELECT Id, Name, ON24_Registrant_Id__c, Event_Participant__c FROM Participant_ON24_Registrant_Id__c];
        System.assertEquals(existingParticipant.get(0).Id, insertedParticipants.get(0).Id, 'No additional/duplicate Participants should be created and the existing one should be the main');
        System.assertEquals(1, insertedParticipants.size(), 'No additional/duplicate Participants should be created');
        
        System.assertEquals(1, insertedParticipants.size(), 'Only one Event Participant record should be created');
        System.assertEquals(4, on24RegistrantIds.size(), '3 related Participant ON24 Registrant Id record should be created and 1 for existing one');         
        for(Participant_ON24_Registrant_Id__c insertedRelatedON24Id : on24RegistrantIds)
        {
            System.assertEquals(insertedParticipants.get(0).Id, insertedRelatedON24Id.Event_Participant__c, 'Participant ON24 Registrant Id record should be related to the triggered participant');
        } 
    }
    
    @isTest
    public static void preventEngagementHubDuplicates_createFewDifferentParticipantsWhileEventParticipantExists_Test()
    {
        //Given
        EventParticipantTriggerHelper helper = new EventParticipantTriggerHelper();
        List<Argyle_Group_Event__c> events = new List<Argyle_Group_Event__c>();
        events.add(new Argyle_Group_Event__c(ON24_Event_Id__c = 'Eng Hub Event Id'));
        events.add(new Argyle_Group_Event__c(ON24_Event_Id__c = 'Webinar Event Id'));
        insert events;
        
        List<Event_Participant__c> existingParticipant = createEventParticipants(1, events.get(0).Id, true, false);
        insert existingParticipant;
        
        List<Event_Participant__c> triggeredParticipants = createEventParticipants(1, events.get(0).Id, true, false);
        triggeredParticipants.addAll(createEventParticipants(1, events.get(0).Id, true, true)); 
        triggeredParticipants.addAll(createEventParticipants(1, events.get(1).Id, false, true));
        
        //When
        insert triggeredParticipants;
        
        //Then
        List<Event_Participant__c> insertedParticipants = [SELECT Id FROM Event_Participant__c];
        List<Participant_ON24_Registrant_Id__c> on24RegistrantIds = [SELECT Id, Name, ON24_Registrant_Id__c, Event_Participant__c FROM Participant_ON24_Registrant_Id__c];
        System.assertEquals(3, insertedParticipants.size(), 'One Webinar registrant, and one Engagement Hub registrant should be created and the existing one should be the main'); 
        System.assertEquals(3, on24RegistrantIds.size());     
    }
    
    
    
    
    public static List<Event_Participant__c> createEventParticipants(Integer count, Id argyleGroupEventId, Boolean isEngagementHubParticipant, Boolean isDifferentParticipantInfo)
    {
        List<Event_Participant__c> listToReturn = new List<Event_Participant__c>();
        
        for(Integer i = 0; i < count; i++)
        {
            String randomString = generateRandomString(4);
            Event_Participant__c triggeredParticipant = new Event_Participant__c(); 
            triggeredParticipant.Argyle_Group_Event__c = argyleGroupEventId; 
            triggeredParticipant.ON24_Registrant_Id__c = '1111' + Math.random() * (i + 1);
            triggeredParticipant.Engagement_Hub_Participant__c = isEngagementHubParticipant;
            triggeredParticipant.Zapier_Company__c = isDifferentParticipantInfo ? 'TESTCompany' + randomString : 'TESTCompany';
            triggeredParticipant.Zapier_Email__c = isDifferentParticipantInfo ? 'test@gmail.com' + randomString : 'test@gmail.com';
            triggeredParticipant.Zapier_First_Name__c = isDifferentParticipantInfo ? 'Test First Name' + randomString : 'Test First Name';
            triggeredParticipant.Zapier_Last_Name__c = isDifferentParticipantInfo ? 'Test Last Name' + randomString : 'Test Last Name'; 
            triggeredParticipant.Registration_Date__c = Date.today(); 
            listToReturn.add(triggeredParticipant);
        }
        
        return listToReturn;
    }
    
    public static String generateRandomString(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr;
    }
*/

}