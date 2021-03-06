var exec = require('cordova/exec');

exports.coolMethod = function (arg0, success, error) {
    exec(success, error, 'WannatalkCore', 'coolMethod', [arg0]);
};

exports.initializeSDK = function (arg0, success, error) {

    exec(success, error, 'WannatalkCore', 'initializeSDK', [arg0]);
};

exports.isUserLoggedIn = function (success, error) {

    var map = {
        method: "isUserLoggedIn"
    };

    exec(success, error, 'WannatalkCore', 'invokeMethod', [map]);
};


exports.login = function (success, error) {

    var map = {
        method: "login"
    };

    exec(success, error, 'WannatalkCore', 'invokeMethod', [map]);
};


exports.silentLogin = function (identifier, arg0, success, error) {

    var map = {
        identifier: identifier,
        method: "silentLogin",
        userInfo: arg0
    };

    exec(success, error, 'WannatalkCore', 'invokeMethod', [map]);
};


exports.logout = function (success, error) {

    var map = {
        method: "logout"
    };

    exec(success, error, 'WannatalkCore', 'invokeMethod', [map]);
};


exports.loadOrgProfile = function (success, error) {

    var map = {
        method: "loadOrgProfile"
    };

    exec(success, error, 'WannatalkCore', 'invokeMethod', [map]);
};

    class ConfigKey {
        clearTempFolder = 9001;
        setInactiveChatTimeout = 9002;
        showGuideButton = 9003;
        allowSendAudioMessage = 9004;
        allowAddParticipant = 9005;
        allowRemoveParticipants = 9006;
        showWelcomePage = 9007;
        showProfileInfoPage = 9008;
        enableAutoTickets = 9009;
        showExitButton = 9010;
        showChatParticipants = 9011;
        enableChatProfile = 9012;
        allowModifyChatProfile = 9013;
        setAgentQueueInterval = 9014;
    }

    exports.ConfigKey = ConfigKey;
