//
//  VenuesEntity.m
//  HobbyCourses
//
//  Created by iOS Dev on 17/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "VenuesEntity.h"

@implementation VenuesEntity

-(id) init {
    self = [super init];
    if (self) {
        self.title = @"";
        self.venue_details = @"";
        self.venue_name = @"";
        self.venue_id = @"";
        self.arrImgaes = [NSMutableArray new];
        self.address = @"";
        self.address1 = @"";
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
            self.venue_id = dict[@"item_id"];
            self.title = dict[@"title"];
            self.latitude = [NSString stringWithFormat:@"%@",dict[@"lat"]];
            self.longitude = [NSString stringWithFormat:@"%@",dict[@"lon"]];
            NSString *desc = dict[@"venue_details"];
            self.venue_details = [desc removeHTML];
            self.location = dict[@"location"];
            self.venue_name = [NSString stringWithFormat:@"%@",dict[@"venue_name"]];
            self.address = dict[@"street"];
            self.address1 = dict[@"city"];
            self.pincode = dict[@"postal_code"];
            self.country = @"";
            NSDictionary *imgDict = dict[@"image"];
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
