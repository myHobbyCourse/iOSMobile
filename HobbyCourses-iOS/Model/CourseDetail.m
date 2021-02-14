//
//  CourseDetail.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 01/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "CourseDetail.h"

@implementation CourseDetail

- (id) initWith:(NSMutableDictionary*)dict {
    self = [super init];
    if (self) {
        
        @try
        {
            self.title = dict[@"title"];
            self.qrcode = dict[@"qrcode"];
            self.qrcode_vendor = dict[@"qrcode_vendor"];
            self.nid = dict[@"nid"];
            self.author = dict[@"author"];
            self.company = dict[@"company"];
            self.city = dict[@"city"];
            self.postal_code = dict[@"postal_code"];
            self.address_2 = dict[@"street"];
            self.address_1 = dict[@"venue"];
            self.author_uid = dict[@"author_uid"];
            self.category = dict[@"category"];
            self.subcategory = dict[@"sub_category"];
            self.comment_count = [NSString stringWithFormat:@"%@",dict[@"comment_count"]];
            self.latitude = dict[@"latitude"];
            self.longitude = dict[@"longitude"];
            
            self.isFullTitle = false;
            if (dict[@"field_deal_image"])
            {
                NSArray *arr = dict[@"field_deal_image"];
                if (arr && arr.count>0)
                {
                    self.field_deal_image = [[NSMutableArray alloc]init];
                    if ([arr isKindOfClass:[NSDictionary class]])
                    {
                        [self.field_deal_image addObject:[arr valueForKey:@"src"]];
                        
                    }else{
                        for(NSDictionary *imgDict in arr)
                        {
                            if([imgDict valueForKey:@"src"])
                            {
                                [self.field_deal_image addObject:[imgDict valueForKey:@"src"]];
                            }
                        }
                    }
                }
            }
            if (self.field_deal_image) {
                NSSet *set = [NSSet setWithArray:self.field_deal_image];
                [self.field_deal_image removeAllObjects];
                self.field_deal_image = [[set allObjects] mutableCopy];
            }
            self.field_money_back_guarantee = dict[@"field_money_back_guarantee"];
            NSDateFormatter *format24 = global24Formatter();
            NSDateFormatter *formateDate = globalDateOnlyFormatter();
            NSString *d1 = dict[@"offer_valid_from"];
            NSString *d2 = dict[@"offer_valid_untill"];
            if (d1) {
                NSDate *dd = [format24 dateFromString:d1];
                if (dd) {
                    self.offer_valid_from = [formateDate stringFromDate:dd];;
                }
            }
            if (d2) {
                NSDate *dd = [format24 dateFromString:d2];
                if (dd) {
                    self.offer_valid_untill = [formateDate stringFromDate:dd];
                }
            }
            
            self.post_date = dict[@"post_date"];
            self.course_rating = dict[@"course_rating"];
            if (!_isStringEmpty(self.course_rating)) {
                self.course_rating =  ([self.course_rating componentsSeparatedByString:@"/"].count > 0) ? [self.course_rating componentsSeparatedByString:@"/"][0]: self.course_rating;
            }
            self.mobile = dict[@"mobile"];
            self.if_bought = dict[@"if_bought"];
            NSString *desc = dict[@"Description"];
            if([desc isKindOfClass:[NSString class]]){
                self.Description = [desc removeHTML];
            }else{
                self.Description = @"";
            }
            self.field_trial_class = dict[@"field_trial_class"];
            if (self.field_trial_class == nil) {
                self.field_trial_class = @"NO";
            }
            self.sold = dict[@"sold"];
            self.quantity = dict[@"quantity"];
            
            self.certifications = dict[@"certifications"];
            self.certificationsArr = [NSMutableArray new];
            if (!_isStringEmpty(self.certifications)) {
                NSArray *aa = [self.certifications componentsSeparatedByString:@","];
                [self.certificationsArr addObjectsFromArray:aa];
            }
            self.youtube_video = [[NSMutableArray alloc]init];
            NSString *strYoutube = dict[@"youtube_video"];
            if (!_isStringEmpty(strYoutube))
            {
                NSArray *arr = [strYoutube componentsSeparatedByString:@"|"];
                if (arr.count>0)
                {
                    for (NSString *url in arr)
                    {
                        NSArray *idArr = [url componentsSeparatedByString:@"v="];
                        NSString *trimmedString = [[idArr lastObject] stringByTrimmingCharactersInSet:
                                                   [NSCharacterSet whitespaceCharacterSet]];
                        [self.youtube_video addObject:trimmedString];
                    }
                }
            }
            
            self.product_id = dict[@"product_id"];
            
            self.course_start_date = dict[@"course_start_date"];
            self.course_end_date = dict[@"course_end_date"];
            self.sessions_number = dict[@"sessions_number"];
            self.landLine_number = dict[@"landLine_number"];
            if (self.landLine_number == nil || [self.landLine_number isEqualToString:@""]) {
                self.landLine_number = @" - ";
            }
            self.batch_size = dict[@"batch_size"];
            self.educator_introduction = dict[@"educator_introduction"];
            
            self.address_verified_flagged = dict[@"address_verified_flagged"];
            self.mobile_verified_flagged = dict[@"mobile_verified_flagged"];
            self.social_media_verified_flagged = dict[@"social_media_verified_flagged"];
            self.credit_card_verified_flagged = dict[@"credit_card_verified_flagged"];
            self.landline_verified_flagged = dict[@"landline_verified_flagged"];
            self.email_verified_flagged = dict[@"email_verified_flagged"];
            self.spam_flag_flagged = dict[@"spam_flag_flagged"];
            self.favorite_flag_flagged = dict[@"favorite_flag_flagged"];
            self.author_image = dict[@"author_image"];
            self.spam_flag_counter = [NSString stringWithFormat:@"%@", dict[@"spam_flag_counter"]];
            NSString *req = dict[@"course_requirements"];
            if (req) {
                self.course_requirements = [req removeHTML];
            }else{
                self.course_requirements = @"";
            }
            NSString *shortDesc = dict[@"short_description"];
            if (shortDesc) {
                self.short_description = shortDesc.removeHTML;
            }else{
                self.short_description = @"";
            }
            self.status = dict[@"status"];
            self.tutor = dict[@"tutor"];
            NSDictionary *ageDict = dict[@"age_group"];
            if ([ageDict isKindOfClass:[NSDictionary class]]) {
                self.age_group = _isStringEmpty(ageDict[@"description"]) ? @"" : ageDict[@"description"];
                self.age_groupIndex = ageDict[@"num"];
            }
            
            
            self.productArr = [[NSMutableArray alloc]init];
            NSArray *arrValue = dict[@"products"];
            if ([arrValue isKindOfClass:[NSArray class]]) {
                for (NSMutableDictionary *dict in arrValue) {
                    NSMutableDictionary *d = [dict mutableCopy];
                    [d handleNullValue];
                    ProductEntity * entity = [[ProductEntity alloc]initWith:d];
                    if (entity) {
                        [self.productArr addObject:entity];
                    }
                }
            }
            self.shorten_url = dict[@"shorten_url"];
            self.amenities = [NSMutableArray new];
            
            if ([dict[@"amenities"] isKindOfClass:[NSArray class]]) {
                NSArray *arr = dict[@"amenities"];
                for(NSDictionary * dict in arr) {
                    if ([dict isKindOfClass:[NSDictionary class]]) {
                        Amenities *ame = [[Amenities alloc] initWith:dict];
                        if (ame) {
                            [self.amenities addObject:ame];
                        }
                    }
                    
                }
            }
            
            self.cancellation_type = dict[@"cancellation_type"];
            self.member_since = dict[@"member_since"];
            self.last_updated = dict[@"last_updated"];
            self.vendor_review_count = dict[@"vendor_review_count"];
            
            self.suitable_for = dict[@"suitable_for"];
            self.people_saved_course = dict[@"people_saved_course"];
        }
        
        @catch (NSException *exception) {}
    }
    return self;
}

@end
