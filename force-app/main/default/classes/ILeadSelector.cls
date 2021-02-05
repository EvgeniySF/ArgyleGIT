public interface ILeadSelector 
{
    Map<Id, Lead> getLeadsByEmail(List<String> leadEmails);
    Map<Id, Lead> getLeadsByIds(List<Id> leadIds);
}