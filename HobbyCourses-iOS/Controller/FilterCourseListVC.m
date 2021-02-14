//
//  FilterCourseListVC.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 05/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "FilterCourseListVC.h"

@interface FilterCourseListVC ()<CourseTableViewCellProtocol,UIActionSheetDelegate>
{
    BOOL isCommentClciked;
    int pageIndex;
    IBOutlet UIButton *btnSortBy;
    IBOutlet UIButton *btnAgeBy;
    IBOutlet UIButton *btnPriceBy;
    IBOutlet UIButton *btnBatchBy;
    IBOutlet UIButton *btnSessionBy;
    
    IBOutlet UITextField *lblSortBy;
    IBOutlet UITextField *lblAgeBy;
    IBOutlet UITextField *lblPriceBy;
    IBOutlet UITextField *lblBatchBy;
    IBOutlet UITextField *lblSessionBy;
    
    
    NSMutableArray *arrSortBy;
    NSMutableArray *arrPriceBy;
    NSMutableArray *arrAgrBy;
    NSMutableArray *arrSessionBy;
    NSMutableArray *arrBatchBy;
    BOOL isContinueFirstPage;
}
@end

@implementation FilterCourseListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    pageIndex = 1;
    isContinueFirstPage = true;
    NSLeadingtblFilter.constant = _screenSize.width;
    if (self.arrCourses == nil) {
        self.arrCourses = [[NSMutableArray alloc]init];
        [self getCourseApiSimpleSearch];
    }
    lblTittle.text = @"Search Course";
    lblSearch.text = [NSString stringWithFormat:@"Filter: %@",self.postalCode];
    
    arrAgrBy = [[NSMutableArray alloc]initWithObjects:@"Any Age (3-65 Years)",@"Adults (18+)",@"A level (16-18 years)",@"GCSE (15-16)",@"Secondary School (11-16 Years)",@"Primary School (6-10 Years)",@"PreSchool (3-5 Years)",@"Don't care", nil];
    arrPriceBy = [[NSMutableArray alloc]initWithObjects:@"5-49 £",@"50-99 £",@"100-249 £",@"250-499 £",@"Don't care", nil];
    arrBatchBy = [[NSMutableArray alloc]initWithObjects:@"1-to-1",@"2 - 5",@"5 - 10",@"10 - 20",@"Don't care", nil];
    arrSessionBy = [[NSMutableArray alloc]initWithObjects:@"Individual (1-to-1)",@"2 - 10",@"10 - 15",@"15+",@"Don't care", nil];
    arrSortBy = [[NSMutableArray alloc]initWithObjects:@"Posted date (DESC)",@"Posted date (ASC)",@"Reviews count (DESC)",@"Reviews count (ASC)",@"Price (DESC)",@"Price (ASC)",@"Distance", nil];
    
    
    NSString *dStart = [globalDateOnlyFormatter() stringFromDate:[globalDateFormatter() dateFromString:self.basicDict[@"start_date"]]];
    if (dStart) {
        tfStart.text = dStart;
    }else{
        tfStart.text = [globalDateOnlyFormatter() stringFromDate:[NSDate date]];
    }
    
    NSString *dEnd = [globalDateOnlyFormatter() stringFromDate:[globalDateFormatter() dateFromString:self.basicDict[@"end_date"]]];
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
-(void)viewWillAppear:(BOOL)animated
{
    isCommentClciked = false;
    [self updateToGoogleAnalytics:@"Advance search-2 Screen"];
}

-(IBAction)btnOptionValue:(UIButton*)sender {
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
    UIAlertController *departureActnSht = [UIAlertController alertControllerWithTitle:@""
                                                                              message:@""
                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int j =0 ; j<arr.count; j++)
    {
        NSString *titleString = arr[j];
        UIAlertAction *action = [UIAlertAction actionWithTitle:titleString style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            switch (sender.tag) {
                case 11:
                    lblSortBy.text = arrSortBy[j];
                    break;
                case 12:
                    lblAgeBy.text = arrAgrBy[j];
                    break;
                case 13:
                    lblPriceBy.text = arrPriceBy[j];
                    break;
                case 14:
                    lblBatchBy.text = arrBatchBy[j];
                    break;
                case 15:
                    lblSessionBy.text = arrSessionBy[j];
                    break;
                default:
                    break;
            }
        }];
        
        [departureActnSht addAction:action];
    }
    
    [self presentViewController:departureActnSht animated:YES completion:nil];
}

#pragma mark - tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrCourses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseTableViewCell"];
    cell.delegate = self;
    id data =[self.arrCourses objectAtIndex:indexPath.row];
    if ([data isKindOfClass:[Course class]])
    {
        Course* course = [self.arrCourses objectAtIndex:indexPath.row];
        [cell setData:course customCell:cell isscroll:true ];
    }else{
        CourseDetail* courseDetail = [self.arrCourses objectAtIndex:indexPath.row];
        [cell setData:courseDetail customCell:cell];
    }
    cell.imgScroll.userInteractionEnabled = NO;
    [cell.contentView addGestureRecognizer:cell.imgScroll.panGestureRecognizer];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"course_detail" sender:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190 * _heighRatio;
}

#pragma mark - IBActions

- (IBAction)btnFilterAction:(UIButton*)sender
{
    if (NSLeadingtblFilter.constant == 0)
    {
        [UIView animateWithDuration:0.25 animations:^{
            NSLeadingtblFilter.constant = _screenSize.width;
            [self.view layoutIfNeeded];
        }];
    }else
    {
        [UIView animateWithDuration:0.25 animations:^{
            NSLeadingtblFilter.constant = 0;
            [self.view layoutIfNeeded];
        }];
    }
}
- (IBAction)btnApplyAction:(UIButton*)sender
{
    pageIndex = 1;
    [self searchAdvanceScreen2];
    [UIView animateWithDuration:0.25 animations:^{
        NSLeadingtblFilter.constant = _screenSize.width;
        [self.view layoutIfNeeded];
    }];
}
- (IBAction)btnCloseFilter:(UIButton*)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        NSLeadingtblFilter.constant = _screenSize.width;
        [self.view layoutIfNeeded];
    }];
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
    [dictObj setValue:[NSNumber numberWithInt:posAge] forKey:@"age_group"];

    //Price
    NSInteger posPrice =  [arrPriceBy indexOfObject:lblPriceBy.text];
    [dictObj setValue:[NSNumber numberWithInt:posPrice] forKey:@"price"];
    
    //Batch
    NSInteger posBatch =  [arrBatchBy indexOfObject:lblBatchBy.text];
    [dictObj setValue:[NSNumber numberWithInt:posBatch+1] forKey:@"batch_size"];

    //sessions
    NSInteger posSession =  [arrSessionBy indexOfObject:lblSessionBy.text];
    [dictObj setValue:[NSNumber numberWithInt:posSession] forKey:@"sessions"];
    
    //days_of_week
    if ([self getCourseDay].count > 0){
        [dictObj setValue:[self getCourseDay] forKey:@"days_of_week"];
    }
    
    [dictObj setValue:@2 forKey:@"form"];
    [dictObj setValue:[NSNumber numberWithInt:pageIndex] forKey:@"page"];
    
    [[NetworkManager sharedInstance] postRequestUrl:apiSearchUrl paramter:dictObj withCallback:^(id jsonData, WebServiceResult result) {
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
                    [tblCourseList reloadData];
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
                [tblCourseList reloadData];
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

-(void) getCourseApiSimpleSearch
{
    pageIndex = pageIndex + 1;
    [self startActivity];
    NSDictionary *dict = @{@"city":APPDELEGATE.selectedCity,@"category":self.category,@"sorting":APPDELEGATE.sortCourseBy,@"sub_category":self.subCategory,@"form":@"1",@"page":[NSString stringWithFormat:@"%d",pageIndex]};
    
    [[NetworkManager sharedInstance] postRequestUrl:apiSearchUrl paramter:dict withCallback:^(id jsonData, WebServiceResult result) {
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
                    }
                    [tblCourseList reloadData];
                }
            }
        }else
        {
            pageIndex = pageIndex - 1;
            showAletViewWithMessage(@"No Course found,Please try again.");
        }
    }];
}
-(IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
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
-(IBAction)btnDaySelection:(UIButton*)sender
{
    if (sender.isSelected) {
        sender.selected = false;
    } else {
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

#pragma mark - Course TableView Cell delegate
-(void) btnLocationButtonTapped:(CourseTableViewCell *)cell{
    
    NSIndexPath *indexPath = [tblCourseList indexPathForCell:cell];
    CourseLocationViewController *mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CourseLocationViewController"];
    mapViewController.arrayCourseList = self.arrCourses;
    mapViewController.selectedCourse = self.arrCourses[indexPath.row];
    [self.navigationController pushViewController:mapViewController animated:YES];
}
-(void) btnCommentBtnTapped:(CourseTableViewCell *)cell
{
    
    NSIndexPath *indexPath = [tblCourseList indexPathForCell:cell];
    isCommentClciked = true;
    [self performSegueWithIdentifier:@"course_detail" sender:indexPath];
    
}

@end
