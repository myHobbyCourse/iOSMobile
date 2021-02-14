//
//  Message.h
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/16/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "ParticipantModel.h"
#import "JSONModel.h"
@protocol ParticipantModel
@end

@interface Message : NSObject


@property (nonatomic, strong) NSString* mid;
@property (nonatomic, strong) NSString* subject;
@property (nonatomic, strong) NSString* body;
@property (nonatomic, strong) NSString*sending_time;
@property (nonatomic, strong) NSDate *dateSending;
@property (nonatomic, strong) NSString*is_new;
@property (nonatomic, strong) NSString* thread_id;
@property (nonatomic, strong) NSString* deleted;
@property (nonatomic, strong) NSString*author;
@property (nonatomic, strong) NSString* author_uid;
@property (nonatomic, strong) NSString*author_picture;
@property (strong, nonatomic) NSString *recipient;
@property (strong, nonatomic) NSString *uid;

- (id) initWith:(NSDictionary*)dict ;

@end
