public class ContactDataTableWrapper {
	@AuraEnabled    
    public Integer pageSize {get;set;}
    @AuraEnabled
    public Integer pageNumber {get;set;}    
    @AuraEnabled
    public Integer amountOfRecords {get;set;}
    @AuraEnabled
    public Integer amountOfPages {get;set;}
    @AuraEnabled
    public Integer numberOfFirstRecordOnPage {get;set;}
    @AuraEnabled
    public Integer numberOfLastRecordOnPage {get;set;}
    @AuraEnabled
    public List<Contact> contactList {get;set;}
}