// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

List<Contact> contactList = new List<Contact>();
Contact newContact = new Contact();
newContact.FirstName = 'John';
newContact.LastName = 'Doe';
newContact.AccountId = '0013I00000nPCGaQAO';
contactList.add(newContact);

newContact = new Contact();
newContact.FirstName = 'Jane';
newContact.LastName = 'Doe';
newContact.AccountId = '0013I00000nPCGaQAO';
contactList.add(newContact);

newContact = new Contact();
newContact.FirstName = 'Agent';
newContact.LastName = 'Smith';
newContact.AccountId = '0013I00000nPCGaQAO';
//newContact.Email = '123556';
contactList.add(newContact);

contactList[0].addError('Duplicate Detected');

Database.insert(contactList, false);

//SOQL - Salesforce Object Querying Language
//SOSL - Salesforce Object Search Language

String query = 'SELECT ';
List<String> fields = new List<String>();
for(String s : fields) {
    query = query + s + ', ';
}

query = query + ' FROM Contact';



String fields = 'SELECT Id';
String fields = fields + ', Name';
String from = ' FROM Contact ';

String where1 = 'WHERE CreatedDate = TODAY';
String where2 = 'WHERE Name = \'Fady Labib\'';

Database.query(fields + from + where1);
Database.query(fields + from + where2);

System.debug(Database.query('SELECT Id, Name FROM Contact WHERE CreatedDate = TODAY'));

//System.debug([SELECT Id FROM Contact WHERE CreatedDate = TODAY]);


for(Contact c : [SELECT Name, Email, Account.Name, Account.CreatedDate, Account.Owner.Name, Account.CreatedBy.Name
                FROM Contact
                WHERE Name = 'Jane Doe']){

    System.debug(c.Account.Name + ' - ' + c.Account.Owner.Name + ' - ' + c.Account.CreatedBy.Name);
}

for(Account a : [SELECT Name, (SELECT Name, Email FROM Contacts) 
                        FROM Account]){

    System.debug(a.Name);

    for(Contact c : a.Contacts) {
        System.debug(' > ' + c.Name + ' - ' + c.Email);
    }
}




for(Timesheet__c t : [SELECT Name, Status__c, Project__c, Project__r.Name, Project__r.Project_Manager__c 
                        FROM Timesheet__c]){

    System.debug(t.Name + ' - ' + t.Status__c + ' - ' + t.Project__r.Name);
}




for(Project__c project : [SELECT Name, CreatedDate, (SELECT Name, Status__c FROM Timesheets__r) 
                        FROM Project__c]){

    System.debug(project.Name);

    for(Timesheet__c t : project.Timesheets__r) {
        System.debug(' > ' + t.Name + ' - ' + t.Status__c);
    }
}



//



System.debug([SELECT Id, Name, Account.Name, Account.Owner.Name, Account.CreatedBy.Name 
                FROM Contact 
                WHERE CreatedDate < :Date.today()]);



System.debug([SELECT Id, Name, Subject 
                FROM Case 
                WHERE CreatedDate < :Date.today()]);



System.debug([SELECT Id, Email, Owner.Name, Owner.Email 
                FROM Lead 
                WHERE Rating = 'Hot']);



System.debug([SELECT count() 
                FROM Account 
                WHERE LastModifiedDate = :Date.today()])



System.debug([SELECT Id, Name, Amount, 
                (SELECT ListPrice, Quantity
                    FROM OpportunityLineItems) 
                FROM Opportunity
                WHERE Amount > 1000]);



System.debug([SELECT QuoteId, ListPrice, UnitPrice 
                FROM QuoteLineItem 
                WHERE ListPrice > 10]);
