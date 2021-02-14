//
//  WriteReviewViewController.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 20/02/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyReview;
typedef void (^RefreshBlock)(NSString *anyValue);
typedef void (^CommonBlock)(id anyValue);
@interface WriteReviewViewController : ParentViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate,RateViewDelegate>
{
    IBOutlet UICollectionView *cvPics;
    IBOutlet UIButton *btnUpload;
    IBOutlet UIButton *btnPostReview;
    
    
    __weak IBOutlet UILabel *lblTitle;
    __weak IBOutlet UITextView *txtComment;
     __weak IBOutlet UITextField *tfTittle;
    IBOutlet RateView *rate;
}


@property (assign, nonatomic) BOOL isEditMode;
@property(strong,nonatomic) NSString *NID;
@property(strong,nonatomic) NSString *courseTittle;
@property(strong,nonatomic) MyReview *editReview;
@property (nonatomic, strong) RefreshBlock refreshBlock;
-(IBAction)btnPostReviewAction:(id)sender;
-(IBAction)btnAttachment:(id)sender;
-(void) getRefreshBlock:(RefreshBlock)refreshBlock;
@end
