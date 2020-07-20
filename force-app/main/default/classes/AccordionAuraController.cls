public class AccordionAuraController {
    @AuraEnabled
    public static List<Member__c> getMembers(){
        List<Member__c> members = new List<Member__c>();
        for(Member__c item : [SELECT Id, Name, Active_Clients__c, Capacity__c, Actual_Client_Share__c, Workload__c, 
                              		(SELECT Id, Name, Active__c 
                               		FROM Clients__r 
                               		ORDER BY Name)
                             FROM Member__c 
                             ORDER BY WorkLoad__c]){
           members.add(item); 
        }
        return members;
    }
}