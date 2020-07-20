public class ContactPagination {
    public Integer pageSize{get;set;} 
    
    public ContactPagination(ApexPages.StandardSetController controller){
        pageSize = 5;
        controller.setPageSize(pageSize);
    }
}