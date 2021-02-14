//
//  CourseFrom.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 29/05/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "CourseFrom.h"

@implementation CourseFrom

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.coursestartDate = @"";
        self.courseEndDate = @"";
        self.coursePrice = @"";
        self.courseDiscount = @"";
        self.courseSession = @"";
        self.courseBatchSize = @"";
    }
    return self;
}
@end
