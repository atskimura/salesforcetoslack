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

        if (slackMsg.IsAttachmentFormat__c) {
            Attachments at = new Attachments();
            at.text = msg.text;
            if (String.isNotBlank(slackMsg.AuthorName__c)) 
                at.author_name = slackMsg.AuthorName__c;
            if (String.isNotBlank(slackMsg.AuthorLink__c)) 
                at.author_link = slackMsg.AuthorLink__c;
            if (String.isNotBlank(slackMsg.AuthorIcon__c)) 
                at.author_icon = slackMsg.AuthorIcon__c;
            if (String.isNotBlank(slackMsg.Fallback__c)) 
                at.fallback = slackMsg.Fallback__c;
            if (String.isNotBlank(slackMsg.Pretext__c)) 
                at.pretext = slackMsg.Pretext__c;
            if (String.isNotBlank(slackMsg.Title__c)) 
                at.title = slackMsg.Title__c;
            if (String.isNotBlank(slackMsg.TitleLink__c)) 
                at.title_link = slackMsg.TitleLink__c;
            if (String.isNotBlank(slackMsg.ImageUrl__c)) 
                at.image_url = slackMsg.ImageUrl__c;
            if (String.isNotBlank(slackMsg.ThumbUrl__c)) 
                at.thumb_url = slackMsg.ThumbUrl__c;
            if (String.isNotBlank(slackMsg.Color__c)) {
                at.color = slackMsg.Color__c;
            } else {
                at.color = '#009CDB';       //SFDC Blue
            }
                
            if (String.isNotBlank(slackMsg.FieldsTitle1__c) && String.isNotBlank(slackMsg.FieldsValue1__c )) {
                Fields fmsg = new Fields();
                fmsg.title = slackMsg.FieldsTitle1__c;
                fmsg.value = slackMsg.FieldsValue1__c;
                if (String.isNotBlank(slackMsg.FieldsShort1__c)) {
                    fmsg.shortValue = Boolean.valueOf(slackMsg.FieldsShort1__c);
                } else {
                    fmsg.shortValue = false;
                }
                at.fields.add(fmsg);
            }
            if (String.isNotBlank(slackMsg.FieldsTitle2__c) && String.isNotBlank(slackMsg.FieldsValue2__c )) {
                Fields fmsg = new Fields();
                fmsg.title = slackMsg.FieldsTitle2__c;
                fmsg.value = slackMsg.FieldsValue2__c;
                if (String.isNotBlank(slackMsg.FieldsShort2__c)) {
                    fmsg.shortValue = Boolean.valueOf(slackMsg.FieldsShort2__c);
                } else {
                    fmsg.shortValue = false;
                }
                at.fields.add(fmsg);
            }
                
            msg.attachments.add(at);
        }

        sendMessage(msg, slackMsg.IsAttachmentFormat__c);
    }
    
    private static void sendMessage(Message msg, Boolean isAttachment) {
        //sendMessage(JSON.serialize(msg));
        String jsonMsg = JSON.serialize(msg);
        if (isAttachment) {
            sendMessage(jsonMsg.replace('shortValue', 'short'));
        } else {
            sendMessage(jsonMsg);
        }
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
        public List<Attachments> attachments;   //Attachment Support
        public Message() {
            this.username = 'Salesforce';
            this.icon_emoji = ':cloud:';
            attachments = new List<Attachments>(); 
        }
    }

    public class Attachments {
        public String mkdwn_in = '[\'text\']';
        public String author_name {get; set;}
        public String author_link {get; set;}
        public String author_icon {get; set;}
        public String fallback {get; set;}
        public String pretext {get; set;}
        public String title {get; set;}
        public String title_link {get; set;}
        public String text {get; set;}
        public String image_url {get; set;}
        public String thumb_url {get; set;}
        public String color {get; set;}
        public List<Fields> fields {get; set;}
        
        public Attachments() {
            fields = new List<Fields>();
        }
    }
    
    public class Fields {
        public String title {get; set;}
        public String value {get; set;}
        public Boolean shortValue {get; set;}       //"short" is actual key name in Attachment format
    }
}