//
//  CourseDetailViewController.h
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/17/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"
#import "CourseDetail.h"
#import "CMPopTipView.h"

@class CourseDetail,CMPopTipView;

@interface CourseDetailViewController : ParentViewController <UITableViewDataSource, UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,YTPlayerViewDelegate,CMPopTipViewDelegate>{

    IBOutlet UIImageView*       imvVideoTabSel;
    IBOutlet UIImageView*       imvBatchesTabSel;

    IBOutlet UIImageView*       imvCertificationTabSel;
    IBOutlet UIImageView*       imvReviewTabSel;
    IBOutlet UIImageView*       imvDurationTabSel;
    IBOutlet UITableView*       tblCertifications;
    IBOutlet UITableView*       tblReviews;
    IBOutlet UITableView*       tblProduct;
    IBOutlet UITableView*       tblProductCopy;

    IBOutlet UICollectionView *collectView;
    IBOutlet UICollectionView *cvRecent;
    IBOutlet UICollectionView *cvLocal;
    IBOutlet UICollectionView *cvImageScroll;
    IBOutlet UICollectionView *cvImageLandscap;
    IBOutlet UICollectionView *cvLbl;
    
    IBOutlet UIScrollView *scrollViewImages;
    
    IBOutlet UICollectionView *cvRecentCopy;
    IBOutlet UICollectionView *cvLocalCopy;

    
    IBOutlet UIScrollView *scrollMain;
    IBOutlet UIView *viewVerified;
    NSMutableArray*         arrCertifications;
    NSMutableArray*         arrReviews;
    
    IBOutlet UILabel *lblCourseTittle;
    IBOutlet UIWebView *webViewDesc;
    IBOutlet UILabel *lblCourseStartEnd;
    IBOutlet UILabel *lblCourseEndDate;

    IBOutlet UILabel *lblCourseTrialClass;
    IBOutlet UILabel *lblCourseSessionNo;
    IBOutlet UILabel *lblCourseTutors;
    IBOutlet UILabel *lblCourseContactNo;
    IBOutlet UILabel *lblCourseLandline;
    IBOutlet UILabel *lblAge;
    IBOutlet UILabel *lblCity;
    IBOutlet UILabel *lblInitialPrice;
    IBOutlet UILabel *lblDiscounts;
    IBOutlet UILabel *lblSold;
    IBOutlet UILabel *lblQuantity;
    IBOutlet UILabel *lblBatchSize;

    IBOutlet UILabel *lblInitialPriceCopy;
    IBOutlet UILabel *lblDiscountsCopy;
    IBOutlet UILabel *lblSoldCopy;
    IBOutlet UILabel *lblQuantityCopy;

    IBOutlet UIView *viewPrice;
    IBOutlet UIView *viewQuality;
    IBOutlet UIButton *btnWriteCopy;
    
    IBOutlet UILabel *lblReview;
    IBOutlet UILabel *lblCertification;
    
    __weak IBOutlet UILabel *lblSpamCount;
    __weak IBOutlet UILabel *lblCommentsCount;
    IBOutlet UIButton *btnFav;
     IBOutlet UIButton *btnSpam;
    
    IBOutlet UIImageView *imgVerEmail;
    IBOutlet UIImageView *imgVerLand;
    IBOutlet UIImageView *imgVerAddress;
    IBOutlet UIImageView *imgVerMobile;
    IBOutlet UIImageView *imgVerSocial;
    IBOutlet UIImageView *imgVerCard;
    IBOutlet UITextView *txtRequirements;
    __weak IBOutlet NSLayoutConstraint *webViewHeight;
    __weak IBOutlet NSLayoutConstraint *viewHeightConstraint;
    
    IBOutlet UIView *viewCover;

}
@property (nonatomic, strong)	id	currentPopTipViewTarget;
@property (nonatomic, strong)	NSMutableArray	*visiblePopTipViews;


@property(strong,nonatomic) NSString *NID;
@property(assign) BOOL isGoComment;
@property(strong,nonatomic) NSMutableArray *arrLocalViewed;
@property(strong,nonatomic) CourseDetail *courseEntity;


@end