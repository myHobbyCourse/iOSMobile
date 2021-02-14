//
//  AdvanceSearchVC.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 28/06/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "AdvanceSearchVC.h"
#import "CourseTableViewCell.h"
#import "CourseLocationViewController.h"
@interface AdvanceSearchVC ()<CourseCVCellProtocol,CalenderPickerDelegate,PopDelegateProtocol>
{
    NSArray *arrFilter;
    int selectedIndex;
    NSTimer *timer;
    int refreshCount;
    BOOL isCommentClciked;
    NSArray *arrayCourseListData;
    int pageIndex;
    NSInteger selectedSortBy;
 
    NSMutableArray *arrSortBy;
    NSMutableArray *arrPriceBy;
    NSMutableArray *arrAgrBy;
    NSMutableArray *arrSessionBy;
    NSMutableArray *arrBatchBy;
    
    IBOutlet UITextField *lblSortBy;
    IBOutlet UITextField *lblAgeBy;
    IBOutlet UITextField *lblPriceBy;
    IBOutlet UITextField *lblBatchBy;
    IBOutlet UITextField *lblSessionBy;
    BOOL isContinueFirstPage;

    
}
@end

@implementation AdvanceSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isContinueFirstPage = true;
    selectedIndex = -1;
    [[MyLocationManager sharedInstance] getCurrentLocation];
    refreshCount = 0;
    pageIndex = 1;
    selectedSortBy = -1;
    
    arrAgrBy = [[NSMutableArray alloc]initWithObjects:@"Any Age (3-65 Years)",@"Adults (18+)",@"A level (16-18 years)",@"GCSE (15-16)",@"Secondary School (11-16 Years)",@"Primary School (6-10 Years)",@"PreSchool (3-5 Years)",@"Don't care", nil];
    arrPriceBy = [[NSMutableArray alloc]initWithObjects:@"5-49 £",@"50-99 £",@"100-249 £",@"250-499 £",@"Don't care", nil];
    arrBatchBy = [[NSMutableArray alloc]initWithObjects:@"1-to-1",@"2 - 5",@"5 - 10",@"10 - 20",@"Don't care", nil];
    arrSessionBy = [[NSMutableArray alloc]initWithObjects:@"Individual (1-to-1)",@"2 - 10",@"10 - 15",@"15+",@"Don't care", nil];
    arrSortBy = [[NSMutableArray alloc]initWithObjects:@"Posted date (DESC)",@"Posted date (ASC)",@"Reviews count (DESC)",@"Reviews count (ASC)",@"Price (DESC)",@"Price (ASC)", nil];
    
    NSString *dStart = [dateSimpleFormatter() stringFromDate:[globalDateFormatter() dateFromString:self.basicDict[@"start_date"]]];
    if (dStart) {
        tfStart.text = dStart;
    }else{
        tfStart.text = [dateSimpleFormatter() stringFromDate:[NSDate date]];
    }
    
    NSString *dEnd = [dateSimpleFormatter() stringFromDate:[globalDateFormatter() dateFromString:self.basicDict[@"end_date"]]];
    if (dEnd) {
        tfEnd.text = dEnd;
    }else{
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setMonth:6];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
        tfEnd.text = [dateSimpleFormatter() stringFromDate:newDate];
    }
    
    NSString *tempSort = self.basicDict[@"sorting"];
    lblSortBy.text = (arrSortBy.count > tempSort.intValue) ? [arrSortBy objectAtIndex:[tempSort intValue]] : [arrSortBy lastObject];
    
    NSString *tempBatch = self.basicDict[@"batch_size"];
    lblBatchBy.text = (arrBatchBy.count > tempBatch.intValue) ? [arrBatchBy objectAtIndex:[tempBatch intValue]] : [arrBatchBy lastObject];
    
    lblAgeBy.text = [arrAgrBy firstObject];
    lblPriceBy.text = [arrPriceBy lastObject];
    lblSessionBy.text = [arrSessionBy lastObject];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:true];
    [self startTimer];
    isCommentClciked = false;
    [self initData];
    [self updateToGoogleAnalytics:@"Advance search - 2"];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [self stopTimer];

}

- (void) initData {
    arrFilter = [[NSArray alloc]initWithObjects:@"post date(desc)",@"Comment count(desc)",@"Comment count(asc)",@"Course price(desc)",@"Course price(asc)",@"Course rating", nil];
    [self configureLabelSlider];
    
}
-(IBAction)btnApplyFilters:(UIButton*)sender {
    pageIndex = 1;
    [self searchAdvanceScreen2];
}
-(IBAction)btnCloseFilters:(UIButton*)sender {
    [UIView animateWithDuration:0.5 animations:^{
        _filterHeight.constant = 60;
        openFilterView.alpha = 1;
        sortByView.hidden = true;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [collectView reloadData];
    }];
}

-(IBAction)btnOpenSortBy:(UIButton*)sender
{
    if (sortByView.hidden) {
        sortByView.hidden = false;
    }else{
        sortByView.hidden = true;
    }
}
-(IBAction)btnSoryBySelected:(UIButton*)sender {
    selectedSortBy = sender.tag;
    sortByView.hidden = true;
    switch (sender.tag) {
        case 0:
            tfSortBy.text = @"post date (DESC)";
            break;
        case 1:
            tfSortBy.text = @"comment count (DESC)";
            break;
        case 2:
            tfSortBy.text = @"comment count (ASC)";
            break;
        case 3:
            tfSortBy.text = @"commerce price (DESC)";
            break;
        case 4:
            tfSortBy.text = @"commerce price (ASC)";
            break;
        default:
            break;
    }
}
-(IBAction)btnOpenFilterView:(UIButton*)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        _filterHeight.constant = 410;
        openFilterView.alpha = 0;
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        [collectView reloadData];
    }];
}
-(IBAction)btnSelectDate:(UIButton*)sender
{
    DateCalenderPickerVC  *vc =(DateCalenderPickerVC*) [(!is_iPad())?getStoryBoardDeviceBased(StoryboardPop): self.storyboard instantiateViewControllerWithIdentifier: @"DateCalenderPickerVC"];
    vc.delegate = self;
    if (sender.tag == 44) {
        vc.selectTxt = 44;
    }else{
        vc.selectTxt = 45;
    }
    if (is_iPad()) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            UIPopoverController *popover=[[UIPopoverController alloc]initWithContentViewController:vc];
            [popover presentPopoverFromRect:sender.frame inView:FilterView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }];
        
    }else{
        [self presentViewController:vc animated:true completion:nil];
    }
}
#pragma mark CalenderPicker Delegate
-(void)selectedCalenderDate:(NSString *)date index:(NSInteger)pos
{
    if (pos == 44) {
        tfStart.text = date;
    }else{
        tfEnd.text = date;
    }
}
#pragma mark - Button method
-(IBAction)btnOptionValue:(UIButton*)sender{
    PopVC  *vc =(PopVC*) [getStoryBoardDeviceBased(StoryboardPop) instantiateViewControllerWithIdentifier: @"PopVC"];
    NSMutableArray * arr;
    switch (sender.tag) {
        case 11:
            arr = arrSortBy;
            break;
        case 12:
            arr = arrAgrBy;
            break;
        case 13:
            arr = arrPriceBy;
            break;
        case 14:
            arr = arrBatchBy;
            break;
        case 15:
            arr = arrSessionBy;
            break;
        default:
            break;
    }
    vc.arrData = arr;
    vc.selectedTag = sender.tag;
    vc.delegate = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        UIPopoverController *popover=[[UIPopoverController alloc]initWithContentViewController:vc];
        [popover presentPopoverFromRect:sender.frame inView:FilterView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }];
}
-(void)selectedCustomView:(NSString *)value tag:(NSInteger)selectTag
{
    switch (selectTag) {
        case 11:
            lblSortBy.text = value;
            break;
        case 12:
            lblAgeBy.text = value;
            break;
        case 13:
            lblPriceBy.text = value;
            break;
        case 14:
            lblBatchBy.text = value;
            break;
        case 15:
            lblSessionBy.text = value;
            break;
        default:
            break;
    }
   
}
-(IBAction)btnDaySelection:(UIButton*)sender
{
    if (sender.isSelected)
    {
        sender.selected = false;
    }
    else
    {
        sender.selected = true;
    }
}
-(NSMutableArray*) getCourseDay
{
    NSMutableArray *arrSelectCity = [[NSMutableArray alloc]init];
    if (btnMon.isSelected)
    {
        [arrSelectCity addObject:@"Monday"];
    } if(btnThu.isSelected)
    {
        [arrSelectCity addObject:@"Thursday"];
    } if(btnWed.isSelected)
    {
        [arrSelectCity addObject:@"Wednesday"];
    } if(btnTue.isSelected)
    {
        [arrSelectCity addObject:@"Tuesday"];
    } if(btnFri.isSelected)
    {
        [arrSelectCity addObject:@"Friday"];
    } if(btnSat.isSelected)
    {
        [arrSelectCity addObject:@"Saturday"];
    } if(btnSan.isSelected)
    {
        [arrSelectCity addObject:@"Sunday"];
    }
    
    return arrSelectCity;
}
- (UIDeviceOrientation) orientationChanged:(NSNotification *)note
{
    UIDevice * device = note.object;
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
            /* start special animation */
            return UIDeviceOrientationPortrait;
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            /* start special animation */
            return UIDeviceOrientationLandscapeLeft;
            break;
            
        case UIDeviceOrientationLandscapeRight:
            /* start special animation */
            return UIDeviceOrientationLandscapeRight;
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            /* start special animation */
            return UIDeviceOrientationPortraitUpsideDown;
            break;
            
        default:
            return UIDeviceOrientationLandscapeLeft;
            break;
    };
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    // Do view manipulation here.
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self viewDidLayoutSubviews];
    [self.view layoutIfNeeded];
    [collectView reloadData];
}
#pragma mark -
#pragma mark - Label  Slider

- (void) configureLabelSlider
{
    self.ageSlider.minimumValue = 0;
    self.ageSlider.maximumValue = 100;
    self.ageSlider.lowerValue = 1;
    self.ageSlider.upperValue = 100;
    self.ageSlider.minimumRange = 1;
    self.ageSlider.trackImage = [self imageWithColor:[UIColor colorFromHexString:@"F52375"]];
    
    self.priceSlider.minimumValue = 0;
    self.priceSlider.maximumValue = 2000;
    self.priceSlider.lowerValue = 1;
    self.priceSlider.upperValue = 2000;
    self.priceSlider.minimumRange = 1;
    self.priceSlider.trackImage = [self imageWithColor:[UIColor colorFromHexString:@"F52375"]];
    
    self.sessionSlider.minimumValue = 0;
    self.sessionSlider.maximumValue = 100;
    self.sessionSlider.lowerValue = 1;
    self.sessionSlider.upperValue = 100;
    self.sessionSlider.minimumRange = 1;
    self.sessionSlider.trackImage = [self imageWithColor:[UIColor colorFromHexString:@"F52375"]];
    
    self.sizeSlider.minimumValue = 0;
    self.sizeSlider.maximumValue = 100;
    self.sizeSlider.lowerValue = 1;
    self.sizeSlider.upperValue = 100;
    self.sizeSlider.minimumRange = 1;
    self.sizeSlider.trackImage = [self imageWithColor:[UIColor colorFromHexString:@"F52375"]];
    
}
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 3.0f, 3.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (void) updateSliderLabels
{
    CGPoint lowerCenter;
    lowerCenter.x = (self.ageSlider.lowerCenter.x + self.ageSlider.frame.origin.x);
    lowerCenter.y = (self.ageSlider.center.y - 30.0f);
    self.ageLowerLabel.center = lowerCenter;
    self.ageLowerLabel.text = [NSString stringWithFormat:@"%d", (int)self.ageSlider.lowerValue];
    
    CGPoint upperCenter;
    upperCenter.x = (self.ageSlider.upperCenter.x + self.ageSlider.frame.origin.x);
    upperCenter.y = (self.ageSlider.center.y - 30.0f);
    self.ageUpperLabel.center = upperCenter;
    self.ageUpperLabel.text = [NSString stringWithFormat:@"%d", (int)self.ageSlider.upperValue];
}
- (void) updateSliderLabels2
{
    CGPoint lowerCenter;
    lowerCenter.x = (self.priceSlider.lowerCenter.x + self.priceSlider.frame.origin.x);
    lowerCenter.y = (self.priceSlider.center.y - 30.0f);
    self.priceLowerLabel.center = lowerCenter;
    self.priceLowerLabel.text = [NSString stringWithFormat:@"%d", (int)self.priceSlider.lowerValue];
    
    CGPoint upperCenter;
    upperCenter.x = (self.priceSlider.upperCenter.x + self.ageSlider.frame.origin.x);
    upperCenter.y = (self.priceSlider.center.y - 30.0f);
    self.priceUpperLabel.center = upperCenter;
    self.priceUpperLabel.text = [NSString stringWithFormat:@"%d", (int)self.priceSlider.upperValue];
}
- (void) updateSliderLabels3
{
    CGPoint lowerCenter;
    lowerCenter.x = (self.sizeSlider.lowerCenter.x + self.sizeSlider.frame.origin.x);
    lowerCenter.y = (self.sizeSlider.center.y - 30.0f);
    self.sizeLowerLabel.center = lowerCenter;
    self.sizeLowerLabel.text = [NSString stringWithFormat:@"%d", (int)self.sizeSlider.lowerValue];
    
    CGPoint upperCenter;
    upperCenter.x = (self.sizeSlider.upperCenter.x + self.sizeSlider.frame.origin.x);
    upperCenter.y = (self.sizeSlider.center.y - 30.0f);
    self.sizeUpperLabel.center = upperCenter;
    self.sizeUpperLabel.text = [NSString stringWithFormat:@"%d", (int)self.sizeSlider.upperValue];
}
- (void) updateSliderLabels4
{
    CGPoint lowerCenter;
    lowerCenter.x = (self.sessionSlider.lowerCenter.x + self.sessionSlider.frame.origin.x);
    lowerCenter.y = (self.sessionSlider.center.y - 30.0f);
    self.sessionLowerLabel.center = lowerCenter;
    self.sessionLowerLabel.text = [NSString stringWithFormat:@"%d", (int)self.sessionSlider.lowerValue];
    
    CGPoint upperCenter;
    upperCenter.x = (self.sessionSlider.upperCenter.x + self.sessionSlider.frame.origin.x);
    upperCenter.y = (self.sessionSlider.center.y - 30.0f);
    self.sessionUpperLabel.center = upperCenter;
    self.sessionUpperLabel.text = [NSString stringWithFormat:@"%d", (int)self.sessionSlider.upperValue];
}


// Handle control value changed events just like a normal slider
- (IBAction)labelSliderChanged:(NMRangeSlider*)sender
{
    switch (sender.tag) {
        case 1:
            [self updateSliderLabels];
            break;
        case 2:
            [self updateSliderLabels2];
            break;
        case 3:
            [self updateSliderLabels3];
            break;
        case 4:
            [self updateSliderLabels4];
            break;
        default:
            break;
    }
    
}
#pragma mark -
-(void) updateTimer
{
    NSInteger count = [collectView visibleCells].count;
    if (refreshCount < count)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:refreshCount inSection:0];
        CourseListCollectionViewCell *cell = (CourseListCollectionViewCell*) [collectView cellForItemAtIndexPath:indexPath];
        if (cell == nil) {
            return;
        }
        id data = [self.arrCourses objectAtIndex:indexPath.row];
        if ([data isKindOfClass:[CourseDetail class]])
        {
            CourseDetail * course = (CourseDetail*) data;
            if (course == nil) {
                return;
            }
            if (course.currentPage * cell.frame.size.width >= course.field_deal_image.count * cell.frame.size.width)
            {
                course.currentPage = 0;
                CGPoint offset = CGPointMake(course.currentPage * cell.frame.size.width, 0);
                [cell.imgScroll setContentOffset:offset];
                
            }else{
                CGPoint offset = CGPointMake(course.currentPage * cell.frame.size.width, 0);
                
                [UIScrollView animateWithDuration:1 animations:^{
                    [cell.imgScroll setContentOffset:offset];
                }];
            }
            course.currentPage++;
            refreshCount++;
        }
    }else{
        refreshCount = 0;
    }
}


#pragma mark - UICollectionView delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.arrCourses count];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIInterfaceOrientation interfaceOrientation = self.interfaceOrientation;
    if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        return CGSizeMake(collectView.frame.size.width/2, collectView.frame.size.width/2);
        
    }
    return CGSizeMake(collectView.frame.size.width/3, collectView.frame.size.width/3);
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CourseListCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.delegate = self;
    if (indexPath.row <= self.arrCourses.count)
    {
        id data =[self.arrCourses objectAtIndex:indexPath.row];
        if ([data isKindOfClass:[Course class]])
        {
            Course* course = [self.arrCourses objectAtIndex:indexPath.row];
            [cell setCourseData:course customCell:cell];
        }
        else
        {
            CourseDetail* courseDetail = [self.arrCourses objectAtIndex:indexPath.row];
            [cell setData:courseDetail customCell:cell];
        }
        cell.imgScroll.userInteractionEnabled = NO;
        [cell.contentView addGestureRecognizer:cell.imgScroll.panGestureRecognizer];
    }
    return cell;
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"course_detail" sender:indexPath];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
    if (_filterHeight.constant == 410) {
        [self btnCloseFilters:nil];
    }
}

-(void) startTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}
-(void) stopTimer
{
    [timer invalidate];
    timer = nil;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if ([segue.identifier isEqualToString:@"course_detail"])
    {
        CourseDetailViewController *vc =(CourseDetailViewController *) segue.destinationViewController;
        NSIndexPath *path = (NSIndexPath*) sender;
        id data = [self.arrCourses objectAtIndex:path.row];
        if ([data isKindOfClass:[CourseDetail class]])
        {
            CourseDetail *course = [self.arrCourses objectAtIndex:path.row];
            vc.NID = course.nid;
            
        }else
        {
            Course *course = [self.arrCourses objectAtIndex:path.row];
            vc.NID = course.nid;
        }
        if (isCommentClciked) {
            vc.isGoComment = true;
        }else{
            vc.isGoComment = false;
        }
        
        vc.arrLocalViewed = self.arrCourses;
        
    }else if ([segue.identifier isEqualToString:@"MapScreen"]){
        
        CourseLocationViewController *mapViewController = segue.destinationViewController;
        if (self.arrCourses.count > 0) {
            mapViewController.arrayCourseList = self.arrCourses;
            mapViewController.selectedCourse = [self.arrCourses firstObject];
        }
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
#pragma mark - Search Course based on Filter
-(void) searchAdvanceScreen2
{
    NSMutableDictionary * dictObj = [[NSMutableDictionary alloc]init];
    [self startActivity];
    NSDateFormatter *df = globalDateOnlyFormatter();
    NSDateFormatter *df2 = globalDateFormatter();
    NSDate *Start = [df dateFromString:tfStart.text];
    NSString *strStart = [df2 stringFromDate:Start];
    
    NSDate *End = [df dateFromString:tfEnd.text];
    NSString *strEnd = [df2 stringFromDate:End];
    
    //Dates
    [dictObj setValue:strStart forKey:@"start_date"];
    [dictObj setValue:strEnd forKey:@"end_date"];
    
    //Age Group
    NSInteger posAge =  [arrAgrBy indexOfObject:lblAgeBy.text];
    [dictObj setValue:[NSString stringWithFormat:@"%d",posAge] forKey:@"age_group"];
    
    //Price
    NSInteger posPrice =  [arrPriceBy indexOfObject:lblPriceBy.text];
    [dictObj setValue:[NSString stringWithFormat:@"%d",posPrice] forKey:@"price"];
    
    //Batch
    NSInteger posBatch =  [arrBatchBy indexOfObject:lblBatchBy.text];
    [dictObj setValue:[NSString stringWithFormat:@"%d",posBatch+1] forKey:@"batch_size"];
    
    //sessions
    NSInteger posSession =  [arrSessionBy indexOfObject:lblSessionBy.text];
    [dictObj setValue:[NSString stringWithFormat:@"%d",posSession] forKey:@"sessions"];
    
    //days_of_week
    if ([self getCourseDay].count > 0){
        [dictObj setValue:[self getCourseDay] forKey:@"days_of_week"];
    }
    
    [dictObj setValue:@"2" forKey:@"form"];
    [dictObj setValue:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"page"];
    
    [[NetworkManager sharedInstance] postRequestUrl:apiSearchUrl paramter:dictObj withCallback:^(id jsonData, WebServiceResult result) {
        NSLog(@"%@",jsonData);
        [self stopActivity];
        if (result == WebServiceResultSuccess)
        {
            if ([jsonData isKindOfClass:[NSArray class]])
            {
                showAletViewWithMessage(@"No Course found,Please try again.");
                return;
            }
            if (jsonData[@"results"]) {
                NSArray * arr =  jsonData[@"results"];
                if ([arr isKindOfClass:[NSArray class]])
                {
                    isContinueFirstPage = false;
                    if (pageIndex == 1) {
                        [self.arrCourses removeAllObjects];
                    }
                    for (NSDictionary *dict in arr)
                    {
                        if ([dict isKindOfClass:[NSDictionary class]])
                        {
                            Course *courseEnt = [[Course alloc]initWith:dict];
                            [self.arrCourses addObject:courseEnt];
                        }
                    }
                    
                    if (self.arrCourses.count < 10) {
                        pageIndex = -1;
                    }else{
                        pageIndex = pageIndex + 1;
                        
                    }
                    [collectView reloadData];
                }
            }
        }else
        {
            pageIndex = 1;
            showAletViewWithMessage(@"No Course found,Please try again.");
        }
    }];
}
-(void) searchBasicScreen1:(NSMutableDictionary*)dict
{
    [self startActivity];
    if (pageIndex == 1) { //Because first page data load from basic search screen now load from page screen.
        pageIndex = pageIndex + 1;
    }
    [dict setValue:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"page"];
    
    [[NetworkManager sharedInstance] postRequestUrl:apiSearchUrl paramter:dict withCallback:^(id jsonData, WebServiceResult result) {
        NSLog(@"%@",jsonData);
        [self stopActivity];
        if (result == WebServiceResultSuccess)
        {
            if ([jsonData isKindOfClass:[NSArray class]])
            {
                showAletViewWithMessage(@"No Course found,Please try again.");
                return;
            }
            if (jsonData[@"results"]) {
                NSArray * arr =  jsonData[@"results"];
                if ([arr isKindOfClass:[NSArray class]])
                {
                    for (NSDictionary *dict in arr)
                    {
                        if ([dict isKindOfClass:[NSDictionary class]])
                        {
                            Course *courseEnt = [[Course alloc]initWith:dict];
                            [self.arrCourses addObject:courseEnt];
                        }
                    }
                    if (self.arrCourses.count < 10) {
                        pageIndex = -1;
                    }else{
                        pageIndex = pageIndex + 1;
                    }
                }
                [collectView reloadData];
            }
        }else
        {
            pageIndex =  1;
            if ([jsonData isKindOfClass:[NSString class]]){
                showAletViewWithMessage(jsonData);
            }else{
                showAletViewWithMessage(@"No Course found,Please try again.");
            }
        }
    }];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startTimer];
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    if (maximumOffset - currentOffset <= 5.0 && pageIndex != -1)
    {
        if (isContinueFirstPage) {
            [self searchBasicScreen1:_basicDict];
        }else{
            [self searchAdvanceScreen2];
        }
    }
}

#pragma mark - Course TableView Cell delegate
-(void) btnLocationButtonTapped:(CourseListCollectionViewCell *)cell{
    
    NSIndexPath *indexPath = [collectView indexPathForCell:cell];
    CourseLocationViewController *mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CourseLocationViewController"];
    mapViewController.arrayCourseList = arrayCourseListData;
    mapViewController.selectedCourse = arrayCourseListData[indexPath.row];
    [self.navigationController pushViewController:mapViewController animated:YES];
}
-(void) btnCommentBtnTapped:(CourseListCollectionViewCell *)cell
{
    NSIndexPath *indexPath = [collectView indexPathForCell:cell];
    isCommentClciked = true;
    [self performSegueWithIdentifier:@"course_detail" sender:indexPath];
    
}



@end

