@isTest
public class InventoryBatchJobTest {

    @testSetup
    static void setupTestData() {
        
        HandsMen_Product__c product = new HandsMen_Product__c(
            Name = 'Test Product',
            Price__c = 100,
            Stock_Quantity__c = 5
        );
		insert product;
    }

    @isTest
    static void testBatchExecution() {

        HandsMen_Product__c lowStock = [
            SELECT Id, Stock_Quantity__c 
            FROM HandsMen_Product__c 
            WHERE Stock_Quantity__c < 10 
            LIMIT 1
        ];

        Test.startTest();

        InventoryBatchJob job = new InventoryBatchJob();
        Database.executeBatch(job, 200);
        Test.stopTest();

        HandsMen_Product__c updated = [
            SELECT Stock_Quantity__c 
            FROM HandsMen_Product__c 
            WHERE Id = :lowStock.Id
        ];
        System.assertEquals(55, updated.Stock_Quantity__c, 'Stock should have increased by 50');
    }
    
    @isTest
    static void testSchedulableExecution() {
        Test.startTest();
        InventoryBatchJob batchJob = new InventoryBatchJob();
        String cronExp = '0 0 0 ? * MON'; 
        System.schedule('Test Inventory Scheduler', cronExp, batchJob);
        Test.stopTest();
    }
}
