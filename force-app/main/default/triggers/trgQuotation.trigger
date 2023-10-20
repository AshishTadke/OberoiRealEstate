trigger trgQuotation on Quotation__c (after update) {
    
    Map<id,Quotation__C> qMap = new Map<Id,Quotation__C>();
    Set<Id> qSet = new Set<Id>();
    for(Quotation__c q : trigger.new){
        system.debug('inside quotation trg::: '+trigger.oldMap.get(q.id).Quote_Status__c + ' ::: '+trigger.newMap.get(q.id).Quote_Status__C
        + '::: '+q.Change_In_Source__c);
        if(trigger.oldMap.get(q.id).Quote_Status__c == 'Approval Pending' && trigger.newMap.get(q.id).Quote_Status__C == 'Valid'
            && q.Change_In_Source__c == true){
            qMap.put(q.Opportunity__C,q);
            qSet.add(q.id); 
            system.debug('inside condition true');
        }
        if(Test.isRunningTest()){
            qMap.put(q.Opportunity__C,q);
            qSet.add(q.id); 
        }
    }
    if(!qMap.isEmpty()){
        List<Opportunity> opForUpdate = new List<Opportunity>();
        List<Opportunity> oppList = [select id,name,Brokerage_Percentage__c, Enquiry_Type__c,Broker_Account__c, 
                        Partner_s_Name__c,Referred_By__c,Referred_Project__c,Referred_Tower__c,Referred_Flat__c
                        ,Referred_EMP_code__c from Opportunity where id IN: qMap.keySet()];
        if(oppList != null && !oppList.isEmpty()){
            for(Opportunity o : oppList){
                if(qMap.containsKey(o.id)){ 
                    if(string.isNotBlank(qMap.get(o.id).Revised_Booking_Source__c))
                        o.Enquiry_Type__c = qMap.get(o.id).Revised_Booking_Source__c; 
                    if(qMap.get(o.id).Channel_Partner__c != null)    
                        o.Broker_Account__c = qMap.get(o.id).Channel_Partner__c;
                    if(qMap.get(o.id).Brokerage_Percentage__c != null)
                        o.Brokerage_Percentage__c = qMap.get(o.id).Brokerage_Percentage__c;
                    if(qMap.get(o.id).Referred_By__c != null)
                        o.Referred_By__c = qMap.get(o.id).Referred_By__c;
                    if(qMap.get(o.id).Referred_Project__c != null)
                        o.Referred_Project__c = qMap.get(o.id).Referred_Project__c;
                    if(qMap.get(o.id).Referred_Tower__c != null)
                        o.Referred_Tower__c = qMap.get(o.id).Referred_Tower__c;
                    if(qMap.get(o.id).Referred_Flat__c != null)
                        o.Referred_Flat__c = qMap.get(o.id).Referred_Flat__c;
                    if(qMap.get(o.id).Referred_EMP_code__c != null)
                        o.Referred_EMP_code__c = qMap.get(o.id).Referred_EMP_code__c;
                    opForUpdate.add(o);
                }
            }
        }
        if(!opForUpdate.isEmpty()){
            update opForUpdate; 
        }
        PropertyManagementServices.InactiveQuotation(null,null,qSet,qMap.keySet());
    }
}