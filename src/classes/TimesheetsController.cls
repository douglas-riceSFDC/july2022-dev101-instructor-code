public with sharing class TimesheetsController {

    @AuraEnabled(cacheable=true)
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

    @AuraEnabled
    public static void updateTimesheets(List<Timesheet__c> timesheets, String status) {
        try {
            for(Timesheet__c ts : timesheets) {
                ts.Status__c = status;
            }

            update timesheets;
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


}