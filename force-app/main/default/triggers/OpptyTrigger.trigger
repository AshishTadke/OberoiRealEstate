trigger OpptyTrigger on Opportunity (after insert, after update, before insert, before update, after delete) {
    
    Set<id> campId = new Set<id>();
    
    if(Trigger.isUpdate) {
    for (Opportunity item : Trigger.new)
        if(item.StageName != trigger.oldMap.get(item.id).StageName && item.StageName == 'Booked'){
            campId.add(item.campaignId);
        }    
    }
    
    if (Trigger.isDelete) {
        for (Opportunity item : Trigger.old)
            campId.add(item.campaignId);
    }
    if(!campId.isEmpty() && !Test.isRunningTest()){
        OpportunityTriggerHandler.updateBookingCountOnCampaign(campId); 
    }
     if(Trigger.isInsert && Trigger.isBefore){
     OpportunityTriggerHandler.beforeInsertOpportunity(Trigger.New);
     OpportunityTriggerHandler.updateApprovalHierarchy(Trigger.New); 
     OpportunityTriggerHandler.populateCountryName(Trigger.New);  
     SiteVisitDateValidator.validateSiteVisitDate(Trigger.new);  
     }
     
     if(Trigger.isUpdate && Trigger.isBefore){
     OpportunityTriggerHandler.beforeUpdateOpportunity(Trigger.newMap, Trigger.oldMap);
     OpportunityTriggerHandler.updateApprovalHierarchyOnUpdate(Trigger.newMap, Trigger.oldMap);
     OpportunityTriggerHandler.populateCountryName(Trigger.New); 
     SiteVisitDateValidator.validateSiteVisitDate(Trigger.new);
    }
    if(Trigger.isUpdate && Trigger.isAfter){
     OpportunityTriggerHandler.AfterUpdateOpportunityStatusBooked(Trigger.newMap);
     // OpportunityTriggerHandler.UpdateBookingDetailsOnOpty(Trigger.newMap, Trigger.old);
     OpportunityHandler1.createCoOwnerAndAcc(Trigger.newMap, Trigger.old);
    }
    
}