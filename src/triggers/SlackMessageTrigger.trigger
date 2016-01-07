trigger SlackMessageTrigger on SlackMessage__c (after insert) {
  if(Trigger.isAfter && Trigger.isInsert) {
        SlackMessageTriggerHandler.handleAfterInsert(Trigger.new);
    }
}