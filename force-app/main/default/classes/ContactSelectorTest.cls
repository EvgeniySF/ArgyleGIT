@isTest
public with sharing class ContactSelectorTest 
{
    @isTest
    public static void getContactsByEmailTest()
    {
        //Given
        IContactSelector selector = new ContactSelector();
        String contactEmail = 'testemail@gmail.com';
        Contact contactToInsert = new Contact(Email = contactEmail, LastName = 'Last Name');
        insert contactToInsert;

        //When
        Map<Id, Contact> returnedContacts = selector.getContactsByEmail(new List<String>{contactEmail});

        //Then
        System.assertEquals(1, returnedContacts.values().size());
        System.assertEquals(contactEmail, returnedContacts.values().get(0).Email);
    }
}