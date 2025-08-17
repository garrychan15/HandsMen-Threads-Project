@isTest
public class UpdateOrderTotalTest {
    
    @testSetup
    static void setupData(){
        
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
    }
    
    @isTest
    static void testOrderTotalCalculation() {
        
        HandsMen_Product__c product = [SELECT Id FROM HandsMen_Product__c];
        HandsMen_Customer__c customer = [SELECT Id FROM HandsMen_Customer__c];
        
        HandsMen_Order__c order = new HandsMen_Order__c(
            Customer__c = customer.Id,
            HandsMen_Product__c = product.Id,
            Quantity__c = 3
        );
        insert order;
        
        order = [SELECT Id, Total_Amount__c FROM HandsMen_Order__c WHERE Id = :order.Id];
        
        System.assertEquals(300, order.Total_Amount__c, 'Order total should be calculated correctly');
    }
    
    @isTest
    static void testOrderWithoutProduct() {
        
		HandsMen_Customer__c customer = [SELECT Id FROM HandsMen_Customer__c];
       
        HandsMen_Order__c order = new HandsMen_Order__c(
            Customer__c = customer.Id,
            Quantity__c = 5
        );
        insert order;
        
        order = [SELECT Id, Total_Amount__c FROM HandsMen_Order__c WHERE Id = :order.Id];
        
        System.assertEquals(null, order.Total_Amount__c, 'Total should not be calculated without product');
    }
}