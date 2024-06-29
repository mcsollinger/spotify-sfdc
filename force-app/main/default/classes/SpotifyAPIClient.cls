public with sharing class SpotifyAPIClient {
    /**
     * @description Calls search endpoint
     * @param  encodedTrackName Encoded track name to search
     * @return                  APIMsg result
     */
    public static SpotifyAPIMsg.TrackSearch searchTrack(String encodedTrackName) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Spotify/v1/search?type=track&limit=5&q=' + encodedTrackName);
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
        req.setEndpoint('callout:Spotify/v1/audio-features/' + songId);
        req.setMethod('GET');
        String json = sendAndProcessResponse(req);
        return (SpotifyAPIMsg.AudioFeaturesResult) System.JSON.deserialize(
            json,
            SpotifyAPIMsg.AudioFeaturesResult.class
        );
    }

    private static String sendAndProcessResponse(HttpRequest req) {
        Http http = new Http();
        HttpResponse res = http.send(req);
        if (res.getStatusCode() > 200) {
            throw new SpotifyAPIException(res.getBody());
        }

        return res.getBody();
    }

    public class SpotifyAPIException extends Exception {
    }
}