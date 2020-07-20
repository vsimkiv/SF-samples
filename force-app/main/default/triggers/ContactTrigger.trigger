trigger ContactTrigger on Contact (before insert, before update, before delete,  
                                   after insert, after update, after delete, after undelete) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
        }else if (Trigger.isUpdate) {
        }else if (Trigger.isDelete) {
        }
    }else if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            System.debug('Hello from Insert');
            ContactTriggerHandler.updateStatusOfRelatedAccounts(Trigger.new);
            ContactTriggerHandler.updateClosestBirthdate(Trigger.new);
        }else if (Trigger.isUpdate) {
            System.debug('Hello from Update');
            ContactTriggerHandler.updateStatusOfRelatedAccounts(Trigger.old, Trigger.new);
            ContactTriggerHandler.updateClosestBirthdate(Trigger.old, Trigger.new);
        }else if (Trigger.isDelete) {
            System.debug('Hello from Delete');
            ContactTriggerHandler.updateStatusOfRelatedAccounts(Trigger.old);
            ContactTriggerHandler.updateClosestBirthdate(Trigger.old);
        }else if (Trigger.isUndelete) {
            System.debug('Hello from Undelete');
            ContactTriggerHandler.updateStatusOfRelatedAccounts(Trigger.new);
            ContactTriggerHandler.updateClosestBirthdate(Trigger.new);
        }
    }
}