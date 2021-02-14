//
//  UserPhoneBook.h
//  TableShare
//
//  Created by Yudiz Solutions Pvt. Ltd. on 02/06/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserPhoneBook : NSObject
+ (instancetype)sharedInstance;
- (void)checkAuthorizationStatus:(void(^)(BOOL,NSError*))block;
- (void)fetchUserNameNumberEmail:(void (^)(NSArray <NSDictionary*> *))block;
- (void)fetchAllEmailsAndNumbers:(void (^)(NSDictionary*))block;
@end
