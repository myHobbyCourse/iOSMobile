//
//  Conversation.h
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/21/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Conversation : NSObject

@property (nonatomic, strong) User* user;
@property (nonatomic, strong) NSMutableArray* arrMessages;

@end
