//
//  CourseDetailsVC.m
//  AirbnbClone
//
//  Created by iOS Dev on 25/08/16.
//  Copyright © 2016 iOS Dev. All rights reserved.
//

#import "CourseDetailsVC.h"

@interface CourseDetailsVC () {
    Review *firstReview;
    NSArray * arrCaption,*arrAction;
    int selectedProduct;
    NSTimer *clockTimer,*scrollTimer;
    NSDate *timerDate;
    NSArray *arrAgeTitle,*cellIdf;
    NSInteger currentItem;

    NSDictionary *attributesText,*attributesReadmore;
}
@end

@implementation CourseDetailsVC
@synthesize tableview,isDescSize;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainImageView.hidden = true;
    self.mainImageView.image = [UIImage imageWithData:self.imgVSource];
    [self initData];
    [self getCommentsData:self.NID];
    [self getCourseDetails:self.NID];
    arrCaption = [[NSArray alloc]initWithObjects:@"",@"Course Batches",@"Course Videos",@"Certification",@"Verified ID's",@"Amenities",@"Cancelation Term", nil];
    arrAction = [[NSArray alloc]initWithObjects:@"",@"Check",@"Watch",@"See",@"View",@"View",@"Read", nil];
    arrAgeTitle = [[NSArray alloc] initWithObjects:@"Don't care",@"Any Age",@"Adults",@"A Level",@"GCSE",@"Secondary school",@"Primary school",@"Preschool", nil];
    
    btnAvailability.layer.cornerRadius = 8;
    btnAvailability.layer.masksToBounds = YES;
    
    cellIdf = @[@[@"cellImages", @"cellPlaceAge", @"cellTimer", @"cellAbout", @"cellHost", @"cellContact", @"cellAmenities", @"cellDesc", @"cellReq",],@[@"cellCertificate"], @[@"cellCancellation", @"cellVideo", @"cellLink", @"cellReviews", @"cellWriteReview",@"cellTutor"], @[@"cellButton"],@[@"cellMsg", @"cellMap",
                                                                                                                                                                                                                                                                                                     @"CellListing"]];
    
    UIFont *font = [UIFont hcOpenSansRegularWithSize:(21 * _widthRatio)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:2];
    attributesText = @{NSFontAttributeName:font,
                                 NSForegroundColorAttributeName:[UIColor darkGrayColor],
                                 NSBackgroundColorAttributeName:[UIColor clearColor],
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 };
    
    attributesReadmore = @{NSFontAttributeName:font,
                       NSForegroundColorAttributeName:ThemEColor,
                       NSBackgroundColorAttributeName:[UIColor clearColor],
                       NSParagraphStyleAttributeName:paragraphStyle,
                       };
    // Do any additional setup after loading the view.
}
-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    clockTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(reloadTimerCell) userInfo:nil repeats:YES];
    scrollTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(scrollImages) userInfo:nil repeats:YES];

    [self updateToGoogleAnalytics:[NSString stringWithFormat:@"Course Details Screen nid %@",self.NID]];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [scrollTimer invalidate];
    scrollTimer = nil;
    [clockTimer invalidate];
    clockTimer = nil;
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
#pragma mark - UIButton Action
-(IBAction)btnBackNav:(id)sender {
    self.mainImageView.hidden = false;
    [self.navigationController popViewControllerAnimated:true];
}

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
#pragma mark - Other Methods
-(void) initData{
    tableview.estimatedRowHeight = 50;
    tableview.rowHeight = UITableViewAutomaticDimension;
    selectedProduct = 0;
    btnSendMessage.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    // you probably want to center it
    btnSendMessage.titleLabel.textAlignment = NSTextAlignmentCenter; // if you want to
    btnSendMessage.titleLabel.numberOfLines = 0;
    [btnSendMessage setTitle: @"Send Message to Tutor" forState: UIControlStateNormal];
    isDescSize = 110;
    currentItem = 0;
}

-(IBAction)onCourseMapOpen:(UIButton*)sender {
    [AppUtils actionWithMessage:kAppName withMessage:@"Do you want to open course on map?" alertType:UIAlertControllerStyleAlert button:@[@"YES"] controller:self block:^(NSString *tapped) {
        if ([tapped isEqualToString:@"YES"]) {
            [self performSegueWithIdentifier:@"segueMap" sender:self];
        }
    }];
}
- (NSUInteger)fitString:(NSString *)string intoLabel:(UILabel *)label
{
    UIFont *font           = label.font;
    NSLineBreakMode mode   = label.lineBreakMode;
    
    CGFloat labelWidth     = label.frame.size.width;
    CGFloat labelHeight    = label.frame.size.height;
    CGSize  sizeConstraint = CGSizeMake(labelWidth, CGFLOAT_MAX);
    
        NSDictionary *attributes = @{ NSFontAttributeName : font };
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:string attributes:attributes];
        CGRect boundingRect = [attributedText boundingRectWithSize:sizeConstraint options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        {
            if (boundingRect.size.height > labelHeight)
            {
                NSUInteger index = 0;
                NSUInteger prev;
                NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
                
                do
                {
                    prev = index;
                    if (mode == NSLineBreakByCharWrapping)
                        index++;
                    else
                        index = [string rangeOfCharacterFromSet:characterSet options:0 range:NSMakeRange(index + 1, [string length] - index - 1)].location;
                }
                
                while (index != NSNotFound && index < [string length] && [[string substringToIndex:index] boundingRectWithSize:sizeConstraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height <= labelHeight);
                
                return prev;
            }
        }
    return [string length];
}


-(IBAction)btnReadMoreDesc:(UIButton*)sender {
    if (self.courseEntity.isFullTitle) {
        self.courseEntity.isFullTitle = false;
    }else{
        self.courseEntity.isFullTitle = true;
    }
    
    [self.tableview reloadData];
    [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:false];
    
}
-(IBAction)btnExplandLabel:(UIButton*)sender {
    NSIndexPath *indexPath;
    if(sender.tag == 97){
        indexPath = [NSIndexPath indexPathForRow:5 inSection:2];
    }else{
        indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    }
    ConstrainedTableViewCell *cell = [tableview cellForRowAtIndexPath:indexPath];
    ReadMoreTextView *readMore = [cell viewWithTag:1];
    readMore.shouldTrim = !readMore.shouldTrim;
    [tableview reloadData];

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
        self.courseEntity.certifications = [self.courseEntity.certifications stringByReplacingOccurrencesOfString:@"," withString:@"\n\n"];
        if (self.courseEntity.favorite_flag_flagged && [self.courseEntity.favorite_flag_flagged.uppercaseString isEqualToString:@"YES"]) {
            btnFav.selected = YES;
        }else{
            btnFav.selected = NO;
        }
        
        
        [tableview reloadData];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"batch_start_date >= %@", [NSDate date]];
        if (self.courseEntity.productArr.count > 0) {
            ProductEntity *pro =  self.courseEntity.productArr[selectedProduct];
            NSArray *arr = [pro.timingsDate filteredArrayUsingPredicate:predicate];
            if (arr.count > 0) {
                TimeBatch *timeObj = arr[0];
                timerDate = timeObj.batch_start_date;
            }
            lblPriceBottom.text = pro.initial_price;
            
        }else{
            showAletViewWithMessage(@"Strange No Batch found");
            [self.navigationController popViewControllerAnimated:true];
        }
        //Update Bottom view
        lblRateBottom.text = self.courseEntity.comment_count;
        imgVRate.image = [UIImage imageNamed:[NSString stringWithFormat:@"star%@",self.courseEntity.course_rating]];
        
        
        if (_isStringEmpty(self.courseEntity.latitude)) {
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            NSString *str = [NSString stringWithFormat:@"%@ %@ %@",self.courseEntity.address_1,self.courseEntity.city,self.courseEntity.postal_code];
            [geocoder geocodeAddressString:str completionHandler:^(NSArray* placemarks, NSError* error){
                for (CLPlacemark* aPlacemark in placemarks) {
                    // Process the placemark.
                    self.courseEntity.latitude = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.latitude];
                    self.courseEntity.longitude = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.longitude];
                    [tableview reloadData];
                }
            }];
            
        }
        
        [self getCommentsData:self.NID];
        
    }
}
-(void) scrollImages{
    if (self.courseEntity && self.courseEntity.field_deal_image.count > 1) {
        CourseListingCell *cell = [tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        if (currentItem < [cell.cvDetails numberOfItemsInSection:0]) {
            [cell.cvDetails scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:currentItem inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];
            currentItem += 1;
        }else{
            [cell.cvDetails scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
            currentItem = 0;
        }
    }
}


-(void) reloadTimerCell{
    if (self.courseEntity) {
        UITableViewCell *cell = [tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        [self updateCellTimer:cell];
    }
}
-(void) updateCellTimer:(UITableViewCell*) cell{
    UILabel *lblD = [cell viewWithTag:11];
    UILabel *lblH = [cell viewWithTag:12];
    UILabel *lblM = [cell viewWithTag:13];
    UILabel *lblS = [cell viewWithTag:14];
    lblD.layer.borderWidth = 1;
    lblD.layer.borderColor = [UIColor blackColor].CGColor;
    lblH.layer.borderWidth = 1;
    lblH.layer.borderColor = [UIColor blackColor].CGColor;
    lblM.layer.borderWidth = 1;
    lblM.layer.borderColor = [UIColor blackColor].CGColor;
    lblS.layer.borderWidth = 1;
    lblS.layer.borderColor = __THEME_COLOR.CGColor;
    lblD.hidden = false;
    lblH.hidden = false;
    lblM.hidden = false;
    lblS.hidden = false;
    
    if (timerDate) {
        NSTimeInterval seconds = [timerDate timeIntervalSinceNow];
        int days           = floor(seconds/24/60/60);
        int hoursLeft   = floor((seconds) - (days*86400));
        int hours           = floor(hoursLeft/3600);
        int minutesLeft = floor((hoursLeft) - (hours*3600));
        int minutes         = floor(minutesLeft/60);
        
        NSInteger tt = (NSInteger) seconds;
        lblD.text = [NSString stringWithFormat:@"%d D",days];
        lblH.text = [NSString stringWithFormat:@"%d H",hours];
        lblM.text = [NSString stringWithFormat:@"%d M",minutes];
        lblS.text = [NSString stringWithFormat:@"%ld S",(tt % 60)];
    }else{
        lblD.hidden = true;
        lblH.hidden = true;
        lblM.hidden = true;
        lblS.hidden = true;
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
                for(NSDictionary *dict in arrData) {
                    if ([dict valueForKey:@"node"]) {
                        firstReview = [[Review alloc]initWith:[dict valueForKey:@"node"]];
                        [tableview reloadData];
                    }
                }
            }
        }
    }
}

#pragma mark - UITableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.courseEntity == nil) {
        return 0;
    }
    if (self.courseEntity.productArr.count == 0) {
        return 0;
    }
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 9;
        case 1:
            return self.courseEntity.certificationsArr.count;
        case 2:
            return 6;
        case 3:
            return 5;
        case 4:
            return 3;
        default:
            return 0;
    }
    return cellIdf.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellImages"]) {
            return (self.courseEntity.isFullTitle) ? [self.courseEntity.title heightWithConstrainedWidth:(374 * _widthRatio) font:[UIFont hcOpenSansBoldWithSize:(36 * _widthRatio)]] +  (341 *_widthRatio) : 410 * _widthRatio;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellPlaceAge"]) {
            return 110 * _widthRatio;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellTimer"]) {
            return (timerDate) ? 200 * _widthRatio : 70 * _widthRatio;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellHost"]) {
            return 335 * _widthRatio;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellContact"]) {
            return 256 * _widthRatio;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellAmenities"]) {
            return (self.courseEntity.amenities.count > 0) ? 140 * _widthRatio : 0;
        }
    }else if (indexPath.section == 2){
        if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellCancellation"]) {
            return 75 * _widthRatio;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellVideo"]) {
            if (self.courseEntity.youtube_video.count == 0 ) {
                return 0;
            }else{
                return 200 * _widthRatio;
            }
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellLink"]) {
            return 55 * _widthRatio;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellReviews"]) {
            if (self.courseEntity.comment_count == nil || [self.courseEntity.comment_count isEqualToString:@"0"]) {
                return 0;
            }
        }
    }else if(indexPath.section == 3){
        return 45 * _widthRatio;
    }else if (indexPath.section == 4){
        if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"CellListing"]) {
            return (self.similerCourses.count == 0) ? 0 : 430 * _widthRatio;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellMap"]) {
            return 290 * _widthRatio;
        }
    }
    
    
    return UITableViewAutomaticDimension;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
    }else{
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
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier;
    
    ProductEntity *produt =  self.courseEntity.productArr[selectedProduct];
    if (indexPath.section == 0) {
        
        cellIdentifier = cellIdf[indexPath.section][indexPath.row];
        if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellImages"]) {
            
            CourseListingCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.controllerDetails = self;
            self.mainImageView.hidden = true;
            [cell.cvDetails reloadData];
            cell.lblTitle.text = self.courseEntity.title;
            cell.lblPrice.text = produt.initial_price;
            cell.lblReviewCount.text = self.courseEntity.comment_count;
            cell.lblCity.text = self.courseEntity.city;
            cell.btnFav.selected = btnFav.selected;
            UIImageView *imgVStar = [cell viewWithTag:222];
            imgVStar.image = [UIImage imageNamed:[NSString stringWithFormat:@"star%@",self.courseEntity.course_rating]];
            cell.lblPeopleSaved.text = [NSString stringWithFormat:@"%@ People Saved this",self.courseEntity.people_saved_course];
            cell.lblSutableFor.text = (_isStringEmpty(self.courseEntity.suitable_for)) ? @"Both" : self.courseEntity.suitable_for;
            return cell;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellPlaceAge"]) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            UILabel *lblTime = [cell viewWithTag:11];
            UILabel *lblAgeGroup = [cell viewWithTag:12];
            UIImageView *imgAgeGroup = [cell viewWithTag:112];

            UILabel *lblWeekDay = [cell viewWithTag:13];
            UILabel *lblCity = [cell viewWithTag:14];
            
            imgAgeGroup.image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_age_%@",self.courseEntity.age_groupIndex]];
            lblTime.text =  produt.batch_size;
            lblWeekDay.text =  getDays(self.courseEntity);
            lblAgeGroup.text = self.courseEntity.age_group;
            lblCity.text = self.courseEntity.city;
            return cell;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellTimer"]) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            [self updateCellTimer:cell];
            return cell;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellAbout"]) {
            ConstrainedTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            ReadMoreTextView *lblDesc = [cell viewWithTag:1];
            lblDesc.attributedReadMoreText = [[NSMutableAttributedString alloc] initWithString:@"... Read more" attributes:attributesReadmore];
            lblDesc.attributedReadLessText = [[NSMutableAttributedString alloc] initWithString:@" Read less" attributes:attributesReadmore];;

            lblDesc.attributedText = [[NSAttributedString alloc]initWithString:self.courseEntity.short_description.removeHTML attributes:attributesText];
            [lblDesc setNeedsUpdateTrim];
            [lblDesc layoutIfNeeded];
            return cell;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellHost"]) {
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
            
            btnOurTutor.layer.cornerRadius = 8;
            btnOurLocation.layer.cornerRadius = 8;
            btnAllReview.layer.cornerRadius = 8;
            btnOtherCourse.layer.cornerRadius = 8;
            imgV.layer.cornerRadius = (60 * _widthRatio)/2;
            imgV.layer.masksToBounds = true;
            [imgV sd_setImageWithURL:[NSURL URLWithString:self.courseEntity.author_image] placeholderImage:_placeHolderImg];
            
            [lblTutorName setAttributedText:@[@"Offered by ",self.courseEntity.author] attributes:@[@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName: [UIFont hcOpenSansRegularWithSize:21 * _widthRatio]},@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName: [UIFont hcOpenSansRegularWithSize:21 * _widthRatio]}]];
            lblTutorStatus.text = [NSString stringWithFormat:@"Member Since %@",self.courseEntity.member_since];
            lblReviewCount.text = self.courseEntity.vendor_review_count;
            
            if ([self.courseEntity.email_verified_flagged.uppercaseString isEqualToString:@"NO"]) {
                imgV1.image = [UIImage imageNamed:@"ic_wrong"];
            }else{
                imgV1.image = [UIImage imageNamed:@"ic_right"];
            }
            if ([self.courseEntity.landline_verified_flagged.uppercaseString isEqualToString:@"NO"]) {
                imgV3.image = [UIImage imageNamed:@"ic_wrong"];
            }else{
                imgV3.image = [UIImage imageNamed:@"ic_right"];
            }
            if ([self.courseEntity.address_verified_flagged.uppercaseString isEqualToString:@"NO"]) {
                imgV5.image = [UIImage imageNamed:@"ic_wrong"];
            }else {
                imgV5.image = [UIImage imageNamed:@"ic_right"];
            }
            if ([self.courseEntity.mobile_verified_flagged.uppercaseString isEqualToString:@"NO"]) {
                imgV2.image = [UIImage imageNamed:@"ic_wrong"];
                
            }else{
                imgV2.image = [UIImage imageNamed:@"ic_right"];
            }
            if ([self.courseEntity.social_media_verified_flagged.uppercaseString isEqualToString:@"NO"]) {
                imgV4.image = [UIImage imageNamed:@"ic_wrong"];
            }else{
                imgV4.image = [UIImage imageNamed:@"ic_right"];
            }
            if ([self.courseEntity.credit_card_verified_flagged.uppercaseString isEqualToString:@"NO"]) {
                imgV6.image = [UIImage imageNamed:@"ic_wrong"];
            }else{
                imgV6.image = [UIImage imageNamed:@"ic_right"];
            }
            
            return cell;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellContact"]) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            UIButton *btnContactEducator = [cell viewWithTag:11];
            btnContactEducator.layer.cornerRadius = 8;
            UILabel *lblTrial = [cell viewWithTag:12];
            UILabel *lblTutor = [cell viewWithTag:13];
            UILabel *lblLand = [cell viewWithTag:14];
            UILabel *lblMobile = [cell viewWithTag:15];
            
            lblTrial.text = [NSString stringWithFormat:@"%@",self.courseEntity.field_trial_class];
            lblTutor.text = [NSString stringWithFormat:@"%@",produt.tutor];
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
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellAmenities"]) {
            CourseDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.controllerDetails = self;
            [cell.cvAmenities reloadData];
            return cell;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellDesc"]) {
            ConstrainedTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            ReadMoreTextView *lblDesc = [cell viewWithTag:1];
            lblDesc.attributedReadMoreText = [[NSMutableAttributedString alloc] initWithString:@"... Read more" attributes:attributesReadmore];
            lblDesc.attributedReadLessText = [[NSMutableAttributedString alloc] initWithString:@" Read less" attributes:attributesReadmore];;

            lblDesc.attributedText = [[NSAttributedString alloc]initWithString:self.courseEntity.Description.removeHTML attributes:attributesText];

            [lblDesc setNeedsUpdateTrim];
            [lblDesc layoutIfNeeded];

            return cell;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellReq"]) {
            ConstrainedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

            ReadMoreTextView *lblDesc = [cell viewWithTag:1];
            lblDesc.attributedReadMoreText = [[NSMutableAttributedString alloc] initWithString:@"... Read more" attributes:attributesReadmore];
            lblDesc.attributedReadLessText = [[NSMutableAttributedString alloc] initWithString:@" Read less" attributes:attributesReadmore];;

            lblDesc.attributedText = [[NSAttributedString alloc]initWithString:self.courseEntity.course_requirements.removeHTML attributes:attributesText];

            [lblDesc setNeedsUpdateTrim];
            [lblDesc layoutIfNeeded];

            return cell;
        }
    }else if(indexPath.section == 1){
        cellIdentifier = @"cellCertificate";
        
        GenericTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.lblTitle.text = (indexPath.row == 0) ? @"Certificates" : @"";
        cell.lblSubTitle.text = [self.courseEntity.certificationsArr[indexPath.row] trimmedString];
        return cell;
    }else if(indexPath.section == 2) {
        cellIdentifier = cellIdf[indexPath.section][indexPath.row];
        
        if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellCancellation"]) {
            GenericTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.lblTitle.text = (_isStringEmpty(self.courseEntity.cancellation_type)) ? @"--" : self.courseEntity.cancellation_type;
            return cell;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellVideo"]) {
            CourseDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.controllerDetails = self;
            [cell.cvVideo reloadData];
            cell.cvVideo.backgroundColor = [UIColor clearColor];
            return cell;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellLink"]) {
            CourseDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            UILabel *lblLink = [cell viewWithTag:91];
            lblLink.text = self.courseEntity.shorten_url;
            return cell;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellReviews"]) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            UILabel *lblReviewCount = [cell viewWithTag:71];
            UIImageView *imgV = [cell viewWithTag:72];
            UILabel *lblReviewerName = [cell viewWithTag:73];
            UILabel *lblTime = [cell viewWithTag:74];
            UILabel *lblComment = [cell viewWithTag:75];
            UIButton *btnReview = [cell viewWithTag:76];
            btnReview.layer.cornerRadius = 8;
            lblReviewCount.text = [NSString stringWithFormat:@"%@ Reviews",self.courseEntity.comment_count];
            if (firstReview) {
                lblComment.text = firstReview.comment;
                lblTime.text = firstReview.post_date;
                lblReviewerName.text = firstReview.author;
                [imgV sd_setImageWithURL:[NSURL URLWithString:firstReview.avatar] placeholderImage:_placeHolderImg];
            }
            return cell;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellWriteReview"]) {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            return cell;
            
        } else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellTutor"]) {
            GenericTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            [cell layoutIfNeeded];
            ReadMoreTextView *lblDesc = [cell viewWithTag:1];
            lblDesc.attributedReadMoreText = [[NSMutableAttributedString alloc] initWithString:@"... Read more" attributes:attributesReadmore];
            lblDesc.attributedReadLessText = [[NSMutableAttributedString alloc] initWithString:@" Read less" attributes:attributesReadmore];;
            
            lblDesc.attributedText = [[NSAttributedString alloc]initWithString:self.courseEntity.educator_introduction attributes:attributesText];
            [lblDesc setNeedsUpdateTrim];
            [lblDesc layoutIfNeeded];
            return cell;
        }
    }else if(indexPath.section == 3){
        GenericTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellButton" forIndexPath:indexPath];
        if(indexPath.row == 0) {
            [cell.lblTitle setAttributedText:@[@"Reviews: ",self.courseEntity.vendor_review_count] attributes:@[@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName: [UIFont hcOpenSansRegularWithSize:17 * _widthRatio]},@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName: [UIFont hcOpenSansRegularWithSize:17 * _widthRatio]}]];
        }else if(indexPath.row == 1) {
            cell.lblTitle.text = @"Our tutors";
        }else if(indexPath.row == 2) {
            cell.lblTitle.text = @"Our locations";
        }else if(indexPath.row == 3) {
            cell.lblTitle.text = @"My other courses";
        }else if(indexPath.row == 4) {
            cell.lblTitle.text = @"All reviews";
        }
        return cell;
        
    }else {
        cellIdentifier = cellIdf[indexPath.section][indexPath.row];
        
        if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"CellListing"]) {
            CourseListingCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.controllerDetails = self;
            [cell.cvSimilerListing reloadData];
            return cell;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellMap"]) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            NSString *staticMapUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/staticmap?markers=color:red|%@,%@&%@&sensor=true",self.courseEntity.latitude,self.courseEntity.longitude,@"zoom=15&size=450x300"];
            NSString * newStringURL = [staticMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            UIImageView *imgV = [cell viewWithTag:11];
            [imgV sd_setImageWithURL:[NSURL URLWithString:newStringURL] placeholderImage:_placeHolderImg];
            return cell;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellMsg"]) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            UIButton *btnSendMsg = [cell viewWithTag:141];
            UILabel *lblUpdateOn = [cell viewWithTag:144];
            lblUpdateOn.text = self.courseEntity.last_updated;
            btnSendMsg.layer.cornerRadius = 8;
            return cell;
        }else {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            return cell;
            
        }
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    dispatch_async(dispatch_get_main_queue(), ^{
        if(indexPath.section == 0) {
            
            if(indexPath.row == 6){
                [self performSegueWithIdentifier:@"segueAmenities" sender:self];
            }else if (indexPath.row == 3 || indexPath.row == 7 || indexPath.row == 8){
                ConstrainedTableViewCell *cell = [tableview cellForRowAtIndexPath:indexPath];
                ReadMoreTextView *readMore = [cell viewWithTag:1];
                readMore.shouldTrim = !readMore.shouldTrim;
                [tableview reloadData];
            }else if(indexPath.row == 4){
                [self performSegueWithIdentifier:@"segueVendor" sender:self];
            }
        }else if(indexPath.section == 2){
            if(indexPath.row == 0){
                [self performSegueWithIdentifier:@"segueCancel" sender:self];
            }else if(indexPath.row == 3){
                [self performSegueWithIdentifier:@"segueReviews" sender:self];
            }
        }else if(indexPath.section == 3){
            if (indexPath.row == 1) {
                [self performSegueWithIdentifier:@"toTutor" sender:self];
            }else if (indexPath.row == 0) {
                [self performSegueWithIdentifier:@"segueReviews" sender:self];
            }else if(indexPath.row == 2){
                [self performSegueWithIdentifier:@"toVenue" sender:self];
            }else if(indexPath.row == 3){
                [self performSegueWithIdentifier:@"GoToVendor" sender:self];
            }else{
                [self performSegueWithIdentifier:@"GoToCommentList" sender:self];
            }
        }else if(indexPath.section == 4){
            if (indexPath.row ==1) {
                [self performSegueWithIdentifier:@"segueMap" sender:self];
            }
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
        CourseReviewVC *vc =segue.destinationViewController;
        vc.nid = self.NID;
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
        TutorListVC *vc = segue.destinationViewController;
        vc.isFromDetails = true;
        vc.courseEntity = self.courseEntity;
    }else if ([segue.identifier isEqualToString:@"toVenue"]){
        VenueListVC *vc = segue.destinationViewController;
        vc.isFromDetails = true;
        vc.courseEntity = self.courseEntity;
    }else if([segue.destinationViewController isKindOfClass:[AmenitiesVC class]]) {
        AmenitiesVC *vc = segue.destinationViewController;
        vc.arrAmenities = self.courseEntity.amenities;
    }else if([segue.destinationViewController isKindOfClass:[QRScanPopVC class]]) {
        QRScanPopVC *vc = segue.destinationViewController;
        vc.isFromCourseDetails = true;
        vc.courseObj = self.courseEntity;
    }
}


@end
