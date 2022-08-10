trigger Timesheet on Timesheet__c (before update, before insert) {
    if(Trigger.isBefore && Trigger.isUpdate) {
        TimesheetRejectionCounter.updateTimesRejectedOnRejection(Trigger.new, Trigger.oldMap);
    } else if(Trigger.isBefore && Trigger.isInsert) {
        ProjectManagerAssigner.assignTimesheetManagerFromProject(Trigger.new);
    }
}