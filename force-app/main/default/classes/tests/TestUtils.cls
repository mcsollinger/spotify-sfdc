@isTest
public with sharing class TestUtils {
    public static final String UNIT_TEST_EMAIL = 'unit.test@spotify.off';
    public static User createSpotifyUser() {
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

        return u;
    }
}