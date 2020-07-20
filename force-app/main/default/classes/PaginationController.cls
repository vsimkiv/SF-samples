public with sharing class PaginationController {
    public Integer pageSize {get;set;}
    public Integer pageNumber {get;set;}    
    public Integer amountOfRecords {get;set;}
    public Integer amountOfPages {get;set;}
    
    public PaginationController (){
        pageNumber = 1;
        pageSize = 5;
        amountOfRecords = [SELECT COUNT() 
                           FROM Contact];
        amountOfPages = amountOfRecords/pageSize +1;
    }
    
    public List<Contact> getContacts(){
        Integer offsetValue = getOffset(pageNumber, pageSize);
        
        return [SELECT Name, Account.Name, Title, Phone, Email, Birthdate 
                FROM Contact 
                ORDER BY Name 
                LIMIT :pageSize 
                OFFSET :offsetValue];
    }
    
    public void nextPage() {
        pageNumber += 1;
    }
    
    public void previousPage() {
        pageNumber -= 1;
    }
    
    public void firstPage() {
        pageNumber = 1;
    }
    
    public void lastPage() {
        pageNumber = amountOfPages;
    }
    
    public Boolean getDisableFirstPrevious(){
        if(pageNumber == 1){
            return true;
        }else{ 
            return false;
        }
    }
    
    public Boolean getDisableNextLast() {
        if (pageNumber == amountOfPages){
            return true;
        }else {
            return false;
        }   
    }
    
    private static Integer getOffset(Integer pageNumber, Integer pageSize) {
        return (pageNumber - 1)*pageSize;
    }
    
}