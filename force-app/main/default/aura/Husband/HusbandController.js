({
	getMessage : function(component, event, helper) {
		let ps = event.getParam('arguments');
        if (ps) {
            let p1 = ps.Name;
            return "Hello " + p1 + " from husband";
        }
        return "no param";
	}
})