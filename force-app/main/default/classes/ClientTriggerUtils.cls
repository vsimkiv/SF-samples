public class ClientTriggerUtils {  
    public static void distributeClients (List<Client__c> clients) {
        Integer newTotalClients = [SELECT COUNT() FROM Client__c] + clients.size();
        
        List<Member__c> allMembers = [SELECT Id, Active_Clients__c, Capacity__c, Actual_Client_Share__c, Workload__c
                                      FROM Member__c 
                                      ORDER BY WorkLoad__c];
        
        recalcWorkloadAll(allMembers, newTotalClients);
          
        for (Client__c item : clients) {
            Member__c member = getMemberWithMinWorkload(allMembers);            
            item.Member__c = member.Id;
            
			recalcWorkloadOne(member, newTotalClients);
        }	    
    }
    
    private static Member__c getMemberWithMinWorkload (List<Member__c> members) {
        Decimal minWorkload;
        Member__c memberWithMinWorkload;
        for (Member__c item : members) {
            if (minWorkload == null || item.WorkLoad__c < minWorkload) {
                minWorkload = item.Workload__c;
                memberWithMinWorkload = item;
            }
        }
        return memberWithMinWorkload;
    }
    
    //for recently assigned member 
    private static void recalcWorkloadOne(Member__c member, Decimal totalClients) {                           
        member.Active_Clients__c = member.Active_Clients__c + 1;
        member.Workload__c = (member.Active_Clients__c/totalClients) /member.Capacity__c *10000;
    }
    
    //before updates of Members
    private static void recalcWorkloadAll(List<Member__c> members, Decimal totalClients) {
        for (Member__c item : members) {
            if (totalClients > 0){
            	item.Workload__c = (item.Active_Clients__c/totalClients) /item.Capacity__c *10000;
            } else {
                item.Workload__c = 0;
            }
        }
    } 
    
    public static void updateMembers(List<Client__c> clients) {
        List<Member__c> membersToUpdate = new List<Member__c>();
        Decimal totalClients = [SELECT COUNT() FROM Client__c];
        
        for (Member__c item: [SELECT Id, Name, Active_Clients__c, Capacity__c, Actual_Client_Share__c, Workload__c, (SELECT Id FROM Clients__r)
                              FROM Member__c]) {
                                  
             item.Active_Clients__c = item.Clients__r.size();
             if (totalClients > 0) { 
                item.Actual_Client_Share__c = item.Clients__r.size()/totalClients*100;     
             	item.Workload__c = (item.Clients__r.size()/totalClients) /item.Capacity__c *10000;
             } else {
                 item.Actual_Client_Share__c = 0;
                 item.Workload__c = 0;
             }
             membersToUpdate.add(item);
        }
        
        try{
            update membersToUpdate;
        }
        catch(Exception e){
            System.debug(e.getMessage());
        }
    }
}