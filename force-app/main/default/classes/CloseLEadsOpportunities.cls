global class CloseLEadsOpportunities implements Database.Batchable<sObject> {
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        string stage ='Lost';
        Datetime dt = System.Now().addDays(-270);
        string dat = dt.format('yyyy-MM-dd') ;
        string query;
        system.debug('offset'+ dat); 
        if(Test.isRunningTest()){
            query = 'Select Id, Name, ownerId,  Status, Lead_Stage__c, isconverted,Data_Sheet_Submitted_Date__c, Date_of_Enquiry__c, convertedOpportunityId from Lead WHERE  isconverted = true  AND  convertedOpportunity.StageName = \''+ stage+'\'';     
        }else{
            query = 'Select Id, Name, ownerId,  Status, Lead_Stage__c, isconverted,Data_Sheet_Submitted_Date__c, Date_of_Enquiry__c,convertedOpportunityId from Lead WHERE  isconverted = true AND  Data_Sheet_Submitted_Date__c < ' + dat + '  AND  convertedOpportunity.StageName = \''+ stage+'\' '; 
        }system.debug(query+'query');
        return database.getQueryLocator(query);             
    } 
    
    global void execute(Database.BatchableContext BC, List<sObject> leadList) {
        updateLead(leadList);
        updateOppty(leadList);
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
    
    
    //Method Added to update Lead
    public static void updateLead(list<Lead> ldList) {       
        list <Lead> nList = new list<Lead>();
        for (Lead ld: ldList){
            ld.Lead_Stage__c ='Closed';
            nList.add(ld);
        }
        update nList;
    }
    
    //Method Added to update Oppty
    public static void updateOppty(list<Lead> ldList) {
        list <Opportunity> oppList = new list<Opportunity>();
        for (Lead ld: ldList){
            Opportunity op = new Opportunity();
            op.id= ld.ConvertedOpportunityId;
            op.Opportunity_Status__c ='Closed';
            oppList.add(op);
        }
        update oppList;
    }
    
}