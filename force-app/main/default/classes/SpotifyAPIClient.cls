public with sharing class SpotifyAPIClient {
    public static final String BASE_API_ENDPOINT = SpotifyEndpointSetting__mdt.getInstance('Default').APIEndpoint__c;

    /**
     * @description Calls search endpoint
     * @param  encodedTrackName Encoded track name to search
     * @return                  APIMsg result
     */
    public static SpotifyAPIMsg.TrackSearch searchTrack(String encodedTrackName) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(BASE_API_ENDPOINT + '/v1/search?type=track&limit=5&q=' + encodedTrackName);
        req.setMethod('GET');
        String json = sendAndProcessResponse(req);
        return (SpotifyAPIMsg.TrackSearch) System.JSON.deserialize(json, SpotifyAPIMsg.TrackSearch.class);
    }

    /**
     * @description Calls audio features endpoint
     * @param  songId Song ID of the song to describe
     * @return        APIMsg result
     */
    public static SpotifyAPIMsg.AudioFeaturesResult getAudioFeatures(String songId) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(BASE_API_ENDPOINT + '/v1/audio-features/' + songId);
        req.setMethod('GET');
        String json = sendAndProcessResponse(req);
        return (SpotifyAPIMsg.AudioFeaturesResult) System.JSON.deserialize(
            json,
            SpotifyAPIMsg.AudioFeaturesResult.class
        );
    }

    private static String sendAndProcessResponse(HttpRequest req) {
        SpotifySettings__c settings = SpotifySettings__c.getInstance();
        req.setHeader('Authorization', 'Bearer ' + settings.AccessToken__c);
        Http http = new Http();
        HttpResponse res = http.send(req);
        if (res.getStatusCode() == 401) {
            String accessToken = exchangeRefreshTokenForAccessToken(
                settings.RefreshToken__c,
                settings.ClientId__c,
                settings.ClientSecret__c
            );
            req.setHeader('Authorization', 'Bearer ' + accessToken);
            res = http.send(req);
            if (res.getStatusCode() > 200) {
                throw new SpotifyAPIException(res.getBody());
            } else {
                settings.AccessToken__c = accessToken;
                upsert as system settings;
            }
        } else if (res.getStatusCode() > 200) {
            throw new SpotifyAPIException(res.getBody());
        }

        return res.getBody();
    }

    private static String exchangeRefreshTokenForAccessToken(
        String refreshToken,
        String clientId,
        String clientSecret
    ) {
        String accountEndpoint = SpotifyEndpointSetting__mdt.getInstance('Default').AccountsEndpoint__c + '/api/token';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(accountEndpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');

        String authHeader = Utils.createBasicHeader(clientId, clientSecret);
        req.setHeader('Authorization', authHeader);

        String body = 'grant_type=refresh_token&refresh_token=' + refreshToken;
        req.setBody(body);

        Http http = new Http();
        try {
            HttpResponse res = http.send(req);
            if (res.getStatusCode() == 200) {
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                return (String) jsonResponse.get('access_token');
            } else {
                throw new SpotifyAPIException(res.getBody());
            }
        } catch (Exception e) {
            throw new SpotifyAPIException(e.getMessage());
        }
    }

    public class SpotifyAPIException extends Exception {
    }
}