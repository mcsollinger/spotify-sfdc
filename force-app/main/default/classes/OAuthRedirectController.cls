public with sharing class OAuthRedirectController {
    public String authCode { get; set; }
    public String error { get; set; }
    public String state { get; set; }

    public OAuthRedirectController() {
        PageReference currentPage = ApexPages.currentPage();
        authcode = currentPage.getParameters().get('code');
        error = currentPage.getParameters().get('error');
        state = currentPage.getParameters().get('state');
    }

    public PageReference getToken() {
        PageReference currentPage = ApexPages.currentPage();
        if (String.isNotEmpty(error)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, error));
            return null;
        }

        SpotifySettings__c settings = SpotifySettings__c.getInstance();
        if (state != settings.State__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Bad request, state does not match.'));
            return null;
        }

        if (String.isNotEmpty(authCode)) {
            SpotifyEndpointSetting__mdt setting = SpotifyEndpointSetting__mdt.getInstance('Default');
            String tokenEndpoint = setting.AccountsEndpoint__c + '/api/token';
            String grantType = 'authorization_code';
            String redirectUri = URL.getOrgDomainUrl().toExternalForm() + '/apex/oauthRedirect';

            HttpRequest req = new HttpRequest();
            req.setEndpoint(tokenEndpoint);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');

            String authHeader = Utils.createBasicHeader(settings.ClientId__c, settings.ClientSecret__c);
            req.setHeader('Authorization', authHeader);

            String body = 'grant_type=' + grantType + '&code=' + authCode + '&redirect_uri=' + redirectUri;
            req.setBody(body);

            Http http = new Http();
            try {
                HttpResponse res = http.send(req);
                if (res.getStatusCode() == 200) {
                    Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                    settings.AccessToken__c = (String) jsonResponse.get('access_token');
                    settings.RefreshToken__c = (String) jsonResponse.get('refresh_token');
                    upsert as system settings;

                    return new PageReference('/lightning/n/Spotify');
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, res.getBody()));
                }
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()));
            }
        }
        return null;
    }
}