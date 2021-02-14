//
//  TimeBatch.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 03/07/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeBatch : NSObject

@property(strong,nonatomic) NSString * sessionId;

@property(strong,nonatomic) NSDate * batch_end_date;
@property(strong,nonatomic) NSDate * batch_start_date;
@property(strong,nonatomic) NSString * dayName;
@property(strong,nonatomic) NSDate * class_name;


@property(strong,nonatomic) NSDate * sDate;
@property(strong,nonatomic) NSDate * eDate;

- (id) initWith:(NSMutableDictionary*)dict;


@end
