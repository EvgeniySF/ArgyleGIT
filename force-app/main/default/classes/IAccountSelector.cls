public interface IAccountSelector 
{
    Map<Id, Account> getAccountsByName(List<String> accountNames);
}