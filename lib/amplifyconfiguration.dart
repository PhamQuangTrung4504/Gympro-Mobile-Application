const amplifyconfig = '''{
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserProfiles": {
                    "Default": {
                        "authenticationFlowType": "USER_PASSWORD_AUTH"
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "us-east-1_oSMRF96l9",
                        "AppClientId": "7o4lfdo51v9b3k2e7ia80tb8o4",
                        "Region": "us-east-1"
                    }
                }
            }
        }
    }
}''';
