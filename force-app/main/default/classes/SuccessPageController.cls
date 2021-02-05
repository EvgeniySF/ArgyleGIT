global class SuccessPageController {
    
    public Event_Participant__c eventParticipant{get;set;}
    public String accessTypeCustom{get;set;}
    @TEstVisible public static Boolean throwEx{get;set;}
    
    public SuccessPageController() {
        throwEx = false;
        String currentRecordId  = ApexPages.CurrentPage().getparameters().get('id'); 
        eventParticipant = [select id, Lead__c, Contact__c, Zapier_Email__c, Confirmation_Email_Dev_Name__c, Confirmation_Email_is_Sent__c, Confirmation_Email_Sender_Name__c, Zapier_First_Name__c, Ticket_Payment_Status__c, Zapier_Last_Name__c, Argyle_Group_Event__r.Name, Argyle_Group_Event__r.Event_Date__c, Ticket_Access_Type__c from Event_Participant__c where Custom_Id__c =: currentRecordId ];
        accessTypeCustom = eventParticipant.Ticket_Access_Type__c.substring(0, eventParticipant.Ticket_Access_Type__c.indexOf('Pass'));
    } 
    public void updateStatus(){ 
        if(eventParticipant.Ticket_Payment_Status__c != 'Paid')
        {  
            try{
                if(Test.isRunningTest() && throwEx == true){
                    insert new Lead();
                } else {  
                    if(!eventParticipant.Confirmation_Email_is_Sent__c){
                        System.debug('Send Email');
                        eventParticipant.Confirmation_Email_is_Sent__c = true;
                        Id targetObjectId = eventParticipant.Contact__c != null ? eventParticipant.Contact__c : eventParticipant.Lead__c;
                        EmailService.sendingMail(targetObjectId, eventParticipant.Id, eventParticipant.Zapier_Email__c, eventParticipant.Confirmation_Email_Dev_Name__c, eventParticipant.Confirmation_Email_Sender_Name__c ); 
                    }
                    
                    eventParticipant.Ticket_Payment_Status__c  = 'Paid';
                    update eventParticipant;
                }
            } catch(DMLException ex){
                Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {'evgeniy.motalygin@nixsolutions.com'};
                mail.setToAddresses(toAddresses);
                mail.setReplyTo('argyle@gmail.com');
                mail.setSenderDisplayName('Apex error message during Confirmation Page Update');
                mail.setSubject('Error from Org : ' + UserInfo.getOrganizationName());
                mail.setPlainTextBody(ex.getMessage());
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
    }
}