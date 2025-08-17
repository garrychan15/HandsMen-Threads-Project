@isTest
public class LoyaltyStatusUpdateTest {
    
    @isTest
    static void testBronzeCustomer() {
        HandsMen_Customer__c bronzeCust = new HandsMen_Customer__c(
            Name = 'Bronze Customer',
            Total_Purchases__c = 300
        );
        insert bronzeCust;

        HandsMen_Customer__c result = [SELECT Loyalty_Status__c FROM HandsMen_Customer__c WHERE Id = :bronzeCust.Id];
        System.assertEquals('Bronze', result.Loyalty_Status__c, 'Customer with purchases < 500 should be Bronze');
    }

    @isTest
    static void testSilverCustomer() {
        HandsMen_Customer__c silverCust = new HandsMen_Customer__c(
            Name = 'Silver Customer',
            Total_Purchases__c = 700
        );
        insert silverCust;

        HandsMen_Customer__c result = [SELECT Loyalty_Status__c FROM HandsMen_Customer__c WHERE Id = :silverCust.Id];
        System.assertEquals('Silver', result.Loyalty_Status__c, 'Customer with purchases between 500–1000 should be Silver');
    }

    @isTest
    static void testGoldCustomer() {
        HandsMen_Customer__c goldCust = new HandsMen_Customer__c(
            Name = 'Gold Customer',
            Total_Purchases__c = 1500
        );
        insert goldCust;

        HandsMen_Customer__c result = [SELECT Loyalty_Status__c FROM HandsMen_Customer__c WHERE Id = :goldCust.Id];
        System.assertEquals('Gold', result.Loyalty_Status__c, 'Customer with purchases > 1000 should be Gold');
    }
}