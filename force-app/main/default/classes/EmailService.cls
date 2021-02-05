public class EmailService {
    public static void sendingMail(String targetObjectId, String setWhatId, String email, String confirmationEmailDevName, String confirmationEmailSenderName) {	
        Id temlateId = [SELECT Id FROM EmailTemplate WHERE DeveloperName =: confirmationEmailDevName].Id;
        
        Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();// create instance of SingleEmailMessage class
        String[] sendingToBccAdd = new String[] {'argyleeventconfirmation@gmail.com'}; // Add email addresses to blind carbon copy (BCC) addresses. The maximum allowed is 25.
        mail.setBccAddresses(sendingToBccAdd); 
        mail.setReplyTo('campaignmanagement@argyleforum.com');
        mail.setTargetObjectId(targetObjectId);// This is the ID of rel 
        mail.setSaveAsActivity(false);
        mail.setWhatId(setWhatId);
        mail.setTemplateId(temlateId);// This is template ID
        mail.setSenderDisplayName(confirmationEmailSenderName);
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        allmsg.add(mail);
        Messaging.sendEmail(allmsg, false); 
    } 
    
}