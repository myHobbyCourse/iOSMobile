//
//  MyReview.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 05/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyReview : NSObject

@property(strong,nonatomic) NSString * Comment_title;


@property(strong,nonatomic) NSString * cid;
@property(strong,nonatomic) NSString * commented_nid;
@property(strong,nonatomic) NSString * post_date;
@property(strong,nonatomic) NSMutableArray * arrImages;
@property(strong,nonatomic) NSString * comment;
@property(strong,nonatomic) NSString *commented_course_title;
@property(strong,nonatomic) NSString *course_rating;
@property(strong,nonatomic) NSString * updated_date;

- (id) initWith:(NSDictionary*)dict;

@end
