trigger StockDeduction on HandsMen_Order__c (after insert, after update) {
    
    Set<Id> productIds = new Set<Id>();
    
    for (HandsMen_Order__c order : Trigger.new) {
        if (order.Status__c == 'Confirmed' && order.HandsMen_Product__c != null &&
           (Trigger.isInsert || 
            (Trigger.isUpdate && order.Status__c != Trigger.oldMap.get(order.Id).Status__c))) {
               
            productIds.add(order.HandsMen_Product__c);
        }
    }
    
    if (productIds.isEmpty()) return;
    
    // Map ProductId → Inventory
    Map<Id, Inventory__c> productToInventoryMap = new Map<Id, Inventory__c>();
    for (Inventory__c inv : [
        SELECT Id, Stock_Quantity__c, Product__c
        FROM Inventory__c
        WHERE Product__c IN :productIds
    ]) {
        productToInventoryMap.put(inv.Product__c, inv);
    }
    
    List<Inventory__c> inventoriesToUpdate = new List<Inventory__c>();
    
    for (HandsMen_Order__c order : Trigger.new) {
        if (order.Status__c == 'Confirmed' && order.HandsMen_Product__c != null &&
           (Trigger.isInsert || 
            (Trigger.isUpdate && order.Status__c != Trigger.oldMap.get(order.Id).Status__c))) {
            
            Inventory__c inv = productToInventoryMap.get(order.HandsMen_Product__c);
            if (inv != null) {
                inv.Stock_Quantity__c -= order.Quantity__c;
                inventoriesToUpdate.add(inv);
            }
        }
    }
    
    if (!inventoriesToUpdate.isEmpty()) {
        update inventoriesToUpdate;
    }
}