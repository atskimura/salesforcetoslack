@isTest
private class SlackTest {
    @isTest
    static void testSendMessage() {
        Test.setMock(HttpCalloutMock.class, new SlackHttpResponseGenerator());
        
        SlackSettings__c setting = new SlackSettings__c(
            WebhookUrl__c = 'https://hooks.slack.com/services/xxxxxx'
        );
        insert setting;
        
        SlackMessage__c slackMsg = new SlackMessage__c(
            Text__c = 'Text Test',
            Channel__c = '#general',
            IconUrl__c = 'http://xxxxx/icon.png',
            IconEmoji__c = ':monkey_face:',
            Username__c = 'test-bot'
        );
        insert slackMsg;
    }
    
    @isTest
    static void testSendAttachment1() {
        Test.setMock(HttpCalloutMock.class, new SlackHttpResponseGenerator());
        
        SlackSettings__c setting = new SlackSettings__c(
            WebhookUrl__c = 'https://hooks.slack.com/services/xxxxxx'
        );
        insert setting;
        
        SlackMessage__c slackMsg = new SlackMessage__c(
            //Below items never used in attachment format
            IconUrl__c = 'http://xxxxx/icon.png',
            IconEmoji__c = ':monkey_face:',
            Username__c = 'test-bot',

            IsAttachmentFormat__c = true,
            Text__c = 'Text Test',
            Channel__c = '#general',

            AuthorIcon__c = 'http://xxxxx/authericon.png',
            AuthorLink__c = 'http://xxxxx/autherlink.html',
            AuthorName__c = 'Taro Slack',
            Color__c = '#009CDB',
            Fallback__c = 'fallback',
            FieldsShort1__c = 'true',
            FieldsShort2__c = 'true',
            FieldsTitle1__c = 'Field Title1',
            FieldsTitle2__c = 'Field Title2',
            FieldsValue1__c = 'Field Value1',
            FieldsValue2__c = 'Field Value2',
            ImageUrl__c = 'http://xxxxx/image.png',
            Pretext__c = 'Pre-Text',
            ThumbUrl__c = 'http://xxxxx/thumb.png',
            Title__c = 'My Title',
            TitleLink__c =  'http://xxxxx/title.html'
        );
        insert slackMsg;
    }
    
    @isTest
    static void testSendAttachment2() {
        Test.setMock(HttpCalloutMock.class, new SlackHttpResponseGenerator());
        
        SlackSettings__c setting = new SlackSettings__c(
            WebhookUrl__c = 'https://hooks.slack.com/services/xxxxxx'
        );
        insert setting;
        
        SlackMessage__c slackMsg = new SlackMessage__c(
            //Below items never used in attachment format
            IconUrl__c = 'http://xxxxx/icon.png',
            IconEmoji__c = ':monkey_face:',
            Username__c = 'test-bot',

            IsAttachmentFormat__c = true,
            Text__c = 'Text Test',
            Channel__c = '#general',

            AuthorIcon__c = 'http://xxxxx/authericon.png',
            AuthorLink__c = 'http://xxxxx/autherlink.html',
            AuthorName__c = 'Taro Slack',
            Color__c = '',
            Fallback__c = 'fallback',
            FieldsShort1__c = '',
            FieldsShort2__c = '',
            FieldsTitle1__c = 'Field Title1',
            FieldsTitle2__c = 'Field Title2',
            FieldsValue1__c = 'Field Value1',
            FieldsValue2__c = 'Field Value2',
            ImageUrl__c = 'http://xxxxx/image.png',
            Pretext__c = 'Pre-Text',
            ThumbUrl__c = 'http://xxxxx/thumb.png',
            Title__c = 'My Title',
            TitleLink__c =  'http://xxxxx/title.html'
        );
        insert slackMsg;
    }
    
    class SlackHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            System.assertEquals('https://hooks.slack.com/services/xxxxxx', req.getEndpoint());
            System.assertEquals('POST', req.getMethod());
            
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{}');
            res.setStatusCode(200);
            return res;
        }
    }
}