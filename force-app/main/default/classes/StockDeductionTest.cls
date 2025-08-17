@isTest
public class StockDeductionTest {

    @testSetup
    static void setupData() {
        HandsMen_Product__c product = new HandsMen_Product__c(
            Name = 'Test Product',
            Price__c = 100
        );
        insert product;

        HandsMen_Customer__c customer = new HandsMen_Customer__c(
            Name = 'Test Customer',
            Email__c = 'testemail@gmail.com'
        );
        insert customer;

        Inventory__c inventory = new Inventory__c(
            Product__c = product.Id,
            Stock_Quantity__c = 50
        );
        insert inventory;
    }

    @isTest
    static void testStockDeductionOnInsert() {
        HandsMen_Product__c product = [SELECT Id FROM HandsMen_Product__c LIMIT 1];
        Inventory__c invBefore = [SELECT Id, Stock_Quantity__c FROM Inventory__c WHERE Product__c = :product.Id LIMIT 1];
        HandsMen_Customer__c customer = [SELECT Id FROM HandsMen_Customer__c LIMIT 1];

        HandsMen_Order__c order = new HandsMen_Order__c(
            Customer__c = customer.Id,
            HandsMen_Product__c = product.Id,
            Quantity__c = 5,
            Status__c = 'Confirmed'
        );

        Test.startTest();
        insert order;
        Test.stopTest();

        Inventory__c invAfter = [SELECT Stock_Quantity__c FROM Inventory__c WHERE Id = :invBefore.Id];
        System.assertEquals(invBefore.Stock_Quantity__c - 5, invAfter.Stock_Quantity__c,
            'Stock should decrease by order quantity on insert');
    }

    @isTest
    static void testStockDeductionOnUpdateStatusChange() {
        HandsMen_Product__c product = [SELECT Id FROM HandsMen_Product__c LIMIT 1];
        Inventory__c invBefore = [SELECT Id, Stock_Quantity__c FROM Inventory__c WHERE Product__c = :product.Id LIMIT 1];
        HandsMen_Customer__c customer = [SELECT Id FROM HandsMen_Customer__c LIMIT 1];
    
        HandsMen_Order__c order = new HandsMen_Order__c(
            Customer__c = customer.Id,
            HandsMen_Product__c = product.Id,
            Quantity__c = 3,
            Status__c = 'Pending',
            Customer_Email_Address__c = 'test@gmail.com'
        );
        insert order;
   
        Test.startTest();
        order.Status__c = 'Confirmed';
        update order;
        Test.stopTest();
    
        Inventory__c invAfter = [SELECT Stock_Quantity__c FROM Inventory__c WHERE Id = :invBefore.Id];
        System.assertEquals(invBefore.Stock_Quantity__c - 3, invAfter.Stock_Quantity__c,
            'Stock should decrease by order quantity when status changes to Confirmed');
    }
}