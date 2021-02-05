trigger ContactTrigger on Contact (before insert, after insert, after undelete, before delete) 
{
	ContactTriggerHelper helper = new ContactTriggerHelper();

	//Delete related action plans
	if (Trigger.isBefore && Trigger.isDelete)
	{
		helper.handleBeforeDelete(Trigger.old);
	}
	
	//Undelete related action plans
	if (Trigger.isUnDelete)
	{
		helper.handleAfterUndelete(Trigger.new);
	}

}