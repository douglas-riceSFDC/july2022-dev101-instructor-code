public with sharing class TimesheetRejectionCounter {
    public TimesheetRejectionCounter() {


    }

    public static void updateTimesRejectedOnRejection(List<Timesheet__c> updatedTimesheets,
                                                        Map<Id, Timesheet__c> oldTimesheetValues) {
        
        for(Timesheet__c timesheet : updatedTimesheets) {
            if(timesheet.Status__c == 'Rejected' &&
                oldTimesheetValues.get(timesheet.Id).Status__c != 'Rejected') {

                if(timesheet.Number_of_Times_Rejected__c == null) {
                    timesheet.Number_of_Times_Rejected__c = 0;
                }

                timesheet.Number_of_Times_Rejected__c = timesheet.Number_of_Times_Rejected__c + 1;
            }
        }

    }
}
