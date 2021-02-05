@isTest
public without sharing class AccountTriggerHelperTest 
{
    @isTest
    public static void hanldeBeforeInsert_unescapeTest() 
    {
        //Given
        sfab_FabricatedSObject generatedAccount = generateSObject(new Map<SObjectField, Object>{Account.Name => 'AT&amp;T'},
                                                                        Account.class);
        Account newAccount = (Account) generatedAccount.toSObject();

        //When
        insert newAccount;

        //Then
        List<Account> accAfterInsetion = [SELECT Name FROM Account WHERE Id =: newAccount.id];
        System.assertEquals('AT&T', accAfterInsetion.get(0).Name);
    }
    
    private static sfab_FabricatedSObject generateSObject(Map<SObjectField, Object> fields, System.Type objectToGenerate)
    {
        sfab_FabricatedSObject fabricatedObject = new sfab_FabricatedSObject(objectToGenerate);
        for(SObjectField field : fields.keySet())
        {
            fabricatedObject.setField(field, fields.get(field));
        }
        return fabricatedObject;
    }

}