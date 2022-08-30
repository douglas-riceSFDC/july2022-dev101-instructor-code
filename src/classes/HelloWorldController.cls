public with sharing class HelloWorldController {
    private Timesheet__c timesheet;

    // When working with custom controllers, you can extend the base Standard Controller functionality
    // In order to do that, your constructor needs to take in the Standard Controller as a parameter
    public HelloWorldController(ApexPages.StandardController controller) {
        timesheet = [SELECT Name
                        FROM Timesheet__c
                        WHERE Id = :controller.getId()];
    }

    public String getWelcomeMessage(){
        return 'Welcome to Salesforce! Your timesheet number is: ' + timesheet.Name;
    }

    public List<String> getStringCollection() {
        List<String> returnStrings = new List<String>();
        returnStrings.add('One');
        returnStrings.add('Two');
        returnStrings.add('Three');

        return returnStrings;
    }
}
