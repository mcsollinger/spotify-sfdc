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
}