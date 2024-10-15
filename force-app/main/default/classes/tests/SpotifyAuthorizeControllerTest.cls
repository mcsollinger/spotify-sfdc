@isTest
private with sharing class SpotifyAuthorizeControllerTest {
    @testSetup
    private static void setupData() {
        TestUtils.createSpotifyUser();
        User u = [SELECT Id FROM User WHERE Email = :TestUtils.UNIT_TEST_EMAIL LIMIT 1];
        System.runAs(u) {
            SpotifySettings__c settings = SpotifySettings__c.getInstance();
            settings.ClientId__c = 'client';
            settings.ClientSecret__c = 'secret';
            settings.AccessToken__c = 'access';
            upsert settings;
        }
    }

    @isTest
    static void testCheckAuthorization() {
        User u = [SELECT Id FROM User WHERE Email = :TestUtils.UNIT_TEST_EMAIL LIMIT 1];
        System.runAs(u) {
            Test.startTest();
            Boolean authorized = SpotifyAuthorizeController.checkAuthorization();
            Test.stopTest();

            Assert.isTrue(authorized, 'Should be authorized');
        }
    }

    @isTest
    static void testAuthorize() {
        User u = [SELECT Id FROM User WHERE Email = :TestUtils.UNIT_TEST_EMAIL LIMIT 1];
        System.runAs(u) {
            Test.startTest();
            String authUrl = SpotifyAuthorizeController.authorize('updatedClient', 'updatedSecret');
            Test.stopTest();

            Assert.isTrue(authUrl.contains('updatedClient'), 'Should include client id');

            SpotifySettings__c settings = SpotifySettings__c.getInstance();
            Assert.areEqual('updatedClient', settings.ClientId__c, 'Client Id should be updated');
            Assert.areEqual('updatedSecret', settings.ClientSecret__c, 'Client Secret should be updated');
        }
    }

    @isTest
    static void testReset() {
        User u = [SELECT Id FROM User WHERE Email = :TestUtils.UNIT_TEST_EMAIL LIMIT 1];
        System.runAs(u) {
            Test.startTest();
            SpotifyAuthorizeController.resetAuthorization();
            Test.stopTest();

            SpotifySettings__c settings = SpotifySettings__c.getInstance();
            Assert.isNull(settings.ClientId__c, 'Should be deleted');
        }
    }
}