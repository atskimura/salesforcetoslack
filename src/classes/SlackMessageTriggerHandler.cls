public class SlackMessageTriggerHandler {
    public static void handleAfterInsert(List<SlackMessage__c> slackMsgs) {
        for (SlackMessage__c slackMsg : slackMsgs) {
            Slack.sendMessage(slackMsg);
        }
    }
}