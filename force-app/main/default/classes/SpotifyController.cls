public with sharing class SpotifyController {
    @AuraEnabled
    public static String searchTrack(String trackName) {
        try {
            return JSON.serialize(SpotifyService.searchTrack(trackName));
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String getTrackAudioFeatures(String trackId) {
        try {
            // TODO: update SpotifyMsg.AudioFeaturesResult to parse out specific info needed for FE
            return JSON.serialize(SpotifyAPIClient.getAudioFeatures(trackId));
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}