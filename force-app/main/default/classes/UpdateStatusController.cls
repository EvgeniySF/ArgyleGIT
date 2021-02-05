public inherited sharing class UpdateStatusController {

    @AuraEnabled
    public static list<String> readCSVFile(Id idContentDocument, Id argyleGroupEventId){ 
        List<String> uploadedEmails = new List<String>();
        if(idContentDocument != null && argyleGroupEventId != null) { 
            ContentVersion objVersion = [SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId =:idContentDocument];
            
            list<String> lstCSVLines = objVersion.VersionData.toString().split('\n'); 
            for(Integer i = 1; i < lstCSVLines.size(); i++){
                uploadedEmails.add(lstCSVLines[i].replaceAll('\r\n|\n|\r',''));  
            } 
            system.debug('uploadedEmails size = ' + uploadedEmails.size());
            try{    
                if(!uploadedEmails.isEmpty()) {
                List<Event_Participant__c> participantsToUpdate = [SELECT Participation_Status__c, Zapier_Email__c
                                                                   FROM Event_Participant__c 
                                                                   WHERE Argyle_Group_Event__c =: argyleGroupEventId 
                                                                   AND Participation_Status__c != 'Attended'
                                                                   AND (Zapier_Email__c IN : uploadedEmails
                                                                   OR Contact__r.Email IN : uploadedEmails)]; 
                for(Event_Participant__c participant : participantsToUpdate) {
                    participant.Participation_Status__c = 'Attended'; 
                } 
                
            system.debug('participantsToUpdate size = ' + participantsToUpdate.size());                                                                                                   
                    update participantsToUpdate;
                    delete [SELECT Id FROM ContentDocument WHERE Id =: idContentDocument];
                }
            }
            catch (Exception ex) {
                throw new AuraHandledException(ex.getMessage());
            } 
        }
        return uploadedEmails;    
    }
}