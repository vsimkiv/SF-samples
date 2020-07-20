public class TriggerUtils {
    public static Boolean isChangedOrIsNew(SObject oldRecord, SObject newRecord, String fieldToCheck){
        if(oldRecord == null)
            return true;
        try {
            if(newRecord.get(fieldToCheck) != oldRecord.get(fieldToCheck))
                return true;
        } catch (Exception e){
            return false;
        }
        return false;
    }
    
    public static Boolean isChangedOrIsNew(SObject newRecord, Map<Id, SObject> oldMap, String fieldToCheck){
        if(oldMap == null || oldMap.get((Id) newRecord.get('Id')) == null) {
            return true;
        }
        
        try {
            if(newRecord.get(fieldToCheck) != oldMap.get((Id) newRecord.get('Id')).get(fieldToCheck)) {
                return true;
            }
        } catch (Exception e){
            return false;
        }
        
        return false;
    }
}