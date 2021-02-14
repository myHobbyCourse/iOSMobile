//
//  MyCommentViewController.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 21/02/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCommentViewController : ParentViewController<UITableViewDelegate,UITableViewDataSource> {
    IBOutlet UITableView *tblComment;
  
    IBOutlet RateView *rate;
    IBOutlet RateView *avgRateView;
    IBOutlet UICollectionView *cvPics;
    __weak IBOutlet UILabel *lblTitle;
    __weak IBOutlet UITextView *txtComment;
    __weak IBOutlet UITextField *tfTittle;
    IBOutlet UIButton *btnUpload;
    IBOutlet UIButton *btnViewCourse;
    IBOutlet UIView  *viewShadow;
    IBOutlet UILabel  *lblReviewCount;

}

@property(strong,nonatomic) MyReview *editReview;
@end
