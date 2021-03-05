/********* WannatalkCore.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
//#import "WTConfigHandler.h"

#import <WTExternalSDK/WTExternalSDK.h>

@interface WannatalkCore : CDVPlugin {
  // Member variables go here.
    
}

@property BOOL tempBool;

@property BOOL sdkInitialized;

- (void)initializeSDK:(CDVInvokedUrlCommand*)command;
- (void)coolMethod:(CDVInvokedUrlCommand*)command;
- (void)invokeMethod:(CDVInvokedUrlCommand*)command;

@property CDVInvokedUrlCommand *loginResult;
@property CDVInvokedUrlCommand *logoutResult;
@property CDVInvokedUrlCommand *orgProfileResult;

@end

@interface WannatalkCore()<WTLoginManagerDelegate, WTSDKManagerDelegate>

@end

@implementation WannatalkCore
//
//- (void)coolMethod:(CDVInvokedUrlCommand*)command
//{
//    CDVPluginResult* pluginResult = nil;
//    NSString* echo = [command.arguments objectAtIndex:0];
//
//    if (echo != nil && [echo length] > 0) {
//        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
//    } else {
//        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
//    }
//
//    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//}


- (void)coolMethod:(CDVInvokedUrlCommand*)command
{
    NSLog(@"coolMethod: %@", command);
    CDVPluginResult* pluginResult = nil;
    NSString* echo = [command.arguments objectAtIndex:0];

    if (echo != nil && [echo length] > 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

//
//- (void)isUserLoggedIn:(CDVInvokedUrlCommand*)command
//{
//    NSLog(@"isUserLoggedIn: %@", command);
//    BOOL loggedIn = [self isUserLoggedIn];
//
//    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:loggedIn];
//
//    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//}


- (void)invokeMethod:(CDVInvokedUrlCommand*)command
{
//    NSLog(@"invokeMethod: %@", command);
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        dispatch_async(dispatch_get_main_queue(), ^{
            
//            if (!self.sdkInitialized) {
//                [self initializeSDKSettings:nil];
//            }
            
            CDVPluginResult* pluginResult = nil;
            NSDictionary* echo = [command.arguments objectAtIndex:0];

            
            NSString *method = echo[@"method"];
            
            if ([method isEqualToString:@"silentLogin"]) {
                
                NSString *identifier = echo[@"identifier"];
                NSDictionary *userInfo = echo[@"userInfo"];
                NSLog(@"isMainThread: %d", [NSThread isMainThread]);
                [self silentLogin:identifier userInfo:userInfo result:command];

                return;
            }
            else if ([method isEqualToString:@"login"]) {
                
                [self loginWithResult:command];

                return;
            }
            else if ([method isEqualToString:@"loadOrgProfile"]) {
            
                [self loadOrganizationProfile:YES result:command];
                return;
            }
            else if ([method isEqualToString:@"logout"]) {
            
                [self logout:command];
                return;
            }
//            else if ([method isEqualToString:@"updateConfig"]) {
//
//                NSInteger methodType = [echo[@"methodType"] integerValue];
//                NSNumber *args = echo[@"arg"];
//                [WannatalkCore handleConfigMethodType:methodType arguments:args];
//                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
//                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//                return;
//            }
            else if ([method isEqualToString:@"isUserLoggedIn"]) {
                BOOL loggedIn = [self isUserLoggedIn];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:loggedIn];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                return;
            }
            
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        });

    });


}


- (void)initializeSDK:(CDVInvokedUrlCommand*)command
{
    NSLog(@"initializeSDK: %@", command);
    
    self.sdkInitialized = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{

            NSDictionary *sdkSettings = [command.arguments objectAtIndex:0];
            
            [self initializeSDKSettings:sdkSettings];
            
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

            
        });
        
    });

}

- (void) initializeSDKSettings:(NSDictionary *) sdkSettings {
    
    UIApplication *application =  [UIApplication sharedApplication];
    NSDictionary *launchOptions = nil;
    
    [[WTSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    [WTLoginManager sharedInstance].delegate = self;
    
    if (sdkSettings) {
        
//        if ([sdkSettings )
        
//        NSDictionary<NSNumber *, NSNumber *> *dctTest = @{};
        [WTSDKManager ShowGuideButton:NO];
        [WTSDKManager ShowProfileInfoPage:NO];
        [WTSDKManager ShouldAllowSendAudioMessage:NO];
        [WTSDKManager ShouldAllowAddParticipant:NO];
        [WTSDKManager EnableAutoTickets:YES];

        [WTSDKManager ShowExitButton:YES];
        [WTSDKManager EnableChatProfile:NO];
        
        [sdkSettings enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
           
            [WannatalkCore handleConfigMethodType:key.integerValue arguments:obj];
            
        }];
        
        
    }
    
}



//- (IBAction)silentLoginBtnClicked:(id)sender {
//    NSString *sad = @"";
//
//
//    @try {
//        NSDictionary *userInfo = @{ @"key1": @"value1", @"key2": sad};
//
//        [[WTLoginManager sharedInstance] silentLoginWithIdentifier:@"+919000220455" userInfo:userInfo fromVC:self];
//    } @catch (NSException *exception) {
//        NSLog(@"Exception: %@", exception);
//    }
//
//
//}


- (void) sendLoginCallback:(NSString *) error {
    
    
    [self.commandDelegate runInBackground:^{
        
        if (self.loginResult) {
            CDVPluginResult *pluginResult;
            
            if (error) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error];
            }
            else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            }
        
            [self.commandDelegate sendPluginResult:pluginResult callbackId:self.loginResult.callbackId];
            
        }
        self.loginResult = nil;
    }];
    
}


- (void) sendLogoutCallback:(NSString *) error {
    
    
    [self.commandDelegate runInBackground:^{
        
        
        if (self.logoutResult) {
            CDVPluginResult *pluginResult;
            
            if (error) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error];
            }
            else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            }
            
            
            [self.commandDelegate sendPluginResult:pluginResult callbackId:self.logoutResult.callbackId];
            
        }
        self.logoutResult = nil;
    }];
}



- (void) sendOrgProfileCallback:(NSString *) error {
    
    [self.commandDelegate runInBackground:^{
        
        if (self.orgProfileResult) {
            CDVPluginResult *pluginResult;
            
            //        if (echo != nil && [echo length] > 0) {
            //            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
            //        } else {
            //            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            //        }
            
            if (error) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error];
            }
            else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            }
            
            //        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus];
            
            [self.commandDelegate sendPluginResult:pluginResult callbackId:self.orgProfileResult.callbackId];
            
        }
        self.orgProfileResult = nil;
    }];
       
}


#pragma mark -
// If implemented, this method will be invoked when organization profile loads successfully
- (void) wtsdkOrgProfileDidLoadSuccesfully {
    [self sendOrgProfileCallback:nil];
}

// If implemented, this method will be invoked when organization profile fails to load
- (void) wtsdkOrgProfileDidLoadFailWithError:(NSString *) error {
    [self sendOrgProfileCallback:error];
}



#pragma mark -

// This method will be invoked when user sign in successfully
- (void) wtAccountDidLoginSuccessfully {
    [self sendLoginCallback:nil];
}

// If implemented, this method will be invoked when login fails
- (void) wtAccountDidLoginFailWithError:(NSString *) error {
    [self sendLoginCallback:error];
}

// This method will be invoked when user sign out successfully
- (void) wtAccountDidLogOutSuccessfully {
    [self sendLogoutCallback:nil];
}

// If implemented, this method will be invoked when logout fails
- (void) wtAccountDidLogOutFailedWithError:(NSString *) error {
    [self sendLogoutCallback:error];
}


#pragma mark -

+ (UIViewController *) GetWindowRootViewController {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIViewController *_rootViewController = (UIViewController *)window.rootViewController;
    return _rootViewController;
}

+ (void) RunMainThread:(void (^)(void))onMainThread {

    if (onMainThread) {
        onMainThread();
    }
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (onMainThread) {
//                onMainThread();
//            }
//        });
//    });

}

+ (void) GetBaseViewController:(void (^)(UIViewController *baseViewController)) onCompletion {

    [self RunMainThread:^{
        UIViewController *_rootViewController = [self GetWindowRootViewController];

        if (onCompletion) {
            onCompletion(_rootViewController);
        }
    }];


}
#pragma mark -

- (BOOL) isUserLoggedIn {
    return [WTLoginManager sharedInstance].isUserLoggedIn;
}

- (void) logout:(CDVInvokedUrlCommand *) command {
    self.logoutResult = command;

    [WannatalkCore RunMainThread:^{
        [[WTLoginManager sharedInstance] logout];
    }];
}


- (void)loginWithResult:(CDVInvokedUrlCommand *) command {
    self.loginResult = command;

    [WannatalkCore GetBaseViewController:^(UIViewController *baseViewController) {
        [[WTLoginManager sharedInstance] loginFromVC:baseViewController];
    }];
}

- (void)silentLogin:(NSString *) identifier userInfo:(NSDictionary *) userInfo result:(CDVInvokedUrlCommand *) command {
    self.loginResult = command;

    
    [WannatalkCore GetBaseViewController:^(UIViewController *baseViewController) {
        [[WTLoginManager sharedInstance] silentLoginWithIdentifier:identifier userInfo:userInfo fromVC:baseViewController];

    }];
}


-(void) login:(CDVInvokedUrlCommand *) command {

    self.loginResult = command;

    [WannatalkCore GetBaseViewController:^(UIViewController *baseViewController) {
        [[WTLoginManager sharedInstance] loginFromVC:baseViewController];

    }];

}

#pragma mark -

- (void)loadOrganizationProfile:(BOOL) autoOpenChat result:(CDVInvokedUrlCommand *) command {
    self.orgProfileResult = command;

    [WannatalkCore GetBaseViewController:^(UIViewController *baseViewController) {
        [baseViewController presentOrgProfileVCWithAutoOpenChat:autoOpenChat delegate:self animated:YES completion:nil];
    }];

}

-(void) loadChatList:(CDVInvokedUrlCommand *) command {
//    self.chatListResult = result;
//    [WannatalkCore GetBaseViewController:^(UIViewController *baseViewController) {
//        [baseViewController presentChatListVCWithDelegate:self animated:YES completion:nil];
//    }];
}


- (void)loadUsers:(CDVInvokedUrlCommand *) command {
//    self.userListResult = result;
//
//    [WannatalkCore GetBaseViewController:^(UIViewController *baseViewController) {
//        [baseViewController presentUsersVCWithDelegate:self animated:YES completion:nil];
//    }];
}

#pragma mark -

static const  int _kWTConfigClearTempFolder = 9001;
static const  int _kWTConfigSetInactiveChatTimeout = 9002;
static const  int _kWTConfigShowGuideButton = 9003;
static const  int _kWTConfigAllowSendAudioMessage = 9004;
static const  int _kWTConfigAllowAddParticipant = 9005;
static const  int _kWTConfigAllowRemoveParticipants = 9006;
static const  int _kWTConfigShowWelcomePage = 9007;
static const  int _kWTConfigShowProfileInfoPage = 9008;
static const  int _kWTConfigEnableAutoTickets = 9009;
static const  int _kWTConfigShowExitButton = 9010;
static const  int _kWTConfigShowChatParticipants = 9011;
static const  int _kWTConfigEnableChatProfile = 9012;
static const  int _kWTConfigAllowModifyChatProfile = 9013;
static const  int _kWTConfigSetAgentQueueInterval = 9014;

#define cShow @"show"
#define cEnable @"enable"
#define cAllow @"allow"

#define cTimeoutInterval @"timeoutInterval"
#define cTimeInterval @"timeInterval"

+ (void) handleConfigMethodType:(NSInteger) methodType arguments:(NSNumber *) arg {

    switch (methodType) {
        case _kWTConfigClearTempFolder: {
            [self ClearTempFiles];
            break;
        }
        case _kWTConfigSetInactiveChatTimeout: {
            NSTimeInterval interval = [arg doubleValue];
            [self SetInactiveChatTimeoutInterval:interval];
            break;
        }
        case _kWTConfigSetAgentQueueInterval: {
            NSTimeInterval interval = [arg doubleValue];
            [self SetAgentQueueTimeInterval:interval];
            break;
        }
        case _kWTConfigShowGuideButton: {
            BOOL show = [arg boolValue];
            [self ShowGuideButton:show];
            break;
        }
        case _kWTConfigAllowSendAudioMessage: {
            BOOL allow = [arg boolValue];
            [self AllowSendAudioMessage:allow];
            break;
        }
        case _kWTConfigAllowAddParticipant: {
            BOOL allow = [arg boolValue];
            [self AllowAddParticipants:allow];
            break;
        }
        case _kWTConfigAllowRemoveParticipants: {
            BOOL allow = [arg boolValue];
            [self AllowRemoveParticipants:allow];
            break;
        }
        case _kWTConfigShowWelcomePage: {
            BOOL show = [arg boolValue];
            [self ShowWelcomeMessage:show];
            break;
        }
        case _kWTConfigShowProfileInfoPage: {
            BOOL show = [arg boolValue];
            [self ShowProfileInfoPage:show];
            break;
        }
        case _kWTConfigEnableAutoTickets: {
            BOOL enable = [arg boolValue];
            [self EnableAutoTickets:enable];
            break;
        }
        case _kWTConfigShowExitButton: {
            BOOL show = [arg boolValue];
            [self ShowExitButton:show];
            break;
        }
        case _kWTConfigShowChatParticipants: {
            BOOL show = [arg boolValue];
            [self ShowChatParticipants:show];
            break;
        }
        case _kWTConfigEnableChatProfile: {
            BOOL enable = [arg boolValue];
            [self EnableChatProfile:enable];
            break;
        }
        case _kWTConfigAllowModifyChatProfile: {
            BOOL allow = [arg boolValue];
            [self AllowModifyChatProfile:allow];
            break;
        }
        default: {

            break;
        }

    }

}


#pragma mark -

+ (void)ClearTempFiles {
    [WTSDKManager ClearTempDirectory];
}

// To show or hide guide button
+ (void)ShowGuideButton:(BOOL) show               // default = YES
{
    [WTSDKManager ShowGuideButton:show];
}

// To enable or disable sending audio message
+ (void)AllowSendAudioMessage:(BOOL) allow  // default = YES
{
    [WTSDKManager ShouldAllowSendAudioMessage:allow];
}

// To show or hide add participants option in new ticket page and chat item profile page
+ (void)AllowAddParticipants:(BOOL) allow    // default = YES
{
    [WTSDKManager ShouldAllowAddParticipant:allow];
}

// To show or hide remove participants option in chat item profile
+ (void)AllowRemoveParticipants:(BOOL) allow // default = NO
{
    [WTSDKManager ShouldAllowRemoveParticipant:allow];
}

// To show or hide welcome message
+ (void)ShowWelcomeMessage:(BOOL) show            // default = NO
{
    [WTSDKManager ShowWelcomeMessage:show];
}

// To show or hide Profile Info page
+ (void)ShowProfileInfoPage:(BOOL) show           // default = YES
{
    [WTSDKManager ShowProfileInfoPage:show];
}

// To create auto tickets:
//Chat ticket will create automatically when auto tickets is enabled, otherwise default ticket creation page will popup
+ (void)EnableAutoTickets:(BOOL) enable           // default = NO
{
    [WTSDKManager EnableAutoTickets:enable];
}

// To show or hide close chat button in chat page
+ (void)ShowExitButton:(BOOL) show                // default = NO
{
    [WTSDKManager ShowExitButton:show];
}

// To show or hide participants in chat profile page
+ (void)ShowChatParticipants:(BOOL) show          // default = YES
{
    [WTSDKManager ShowChatParticipants:show];
}

// To enable or disbale chat profile page
+ (void)EnableChatProfile:(BOOL) enable           // default = YES
{
    [WTSDKManager EnableChatProfile:enable];
}

// To allow modify  in chat profile page
+ (void)AllowModifyChatProfile:(BOOL) allow       // default = YES
{
    [WTSDKManager AllowModifyChatProfile:allow];
}

// To set Inactive chat timeout:
//Chat session will end if user is inactive for timeout interval duration. If timeout interval is 0, chat session will not end automatically. The default timout interval is 1800 seconds (30 minutes).
+ (void)SetInactiveChatTimeoutInterval:(double) timeoutInterval   // default = 1800 seconds (30 minutes).
{
    [WTSDKManager SetInactiveChatTimeoutInterval:timeoutInterval];
}

// To set timeinterval for checking the available agent // default 20 seconds
+ (void) SetAgentQueueTimeInterval:(double) timeInterval {
    [WTSDKManager SetAgentQueueTimeInterval:timeInterval];
}


@end
