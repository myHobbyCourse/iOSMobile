//
//  AppDelegate.h
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/9/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Reachability.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import "ValidationToast.h"


@class User;
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    ValidationToast *offlineBarStatus;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@property(strong,nonatomic) User *userCurrent;

@property(strong,nonatomic) NSString *sortCourseBy;
@property(strong,nonatomic) NSString *selectedCity;
@property(strong,nonatomic) NSString *deviceTokenReg;
@property(assign) BOOL isAlert;
@property(assign) BOOL isOpenProfile;
//@property(strong,nonatomic) NSMutableDictionary *preFillDict;

@property (retain, nonatomic)  Reachability* reachability;


- (void)registerPushNotification;


@end

