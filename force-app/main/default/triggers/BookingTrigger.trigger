trigger BookingTrigger on Booking__c (before update, After Insert,After Update, Before Insert) {
 
    if(Trigger.isAfter && Trigger.isInsert){
         String Projectid ='';
         String BrokerCode ='';
         List<Account> a = new List<Account>();
         List<Channel_Partner_Project__c> CPProjetList = new List<Channel_Partner_Project__c>();  
            for(booking__c b :trigger.new){
            If(B.Booking_Through__c == 'Partner'){
            Id cpRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel Partner').getRecordTypeId();
                If(B.Booking_Through__c == 'Partner' && B.Vendor_Code__c != ''){
                    BrokerCode = b.Vendor_Code__c;
                    Projectid  = B.Project__c ;
                }
                 a= [Select Id, Name,Broker_Code__c From Account Where Broker_Code__c =: BrokerCode AND recordtypeid =: cpRecordTypeId];
                 CPProjetList = [Select Id, Name,account__c,Extended__c,account__r.Broker_Code__c FROM Channel_Partner_Project__c WHERE Project__c =:Projectid AND account__r.Broker_Code__c =: BrokerCode order by CreatedDate desc limit 1];
                 if(CPProjetList.size()>0){
                                       
                 }Else{
                    Channel_Partner_Project__c CPProj = new Channel_Partner_Project__c ();
                    CPProj.Account__c = a[0].id;
                    CPProj.Project__c = Projectid ;
                    insert CPProj;                 
                 }
                 }Else{}
                                  
            }
    }
}