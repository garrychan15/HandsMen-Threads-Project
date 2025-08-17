trigger LoyaltyStatusUpdate on HandsMen_Customer__c (before insert, before update) {

    for (HandsMen_Customer__c customer : Trigger.new) {

        if (customer.Total_Purchases__c != null) {
            
            if (customer.Total_Purchases__c > 1000) {
                
                customer.Loyalty_Status__c = 'Gold';
            } else if (customer.Total_Purchases__c < 500) {
                
                customer.Loyalty_Status__c = 'Bronze';
            } else {
                
                customer.Loyalty_Status__c = 'Silver';
            }
        }
    }
}