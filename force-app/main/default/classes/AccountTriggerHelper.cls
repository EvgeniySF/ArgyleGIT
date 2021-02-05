public without sharing class AccountTriggerHelper 
{
    @TestVisible
    private static  IArgyleGroupEventSelector eventSelector = new ArgyleGroupEventSelector();

    private static Set<ID> aIds	= new Set<ID>();
	private static List<String>	apIds = new List<String>();
	private static List<ActionPlan__c> deletePermantently_apIds = new List<ActionPlan__c>();

    public void hanldeBeforeInsert(List<Account> newAccounts)
    {
        unescapeAccountName(newAccounts);
    }

    public void handleBeforeDelete(List<Account> oldAccounts)
    {
        for(Account oldAccount : oldAccounts)
		{
        	aIds.add(oldAccount.Id);
   		}
		/* GET Action Plans to delete from recycle bin */
   		deletePermantently_apIds = [SELECT Id, Name, LastModifiedDate FROM ActionPlan__c WHERE Account__c IN: aIds and isDeleted = true ALL ROWS];
   		
   		if (deletePermantently_apIds.size() >0 )
		{   		
			Database.emptyRecycleBin(deletePermantently_apIds);
   		}
	
		//Get all action plans associated with Accounts
   		for(Account account : [SELECT (SELECT Id, isDeleted FROM Action_Plans__r) FROM Account a WHERE Id IN: aIds])
		   {
			if (account.Action_Plans__r.size() > 0)
			{
				for(ActionPlan__c ap :account.Action_Plans__r)
				{					
					apIds.add(ap.Id);
				}
			}
   		}
   		if (apIds.size() > 0)
		{   	
			ActionPlansBatchDelete aPBatch = new ActionPlansBatchDelete(apIds, Userinfo.getUserId());
			Database.ExecuteBatch( aPBatch );
   		}
    }

    public void handleAfterUndelete(List<Account> newAccounts)
    {
        Database.UndeleteResult[] unDel_errors;
		for(Account newAccount : newAccounts)
		{
        	aIds.add(newAccount.Id);
   		}
   		List <ActionPlan__c> aPs = [SELECT Id, Name, LastModifiedDate FROM ActionPlan__c WHERE Account__c IN: aIds AND isDeleted = true ALL ROWS];
   		try
		{
   			if(ActionPlanObjectTriggerTest.isTest)
			{
   				//throw dmlException
   				insert new Contact();	
   			}
   			unDel_errors =Database.undelete(aPs,false);
   		} 
		catch(Dmlexception e)
		{				
   			for (Account account : newAccounts)
			{
				account.addError('You can not undelete an action plan whose related object is deleted.');
			}
   		}
    }

    private void unescapeAccountName(List<Account> newAccounts)
    {
        for(Account newAccount : newAccounts)
        {
            if(String.isBlank(newAccount.Name) == false) // Required fields validation fires after befire trigger
            {
                newAccount.Name = newAccount.Name.unescapeHtml4();
            } 
        }
    }
}