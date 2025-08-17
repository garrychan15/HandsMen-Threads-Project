@isTest
public class LoyaltyPointsCalculationBatchJobTest {
    
    @testSetup
    static void setupTestData() {
        List<HandsMen_Customer__c> customers = new List<HandsMen_Customer__c>();

        customers.add(new HandsMen_Customer__c(
            Name = 'Gold Customer',
            Loyalty_Status__c = 'Gold',
            Loyalty_Points__c = 100
        ));
        customers.add(new HandsMen_Customer__c(
            Name = 'Silver Customer',
            Loyalty_Status__c = 'Silver',
            Loyalty_Points__c = 50
        ));
        customers.add(new HandsMen_Customer__c(
            Name = 'Bronze Customer',
            Loyalty_Status__c = 'Bronze',
            Loyalty_Points__c = 25
        ));
        customers.add(new HandsMen_Customer__c(
            Name = 'New Customer',
            Loyalty_Status__c = null,
            Loyalty_Points__c = null
        ));
        
        insert customers;
    }
    
    @isTest
    static void testBatchJobExecution() {

        Test.startTest();
        LoyaltyPointsCalculationBatchJob job = new LoyaltyPointsCalculationBatchJob();
        Database.executeBatch(job, 200);
        Test.stopTest();
        
        List<HandsMen_Customer__c> updatedCustomers = [
            SELECT Name, Loyalty_Points__c, Loyalty_Status__c
            FROM HandsMen_Customer__c
        ];
        
        for (HandsMen_Customer__c cust : updatedCustomers) {
            if (cust.Name == 'Gold Customer') {
                System.assertEquals(120, cust.Loyalty_Points__c, 'Gold customer should get +20 points');
            } else if (cust.Name == 'Silver Customer') {
                System.assertEquals(60, cust.Loyalty_Points__c, 'Silver customer should get +10 points');
            } else if (cust.Name == 'Bronze Customer') {
                System.assertEquals(30, cust.Loyalty_Points__c, 'Bronze customer should get +5 points');
            } else if (cust.Name == 'New Customer') {
                System.assertEquals(0, cust.Loyalty_Points__c, 'Customer with null status should remain at 0 points');
            }
        }
    }

    @isTest
    static void testSchedulableExecution() {
        Test.startTest();
        String cronExp = '0 0 0 ? * MON'; 
        System.schedule('Test Loyalty Points Scheduler', cronExp, new LoyaltyPointsCalculationBatchJob());
        Test.stopTest();
    }
}