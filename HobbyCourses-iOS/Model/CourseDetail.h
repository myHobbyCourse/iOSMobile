//
//  CourseDetail.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 01/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ProductEntity,Amenities;
@interface CourseDetail : NSObject

@property(strong,nonatomic) NSString * title;
@property(strong,nonatomic) NSString *  nid;
@property(strong,nonatomic) NSString * author;
@property(strong,nonatomic) NSString * company;
@property(strong,nonatomic) NSString *  city;
@property(strong,nonatomic) NSString *  postal_code;
@property(strong,nonatomic) NSString *  address_2;
@property(strong,nonatomic) NSString * address_1;
@property(strong,nonatomic) NSString * author_uid;
@property(strong,nonatomic) NSString *  category;
@property(strong,nonatomic) NSString *  subcategory;

@property(strong,nonatomic) NSString *  comment_count;

@property(strong,nonatomic) NSMutableArray * field_deal_image;
@property(strong,nonatomic) NSString * field_money_back_guarantee;
@property(strong,nonatomic) NSString * offer_valid_from;
@property(strong,nonatomic) NSString * offer_valid_untill;
@property(strong,nonatomic) NSString *post_date;
@property(strong,nonatomic) NSString *course_rating;
@property(strong,nonatomic) NSString * Description;
@property(strong,nonatomic) NSString * mobile;
@property(strong,nonatomic) NSString * if_bought;

@property(strong,nonatomic) NSString *field_trial_class;
@property(strong,nonatomic) NSString *sold;
@property(strong,nonatomic) NSString *quantity;
@property(strong,nonatomic) NSString *certifications;
@property(strong,nonatomic) NSMutableArray<NSString*> *certificationsArr;


@property(strong,nonatomic) NSString *shorten_url;
@property(strong,nonatomic) NSMutableArray<Amenities *> *amenities;
@property(strong,nonatomic) NSString *cancellation_type;
@property(strong,nonatomic) NSString *member_since;
@property(strong,nonatomic) NSString *last_updated;
@property(strong,nonatomic) NSString * vendor_review_count;

@property(strong,nonatomic) NSMutableArray<NSString*> * youtube_video;
@property(strong,nonatomic) NSString *product_id;


@property(strong,nonatomic) NSString *course_start_date;
@property(strong,nonatomic) NSString *course_end_date;
@property(strong,nonatomic) NSString *sessions_number;
@property(strong,nonatomic) NSString *landLine_number;
@property(strong,nonatomic) NSString *batch_size;
@property(strong,nonatomic) NSString * educator_introduction;


@property(strong,nonatomic) NSString *address_verified_flagged;
@property(strong,nonatomic) NSString *mobile_verified_flagged;
@property(strong,nonatomic) NSString *social_media_verified_flagged;
@property(strong,nonatomic) NSString *credit_card_verified_flagged;
@property(strong,nonatomic) NSString *landline_verified_flagged;
@property(strong,nonatomic) NSString *email_verified_flagged;

@property(strong,nonatomic) NSString *favorite_flag_flagged;
@property(strong,nonatomic) NSString *spam_flag_flagged;

@property(strong,nonatomic) NSString *author_image;
@property(strong,nonatomic) NSString *spam_flag_counter;

@property(strong,nonatomic) NSString *age_group;
@property(strong,nonatomic) NSString *age_groupIndex;

@property(strong,nonatomic) NSString *short_description;
@property(strong,nonatomic) NSString *course_requirements;
@property(strong,nonatomic) NSString *status;
@property(strong,nonatomic) NSString *tutor;
@property(strong,nonatomic) NSString * latitude;
@property(strong,nonatomic) NSString * longitude;

@property(strong,nonatomic) NSString * suitable_for;
@property(strong,nonatomic) NSString * people_saved_course;
@property(strong,nonatomic) NSString * qrcode;
@property(strong,nonatomic) NSString * qrcode_vendor;
@property(strong,nonatomic) NSMutableArray<ProductEntity*> * productArr;



@property (assign) BOOL isFullTitle;


- (id) initWith:(NSMutableDictionary*)dict;

@end
