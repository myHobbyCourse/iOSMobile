//
//  Course.h
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/13/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Course : NSObject


@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* period;

@property (assign) int currentPage;
@property (nonatomic) int education;
@property (nonatomic) int notifyCount;
@property (nonatomic) int user;

@property (nonatomic, strong) NSString* post;
@property (nonatomic, strong) NSString* available;

//My change
@property (nonatomic, strong) NSString* nid;
@property (nonatomic, strong) NSString* short_description;
@property (nonatomic, strong) NSString* post_date;
@property (nonatomic, strong) NSString* author;
@property (nonatomic, strong) NSString* city;
@property(strong,nonatomic) NSString *  address_2;
@property(strong,nonatomic) NSString * address_1;
@property (nonatomic, strong) NSString* category;
@property (nonatomic, strong) NSString* sub_category;
@property (nonatomic, strong) NSString* trial_class;
@property (nonatomic, strong) NSString* offer_valid_from;
@property (nonatomic, strong) NSString* offer_valid_until;
@property (nonatomic, strong) NSString* guarantee;
@property (nonatomic, strong) NSMutableArray* images;
@property (nonatomic, strong) NSString* comment_count;
@property (nonatomic, strong) NSString* descriptions;
@property (nonatomic, strong) NSString* commerce_price;

@property (nonatomic, strong) NSMutableArray* productArr;

@property(strong,nonatomic) NSString * latitude;
@property(strong,nonatomic) NSString * longitude;

@property (nonatomic, strong) NSString* requirements;
@property (nonatomic, strong) NSString* path;
@property (nonatomic, strong) NSString* daytime;


- (id) initWith:(NSDictionary*)dict;



@end
