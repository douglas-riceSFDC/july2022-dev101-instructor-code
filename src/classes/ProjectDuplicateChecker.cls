public with sharing class ProjectDuplicateChecker {
    
    @InvocableMethod(description='Returns duplicate projects.' category='Project')
    public static List<DuplicateProjectResponse> checkForDuplicateProjects(List<DuplicateProjectParameter> input) {
        System.debug('Input - ' + input);
        List<Project__c> currentProject = [SELECT Name 
                                            FROM Project__c 
                                            WHERE Id = :input[0].projectId
                                            LIMIT 1];
        
        List<DuplicateProjectResponse> responses = new List<DuplicateProjectResponse>();
        
        if(currentProject.size() > 0) {
            DuplicateProjectResponse response = new DuplicateProjectResponse();
            response.duplicateProjects = [SELECT Id, Name
                                                    FROM Project__c
                                                    WHERE Name = :currentProject[0].Name
                                                        AND Id != :input[0].projectId];

            responses.add(response);
        }

        return responses;
    }

    public class DuplicateProjectResponse {

        @InvocableVariable
        public List<Project__c> duplicateProjects;
    }

    public class DuplicateProjectParameter {
        
        @InvocableVariable 
        public Id projectId;

        @InvocableVariable
        public String projectName;

        @InvocableVariable
        public Project__c project;

    }
}
