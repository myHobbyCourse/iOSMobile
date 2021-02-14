//
//  CourseSchedule.h
//  HobbyCourses
//
//  Created by iOS Dev on 07/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseSchedule : NSObject
@property(strong,nonatomic) NSString *nid;
@property(strong,nonatomic) NSString *title;
@property(strong,nonatomic) NSString *author;
@property(strong,nonatomic) NSString *post_date;
@property(strong,nonatomic) NSString * author_uid;
@property(strong,nonatomic) NSString *city;
@property(strong,nonatomic) NSMutableArray *field_deal_image;

@property(strong,nonatomic) NSMutableArray<ProductEntity*> *arrProducts;

- (id) initWith:(NSDictionary*)dict;

@end
