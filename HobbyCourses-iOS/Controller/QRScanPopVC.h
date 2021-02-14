//
//  QRScanPopVC.h
//  HobbyCourses
//
//  Created by iOS Dev on 30/03/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRScanPopVC : ParentViewController

@property(strong,nonatomic) CourseDetail *courseObj;
@property(assign) BOOL isFromCourseDetails;
@end
