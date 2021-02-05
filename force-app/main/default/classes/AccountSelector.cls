public without sharing class AccountSelector implements IAccountSelector
{
    public Map<Id, Account> getAccountsByName(List<String> accountNames)
    {
        Map<Id, Account> accountsToReturn = new Map<Id, Account>([SELECT Name FROM Account WHERE Name IN: accountNames]);
        return accountsToReturn;
    }
}