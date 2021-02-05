@isTest
public without sharing class AccountSelectorTest 
{
    @isTest
    public static void getAccountsByNameTest()
    {
        //Given
        IAccountSelector selector = new AccountSelector();
        String accountName = 'Acc name';
        Account accountToInsert = new Account(Name = accountName);
        insert accountToInsert;

        //When
        Map<Id, Account> returnedAccounts = selector.getAccountsByName(new List<String>{accountName});

        //Then
        System.assertEquals(1, returnedAccounts.values().size());
        System.assertEquals(accountName, returnedAccounts.values().get(0).Name);
    }
}