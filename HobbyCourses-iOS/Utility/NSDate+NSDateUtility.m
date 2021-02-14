//
//  NSDate+NSDateUtility.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 25/06/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "NSDate+NSDateUtility.h"

@implementation NSDate (NSDateUtility)

-(NSDate *) toLocalTime
{
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: self];
    return [NSDate dateWithTimeInterval: seconds sinceDate: self];
}

-(NSDate *) toGlobalTime
{
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = -[tz secondsFromGMTForDate: self];
    return [NSDate dateWithTimeInterval: seconds sinceDate: self];
}

@end
