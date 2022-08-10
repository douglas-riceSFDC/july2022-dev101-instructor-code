trigger Project on Project__c (after update) {
    if(Trigger.isAfter && Trigger.isUpdate) {
        ProjectManagerAssigner.updateTimesheetManagerOnProjectChange(Trigger.new);
    }
}