public interface IEmailManager 
{
    void sendEmail(String subject, List<String> recipients, String body);
}