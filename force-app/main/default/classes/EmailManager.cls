public without sharing class EmailManager implements IEmailManager
{
    public void sendEmail(String subject, List<String> recipients, String body)
    {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.subject = subject;
        message.toAddresses = recipients;
        message.plainTextBody = body;
        Messaging.SingleEmailMessage[] messages =  new List<Messaging.SingleEmailMessage>{message};
        Messaging.sendEmail(messages);
    }
}