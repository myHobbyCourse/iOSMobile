//
//  Conversation.m
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/21/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import "Conversation.h"

@implementation Conversation

@synthesize user, arrMessages;

- (id) init {
    self = [super init];
    if (self) {
        user = [[User alloc] init];
        arrMessages = [[NSMutableArray alloc] init];
    }
    return self;
}

@end