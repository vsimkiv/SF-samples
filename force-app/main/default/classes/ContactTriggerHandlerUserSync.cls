public class ContactTriggerHandlerUserSync {
    public static void updateUsers(List<Contact> oldContacts, List<Contact> newContacts){
        List<Id> usersIds = new List<Id>();
        List<Contact> contactsWithUpdatedNameFields = new List<Contact>();
        
        for (Contact itemNew : newContacts) {
            for (Contact itemOld : oldContacts){
                if (itemNew.Id == itemOld.Id) {
                    if (isContactFirstNameUpdated(itemNew, itemOld) || isContactLastNameUpdated(itemNew, itemOld)) {
                        usersIds.add(itemNew.UserOneToOne__c);
                        contactsWithUpdatedNameFields.add(itemNew);
                    }
                }
            }
        }
        
        List<User> users = [SELECT Id, FirstName, LastName
                            FROM User
                            WHERE Id IN : usersIds];
        
        for (User userItem : users) {
            for (Contact contactItem : contactsWithUpdatedNameFields) {
                if (userItem.Id == contactItem.UserOneToOne__c){
                    userItem.FirstName = contactItem.FirstName;
                    userItem.LastName = contactItem.LastName;
                }
            }
        }
        
        update users;
    }
    
    
    
    
    private static Boolean isContactFirstNameUpdated(Contact oldContact, Contact newContact){
        if (oldContact.FirstName != newContact.FirstName && newContact.FirstName != null) {
            return true;
        } else {
            return false;
        }
    }
    
    private static Boolean isContactLastNameUpdated(Contact oldContact, Contact newContact){
        if (oldContact.LastName != newContact.LastName && newContact.LastName != null) {
            return true;
        } else {
            return false;
        }
    }
    
}