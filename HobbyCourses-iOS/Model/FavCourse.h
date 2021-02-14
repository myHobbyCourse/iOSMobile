//
//  FavCourse.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 05/05/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavCourse : NSObject

@property(strong,nonatomic) NSString * title;
@property(strong,nonatomic) NSString *  nid;
@property(strong,nonatomic) NSString * image;
@property(strong,nonatomic) NSString * lastUpdate;

@property(strong,nonatomic) NSString * review_count;
@property(strong,nonatomic) NSString * price;
@property(strong,nonatomic) NSString * city;
@property(strong,nonatomic) NSString * author_avatar;
@property(strong,nonatomic) NSString * author_uid;
@property(strong,nonatomic) NSString * author;
@property(strong,nonatomic) NSString * vote_result;

- (id) initWith:(NSMutableDictionary*)dict;

@end
