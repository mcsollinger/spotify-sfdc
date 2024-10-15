@isTest
private with sharing class OAuthRedirectTest {
    @testSetup
    static void setupData() {
        TestUtils.createSpotifyUser();
    }

    @isTest
    static void testGetToken() {
        User u = [SELECT Id FROM User WHERE Email = :TestUtils.UNIT_TEST_EMAIL LIMIT 1];
        System.runAs(u) {
            SpotifySettings__c settings = SpotifySettings__c.getInstance();
            settings.State__c = 'abc';
            settings.ClientId__c = 'client';
            settings.ClientSecret__c = 'secret';
            upsert settings;

            PageReference pageRef = Page.oauthRedirect;
            pageRef.getParameters().put('code', '123');
            pageRef.getParameters().put('state', 'abc');
            Test.setCurrentPage(pageRef);

            String response = '{"access_token":"access","refresh_token":"refresh"}';
            HttpCalloutMockFactory mock = new HttpCalloutMockFactory(200, 'success', response, null);
            Test.setMock(HttpCalloutMock.class, mock);

            Test.startTest();
            OAuthRedirectController controller = new OAuthRedirectController();
            controller.getToken();
            Test.stopTest();

            SpotifySettings__c updatedSettings = SpotifySettings__c.getInstance();
            Assert.areEqual('access', updatedSettings.AccessToken__c, 'Access token should be updated');
            Assert.areEqual('refresh', updatedSettings.RefreshToken__c, 'Refresh token should be updated');
        }
    }
}