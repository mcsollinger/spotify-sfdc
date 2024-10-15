public with sharing class SpotifyAuthorizeController {
    @AuraEnabled
    public static Boolean checkAuthorization() {
        SpotifySettings__c settings = SpotifySettings__c.getInstance();
        return settings.AccessToken__c != null;
    }

    @AuraEnabled
    public static String authorize(String clientId, String clientSecret) {
        try {
            SpotifySettings__c settings = SpotifySettings__c.getInstance();
            settings.ClientId__c = clientId;
            settings.clientSecret__c = clientSecret;

            String state = String.valueOf(Crypto.getRandomInteger());
            settings.State__c = state;
            upsert as system settings;

            String vfUrl = URL.getOrgDomainUrl().toExternalForm() + '/apex/oauthRedirect';

            SpotifyEndpointSetting__mdt setting = SpotifyEndpointSetting__mdt.getInstance('Default');
            String authUrl =
                setting.AccountsEndpoint__c +
                '/authorize?client_id=' +
                clientId +
                '&response_type=code&redirect_uri=' +
                vfUrl +
                '&state=' +
                state +
                '&scope=user-read-private user-read-email';

            return authUrl;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void resetAuthorization() {
        try {
            SpotifySettings__c settings = SpotifySettings__c.getInstance();
            delete as system settings;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}