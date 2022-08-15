@isTest
private class ProjectManagerAssignerTest {

    @testSetup
    static void createProjectData() {
        Contact projectManager = generateProjectManager('John', 'Doe');
        insert projectManager;

        Project__c project = new Project__c();
        project.Name = 'Test Project';
        project.Project_Manager__c = projectManager.Id;
        insert project;
    }

    private static Contact generateProjectManager(String firstName, String lastName) {
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        insert testAccount;

        Contact projectManager = new Contact();
        projectManager.FirstName = firstName;
        projectManager.LastName = lastName;
        projectManager.AccountId = testAccount.Id;

        return projectManager;
    }

    @isTest
    static void methodUnderTest_given_should() {

    }

    @isTest
    static void assignTimesheetManagerFromProject_givenNewTimesheet_shouldAssignManager() {
        // Data setup
        List<Project__c> project = [SELECT Id, Project_Manager__c
                                    FROM Project__c 
                                    LIMIT 1];

        Timesheet__c timesheet = new Timesheet__c();
        timesheet.Project__c = project[0].Id;

        // Executing scenario
        Test.startTest();

        insert timesheet;

        Test.stopTest();

        // Checking results
        List<Timesheet__c> insertedTimesheets = [SELECT Project_Manager__c 
                                                    FROM Timesheet__c
                                                    WHERE Id = :timesheet.Id];
        
        System.assertEquals(project[0].Project_Manager__c, 
            insertedTimesheets[0].Project_Manager__c, 
            'The Project Manager should have been assigned to the timesheet.');

    }

    @isTest
    static void assignTimesheetManagerFromProject_givenGivenNoManager_shouldNotFail() {
        // Data setup
        List<Project__c> project = [SELECT Id, Project_Manager__c
                                    FROM Project__c 
                                    LIMIT 1];

        Timesheet__c timesheet = new Timesheet__c();
        timesheet.Project__c = project[0].Id;

        // Executing scenario
        Test.startTest();

        insert timesheet;

        Test.stopTest();

        // Checking results
        List<Timesheet__c> insertedTimesheets = [SELECT Project_Manager__c 
                                                    FROM Timesheet__c
                                                    WHERE Id = :timesheet.Id];
        
        System.assertEquals(1, 
            insertedTimesheets.size(), 
            'The Timesheet should not have had errors.');

    }

    @isTest
    static void updateTimesheetManagerOnProjectChange_givenNewManager_shouldUpdateTimesheet() {
        List<Project__c> project = [SELECT Id, Project_Manager__c
                                    FROM Project__c 
                                    LIMIT 1];

        Timesheet__c timesheet = new Timesheet__c();
        timesheet.Project__c = project[0].Id;
        insert timesheet;
       
        Contact newProjectManager = generateProjectManager('Jane', 'Doe');
        insert newProjectManager;

        Test.startTest();

        project[0].Project_Manager__c = newProjectManager.Id;
        update project;

        Test.stopTest();

        List<Timesheet__c> insertedTimesheets = [SELECT Project_Manager__c 
                                                    FROM Timesheet__c
                                                    WHERE Id = :timesheet.Id];
        
        System.assertEquals(project[0].Project_Manager__c, 
            insertedTimesheets[0].Project_Manager__c, 
            'The Project Manager should have been updated to the new value.');
    }
}
