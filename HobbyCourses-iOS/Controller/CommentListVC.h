//
//  CommentListVC.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 05/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentListVC : ParentViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView  *tblComments;
    IBOutlet UIView  *viewShadow;
    IBOutlet RateView  *avgRateView;
    IBOutlet UILabel  *lblReviewCount;
    IBOutlet UILabel *lblCourseTittle;
}
@property(strong,nonatomic) NSString *nidComment;
@property(strong,nonatomic) NSString *courseTittle;
@property(assign) BOOL isAllReview;
@property(assign) BOOL isCourseAllReview;
@property(strong,nonatomic) NSString *nid;

@property(strong,nonatomic) Review *review;

@end
