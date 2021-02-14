//
//  DayMessages.m
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/16/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import "DayMessages.h"

@implementation DayMessages

@synthesize day, arrMessages;

- (id) init {
    self = [super init];
    if (self) {
        day = @"";
        arrMessages = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
