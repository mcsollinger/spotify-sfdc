public with sharing class SpotifyAPIMsg {
    public class TrackSearch {
        public Tracks tracks;
    }
    public class Tracks {
        public List<Item> items;
    }

    public class Item {
        public Album album;
        public List<Artist> artists;
        public String id;
        public String name;
        public String preview_url;
    }

    public class Album {
        public List<Image> images;
    }

    public class Artist {
        public String name;
    }

    public class Image {
        public Integer height;
        public Integer width;
        public String url;
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