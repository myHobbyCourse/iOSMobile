//
//  MapPin.h
//  HobbyCourses-iOS
//
//  Created by Kirit on 13/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapPin : NSObject<MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, strong) NSString *courseId;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:(NSString *)placeName description:(NSString *)description courseId:(NSString*) Id;


@end
