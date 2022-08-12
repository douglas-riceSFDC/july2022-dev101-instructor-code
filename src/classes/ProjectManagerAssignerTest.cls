@isTest
private class ProjectManagerAssignerTest {

    @isTest
    static void methodUnderTest_given_should() {

    }

    @isTest
    static void assignTimesheetManagerFromProject_givenNewTimesheet_shouldAssignManager() {
        // Data setup
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        insert testAccount;

        Contact projectManager = new Contact();
        projectManager.FirstName = 'John';
        projectManager.LastName = 'Doe';
        projectManager.AccountId = testAccount.Id;
        insert projectManager;

        Project__c project = new Project__c();
        project.Name = 'Test Project';
        project.Project_Manager__c = projectManager.Id;
        insert project;

        Timesheet__c timesheet = new Timesheet__c();
        timesheet.Project__c = project.Id;

        // Executing scenario
        Test.startTest();

        insert timesheet;

        Test.stopTest();

        // Checking results
        List<Timesheet__c> insertedTimesheets = [SELECT Project_Manager__c 
                                                    FROM Timesheet__c
                                                    WHERE Id = :timesheet.Id];
        
        System.assertEquals(project.Project_Manager__c, 
            insertedTimesheets[0].Project_Manager__c, 
            'The Project Manager should have been assigned to the timesheet.');

    }
}
