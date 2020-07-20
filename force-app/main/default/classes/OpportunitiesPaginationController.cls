public class OpportunitiesPaginationController{
    public Integer pageSize{get;set;} 
    public Integer noOfRecords{get; set;} 
    public List<SelectOption> pageSizeOptions{get;set;}
         
    public OpportunitiesPaginationController(){
        pageSize=10;
        pageSizeOptions = new List<SelectOption>();
        pageSizeOptions.add(new SelectOption('5','5'));
        pageSizeOptions.add(new SelectOption('10','10'));
        pageSizeOptions.add(new SelectOption('20','20'));
        pageSizeOptions.add(new SelectOption('50','50'));
        pageSizeOptions.add(new SelectOption('100','100'));
    }
     
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {                
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                      [SELECT Id, Name, AccountId, Account.Name, Amount, StageName, CloseDate, LastModifiedDate 
                       FROM Opportunity]));
                setCon.setPageSize(pageSize);  
                noOfRecords = setCon.getResultSize();
            }            
            return setCon;
        }
        set;
    }
     
    //Changes the size of pagination
    public PageReference refreshPageSize() {
         setCon.setPageSize(pageSize);
         return null;
    }
 
    // Initialize setCon and return a list of record    
     
    public List<Opportunity> getOpportunities() {
         return (List<Opportunity>) setCon.getRecords();
    }
}