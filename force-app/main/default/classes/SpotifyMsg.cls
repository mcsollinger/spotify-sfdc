public with sharing class SpotifyMsg {
    public class TrackSearchResult {
        public String artist;
        public String name;
        public String trackId;
        public String albumImageUrl;
    }

    public class AudioFeaturesResult {
        public Double danceability;
        public Double energy;
        public Integer key;
        public Double loudness;
        public Integer mode;
        public Double speechiness;
        public Double acousticness;
        public Double instrumentalness;
        public Double liveness;
        public Double valence;
        public Double tempo;
        public String type;
        public String id;
        public String uri;
        public String track_href;
        public String analysis_url;
        public Integer duration_ms;
        public Integer time_signature;
    }
}