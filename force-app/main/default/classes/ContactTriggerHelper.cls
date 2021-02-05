public without sharing class ContactTriggerHelper 
{
    @TestVisible
    private static IArgyleGroupEventSelector eventSelector = new ArgyleGroupEventSelector();
    
    List<ID> cIds = new List<ID>();
	List<String> apIds = new List<String>();
	List<ActionPlan__c>	deletePermantently_apIds = new List<ActionPlan__c>();	


    public void handleBeforeDelete(List<Contact> oldContacts)
    {
        for(Contact oldContact : oldContacts)
        {
        	cIds.add(oldContact.Id);
   		}
   		
		/* GET Action Plans to delete from recycle bin */
   		deletePermantently_apIds = [SELECT Id, Name , LastModifiedDate FROM ActionPlan__c WHERE Contact__c IN: cIds AND isDeleted = true ALL ROWS];
   		
   		if (deletePermantently_apIds.size() > 0)
        {   		
			Database.emptyRecycleBin(deletePermantently_apIds);
   		}   		
   		
		List<ActionPlan__c> apList = [SELECT Id FROM ActionPlan__c WHERE Contact__c IN: cIds];
		for(ActionPlan__c ap : [SELECT Id FROM ActionPlan__c WHERE Contact__c in : cIds])
        {
        	apIds.add(ap.Id);
   		}
   		
   		if (apIds.size() > 0)
           {
   			ActionPlansBatchDelete aPBatch = new ActionPlansBatchDelete(apIds, Userinfo.getUserId());
			Database.ExecuteBatch(aPBatch);
   		}			
    }

    public void handleAfterUndelete(List<Contact> newContacts)
    {
        for( Contact newContact : newContacts)
        {
        	cIds.add(newContact.Id);
   		}
   		list <ActionPlan__c> aPs = [SELECT Id FROM ActionPlan__c WHERE Contact__c IN: cIds ALL ROWS];
   		
   		try
        {
   			if(ActionPlanObjectTriggerTest.isTest)
            {
   				//throw dmlException
   				insert new Contact();	
   			}
   			//undelete aPs;
   			Database.undelete( aPs,false);
   		}
        catch (Dmlexception e)
        {
   			for (Contact newContact : newContacts)
            {
				newContact.addError('You can not undelete an action plan whose related object is deleted.');
			}
   		}
    }

    
}