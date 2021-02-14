//
//  AppDelegate.m
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/9/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import "AppDelegate.h"


#import "Constants.h"
#import <GooglePlus/GooglePlus.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <SDWebImage/SDWebImage.h>
#import <SDImageCache.h>
#import <SDWebImageCacheSerializer.h>

static NSString * const kClientID =@"416018487342";
static NSString * const kPDKExampleFakeAppId = @"4807449837091956838";


@interface AppDelegate () <GPPDeepLinkDelegate>


@end

@implementation AppDelegate
@synthesize userCurrent,reachability,isOpenProfile;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
//    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : ClientId_live,
//                                                           PayPalEnvironmentSandbox : ClientId_dev}];
//    [[PayPalManager getInstance] setupPaypal];
    
    // Set app's client ID for |GPPSignIn| and |GPPShare|.
    [GPPSignIn sharedInstance].clientID = kClientID;
    // Read Google+ deep-link data.
    [GPPDeepLink setDelegate:self];
    [GPPDeepLink readDeepLinkAfterInstall];
    
    [PDKClient configureSharedInstanceWithAppId:kPDKExampleFakeAppId];
    
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    //NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    [GMSServices provideAPIKey:googleKey];
    [GMSPlacesClient provideAPIKey:googleKey];

    [UserDefault setBool:false forKey:kUserAppType];
//    self.preFillDict = [[NSMutableDictionary alloc]init];
    
    self.sortCourseBy = @"0";
    self.selectedCity = @"";
    
    [Fabric with:@[CrashlyticsKit]];
    
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor blackColor]} forState:UIControlStateSelected];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    self.isAlert = false;
    [self setUpRechability];
    [self.window setTintColor:ThemEColor];
    [self configuredGoogleAnalytics];
    isOpenProfile = false;
    
    application.applicationIconBadgeNumber = 0;
    
//    for (NSString* fontFamily in [UIFont familyNames]) {
//        NSArray *fontNames = [UIFont fontNamesForFamilyName:fontFamily];
//        NSLog (@"%@: %@", fontFamily, fontNames);
//    }
    NSLog (@"%@", NSStringFromCGSize(UIScreen.mainScreen.bounds.size));
//    [self registerPushAPI];
    
    return YES;
}
-(void) configuredGoogleAnalytics{
    // Configure tracker from GoogleService-Info.plist.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
//    gai.logger.logLevel = kGAILogLevelVerbose;
    
    _arrColorsBathces = [NSMutableArray new];
    [_arrColorsBathces addObject:@"F68B5A"];
    [_arrColorsBathces addObject:@"830006"];
    [_arrColorsBathces addObject:@"AC8DBC"];
    [_arrColorsBathces addObject:@"808080"];
    [_arrColorsBathces addObject:@"00B05A"];
    [_arrColorsBathces addObject:@"EB007A"];
    [_arrColorsBathces addObject:@"000080"];
    
}
#pragma mark- Push Notification Code Added
- (void)registerPushNotification{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    }
}
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        
    }];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        
    }];
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}
#pragma mark - Reachebility method
-(void)setUpRechability
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    if(remoteHostStatus == NotReachable){
        NSLog(@"no");
    }else if(remoteHostStatus == ReachableViaWiFi)
    {
        NSLog(@"wifi");
    }
    else if(remoteHostStatus == ReachableViaWWAN){
        NSLog(@"cell");
    }
    
}

- (void) handleNetworkChange:(NSNotification *)notice
{
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    if (remoteHostStatus == NotReachable) {
        NSLog(@"no");
       offlineBarStatus = [ValidationToast showBarMessage:kNoNet inView:[UIApplication sharedApplication].keyWindow.rootViewController.view withColor:ThemEColor autoClose:false];
    } else if(remoteHostStatus == ReachableViaWiFi || remoteHostStatus == ReachableViaWWAN) {
        NSLog(@"wifi");
        [offlineBarStatus removeFromSuperview];
    }
}

-(void) registerPushAPI {
    if (!_isStringEmpty(APPDELEGATE.deviceTokenReg)) {
        if (![UserDefault boolForKey:@"isPushSet"]) {
            NSDictionary *dict = @{@"type":@"ios",@"token":APPDELEGATE.deviceTokenReg};
            [[NetworkManager sharedInstance] postRequestUrl:apiPush paramter:dict withCallback:^(id jsonData, WebServiceResult result) {
                if (result == WebServiceResultSuccess) {
                    [UserDefault setBool:true forKey:@"isPushSet"];
                }
            }];
        }
    }
    
}

#pragma mark - UIApplication
- (void)application:(UIApplication *)application   didRegisterUserNotificationSettings:   (UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [DefaultCenter postNotificationName:@"pushCallBack" object:self];
    
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString * tokenAsString = [[[deviceToken description]
                                 stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
                                stringByReplacingOccurrencesOfString:@" " withString:@""];
    [UserDefault setObject:tokenAsString forKey:kUserDeviceTokenKey];
    [UserDefault synchronize];
    
    NSLog(@"device token -- %@",tokenAsString);
    self.deviceTokenReg = tokenAsString;
    [DefaultCenter postNotificationName:@"pushCallBack" object:self];
    
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    NSLog(@"user info for remote notification : %@",userInfo);
    //Check application state then perform action
    if (application.applicationState == UIApplicationStateActive)
    {
        //Display view as per notification type when application in active state
        if(userInfo[@"aps"][@"alert"]){
            // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view.
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"MyHobbyCourse Notification" message:[NSString stringWithFormat:@"%@",userInfo[@"aps"][@"alert"]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alertView show];
            
            
        }
        
        NSLog(@"Remote notification received when app in Active mode......");
    }
    else if (application.applicationState == UIApplicationStateBackground)
    {
        NSLog(@"Remote notification received when app in background mode......");
        
        
    }
}
#pragma mark-

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"AppBecomeActive"
     object:nil];
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if([url.scheme isEqualToString:@"fb394605497414395"]){
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation
                ];
    }else{
        return [[GIDSignIn sharedInstance] handleURL:url sourceApplication:sourceApplication annotation:annotation];
    }
}
#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.codeatena.HobbyCourses_iOS" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"HobbyCourses_iOS" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"HobbyCourses_iOS.sqlite"];
    NSError *error = nil;
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES,
                              NSInferMappingModelAutomaticallyOption: @YES};
    
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
