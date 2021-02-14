//
//  RevisionHistoryTimings.h
//  HobbyCourses
//
//  Created by iOS Dev on 07/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RevisionHistoryTimings : NSObject
@property(strong,nonatomic) NSString *title;
@property(strong,nonatomic) NSString *start;
@property(strong,nonatomic) NSString *end;

- (id) initWith:(NSMutableDictionary*)dict;

@end
