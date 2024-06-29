@isTest
private with sharing class SpotifyTest {
    private static final String UNIT_TEST_EMAIL = 'unit.test@spotify.off';
    @testSetup
    static void setupData() {
        Profile sysAdmin = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User u = new User(
            FirstName = 'Unit',
            LastName = 'Test',
            Alias = 'utest',
            Email = UNIT_TEST_EMAIL,
            Username = 'unit.test.' + UserInfo.getOrganizationId() + Crypto.getRandomInteger() + '@spotify.off',
            ProfileId = sysAdmin.Id,
            TimezoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            EmailEncodingKey = 'UTF-8'
        );
        insert u;
        PermissionSet spotifyPermissionSet = [SELECT Id FROM PermissionSet WHERE Name = 'Spotify' LIMIT 1];
        insert new PermissionSetAssignment(PermissionSetId = spotifyPermissionSet.Id, AssigneeId = u.Id);
    }

    @isTest
    static void testSearchTrack() {
        User u = [SELECT Id FROM User WHERE Email = :UNIT_TEST_EMAIL LIMIT 1];
        System.runAs(u) {
            String responseBody = JSON.serialize(buildTrackMsg());
            HttpCalloutMockFactory mock = new HttpCalloutMockFactory(200, 'success', responseBody, null);
            Test.setMock(HttpCalloutMock.class, mock);

            Test.startTest();
            String json = SpotifyController.searchTrack('red hot chili peppers');
            Test.stopTest();

            List<SpotifyMsg.TrackSearchResult> msgs = (List<SpotifyMsg.TrackSearchResult>) System.JSON.deserialize(
                json,
                List<SpotifyMsg.TrackSearchResult>.class
            );
            SpotifyMsg.TrackSearchResult msg = msgs[0];

            Assert.areEqual('Red Hot Chili Peppers', msg.artist, 'Attributes should match');
            Assert.areEqual('Under the Bridge', msg.name, 'Attributes should match');
            Assert.areEqual('3d9DChrdc6BOeFsbrZ3Is0', msg.trackId, 'Attributes should match');
            Assert.areEqual('https://i.scdn.co/image/test', msg.albumImageUrl, 'Attributes should match');
        }
    }

    @isTest
    static void testGetTrackFeatures() {
        User u = [SELECT Id FROM User WHERE Email = :UNIT_TEST_EMAIL LIMIT 1];
        System.runAs(u) {
            String responseBody = JSON.serialize(buildAudioFeaturesResult());
            HttpCalloutMockFactory mock = new HttpCalloutMockFactory(200, 'success', responseBody, null);
            Test.setMock(HttpCalloutMock.class, mock);

            Test.startTest();
            String json = SpotifyController.getTrackAudioFeatures('123');
            Test.stopTest();

            SpotifyMsg.AudioFeaturesResult msg = (SpotifyMsg.AudioFeaturesResult) System.JSON.deserialize(
                json,
                SpotifyMsg.AudioFeaturesResult.class
            );

            Assert.areEqual(1, msg.danceability, 'Attributes should match');
            Assert.areEqual(2, msg.energy, 'Attributes should match');
            Assert.areEqual('C Major', msg.key, 'Attributes should match');
        }
    }

    private static SpotifyAPIMsg.TrackSearch buildTrackMsg() {
        SpotifyAPIMsg.Item item = new SpotifyAPIMsg.Item();
        item.id = '3d9DChrdc6BOeFsbrZ3Is0';
        item.name = 'Under the Bridge';
        item.preview_url = 'https://p.scdn.co/mp3-preview/test';

        SpotifyAPIMsg.Image image = new SpotifyAPIMsg.Image();
        image.height = 64;
        image.width = 64;
        image.url = 'https://i.scdn.co/image/test';

        SpotifyAPIMsg.Album album = new SpotifyAPIMsg.Album();
        album.images = new List<SpotifyAPIMsg.Image>{ image };
        item.album = album;

        SpotifyAPIMsg.Artist artist = new SpotifyAPIMsg.Artist();
        artist.name = 'Red Hot Chili Peppers';
        item.artists = new List<SpotifyAPIMsg.Artist>{ artist };

        SpotifyAPIMsg.Tracks track = new SpotifyAPIMsg.Tracks();
        track.items = new List<SpotifyAPIMsg.Item>{ item };

        SpotifyAPIMsg.TrackSearch trackSearch = new SpotifyAPIMsg.TrackSearch();
        trackSearch.tracks = track;
        return trackSearch;
    }

    private static SpotifyAPIMsg.AudioFeaturesResult buildAudioFeaturesResult() {
        SpotifyAPIMsg.AudioFeaturesResult msg = new SpotifyAPIMsg.AudioFeaturesResult();
        msg.danceability = 1;
        msg.energy = 2;
        msg.key = 0;
        msg.mode = 1;
        return msg;
    }
}