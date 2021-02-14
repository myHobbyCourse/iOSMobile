//
//  Attendance.h
//  HobbyCourses
//
//  Created by iOS Dev on 08/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Attendance : NSObject
@property(strong,nonatomic) NSString *ID;
@property(strong,nonatomic) NSString *product_id;
@property(strong,nonatomic) NSString *course_title;
@property(strong,nonatomic) NSString *uid_owner;
@property(strong,nonatomic) NSString *uid_student;
@property(strong,nonatomic) NSString *student_name;
@property(strong,nonatomic) NSString *register_date;
@property(strong,nonatomic) NSString *course_time_start;
@property(strong,nonatomic) NSString *course_time_end;
@property(strong,nonatomic) NSString *attendance;
@property(strong,nonatomic) NSString *late;
@property(strong,nonatomic) NSString *comment;
@property(strong,nonatomic) NSString *student_avatar;
@property(strong,nonatomic) NSString *strDay;
- (id) initWith:(NSDictionary*)dict;


@end
