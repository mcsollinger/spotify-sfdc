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
        public String key;
        public Double loudness;
        public Double speechiness;
        public Double acousticness;
        public Double instrumentalness;
        public Double liveness;
        public Double valence;
        public Double tempo;

        public void copyFromAPI(SpotifyAPIMsg.AudioFeaturesResult apiMsg) {
            this.danceability = apiMsg.danceability;
            this.energy = apiMsg.energy;
            this.loudness = apiMsg.loudness;
            this.speechiness = apiMsg.speechiness;
            this.acousticness = apiMsg.acousticness;
            this.instrumentalness = apiMsg.instrumentalness;
            this.liveness = apiMsg.liveness;
            this.valence = apiMsg.valence;
            this.tempo = apiMsg.tempo;
        }
    }
}