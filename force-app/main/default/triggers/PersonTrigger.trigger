trigger PersonTrigger on Person__c (before insert, before update, before delete,  
                                   after insert, after update, after delete, after undelete) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
        }else if (Trigger.isUpdate) {
        }else if (Trigger.isDelete) {
        }
    }else if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            PersonTriggerHandler.updateFamily(Trigger.new);
        }else if (Trigger.isUpdate) {
            PersonTriggerHandler.updateFamily(Trigger.old, Trigger.new);
        }else if (Trigger.isDelete) {
            PersonTriggerHandler.updateFamily(Trigger.old);
        }else if (Trigger.isUndelete) {   
            PersonTriggerHandler.updateFamily(Trigger.new);
        }
    }
}