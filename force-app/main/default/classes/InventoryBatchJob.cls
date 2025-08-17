global class InventoryBatchJob implements Database.Batchable<SObject>, Schedulable {

    global Database.QueryLocator start(Database.BatchableContext bc) {

        return Database.getQueryLocator(
            'SELECT Id, Stock_Quantity__c FROM HandsMen_Product__c WHERE Stock_Quantity__c < 10'
        );
    }

    global void execute(Database.BatchableContext bc, List<SObject> records) {

        List<HandsMen_Product__c> productsToUpdate = new List<HandsMen_Product__c>();

        for (SObject record : records) {

            HandsMen_Product__c product = (HandsMen_Product__c) record;
            product.Stock_Quantity__c += 50; 
            productsToUpdate.add(product);
        }

        if (!productsToUpdate.isEmpty()) {

        	update productsToUpdate;
        }
    }
    global void finish(Database.BatchableContext bc) {

        System.debug('Inventory Sync Completed');
    }

    global void execute(SchedulableContext sc) {

        InventoryBatchJob batchJob = new InventoryBatchJob();
        Database.executeBatch(batchJob, 200);
    }
}