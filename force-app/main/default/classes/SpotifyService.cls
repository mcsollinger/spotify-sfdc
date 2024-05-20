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

            msg.name = item.id;
            msg.trackId = item.name;

            msgs.add(msg);
        }

        return msgs;
    }
}