trigger AccountTrigger on Account (before insert, after insert, before delete, after undelete) 
{
	AccountTriggerHelper helper = new AccountTriggerHelper();
	
	if(Trigger.isBefore && Trigger.isInsert)
	{
		helper.hanldeBeforeInsert(Trigger.new);
	}
	//Delete related action plans
	if (Trigger.isBefore && Trigger.isDelete)
	{
		helper.handleBeforeDelete(Trigger.old);
	}

	//Undelete related action plans
	if (Trigger.isAfter && Trigger.isUndelete)
	{
		helper.handleAfterUndelete(Trigger.new);
	}
}