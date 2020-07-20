({    
    doInit: function(component,event,helper){
        var action = component.get('c.getMembers');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS' && component.isValid()){
                var result = response.getReturnValue();
                component.set('v.members', result);
            }else{
                alert('ERROR...');
            }
        });
        $A.enqueueAction(action);
    }
})