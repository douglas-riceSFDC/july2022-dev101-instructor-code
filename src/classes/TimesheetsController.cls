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

    @AuraEnabled
    public static void approveTimesheets(List<Timesheet__c> timesheetsToApprove) {
        try {
            for(Timesheet__c ts : timesheetsToApprove) {
                ts.Status__c = 'Approved';
            }

            update timesheetsToApprove;
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void rejectTimesheets(List<Timesheet__c> timesheetsToReject) {
        try {
            for(Timesheet__c ts: timesheetsToReject) {
                ts.Status__c = 'Rejected';
            }

            update timesheetsToReject;
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}