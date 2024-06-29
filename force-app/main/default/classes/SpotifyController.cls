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
            return JSON.serialize(SpotifyService.getTrackFeatures(trackId));
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}