public with sharing class Utils {
    public static String createBasicHeader(String clientId, String clientSecret) {
        String clientIdSecretMashup = clientId + ':' + clientSecret;
        return 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(clientIdSecretMashup));
    }
}