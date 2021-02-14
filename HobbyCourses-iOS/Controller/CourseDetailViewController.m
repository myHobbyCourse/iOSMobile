//
//  CourseDetailViewController.m
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/17/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import "CourseDetailViewController.h"
#import "CertificationTableViewCell.h"
#import "ReviewTableViewCell.h"
#import "WriteReviewViewController.h"

@interface CourseDetailViewController ()
{
    IBOutlet UIButton *btnAddReview;
    
    IBOutlet UIButton *widget1;
    IBOutlet UIButton *widget2;
    IBOutlet UIButton *widget3;
    IBOutlet UIButton *widget4;
    IBOutlet UIButton *widget5;
    
    IBOutlet UIView *shareView;
    NSTimer *timer;
    NSTimer *timerLocal;
    NSTimer *timerRecent;
    
    int refreshCount;
    NSMutableArray *arrRecentViewed;
    NSInteger currentRecentIndex;
    NSInteger currentLocalIndex;
    int commentPageIndex;
    BOOL isCommentLoading;
    BOOL isViewDidLoad;
    int sortedIndex;
    IBOutlet NSLayoutConstraint * iPadheightScroll;
    IBOutlet NSLayoutConstraint * iPadviewRecentLocal;
    IBOutlet NSLayoutConstraint * iPadWidthScroll;
    IBOutlet NSLayoutConstraint * heightTblBatches;
    IBOutlet NSLayoutConstraint * _heightRequiremenTxt;
    
    BOOL isViewdidload;
    NSString *selectedProduct_id;
    int scrollHeight;
    
}
@end

@implementation CourseDetailViewController
@synthesize NID;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    commentPageIndex = 0;
    sortedIndex = -1;
    isCommentLoading = false;
    [self initWidget];
    [self initData];
    if (is_iPad()) {
        scrollHeight = 1950;
    } else {
        scrollHeight = 1200;
    }
    scrollMain.backgroundColor = [UIColor whiteColor];
    if (is_iPad())
    {
        [self onReview:nil];
    }else{
        [self onVideo:nil];
    }
    isViewDidLoad = true;
    [self performSelector:@selector(getCourseDetails:) withObject:NID afterDelay:0.5];
    [self performSelector:@selector(getRecentViewedCourse) withObject:nil afterDelay:0.8];
    
    tblProductCopy.tableFooterView = [[UIView alloc]init];
    tblProduct.tableFooterView = [[UIView alloc]init];
    UIButton *btn = [[UIButton alloc]init];
    btn.tag = 998;
    [self btnSortBatches:btn];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(temp)
                                                 name:@"AppBecomeActive"
                                               object:nil];
    widget1.imageView.contentMode = UIViewContentModeScaleAspectFit;
    widget2.imageView.contentMode = UIViewContentModeScaleAspectFit;
    widget3.imageView.contentMode = UIViewContentModeScaleAspectFit;
    widget4.imageView.contentMode = UIViewContentModeScaleAspectFit;
    widget5.imageView.contentMode = UIViewContentModeScaleAspectFit;

}
-(void) temp{
    [self.navigationController popViewControllerAnimated:true];
}
-(void)viewWillAppear:(BOOL)animated
{
    [cvRecentCopy reloadData];
    [self updateToGoogleAnalytics:@"Course detail Screen"];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:true];
    if (!is_iPad()) {
        return;
    }
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        iPadWidthScroll.constant = self.view.frame.size.width * 0.6;
        iPadheightScroll.constant = 0;
        iPadviewRecentLocal.constant = 0;
        viewPrice.hidden= true;
        viewQuality.hidden = true;
        btnWriteCopy.hidden = true;
        scrollHeight = scrollHeight - 800;
        if (scrollHeight > 1000) {
            viewHeightConstraint.constant = scrollHeight;
            [scrollMain setContentSize:CGSizeMake(scrollMain.frame.size.width,scrollHeight)];
        }
    }
    else
    {
        iPadheightScroll.constant = 400;
        iPadviewRecentLocal.constant = 400;
        iPadWidthScroll.constant = self.view.frame.size.width;
        viewPrice.hidden= false;
        viewQuality.hidden = false;
        btnWriteCopy.hidden = false;
      
        viewHeightConstraint.constant = scrollHeight;
        [scrollMain setContentSize:CGSizeMake(scrollMain.frame.size.width,scrollHeight)];
        
    }
    [self viewDidLayoutSubviews];
    
}
- (void) orientationChanged:(NSNotification *)note
{
    UIDevice * device = note.object;
    [self autoScroll];
    [tblProduct reloadData];
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
            /* start special animation */
            iPadheightScroll.constant = 400;
            iPadviewRecentLocal.constant = 400;
            iPadWidthScroll.constant = self.view.frame.size.width;
            viewPrice.hidden= false;
            viewQuality.hidden = false;
            btnWriteCopy.hidden = false;
            
            scrollHeight = scrollHeight + 800;
            viewHeightConstraint.constant = scrollHeight;
            [scrollMain setContentSize:CGSizeMake(scrollMain.frame.size.width,scrollHeight)];
            [self.view layoutIfNeeded];
            [cvImageScroll reloadData];
            [cvRecentCopy reloadData];
            
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            /* start special animation */
            iPadWidthScroll.constant = self.view.frame.size.width * 0.6;
            iPadheightScroll.constant = 0;
            iPadviewRecentLocal.constant = 0;
            viewPrice.hidden= true;
            viewQuality.hidden = true;
            btnWriteCopy.hidden = true;
            
            scrollHeight = scrollHeight - 800;
            if (scrollHeight > 1000) {
                viewHeightConstraint.constant = scrollHeight;
                [scrollMain setContentSize:CGSizeMake(scrollMain.frame.size.width,scrollHeight)];
            }
            
            [self.view layoutIfNeeded];
            [cvImageLandscap reloadData];
            break;
            
        case UIDeviceOrientationLandscapeRight:
            /* start special animation */
            iPadWidthScroll.constant = self.view.frame.size.width * 0.6;
            iPadheightScroll.constant = 0;
            iPadviewRecentLocal.constant = 0;
            viewPrice.hidden= true;
            viewQuality.hidden = true;
            btnWriteCopy.hidden = true;
            scrollHeight = scrollHeight - 800;
            if (scrollHeight > 1000) {
                viewHeightConstraint.constant = scrollHeight;
                [scrollMain setContentSize:CGSizeMake(scrollMain.frame.size.width,scrollHeight)];
            }
            
            [self.view layoutIfNeeded];
            [cvImageLandscap reloadData];
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            /* start special animation */
            iPadheightScroll.constant = 400;
            iPadviewRecentLocal.constant = 400;
            iPadWidthScroll.constant = self.view.frame.size.width;
            viewPrice.hidden= false;
            viewQuality.hidden = false;
            btnWriteCopy.hidden = false;
            
            scrollHeight = scrollHeight + 800;
            viewHeightConstraint.constant = scrollHeight;
            [scrollMain setContentSize:CGSizeMake(scrollMain.frame.size.width,scrollHeight)];
            [self.view layoutIfNeeded];
            [cvImageScroll reloadData];
            [cvRecentCopy reloadData];
            
            break;
            
        default:
            break;
    };
}


-(IBAction)btnBatchCalender:(UIButton*)sender {
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"product_id == %@",selectedProduct_id];
    NSArray *arr =  [self.courseEntity.productArr filteredArrayUsingPredicate:pre];
    if (arr.count > 0) {
        ProductEntity *obj = arr[0];
        if (obj) {
            CourseBatchDisplayVC  *vc =(CourseBatchDisplayVC*) [self.storyboard instantiateViewControllerWithIdentifier: @"CourseBatchDisplayVC"];
            vc.arrTimes = obj.timings;
            vc.courseStart = obj.course_start_date;
            vc.courseEnd = obj.course_end_date;
            
            if (is_iPad())
            {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    UIPopoverController *popover=[[UIPopoverController alloc]initWithContentViewController:vc];
                    [popover presentPopoverFromRect:sender.frame inView:scrollMain permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                }];
            }else{
                [self presentViewController:vc animated:false completion:nil];
            }
        }
    }
    
}
-(IBAction)btnCourseDetailCalender:(UIButton*)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblProduct];
    NSIndexPath *indexPath = [tblProduct indexPathForRowAtPoint:buttonPosition];
    ProductCell * cell = [tblProduct cellForRowAtIndexPath:indexPath];
    ProductEntity *obj = self.courseEntity.productArr[indexPath.row];
    if (obj) {
        CourseBatchDisplayVC  *vc =(CourseBatchDisplayVC*) [self.storyboard instantiateViewControllerWithIdentifier: @"CourseBatchDisplayVC"];
        vc.arrTimes = obj.timings;
        vc.courseStart = obj.course_start_date;
        vc.courseEnd = obj.course_end_date;
        
        if (is_iPad())
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                UIPopoverController *popover=[[UIPopoverController alloc]initWithContentViewController:vc];
                [popover presentPopoverFromRect:cell.btnDetails.frame inView:cell permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
            }];
        }else{
            [self presentViewController:vc animated:false completion:nil];
        }
    }
}
-(IBAction)btnCourseDetailCalenderCopy:(UIButton*)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblProductCopy];
    NSIndexPath *indexPath = [tblProductCopy indexPathForRowAtPoint:buttonPosition];
    ProductCell * cell = [tblProduct cellForRowAtIndexPath:indexPath];
    ProductEntity *obj = self.courseEntity.productArr[indexPath.row];
    if (obj) {
        CourseBatchDisplayVC  *vc =(CourseBatchDisplayVC*) [self.storyboard instantiateViewControllerWithIdentifier: @"CourseBatchDisplayVC"];
        vc.arrTimes = obj.timings;
        vc.courseStart = obj.course_start_date;
        vc.courseEnd = obj.course_end_date;
        
        if (is_iPad())
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                UIPopoverController *popover=[[UIPopoverController alloc]initWithContentViewController:vc];
                [popover presentPopoverFromRect:cell.btnDetails.frame inView:cell permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
            }];
        }else{
            [self presentViewController:vc animated:false completion:nil];
        }
    }
}
- (IBAction)btnSpamAction:(id)sender
{
    [self toolTipView:sender msg:@"\n  Mark this course as Spam   \n     "];

    NSString *str;
    NSString *str_flag;
    if ([self.courseEntity.spam_flag_flagged.uppercaseString isEqualToString:@"NO"])
    {
        str = @"Do you really want to flag this course as Spam?";
        str_flag = @"flag";
    }else{
        str = @"Do you want to clear this course as NOT spam?";
        str_flag = @"unflag";
    }
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:kAppName
                                  message:str
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yes = [UIAlertAction
                          actionWithTitle:@"YES"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action)
                          {
                              NSDictionary *dict =@{@"action":str_flag, @"flag_name":@"spam_flag_on_courses", @"entity_id":NID
                                                    };
                              [self startActivity];
                              [[NetworkManager sharedInstance] postRequestUrl:apifavFlagUrl paramter:dict withCallback:^(id jsonData, WebServiceResult result) {
                                  [self stopActivity];
                                  if (result == WebServiceResultSuccess)
                                  {
                                      if ([jsonData isKindOfClass:[NSArray class]])
                                      {
                                          NSArray *arr = jsonData;
                                          if (arr && arr.count)
                                          {
                                              BOOL flag = arr[0];
                                              if (flag)
                                              {
                                                  showAletViewWithMessage(@"Successfully.");
                                                  if ([str_flag isEqualToString:@"flag"])
                                                  {
                                                      int count = [lblSpamCount.text intValue] + 1;
                                                      lblSpamCount.text = [NSString stringWithFormat:@"%d",count];
                                                      self.courseEntity.spam_flag_flagged = @"YES";
                                                  }else{
                                                      int count = [lblSpamCount.text intValue] - 1;
                                                      lblSpamCount.text = [NSString stringWithFormat:@"%d",count];
                                                      self.courseEntity.spam_flag_flagged = @"NO";
                                                  }
                                              }
                                              
                                          }
                                      }
                                      
                                  }else{
                                      showAletViewWithMessage(@"Let’s give that another go...An error occurred with your spam request");
                                  }
                                  
                              }];
                              
                          }];
    UIAlertAction* no = [UIAlertAction
                         actionWithTitle:@"NO"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alert addAction:yes];
    [alert addAction:no];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}
-(IBAction)btnCommentScroll:(id)sender
{
    CGPoint offset = CGPointMake(0, tblReviews.frame.origin.y);
    [self scrollToscreen:offset];
    [self onReview:nil];
}
- (IBAction)btnFavUnFav:(UIButton*)sender
{
    [self toolTipView:sender msg:@" \n Store this course as Favourite   \n "];
    NSString *action;
    if (sender.selected)
    {
        action = @"unflag";
    }else
    {
        action =@"flag";
    }
    NSDictionary *dict =@{@"action":action, @"flag_name":@"favorite_flag_on_courses", @"entity_id":NID
                          };
    
    [self startActivity];
    [[NetworkManager sharedInstance] postRequestUrl:apifavFlagUrl paramter:dict withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        if (result == WebServiceResultSuccess)
        {
            if ([jsonData isKindOfClass:[NSArray class]])
            {
                NSArray *arr = jsonData;
                if (arr && arr.count)
                {
                    BOOL flag = arr[0];
                    if (flag)
                    {
                        if(btnFav.selected)
                        {
                            btnFav.selected =false;
                        }else{
                            btnFav.selected =true;
                        }
                    }
                    
                }
            }
        }else{
            showAletViewWithMessage(@"Error occurs,Please try again.");
        }
    }];
    
    
    
}
#pragma mark- Share
- (IBAction) shareToFacebook:(id)sender
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        NSString *str;
        if([self.courseEntity.field_deal_image isKindOfClass:[NSString class]])
        {
            str = self.courseEntity.field_deal_image;
        }else if ([self.courseEntity.field_deal_image isKindOfClass:[NSArray class]] && self.courseEntity.field_deal_image.count> 0)
        {
            str = self.courseEntity.field_deal_image[0];
        }
        dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
        dispatch_async(myQueue, ^{
            
            NSData *theData = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [controller setInitialText:self.courseEntity.title];
                [controller addImage:[UIImage imageWithData:theData]];
                [self presentViewController:controller animated:YES completion:Nil];
            });
        });
        
    }
    else {
        [self showAlertWithTitle:@"Info" forMessage:@"You don't have configured any Facebook settings, please go to Settings->Facebook and setup you account"];
    }
}

- (IBAction) shareToTwitter:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        NSString *str;
        if([self.courseEntity.field_deal_image isKindOfClass:[NSString class]])
        {
            str = self.courseEntity.field_deal_image;
        }else if ([self.courseEntity.field_deal_image isKindOfClass:[NSArray class]] && self.courseEntity.field_deal_image.count> 0)
        {
            str = self.courseEntity.field_deal_image[0];
        }
        [self startActivity];
        dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
        dispatch_async(myQueue, ^{
            
            NSData *theData = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stopActivity];
                [tweetSheet setInitialText:self.courseEntity.title];
                [tweetSheet addImage:[UIImage imageWithData:theData]];
                [self presentViewController:tweetSheet animated:YES completion:nil];
                
            });
        });
    }else {
        [self showAlertWithTitle:@"Info" forMessage:@"You don't have configured any Facebook settings, please go to Settings->Twitter and setup you account"];
    }
}
- (IBAction)shareToGooglePlus:(id)sender
{
    id<GPPShareBuilder> shareBuilder = [self shareBuilder];
    [shareBuilder open];
}

- (id<GPPShareBuilder>)shareBuilder
{
    // End editing to make sure all changes are saved to _shareConfiguration.
    [self.view endEditing:YES];
    
    // Create the share builder instance.
    id<GPPShareBuilder> shareBuilder = [[GPPShare sharedInstance] shareDialog];// _shareConfiguration.useNativeSharebox ?
    //    [[GPPShare sharedInstance] nativeShareDialog] :
    //    [[GPPShare sharedInstance] shareDialog];
    //    NSString* urlString = [[NSString alloc] init];
    //    if (![[[[self.unquieDealDetailDataArray objectAtIndex:0] objectForKey:@"node"] valueForKey:@"field_cat"] isEqualToString:@"Ask"]){
    //        urlString = [[[self.unquieDealDetailDataArray objectAtIndex:0] objectForKey:@"node"] valueForKey:@"field_deal_url"];
    //        if ([urlString isKindOfClass:[NSNull class]]){
    //            urlString = @"";
    //        }
    //    }
    //
    //    //    if (_shareConfiguration.urlEnabled) {
    //    NSURL *urlToShare = [urlString length] ? [NSURL URLWithString:urlString] : nil;
    //    if (urlToShare) {
    //        [shareBuilder setURLToShare:urlToShare];
    //    }
    //    }
    
    // Add deep link content.
    //    if (_shareConfiguration.deepLinkEnabled) {
    //        [shareBuilder setContentDeepLinkID:_shareConfiguration.contentDeepLinkID];
    //        NSString *title = _shareConfiguration.contentDeepLinkTitle;
    //        NSString *description = _shareConfiguration.contentDeepLinkDescription;
    //        NSString *urlString = _shareConfiguration.contentDeepLinkThumbnailURL;
    //        NSURL *thumbnailURL = urlString.length ? [NSURL URLWithString:urlString] : nil;
    //        [shareBuilder setTitle:title description:description thumbnailURL:thumbnailURL];
    //    }
    
    
    [shareBuilder setPrefillText:self.courseEntity.title];
    
    return shareBuilder;
}

- (IBAction) postToPinterest: (id)sender
{
    NSString *str;
    if([self.courseEntity.field_deal_image isKindOfClass:[NSString class]]) {
        str = self.courseEntity.field_deal_image;
    }else if ([self.courseEntity.field_deal_image isKindOfClass:[NSArray class]] && self.courseEntity.field_deal_image.count> 0) {
        str = self.courseEntity.field_deal_image[0];
    }
    [PDKPin pinWithImageURL:[NSURL URLWithString:str]
                       link:[NSURL URLWithString:@"https://www.pinterest.com"]
         suggestedBoardName:self.courseEntity.title
                       note:@""
                withSuccess:^{
                    
                }andFailure:^(NSError *error)
        {
     }];
}

#pragma mark - API
-(void) getCourseDetails:(NSString *) courseNID
{
    if (![self isNetAvailable])
    {
        NSData *data = [UserDefault objectForKey:courseNID];
        if (data)
        {
            NSDictionary *jsonData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [self parseCourseDetails:jsonData nid:courseNID];
        }
        else
        {

            [self.navigationController popViewControllerAnimated:true];
        }
    }else{
        [self startActivity];
        [[NetworkManager sharedInstance] getRequestUrl:[NSString stringWithFormat:@"%@%@",apiCourseDetailUrl,courseNID] paramter:nil isToken:NO withCallback:^(id jsonData, WebServiceResult result) {
            [self stopActivity];
            if (result == WebServiceResultSuccess)
            {
                if ([jsonData isKindOfClass:[NSDictionary class]])
                {
                    if (jsonData)
                    {
                        [UserDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:jsonData] forKey:courseNID];
                        [UserDefault synchronize];
                    }
                    
                }
                [self parseCourseDetails:jsonData nid:courseNID];
            } else {
                showAletViewWithMessage(kFailAPI);
                [self.navigationController popToRootViewControllerAnimated:true];
            }
        }];
    }
    
}
-(void) parseCourseDetails:(id) jsonData nid:(NSString*) courseNID
{
    if ([jsonData isKindOfClass:[NSDictionary class]])
    {
        NSMutableDictionary *d = [jsonData mutableCopy];
        [d handleNullValue];
        self.courseEntity = [[CourseDetail alloc]initWith:d];
        for(ProductEntity * product in self.courseEntity.productArr) {
            NSDateFormatter *dateOnly = globalDateOnlyFormatter();
            NSDate *date = [dateOnly dateFromString:product.course_start_date];
            if ([date compare:[NSDate date]] == NSOrderedSame || [date compare:[NSDate date]] == NSOrderedAscending || [product.sold integerValue] == [product.quantity integerValue]) {
                //Sold out batches
            }else{
                selectedProduct_id = product.product_id;
                [self displayValueBasedOnSelectedBatch:product];
            }
        }
        
        [self updateUI];
        [collectView reloadData]; //youtube video collection view
        [tblProduct reloadData];
        [tblProductCopy reloadData];
        int size = [tblProduct contentSize].height;
        
        heightTblBatches.constant = size;
        if (is_iPad())
        {
            scrollHeight = scrollHeight-200+size;
            viewHeightConstraint.constant = scrollHeight-200+size;
        }else{
            viewHeightConstraint.constant = 1220-190+size;
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        viewCover.hidden = true;
        [self.view layoutIfNeeded];
        [self autoScroll];
    }];
    
}
-(void) getCommentsData:(NSString*) nid
{
    if (![self isNetAvailable])
    {
        NSData *data = [UserDefault objectForKey:[self uniqueCommentId:nid]];
        if (data)
        {
            NSDictionary *jsonData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [self parseComment:jsonData nid:nid];
        }
    }else{
        if (isCommentLoading) {
            return;
        }
        if (commentPageIndex == -1) {
            commentPageIndex = 0;
        }
        [[NetworkManager sharedInstance] getRequestUrl:[NSString stringWithFormat:@"%@%@?page=%@",apiCommentURL,self.courseEntity.nid,[NSString stringWithFormat:@"%d",commentPageIndex]] paramter:nil isToken:true withCallback:^(id jsonData, WebServiceResult result)
         {
             isCommentLoading = false;
             if (result == WebServiceResultSuccess)
             {
                 [self parseComment:jsonData nid:nid];
             }
         }];
    }
}
-(NSString*) uniqueCommentId:(NSString*) nid
{
    return [NSString stringWithFormat:@"cc%@",nid];
}
-(void) parseComment:(id) jsonData nid:(NSString *) nid
{
    if ([jsonData isKindOfClass:[NSDictionary class]])
    {
        if ([jsonData valueForKey:@"nodes"])
        {
            NSArray *arrData = [jsonData valueForKey:@"nodes"];
            if (arrData && arrData.count>0)
            {
                if (commentPageIndex == 0)
                {
                    [UserDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:jsonData] forKey:[self uniqueCommentId:nid]];
                    [UserDefault synchronize];
                    [arrReviews removeAllObjects];
                }
                
                for(NSDictionary *dict in arrData)
                {
                    if ([dict valueForKey:@"node"])
                    {
                        Review *review = [[Review alloc]initWith:[dict valueForKey:@"node"]];
                        [arrReviews addObject:review];
                        
                    }
                }
                lblReview.text = @"Reviews";
                [tblReviews reloadData];
            }else{
                lblReview.text = @"Weird wallabies…No reviews found";
            }
            if (arrData.count < 10)
            {
                commentPageIndex = -1;
            }else{
                commentPageIndex = commentPageIndex + 1;
            }
        }
    }
}

-(void) getRecentViewedCourse
{
    if (![self isNetAvailable])
    {
        NSData *data = [UserDefault objectForKey:kRecentKey];
        if (data)
        {
            NSDictionary *jsonData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [self parseRecentCourse:jsonData];
        }
    }
    else
    {
        [[NetworkManager sharedInstance] getRequestUrl:[NSString stringWithFormat:@"%@%@/all/all",apiTop50Commented,APPDELEGATE.selectedCity] paramter:nil isToken:NO withCallback:^(id jsonData, WebServiceResult result)
         {
             if (result == WebServiceResultSuccess)
             {
                 [self parseRecentCourse:jsonData];
                 if ([jsonData isKindOfClass:[NSArray class]])
                 {
                     [UserDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:jsonData] forKey:kRecentKey];
                     [UserDefault synchronize];
                 }
                 
             }else{
                 showAletViewWithMessage(kFailAPI);
             }
         }];
    }
}
-(void) parseRecentCourse:(id) jsonData
{
    if ([jsonData isKindOfClass:[NSArray class]])
    {
        for(NSDictionary *dict in jsonData)
        {
            NSMutableDictionary *d = [dict mutableCopy];
            [d handleNullValue];
            CourseDetail *entity = [[CourseDetail alloc]initWith:d];
            [arrRecentViewed addObject:entity];
        }
        [cvRecent reloadData];
        [cvRecentCopy reloadData];
    }
    
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"GoToCommentList"])
    {
        CommentListVC *vc =(CommentListVC *) segue.destinationViewController;
        if ([sender isKindOfClass:[NSIndexPath class]]) {
            NSIndexPath *path = (NSIndexPath*) sender;
            Review *review = [arrReviews objectAtIndex:path.row];
            vc.nidComment = review.commented_nid;
            vc.review = review;
            vc.courseTittle = self.courseEntity.title;
            vc.isAllReview = false;
        }else
        {
            vc.nidComment = self.courseEntity.author_uid;
            vc.courseTittle = self.courseEntity.title;
            vc.isAllReview = true;
        }
    }else if([segue.identifier isEqualToString:@"GoToVendor"]){
        VendorViewController *vc =(VendorViewController *) segue.destinationViewController;
        vc.verndorID = self.courseEntity.author_uid;
    }else if ([segue.identifier isEqualToString:@"GoToMessage"])
    {
        if (is_iPad())
        {
            MessagesViewController *view = segue.destinationViewController;
            view.isNewthread = true;
            view.couseEntity = self.courseEntity;
            view.isBackArrow = true;
        }else{
            ConversationViewController *view = segue.destinationViewController;
            view.isNewthread = true;
            view.couseEntity = self.courseEntity;
        }
        
    }else if ([segue.identifier isEqualToString:@"GoToWriteReview"]){
        
        WriteReviewViewController *postReviewController = segue.destinationViewController;
        postReviewController.isEditMode = NO;
        postReviewController.NID = self.courseEntity.nid;
        postReviewController.courseTittle = self.courseEntity.title;
        [postReviewController getRefreshBlock:^(NSString *anyValue) {
            [arrReviews removeAllObjects];
            [self getCommentsData:self.courseEntity.nid];
        }];
    }
    
}


- (void) initWidget {
    [self hideAllTabs];
    btnAddReview.layer.cornerRadius = btnAddReview.frame.size.height/2;
    btnAddReview.layer.masksToBounds =YES;
    btnWriteCopy.layer.cornerRadius = btnWriteCopy.frame.size.height/2;
    btnWriteCopy.layer.masksToBounds =YES;
}

- (void) hideAllTabs {
    imvVideoTabSel.hidden = YES;
    imvCertificationTabSel.hidden = YES;
    imvReviewTabSel.hidden = YES;
    imvBatchesTabSel.hidden = YES;
    imvDurationTabSel.hidden = YES;
    tblProductCopy.hidden = YES;
    tblCertifications.hidden = YES;
    tblReviews.hidden = YES;
    collectView.hidden = YES;
    viewVerified.hidden = YES;
}

- (void) initData {
    
    arrCertifications = [[NSMutableArray alloc]init];
    arrReviews =  [[NSMutableArray alloc]init];
    arrRecentViewed = [[NSMutableArray alloc]init];
    refreshCount = 0;
    tblCertifications.tableFooterView = [[UIView alloc]init];
    tblReviews.tableFooterView = [[UIView alloc]init];
    
}

-(void)btnZoomImage:(UIButton*) sender
{
    ImageZoomViewController  *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"ImageZoomViewController"];
    vc.path =[self.courseEntity.field_deal_image objectAtIndex:sender.tag];
    if ([self.courseEntity.field_deal_image isKindOfClass:[NSMutableArray class]])
    {
        vc.arrData = self.courseEntity.field_deal_image;
        
    }
    vc.course = self.courseEntity;
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBuy:(id)sender {
    
    if (self.courseEntity == nil) {
        return;
    }
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"product_id == %@",selectedProduct_id];
    NSArray *arrBatch =  [self.courseEntity.productArr filteredArrayUsingPredicate:pre];
    if (arrBatch.count > 0) {
        ProductEntity *product = arrBatch[0];
        NSDateFormatter *dateOnly = globalDateOnlyFormatter();
        NSDate *date = [dateOnly dateFromString:product.course_start_date];
        if (date) {
            if ([date compare:[NSDate date]] == NSOrderedSame || [date compare:[NSDate date]] == NSOrderedAscending || [product.sold integerValue] == [product.quantity integerValue])
            {
                showAletViewWithMessage(@"Your selected course sessions have been sold out, but keep looking!");
                return;
            }
            NSMutableArray *arrItem;
            if ([UserDefault objectForKey:@"cartItem"]) {
                arrItem = [[UserDefault objectForKey:@"cartItem"] mutableCopy];
            } else {
                arrItem = [[NSMutableArray alloc]init];
            }
            if (arrItem.count > 4) {
                showAletViewWithMessage(@"Let’s save some for others, there’s a 5 course purchase limit at any given time");
                return;
            }
            if ([self checkStringValue:NID]) {
                showAletViewWithMessage(@"Something went wrong.");
                return;
            }
            NSArray * arr = [arrItem filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"id == %@",NID]];
            if (arr.count > 0) {
                showAletViewWithMessage(@"No need to double dip, this course already in your shopping cart");
                return;
            }
            
            NSString* totalString = [product.initial_price stringByTrimmingCharactersInSet: [NSCharacterSet symbolCharacterSet]];
            NSDictionary *dict = @{@"category":self.courseEntity.category,@"course_tittle":self.courseEntity.title,@"price":totalString,@"id":NID,@"product_id":product.product_id};
            [arrItem addObject:dict];
            [UserDefault setObject:arrItem forKey:@"cartItem"];
            
            UIViewController  *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"ShoppingCartViewController"];
            [self.navigationController pushViewController:vc animated:true];
        }
    }
    
}

- (IBAction)onSend:(id)sender {
    //    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onVideo:(id)sender {
    [self hideAllTabs];
    imvVideoTabSel.hidden = NO;
    collectView.hidden = NO;
    [self toolTipView:sender msg:@" Youtube Video \n     "];
    
}
- (IBAction)onBatches:(id)sender {
    [self hideAllTabs];
    imvBatchesTabSel.hidden = NO;
    tblProductCopy.hidden = NO;
    [self toolTipView:sender msg:@" Batch Times \n     "];
    
}
- (IBAction)onCertification:(id)sender {
    [self hideAllTabs];
    imvCertificationTabSel.hidden = NO;
    tblCertifications.hidden = NO;
    [self toolTipView:sender msg:@" Certification \n     "];
}

- (IBAction)onReview:(id)sender {
    [self hideAllTabs];
    imvReviewTabSel.hidden = NO;
    tblReviews.hidden = NO;
    [self toolTipView:sender msg:@" Reviews \n   "];
}

- (IBAction)onDuration:(id)sender {
    [self hideAllTabs];
    imvDurationTabSel.hidden = NO;
    viewVerified.hidden = NO;
    [self toolTipView:sender msg:@" Verified Ids \n      "];
    
}
-(void) toolTipView:(id) sender msg:(NSString*) strTittle
{
    [self dismissAllPopTipViews];
    
    if (sender == self.currentPopTipViewTarget) {
        // Dismiss the popTipView and that is all
        self.currentPopTipViewTarget = nil;
    }
    else {
        NSString *contentMessage = nil;
        contentMessage = strTittle;
        
        UIColor *backgroundColor = [UIColor whiteColor];
        UIColor *textColor = [UIColor darkGrayColor];
        
        CMPopTipView *popTipView;
        popTipView = [[CMPopTipView alloc] initWithMessage:contentMessage];
        popTipView.delegate = self;
        
        popTipView.preferredPointDirection = PointDirectionDown;
        popTipView.cornerRadius = 2.0;
        if (backgroundColor && ![backgroundColor isEqual:[NSNull null]]) {
            popTipView.backgroundColor = backgroundColor;
        }
        if (textColor && ![textColor isEqual:[NSNull null]]) {
            popTipView.textColor = textColor;
        }
        
        popTipView.animation = arc4random() % 2;
        popTipView.has3DStyle = YES;//(BOOL)(arc4random() % 2);
        
        popTipView.dismissTapAnywhere = YES;
        [popTipView autoDismissAnimated:YES atTimeInterval:1.0];
        
        if ([sender isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)sender;
            [popTipView presentPointingAtView:button inView:self.view animated:YES];
        }
        else {
            UIBarButtonItem *barButtonItem = (UIBarButtonItem *)sender;
            [popTipView presentPointingAtBarButtonItem:barButtonItem animated:YES];
        }
        
        [self.visiblePopTipViews addObject:popTipView];
        self.currentPopTipViewTarget = sender;
    }
}
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView
{
    [self.visiblePopTipViews removeObject:popTipView];
    self.currentPopTipViewTarget = nil;
}

- (void)dismissAllPopTipViews
{
    while ([self.visiblePopTipViews count] > 0) {
        CMPopTipView *popTipView = [self.visiblePopTipViews objectAtIndex:0];
        [popTipView dismissAnimated:YES];
        [self.visiblePopTipViews removeObjectAtIndex:0];
    }
}

-(IBAction)btnViewtutorProfile:(id)sender
{
    TutorProfileVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorProfileVC"];
    vc.view.backgroundColor = [UIColor clearColor];
    vc.auther = self.courseEntity.author;
    vc.autherID = self.courseEntity.author_uid;
    vc.desc = self.courseEntity.educator_introduction;
    [vc getRefreshBlock:^(NSString *anyValue) {
        if ([anyValue isEqualToString:@"1"])
        {
            [self performSegueWithIdentifier:@"GoToVendor" sender:self];
        }else{
            [self performSegueWithIdentifier:@"GoToCommentList" sender:self];
        }
    }];
    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:vc animated:NO completion:nil];
}
-(IBAction) btnAddReview:(UIButton*) sender
{
    [self performSegueWithIdentifier:@"GoToWriteReview" sender:self];
    
}
-(IBAction) btnSendNewMsg:(UIButton*) sender
{
    [self performSegueWithIdentifier:@"GoToMessage" sender:self];
    
}
#pragma mark--
-(IBAction)btnOpenMap:(id)sender
{
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:kAppName
                                  message:@"Do you want to see location in google maps?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yes = [UIAlertAction
                          actionWithTitle:@"YES"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action)
                          {
                              CourseLocationViewController *mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CourseLocationViewController"];
                              mapViewController.isFromDetail = true;
                              mapViewController.selectedCourse = self.courseEntity;
                              [self.navigationController pushViewController:mapViewController animated:YES];
                          }];
    UIAlertAction* no = [UIAlertAction
                         actionWithTitle:@"NO"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alert addAction:yes];
    [alert addAction:no];
    [self presentViewController:alert animated:YES completion:nil];
}
-(IBAction)btnShare:(id)sender
{
    if (self.courseEntity)
    {
        if (shareView.alpha == 0.0)
        {
            [UIView animateWithDuration:0.2 animations:^{
                shareView.alpha = 1.0;
            }];
        }else {
            [UIView animateWithDuration:0.2 animations:^{
                shareView.alpha = 0.0;
            }];
        }
    }
}
- (void)shareText:(NSString *)text andImage:(UIImage *)image andUrl:(NSURL *)url
{
    NSMutableArray *sharingItems = [NSMutableArray new];
    
    if (text) {
        [sharingItems addObject:text];
    }
    if (image) {
        [sharingItems addObject:image];
    }
    if (url) {
        [sharingItems addObject:url];
    }
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}
-(void) startTimer
{
    if (is_iPad())
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(updateTimeriPad) userInfo:nil repeats:YES];
    }else
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    }
    timerLocal = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(updateLocalCourse) userInfo:nil repeats:YES];
    timerRecent = [NSTimer scheduledTimerWithTimeInterval:7 target:self selector:@selector(updateRecentCourse) userInfo:nil repeats:YES];
    
}
-(void) stopTimer
{
    [timer invalidate];
    timer = nil;
    [timerRecent invalidate];
    timerRecent = nil;
    [timerLocal invalidate];
    timerLocal = nil;
}
#pragma mark -
-(void) updateTimeriPad
{
    NSInteger count = self.courseEntity.field_deal_image.count;
    if (count == 0)
    {
        return;
    }
    if (refreshCount < count)
    {
        [cvImageScroll scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:refreshCount inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [cvImageLandscap scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:refreshCount inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        refreshCount++;
    }
    else
    {
        refreshCount = 0;
        [cvImageScroll scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:refreshCount inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [cvImageLandscap scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:refreshCount inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}
-(void) updateTimer
{
    NSInteger count = self.courseEntity.field_deal_image.count;
    
    if (refreshCount < count)
    {
        CGPoint offset;
        if (is_iPad())
        {
            offset = CGPointMake(refreshCount * scrollViewImages.frame.size.width, 0);
        }
        else
        {
            offset = CGPointMake(refreshCount * self.view.frame.size.width, 0);
        }
        
        if (refreshCount * self.view.frame.size.width >= self.courseEntity.field_deal_image.count * self.view.frame.size.width)
        {
            refreshCount = 0;
            [scrollViewImages setContentOffset:offset];
            
        }else{
            
            [UIScrollView animateWithDuration:1 animations:^{
                [scrollViewImages setContentOffset:offset];
            }];
        }
        refreshCount++;
    }else{
        refreshCount = 0;
    }
    
}
-(void)autoScroll{
    int size = 0;
    if (is_iPad()) {
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        if (orientation == UIDeviceOrientationPortrait) {
            size = _screenSize.width;
        }else if (orientation == UIDeviceOrientationPortraitUpsideDown){
            size = _screenSize.width;
        }else{
            size = _screenSize.width * 0.4;
        }
    }else{
        size = _screenSize.width;
    }
    CGSize stringBoundingBox = [self.courseEntity.title sizeWithFont:[UIFont systemFontOfSize:17]];
    if(stringBoundingBox.width > size){
        CGFloat point = cvLbl.contentOffset.x;
        CGFloat lo = point + 1;
        [UIView animateWithDuration:0 delay:0.02 options:UIViewAnimationOptionCurveEaseIn animations:^{
            cvLbl.contentOffset = CGPointMake(lo, 0);
        }completion:^(BOOL finished){
            
            if (cvLbl.contentOffset.x+ 20 > stringBoundingBox.width ){
                [cvLbl setContentOffset:CGPointMake(-size+100, cvLbl.contentOffset.y) animated:false];
            }
            [self autoScroll];
        }];
    }
}


-(void) updateLocalCourse
{
    if (currentLocalIndex+1 <= self.arrLocalViewed.count - 1){
        currentLocalIndex ++;
        [self reloadLocal:[NSIndexPath indexPathForRow:currentLocalIndex inSection:0]];
    }else{
        currentLocalIndex = 0;
    }
}
-(void) updateRecentCourse
{
    if (currentRecentIndex+1 <= arrRecentViewed.count - 1){
        currentRecentIndex ++;
        [self reloadRecent:[NSIndexPath indexPathForRow:currentRecentIndex inSection:0]];
    }else{
        currentRecentIndex = 0;
    }
}
#pragma mark - UI update
-(void) updateUI
{
    lblCourseTittle.text = self.courseEntity.title;
    lblCity.text= self.courseEntity.city;
    lblCourseTutors.text = self.courseEntity.author;
    lblCourseTrialClass.text = ([self checkStringValue:self.courseEntity.field_trial_class])?@"NO":self.courseEntity.field_trial_class;
    if (self.courseEntity.productArr.count > 0) {
        ProductEntity * product = self.courseEntity.productArr[0];
        lblAge.text = product.field_age_group;
        lblCourseStartEnd.text = product.course_start_date;
        lblCourseEndDate.text = product.course_end_date;
        lblCourseSessionNo.text = product.sessions_number;
        lblSold.text = product.sold;
        lblQuantity.text = product.quantity;
        lblSoldCopy.text = product.sold;
        lblQuantityCopy.text = product.quantity;
        lblBatchSize.text = product.batch_size;
        lblInitialPrice.text = product.initial_price;
        lblInitialPriceCopy.text = product.initial_price;
        
        NSString* totalString = [product.initial_price stringByTrimmingCharactersInSet: [NSCharacterSet symbolCharacterSet]];
        NSString* discountString = [product.price stringByTrimmingCharactersInSet: [NSCharacterSet symbolCharacterSet]];
        float total = totalString.floatValue;
        float discount = discountString.floatValue;
        lblDiscounts.text = [NSString stringWithFormat:@"£ %.2f %% discount you save £ %.1f",100 - ((total/discount) * 100),(total-discount)];
        lblDiscountsCopy.text = [NSString stringWithFormat:@"£ %.2f %% discount you save £ %.1f",100 - ((total/discount) * 100),(total-discount)];
    }
    if (![self checkStringValue:self.courseEntity.comment_count]) {
        lblCommentsCount.text = self.courseEntity.comment_count;
    }
    lblCommentsCount.layer.cornerRadius = 7.5;
    lblCommentsCount.layer.masksToBounds =YES;
    
    lblSpamCount.text = self.courseEntity.spam_flag_counter;
    lblSpamCount.layer.cornerRadius = 7.5;
    lblSpamCount.layer.masksToBounds =YES;
    
    if (![self checkStringValue:self.courseEntity.course_requirements]) {
        txtRequirements.text = self.courseEntity.course_requirements;
        CGRect rect = [self.courseEntity.course_requirements getStringHeight:(txtRequirements.frame.size.width) font:[UIFont systemFontOfSize:15]];
        _heightRequiremenTxt.constant =  rect.size.height + 30;
        if (is_iPad()) {
            scrollHeight = (scrollHeight-100)+_heightRequiremenTxt.constant;
            viewHeightConstraint.constant = scrollHeight;
            [scrollMain setContentSize:CGSizeMake(scrollMain.frame.size.width,scrollHeight)];
            [self.view layoutIfNeeded];
        }else{
            int mainSize = [scrollMain contentSize].height;
            scrollHeight = (mainSize - 100) + _heightRequiremenTxt.constant;
            viewHeightConstraint.constant = scrollHeight;
            [scrollMain setContentSize:CGSizeMake(_screenSize.width,scrollHeight)];
            [self.view layoutIfNeeded];
        }
        
        
    }else{
        txtRequirements.text = @"";
    }
    
    if (![self checkStringValue:self.courseEntity.landLine_number])
    {
        if ([self.courseEntity.landLine_number length] > 4) {
            self.courseEntity.landLine_number = [self.courseEntity.landLine_number substringToIndex:[self.courseEntity.landLine_number length] - 4];
        }
        lblCourseLandline.text = [NSString stringWithFormat:@"%@****",self.courseEntity.landLine_number];
    }else{
        lblCourseLandline.text = @"";
        
    }
    if (![self checkStringValue:self.courseEntity.mobile])
    {
        if ([self.courseEntity.mobile length] > 4) {
            self.courseEntity.mobile = [self.courseEntity.mobile substringToIndex:[self.courseEntity.mobile length] - 4];
        }
        lblCourseContactNo.text = [NSString stringWithFormat:@"%@****",self.courseEntity.mobile];
    }else{
        lblCourseContactNo.text = @"";
    }
    
    if (![self checkStringValue:self.courseEntity.Description]) {
        
        [webViewDesc loadHTMLString:[NSString stringWithFormat:@"<html><head><style>div {color:white;} p {color:white;}</style></head><body text=\"#FFFFFF\"><font face='ProximaNova-light' ><div id ='foo'>%@</div></body></html>", self.courseEntity.Description] baseURL: nil];
        webViewDesc.hidden = false;
    }else{
        webViewDesc.hidden = true;
    }
    
    webViewDesc.backgroundColor = [UIColor clearColor];
    webViewDesc.opaque = NO;
    
    if ([self.courseEntity.certifications isKindOfClass:[NSString class]])
    {
        NSArray *arrCerti = [self.courseEntity.certifications componentsSeparatedByString:@","];
        
        if (arrCerti && arrCerti.count>0)
        {
            [arrCertifications addObjectsFromArray:arrCerti];
            [tblCertifications reloadData];
        }else{
            lblCertification.text = @"No certificate found.";
        }
    }
    if ([self.courseEntity.favorite_flag_flagged.uppercaseString isEqualToString:@"NO"])
    {
        btnFav.selected = NO;
    }else{
        btnFav.selected = YES;
    }
    if ([self.courseEntity.spam_flag_flagged.uppercaseString isEqualToString:@"NO"])
    {
        btnSpam.selected = NO;
    }else{
        btnSpam.selected = YES;
    }
    
    if ([self.courseEntity.address_verified_flagged.uppercaseString isEqualToString:@"NO"])
    {
        imgVerAddress.image = [UIImage imageNamed:@"ic_nv_adress-icon"];
        
    }else
    {
        imgVerAddress.image = [UIImage imageNamed:@"ic_address_verified"];
    }
    
    if ([self.courseEntity.mobile_verified_flagged.uppercaseString isEqualToString:@"NO"])
    {
        imgVerMobile.image = [UIImage imageNamed:@"ic_nv_mobile-icon"];
        
    }else{
        imgVerMobile.image = [UIImage imageNamed:@"ic_mobile_no_verified"];
        
    }
    if ([self.courseEntity.social_media_verified_flagged.uppercaseString isEqualToString:@"NO"])
    {
        imgVerSocial.image = [UIImage imageNamed:@"ic_nv_socials-icon"];
        
        
    }else{
        imgVerSocial.image = [UIImage imageNamed:@"ic_social_verified"];
    }
    if ([self.courseEntity.landline_verified_flagged.uppercaseString isEqualToString:@"NO"])
    {
        
        imgVerLand.image = [UIImage imageNamed:@"ic_nv_land-icon"];
        
    }else{
        imgVerLand.image = [UIImage imageNamed:@"ic_land_verified"];
        
    }
    if ([self.courseEntity.email_verified_flagged.uppercaseString isEqualToString:@"NO"])
    {
        imgVerEmail.image = [UIImage imageNamed:@"ic_nv_mail-icon"];
        
    }else{
        imgVerEmail.image = [UIImage imageNamed:@"ic_email_verifed"];
    }
    
    if ([self.courseEntity.credit_card_verified_flagged.uppercaseString isEqualToString:@"NO"])
    {
        imgVerCard.image = [UIImage imageNamed:@"ic_nv_credit-card-icon"];
        
    }else{
        imgVerCard.image = [UIImage imageNamed:@"ic_card_verified"];
        
    }
    if (!is_iPad())
    {
        int i=0;
        int tag = 0;
        if ([self.courseEntity.field_deal_image isKindOfClass:[NSString class]])
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * i++, 0, self.view.frame.size.width, scrollViewImages.frame.size.height)];
            
            UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height)];
            btn.tag = tag;
            tag = tag + 1;
            btn.backgroundColor = [UIColor clearColor];
            
            [btn addTarget:self action:@selector(btnZoomImage:) forControlEvents:UIControlEventTouchUpInside];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.courseEntity.field_deal_image]
                         placeholderImage:[UIImage imageNamed:@"placeholder"]
                                  options:SDWebImageRefreshCached];
            
            
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            
            [scrollViewImages addSubview:imageView];
            [scrollViewImages addSubview:btn];
            scrollViewImages.contentSize = CGSizeMake(self.view.frame.size.width,scrollViewImages.frame.size.height);
        }else if([self.courseEntity.field_deal_image isKindOfClass:[NSArray class]])
        {
            for (NSString *image in self.courseEntity.field_deal_image)
            {
                UIImageView *imageView;
                UIButton *btn;
                if (is_iPad())
                {
                    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(scrollViewImages.frame.size.width * i++, 0, scrollViewImages.frame.size.width, (self.view.frame.size.height * 0.45))];
                    btn =[[UIButton alloc] initWithFrame:CGRectMake(imageView.frame.origin.x, 0, scrollViewImages.frame.size.width, (self.view.frame.size.height * 0.45))];
                }else{
                    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * i++, 0, self.view.frame.size.width, scrollViewImages.frame.size.height)];
                    btn =[[UIButton alloc] initWithFrame:CGRectMake(imageView.frame.origin.x, 0, self.view.frame.size.width, scrollViewImages.frame.size.height)];
                }
                
                btn.tag = tag;
                tag = tag + 1;
                btn.backgroundColor = [UIColor clearColor];
                
                [btn addTarget:self action:@selector(btnZoomImage:) forControlEvents:UIControlEventTouchUpInside];
                
                [imageView sd_setImageWithURL:[NSURL URLWithString:image]
                             placeholderImage:[UIImage imageNamed:@"placeholder"]
                                      options:SDWebImageRefreshCached];
                
                
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.clipsToBounds = YES;
                
                [scrollViewImages addSubview:imageView];
                [scrollViewImages addSubview:btn];
            }
            
            scrollViewImages.contentSize = CGSizeMake(self.courseEntity.field_deal_image.count * scrollViewImages.frame.size.width,scrollViewImages.frame.size.height);
            
        }
    }
    
    [self startTimer];
    
    [self performSelector:@selector(getCommentsData:) withObject:self.courseEntity.nid afterDelay:0.5];
    
    if (self.isGoComment)
    {
        CGPoint offset = CGPointMake(0, tblReviews.frame.origin.y);
        [self scrollToscreen:offset];
        [self onReview:nil];
        
    }
    // Load comment secon time after added
    isViewDidLoad = true;
    [cvImageScroll reloadData];
    [cvImageLandscap reloadData];
    [cvLbl reloadData];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *output = [webViewDesc stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"foo\").offsetHeight;"];
    NSLog(@"height: %@", output);
    int value= output.intValue + 60;
    if (value < 50) {
        value = 60;
    }
    int mainSize = [scrollMain contentSize].height;
    
    if (is_iPad())
    {
        scrollHeight = (scrollHeight-250)+value;
        viewHeightConstraint.constant = scrollHeight;
        webViewHeight.constant = value;
        [scrollMain setContentSize:CGSizeMake(scrollMain.frame.size.width,scrollHeight)];
        [self.view layoutIfNeeded];
    }else{
        int size = (mainSize-318)+value;
        if (size < 1220) {
            size = 1230;
        }
        viewHeightConstraint.constant = size;
        webViewHeight.constant = value;
        [scrollMain setContentSize:CGSizeMake(_screenSize.width,size)];
        [self.view layoutIfNeeded];
    }
}
-(IBAction)btnSortBatches:(UIButton*)sender {
    
    NSArray *sortedArray;
    if(sender.tag == 999){
        if (sortedIndex == 999) {
            sender.selected = false;
            sortedArray= [self.courseEntity.productArr sortedArrayUsingComparator: ^(ProductEntity *d1, ProductEntity *d2) {
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"dd-MMM-yy"];
                
                NSDate *dd1 = [df dateFromString:d1.course_end_date];
                NSDate *dd2 = [df dateFromString:d2.course_end_date];
                return [dd1 compare: dd2];
            }];
            sortedIndex = 9999;
        }else{
            sortedIndex = 999;
            sender.selected = true;
            sortedArray= [self.courseEntity.productArr sortedArrayUsingComparator: ^(ProductEntity *d1, ProductEntity *d2) {
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"dd-MMM-yy"];
                
                NSDate *dd1 = [df dateFromString:d1.course_end_date];
                NSDate *dd2 = [df dateFromString:d2.course_end_date];
                return [dd2 compare: dd1];
            }];
        }
        
        [self.courseEntity.productArr removeAllObjects];
        [self.courseEntity.productArr addObjectsFromArray:sortedArray];
    }else if(sender.tag == 998){
        if (sortedIndex == 998) {
            sender.selected = false;
            sortedArray = [self.courseEntity.productArr sortedArrayUsingComparator: ^(ProductEntity *d1, ProductEntity *d2) {
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"dd-MMM-yy"];
                
                NSDate *dd1 = [df dateFromString:d1.course_start_date];
                NSDate *dd2 = [df dateFromString:d2.course_start_date];
                return [dd1 compare: dd2];
            }];
            sortedIndex = 9988;
        }else{
            sender.selected = true;
            sortedArray = [self.courseEntity.productArr sortedArrayUsingComparator: ^(ProductEntity *d1, ProductEntity *d2) {
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"dd-MMM-yy"];
                
                NSDate *dd1 = [df dateFromString:d1.course_start_date];
                NSDate *dd2 = [df dateFromString:d2.course_start_date];
                return [dd2 compare: dd1];
            }];
            sortedIndex = 998;
        }
        [self.courseEntity.productArr removeAllObjects];
        [self.courseEntity.productArr addObjectsFromArray:sortedArray];
        
    }else if(sender.tag  == 997){
        if (sortedIndex == 997) {
            sortedArray = [self.courseEntity.productArr sortedArrayUsingComparator: ^(ProductEntity *d1, ProductEntity *d2) {
                return [d1.sessions_number compare: d2.sessions_number];
            }];
            sortedIndex = 9977;
        }else{
            sortedArray = [self.courseEntity.productArr sortedArrayUsingComparator: ^(ProductEntity *d1, ProductEntity *d2) {
                return [d2.sessions_number compare: d1.sessions_number];
            }];
            sortedIndex = 997;
        }
        [self.courseEntity.productArr removeAllObjects];
        [self.courseEntity.productArr addObjectsFromArray:sortedArray];
    }else if (sender.tag == 996){
        if (sortedIndex == 996) {
            sortedArray = [self.courseEntity.productArr sortedArrayUsingComparator: ^(ProductEntity *d1, ProductEntity *d2) {
                return [d1.batch_size compare: d2.batch_size];
            }];
            sortedIndex = 9966;
            
        }else{
            sortedArray = [self.courseEntity.productArr sortedArrayUsingComparator: ^(ProductEntity *d1, ProductEntity *d2) {
                return [d2.batch_size compare: d1.batch_size];
            }];
            sortedIndex = 996;
            
        }
        [self.courseEntity.productArr removeAllObjects];
        [self.courseEntity.productArr addObjectsFromArray:sortedArray];
    }else if (sender.tag == 995){
        if (sortedIndex == 995) {
            sortedIndex = 9955;
            sortedArray = [self.courseEntity.productArr sortedArrayUsingComparator: ^(ProductEntity *d1, ProductEntity *d2) {
                return [d1.initial_price compare: d2.initial_price];
            }];
        }else{
            sortedArray = [self.courseEntity.productArr sortedArrayUsingComparator: ^(ProductEntity *d1, ProductEntity *d2) {
                return [d2.initial_price compare: d1.initial_price];
            }];
            sortedIndex = 995;
            
        }
        [self.courseEntity.productArr removeAllObjects];
        [self.courseEntity.productArr addObjectsFromArray:sortedArray];
    }
    [tblProduct reloadData];
    [tblProductCopy reloadData];
}

#pragma mark - tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == tblCertifications) {
        return [arrCertifications count];
    }
    if (tableView == tblReviews) {
        return [arrReviews count];
    }
    if (tableView == tblProduct || tableView == tblProductCopy) {
        if (self.courseEntity.productArr) {
            return self.courseEntity.productArr.count;
        }else{
            return 0;
        }
        
    }
    if(tableView == tblProductCopy) {
        if (self.courseEntity.productArr) {
            return self.courseEntity.productArr.count;
        }else{
            return 0;
        }
    }
    return 0;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == tblProduct || tableView == tblProductCopy) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
        int size = 0;
        if (is_iPad()) {
            UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
            if (orientation == UIDeviceOrientationPortrait) {
                size = _screenSize.width;
            }else if (orientation == UIDeviceOrientationPortraitUpsideDown){
                size = _screenSize.width;
            }else{
                size = _screenSize.width * 0.6;
            }
        }else{
            size = _screenSize.width;
        }
        cell.frame = CGRectMake(0, 0, size, cell.frame.size.height);
        UILabel * lbl1 = [cell viewWithTag:701];
        UILabel * lbl2 = [cell viewWithTag:702];
        UILabel * lbl3 = [cell viewWithTag:703];
        UILabel * lbl4 = [cell viewWithTag:704];
        UILabel * lbl5 = [cell viewWithTag:705];
        lbl1.hidden = true;
        lbl2.hidden = true;
        lbl3.hidden = true;
        lbl4.hidden = true;
        lbl5.hidden = true;
        
        if (sortedIndex == 999 || sortedIndex == 999) {
            lbl2.hidden = false;
        }
        if (sortedIndex == 998 || sortedIndex == 9988) {
            lbl1.hidden = false;
        }
        if (sortedIndex == 997 || sortedIndex == 9977) {
            lbl3.hidden = false;
        }
        if (sortedIndex == 996 || sortedIndex == 9966) {
            lbl4.hidden = false;
        }
        if (sortedIndex == 995 || sortedIndex == 9955) {
            lbl5.hidden = false;
        }
        UIView *view = [[UIView alloc] initWithFrame:[cell frame]];
        [view addSubview:cell];
        UIButton * btn1 = [cell viewWithTag:998];
        UIButton * btn2 = [cell viewWithTag:999];
        UIButton * btn3 = [cell viewWithTag:997];
        UIButton * btn4 = [cell viewWithTag:996];
        UIButton * btn5 = [cell viewWithTag:995];
        btn1.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        btn1.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        btn1.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        
        btn2.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        btn2.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        btn2.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        
        btn3.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        btn3.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        btn3.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        btn4.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        btn4.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        btn4.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        btn5.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        btn5.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        btn5.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        return view;
        
    }
    if (tableView == tblProductCopy) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
        UILabel * lbl1 = [cell viewWithTag:701];
        UILabel * lbl2 = [cell viewWithTag:702];
        UILabel * lbl3 = [cell viewWithTag:703];
        UILabel * lbl4 = [cell viewWithTag:704];
        UILabel * lbl5 = [cell viewWithTag:705];
        lbl1.hidden = true;
        lbl2.hidden = true;
        lbl3.hidden = true;
        lbl4.hidden = true;
        lbl5.hidden = true;
        
        if (sortedIndex == 999 || sortedIndex == 999) {
            lbl2.hidden = false;
        }
        if (sortedIndex == 998 || sortedIndex == 9988) {
            lbl1.hidden = false;
        }
        if (sortedIndex == 997 || sortedIndex == 9977) {
            lbl3.hidden = false;
        }
        if (sortedIndex == 996 || sortedIndex == 9966) {
            lbl4.hidden = false;
        }
        if (sortedIndex == 995 || sortedIndex == 9955) {
            lbl5.hidden = false;
        }
        UIView *view = [[UIView alloc] initWithFrame:[cell frame]];
        [view addSubview:cell];
        
        
        
        return view;
        
    }
    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == tblProduct) {
        return (is_iPad())?45:35;
    }
    if (tableView == tblProductCopy) {
        return (is_iPad())?45:35;
    }
    return 1.00;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == tblCertifications) {
        CertificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CertificationTableViewCell"];
        [cell setDataCertificate:[arrCertifications objectAtIndex:indexPath.row]];
        return cell;
    }
    if (tableView == tblReviews) {
        ReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewTableViewCell"];
        Review* review = [arrReviews objectAtIndex:indexPath.row];
        [cell setData:review];
        return cell;
    }
    if (tableView == tblProduct || tableView == tblProductCopy) {
        ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productCell" forIndexPath:indexPath];
        ProductEntity* product = self.courseEntity.productArr[indexPath.row];
        [cell.btnBuy addTarget:self action:@selector(buyCourseFromBatches:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnBuy.tag = indexPath.row;
        if (product) {
            [cell setData:product];
        }
        NSDateFormatter *dateOnly = globalDateOnlyFormatter();
        NSDate *date = [dateOnly dateFromString:product.course_start_date];
        if (date) {
            if ([date compare:[NSDate date]] == NSOrderedSame || [date compare:[NSDate date]] == NSOrderedAscending || [product.sold integerValue] == [product.quantity integerValue]) {
                [cell.btnBuy setTitle:@"Closed" forState:UIControlStateNormal];
                cell.btnBuy.backgroundColor = [UIColor lightGrayColor];
                cell.btnBuy.enabled = NO;
            }else{
                [cell.btnBuy setTitle:@"BUY" forState:UIControlStateNormal];
                cell.btnBuy.backgroundColor = [UIColor colorFromHexString:@"F52375"];
                cell.btnBuy.enabled = YES;
            }
        }
        if ([selectedProduct_id isEqualToString:product.product_id]) {
            cell.lblBatchSize.textColor =  [UIColor colorFromHexString:@"F52375"];
            cell.lblEndDate.textColor =  [UIColor colorFromHexString:@"F52375"];
            cell.lblPice.textColor =  [UIColor colorFromHexString:@"F52375"];
            cell.lblSessions.textColor =  [UIColor colorFromHexString:@"F52375"];
            cell.lblStartDate.textColor =  [UIColor colorFromHexString:@"F52375"];
        }else {
            if (tableView == tblProductCopy) {
                cell.lblBatchSize.textColor =  [UIColor blackColor];
                cell.lblEndDate.textColor =  [UIColor blackColor];
                cell.lblPice.textColor =  [UIColor blackColor];
                cell.lblSessions.textColor =  [UIColor blackColor];
                cell.lblStartDate.textColor =  [UIColor blackColor];
                
            }else{
                cell.lblBatchSize.textColor =  [UIColor whiteColor];
                cell.lblEndDate.textColor =  [UIColor whiteColor];
                cell.lblPice.textColor =  [UIColor whiteColor];
                cell.lblSessions.textColor =  [UIColor whiteColor];
                cell.lblStartDate.textColor =  [UIColor whiteColor];
            }
        }
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == tblReviews) {
        [self performSegueWithIdentifier:@"GoToCommentList" sender:indexPath];
    }
    if (tableView == tblProduct || tableView == tblProductCopy) {
        ProductEntity *product = self.courseEntity.productArr[indexPath.row];
        
        NSDateFormatter *dateOnly = globalDateOnlyFormatter();
        NSDate *date = [dateOnly dateFromString:product.course_start_date];

        if ([date compare:[NSDate date]] == NSOrderedSame || [date compare:[NSDate date]] == NSOrderedAscending || [product.sold integerValue] == [product.quantity integerValue]) {
            showAletViewWithMessage(@"Batch sold out,Please select active batch.");
        }else{
            selectedProduct_id = product.product_id;
            [self displayValueBasedOnSelectedBatch:product];
        }
        [tableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblCertifications) {
        return UITableViewAutomaticDimension;
    }
    if (tableView == tblReviews) {
        return 70;
    }
    if (tableView == tblProduct || tableView == tblProductCopy) {
        return 45;
    }
    return 0;
}
-(void) displayValueBasedOnSelectedBatch:(ProductEntity*) obj;
{
    lblCourseStartEnd.text = obj.course_start_date;
    lblCourseEndDate.text = obj.course_end_date;
    lblBatchSize.text = obj.batch_size;
    lblCourseSessionNo.text = obj.sessions_number;
    NSString* totalString = [obj.initial_price stringByTrimmingCharactersInSet: [NSCharacterSet symbolCharacterSet]];
    NSString* discountString = [obj.price stringByTrimmingCharactersInSet: [NSCharacterSet symbolCharacterSet]];
    float total = totalString.floatValue;
    float discount = discountString.floatValue;
    //        NSLog(@"%f",(100 - discount)/total);
    //        float finalDiscount = (100 - discount)/total;
    // 100 - ((total/discount) * 100)
    lblInitialPrice.text = obj.initial_price;
    lblInitialPriceCopy.text = obj.initial_price;
    lblDiscounts.text = [NSString stringWithFormat:@"£ %.2f %% discount you save £ %.1f",100 - ((total/discount) * 100),(total-discount)];
    lblDiscountsCopy.text = [NSString stringWithFormat:@"£ %.2f %% discount you save £ %.1f",100 - ((total/discount) * 100),(total-discount)];
    lblSold.text = obj.sold;
    lblSoldCopy.text = obj.sold;
    lblQuantity.text = obj.quantity;
    lblQuantityCopy.text = obj.quantity;
}

-(void) buyCourseFromBatches:(UIButton*)sender{
    if (self.courseEntity == nil)
    {
        return;
    }
    NSMutableArray *arrItem;
    if ([UserDefault objectForKey:@"cartItem"])
    {
        arrItem = [[UserDefault objectForKey:@"cartItem"] mutableCopy];
        
    }else{
        arrItem = [[NSMutableArray alloc]init];
        
    }
    if (arrItem.count > 4)
    {
        showAletViewWithMessage(@"Let’s save some for others, there’s a 5 course purchase limit at any given time");
        return;
    }
    
    NSArray * arr = [arrItem filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"id == %@",self.courseEntity.nid]];
    if (arr.count > 0)
    {
        showAletViewWithMessage(@"No need to double dip, this course already in your shopping cart");
        return;
    }
    if (self.courseEntity.productArr) {
        if (self.courseEntity.productArr.count > 0) {
            ProductEntity * product = self.courseEntity.productArr[sender.tag];
            NSString* totalString = [product.initial_price stringByTrimmingCharactersInSet: [NSCharacterSet symbolCharacterSet]];
            NSDictionary *dict = @{@"category":self.courseEntity.category,@"course_tittle":self.courseEntity.title,@"price":totalString,@"id":NID,@"product_id":product.product_id};
            [arrItem addObject:dict];
            [UserDefault setObject:arrItem forKey:@"cartItem"];
            
            UIViewController  *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"ShoppingCartViewController"];
            [self.navigationController pushViewController:vc animated:true];
        }
    }
    
    
    
    
    
    
}
#pragma mark - UICollectionView delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == cvLbl) {
        return 1;
    }
    if (collectionView == cvRecent)
    {
        return arrRecentViewed.count;
    }
    if (collectionView == cvRecentCopy)
    {
        return arrRecentViewed.count;
    }
    
    if (collectionView == cvLocalCopy)
    {
        return self.arrLocalViewed.count;
    }
    
    if (collectionView == cvLocal)
    {
        return self.arrLocalViewed.count;
    }
    if (collectionView == cvImageScroll)
    {
        if ([self.courseEntity.field_deal_image isKindOfClass:[NSString class]])
        {
            return 1;
        }
        return self.courseEntity.field_deal_image.count;
    }
    if (collectionView == cvImageLandscap)
    {
        if ([self.courseEntity.field_deal_image isKindOfClass:[NSString class]])
        {
            return 1;
        }
        return self.courseEntity.field_deal_image.count;
    }
    
    return self.courseEntity.youtube_video.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectView == collectionView)
    {
        if (is_iPad())
        {
            return CGSizeMake(self.view.frame.size.width/3, self.view.frame.size.width/3);
        }
        return CGSizeMake(self.view.frame.size.width/2, self.view.frame.size.width/2);
    }
    if (collectionView == cvImageScroll)
    {
        NSLog(@"collectionView.frame:%f",collectionView.frame.size.width);
        return CGSizeMake(collectionView.frame.size.width, 400);
    }
    if (collectionView == cvImageLandscap)
    {
        NSLog(@"collectionView.frame:%f",collectionView.frame.size.width);
        return CGSizeMake(collectionView.frame.size.width, 400);
    }
    if (collectionView == cvLbl) {
        if (self.courseEntity && ![self checkStringValue:self.courseEntity.title]) {
            CGSize stringBoundingBox = [self.courseEntity.title sizeWithFont:[UIFont systemFontOfSize:17]];
            return CGSizeMake(stringBoundingBox.width, collectionView.frame.size.height);
        }else{
            return CGSizeMake(collectionView.frame.size.height, collectionView.frame.size.height);
        }
    }
    if (is_iPad())
    {
        return CGSizeMake(collectionView.frame.size.height, collectionView.frame.size.height);
    }
    return CGSizeMake(collectionView.frame.size.height+20, collectionView.frame.size.height);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == cvLbl)
    {
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"lblCell" forIndexPath:indexPath];
        UILabel *lblName = [cell viewWithTag:321];
        if (self.courseEntity && ![self checkStringValue:self.courseEntity.title]) {
            lblName.text = self.courseEntity.title;
        }
        return cell;
    }
    if (collectionView == collectView)
    {
        YoutubeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YoutubeCell" forIndexPath:indexPath];
        NSDictionary *playerVars = @{@"showinfo" : @0};
        [cell.playerView loadWithVideoId:self.courseEntity.youtube_video[indexPath.row] playerVars:playerVars];
        cell.playerView.delegate = self;
        cell.playerView.hidden =true;
        
        return cell;
    }
    if(collectionView == cvRecent || collectionView == cvRecentCopy)
    {
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        cell.layer.cornerRadius = 5;
        cell.layer.masksToBounds = YES;
        CourseDetail *entity = [arrRecentViewed objectAtIndex:indexPath.row];
        UILabel *lblTittle = [cell viewWithTag:5];
        UILabel *lblComments = [cell viewWithTag:6];
        lblComments.text = entity.comment_count;
        lblTittle.text = entity.title;
        
        UILabel *lblName = [cell viewWithTag:4];
        lblName.text = [NSString stringWithFormat:@"%@",entity.category];
        UIImageView *img = [cell viewWithTag:12];
        if ([entity.field_deal_image isKindOfClass:[NSArray class]])
        {
            if (entity.field_deal_image && entity.field_deal_image.count>0)
            {
                [img sd_setImageWithURL:[NSURL URLWithString:entity.field_deal_image[0]]
                       placeholderImage:[UIImage imageNamed:@"placeholder"]
                                options:SDWebImageRefreshCached];
            }
        }else if ([entity.field_deal_image isKindOfClass:[NSString class]])
        {
            
            [img sd_setImageWithURL:[NSURL URLWithString:entity.field_deal_image]
                   placeholderImage:[UIImage imageNamed:@"placeholder"]
                            options:SDWebImageRefreshCached];
        }
        return cell;
    }
    if (collectionView == cvImageScroll || collectionView == cvImageLandscap)
    {
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellScoll" forIndexPath:indexPath];
        UIImageView *img = [cell viewWithTag:91];
        if ([self.courseEntity.field_deal_image isKindOfClass:[NSString class]])
        {
            [img sd_setImageWithURL:[NSURL URLWithString:self.courseEntity.field_deal_image]
                   placeholderImage:[UIImage imageNamed:@"placeholder"]
                            options:SDWebImageRefreshCached];
        }else
        {
            
            [img sd_setImageWithURL:[NSURL URLWithString:self.courseEntity.field_deal_image[indexPath.row]]
                   placeholderImage:[UIImage imageNamed:@"placeholder"]
                            options:SDWebImageRefreshCached];
        }
        
        return cell;
    }
    else
    {
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        cell.layer.cornerRadius = 5;
        cell.layer.masksToBounds = YES;
        id currentEntity = [self.arrLocalViewed objectAtIndex:indexPath.row];
        if ([currentEntity isKindOfClass:[CourseDetail class]])
        {
            CourseDetail *entity = [self.arrLocalViewed objectAtIndex:indexPath.row];
            UIImageView *img = [cell viewWithTag:12];
            UILabel *lblTittle = [cell viewWithTag:5];
            UILabel *lblComments = [cell viewWithTag:6];
            lblComments.text = entity.comment_count;
            lblTittle.text = entity.title;
            UILabel *lblName = [cell viewWithTag:4];
            lblName.text = [NSString stringWithFormat:@"%@",entity.category];
            
            if ([entity.field_deal_image isKindOfClass:[NSArray class]])
            {
                if (entity.field_deal_image && entity.field_deal_image.count>0)
                {
                    [img sd_setImageWithURL:[NSURL URLWithString:entity.field_deal_image[0]]
                           placeholderImage:[UIImage imageNamed:@"placeholder"]
                                    options:SDWebImageRefreshCached];
                    
                }
            }else if ([entity.field_deal_image isKindOfClass:[NSString class]])
            {
                [img sd_setImageWithURL:[NSURL URLWithString:entity.field_deal_image]
                       placeholderImage:[UIImage imageNamed:@"placeholder"]
                                options:SDWebImageRefreshCached];
            }
            
        }
        else
        {
            Course *entity = [self.arrLocalViewed objectAtIndex:indexPath.row];
            UIImageView *img = [cell viewWithTag:12];
            UILabel *lblTittle = [cell viewWithTag:5];
            UILabel *lblComments = [cell viewWithTag:6];
            lblComments.text = entity.comment_count;
            lblTittle.text = entity.title;
            UILabel *lblName = [cell viewWithTag:4];
            lblName.text = [NSString stringWithFormat:@"%@->%@",entity.category,entity.sub_category];
            if ([entity.images isKindOfClass:[NSArray class]])
            {
                if (entity.images.count > 0) {
                    [img sd_setImageWithURL:[NSURL URLWithString:entity.images[0]]
                           placeholderImage:[UIImage imageNamed:@"placeholder"]
                                    options:SDWebImageRefreshCached];
                }
            }
            
        }
        return cell;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == cvRecent)
    {
        CourseDetail *entity = [arrRecentViewed objectAtIndex:indexPath.row];
        [self getCourseDetails:entity.nid];
        [self scrollToscreen:CGPointMake(0, 0)];
    }else if (collectionView == cvLocal)
    {
        id currentEntity = [self.arrLocalViewed objectAtIndex:indexPath.row];
        if ([currentEntity isKindOfClass:[CourseDetail class]])
        {
            CourseDetail *ent = currentEntity;
            [self getCourseDetails:ent.nid];
        }else
        {
            Course *entity = [self.arrLocalViewed objectAtIndex:indexPath.row];
            [self getCourseDetails:entity.nid];
            
        }
        [self scrollToscreen:CGPointMake(0, 0)];
        
    }else if (collectionView == cvImageLandscap || collectionView == cvImageScroll)
    {
        ImageZoomViewController  *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"ImageZoomViewController"];
        vc.path =[self.courseEntity.field_deal_image objectAtIndex:indexPath.row];
        if ([self.courseEntity.field_deal_image isKindOfClass:[NSMutableArray class]])
        {
            vc.arrData = self.courseEntity.field_deal_image;
        }
        vc.course = self.courseEntity;
        [self presentViewController:vc animated:YES completion:nil];
    }
}
- (void)playerViewDidBecomeReady:(YTPlayerView *)playerView {
    playerView.hidden = NO;
}
#pragma mark - Scrollview delegate

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == scrollMain && !is_iPad())
    {
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
    }else
    {
        [self stopTimer];
    }
    shareView.alpha = 0.0;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == scrollMain && !is_iPad())
    {
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
    }else{
        if (arrRecentViewed.count > 0)
        {
            UICollectionViewCell *cell = [[cvRecent visibleCells] firstObject];
            NSIndexPath *index = [cvRecent indexPathForCell:cell];
            currentRecentIndex = index.row;
        }
        if (self.arrLocalViewed.count > 0)
        {
            UICollectionViewCell *cell = [[cvLocal visibleCells] firstObject];
            NSIndexPath *index = [cvLocal indexPathForCell:cell];
            currentLocalIndex = index.row;
        }
        [self startTimer];
        
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    // UITableView only moves in one direction, y axis
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    //NSInteger result = maximumOffset - currentOffset;
    
    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= 3.0 && commentPageIndex != -1 && scrollView == tblReviews)
    {
        if (![self checkStringValue:self.courseEntity.nid])
        {
            [self getCommentsData:self.courseEntity.nid];
            isCommentLoading = true;
        }
        
    }
}
-(void) scrollToscreen:(CGPoint) offset
{
    [UIScrollView animateWithDuration:1 animations:^{
        [scrollMain setContentOffset:offset];
        
    }];
    
}
-(void)reloadLocal:(NSIndexPath *)indexPath{
    
    currentLocalIndex = indexPath.row;
    if (self.arrLocalViewed && self.arrLocalViewed.count > indexPath.row)
    {
        [cvLocal reloadData];
        [cvLocal scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}
-(void)reloadRecent:(NSIndexPath *)indexPath
{
    
    currentRecentIndex = indexPath.row;
    if (arrRecentViewed && arrRecentViewed.count > indexPath.row)
    {
        [cvRecent reloadData];
        [cvRecent scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

#pragma mark - Youtube player delegate
- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state {
    switch (state) {
        case kYTPlayerStatePlaying:
            NSLog(@"Started playback");
            break;
        case kYTPlayerStatePaused:
            NSLog(@"Paused playback");
            [collectView reloadData];
            break;
        default:
            break;
    }
}

@end
