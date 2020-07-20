public class UserTriggerHandlerContactSync { 
    public static void updateContacts(List<User> usersOld, List<User> usersNew){
        Map<Id, User> usersWithUpdatedNameFields = new Map<Id, User>();
        
        for (User itemOld : usersOld) {
            for (User itemNew : usersNew){
                if (itemNew.Id == itemOld.Id) {
                    if (isUserFirstNameUpdated(itemNew, itemOld) || isUserLastNameUpdated(itemNew, itemOld)) {
                        usersWithUpdatedNameFields.put(itemNew.Id, itemNew);
                    }
                }
            }
        }
        
        List<Contact> contacts = [SELECT Id, FirstName, LastName, UserOneToOne__c, User_FK__c
                                  FROM Contact
                                  WHERE UserOneToOne__c IN : usersWithUpdatedNameFields.keySet()];
        
        if (UserContactSyncUtils.runUpdate(contacts, usersNew)){
            for (Id userId : usersWithUpdatedNameFields.keySet()) {
                for (Contact contactItem : contacts) {
                    if (userId == contactItem.UserOneToOne__c){
                        contactItem.FirstName = usersWithUpdatedNameFields.get(userId).FirstName;
                        contactItem.LastName = usersWithUpdatedNameFields.get(userId).LastName;
                        contactItem.User_FK__c = userId;
                    }
                }
            }
            update contacts;
        }   
    }
    
    
    private static Boolean isUserFirstNameUpdated(User oldUser, User newUser){
        if (oldUser.FirstName != newUser.FirstName && newUser.FirstName != null) {
            return true;
        } else {
            return false;
        }
    }
    
    private static Boolean isUserLastNameUpdated(User oldUser, User newUser){
        if (oldUser.LastName != newUser.LastName && newUser.LastName != null) {
            return true;
        } else {
            return false;
        }
    }   
}