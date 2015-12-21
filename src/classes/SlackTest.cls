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