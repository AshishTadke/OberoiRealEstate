@isTest
public class WebToLeadTest {
    static Campaign camp;
    static Project__c proj;
    
    static testMethod void createTestData(){
        WebToLeadResponse wLResp= new WebToLeadResponse();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        camp = TestDataFactory.createCampaign(1)[0];
        proj = TestDataFactory.createResProject(1)[0];
        camp.RecordTypeId = TestDataFactory.campAdvertisementId;
        camp.Advertisement_Cost__c = 234; 
        camp.Tracking_Code__c ='TESTTT'; 
        insert camp;
        proj.Project_Code__c = '12TES'; 
        insert proj;       
        req.addHeader('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response= res; 
        WebToLead.doPost('Dr.','test'+ Math.random(),'test','test'+ Math.random(),'test@tete'+ Math.random()+'.com','+91','6475657685','12TES','NRI','2.5 cr - 3.5 cr','2 BHK',system.Now(),'test','TESTTT','test.com11'); 
        WebToLead.doPost('Dr.','test111'+ Math.random(),'test111','test111'+ Math.random(),'test@tete1'+ Math.random()+'.com','+91','6475657685','12TES','NRI','2.5 cr - 3.5 cr','2 BHK',system.Now(),'test','TESTTT','test.com11');
        WebToLead.doPost('Dr.','test111'+ Math.random(),'test111','','test@tete1'+ Math.random()+'.com','+91','6475657685','12TES','NRI','2.5 cr - 3.5 cr','2 BHK',system.Now(),'test','TESTTT','test.com11'); 
        WebToLeadResponse.parse('{"status":"SUCCESS","message":"lead inserted"}');
        
    }
    
}