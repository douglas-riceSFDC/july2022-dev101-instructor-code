public with sharing class ProjectManagerAssigner {
    
    public static void assignTimesheetManagerFromProject(List<Timesheet__c> insertedTimesheets) {
        Set<Id> projectIds = new Set<Id>();

        for(Timesheet__c timesheet : insertedTimesheets) {
            projectIds.add(timesheet.Project__c);
        }

        Map<Id, Project__c> assignedProjects = new Map<Id, Project__c>([SELECT Project_Manager__c
                                                                            FROM Project__c
                                                                            WHERE Id IN :projectIds]);

        for(Timesheet__c timesheet : insertedTimesheets) {
            if(assignedProjects.containsKey(timesheet.Project__c)) {
                timesheet.Project_Manager__c = assignedProjects.get(timesheet.Project__c).Project_Manager__c;
            }
        }
    }

    public static void updateTimesheetManagerOnProjectChange(List<Project__c> updatedProjects) {
        Set<Id> projectIds = new Set<Id>();

        for(Project__c project : updatedProjects) {
            projectIds.add(project.Id);
        }

        List<Timesheet__c> childTimesheets = [SELECT Project_Manager__c, Project__c
                                                FROM Timesheet__c
                                                WHERE Project__c IN :projectIds];

        for(Timesheet__c timesheet : childTimesheets) {
            for(Project__c project : updatedProjects) {
                if(timesheet.Project__c == project.Id) {

                    timesheet.Project_Manager__c = project.Project_Manager__c;
                }
            }
        }
        
        update childTimesheets;
    }
}
