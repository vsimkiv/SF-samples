@isTest
private class PersonTriggerTest {
    @testSetup 
    static void setup() {
        List<Family__c> families = new List<Family__c>();
        
        for (Integer i = 0; i<2; i++) {
            families.add(new Family__c(Name = 'F' + i));
        }
        
        insert families;
        
        List<Person__c> persons = new List<Person__c>();
        
        for (Integer j = 0; j<2; j++){
            Person__c one = new Person__c(Name = 'P' + j);
            one.Family__c = families[0].id;
            persons.add(one);
        }
        
        insert persons;
    }
    
    @IsTest
    static void testInsert(){
        // Perform test
        Test.startTest();
        List<Family__c> fromDB = [SELECT Id, Family_Members__c
                                  FROM Family__c
                                  LIMIT 1]; 
        Test.stopTest();
        // Verify 
        System.assertEquals('P0, P1', fromDB[0].Family_Members__c, 'wtf');
    }
    
    @IsTest
    static void testUpdateName(){  
             List<Person__c> persons = [SELECT Id, Name
                                   FROM Person__c
                                   WHERE Name = 'P0']; 
        persons[0].Name = 'P';
        Test.startTest();
   
        update persons;
        
        Test.stopTest();
                List<Family__c> families = [SELECT Id, Name, Family_Members__c 
                                    FROM Family__c
                                    WHERE Name = 'F0'];
        
        System.assertEquals('P, P1', families[0].Family_Members__c, 'wtf');
    }
    
    @IsTest
    static void testUpdateFamily(){
        // Perform test
        Test.startTest();
        List<Family__c> families = [SELECT Id, Name
                                    FROM Family__c
                                    WHERE Name = 'F1'];	
        
        
        List<Person__c> persons = [SELECT Id, Name, Family__c
                                   FROM Person__c
                                   WHERE Name = 'P0']; 
        persons[0].Family__c = families[0].Id;
        update persons;
        
        Test.stopTest();
        // Verify 
        List<Family__c> after = [SELECT Id, Name, Family_Members__c
                                 FROM Family__c
                                 ORDER BY Name];
        
        System.assertEquals('P1', after[0].Family_Members__c, 'wtf-f0');
        System.assertEquals('P0', after[1].Family_Members__c, 'wtf-f1');
    }
    
    @IsTest
    static void testDelete(){
        Test.startTest();
        delete [SELECT Id, Name, Family__c
                                   FROM Person__c
                                   WHERE Name = 'P0'];
        Test.stopTest();
        
        List<Family__c> after = [SELECT Id, Name, Family_Members__c
                                 FROM Family__c
                                 ORDER BY Name];
        
        System.assertEquals('P1', after[0].Family_Members__c, 'wtf-del');
    }
}