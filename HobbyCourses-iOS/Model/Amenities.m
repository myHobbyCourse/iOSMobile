//
//  Amenities.m
//  HobbyCourses
//
//  Created by iOS Dev on 19/03/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import "Amenities.h"

@implementation Amenities

- (id) initWith:(NSDictionary*)dict {
    
    self = [super init];
    if (self)
    {
        self.title = dict[@"title"];
        self.imgUrl = dict[@"src"];
    }
    return self;
}
-(NSURL *) getUrl{
    return [NSURL URLWithString:self.imgUrl];
}

@end
