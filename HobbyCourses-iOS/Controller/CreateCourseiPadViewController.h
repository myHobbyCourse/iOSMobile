//
//  CreateCourseiPadViewController.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 29/04/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>

#import "UploadManager.h"
#import "CourseOfflineEntity.h"
#import "YoutubeCell.h"
#import "DateCalenderPickerVC.h"


@interface CreateCourseiPadViewController : ParentViewController <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate,UploadManagerDelegate,YoutubeCelldelegate,CalenderPickerDelegate,JTMaterialSwitchDelegate> {

    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *viewMain;
    IBOutlet UITableView *tbltxtYoutube;
    IBOutlet UITableView *tbltxtCertificates;
    IBOutlet UICollectionView *cvPics;
    IBOutlet UITableView *tblTimeTable;
    IBOutlet UITableView *tblPreview;
    IBOutlet UIButton *btnPublish;
    IBOutlet UIView *viewPreview;
    
    __weak IBOutlet NSLayoutConstraint *mainViewheight;

    __weak IBOutlet NSLayoutConstraint *tblHeightConstraints;
    __weak IBOutlet NSLayoutConstraint *tblCertificatesHeightConstraints;
    
    IBOutlet UITextField *tfCategory;
    IBOutlet UITextField *tfSubCategory;
    IBOutlet UITextField *tfTittle;
    IBOutlet UITextField *tfaddress1;
    IBOutlet UITextField *tfaddress2;
    IBOutlet UITextField *tfcity;
    IBOutlet UITextField *tfPincode;
    IBOutlet UITextField *tfquantity;
    IBOutlet UITextField *tfsold;
    
    IBOutlet UISwitch *swTrial;
    IBOutlet UISwitch *swStatus;
    IBOutlet UISwitch *swMoneyBack;
    
    IBOutlet UITextField *tfOfferStartDate;
    IBOutlet UITextField *tfOfferEndDate;
    
    IBOutlet UIButton *btnAttachment;
    IBOutlet UIButton *btnVideIgnore;
    IBOutlet UIButton *btnCertificateIgnore;
    
    IBOutlet UITextView *txtRequirement;
    IBOutlet UITextView *txtShortDesc;
    IBOutlet UITextField *tfTutorName;
    
    IBOutlet UILabel *lblCaptionDesc;
    IBOutlet UILabel *lblShortDesc;
    IBOutlet UILabel *lblRequirment;
    
    IBOutlet UILabel *trialYES;
    IBOutlet UILabel *trialNO;
    IBOutlet UILabel *moneyYES;
    IBOutlet UILabel *moneyNO;
    IBOutlet UILabel *statusYES;
    IBOutlet UILabel *statusNO;
    
}


@property(strong,nonatomic) IBOutlet UIView* rangeview;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NMRangeSlider *labelSlider;
@property (weak, nonatomic) IBOutlet UILabel *lowerLabel;
@property (weak, nonatomic) IBOutlet UILabel *upperLabel;
@property (strong, nonatomic) CourseDetail *courseEdit;
@property (weak, nonatomic) NSString *nid;
@property(strong,nonatomic) CourseOfflineEntity *manageObj;
@property(assign) BOOL isBackArrow;
@property (nonatomic, strong)	id	currentPopTipViewTarget;
@property (nonatomic, strong)	NSMutableArray	*visiblePopTipViews;

//Action
-(IBAction)btnHideTextEditor:(id)sender;
-(IBAction)labelSliderChanged:(NMRangeSlider*)sender;


@end
