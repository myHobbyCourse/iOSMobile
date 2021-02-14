//
//  MapPin.m
//  HobbyCourses-iOS
//
//  Created by Kirit on 13/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "MapPin.h"

@implementation MapPin

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:placeName description:description courseId:(NSString*) Id{
    self = [super init];
    if (self != nil) {
        coordinate = location;
        title = placeName;
        subtitle = description;
        self.courseId = Id;
    }
    return self;
}

@end
