trigger ClientTrigger on Client__c (before insert, 
                                    after insert, after update, after delete) {
	if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            ClientTriggerUtils.distributeClients(Trigger.new);
        }
    }
    
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            ClientTriggerUtils.updateMembers(Trigger.new);
        }
        if (Trigger.isUpdate) {
            ClientTriggerUtils.updateMembers(Trigger.new);
        }
        if (Trigger.isDelete) {
            ClientTriggerUtils.updateMembers(Trigger.new);
        }
    }

}