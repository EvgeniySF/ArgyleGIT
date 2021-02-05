public without sharing class ContactSelector implements IContactSelector
{
    public Map<Id, Contact> getContactsByEmail(List<String> contactEmails)
    {
        Map<Id, Contact> contactsToReturn = new Map<Id, Contact>([SELECT Email, Alternate_Email__c, AccountId FROM Contact WHERE Email IN: contactEmails OR Alternate_Email__c IN: contactEmails]);
        return contactsToReturn;
    }
}