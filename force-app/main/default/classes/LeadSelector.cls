public without sharing class LeadSelector implements ILeadSelector
{
    public Map<Id, Lead> getLeadsByEmail(List<String> leadEmails)
    {
        Map<Id,Lead> leadsToReturn = new Map<Id,Lead>([SELECT IsConverted, Email FROM Lead WHERE Email IN: leadEmails]);
        return leadsToReturn;
    }

    public Map<Id, Lead> getLeadsByIds(List<Id> leadIds)
    {
        Map<Id,Lead> leadsToReturn = new Map<Id,Lead>([SELECT IsConverted, Company FROM Lead WHERE Id IN: leadIds]);
        return leadsToReturn;
    }
}