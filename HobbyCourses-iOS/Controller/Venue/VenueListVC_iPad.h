//
//  VenueListVC_iPad.h
//  HobbyCourses
//
//  Created by iOS Dev on 03/12/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VenueListVC_iPad : ParentViewController

@property(strong,nonatomic) VenuesEntity *selectedVenue;
@property(nonatomic,strong) CourseDetail *courseEntity;

@end
