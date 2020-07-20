public class PersonTriggerHandler {
    //INSERT, DELETE, UNDELETE
    public static void updateFamily(List<Person__c> persons) {
        updateFamilyMembers(getFamiliesToUpdate(persons));
    }
    
    //UPDATE
    public static void updateFamily(List<Person__c> personsOld, List<Person__c> personsNew) {
        updateFamilyMembers(getFamiliesToUpdate(personsOld, personsNew));
    }
    
    private static void updateFamilyMembers(List<Family__c> families){
        for (Family__c familyItem : families) {
            String members = '';
            for (Person__c personItem : familyItem.Persons__r){
                members += personItem.Name + ', ';
            }
            
            members = members.substring(0, members.length()-2);
            familyItem.Family_Members__c = members;
        }
        
        try {
            update families;
        } catch (Exception e){
            System.debug('Update failed: ' + e.getMessage());
        }
    }
    
    private static List<Family__c> getFamiliesToUpdate(List<Person__c> personsOld, List<Person__c> personsNew){
        Set<Id> ids = new Set<Id>();
        
        for (Person__c itemOld : personsOld) {
            for (Person__c itemNew : personsNew) {
                if (itemNew.Id == itemOld.Id){
                    if (TriggerUtils.isChangedOrIsNew(itemNew, itemOld, 'Name') ||
                        TriggerUtils.isChangedOrIsNew(itemNew, itemOld, 'Family__c')){
                            ids.add(itemNew.Family__c); 
                            ids.add(itemOld.Family__c); 
                        }
                }
            }
        }
        
        return [SELECT Id, Name, Family_Members__c, (SELECT Id, Name
                                                     FROM Persons__r
                                                     ORDER BY Name)
                FROM Family__c
                WHERE Id IN :ids];
    }
    
    
    private static List<Family__c> getFamiliesToUpdate(List<Person__c> persons){
        Set<Id> ids = new Set<Id>();
        
        for (Person__c personItem : persons) {
            if (personItem.Family__c != null){
                ids.add(personItem.Family__c);
            }
        }
        
        return [SELECT Id, Name, Family_Members__c, (SELECT Id, Name
                                                     FROM Persons__r
                                                     ORDER BY Name)
                FROM Family__c
                WHERE Id IN :ids];
    }
}