//
//  Student.h
//  HobbyCourses
//
//  Created by iOS Dev on 08/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject

@property(strong,nonatomic) NSString *order_id;
@property(strong,nonatomic) NSString *uid;
@property(strong,nonatomic) NSString *name;
@property(strong,nonatomic) NSString *avatar;
@property(strong,nonatomic) NSString *presence;
@property(strong,nonatomic) NSString *comment;
@property(strong,nonatomic) NSString *late;
- (id) initWith:(NSDictionary*)dict;

@end

