public class EventParticipantWrapper {  
    public String firstName { get; set; } 
    public String lastName { get; set; } 
    public String email { get; set; } 
    public String jobTitle { get; set; } 
    public String company { get; set; } 
    public String phone { get; set; }  
    public String sessionId { get; set; }
    public String argyleGroupEventId { get; set; } 
    public String customId { get; set; }
    public String ticketAccessType { get; set; }
    public String paymentIntent { get; set; } 
    public Decimal ticketRevenue { get; set; } 
    public String confirmationEmailDevName { get; set; }
    public String confirmationEmailSenderName { get; set; } 
    public UTMDataWrapper utmData { get; set; }
    
    public EventParticipantWrapper(String firstName, String lastName, String email, String jobTitle, String company, String phone, String argyleGroupEventId, String customId, String ticketAccessType, Decimal ticketRevenue, String confirmationEmailDevName, String confirmationEmailSenderName, UTMDataWrapper utmData) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.jobTitle = jobTitle;
        this.company = company;
        this.phone = phone; 
        this.argyleGroupEventId = argyleGroupEventId; 
        this.customId = customId;
        this.ticketAccessType = ticketAccessType;  
        this.ticketRevenue = ticketRevenue;
        this.confirmationEmailDevName = confirmationEmailDevName;
        this.confirmationEmailSenderName = confirmationEmailSenderName;
        this.utmData = utmData; 
    }
}