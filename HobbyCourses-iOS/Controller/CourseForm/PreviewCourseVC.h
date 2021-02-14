//
//  PreviewCourseVC.h
//  HobbyCourses
//
//  Created by iOS Dev on 15/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Amenities.h"
@class Amenities;

@interface PreviewCourseVC : ParentViewController
@property(nonatomic,strong) NSMutableArray<Amenities*> *arrAmenities;

@end
