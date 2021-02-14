//
//  CourseTableViewCell.h
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/13/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"
#import "ParentViewController.h"

@class CourseTableViewCell;
@protocol CourseTableViewCellProtocol <NSObject>
-(void) btnLocationButtonTapped:(CourseTableViewCell *)cell;
-(void) btnCommentBtnTapped:(CourseTableViewCell*) cell;
@end

@interface CourseTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource> {
    IBOutlet UILabel*       lblName;
    IBOutlet UILabel*       lblTitle;
    IBOutlet UILabel*       lblDuration;
    IBOutlet UILabel*       lblPeriod;
    IBOutlet UILabel*       lblAges;
    IBOutlet UILabel*       lblLocation;
    IBOutlet UILabel*       lblNotifyCount;

    IBOutlet UIButton*       btnComments;
    __weak IBOutlet UIButton *btnLocation;

    IBOutlet UIView*       priceView;
    IBOutlet UILabel*       lblPrice;
    IBOutlet UILabel*       lblDiscount;
    
    IBOutlet UIScrollView *imgScroll;
}

@property (nonatomic, weak) id<CourseTableViewCellProtocol> delegate;

@property (strong,nonatomic)     IBOutlet UIScrollView *imgScroll;
- (void) setData:(Course*) course customCell:(CourseTableViewCell*) cell isscroll:(BOOL) flag ;
- (void) setData:(CourseDetail*) course customCell:(CourseTableViewCell *)cell;
@end
