//
//  MyCoursesTableViewCell.h
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/15/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"
#import "MGSwipeTableCell.h"
#import "MGSwipeButton.h"

@interface MyCoursesTableViewCell : MGSwipeTableCell {
    IBOutlet UILabel*   lblName;
    IBOutlet UILabel*   lblTitle;
    IBOutlet UIButton*  btnUsers;
    IBOutlet UIButton*   btnPost;
    IBOutlet UIButton*   btnAvailable;
    
    IBOutlet UILabel*  lblBatchSize;
    IBOutlet UILabel*  lblLoccation;
    IBOutlet UILabel*  lblTutor;
    IBOutlet UILabel*  lblPost;
    IBOutlet UILabel* lblAvailable;
    
    IBOutlet UIImageView*  imgV;

}

@property (assign, nonatomic) BOOL isDraft;
- (void) setData:(CourseDetail*) course;
- (void) setOfflineData:(DataClass*) course;
@end
