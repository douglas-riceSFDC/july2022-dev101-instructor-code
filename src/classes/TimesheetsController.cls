public with sharing class TimesheetsController {

    @AuraEnabled
    public static List<Timesheet__c> getRelatedTimesheets(Id projectId) {
        try {
            return [
                SELECT Id, Name, Status__c, Number_of_Times_Rejected__c
                FROM Timesheet__c
                WHERE Project__c = :projectId
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}