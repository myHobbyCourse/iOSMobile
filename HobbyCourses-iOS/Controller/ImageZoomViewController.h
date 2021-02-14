//
//  ImageZoomViewController.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 16/02/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseDetail.h"
@interface ImageZoomViewController : ParentViewController<UIScrollViewDelegate>
{
    IBOutlet UIImageView *imageView;
    IBOutlet UIImageView *imgProfile;
    IBOutlet UILabel *lblTittle;
    IBOutlet UILabel *lblComments;
    IBOutlet UIScrollView *zoomScrollView;
    IBOutlet UIView *viewTop;
    IBOutlet UIView *viewBottom;
    IBOutlet UILabel *lblTopDate;
    IBOutlet UILabel *lblCurrentImage;
    IBOutlet UILabel *lblCourseTitle;
}
@property (strong,nonatomic) UIImage *img;
@property (strong,nonatomic) NSString *path;
@property (strong,nonatomic) NSArray *arrData;
@property (strong,nonatomic) CourseDetail * course;


@end
