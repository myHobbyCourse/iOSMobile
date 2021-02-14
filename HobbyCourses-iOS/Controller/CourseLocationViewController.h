//
//  CourseLocationViewController.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 21/02/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseLocationViewController : ParentViewController
{
    IBOutlet UIView* viewCategory;
    IBOutlet UIView* viewCourseDetail;
    IBOutlet UIView* viewCourseRound;
    IBOutlet UITextField *tfSearchLocation;
    
    IBOutlet UIButton *btnCateory;

    IBOutlet UIButton *btnViewCourse;
    IBOutlet UITextView *txtView;
    IBOutlet UILabel *lblAddress;
    IBOutlet UILabel *lblCourseTittle;
    IBOutlet UITableView *tblCategory;
}

@property (strong, nonatomic) NSMutableArray *arrayCourseList;
@property (strong, nonatomic) CourseDetail *selectedCourse;
@property (assign) BOOL isFromDetail;
@end
