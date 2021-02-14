//
//  RevisionHistoryData.h
//  HobbyCourses
//
//  Created by iOS Dev on 07/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RevisionHistoryData : NSObject

@property(strong,nonatomic) NSString * price;
@property(strong,nonatomic) NSString * status;
@property(strong,nonatomic) NSString * start_date;
@property(strong,nonatomic) NSString * end_date;
@property(strong,nonatomic) NSString * sessions;
@property(strong,nonatomic) NSString * batch_size;
@property(strong,nonatomic) NSString * tutor_name;
@property(strong,nonatomic) NSString * age_group;
@property(strong,nonatomic) NSString * field_stock;
@property(strong,nonatomic) NSString * trial_class;

- (id) initWith:(NSMutableDictionary*)dict;


@end
