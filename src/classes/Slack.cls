public class Slack {
    public static void sendMessage(SlackMessage__c slackMsg) {
        if (String.isEmpty(slackMsg.Text__c))
            return;
        Message msg = new Message();
        // Temporary fix for https://success.salesforce.com/issues_view?id=a1p300000008YkZAAU
        msg.text = slackMsg.Text__c.replaceAll('_BR_ENCODED_', '\n');
        if (String.isNotEmpty(slackMsg.Channel__c))
            msg.channel = slackMsg.Channel__c;
        if (String.isNotEmpty(slackMsg.IconUrl__c)) {
            msg.icon_url = slackMsg.IconUrl__c;
            msg.icon_emoji = null;
        }
        if (String.isNotEmpty(slackMsg.IconEmoji__c))
            msg.icon_emoji = slackMsg.IconEmoji__c;
        if (String.isNotEmpty(slackMsg.Username__c))
            msg.username = slackMsg.Username__c;
        sendMessage(msg);
    }
    
    private static void sendMessage(Message msg) {
        sendMessage(JSON.serialize(msg));
    }
    
    @future (callout=true)
    private static void sendMessage(String msg) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(SlackSettings__c.getInstance().WebhookUrl__c);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(msg);
        HttpResponse res = http.send(req);
    }
    
    public class Message {
        public String text {get;set;}
        public String channel {get;set;}
        public String icon_emoji {get;set;}
        public String icon_url {get;set;}
        public String username {get;set;}
        public Message() {
            this.username = 'Salesforce';
            this.icon_emoji = ':cloud:';
        }
    }
}