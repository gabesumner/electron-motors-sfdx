({
    recalc : function(component, event, helper) {
        var price = component.get("v.Price");
        if (isNaN(price) || price == null) { price = 0; }
        
        var downpayment = component.get("v.Downpayment");
        if (isNaN(downpayment) || downpayment == null) { downpayment = 0; }
        
        var rate = parseInt(component.get("v.Rate")) / 100;
        if (isNaN(rate) || rate == null) { rate = 0; }
        
        var terms = parseInt(component.get("v.Terms"));
        if (isNaN(terms) || terms == null) { terms = 0; }
        
        var principle = price - downpayment;
        var interest   = (rate * 100) / 1200;
        var monthlyPayment = principle * interest / (1 - (Math.pow(1/(1 + interest), terms)));
        var totalPayment = monthlyPayment * terms;
        
        component.set("v.Price", price.toString());
        component.get("v.Downpayment", downpayment.toString());
        component.get("v.Rate", rate.toString());
        component.get("v.Terms", terms.toString());
        component.set("v.MonthlyPayment", monthlyPayment);
        component.set("v.TotalPayment", totalPayment);
        component.set("v.TotalInterest", totalPayment - principle);
    }
})