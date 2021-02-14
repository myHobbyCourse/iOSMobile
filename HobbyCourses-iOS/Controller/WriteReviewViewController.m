//
//  WriteReviewViewController.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 20/02/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "WriteReviewViewController.h"
#import "AppUtils.h"
#import "UploadManager.h"
#import "MBProgressHUD.h"

@interface WriteReviewViewController ()<UploadManagerDelegate>
{
    NSMutableArray *arrPics;
    MBProgressHUD *hud;
    IBOutlet UILabel *lblCaptiontxt;
}
@end

@implementation WriteReviewViewController

@synthesize NID;

- (void)viewDidLoad {
    [super viewDidLoad];
    arrPics =[[NSMutableArray alloc]init];
    
    btnUpload.layer.cornerRadius =10;
    btnPostReview.layer.cornerRadius =10;
    
    rate.starSize = (is_iPad()) ? 30:20;
    rate.starNormalColor = [UIColor grayColor];
    rate.starFillColor = UIColorFromRGB(0xffba00);
    rate.starBorderColor = [UIColor darkGrayColor];
    rate.starNormalColor = [UIColor clearColor];
    rate.canRate =YES;
    rate.delegate = self;
    
    if(is_iPad()){
        tfTittle.layer.borderWidth = 1;
        tfTittle.layer.borderColor = [UIColor lightGrayColor].CGColor;
        txtComment.layer.borderWidth = 1;
        txtComment.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Write Review Screen"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isEditMode)   {
        [self setReviewDetail];
        self.title = @"Edit a review";
        lblTitle.text = self.editReview.commented_course_title;
    }else{
        self.title = @"Write a review";
        lblTitle.text = self.courseTittle;
    }
}
-(void) getRefreshBlock:(RefreshBlock)refreshBlock {
    self.refreshBlock = refreshBlock;
}
-(void) setReviewDetail
{
    tfTittle.text = self.editReview.Comment_title;
    txtComment.text = self.editReview.comment;
    if ([self checkStringValue:self.editReview.comment]) {
        lblCaptiontxt.hidden = false;
    }else{
        lblCaptiontxt.hidden = true;
    }
    arrPics = self.editReview.arrImages;
    rate.rating = [self.editReview.course_rating floatValue];
    [cvPics reloadData];
    
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView == txtComment) {
        lblCaptiontxt.hidden =true;
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (textView == txtComment && txtComment.text.length == 0)
    {
        lblCaptiontxt.hidden = false;
    }
    return YES;
}

#pragma mark
#pragma mark<RateViewDelegate Methods>
#pragma mark

-(void)rateView:(RateView*)rateView didUpdateRating:(float)rating
{
    NSLog(@"rateViewDidUpdateRating: %.1f", rating);
}
#pragma mark - Actionsheet
-(IBAction)btnAttachment:(id)sender
{
    if (arrPics.count == 3)
    {
        [self showAlertWithTitle:kAppName forMessage:@"You cannot upload more than 3 photos."];
        return;
    }

    [UIAlertController actionWithMessage:@"" title:@"" type:((is_iPad()) ? UIAlertControllerStyleAlert : UIAlertControllerStyleActionSheet) buttons:@[@"Camera",@"Gallery"] controller:self block:^(NSString * tapped) {
            if ([tapped isEqualToString:@"Camera"]) {
                [[JPUtility shared]performOperation:0.2 block:^{
                    [self openCamera];
                }];
            }else if ([tapped isEqualToString:@"Gallery"]) {
                [self openGallery];
            }
        }];
    
}

-(void) openCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *)kUTTypeImage, nil];
        [self presentViewController:picker animated:YES completion:NULL];
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tip" message:@"Your device don't have camera" delegate:nil cancelButtonTitle:@"Sure" otherButtonTitles:nil];
        [alert show];
        
    }
    
}
-(void) openGallery
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes =[[NSArray alloc] initWithObjects: (NSString *)kUTTypeImage,nil];
    if (is_iPad())
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            UIPopoverController *popover=[[UIPopoverController alloc]initWithContentViewController:picker];
            [popover presentPopoverFromRect:btnUpload.bounds inView:btnUpload permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }];
        
    }else{
        [self presentViewController:picker animated:YES completion:nil];
    }
}
#pragma mark - UIImagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey: UIImagePickerControllerOriginalImage];
    [arrPics addObject:image];
    [cvPics reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UICollectionView delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrPics.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(collectionView.frame.size.height, collectionView.frame.size.height);
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellImg" forIndexPath:indexPath];
    UIImageView *img = [cell viewWithTag:11];
    UIButton *btnDelete = [cell viewWithTag:5];
    [btnDelete addTarget:self action:@selector(btnDeletePics:) forControlEvents:UIControlEventTouchUpInside];
    id obj = arrPics[indexPath.row];
    if ([obj isKindOfClass:[UIImage class]])
    {
        img.image = arrPics[indexPath.row];
    }else
    {
        //        [img setImageWithURL:[NSURL URLWithString:obj] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [img sd_setImageWithURL:[NSURL URLWithString:obj]
               placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    
    return cell;
}


-(void) btnDeletePics:(UIButton*) sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:cvPics];
    NSIndexPath *indexPath = [cvPics indexPathForItemAtPoint:buttonPosition];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kAppName message:@"Are you sure want to delete photo?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                         {
                             [arrPics removeObjectAtIndex:indexPath.row];
                             [cvPics reloadData];
                         }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
    
}


-(IBAction)btnPostReviewAction:(id)sender{
    
    if ([self checkStringValue:tfTittle.text]) {
        showAletViewWithMessage(@"Please enter review title.");
        return;
    }
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    
    if (arrPics.count > 0)
    {
        hud.labelText = [NSString stringWithFormat:@"Uploading 1 of %d",(int)arrPics.count];
        [UploadManager sharedInstance].delegate = self;
        if (self.isEditMode)
        {
            dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
            dispatch_async(myQueue, ^{
                UIImage *tempImg = [[UIImage alloc]init];
                NSMutableArray *arr = [[NSMutableArray alloc]init];
                for (NSString *str in arrPics)
                {
                    if ([str isKindOfClass:[UIImage class]]) {
                        [arr addObject:str];
                    }else{
                        NSData* theData = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
                        if (theData) {
                            tempImg = [UIImage imageWithData:theData];
                            [arr addObject:tempImg];
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UploadManager sharedInstance] uploadImagesWithArray:arr];
                    
                });
            });
            
        }else{
            [[UploadManager sharedInstance] uploadImagesWithArray:arrPics];
        }
    }else{
        [self postReviewWithImagesFid:@[]];
    }
}

-(void)postReviewWithImagesFid:(NSArray *)fids{
    
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Please wait.";
    int rating = rate.rating;
    if (self.isEditMode)
    {
        NSDictionary *dictData = @{
                                   @"cid"           :self.editReview.cid,
                                   //                     @"nid"           : self.editReview.commented_nid,
                                   @"subject"       : tfTittle.text,
                                   @"comment_body"  : txtComment.text,
                                   @"course_rate"   : [NSString stringWithFormat:@"%d",(int)ceil(rating*100/5)],
                                   @"images_fids"   : fids};
        
        [[NetworkManager sharedInstance] postRequestFullUrl:apiEditReviewComment paramter:dictData withCallback:^(id jsonData, WebServiceResult result) {
            NSLog(@"Response : %@",jsonData);
            [hud hide:YES];
            if (result == WebServiceResultSuccess)
            {
                _refreshBlock(@"1");
                [self showAlertWithTitle:@"Success" forMessage:@"Your review for course has been submiited successfully."];
               
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                
                [self showAlertWithTitle:@"Error" forMessage:@"Your review for course has been failed. Please try again."];
                NSLog(@"Fail to post a review");
                
            }
            
            [hud hide:YES afterDelay:1.0];
            
        }];
    }
    else
    {
        NSDictionary *dictData  = @{@"nid"   : self.NID,
                                    @"subject"       : tfTittle.text,
                                    @"comment_body"  : txtComment.text,
                                    @"course_rate"   : [NSString stringWithFormat:@"%d",(int)ceil(rating*100/5)],
                                    @"images_fids"   : fids};
        
        
        
        [[NetworkManager sharedInstance] postRequestFullUrl:apiPostReviewComment paramter:dictData withCallback:^(id jsonData, WebServiceResult result) {
            NSLog(@"Response : %@",jsonData);
            
            [hud hide:YES];
            
            if (result == WebServiceResultSuccess)
            {
                _refreshBlock(@"1");
                if ([jsonData isKindOfClass:[NSArray class]])
                {
                    NSArray * arr = jsonData;
                    if (arr.count>0){
                        NSString *str= arr[0];
                        if ([str isKindOfClass:[NSString class]]) {
                            showAletViewWithMessage(str);
                        }
                    }
                }else{
                    [self showAlertWithTitle:@"Success" forMessage:@"Your review for course has been submiited successfully."];
                }
                
                if(is_iPad())
                {
                    [self dismissViewControllerAnimated:NO completion:nil];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            }else{
                if ([jsonData isKindOfClass:[NSArray class]])
                {
                    NSArray * arr = jsonData;
                    if (arr.count>0)
                    {
                        NSString *str= arr[0];
                        if ([str isKindOfClass:[NSString class]])
                        {
                            showAletViewWithMessage(str);
                            
                        }
                    }
                }else{
                    [self showAlertWithTitle:@"Error" forMessage:@"Your review for course has been failed. Please try again."];
                    NSLog(@"Fail to post a review");
                }
            }
            
            [hud hide:YES afterDelay:1.0];
            
        }];
    }
}
-(IBAction)btnCloseiPad:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark - Upload Manager Delegate
- (void)updateProgress:(NSNumber *)completed total:(NSNumber *)totalUpload{
    hud.progress = ([completed intValue] * 100/[totalUpload intValue])/100.0f;
    hud.labelText = [NSString stringWithFormat:@"Uploading %d of %d",(int)[completed intValue]+1,(int)[totalUpload intValue]];
}
- (void)uploadCompleted:(NSArray *)arrayFids{
    hud.labelText = @"Upload completed.";
    [self performSelector:@selector(postReviewWithImagesFid:) withObject:arrayFids afterDelay:1.0];
    [UploadManager sharedInstance].delegate = nil;
}
- (void)uploadFailed{
    hud.labelText = @"Uploading failed. Please try again.";
    [hud hide:YES afterDelay:1.0];
    [UploadManager sharedInstance].delegate = nil;
}



@end
