var exec = require('cordova/exec');

exports.coolMethod = function (arg0, success, error) {
    exec(success, error, 'WannatalkCore', 'coolMethod', [arg0]);
};


// exports.invokeMethod = function (arg0, success, error) {
//     exec(success, error, 'WannatalkCore', 'invokeMethod', [arg0]);
// };

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


// exports.openWTBasePage = function (success, error) {


//     var successT = function(result) {
      
//         console.log("initializeSDK call success");

//         if (result) {
//             loadOrgProfile(success, error);
//         }
//         else {
//             login(success, error);

//         }
//       }

//       var failureT = function(result) {
        
//         if (result != null) {
//           alert(result);
//         }
//       }
      
//       isUserLoggedIn(successT, failureT);
    

// };

  
    // static const  _kWTConfigClearTempFolder = 9001;
    // static const  _kWTConfigSetInactiveChatTimeout = 9002;
    // static const  _kWTConfigShowGuideButton = 9003;
    // static const  _kWTConfigAllowSendAudioMessage = 9004;
    // static const  _kWTConfigAllowAddParticipant = 9005;
    // static const  _kWTConfigAllowRemoveParticipants = 9006;
    // static const  _kWTConfigShowWelcomePage = 9007;
    // static const  _kWTConfigShowProfileInfoPage = 9008;
    // static const  _kWTConfigEnableAutoTickets = 9009;
    // static const  _kWTConfigShowExitButton = 9010;
    // static const  _kWTConfigShowChatParticipants = 9011;
    // static const  _kWTConfigEnableChatProfile = 9012;
    // static const  _kWTConfigAllowModifyChatProfile = 9013;
    // static const  _kWTConfigSetAgentQueueInterval = 9014;

    exports._kWTConfigClearTempFolder = 9001;
    exports._kWTConfigSetInactiveChatTimeout = 9002;
    exports._kWTConfigShowGuideButton = 9003;
    exports._kWTConfigAllowSendAudioMessage = 9004;
    exports._kWTConfigAllowAddParticipant = 9005;
    exports._kWTConfigAllowRemoveParticipants = 9006;
    exports._kWTConfigShowWelcomePage = 9007;
    exports._kWTConfigShowProfileInfoPage = 9008;
    exports._kWTConfigEnableAutoTickets = 9009;
    exports._kWTConfigShowExitButton = 9010;
    exports._kWTConfigShowChatParticipants = 9011;
    exports._kWTConfigEnableChatProfile = 9012;
    exports._kWTConfigAllowModifyChatProfile = 9013;
    exports._kWTConfigSetAgentQueueInterval = 9014;

    exports.showExitButton = function (value) {

        var map = {
            method: "updateConfig",
            methodType: _kWTConfigShowGuideButton,
            arg: value
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
