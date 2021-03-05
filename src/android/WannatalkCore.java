package cordova_plugin_wannatalk_core;


import android.app.Activity;
import android.os.Bundle;
import android.util.Log;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import wannatalk.wannatalksdk.WTCore.Interface.IWTCompletion;
import wannatalk.wannatalksdk.WTCore.Interface.IWTLoginManager;
import wannatalk.wannatalksdk.WTCore.WTSDKManager;
import wannatalk.wannatalksdk.WTLogin.WTLoginManager;


/**
 * This class echoes a string called from JavaScript.
 */
public class WannatalkCore extends CordovaPlugin {

@Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("coolMethod")) {
            String message = args.getString(0);
            this.coolMethod(message, callbackContext);
            return true;
        }
        else if (action.equals("invokeMethod")) {
          this.invokeMethod(args, callbackContext);
          return true;
        }
        else if (action.equals("initializeSDK")) {
          this.initializeSDK(args, callbackContext);
          return true;
        }

        return false;
    }

    private void coolMethod(String message, CallbackContext callbackContext) {
        if (message != null && message.length() > 0) {
            callbackContext.success(message);
        } else {
            callbackContext.error("Expected one non-empty string argument.");
        }
    }

  CallbackContext loginCallbackContext = null;
  CallbackContext logoutCallbackContext = null;
  CallbackContext orgProfileCallbackContext = null;

  private void invokeMethod(JSONArray args, CallbackContext callbackContext) {

    try {
//      "identifier" -> "+919000220455"
//      "method" -> "silentLogin"
      JSONObject jsonObject  = (JSONObject) args.get(0);
      String method = (String) jsonObject.get("method");

      switch (method) {
        case "silentLogin": {
          String identifier = (String) jsonObject.get("identifier");
          Map<String, String> userInfo = new HashMap<String, String>();
          userInfo.put("displayName", "SG Test");

          silentLogin(identifier, userInfo, callbackContext);

          break;
        }
        case "login": {

          login(callbackContext);

          break;
        }
        case "loadOrgProfile": {
          loadOrganizationProfile(true, callbackContext);
          break;
        }
        case "logout": {
          logout(callbackContext);
          break;
        }
        case "isUserLoggedIn": {
          Boolean loggedIn = isUserLoggedIn();
          callbackContext.success(loggedIn?1:0);
          break;
        }
        default: {
          callbackContext.error("Invalid method.");
        }
      }

    } catch (JSONException e) {
      e.printStackTrace();
      callbackContext.error("Something went wrong with input data");
    }

  }


  public Boolean isUserLoggedIn() {
    return WTLoginManager.IsUserLoggedIn();
  }


  private void initializeSDK(JSONArray args, CallbackContext callbackContext) throws JSONException  {

    WTSDKManager.ShowGuideButton(false);
    WTSDKManager.ShowProfileInfoPage(false);
    WTSDKManager.AllowAddParticipants(false);
    WTSDKManager.AllowSendAudioMessage(false);
    WTSDKManager.EnableAutoTickets(true);
    WTSDKManager.ShowWelcomeMessage(true);

    WTLoginManager.setIwtLoginManager(iwtLoginManager);


    WTSDKManager.ShowExitButton(true);
    WTSDKManager.EnableChatProfile(false);

    JSONObject jsonobj  = (JSONObject) args.get(0);

    if (jsonobj != null) {
      Iterator<String> keys = jsonobj.keys();
      while(keys.hasNext()) {
        String key = keys.next();
        int iKey = Integer.parseInt(key);
        Object value = jsonobj.get(key);
        HandleMethodType(iKey, value);

      }

    }

    callbackContext.success();
  }


  IWTLoginManager iwtLoginManager = new IWTLoginManager() {
    @Override
    public void wtsdkUserLoggedOut() {

      logoutCallbackContext.success();
    }

    @Override
    public void wtsdkUserLoggedIn() {

      loginCallbackContext.success();

    }

    @Override
    public void wtsdkUserLoginFailed(String s) {

      Log.d("Main Activity", "wtsdkUserLoginFailed " + s);
      loginCallbackContext.error(s);
    }

    @Override
    public void wtsdkUserLogoutFailed(String s) {

      Log.d("Main Activity", "wtsdkUserLogoutFailed: " + s);
      logoutCallbackContext.error(s);
    }
  };

  void login(CallbackContext result) {
    loginCallbackContext = result;
    // Silent authentication without otp verification

    Activity currentActivity = this.cordova.getActivity();// getActivity();
    Bundle bundle = new Bundle();
    WTLoginManager.StartLoginActivity(currentActivity);
  }

  void silentLogin(final String identifier, final Map<String, String> userInfo, CallbackContext result) {
    loginCallbackContext = result;
    // Silent authentication without otp verification

    Activity currentActivity = this.cordova.getActivity();// getActivity();
    Bundle bundle = new Bundle();
    if (userInfo != null) {
      for (Map.Entry<String,String> entry : userInfo.entrySet()) {
        String key = entry.getKey();
        String value = entry.getValue();
        bundle.putString(key, value);
      }
    }

    WTLoginManager.SilentLoginActivity(identifier, bundle, currentActivity);

  }


  void logout(CallbackContext result) {
    logoutCallbackContext = result;
    Activity currentActivity = this.cordova.getActivity(); // getActivity();
    WTLoginManager.Logout(currentActivity);

  }

  void loadOrganizationProfile(Boolean autoOpenChat,final CallbackContext result) {
    // Load organization profile
    Activity currentActivity = this.cordova.getActivity();//getActivity();
    WTSDKManager.LoadOrganizationActivity(currentActivity, autoOpenChat, new IWTCompletion() {
      @Override
      public void onCompletion(boolean success, String error) {
        if (success) {
          if (result != null) {
            result.success();
          }
        }
        else {
          if (result != null) {
            result.error(error);
          }
        }

      }
    });

  }

  private void sendLoginCallback(String error) {
    if (loginCallbackContext != null) {
      if (error == null) {
        loginCallbackContext.success();
      }
      else {
        loginCallbackContext.error(error);
      }
    }

    loginCallbackContext = null;
  }

  private void sendLogoutCallback(String error) {
    if (logoutCallbackContext != null) {
      if (error == null) {
        logoutCallbackContext.success();
      }
      else {
        logoutCallbackContext.error(error);
      }
    }

    logoutCallbackContext = null;
  }


  // @Override
    // public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
    //     if (action.equals("coolMethod")) {
    //         String message = args.getString(0);
    //         this.coolMethod(message, callbackContext);
    //         return true;
    //     }
    //     return false;
    // }

    // private void coolMethod(String message, CallbackContext callbackContext) {
    //     if (message != null && message.length() > 0) {
    //         callbackContext.success(message);
    //     } else {
    //         callbackContext.error("Expected one non-empty string argument.");
    //     }
    // }

  static final int _kWTConfigClearTempFolder = 9001;
  static final int _kWTConfigSetInactiveChatTimeout = 9002;
  static final int _kWTConfigShowGuideButton = 9003;
  static final int _kWTConfigAllowSendAudioMessage = 9004;
  static final int _kWTConfigAllowAddParticipant = 9005;
  static final int _kWTConfigAllowRemoveParticipants = 9006;
  static final int _kWTConfigShowWelcomePage = 9007;
  static final int _kWTConfigShowProfileInfoPage = 9008;
  static final int _kWTConfigEnableAutoTickets = 9009;
  static final int _kWTConfigShowExitButton = 9010;
  static final int _kWTConfigShowChatParticipants = 9011;
  static final int _kWTConfigEnableChatProfile = 9012;
  static final int _kWTConfigAllowModifyChatProfile = 9013;
  static final int _kWTConfigSetAgentQueueInterval = 9014;

  public static void HandleMethodType(int methodType, Object arg) {

    switch (methodType) {
      case _kWTConfigClearTempFolder: {
        ClearTempFiles();
        break;
      }
      case _kWTConfigSetInactiveChatTimeout: {
        long interval = (long) arg;
        SetInactiveChatTimeoutInterval(interval);
        break;
      }
      case _kWTConfigSetAgentQueueInterval: {
        long interval = (long) arg;
        SetAgentQueueInterval(interval);
        break;
      }
      case _kWTConfigShowGuideButton: {
        boolean show = (boolean) arg;
        ShowGuideButton(show);
        break;
      }
      case _kWTConfigAllowSendAudioMessage: {
        boolean allow = (boolean) arg;
        AllowSendAudioMessage(allow);
        break;
      }
      case _kWTConfigAllowAddParticipant: {
        boolean allow = (boolean) arg;
        AllowAddParticipants(allow);
        break;
      }
      case _kWTConfigAllowRemoveParticipants: {
        boolean allow = (boolean) arg;
        AllowRemoveParticipants(allow);
        break;
      }
      case _kWTConfigShowWelcomePage: {
        boolean show = (boolean) arg;
        ShowWelcomeMessage(show);
        break;
      }
      case _kWTConfigShowProfileInfoPage: {
        boolean show = (boolean) arg;
        ShowProfileInfoPage(show);
        break;
      }
      case _kWTConfigEnableAutoTickets: {
        boolean enable = (boolean) arg;
        EnableAutoTickets(enable);
        break;
      }
      case _kWTConfigShowExitButton: {
        boolean show = (boolean) arg;
        ShowExitButton(show);
        break;
      }
      case _kWTConfigShowChatParticipants: {
        boolean show = (boolean) arg;
        ShowChatParticipants(show);
        break;
      }
      case _kWTConfigEnableChatProfile: {
        boolean enable = (boolean) arg;
        EnableChatProfile(enable);
        break;
      }
      case _kWTConfigAllowModifyChatProfile: {
        boolean allow = (boolean) arg;
        AllowModifyChatProfile(allow);
        break;
      }
      default: {

        break;
      }

    }
  }


  private static void ClearTempFiles() {
    WTSDKManager.ClearOldTempFiles();
    WTSDKManager.ClearTempFiles();
  }


  private static void ShowGuideButton(boolean show) {
    WTSDKManager.ShowGuideButton(show);
  }


  private static void ShowProfileInfoPage(boolean show) {
    WTSDKManager.ShowProfileInfoPage(show);
  }


  private static void AllowSendAudioMessage(boolean allow) {
    WTSDKManager.AllowSendAudioMessage(allow);
  }


  private static void AllowAddParticipants(boolean allow) {
    WTSDKManager.AllowAddParticipants(allow);
  }


  private static void AllowRemoveParticipants(boolean allow) {
    WTSDKManager.AllowRemoveParticipants(allow);
  }


  private static void ShowWelcomeMessage(boolean show) {
    WTSDKManager.ShowWelcomeMessage(show);
  }


  private static void EnableAutoTickets(boolean enable) {
    WTSDKManager.EnableAutoTickets(enable);
  }


  private static void ShowExitButton(boolean show) {
    WTSDKManager.ShowExitButton(show);
  }


  private static void ShowChatParticipants(boolean show) {
    WTSDKManager.ShowChatParticipants(show);
  }


  private static void EnableChatProfile(boolean enable) {
    WTSDKManager.EnableChatProfile(enable);
  }


  private static void AllowModifyChatProfile(boolean allow) {
    WTSDKManager.AllowModifyChatProfile(allow);
  }


  private static void SetInactiveChatTimeoutInterval(long timeoutInSeconds) {
    WTSDKManager.SetInactiveChatTimeoutInterval(timeoutInSeconds);
  }

  private static void SetAgentQueueInterval(long timeIntervalInSeconds) {
    WTSDKManager.SetAgentQueueInterval(timeIntervalInSeconds);
  }

}
