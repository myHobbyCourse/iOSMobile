//
//  TutorsEntity.m
//  HobbyCourses
//
//  Created by iOS Dev on 16/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "TutorsEntity.h"

@implementation TutorsEntity

-(id) init {
    self = [super init];
    if (self) {
        self.title = @"";
        self.tutor_details = @"";
        self.tutor_name = @"";
        self.tutor_id = @"";
        self.tutor_nid = @"";
        self.arrImgaes = [NSMutableArray new];
        self.address = @"";
        self.city = @"";
        self.pincode = @"";
        self.country = @"";

    }
    return self;
}
- (id) initWith:(NSMutableDictionary*)dict {
    
    self = [super init];
    if (self)
    {
        @try {
            self.title = dict[@"title"];
            NSString *desc = dict[@"tutor_details"];
            self.tutor_details = [desc removeHTML];
            self.tutor_name = dict[@"tutor_name"];
            self.tutor_id = dict[@"item_id"];
            self.tutor_nid = dict[@"nid"];
            NSDictionary *imgDict = dict[@"image"];
            self.address = dict[@"street"];
            self.city = dict[@"city"];
            self.pincode = dict[@"postal_code"];
            self.country = @"";

            self.arrImgaes = [NSMutableArray new];
            if ([imgDict isKindOfClass:[NSDictionary class]]) {
                self.imagePath = imgDict[@"src"];
                if (self.imagePath) {
                    [self.arrImgaes addObject:self.imagePath];
                }
            }
            
        }
        @catch (NSException *exception) { }
    }
    return self;
}

@end
