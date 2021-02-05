public interface IContactSelector 
{
    Map<Id, Contact> getContactsByEmail(List<String> contactEmails);
}