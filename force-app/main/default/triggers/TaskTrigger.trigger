/**********************************************************************************************************************
Version v1.1 - AKohakade - 6-5-2019 - Added debug log
*********************************************************************************************************************/
trigger TaskTrigger on Task (After Insert, After Update, Before Insert, Before Update) {
     Set<id> tskId = new Set<id>();
     Set<id> oppid= new Set<id>();
     List<Task> tskToUpdate = new List<Task>();
     if(trigger.isAfter && trigger.isUpdate){
         for(task tsk :Trigger.new){
             tskid.add(tsk.id);
         }
         /*v1.1*/System.debug('tskid='+tskid);
         TaskTriggerHandler.updateResidentialLead(tskid);
         //TaskTriggerHandler.updateResidentialOpty(tskid);
     }
      if(trigger.isBefore && trigger.isUpdate){
         TaskTriggerHandler.autoCompleteTaskOnOpportunity(Trigger.New,Trigger.OldMap);
     }
     if(trigger.isBefore && trigger.isInsert){
         for(task t :Trigger.new){
             //if(T.WhatId.getSObjectType() == Opportunity.sObjectType){
             String Whatid = string.valueof(T.WhatId);
             if(Whatid.startsWith('006')){
                   oppid.add(T.WhatId);
             }
         }
         if(!oppid.isempty()){
             List<Opportunity> olist = [Select id,Name,Total_Final_Score__c From Opportunity Where Id in: oppid];
             if(olist.size() > 0){
                 for(task t1 :Trigger.new){
                     T1.Total_Final_Score__c = olist[0].Total_Final_Score__c;
                     tskToUpdate.add(t1);
                 }
             }
             //Update tskToUpdate;
         }
     }
}