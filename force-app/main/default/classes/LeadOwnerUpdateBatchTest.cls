@isTest
public class LeadOwnerUpdateBatchTest {
    static Lead ld;
    static list<QueueSobject> queue;
    static Project__c pjR;     
    
    
    static testMethod void updateOwnerBatch() {
      //  pjR = TestDataFactory.createResProject(1)[0];
       // insert pjR;
         User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name =: 'PMT Users'].Id,
            LastName = 'last',
            Email = 'Oberoi'+Math.random()+'@test.com',
            Username = 'Oberoi'+Math.random()+'@test.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        ); 
        queue = [select Id, queueId, queue.Name from QueueSobject where sobjectType =:'Lead' and 
                 queue.Name =:system.label.PMT_Team LIMIT 1];
        ld = TestDataFactory.createResLead(1)[0];
        ld.LeadSource = 'Web';
       // ld.Project__c =pjR.Id; 
        system.runAs(u){     
        insert ld;
        }
        // ld.OwnerId =queue[0].queueId;
        //update ld;
        Test.startTest();
        LeadOwnerUpdateBatch x = new LeadOwnerUpdateBatch();
        database.executeBatch(x);
        Test.stopTest();
    }
}