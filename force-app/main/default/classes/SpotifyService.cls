public with sharing class SpotifyService {
    /**
     * @description Calls search track endpoint and formats result
     * @param  trackName User-entered track name to search
     * @return           Formatted result from API call
     */
    public static List<SpotifyMsg.TrackSearchResult> searchTrack(String trackName) {
        trackName = trackName.replace(' ', '+');
        SpotifyAPIMsg.TrackSearch apiMsg = SpotifyAPIClient.searchTrack(trackName);
        List<SpotifyMsg.TrackSearchResult> msgs = new List<Spotifymsg.TrackSearchResult>();
        for (SpotifyAPIMsg.Item item : apiMsg.tracks.items) {
            SpotifyMsg.TrackSearchResult msg = new SpotifyMsg.TrackSearchResult();

            for (SpotifyAPIMsg.Image image : item.album.images) {
                if (image.height == 64) {
                    msg.albumImageUrl = image.url;
                }
            }

            if (item.artists?.size() > 0) {
                msg.artist = item.artists[0].name;
            }

            msg.trackId = item.id;
            msg.name = item.name;

            msgs.add(msg);
        }

        return msgs;
    }

    /**
     * @description Calls audio features API and formats result
     * @param  trackId ID of the track input for audio features API
     * @return         Formatted result from API call
     */
    public static SpotifyMsg.AudioFeaturesResult getTrackFeatures(String trackId) {
        SpotifyAPIMsg.AudioFeaturesResult apiMsg = SpotifyAPIClient.getAudioFeatures(trackId);
        SpotifyMsg.AudioFeaturesResult msg = new SpotifyMsg.AudioFeaturesResult();
        msg.copyFromAPI(apiMsg);
        msg.key = apiMsg.key == -1 ? 'No Key Detected' : formatKey(apiMsg.key, apiMsg.mode);
        return msg;
    }

    /**
     * @description Formats the key and mode result from the API call
     * @param  key  Key from API call
     * @param  mode Mode from API call
     * @return      Formatted key signature
     */
    private static String formatKey(Double key, Double mode) {
        Map<Double, String> keyMap = new Map<Double, String>{
            -1 => 'No Key Detected',
            0 => 'C',
            1 => 'C-sharp',
            2 => 'D',
            3 => 'D-sharp',
            4 => 'E',
            5 => 'F',
            6 => 'F-sharp',
            7 => 'G',
            8 => 'G-sharp',
            9 => 'A',
            10 => 'A-sharp',
            11 => 'B'
        };

        Map<Double, String> modeMap = new Map<Double, String>{ 0 => 'Minor', 1 => 'Major' };

        String result = keyMap.get(key) + ' ' + modeMap.get(mode);
        return result;
    }
}