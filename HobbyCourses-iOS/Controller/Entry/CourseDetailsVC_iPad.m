//
//  CourseDetailsVC_iPad.m
//  HobbyCourses
//
//  Created by iOS Dev on 04/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "CourseDetailsVC_iPad.h"
#import "AmenitiesVC.h"
#import "AgeInfoPopVC.h"
#import "SuitablePopVC.h"

@interface CourseDetailsVC_iPad ()<SFSafariViewControllerDelegate>
{
    NSArray * arrCaption,*arrAction;
    NSMutableArray<Review*> *arrReviews;
    int selectedProduct;
    NSTimer *clockTimer;
    NSDate *timerDate;
}
@end

@implementation CourseDetailsVC_iPad
@synthesize tableview;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self getCommentsData:self.NID];
    [self getCourseDetails:self.NID];
    arrCaption = [[NSArray alloc]initWithObjects:@"",@"Course Batches",@"Course Videos",@"Certification",@"Verified ID's",@"Amenities",@"Cancelation Term", nil];
    arrAction = [[NSArray alloc]initWithObjects:@"",@"Check",@"Watch",@"See",@"View",@"View",@"Read", nil];
    
    // Do any additional setup after loading the view.
}
-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        clockTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(reloadTimerCell) userInfo:nil repeats:YES];
    [self updateToGoogleAnalytics:[NSString stringWithFormat:@"iPad Course Details Screen nid %@",self.NID]];

    
}
-(void)viewDidDisappear:(BOOL)animated{
    [clockTimer invalidate];
    clockTimer = nil;
}
-(void) dealloc {
    HCLog(@"dealloc");
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UIButton Action
-(IBAction)btnOpenShortLink:(UIButton*)sender{
    if (!_isStringEmpty(self.courseEntity.shorten_url)) {
        SFSafariViewController *vc = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:self.courseEntity.shorten_url]];
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    }
}
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];
}


-(IBAction)btnQRPopUp:(UIButton*)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CourseDetails_iPad" bundle:nil];
    QRScanPopVC *controller = [storyboard instantiateViewControllerWithIdentifier:@"QRScanPopVC"];
    controller.isFromCourseDetails = true;
    controller.courseObj = self.courseEntity;

    controller.preferredContentSize = CGSizeMake(500, 700);
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    [self configuraModalPopOver:sender controller:controller];
}

-(IBAction)btnSuibleInfo:(UIButton*)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CourseDetails_iPad" bundle:nil];
    SuitablePopVC *controller = [storyboard instantiateViewControllerWithIdentifier:@"SuitablePopVC"];
    
    controller.preferredContentSize = CGSizeMake(500, 500);
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    [self configuraModalPopOver:sender controller:controller];
}

-(IBAction)btnOpenAgeInfoPopUp:(UIButton*)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CourseDetails_iPad" bundle:nil];
    AgeInfoPopVC *controller = [storyboard instantiateViewControllerWithIdentifier:@"AgeInfoPopVC"];
    controller.preferredContentSize = CGSizeMake(500, 700);
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    [self configuraModalPopOver:sender controller:controller];
}

-(IBAction)btnOpenAmenities:(UIButton*)sender {
    AmenitiesVC *vc = [getStoryBoardDeviceBased(StoryboardCourseDetails) instantiateViewControllerWithIdentifier:@"AmenitiesVC"];
    vc.arrAmenities = self.courseEntity.amenities;
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:vc];
    [popover presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];

}
-(IBAction)btnVideoScroll:(UIButton*)sender{
    CourseDetailsCell *cell = [tableview dequeueReusableCellWithIdentifier:@"Cell11" forIndexPath:[NSIndexPath indexPathForRow:10 inSection:0]];
    
    cell.controllerDetails = self;
    [cell.cvVideo reloadData];
    NSInteger currentIndex = [cell.cvVideo indexPathForCell:[cell.cvVideo visibleCells].firstObject].row;
    if (sender.tag == 92 && self.courseEntity.youtube_video > 0 && currentIndex != 0) {
        //Pre
        [cell.cvVideo setContentOffset:CGPointMake((currentIndex - 1)*cell.cvVideo.frame.size.width, 0) animated:YES];
        /*[cell.cvVideo scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:currentIndex-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];*/
        
    }else if(sender.tag == 93 && currentIndex < self.courseEntity.youtube_video.count -1) {
        //Nect
        [cell.cvVideo setContentOffset:CGPointMake((currentIndex+1)*cell.cvVideo.frame.size.width, 0) animated:YES];
        
        /*[cell.cvVideo scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:currentIndex+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:true];*/
        
    }
    //[self.tableview reloadData];
    
    
}
#pragma mark - Other Methods
-(void) initData{
    tableview.estimatedRowHeight = 350;
    tableview.rowHeight = UITableViewAutomaticDimension;
    selectedProduct = 0;
    btnSendMessage.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    // you probably want to center it
    btnSendMessage.titleLabel.textAlignment = NSTextAlignmentCenter; // if you want to
    btnSendMessage.titleLabel.numberOfLines = 0;
    [btnSendMessage setTitle: @"Send Message to Tutor" forState: UIControlStateNormal];
    arrReviews = [NSMutableArray new];
}

-(IBAction)onCourseMapOpen:(UIButton*)sender {
    [AppUtils actionWithMessage:kAppName withMessage:@"Do you want to open course on map?" alertType:UIAlertControllerStyleAlert button:@[@"YES"] controller:self block:^(NSString *tapped) {
        if ([tapped isEqualToString:@"YES"]) {
            [self performSegueWithIdentifier:@"segueMap" sender:self];
        }
    }];
}

-(IBAction)btnReadMoreDesc:(UIButton*)sender {
    if (sender.selected) {
        sender.selected = false;
        if (sender.tag == 555) {
            if (self.courseEntity.youtube_video.count > 1){
                NSIndexPath *index = [NSIndexPath indexPathForRow:10 inSection:0];
                CourseDetailsCell *cell = [self.tableview cellForRowAtIndexPath:index];
//                cell._videoHeight.constant = 140;
            }
        }
    }else{
        sender.selected = true;
        if (sender.tag == 555) {
            if (self.courseEntity.youtube_video.count > 1){
                NSIndexPath *index = [NSIndexPath indexPathForRow:10 inSection:0];
                CourseDetailsCell *cell = [self.tableview cellForRowAtIndexPath:index];
//                cell._videoHeight.constant = (self.courseEntity.youtube_video.count * 140);
            }
        }
    }
    
    [self.tableview reloadData];
}
-(IBAction)btnOpenCancellationTerm:(UIButton*)sender{
    [self performSegueWithIdentifier:@"segueCancel" sender:self];

}
- (IBAction)onBuy:(id)sender {
}
#pragma mark - Spam Api
- (IBAction)btnSpamAction:(UIButton*)sender
{
    NSString *str;
    NSString *str_flag;
    if ([self.courseEntity.spam_flag_flagged.uppercaseString isEqualToString:@"NO"])
    {
        str = @"Hang on to that horse… Do you want to clear this course as NOT spam?";
        str_flag = @"flag";
    }else{
        str = @"Hang on to that horse… Do you want to clear this course as NOT spam?";
        str_flag = @"unflag";
    }
    [AppUtils actionWithMessage:kAppName withMessage:str alertType:UIAlertControllerStyleAlert button:@[@"YES"] controller:self block:^(NSString *tapped) {
        if ([tapped isEqualToString:@"YES"]) {
            NSDictionary *dict =@{@"action":str_flag, @"flag_name":@"spam_flag_on_courses", @"entity_id":self.NID
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
                                    int count = [self.courseEntity.spam_flag_counter intValue] + 1;
                                    self.courseEntity.spam_flag_counter = [NSString stringWithFormat:@"%d",count];
                                    self.courseEntity.spam_flag_flagged = @"YES";
                                }else{
                                    int count = [self.courseEntity.spam_flag_counter intValue] - 1;
                                    self.courseEntity.spam_flag_counter = [NSString stringWithFormat:@"%d",count];
                                    self.courseEntity.spam_flag_flagged = @"NO";
                                }
                            }
                            
                        }
                    }
                    
                }else{
                    showAletViewWithMessage(@"Let’s give that another go...An error occurred with your spam request");
                }
                [tableview reloadData];
            }];
        }
    }];
}
#pragma mark - Fav Api
- (IBAction)btnFavUnFav:(UIButton*)sender
{
    NSString *action;
    if (sender.selected) {
        action = @"unflag";
    }else {
        action =@"flag";
    }
    NSDictionary *dict =@{@"action":action, @"flag_name":@"favorite_flag_on_courses", @"entity_id":self.NID};
    [self startActivity];
    [[NetworkManager sharedInstance] postRequestUrl:apifavFlagUrl paramter:dict withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        if (result == WebServiceResultSuccess) {
            if ([jsonData isKindOfClass:[NSArray class]]) {
                NSArray *arr = jsonData;
                if (arr && arr.count) {
                    BOOL flag = arr[0];
                    if (flag) {
                        if(btnFav.selected) {
                            btnFav.selected =false;
                        }else{
                            btnFav.selected =true;
                        }
                    }
                }
            }
        }
        [tableview reloadData];
    }];
    
}

#pragma mark - API
-(void) getCourseDetails:(NSString *) courseNID
{
    self.tableview.hidden = true;
    if (![self isNetAvailable]) {
        NSData *data = [UserDefault objectForKey:courseNID];
        if (data) {
            NSDictionary *jsonData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [self parseCourseDetails:jsonData nid:courseNID];
        } else {
            [self.navigationController popViewControllerAnimated:true];
        }
        self.tableview.hidden = false;
    }else{
        [self startActivity];
        [[NetworkManager sharedInstance] getRequestUrl:[NSString stringWithFormat:@"%@%@",apiCourseDetailUrl,courseNID] paramter:nil isToken:NO withCallback:^(id jsonData, WebServiceResult result) {
            [self stopActivity];
            if (result == WebServiceResultSuccess) {
                if ([jsonData isKindOfClass:[NSDictionary class]]) {
                    if (jsonData) {
                        [UserDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:jsonData] forKey:courseNID];
                        [UserDefault synchronize];
                    }
                    
                }
                [self parseCourseDetails:jsonData nid:courseNID];
            } else {
                showAletViewWithMessage(kFailAPI);
                [self.navigationController popToRootViewControllerAnimated:true];
            }
            self.tableview.hidden = false;
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
        self.courseEntity.certifications = [self.courseEntity.certifications stringByReplacingOccurrencesOfString:@"," withString:@"\n ->"];
        if (self.courseEntity.favorite_flag_flagged && [self.courseEntity.favorite_flag_flagged.uppercaseString isEqualToString:@"YES"]) {
            btnFav.selected = YES;
        }else{
            btnFav.selected = NO;
        }
        [tableview reloadData];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"batch_start_date >= %@", [NSDate date]];
        ProductEntity *pro =  self.courseEntity.productArr[selectedProduct];
        NSArray *arr = [pro.timingsDate filteredArrayUsingPredicate:predicate];
        if (arr.count > 0) {
            HCLog(@"%@",arr[0]);
            TimeBatch *timeObj = arr[0];
            timerDate = timeObj.batch_start_date;
        }
        [self getCommentsData:self.NID];
        
    }
}
-(void) reloadTimerCell{
    if (self.courseEntity) {
        UITableViewCell *cell = [tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        [self updateCellTimer:cell];

//        [tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}
-(void) updateCellTimer:(UITableViewCell*) cell {
    UIView *viewTimer = [cell viewWithTag:42];
    viewTimer.layer.cornerRadius = 10;
    viewTimer.layer.borderColor = __THEME_COLOR.CGColor;
    viewTimer.layer.borderWidth = 1;
    viewTimer.layer.masksToBounds = YES;
    [cell.layer setZPosition:10];
    
    UILabel *lbl = [cell viewWithTag:41];
    if (timerDate) {
        NSTimeInterval seconds = [timerDate timeIntervalSinceNow];
        int days           = floor(seconds/24/60/60);
        int hoursLeft   = floor((seconds) - (days*86400));
        int hours           = floor(hoursLeft/3600);
        int minutesLeft = floor((hoursLeft) - (hours*3600));
        int minutes         = floor(minutesLeft/60);
        
        NSInteger tt = (NSInteger) seconds;
        lbl.text = [NSString stringWithFormat:@"%dD : %dH : %dM : %ldS",days,hours,minutes,(tt % 60)];
    }else{
        lbl.text = @"Sold Out";
    }
}

#pragma mark - Review API API
-(void) getCommentsData:(NSString*) nid
{
    if (![self isNetAvailable]) {
        NSData *data = [UserDefault objectForKey:[self uniqueCommentId:nid]];
        if (data) {
            NSDictionary *jsonData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [self parseComment:jsonData nid:nid];
        }
    }else{
        
        [[NetworkManager sharedInstance] getRequestUrl:[NSString stringWithFormat:@"%@%@?page=%@",apiCommentURL,nid,[NSString stringWithFormat:@"%d",1]] paramter:nil isToken:true withCallback:^(id jsonData, WebServiceResult result) {
            if (result == WebServiceResultSuccess) {
                [self parseComment:jsonData nid:nid];
            }
        }];
    }
}
-(NSString*) uniqueCommentId:(NSString*) nid {
    return [NSString stringWithFormat:@"cc%@",nid];
}
-(void) parseComment:(id) jsonData nid:(NSString *) nid {
    if ([jsonData isKindOfClass:[NSDictionary class]]) {
        if ([jsonData valueForKey:@"nodes"]) {
            NSArray *arrData = [jsonData valueForKey:@"nodes"];
            if (arrData && arrData.count>0) {
                [arrReviews removeAllObjects];
                for(NSDictionary *dict in arrData) {
                    if ([dict valueForKey:@"node"]) {
                        Review *obj = [[Review alloc]initWith:[dict valueForKey:@"node"]];
                        [arrReviews addObject:obj];
                    }
                }
                [tableview reloadData];
            }
        }
    }
}

#pragma mark - UITableDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 13;//16;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 450 * _widthRatioIPAD;
    }else if (indexPath.row == 1) {
        return 135 * _widthRatioIPAD;
    }else if (indexPath.row == 7){
        if (self.courseEntity.youtube_video.count ==0) {
            return 50;
        }
        return 270;
    }else if (indexPath.row == 8 && self.courseEntity) {
        if (self.courseEntity.comment_count == nil || [self.courseEntity.comment_count isEqualToString:@"0"]) {
            return 0;
        }
    }else if (indexPath.row == 12) {
        return (self.similerCourses.count > 0) ? 450 * _widthRatioIPAD: 0;
    }
    return UITableViewAutomaticDimension;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%ld",indexPath.row+1];
    
    ProductEntity *produt =  self.courseEntity.productArr[selectedProduct];
    switch (indexPath.row) {
        case 0:
        {
            CourseListingCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.controllerDetails = self;
            [cell.cvDetails reloadData];
            cell.lblTitle.text = self.courseEntity.title;
            cell.lblPrice.text = produt.initial_price;
            cell.lblReviewCount.text = self.courseEntity.comment_count;
            cell.lblCity.text = self.courseEntity.city;
            cell.btnFav.selected = btnFav.selected;
            UIImageView *imgVStar = [cell viewWithTag:222];
            UIImageView *imgVAuther = [cell viewWithTag:301];
            [imgVAuther sd_setImageWithURL:[NSURL URLWithString:self.courseEntity.author_image] placeholderImage:_placeHolderImg];

            imgVStar.image = [UIImage imageNamed:[NSString stringWithFormat:@"star%@",self.courseEntity.course_rating]];
            cell.lblPeopleSaved.text = [NSString stringWithFormat:@"%@ People Saved this",self.courseEntity.people_saved_course];
            cell.lblSutableFor.text = (_isStringEmpty(self.courseEntity.suitable_for)) ? @"Both" : self.courseEntity.suitable_for;
            return cell;
        }
        case 1:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            UILabel *lblTime = [cell viewWithTag:11];
            UILabel *lblAgeGroup = [cell viewWithTag:12];
            UILabel *lblWeekDay = [cell viewWithTag:13];
            UILabel *lblCity = [cell viewWithTag:14];
            UILabel *lblSutableFor = [cell viewWithTag:15];
            UILabel *lblReviewCount = [cell viewWithTag:16];
            UIImageView *imgVStar = [cell viewWithTag:17];
            
            lblReviewCount.text = self.courseEntity.comment_count;
            imgVStar.image = [UIImage imageNamed:[NSString stringWithFormat:@"star%@",self.courseEntity.course_rating]];
            lblSutableFor.text = (_isStringEmpty(self.courseEntity.suitable_for)) ? @"Both" : self.courseEntity.suitable_for;
            
            
            lblTime.text =  produt.batch_size; //getTime(self.courseEntity);
            lblWeekDay.text =  getDays(self.courseEntity);
            lblAgeGroup.text = _courseEntity.age_group ;
            lblCity.text = self.courseEntity.city;
            
            return cell;
        }
            
        case 2:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            UIButton *btnContactEducator = [cell viewWithTag:11];
            btnContactEducator.layer.cornerRadius = 8;
            UILabel *lblTrial = [cell viewWithTag:12];
            UILabel *lblTutor = [cell viewWithTag:13];
            UILabel *lblLand = [cell viewWithTag:14];
            UILabel *lblMobile = [cell viewWithTag:15];
            UILabel *lblDesc = [cell viewWithTag:41];
            
            
            lblDesc.text = self.courseEntity.short_description.removeHTML;
            
            lblTrial.text = [NSString stringWithFormat:@"%@",self.courseEntity.field_trial_class];
            lblTutor.text = [NSString stringWithFormat:@"%@",self.courseEntity.author];
            if (!_isStringEmpty(self.courseEntity.landLine_number) && self.courseEntity.landLine_number.length > 6) {
                NSString * first3 = [self.courseEntity.landLine_number substringWithRange:NSMakeRange(0, 3)];
                NSString * last3 = [self.courseEntity.landLine_number substringWithRange:NSMakeRange(0, 3)];
                lblLand.text = [NSString stringWithFormat:@"%@*%@",first3,last3];
            }else{
                lblLand.text = [NSString stringWithFormat:@"%@",self.courseEntity.landLine_number];
            }
            if (!_isStringEmpty(self.courseEntity.mobile) && self.courseEntity.mobile.length > 6) {
                NSString * first3 = [self.courseEntity.mobile substringWithRange:NSMakeRange(0, 3)];
                NSString * last3 = [self.courseEntity.mobile substringWithRange:NSMakeRange(0, 3)];
                lblMobile.text = [NSString stringWithFormat:@"%@*%@",first3,last3];
            }else{
                lblMobile.text = [NSString stringWithFormat:@"%@",self.courseEntity.mobile];
            }
            
            return cell;
        }
        case 3:
        {
            CourseDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.controllerDetails = self;
            [cell.cvAmenities reloadData];
            
            NSString *staticMapUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/staticmap?markers=color:red|%@,%@&%@&sensor=true",self.courseEntity.latitude,self.courseEntity.longitude,@"zoom=15&size=450x300"];
            NSString * newStringURL = [staticMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            UIImageView *imgV = [cell viewWithTag:11];
            [imgV sd_setImageWithURL:[NSURL URLWithString:newStringURL] placeholderImage:_placeHolderImg];

            [self updateCellTimer:cell];
            return cell;
        }
        case 4:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            UILabel *lblReq = [cell viewWithTag:91];
            lblReq.text = [NSString stringWithFormat:@"->%@",self.courseEntity.certifications];
            
            UILabel *lblCancellation = [cell viewWithTag:92];
            UILabel *lblCancellationDays = [cell viewWithTag:93];
            if (!_isStringEmpty(self.courseEntity.cancellation_type)) {
                if ([self.courseEntity.cancellation_type.lowercaseString isEqualToString:@"open"]) {
                    lblCancellationDays.text = @"2 Days";
                }else if ([self.courseEntity.cancellation_type.lowercaseString isEqualToString:@"mild"]) {
                    lblCancellationDays.text = @"7 Days";
                }
                else if ([self.courseEntity.cancellation_type.lowercaseString isEqualToString:@"rigid"]) {
                    lblCancellationDays.text = @"15 Days";
                }
                else if ([self.courseEntity.cancellation_type.lowercaseString isEqualToString:@"firm"]) {
                    lblCancellationDays.text = @"30 Days";
                }else{
                    lblCancellationDays.text = @"";
                }
            }else{
                lblCancellationDays.text = @"";
            }
            lblCancellation.text = (_isStringEmpty(self.courseEntity.cancellation_type)) ? @"--" : self.courseEntity.cancellation_type;
            return cell;
        }
            
        case 5:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            UILabel *lblReq = [cell viewWithTag:61];
            lblReq.text = [NSString stringWithFormat:@"%@",self.courseEntity.Description.removeHTML];
            UIButton *btnMore = [cell viewWithTag:62];
            
            if (btnMore.selected) {
                lblReq.numberOfLines = 0;
            }else{
                lblReq.numberOfLines = 5;
            }
            return cell;
        }
        case 6:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            UILabel *lblReq = [cell viewWithTag:61];
            lblReq.text = [NSString stringWithFormat:@"%@",self.courseEntity.course_requirements.removeHTML];
            UIButton *btnMore = [cell viewWithTag:62];
            
            if (btnMore.selected) {
                lblReq.numberOfLines = 0;
            }else{
                lblReq.numberOfLines = 3;
            }
            return cell;
        }
            
        case 7:{
            CourseDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            UILabel *lblLink = [cell viewWithTag:91];
            UIButton *btnPre = [cell viewWithTag:92];
            UIButton *btnNext = [cell viewWithTag:93];
            lblLink.text = self.courseEntity.shorten_url;
            cell.controllerDetails = self;
            [cell.cvVideo reloadData];
            cell.cvVideo.backgroundColor = [UIColor clearColor];
            if(self.courseEntity.youtube_video.count == 1){
                btnPre.hidden = true;
                btnNext.hidden = true;
            }else{
                btnPre.hidden = false;
                btnNext.hidden = false;
            }
            
            return cell;
        }
       
            
        case 8:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            UILabel *lblReviewCount = [cell viewWithTag:71];
            UIImageView *imgV = [cell viewWithTag:72];
            UILabel *lblReviewerName = [cell viewWithTag:73];
            UILabel *lblTime = [cell viewWithTag:74];
            UILabel *lblComment = [cell viewWithTag:75];
            UIButton *btnReview = [cell viewWithTag:76];
            btnReview.layer.cornerRadius = 8;
            lblReviewCount.text = [NSString stringWithFormat:@"%@ Reviews",self.courseEntity.comment_count];
            UIView *reviewView1 = [cell viewWithTag:311];
            UIView *reviewView2 = [cell viewWithTag:312];
            reviewView1.hidden = true;
            reviewView2.hidden = true;
            if (arrReviews.count>0) {
                reviewView1.hidden = false;
                lblComment.text = arrReviews[0].comment;
                lblTime.text = arrReviews[0].post_date;
                lblReviewerName.text = arrReviews[0].author;
                [imgV sd_setImageWithURL:[NSURL URLWithString:arrReviews[0].avatar] placeholderImage:_placeHolderImg];
            }
            if(arrReviews.count > 1){
                UIImageView *imgV = [cell viewWithTag:721];
                UILabel *lblReviewerName = [cell viewWithTag:731];
                UILabel *lblTime = [cell viewWithTag:741];
                UILabel *lblComment = [cell viewWithTag:751];
                reviewView2.hidden = false;
                
                lblComment.text = arrReviews[1].comment;
                lblTime.text = arrReviews[1].post_date;
                lblReviewerName.text = arrReviews[1].author;
                [imgV sd_setImageWithURL:[NSURL URLWithString:arrReviews[1].avatar] placeholderImage:_placeHolderImg];
            }
            return cell;
        }
        case 9:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            return cell;
        }
        case 10:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            UIImageView *imgV = [cell viewWithTag:131];
            UILabel *lblTutorName = [cell viewWithTag:132];
            UILabel *lblTutorStatus = [cell viewWithTag:133];
            UIImageView *imgV1 = [cell viewWithTag:135];
            UIImageView *imgV2 = [cell viewWithTag:136];
            UIImageView *imgV3 = [cell viewWithTag:137];
            UIImageView *imgV4 = [cell viewWithTag:138];
            UIImageView *imgV5 = [cell viewWithTag:139];
            UIImageView *imgV6 = [cell viewWithTag:140];
            UILabel *lblReviewCount= [cell viewWithTag:141];
            UIButton *btnOurTutor= [cell viewWithTag:142];
            UIButton *btnOurLocation= [cell viewWithTag:143];
            UIButton *btnOtherCourse= [cell viewWithTag:144];
            UIButton *btnAllReview= [cell viewWithTag:145];
            UILabel *lblEducatorDesc= [cell viewWithTag:146];
            btnOurTutor.layer.cornerRadius = 8;
            btnOurLocation.layer.cornerRadius = 8;
            btnAllReview.layer.cornerRadius = 8;
            btnOtherCourse.layer.cornerRadius = 8;
            imgV.layer.cornerRadius = ((_screenSize.width * 0.6) * 0.3)/2;
            imgV.layer.masksToBounds = YES;

            [imgV sd_setImageWithURL:[NSURL URLWithString:self.courseEntity.author_image] placeholderImage:_placeHolderImg];
            lblTutorName.text = produt.tutor;
            lblEducatorDesc.text = self.courseEntity.educator_introduction;
            
            UIButton *btnMore = [cell viewWithTag:147];
            if (btnMore.selected) {
                lblEducatorDesc.numberOfLines = 0;
            }else{
                lblEducatorDesc.numberOfLines = 3;
            }
            lblReviewCount.text = self.courseEntity.vendor_review_count;
            
            if ([self.courseEntity.email_verified_flagged.uppercaseString isEqualToString:@"NO"]) {
                imgV1.image = [UIImage imageNamed:@"ic_c_red_tip"];
            }else{
                imgV1.image = [UIImage imageNamed:@"ic_d_white_right"];
            }
            if ([self.courseEntity.landline_verified_flagged.uppercaseString isEqualToString:@"NO"]) {
                imgV3.image = [UIImage imageNamed:@"ic_c_red_tip"];
            }else{
                imgV3.image = [UIImage imageNamed:@"ic_d_white_right"];
            }
            if ([self.courseEntity.address_verified_flagged.uppercaseString isEqualToString:@"NO"]) {
                imgV5.image = [UIImage imageNamed:@"ic_c_red_tip"];
            }else {
                imgV5.image = [UIImage imageNamed:@"ic_d_white_right"];
            }
            if ([self.courseEntity.mobile_verified_flagged.uppercaseString isEqualToString:@"NO"]) {
                imgV2.image = [UIImage imageNamed:@"ic_c_red_tip"];
                
            }else{
                imgV2.image = [UIImage imageNamed:@"ic_d_white_right"];
            }
            if ([self.courseEntity.social_media_verified_flagged.uppercaseString isEqualToString:@"NO"]) {
                imgV4.image = [UIImage imageNamed:@"ic_c_red_tip"];
            }else{
                imgV4.image = [UIImage imageNamed:@"ic_d_white_right"];
            }
            if ([self.courseEntity.credit_card_verified_flagged.uppercaseString isEqualToString:@"NO"]) {
                imgV6.image = [UIImage imageNamed:@"ic_c_red_tip"];
            }else{
                imgV6.image = [UIImage imageNamed:@"ic_d_white_right"];
            }
            UILabel *lblUpdateOn = [cell viewWithTag:111];
            lblUpdateOn.text = self.courseEntity.last_updated;
            [cell.layer setZPosition:100];
            return cell;
        }
            
        case 11:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.backgroundColor = [UIColor lightGrayColor];
            return cell;
        }
            
        case 12:{
            CourseListingCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CellListing" forIndexPath:indexPath];
            cell.controllerDetails = self;
            [cell.cvSimilerListing reloadData];
            return cell;
        }
        case 14:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.backgroundColor = [UIColor clearColor];
            return cell;
            
        }
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (indexPath.row == 3) {
            [self performSegueWithIdentifier:@"segueMap" sender:self];
            
        }else if (indexPath.row == 8) {
            [self performSegueWithIdentifier:@"segueReviews" sender:self];
        }
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > (180 * _widthRatio)) {
        viewTop.alpha = 1.0;
    }else{
        viewTop.alpha = 0.0;
    }
}


#pragma mark - Navigation
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender{
    if ([identifier isEqualToString:@"GoToWriteReview"] && [self.courseEntity.if_bought.uppercaseString isEqualToString:@"NO"]) {
        showAletViewWithMessage(@"You can only review a course you have bought");
        return false;
    }
    return true;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"GoToCommentList"]){
        CommentListVC *vc = segue.destinationViewController;
        vc.nidComment = self.courseEntity.author_uid;
        vc.courseTittle = self.courseEntity.title;
        vc.isAllReview = true;
    }else if([segue.identifier isEqualToString:@"GoToVendor"]) {
        VendorViewController *vc = segue.destinationViewController;
        vc.verndorID = self.courseEntity.author_uid;
        vc.verndorName = self.courseEntity.author;
    }else if ([segue.identifier isEqualToString:@"GoToWriteReview"]){
        WriteReviewViewController *postReviewController = segue.destinationViewController;
        postReviewController.isEditMode = NO;
        postReviewController.NID = self.courseEntity.nid;
        postReviewController.courseTittle = self.courseEntity.title;
        [postReviewController getRefreshBlock:^(NSString *anyValue) {
            [self getCommentsData:self.courseEntity.nid];
        }];
    }else if ([segue.identifier isEqualToString:@"segueMap"]){
        CourseLocationViewController * vc = segue.destinationViewController;
        vc.isFromDetail = true;
        vc.selectedCourse = self.courseEntity;
    }else if ([segue.identifier isEqualToString:@"GoToMessage"]){
        if (is_iPad()){
            MessagesViewController *view = segue.destinationViewController;
            view.isNewthread = true;
            view.couseEntity = self.courseEntity;
            view.isBackArrow = true;
        }else{
            ConversationViewController *view = segue.destinationViewController;
            view.isNewthread = true;
            view.couseEntity = self.courseEntity;
        }
    }else if ([segue.identifier isEqualToString:@"segueBatches"]){
        CourseDetailBatchVC *vc = segue.destinationViewController;
        vc.arrBatches = self.courseEntity.productArr;
        vc.courseEntity = self.courseEntity;
        vc.selectedBatch =selectedProduct;
        [vc getRefreshBlock:^(NSString *anyValue) {
            selectedProduct = [anyValue intValue];
            [tblParent reloadData];
        }];
    }else if ([segue.identifier isEqualToString:@"segueReviews"]){
//        CourseReviewVC *vc =segue.destinationViewController;
//        vc.nid = self.NID;
        CommentListVC *vc = segue.destinationViewController;
        vc.nid = self.courseEntity.nid;
        vc.courseTittle = self.courseEntity.title;
        vc.isCourseAllReview = true;
        
    }else if ([segue.identifier isEqualToString:@"segueShare"]){
        CourseShareVC *vc =segue.destinationViewController;
        vc.courseEntity = self.courseEntity;
    }else if ([segue.identifier isEqualToString:@"segueVendor"]){
        VendorProfileVC *vc = segue.destinationViewController;
        vc.courseEntity = self.courseEntity;
    }else if ([segue.identifier isEqualToString:@"segueCancel"]){
        CancellationVC *vc = segue.destinationViewController;
        vc.terms = self.courseEntity.cancellation_type;
    }else if ([segue.identifier isEqualToString:@"toTutor"]){
        TutorListVC_iPad *vc = segue.destinationViewController;
        vc.courseEntity = self.courseEntity;
    }else if ([segue.identifier isEqualToString:@"toVenue"]){
        VenueListVC_iPad *vc = segue.destinationViewController;
        vc.courseEntity = self.courseEntity;
    }else if([segue.destinationViewController isKindOfClass:[QRScanPopVC class]]) {
        QRScanPopVC *vc = segue.destinationViewController;
        vc.isFromCourseDetails = true;
        vc.courseObj = self.courseEntity;
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
