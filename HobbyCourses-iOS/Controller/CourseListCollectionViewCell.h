//
//  CourseListCollectionViewCell.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 24/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CourseListCollectionViewCell;
@protocol CourseCVCellProtocol <NSObject>
-(void) btnLocationButtonTapped:(CourseTableViewCell *)cell;
-(void) btnCommentBtnTapped:(CourseTableViewCell*) cell;
@end

@interface CourseListCollectionViewCell : UICollectionViewCell
{
    IBOutlet UILabel*       lblName;
    IBOutlet UILabel*       lblTitle;
    IBOutlet UILabel*       lblDuration;
    IBOutlet UILabel*       lblPeriod;
    IBOutlet UILabel*       lblAges;
    IBOutlet UILabel*       lblLocation;
    IBOutlet UILabel*       lblNotifyCount;
    
    IBOutlet UIButton*       btnComments;
    __weak IBOutlet UIButton *btnLocation;
    
    
    IBOutlet UIScrollView *imgScroll;
    IBOutlet NSLayoutConstraint *scrollWidth;

    IBOutlet UIView*       priceView;
    IBOutlet UILabel*       lblPrice;
    IBOutlet UILabel*       lblDiscount;
}

@property (nonatomic, strong) IBOutlet UIImageView *imageView1;
@property (nonatomic, strong) IBOutlet UIImageView *imageView2;
@property (nonatomic, strong) IBOutlet UIImageView *imageView3;
@property (nonatomic, weak) id<CourseCVCellProtocol> delegate;

@property (strong,nonatomic)     IBOutlet UIScrollView *imgScroll;
- (void) setCourseData:(Course*) course customCell:(CourseListCollectionViewCell *)cell;
- (void) setData:(CourseDetail*) course customCell:(CourseListCollectionViewCell *)cell;

@end
