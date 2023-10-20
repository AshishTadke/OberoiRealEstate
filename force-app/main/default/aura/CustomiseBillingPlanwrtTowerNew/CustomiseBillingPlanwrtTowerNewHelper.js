({
    createObjectData: function(component, event,helper) {
        
        var RowItemList = component.get("v.finalMList");
        var rowIndex = event.currentTarget.parentElement.parentElement.id ;
        console.log('rowIndex',rowIndex);
        var txtVal = RowItemList[rowIndex].Payment_Plan_Line_Item_Name__c;
        var txtValkey = RowItemList[rowIndex].Terms_of_Payment_Key__c;
        console.log('txtValkeytxtValkey'+txtValkey);
        var maxLimitCheck =  this.checkMaxLimit(component, event, helper, txtValkey);
        
        if(maxLimitCheck == true){
          
            rowIndex++;
            RowItemList.splice(rowIndex,0,{            
                'Order__c': '',
                'Payment_Plan_Line_Item_Name__c': txtVal,
                'Description__c' : txtVal,
                'Terms_of_Payment_Key__c': txtValkey,
                'Due_After_Days__c':'',
                'Percentage_Of_Value_To_Be_Invoiced__c':''
            });
            
            component.set("v.finalMList", RowItemList);
        }
       
    },
    checkPercLimit : function(component, event, helper,targetValue,keyid) {
        var RowItemList = component.get("v.finalMList");
        var PercentageSum = 0.00;
        var RationalPercent = 0.00;
        var targetValue1 = component.get("v.changePercent");
        RowItemList[keyid].Percentage_Of_Value_To_Be_Invoiced__c = targetValue;
       for(var j = 0; j < RowItemList.length; j++){
            //  alert('before',RowItemList[j].Percentage_Of_Value_To_Be_Invoiced__c);
            if(RowItemList[j].Percentage_Of_Value_To_Be_Invoiced__c == undefined){
                //   alert('Percentage field is mandatory');
            }
            else{
                if(RowItemList[j] != RowItemList[keyid]){
                	PercentageSum += parseFloat(RowItemList[j].Percentage_Of_Value_To_Be_Invoiced__c);
                }
            	if(RowItemList[j].Terms_of_Payment_Key__c == 'IN00' ||
                  RowItemList[j].Terms_of_Payment_Key__c == 'IN01'){
                    if(RowItemList[j] != RowItemList[keyid]){
                   		RationalPercent += parseFloat(RowItemList[j].Percentage_Of_Value_To_Be_Invoiced__c);
            	    }
                }
            }
        }
        if(RowItemList[keyid].Terms_of_Payment_Key__c == 'IN00' ||
         RowItemList[keyid].Terms_of_Payment_Key__c == 'IN01'){
            RationalPercent += parseFloat(RowItemList[keyid].Percentage_Of_Value_To_Be_Invoiced__c);
        }
        PercentageSum += parseFloat(RowItemList[keyid].Percentage_Of_Value_To_Be_Invoiced__c);
       	RowItemList[keyid].Percentage_Of_Value_To_Be_Invoiced__c = targetValue;
        component.set("v.finalMList",RowItemList);
		component.set('v.totalPercentage',PercentageSum);
        if(RationalPercent > 25){
            this.showToast(component, event, helper,'IN Slab Percentage is '+RationalPercent+'%','error','dismissible');
        }
        if(PercentageSum != 100.00){
            this.showToast(component, event, helper,'Total Percentage is '+PercentageSum+'%', 'warning','pester');
            this.calcAmountVal(component, event, helper);
        }
        else{
            this.calcAmountVal(component, event, helper);
        }
    },
    calcAmountVal : function(component, event, helper){
        var target = event.target.id;  
        var targetValue = event.target.value;  
        var clickId = target;		//0-perBSP
        var len = clickId.length;   //8
        var index = clickId.indexOf("-");
        var keyid = clickId.substr(0,(index));
        var totalCostPlan=component.get('v.billingplan');
        var totalCost = totalCostPlan[0].Total_Sales_Amount__c;
        var perAmount = (totalCost/100)*targetValue;
        var roundPerAmount = parseFloat(perAmount).toFixed(2);
        document.getElementById(keyid+"-amountBSP").value= roundPerAmount;  
        var RowItemList = component.get("v.finalMList");
        //  alert('after ',RowItemList[1].Percentage_Of_Value_To_Be_Invoiced__c);
		console.log('roundPerAmountroundPerAmountroundPerAmount'+totalCost);
		component.set('v.totalSalesAmount',totalCost);
    },
    checkMaxLimit : function(component, event, helper, txtValkey) {
        //   alert('max');
        var RowItemList = component.get("v.finalMList");
        //  var target = event.getSource();  
        // var txtVal = target.get("v.value") ;
        //  alert(RowItemList);
        //console.log('AdityaBhasin'+txtValkey);
        var milList = component.get("v.metadata"); 
        var maxCount;
        //console.log('AdityaBhasinAdityaBhasin'+milList.length);
        for (var i = 0; i < milList.length; i++) {
            console.log('NameNameName'+milList[0].Name);
            console.log('txtValkey'+txtValkey);
            console.log('Max_Occurrence__cMax_Occurrence__c'+milList[0].Max_Occurrence__c);
            if(milList[i].Name==txtValkey){
                maxCount= milList[i].Max_Occurrence__c;
                break;
            }
            /*else if(txtVal=='To be paid on or Before'){
                maxCount=5;
                break;
            }*/
        }
        console.log('maxCountmaxCount'+maxCount);
        
        console.log('txtValkeytxtValkey'+txtValkey);
        var count = 0;
        for (var j = 0; j < RowItemList.length; j++) {
            console.log('Terms_of_Payment_Key__c'+RowItemList[j].Terms_of_Payment_Key__c);
            if(RowItemList[j].Terms_of_Payment_Key__c == txtValkey){
                count++;
            }
        }
        console.log('countcount'+count);
        if( count >= maxCount){
            //  target.set("v.errors", [{message:"Limit Exceed"}]);
            this.showToast(component, event, helper,'Limit Exceed for Payment Term--.'+txtValkey, 'error','dismissible');
            return false;
        } 
        else{
            // target.set("v.errors", null);   
            return true;
        }
    },
    checkMinLimit : function(component, event, helper, txtValkey) {
	//	alert('Min Call');
        var RowItemList = component.get("v.finalMList");
        console.log('Min Call'+txtValkey);
        var milList = component.get("v.metadata"); 
        var minCount;
        for (var i = 0; i < milList.length; i++) {
            if(milList[i].Terms_of_Payment_Key__c==txtValkey){
                minCount= milList[i].Min_Occurrence__c;
                break;
            }
            /*else if(txtVal=='To be paid on or Before'){
                minCount=1;
                break;
            }*/
        }
        console.log(minCount);
        var count = 0;
        for (var j = 0; j < RowItemList.length; j++) {
            if(RowItemList[j].Terms_of_Payment_Key__c == txtValkey){
                count++;
            }
        }
        console.log('count');
          console.log(count);
        if( count == minCount){
            //  target.set("v.errors", [{message:"Limit Exceed"}]);
            this.showToast(component, event, helper,'You cannot delete this line item.', 'error','dismissible');
            return false;
        } 
        else{
            return true;
        }
    },
    
    loadPropDetailsData : function(component, event, helper) {
        var action = component.get('c.getBillingPlanDetails');
        var billingPlanValue = component.get("v.billingPlanId");
        console.log('@@billingPlanValue'+billingPlanValue);
        action.setParams({
            bpID : billingPlanValue           
        });
        action.setCallback(this, function(res) { 
            this.handleCallback(component, event, helper,res);                     
        });
        $A.enqueueAction(action);  
    },
    handleCallback : function(component, event, helper,res){
        if (res.getState() === 'SUCCESS') {
            var result = res.getReturnValue();
            var resultValue = JSON.stringify(result);
            var milList =[]; 
            if(!$A.util.isEmpty(resultValue) && !$A.util.isUndefined(resultValue)){
                component.set("v.ppList",result);              
            }     
            var milList = component.get("v.ppList");         
            component.set('v.finalMList', milList[0].bplitemList);
            console.log('@@metadata'+JSON.stringify(milList[0].metadataGroupingList));
            component.set('v.metadata',milList[0].metadataGroupingList);
        }
    },
    
    //To Save Billing Plan Line Items 
    saveData : function(component, event, helper) {
        //  alert('Save 111 ');
        var mList = [];
        mList = component.get("v.finalMList");
        console.log('mListmListmListmListmList'+mList);
        console.log('mListmListmListmListmList'+JSON.stringify(mList));
        
        var i=1;
        for(var j = 0; j < mList.length; j++){
            //  alert('j'+j);
            //  alert('j+1'+j+1);
            //   alert('Add-->'+parseInt(j)+1);
            // alert('Before'+mList[j].Sequence_Number__c);
            
            mList[j].Sequence_Number__c=parseInt(j)+parseInt(i);
            //  alert('After'+mList[j].Sequence_Number__c);
            // alert( mList[i].Sequence_Number__c);
            //alert(j);
            //   alert('j+1 after'+j+1);
            // alert('@@'+mList[j].Sequence_Number__c);
        }
        
        //  alert('mList'+JSON.stringify(mList)); 
        var action = component.get('c.saveWrapperDetails');
        action.setParams({
            billingPlanId : component.get("v.billingPlanId"),
            bpLineList : mList           
        });
        action.setCallback(this, function(res) { 
            helper.handleCallbackForSave(component, event, helper,res);          
        });
        $A.enqueueAction(action);  
    },
    
    handleCallbackForSave : function(component, event, helper,res){
        //  alert('Call');
        if (res.getState() === 'SUCCESS') {
            var result = res.getReturnValue();
            //    alert(result);
            if(result=='Missing Fields'){
                this.showToast(component, event, helper,'Please enter all required fields: Name,Percentage & Due After Days', 'error','dismissible');
                //  alert('Please enter all required fields: Name,Percentage & Due After Days');
            }
            else if(result=='Percentage zero'){
                this.showToast(component, event, helper,'Percentage value cannot be 0%.', 'error','dismissible');
                // alert('Percentage cannot be more than 100 %');
            }
                else if(result=='Percentage mismatch'){
                    this.showToast(component, event, helper,'Percentage is not equal to 100 %.', 'error','dismissible');
                    // alert('Percentage cannot be more than 100 %');
                }
                    else if(result=='Successful'){
                        this.showToast(component, event, helper,'Billing Plan Line Items has been updated successfully.', 'success','pester');
                        // alert('Successful');
                        this.navigateToObj(component, event, helper,component.get("v.billingPlanId"));
                    }
        } 
        else if(res.getState() === "ERROR"){
            console.log(res.getReturnValue()+'%%');
            alert('Error in Server calling action.');
        }
    },
    navigateToObj : function (component, event, helper,recId) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recId,
            "slideDevName": "detail"
        });
        navEvt.fire();
    },
    navigateToOpp : function (component, event, helper) {
        var action = component.get('c.deleteBillingPlanOnCancel');
        action.setParams({
            ppObj : component.get("v.billingPlanId")
        });
        action.setCallback(this, function(res) { 
            if (res.getState() === 'SUCCESS') {
                this.navigateToObj(component, event, helper,component.get("v.oppId"));
            }                   
        });
        $A.enqueueAction(action); 
    },
    loadBillingPlanObj : function(component, event, helper) {
        var action = component.get("c.BillingPlanObj");
        action.setParams({ bpId : component.get("v.billingPlanId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var output =component.set('v.billingplan',result);
              //  this.calculateTotalAmount(component, event,helper);
            }
            else if (state === "ERROR") {
            }
        });
        $A.enqueueAction(action); 
    },
    showToast : function(component, event, helper,message, type, mode) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message:message,
            duration:' 5000',
            type: type,
            mode: mode
        });
        toastEvent.fire();
    },
})