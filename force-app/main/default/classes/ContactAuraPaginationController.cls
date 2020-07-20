public class ContactAuraPaginationController {
    @AuraEnabled
    public static ContactDataTableWrapper getContactData(Integer pageNumber, Integer pageSize) {
        Integer offset = (pageNumber - 1) * pageSize;
        
        Integer amountOfRecords = [SELECT COUNT() FROM Contact];
        Integer amountOfPages = amountOfRecords/pageSize +1;
        
        Integer numberOfFirstRecordOnPage = offset + 1;
        Integer numberOfLastRecordOnPage = amountOfRecords > pageNumber * pageSize ? pageNumber * pageSize : amountOfRecords;
        
        List<Contact> contactList = [SELECT Id, Name, Phone, Email 
                                     FROM Contact 
                                     ORDER BY Name 
                                     LIMIT :pageSize 
                                     OFFSET :offset]; 
        
        ContactDataTableWrapper wrapper =  new ContactDataTableWrapper();  
        wrapper.pageSize = pageSize;
        wrapper.pageNumber = pageNumber;
        wrapper.amountOfRecords = amountOfRecords;
        wrapper.amountOfPages = amountOfPages;
        wrapper.numberOfFirstRecordOnPage = numberOfFirstRecordOnPage;
        wrapper.numberOfLastRecordOnPage = numberOfLastRecordOnPage;
        wrapper.contactList = contactList;
        
        return wrapper;
    }
}