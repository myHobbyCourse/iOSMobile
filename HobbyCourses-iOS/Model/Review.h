//
//  Review.h
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/17/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Review : NSObject

@property (nonatomic, strong) User* user;
@property (nonatomic) float rate;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* text;


@property (nonatomic, strong) NSString*subject;
@property (nonatomic, strong) NSString*author;
@property (nonatomic, strong) NSString*author_uid;
@property (nonatomic, strong) NSString*comment;;
@property (nonatomic, strong) NSString*commented_nid;
@property (nonatomic, strong) NSString*post_date;
@property (nonatomic, strong) NSString* commented_node_title;
@property (nonatomic) float course_rating;
@property (nonatomic, strong) NSString*like;
@property (nonatomic, strong) NSString*dislike;
@property (nonatomic, strong) NSMutableArray *imagesArr;
@property (nonatomic, strong) NSString *avatar;


- (id) initWith:(NSDictionary *)dict;

@end
