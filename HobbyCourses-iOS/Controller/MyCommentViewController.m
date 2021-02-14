//
//  MyCommentViewController.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 21/02/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "MyCommentViewController.h"
#import "AppUtils.h"
#import "UploadManager.h"
#import "MBProgressHUD.h"

@interface MyCommentViewController ()
{
    IBOutlet UIView *viewNoReview;
    IBOutlet UITableView *tblReviews;
    IBOutlet UILabel *lblCaptiontxt;
    NSMutableArray *arrReviews;
    NSMutableArray *arrPics;
    MBProgressHUD *hud;
    NSInteger selectedRow;
}
@end

@implementation MyCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrReviews = [[NSMutableArray alloc]init];
    [self performSelector:@selector(getUserComments) withObject:self afterDelay:0.5];
    selectedRow = 0;
    tblComment.estimatedRowHeight = 50;
    tblComment.rowHeight = UITableViewAutomaticDimension;
    
    if (is_iPad()) {
        [self addShaowForiPad:viewShadow];
        
        rate.starSize = 20;
        rate.starNormalColor = [UIColor grayColor];
        rate.starFillColor = UIColorFromRGB(0xffba00);
        rate.starBorderColor = [UIColor darkGrayColor];
        rate.starNormalColor = [UIColor clearColor];
        rate.canRate =YES;
        rate.delegate = self;
        avgRateView.starSize = 20;
        avgRateView.starNormalColor = [UIColor grayColor];
        avgRateView.starFillColor = UIColorFromRGB(0xffba00);
        avgRateView.rating = 5.0;
        arrPics = [NSMutableArray new];
        
        tfTittle.layer.borderWidth = 1;
        tfTittle.layer.borderColor = [UIColor lightGrayColor].CGColor;
        txtComment.layer.borderWidth = 1;
        txtComment.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        btnViewCourse.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        btnViewCourse.layer.shadowRadius = 5;
        
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"My Comments Screen"];
}
#pragma mark - Actionsheet

-(IBAction)btnAttachment:(id)sender
{
    if (arrPics.count == 3)
    {
        [self showAlertWithTitle:kAppName forMessage:@"You cannot upload more than 3 photos."];
        return;
    }
    [UIAlertController actionWithMessage:kAppName title:@"" type:UIAlertControllerStyleAlert buttons:@[@"Camera",@"Gallery"] controller:self block:^(NSString *tapped) {
        if ([tapped isEqualToString:@"Camera"]) {
            [self openCamera];
        }else if ([tapped isEqualToString:@"Gallery"]) {
            [self openGallery];
        }
    }];
    
    /*ActionAlert *alert =  [ActionAlert instanceFromNib:kAppName withMessage:kAppName bgColor:__THEME_YELLOW button:@[@"Camera",@"Gallery"] controller:self block:^(Tapped tapped, ActionAlert *alert) {
        if (tapped == TappedDismiss) {
            [self openCamera];
        }else if (tapped == TappedOkay) {
            [self openGallery];
        }
        [alert removeFromSuperview];
    }];
    [APPDELEGATE.window addSubview:alert];*/
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
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageZoomViewController  *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"ImageZoomViewController"];
    vc.arrData = @[arrPics[indexPath.row]];
    [self presentViewController:vc animated:YES completion:nil];
    
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
    
    if ([self checkStringValue:txtComment.text]) {
        showAletViewWithMessage(@"Please enter review description.");
        return;
    }
    
    if (self.editReview == nil) {
        showAletViewWithMessage(@"No review to edit.");
        return;
    }
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    
    if (arrPics.count > 0)
    {
        hud.labelText = [NSString stringWithFormat:@"Uploading 1 of %d",(int)arrPics.count];
        [UploadManager sharedInstance].delegate = self;
        
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
        if (arr.count>0) {
            [[UploadManager sharedInstance] uploadImagesWithArray:arr];
        }else{
            [self postReviewWithImagesFid:@[]];
        }
        
    }else{
        [self postReviewWithImagesFid:@[]];
    }
}

-(void)postReviewWithImagesFid:(NSArray *)fids{
    
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Please wait.";
    int rating = rate.rating;
    if (rating == 0) {
        rating = 0.5;
    }
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
            [self showAlertWithTitle:@"Success" forMessage:@"Your review for course has been submiited successfully."];
        }else{
            
            [self showAlertWithTitle:@"Error" forMessage:@"Your review for course has been failed. Please try again."];
            NSLog(@"Fail to post a review");
            
        }
        [self getUserComments];
        [hud hide:YES afterDelay:1.0];
        
    }];
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

#pragma mark<RateViewDelegate Methods>
#pragma mark

-(void)rateView:(RateView*)rateView didUpdateRating:(float)rating
{
    NSLog(@"rateViewDidUpdateRating: %.1f", rating);
}
-(void) getUserComments
{
    if (![self isNetAvailable]) {
        NSData *data = [UserDefault objectForKey:kMyReviewKey];
        if (data) {
            NSDictionary *jsonData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            if ([jsonData isKindOfClass:[NSArray class]])
            {
               [self parseUserComments:jsonData];
            }else{
                showAletViewWithMessage(kFailAPI);
            }
        }
    }
    else
    {
        [self startActivity];
        [[NetworkManager sharedInstance] postRequestUrl:[NSString stringWithFormat:@"%@",apiUserCommentURL] paramter:nil withCallback:^(id jsonData, WebServiceResult result)
         {
             [self stopActivity];
             if (result == WebServiceResultSuccess)
             {
                 [self parseUserComments:jsonData];
             }else{
                 showAletViewWithMessage(kFailAPI);
             }
             
         }];
        
    }
}
-(void) parseUserComments:(id) jsonData {
    if ([jsonData isKindOfClass:[NSArray class]])
    {
        NSArray *arrData = jsonData;
        if (arrData && arrData.count>0)
        {
            [arrReviews removeAllObjects];
            for(NSDictionary *dict in arrData)
            {
                MyReview *review = [[MyReview alloc]initWith:dict ];
                NSLog(@"review : :%@",review);
                [arrReviews addObject:review];
            }
            [UserDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:jsonData] forKey:kMyReviewKey];
            [UserDefault synchronize];
            
            NSArray *arrKeys = [arrReviews sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                NSDateFormatter *df = f2DIGItYearTimeFormatter();
                //                     [df setDateFormat:@"yyyy-MM-dd HH:mm"];
                MyReview *a = obj1;
                MyReview *b = obj2;
                NSDate *d1 = [df dateFromString:a.updated_date];
                NSDate *d2 = [df dateFromString:b.updated_date];
                return [d2 compare: d1];
            }];
            
            if (arrKeys && arrKeys.count > 0)
            {
                [arrReviews removeAllObjects];
                [arrReviews addObjectsFromArray:arrKeys];
                self.editReview = arrReviews[selectedRow];
                [self setReviewDetail];
                
            }
            [tblComment reloadData];
            [tblReviews reloadData];
            
            lblReviewCount.text = [NSString stringWithFormat:@"%lu Reviews",(unsigned long)arrReviews.count];
            viewNoReview.hidden = true;
        }else{
            viewNoReview.hidden = false;
            showAletViewWithMessage(@"Weird wallabies…No reviews found");
        }
    }
}
#pragma mark - UItableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrReviews.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    MyReview *review = [arrReviews objectAtIndex:indexPath.row];
    
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    UILabel *lblComment_Tittle = [cell viewWithTag:21];
    UILabel *lblCourseTittle = [cell viewWithTag:22];
    UILabel *lblDate = [cell viewWithTag:23];
    if (!is_iPad()) {
        UIButton *btnEdit = [cell viewWithTag:24];
        [btnEdit addTarget:self action:@selector(btnEditComment:) forControlEvents:UIControlEventTouchUpInside];
        btnEdit.tag = review.cid.intValue;
    }else{
        RateView *rateView = [cell viewWithTag:24];
        rateView.rating = [review.course_rating floatValue];
    }
    
    lblComment_Tittle.text = review.Comment_title;
    lblCourseTittle.text = review.commented_course_title;
    if ([self checkStringValue:review.updated_date]) {
        lblDate.text = review.post_date;
        
    }else{
        lblDate.text = review.updated_date;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    if (is_iPad() && selectedRow == indexPath.row) {
        cell.backgroundColor = __THEME_lightGreen;
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (is_iPad()) {
        selectedRow = indexPath.row;
        self.editReview = arrReviews[indexPath.row];
        [self setReviewDetail];
        [tableView reloadData];
        return;
    }
    ActionAlert *alert =  [ActionAlert instanceFromNib:kAppName withMessage:@"Do you want to visit course you have reviewed?" bgColor:__THEME_YELLOW button:@[@"NO",@"YES"] controller:self block:^(Tapped tapped, ActionAlert *alert) {
        [alert removeFromSuperview];
        if (tapped == TappedOkay) {
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self performSegueWithIdentifier:@"GoToCourseDetail" sender:indexPath];
            });
        }
    }];
    [APPDELEGATE.window addSubview:alert];
}
-(IBAction)btnVisitCourse:(UIButton*)sender{
    [self performSegueWithIdentifier:@"GoToCourseDetail" sender:self];
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
    if (self.editReview.arrImages.count > 0) {
        arrPics = [[NSMutableArray alloc]init];
        
    }
    arrPics = self.editReview.arrImages;
    rate.rating = [self.editReview.course_rating floatValue];
    [cvPics reloadData];
    
}
-(void) btnEditComment:(UIButton*) sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblReviews];
    NSIndexPath *indexPath = [tblReviews indexPathForRowAtPoint:buttonPosition];
    [self performSegueWithIdentifier:@"GoToWriteReview" sender:indexPath];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"GoToWriteReview"])
    {
        WriteReviewViewController *view = segue.destinationViewController;
        NSIndexPath * index = sender;
        view.editReview = [arrReviews objectAtIndex:index.row];
        view.isEditMode = true;
        [view getRefreshBlock:^(NSString *anyValue) {
            [self getUserComments];
        }];
    }else  if ([segue.identifier isEqualToString:@"GoToCourseDetail"])
    {
        CourseDetailsVC *view = segue.destinationViewController;
        NSIndexPath *index = sender;
        MyReview *entity  = [arrReviews objectAtIndex:(is_iPad()) ? selectedRow:index.row];
        view.NID = entity.commented_nid;
    }
}


@end
