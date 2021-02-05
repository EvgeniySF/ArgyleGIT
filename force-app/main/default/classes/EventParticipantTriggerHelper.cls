public without sharing class EventParticipantTriggerHelper 
{
    private @TestVisible IAccountSelector accountsSelector = new AccountSelector();
    private @TestVisible ILeadSelector leadsSelector = new LeadSelector();
    private @TestVisible IContactSelector contactsSelector = new ContactSelector();
    private @TestVisible IEventParticipantSelector eventParticipantSelector = new EventParticipantSelector();
    
    private static LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
    
    private @TestVisible static Map <Id, Lead> appropriateLeadsByEmail;
    private @TestVisible static Map <Id, Lead> appropriateLeadsById;
    private @TestVisible static Map <Id, Contact> appropriateContacts;
    private @TestVisible static Map <Id, Account> appropriateAccounts;
    private @TestVisible static AccountWithDuplicatesListWrapper similarAccounts;
    
    private static fflib_ISObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<Schema.SObjectType>{
            Account.SObjectType,
                Contact.SObjectType
                }
    );
    
    /*  public void createRelatedON24IdRecords(List<Event_Participant__c> newParticipants)
{
List<Participant_ON24_Registrant_Id__c> on24RegistrantIds = new List<Participant_ON24_Registrant_Id__c>();

for(Event_Participant__c participant : newParticipants)
{ 
if(!String.IsBlank(participant.ON24_Related_Ids__c))
{ 
List<String> allRelatedIds = participant.ON24_Related_Ids__c.split(','); 
for(String on24Id : allRelatedIds)
{ 
Participant_ON24_Registrant_Id__c participantOn24Id = new Participant_ON24_Registrant_Id__c();
participantOn24Id.Event_Participant__c = participant.Id;
participantOn24Id.ON24_Registrant_Id__c = on24Id;
participantOn24Id.Name = on24Id;
on24RegistrantIds.add(participantOn24Id); 
}
} 
}
insert on24RegistrantIds;
}

public void deleteEngagementHubDuplicates(List<Event_Participant__c> newParticipants)
{
Set<Id> IdsToDelete = new Set<Id>();

for(Event_Participant__c participant : newParticipants) 
{
if(!participant.Processed_with_duplicate_prevention__c)
{ 
IdsToDelete.add(participant.Id);
}
}
List<Event_Participant__c> participantsToDelete = eventParticipantSelector.getParticipantsToDelete(IdsToDelete);

delete [SELECT Id FROM Event_Participant__c WHERE Id IN : IdsToDelete];
}


public void preventEngagementHubDuplicates(List<Event_Participant__c> newParticipants)
{
List<Event_Participant__c> webinarParticipants = new List<Event_Participant__c>();
List<Event_Participant__c> engagementHubParticipantsWithoutDuplicates = new List<Event_Participant__c>();
List<Event_Participant__c> engagementHubParticipants = new List<Event_Participant__c>();
Set<Id> argyleGroupEventIds = new Set<Id>();

for(Event_Participant__c participant : newParticipants)
{
if(participant.Engagement_Hub_Participant__c) 
{
engagementHubParticipants.add(participant);
argyleGroupEventIds.add(participant.Argyle_Group_Event__c);
}
else
{
webinarParticipants.add(participant);
}
} 

List<Event_Participant__c> existingParticipants = eventParticipantSelector.getExistingParticipantsByEvent(argyleGroupEventIds);

if(existingParticipants.size() > 0) 
{ 
Map<Id, List<Event_Participant__c>> existingParticipantsToArgyleGroupEvent = getParticipantsToArgyleGroupEventMap(existingParticipants, argyleGroupEventIds);
Map<Id, List<Event_Participant__c>> receivedParticipantsToArgyleGroupEvent = getParticipantsToArgyleGroupEventMap(engagementHubParticipants, argyleGroupEventIds);
Map<Id, List<String>> eventParticipantIdToON24Ids = new Map<Id, List<String>>(); 
Set<String> setOfAlreadyAdded = new Set<String>();

for(Id argyleGroupEventId : argyleGroupEventIds)
{ 
for(Event_Participant__c receivedParticipant : receivedParticipantsToArgyleGroupEvent.get(argyleGroupEventId)) 
{ 
List<String> on24IdsForParticularParticipant = new List<String>();
Boolean idIsAlreadyPopulated = false; 
Boolean duplicateIsNotFound = false;
Id existingParticipantId; 
for(Event_Participant__c existingParticipant : existingParticipantsToArgyleGroupEvent.get(argyleGroupEventId))                
{  
if(isTheSameParticipant(existingParticipant, receivedParticipant))
{  
if(!idIsAlreadyPopulated)
{  
idIsAlreadyPopulated = true;
existingParticipantId = existingParticipant.Id; 
}
on24IdsForParticularParticipant.add(receivedParticipant.ON24_Registrant_Id__c); 
duplicateIsNotFound = false;
}
else
{ 
if(!setOfAlreadyAdded.contains(receivedParticipant.ON24_Registrant_Id__c))
{
duplicateIsNotFound = true; 
}
setOfAlreadyAdded.add(receivedParticipant.ON24_Registrant_Id__c); 
}
}
if(duplicateIsNotFound)
{ 
engagementHubParticipantsWithoutDuplicates.add(receivedParticipant); 
}
if(on24IdsForParticularParticipant.size() > 0)
{

if( eventParticipantIdToON24Ids.containsKey(existingParticipantId))
{
eventParticipantIdToON24Ids.get(existingParticipantId).addAll(on24IdsForParticularParticipant);
}
else
{
eventParticipantIdToON24Ids.put(existingParticipantId, on24IdsForParticularParticipant); 
}  
} 
}
} 

List<Event_Participant__c> newRecordsToProcess = new List<Event_Participant__c>(); 

if(engagementHubParticipantsWithoutDuplicates.size() > 0)
{  
List<Event_Participant__c> sortedParticipants = getSortedParticipants(engagementHubParticipantsWithoutDuplicates);
newRecordsToProcess.addAll(sortedParticipants); 
}
if(webinarParticipants.size() > 0)
{ 
newRecordsToProcess.addAll(webinarParticipants);
}   
if(newRecordsToProcess.size() > 0)
{ 
handleBeforeInsert(newRecordsToProcess);
} 


List<Participant_ON24_Registrant_Id__c> on24RegistrantIds = new List<Participant_ON24_Registrant_Id__c>();

for(Id participantId : eventParticipantIdToON24Ids.keySet())
{
for(String on24Id : eventParticipantIdToON24Ids.get(participantId))
{
Participant_ON24_Registrant_Id__c participantOn24Id = new Participant_ON24_Registrant_Id__c();
participantOn24Id.Event_Participant__c = participantId;
participantOn24Id.ON24_Registrant_Id__c = on24Id;
participantOn24Id.Name = on24Id;
on24RegistrantIds.add(participantOn24Id);
}
} 

insert on24RegistrantIds;
}
else
{ 
List<Event_Participant__c> newRecordsToProcess = new List<Event_Participant__c>();  
List<Event_Participant__c> sortedParticipants = getSortedParticipants(engagementHubParticipants);
newRecordsToProcess.addAll(sortedParticipants);
newRecordsToProcess.addAll(webinarParticipants);  
handleBeforeInsert(newRecordsToProcess);
} 
} 

public List<Event_Participant__c> getSortedParticipants(List<Event_Participant__c> participantsToSort)
{  
List<Event_Participant__c> listToReturn = new List<Event_Participant__c>(); 
List<Integer> indexes = new List<Integer>();

for(Integer i = 0; i < participantsToSort.size(); i++)
{   
if(!indexes.contains(i)){
List<Event_Participant__c> sameReceivedParticipants = new List<Event_Participant__c>();
for(Integer j = 0; j < participantsToSort.size(); j++)
{  
if(!indexes.contains(j) && isTheSameParticipant(participantsToSort.get(i), participantsToSort.get(j)) && participantsToSort.get(i).ON24_Registrant_Id__c != participantsToSort.get(j).ON24_Registrant_Id__c)
{  
sameReceivedParticipants.add(participantsToSort.get(j));
indexes.add(j);
}
}
if(sameReceivedParticipants.size() == 0 )
{ 
participantsToSort.get(i).ON24_Related_Ids__c = participantsToSort.get(i).ON24_Registrant_Id__c;
listToReturn.add(participantsToSort.get(i));
}
else if(sameReceivedParticipants.size() > 0){ 
List<String> on24Ids = new List<String>();
on24Ids.add(participantsToSort.get(i).ON24_Registrant_Id__c);
for(Event_Participant__c participant : sameReceivedParticipants)
{ 
on24Ids.add(participant.ON24_Registrant_Id__c);
}
String allON24Ids = String.join(on24Ids, ',');
participantsToSort.get(i).ON24_Related_Ids__c = allON24Ids;
listToReturn.add(participantsToSort.get(i));
} 
}
}

return listToReturn;
}

public Boolean isTheSameParticipant(Event_Participant__c existingParticipantToCompare, Event_Participant__c receivedParticipantToCompare){
if(existingParticipantToCompare.Zapier_First_Name__c == receivedParticipantToCompare.Zapier_First_Name__c &&
existingParticipantToCompare.Zapier_Last_Name__c == receivedParticipantToCompare.Zapier_Last_Name__c &&
existingParticipantToCompare.Zapier_Company__c == receivedParticipantToCompare.Zapier_Company__c &&
existingParticipantToCompare.Zapier_title__c == receivedParticipantToCompare.Zapier_title__c &&
existingParticipantToCompare.Zapier_Email__c == receivedParticipantToCompare.Zapier_Email__c )
{
return true;
}
return false;
}

public Map<Id, List<Event_Participant__c>> getParticipantsToArgyleGroupEventMap(List<Event_Participant__c> existingParticipants, Set<Id> argyleGroupEventIds)
{
Map<Id, List<Event_Participant__c>> mapToReturn = new Map<Id, List<Event_Participant__c>>();
for(Id argyleGroupEventId : argyleGroupEventIds)
{
List<Event_Participant__c> tempParticipants = new List<Event_Participant__c>();
for(Event_Participant__c existingParticipant : existingParticipants)
{
if(existingParticipant.Argyle_Group_Event__c == argyleGroupEventId)
{
tempParticipants.add(existingParticipant);
}
}
mapToReturn.put(argyleGroupEventId, tempParticipants);
}
return mapToReturn;
} 


public void markAllRecordsAsProcessed(List<Event_Participant__c> newParticipants)
{
for(Event_Participant__c participant : newParticipants)
{
participant.Processed_with_duplicate_prevention__c = true;
}
}
*/
    
    public void handleBeforeInsert(List<Event_Participant__c> newParticipants)
    {
        insertParticipantsWithRelatedRecords(newParticipants);
    }
    
    private void insertParticipantsWithRelatedRecords(List<Event_Participant__c> newParticipants)
    {
        // markAllRecordsAsProcessed(newParticipants);
        List<String> companyNames = new List<String>();
        List<String> participantEmails = new List<String>();
        List<Id> leadIds = new List<Id>();
        
        fillLists(newParticipants, companyNames, participantEmails, leadIds);
        
        appropriateLeadsById = leadsSelector.getLeadsByIds(leadIds);
        
        supplementCompaniesList(appropriateLeadsById, companyNames);
        
        appropriateLeadsByEmail = leadsSelector.getLeadsByEmail(participantEmails);
        appropriateContacts = contactsSelector.getContactsByEmail(participantEmails);
        appropriateAccounts = accountsSelector.getAccountsByName(companyNames);
        similarAccounts = fillDuplicatesList(companyNames);
        system.debug('similarAccounts = ' + similarAccounts);
        
        List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
        
        List<ParticipantContactWrapper> participantWrappers = new List<ParticipantContactWrapper>();
        
        for(Event_Participant__c eventParticipant : newParticipants)
        {
            if(String.isBlank(eventParticipant.Contact__c) == true && eventParticipant.Zapier_integration_flag__c == true)
            {
                processZapierRecord(eventParticipant, participantWrappers, leadConverts);
                system.debug('zapier record');
            }
            else if(String.isBlank(eventParticipant.Contact__c) == true && String.isBlank(eventParticipant.Lead__c) == false)
            {
                processActOnRecord(eventParticipant, leadConverts);
                system.debug('act-on record');
            }
        }
        System.debug('Limits.getDmlStatements() before conversion' + Limits.getDmlStatements());
        List<Database.LeadConvertResult> conversionResults = convertLeads(leadConverts);
        System.debug('Limits.getDmlStatements() before commit work ' + Limits.getDmlStatements());
        uow.commitWork();
        System.debug('Limits.getDmlStatements() after commit work ' + Limits.getDmlStatements());
        populateParticipantsContacts(newParticipants, conversionResults);
        populateParticipantsContacts(newParticipants, participantWrappers);
    }
    
    private void processZapierRecord(Event_Participant__c eventParticipant, List<ParticipantContactWrapper> participantWrappers, List<Database.LeadConvert> leadConverts)
    {
        Lead appropriateLead = getLead(appropriateLeadsByEmail, eventParticipant.Zapier_Email__c);
        Contact appropriateContact = getContact(appropriateContacts, eventParticipant.Zapier_Email__c);  
        Account appropirateAccount = getAccount(appropriateAccounts, eventParticipant.Zapier_Company__c) == null ? similarAccounts.getAccountByCompany(eventParticipant.Zapier_Company__c) : getAccount(appropriateAccounts, eventParticipant.Zapier_Company__c);
      
        
        if(appropriateLead != null && appropriateLead.IsConverted == false)
        {
            eventParticipant.Lead__c = appropriateLead.Id;
            System.debug('appropriateLead != null && appropriateLead.IsConverted == false');
            Database.LeadConvert leadConvert = generateLeadConvert(appropriateLead);
            leadConverts.add(leadConvert);
            /*Database.LeadConvertResult convertionResult = convertLead(appropriateLead);
Id contactIdAfterConvertion = convertionResult.getContactId();
eventParticipant.Contact__c = contactIdAfterConvertion;*/
        }
        else if(appropriateContact != null)
        {
            if(appropirateAccount != null && appropriateContact.AccountId == appropirateAccount.Id)
            {
                System.debug('appropriateContact != null account matches');
                eventParticipant.Contact__c = appropriateContact.Id;
            }
            else if(appropirateAccount != null && appropriateContact.AccountId != appropirateAccount.Id)
            {
                System.debug('appropriateContact != null account does not match');
                appropriateContact.AccountId = appropirateAccount.Id;
                uow.registerDirty(appropriateContact);
                eventParticipant.Contact__c = appropriateContact.Id;
            }
            else if(appropirateAccount == null)
            {
                System.debug('appropriateContact != null account does not exist');
                Account newParticipantAccount = new Account();
                newParticipantAccount.Name = eventParticipant.Zapier_Company__c;
                uow.registerNew(newParticipantAccount);
                uow.registerDirty(appropriateContact, Contact.AccountId, newParticipantAccount);
                eventParticipant.Contact__c = appropriateContact.Id;
            }
        }
        else
        {
            ParticipantContactWrapper participantWrapper = new ParticipantContactWrapper();
            participantWrapper.participant = eventParticipant;
            if(appropirateAccount != null)
            {
                System.debug('appropirateAccount != null');
                Contact newParticipantContact = new Contact();
                newParticipantContact.LastName = eventParticipant.Zapier_Last_Name__c;
                newParticipantContact.FirstName = eventParticipant.Zapier_First_Name__c;
                newParticipantContact.Email = eventParticipant.Zapier_Email__c;
                newParticipantContact.Phone = eventParticipant.Zapier_phone__c;
                newParticipantContact.Title = eventParticipant.Zapier_title__c;
                newParticipantContact.Is_EU_Resident__c = eventParticipant.Zapier_is_EU_resident__c;
                newParticipantContact.HasOptedOutSolicitThirdParty__c = eventParticipant.Zapier_Don_t_Market_Third_Party__c;
                newParticipantContact.AccountId = appropirateAccount.Id;
                uow.registerNew(newParticipantContact);
                participantWrapper.participantContact = newParticipantContact;
            }
            else 
            {
                System.debug('last else');
                Account newParticipantAccount = new Account();
                newParticipantAccount.Name = eventParticipant.Zapier_Company__c;
                uow.registerNew(newParticipantAccount);
                Contact newParticipantContact = new Contact();
                newParticipantContact.LastName = eventParticipant.Zapier_Last_Name__c;
                newParticipantContact.FirstName = eventParticipant.Zapier_First_Name__c;
                newParticipantContact.Email = eventParticipant.Zapier_Email__c;
                newParticipantContact.Phone = eventParticipant.Zapier_phone__c;
                newParticipantContact.Title = eventParticipant.Zapier_title__c;
                newParticipantContact.Is_EU_Resident__c = eventParticipant.Zapier_is_EU_resident__c;
                newParticipantContact.HasOptedOutSolicitThirdParty__c = eventParticipant.Zapier_Don_t_Market_Third_Party__c;
                uow.registerNew(newParticipantContact, Contact.AccountId, newParticipantAccount);
                participantWrapper.participantContact = newParticipantContact;
            }
            participantWrappers.add(participantWrapper);
        }
    }
    
    private void processActOnRecord(Event_Participant__c eventParticipant, List<Database.LeadConvert> leadConverts)
    {
        Lead appropriateLead = appropriateLeadsById.get(eventParticipant.Lead__c);
        
        if(appropriateLead != null && appropriateLead.IsConverted == false)
        {
            System.debug('processActOnRecord lead is found');
            System.debug('appropriateLead.Company ' + appropriateLead.Company);
            Account similarAccount = similarAccounts.getAccountByCompany(appropriateLead.Company);
            System.debug('similarAccount ' + similarAccount);
            Database.LeadConvert leadConvert = generateLeadConvert(appropriateLead);
            if(similarAccount != null)
            {
                leadConvert.setAccountId(similarAccount.Id);
            }
            leadConverts.add(leadConvert);
        }
    }
    
    private List<Database.LeadConvertResult> convertLeads(List<Database.LeadConvert> leadConverts)
    {
        List<Database.LeadConvertResult> resultsToReturn = new List<Database.LeadConvertResult>();
        if(leadConverts.size() > 100)
        {
            List<Database.LeadConvert> leadsFirstPart = new List<Database.LeadConvert>();
            List<Database.LeadConvert> leadsSecondPart = new List<Database.LeadConvert>();
            for(Integer i = 0; i < leadConverts.size(); i++)
            {
                if(i < 100)
                {
                    leadsFirstPart.add(leadConverts.get(i));
                }
                else 
                {
                    leadsSecondPart.add(leadConverts.get(i));
                }
            }
            Database.LeadConvertResult[] leadConvertFirstResults = Database.convertLead(leadsFirstPart);
            Database.LeadConvertResult[] leadConvertSecondResults = Database.convertLead(leadsSecondPart);
            resultsToReturn.addAll(leadConvertFirstResults);
            resultsToReturn.addAll(leadConvertSecondResults);
        }
        else 
        {
            resultsToReturn = Database.convertLead(leadConverts);
        }
        return resultsToReturn;
    }
    
    private void fillLists(List<Event_Participant__c> newParticipants, List<String> companyNames, List<String> participantEmails, List<Id> leadIds)
    {
        for(Event_Participant__c eventParticipant : newParticipants)
        {
            if(String.isBlank(eventParticipant.Zapier_Company__c) == false)
            {
                companyNames.add(eventParticipant.Zapier_Company__c);
            }
            if(String.isBlank(eventParticipant.Zapier_Email__c) == false)
            {
                participantEmails.add(eventParticipant.Zapier_Email__c);
            }
            if(String.isBlank(eventParticipant.Lead__c) == false)
            {
                leadIds.add(eventParticipant.Lead__c);
            }
        }
    }
    
    private void supplementCompaniesList(Map <Id, Lead> leadsMap, List<String> companyNames)
    {
        for(Lead lead : leadsMap.values())
        {
            companyNames.add(lead.Company);
        }
    }
    
    private Lead getLead(Map <Id, Lead> appropriateLeads, String participantEmail)
    {
        Lead leadToReturn = null;
        for(Lead appropriateLead : appropriateLeads.values())
        {
            if(appropriateLead.Email == participantEmail)
            {
                leadToReturn = appropriateLead;
                break;
            }
        }
        return leadToReturn;
    }
    
    private Contact getContact(Map <Id, Contact> appropriateContacts, String participantEmail)
    {
        Contact contactToReturn = null;
        for(Contact appropriateContact : appropriateContacts.values())
        {
            if(appropriateContact.Email == participantEmail || appropriateContact.Alternate_Email__c == participantEmail)
            {
                contactToReturn = appropriateContact;
                break;
            }
        }
        return contactToReturn;
    }
    
    private Account getAccount(Map <Id, Account> appropriateAccounts, String participantCompany)
    {
        Account accountToReturn = null;
        for(Account appropriateAccount : appropriateAccounts.values())
        {
            if(appropriateAccount.Name == participantCompany)
            {
                accountToReturn = appropriateAccount;
                break;
            }
        }
        system.debug('accountToReturn = ' + accountToReturn);
        return accountToReturn;
    }
    
    private Database.LeadConvert generateLeadConvert(Lead leadToConvert)
    {
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(leadToConvert.Id);
        lc.setConvertedStatus(convertStatus.MasterLabel);
        lc.setDoNotCreateOpportunity(true);
        return lc;
    }
    
    private void populateParticipantsContacts(List<Event_Participant__c> newParticipants, List<ParticipantContactWrapper> participantWrappers)
    {
        for(Event_Participant__c participant : newParticipants)
        {
            for(ParticipantContactWrapper wrapper : participantWrappers)
            {
                if(participant.ON24_Registrant_Id__c == wrapper.participant.ON24_Registrant_Id__c)
                {
                    participant.Contact__c = wrapper.participantContact.Id;
                    break;
                }
            }
        }
    }
    
    private void populateParticipantsContacts(List<Event_Participant__c> newParticipants, List<Database.LeadConvertResult> conversionResults)
    {
        for(Event_Participant__c participant : newParticipants)
        {
            System.debug('participant.Lead__c ' + participant.Lead__c);
            for(Database.LeadConvertResult result : conversionResults)
            {
                System.debug('result.getLeadId() ' + result.getLeadId());
                if(participant.Lead__c == result.getLeadId())
                {
                    participant.Contact__c = result.getContactId();
                    participant.Lead__c = null;
                }
            }
        } 
    }
    
    public List<AccountWithDuplicatesWrapper> getAccountDuplicate(List<String> companies)
    {
        List<AccountWithDuplicatesWrapper> accountsWithDuplicates = new List<AccountWithDuplicatesWrapper>();
        List<Account> acctList = new List<Account>();
        for(String company : companies)
        {
            AccountWithDuplicatesWrapper accountWrapper = new AccountWithDuplicatesWrapper();
            Account acc = new Account(Name = company);
            acctList.add(acc);
            accountWrapper.accountToCreate = acc;
            accountWrapper.company = company;
            accountsWithDuplicates.add(accountWrapper);
        }
        try 
        {
            Datacloud.FindDuplicatesResult[] results = Datacloud.FindDuplicates.findDuplicates(acctList);
            for(Integer i = 0; i < accountsWithDuplicates.size(); i++)
            {
                Map <Double, Account> duplicatesWithConfidence = new Map <Double, Account>();
                Datacloud.FindDuplicatesResult findDupeResult = results[i]; 
                for (Datacloud.DuplicateResult dupeResult : findDupeResult.getDuplicateResults()) 
                { 
                    for (Datacloud.MatchResult matchResult : dupeResult.getMatchResults()) 
                    { 
                        for (Datacloud.MatchRecord matchRecord : matchResult.getMatchRecords()) 
                        { 
                            
                            duplicatesWithConfidence.put(matchRecord.getMatchConfidence(), (Account) matchRecord.getRecord());
                        }
                    }
                }
                if(duplicatesWithConfidence.keySet().isEmpty() == false)
                {
                    List<Double> confidenceList = new List<Double>(duplicatesWithConfidence.keySet());
                    confidenceList.sort();
                    Double bestConfidence = confidenceList.get(confidenceList.size() - 1);
                    accountsWithDuplicates.get(i).existingAccount = duplicatesWithConfidence.get(bestConfidence);
                }
            }
        }
        catch(Exception ex)
        {
            System.debug('accountToReturn catch' + accountsWithDuplicates);
            System.debug(ex.getMessage());
            return accountsWithDuplicates;
        }
        System.debug('accountToReturn ' + accountsWithDuplicates);
        return accountsWithDuplicates;
    }
    
    private AccountWithDuplicatesListWrapper fillDuplicatesList(List<String> allCompanies)
    {
        AccountWithDuplicatesListWrapper wrapperToReturn = new AccountWithDuplicatesListWrapper();
        List<String> tempList = new List<String>();
        for(Integer i = 0; i < allCompanies.size(); i++)
        {
            if(Math.mod(i, 50) != 0 || i == 0)
            {
                tempList.add(allCompanies.get(i));
            }
            else 
            {
                wrapperToReturn.wrappers.addAll(getAccountDuplicate(tempList));
                tempList.clear();
            }
        }
        wrapperToReturn.wrappers.addAll(getAccountDuplicate(tempList));
        return wrapperToReturn;
    }
    
    private class ParticipantContactWrapper
    {
        Event_Participant__c participant;
        Contact participantContact;
    }
    
    private class AccountWithDuplicatesWrapper
    {
        String company;
        Account accountToCreate;
        Account existingAccount;
    }  
    
    private class AccountWithDuplicatesListWrapper
    {
        List<AccountWithDuplicatesWrapper> wrappers = new List<AccountWithDuplicatesWrapper>();
        
        private Account getAccountByCompany(String company)
        {
            Account accountToReturn = null;
            for(AccountWithDuplicatesWrapper wrapper : this.wrappers)
            {
                if(wrapper.company == company && wrapper.existingAccount != null)
                {
                    accountToReturn = wrapper.existingAccount;
                }
            }
            return accountToReturn;
        }
    } 
}