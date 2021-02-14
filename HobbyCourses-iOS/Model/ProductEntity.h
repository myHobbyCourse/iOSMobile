//
//  ProductEntity.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 31/05/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Student;
@interface ProductEntity : NSObject

@property(strong,nonatomic) NSString * batch_size;
@property(strong,nonatomic) NSString * course_end_date;
@property(strong,nonatomic) NSString * course_start_date;
//@property(strong,nonatomic) NSString * field_age_group;
@property(strong,nonatomic) NSString * initial_price;
@property(strong,nonatomic) NSString * price;
@property(strong,nonatomic) NSString * product_id;
@property(strong,nonatomic) NSString * quantity;
@property(strong,nonatomic) NSString * sessions_number;
@property(strong,nonatomic) NSString * sold;
@property(strong,nonatomic) NSString * status;
@property(strong,nonatomic) NSString * title;
@property(strong,nonatomic) NSString * tutor;
@property(strong,nonatomic) NSMutableArray *timings;
@property(strong,nonatomic) NSMutableArray<TimeBatch*> *timingsDate;
@property(strong,nonatomic) NSMutableArray<Student*> *students ;


- (id) initWith:(NSDictionary*)dict;

@end
