public class UserContactSyncUtils {
    public static Boolean preventContactUpdate (List<Contact> contactsNew){
        Boolean prevent = true;
        
        List<Id> userIds = new List<Id>();
        
        for (Contact contactItem : contactsNew) {
            userIds.add(contactItem.UserOneToOne__c);
            
        }
        
        List<User> users = [SELECT Id, FirstName, LastName
                            FROM User
                            WHERE Id IN : userIds];
        
        for (Contact contactItem : contactsNew) {
            for (User userItem : users ){
                if (userItem.Id == contactItem.UserOneToOne__c) {
                    if (userItem.FirstName != contactItem.FirstName || userItem.LastName != contactItem.LastName) {
                        prevent = false;
                        break;
                    }
                }
            }
        }
        return prevent;
    }
    
    private static Boolean isEquivalent (Contact contact, User user) {
        if (contact.FirstName == user.FirstName || contact.LastName == user.LastName) {
            return true;
        } else {
            return false;
        }
    }
    
}