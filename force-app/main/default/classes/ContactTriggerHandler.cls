public class ContactTriggerHandler {
	//UPDATE
    public static void updateClosestBirthdate (List<Contact> oldContacts, List<Contact> newContacts){
        updateClosestBirthdateContactForAccount(getAccountsToUpdate(oldContacts, newContacts));
    }

    //INSERT/DELETE/UNDELETE
    public static void updateClosestBirthdate (List<Contact> contacts){
        updateClosestBirthdateContactForAccount(getAccountsToUpdate(contacts));
    }

    
    public static void updateClosestBirthdateContactForAccount(Set<Id> accountIds){
        List<Account> accounts = [SELECT Id, CreatedDate, Closest_Birthdate_Contact__c, (SELECT Id, Birthdate
                                                                                         FROM Contacts)
                                  FROM Account
                                  WHERE Id IN :accountIds];
        
        for (Account a : accounts){
            Integer minDiff;
            Id minDiffContactId;
            Date accCreatedDate = Date.newinstance(a.CreatedDate.year(), a.CreatedDate.month(), a.CreatedDate.day());
            
            for (Contact c : a.Contacts){
                Integer currentDiff;
                if (c.Birthdate != null) {
                    currentDiff = Math.abs(accCreatedDate.daysBetween(c.Birthdate));
                }
                
                if (currentDiff != null){
                    if (minDiff == null) {
                        minDiff = currentDiff;
                        minDiffContactId = c.Id;
                    } else {
                        if (currentDiff < minDiff){
                            minDiff = currentDiff;
                            minDiffContactId = c.Id;
                        }
                    }
                }
            }
            a.Closest_Birthdate_Contact__c = minDiffContactId;
        }
        
        update accounts;
    }
    
    //get Ids of Accounts to Update for UPDATE trigger
    private static Set<Id> getAccountsToUpdate(List<Contact> oldContacts, List<Contact> newContacts){ 
        Set<Id> ids = new Set<Id>();
        
        for (Contact itemNew : newContacts) {
            for (Contact itemOld : oldContacts){
                if (itemNew.Id == itemOld.Id && isBirthdateUpdated(itemOld, itemNew)) {
                    ids.add(itemNew.AccountId);
                }
            }    
        }
        return ids;
    }
    
    //get Ids of Accounts to Update for INSERT/DELETE/UNDELETE trigger
    private static Set<Id> getAccountsToUpdate(List<Contact> contacts){ 
        Set<Id> ids = new Set<Id>();
        
        for (Contact c : contacts) {
                if (c.Birthdate != null) {
                    ids.add(c.AccountId);
                }
        }
        return ids;
    }
    
    //check if Birthday of Contact is updated 
    private static boolean isBirthdateUpdated(Contact oldContact, Contact newContact){
        if (oldContact.Birthdate != newContact.Birthdate && newContact.Birthdate != null) {
            return true;
        } else {
            return false;
        }
    }

    //method for UPDATE triggers
    public static void updateStatusOfRelatedAccounts(List<Contact> contactsOld, List<Contact> contactsNew) {
        updateAccountStatus(getRelatedAccounts(contactsOld, contactsNew));
    } 
    //method for INSERT/DELETE/UNDELETE triggers
    public static void updateStatusOfRelatedAccounts(List<Contact> contacts) {
        updateAccountStatus(getRelatedAccounts(contacts));
    } 
    
    private static void updateAccountStatus(Map<Id, Account> accountsToUpdate){
        for (AggregateResult item : [SELECT AccountId, COUNT(Id) 
                                     FROM Contact
                                     WHERE AccountId IN :accountsToUpdate.values()
                                     GROUP BY AccountId]) {
                                         
                                         Integer numberOfContacts = (Integer)item.get('expr0');
                                         Id accId = (Id)item.get('AccountId');
                                         
                                         if(numberOfContacts > 1) {
                                             accountsToUpdate.get(accId).Status__c = 'Completed';
                                         }else {
                                             accountsToUpdate.get(accId).Status__c = 'Draft';
                                         }
                                     }
        
        System.debug(accountsToUpdate.values().size());
        for (Account a : accountsToUpdate.values()) {
            System.debug(a.Id + '-------' + a.Status__c);
        }
        
        try{
            update(accountsToUpdate.values());
        }catch (DmlException e){
            System.debug(e.getMessage());
        }
        
    }
    
    // for INSERT/DELETE triggers
    private static Map<Id, Account> getRelatedAccounts(List<Contact> contacts){
        Set<Id> accIds = new Set<Id>(); 
        
        for (Contact c : contacts) {
            accIds.add(c.AccountId);
        }
        
        return new Map<Id, Account> ([SELECT Id, Status__c 
                                      FROM Account 
                                      WHERE Id IN :accIds]);
    }
    
    //helper method used in updateStatusForUpdateTrigger
    private static Map<Id, Account> getRelatedAccounts(List<Contact> contactsOld, List<Contact> contactsNew) {
        Set<Id> accountsToUpdateIds = new Set<Id>();
        
        for (Contact itemOld : contactsOld){
            for (Contact itemNew : contactsNew){
                if (itemOld.Id == itemNew.Id){
                    if (isAccountUpdated(itemOld, itemNew)){
                        accountsToUpdateIds.add(itemOld.AccountId);
                        accountsToUpdateIds.add(itemNew.AccountId);
                    }
                }
            }
        }
        
        Map<Id, Account> result = new Map<Id, Account> ([SELECT Id, Status__c
                                                         FROM Account
                                                         WHERE Id IN :accountsToUpdateIds]);
        return result;   
    }
    
    //helper method used in getAccountsToUpdate
    private static boolean isAccountUpdated(Contact oldContact, Contact newContact){
        if (oldContact.AccountId != newContact.AccountId) {
            return true;
        } else {
            return false;
        }
    }
    
}