global class LoyaltyPointsCalculationBatchJob implements Database.Batchable<SObject>, Schedulable {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        return Database.getQueryLocator([
            SELECT Id, Loyalty_Points__c, Loyalty_Status__c 
            FROM HandsMen_Customer__c
        ]);
    }

    global void execute(Database.BatchableContext bc, List<HandsMen_Customer__c> customers) {
        List<HandsMen_Customer__c> customersToUpdate = new List<HandsMen_Customer__c>();
        
        for (HandsMen_Customer__c cust : customers) {
            
            if (cust.Loyalty_Points__c == null) {
                cust.Loyalty_Points__c = 0;
            }
        
        	if (cust.Loyalty_Status__c == 'Gold') {
                cust.Loyalty_Points__c += 20;
            } else if (cust.Loyalty_Status__c == 'Silver') {
                cust.Loyalty_Points__c += 10;
            } else if (cust.Loyalty_Status__c == 'Bronze') {
                cust.Loyalty_Points__c += 5;
            } else {
                cust.Loyalty_Points__c += 0;
            }

            customersToUpdate.add(cust);
        }
        
        if (!customersToUpdate.isEmpty()) {
            
        	update customersToUpdate;
        	System.debug('Successfully updated' + customersToUpdate.size() + 'Customers\' Loyalty Points!');

            
        }
    }

    global void finish(Database.BatchableContext bc) {
        System.debug('Weekly Customer Points Update Completed');
    }

    global void execute(SchedulableContext sc) {

        LoyaltyPointsCalculationBatchJob batchJob = new LoyaltyPointsCalculationBatchJob();
        Database.executeBatch(batchJob, 200);
    }

    
}