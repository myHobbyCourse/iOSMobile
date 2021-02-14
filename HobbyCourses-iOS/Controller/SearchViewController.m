//
//  SearchViewController.m
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/17/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import "SearchViewController.h"
#import "Constants.h"
#import "TimeSlotVC.h"

@interface SearchViewController ()<CalenderPickerDelegate> {
    NSArray *arrSearchBase,*arrSearchImg;
    NSMutableArray *arrCourses;
    NSMutableDictionary *searchDict,*adSearchDict;
    int pageIndex;
    int adPageIndexA;
    BOOL isLoadSearch,isSimpleSearch,isAdvanceSearch,isLoadingData;
    
    IBOutlet UIImageView *imgVFilter;
    IBOutlet UIImageView *imgVOrderBy;
    
}
@end

@implementation SearchViewController
@synthesize searchObj;

- (void)viewDidLoad {
    [super viewDidLoad];
    if ( APPDELEGATE.userCurrent.isStudent) {
        [self GoToProfile];
        return;
    }
    [self initData];
    [self updateUI];
    [self searchCoursesAPI];
}




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Search Screen"];

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (isAdvanceSearch) {
        isAdvanceSearch = false;
        [self searchAdvanceAPI];
    }else if (isSimpleSearch) {
        isSimpleSearch = false;
        [self searchCoursesAPI];
    }
    [tblParent reloadData];
}


-(void) GoToProfile{
    if ( APPDELEGATE.userCurrent.isStudent) {
        ProfileSearchResultsViewController *vc = (ProfileSearchResultsViewController*)[getStoryBoardDeviceBased(StoryboardCourseDetail) instantiateViewControllerWithIdentifier: @"ProfileSearchResultsViewController"];
        [[self navigationController] setViewControllers:[[NSArray alloc]initWithObjects:vc, nil] animated:false];
    }

}

-(void) initData{
    arrSearchBase = [[NSArray alloc] initWithObjects:@"Location",@"Radius",@"Start Date",@"Class Size",@"Class Time", nil];
    arrSearchImg = [[NSArray alloc] initWithObjects:@"ic_s_loc",@"ic_s_Radius",@"ic_t_2",@"ic_f_stud_no",@"ic_f_stud_no", nil];
    searchDict = [[NSMutableDictionary alloc]init];
    arrCourses = [NSMutableArray new];
    searchObj = [[Search alloc] init];
    adSearchDict = [[NSMutableDictionary alloc] init];
    [DefaultCenter addObserver:self selector:@selector(handleNotificationSearch1) name:@"searchCoursesAPI" object:nil];
    [DefaultCenter addObserver:self selector:@selector(handleNotificationSearch2) name:@"searchAdvanceAPI" object:nil];
    isLoadSearch = true;
    pageIndex = 1;
    adPageIndexA = 1;
    isLoadingData = true;
    
}
-(void) handleNotificationSearch1{
    pageIndex = 1;
    isLoadSearch = true;
    isSimpleSearch = true;
    //    [self searchCoursesAPI];
}
-(void) handleNotificationSearch2{
    adPageIndexA = 1;
    isLoadSearch = false;
    isAdvanceSearch = true;
    //    [self searchAdvanceAPI];
}
-(void) updateUI {
    tblParent.estimatedRowHeight = 90;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    viewKeyBorad.layer.borderColor = __THEME_lightGreen.CGColor;
    viewKeyBorad.layer.borderWidth = 1;
    viewBottomPanel.layer.cornerRadius = 17.5;
    viewBottomPanel.layer.masksToBounds = true;
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Keyword" attributes:@{ NSForegroundColorAttributeName : __THEME_lightGreen }];
    tfSerach.attributedPlaceholder = str;
    tblParent.contentInset = UIEdgeInsetsMake(64 + (40 * _widthRatio), 0, 0, 0);
    tblParent.tableFooterView = [[UIView alloc]init];
    adPageIndexA = 1;
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"segueClass"]) {
        ClassSelectionVC *vc = segue.destinationViewController;
        vc.searchObj = searchObj;
    }
    
    if ([segue.identifier isEqualToString:@"segueTimes"]) {
        TimeSlotVC *vc = segue.destinationViewController;
        vc.searchObj = searchObj;
    }
    
    if ([segue.identifier isEqualToString:@"segueOrderBy"]) {
        OrderBySelectionVC *vc = segue.destinationViewController;
        vc.searchObj = searchObj;
    }if ([segue.identifier isEqualToString:@"segueMap"]) {
        CourseLocationViewController *vc = segue.destinationViewController;
        vc.arrayCourseList = arrCourses;
    }if ([segue.identifier isEqualToString:@"segueRadius"]) {
        RadiusSelectionVC *vc = segue.destinationViewController;
        vc.searchObj = searchObj;
    }if ([segue.identifier isEqualToString:@"segueFilter"]) {
        FiltersVC *vc = segue.destinationViewController;
        vc.searchObj = searchObj;
    }if ([segue.identifier isEqualToString:@"segueStartDate"]) {
        DateCalenderPickerVC *vc = segue.destinationViewController;
        vc.strTitle = @"Start Date";
        vc.delegate = self;
    }if ([segue.identifier isEqualToString:@"segueCity"]) {
        CitySelectionVC *vc = segue.destinationViewController;
        vc.searchObj = searchObj;
    }if ([segue.identifier isEqualToString:@"segueDetails"]) {
        CourseDetailsVC *vc = segue.destinationViewController;
        vc.NID = sender;
    }
    
}
#pragma Delegates
- (void) selectedCalenderDate:(NSString*) date index:(NSInteger) pos {
    searchObj.startDate = date;
    [tblParent reloadData];
    isSimpleSearch = true;
    //    [self searchCoursesAPI];
    
}
#pragma mark- UIbutton Delegate
-(IBAction)btnMapClicked:(id)sender{
    if (arrCourses.count > 0) {
        [self performSegueWithIdentifier:@"segueMap" sender:self];
    }else{
        showAletViewWithMessage(@"Map it out by selecting a course to view");
    }
}

#pragma mark- UITextFieldDelegate Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    searchObj.keyword = textField.text;
    pageIndex = 1;
    [self searchCoursesAPI];
}
#pragma mark- UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }else{
        return arrCourses.count;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        return 60 * _widthRatio;
    }else{
        return 265 * _widthRatio;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 ){
        return 0.01;
    }else{
        return 50 * _widthRatio;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *viewArray =  [[NSBundle mainBundle] loadNibNamed:@"BatchHeader" owner:self options:nil];
    UIView *view = [viewArray objectAtIndex:2];
    UILabel *lblTitle = [view viewWithTag:111];
    switch (section) {
        case 1:
            lblTitle.text = (arrCourses.count == 0) ? @"Search returned no results so alter filter criteria" : [NSString stringWithFormat:@"Explore %lu+ courses",(unsigned long)arrCourses.count];
            break;
        default:
            break;
    }
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell0" forIndexPath:indexPath];
        UILabel *lblCaption = [cell viewWithTag:11];
        UIImageView *imgV = [cell viewWithTag:13];
        UILabel *lblValue = [cell viewWithTag:12];
        
        lblCaption.text = arrSearchBase[indexPath.row];
        imgV.image = [UIImage imageNamed:arrSearchImg[indexPath.row]];
        lblValue.textColor = [UIColor blackColor];
        switch (indexPath.row) {
            case 0:
                lblValue.text = searchObj.location;
                break;
            case 1:
                lblValue.text = [NSString stringWithFormat:@"%@ Miles",searchObj.radius];
                break;
            case 2:
                lblValue.text = searchObj.startDate;
                break;
            case 3:
                lblValue.text = searchObj.classSize;
                break;
            case 4:
                lblValue.text = searchObj.timesValue;
                break;
            default:
                break;
        }
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];
        UILabel *lblTitle = [cell viewWithTag:11];
        UIImageView *imgV = [cell viewWithTag:12];
        UILabel *lblPrice = [cell viewWithTag:13];
        UILabel *lblLocation = [cell viewWithTag:14];
        UILabel *lblDays = [cell viewWithTag:15];
        if(indexPath.row < arrCourses.count) {
            Course* course = [arrCourses objectAtIndex:indexPath.row];
            [imgV sd_setImageWithURL:[NSURL URLWithString:(course.images.count > 0) ? [course.images firstObject] : @""]
                    placeholderImage:_placeHolderImg];
            lblTitle.text = course.title;
            lblDays.text =  [NSString stringWithFormat:@"%@  %@",getDays(course),getTime(course)];
            if (course.productArr.count > 0) {
                ProductEntity * obj = course.productArr[0];
                lblPrice.text = obj.initial_price;
            }
            lblLocation.text = course.city;
            BOOL lastItemReached = [course isEqual:[arrCourses lastObject]];
            if (lastItemReached && !isLoadingData && indexPath.row == [arrCourses count] - 1) {
                if (isLoadSearch) {
                    [self searchCoursesAPI];
                }else if (adPageIndexA != -1) {
                    [self searchAdvanceAPI];
                }
            }
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (indexPath.row) {
                case 0:
                    [self performSegueWithIdentifier:@"segueCity" sender:self];
                    break;
                case 1:
                    [self performSegueWithIdentifier:@"segueRadius" sender:self];
                    break;
                case 2:
                    [self performSegueWithIdentifier:@"segueStartDate" sender:self];
                    break;
                case 3:
                    [self performSegueWithIdentifier:@"segueClass" sender:self];
                    break;
                case 4:
                    [self performSegueWithIdentifier:@"segueTimes" sender:self];
                    break;
                    
                default:
                    break;
            }
        });
    }else{
        if (indexPath.row < arrCourses.count) {
            Course *obj = arrCourses[indexPath.row];
            [self performSegueWithIdentifier:@"segueDetails" sender:obj.nid];
        }
    }
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [UIView animateWithDuration:0.3 animations:^{
        viewTop.alpha = 0;
        viewKeyBorad.alpha = 0;
        viewBottomContainer.alpha = 0;
        [self.view layoutIfNeeded];
    }];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [UIView animateWithDuration:0.3 animations:^{
        viewTop.alpha = 1;
        viewKeyBorad.alpha = 1;
        viewBottomContainer.alpha = 1;
        [self.view layoutIfNeeded];
    }];
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    if (maximumOffset - currentOffset <= 2.0) {
//        if (isLoadSearch) {
//            [self searchCoursesAPI];
//        }else if (adPageIndexA != -1) {
//            [self searchAdvanceAPI];
//        }
        
    }
}
#pragma mark - Search API
-(void) searchCoursesAPI {
    
    if(pageIndex == -1){
        return;
    }
    
    searchObj.priceRangeMin = nil;
    searchObj.priceRangeMax = nil;
    searchObj.price = nil;
    searchObj.ageGroup = nil;
    searchObj.endDate = nil;
    [searchObj.weekDays removeAllObjects];
    searchObj.sessions = nil;
    
    if ([searchObj getOrderValue] == 6) {
        imgVOrderBy.image = [UIImage imageNamed:@"ic_s_group"];
    }else{
        imgVOrderBy.image = [UIImage imageNamed:@"ic_s_sel_order_by"];
    }
    if (searchDict == nil) {
        searchDict = [NSMutableDictionary new];
    }
    adPageIndexA = 1;
    
    //    [searchDict setValue:[NSNumber numberWithInt:1] forKey:@"form"];
    [searchDict setValue:[NSNumber numberWithInt:pageIndex] forKey:@"page"];
    [searchDict setValue:searchObj.keyword forKey:@"search_word"];
    if (!_isStringEmpty([searchObj getLocationName])) {
        [searchDict setValue:[searchObj getLocationName] forKey:@"postal_code"];
    }
    [searchDict setValue:[NSNumber numberWithInt:[searchObj.radius intValue]] forKey:@"distance"];
    [searchDict setValue:[NSNumber numberWithInt:[searchObj getClassValue] + 1] forKey:@"batch_size"];
    [searchDict setValue:[NSNumber numberWithInt:[searchObj getOrderValue]] forKey:@"sorting"];
    NSString *dStart = [globalDateFormatter() stringFromDate:[globalDateOnlyFormatter() dateFromString:searchObj.startDate]];
    NSString *dEnd = [globalDateFormatter() stringFromDate:[globalDateOnlyFormatter() dateFromString:searchObj.endDate]];
    [searchDict setValue:dStart forKey:@"start_date"];
    [searchDict setValue:dEnd forKey:@"end_date"];
    [searchDict setValue:[NSNumber numberWithInt:[self.searchObj getTimesValue]] forKey:@"timing"];
    [self startActivity];
    isLoadingData = true;
    [[NetworkManager sharedInstance] postRequestUrl:apiSearchUrl paramter:searchDict withCallback:^(id jsonData, WebServiceResult result) {
        searchDict = nil;
        [self stopActivity];
        if (result == WebServiceResultSuccess) {
            if ([jsonData isKindOfClass:[NSArray class]]) {
                NSArray *arr = jsonData;
                if (pageIndex == 1) {
                    [arrCourses removeAllObjects];
                }
                
                for (NSDictionary *dict in jsonData) {
                    if ([dict isKindOfClass:[NSDictionary class]]) {
                        NSMutableDictionary *d = [dict mutableCopy];
                        [d handleNullValue];
                        NSString *nid = d[@"nid"];
                        NSPredicate *pred =[NSPredicate predicateWithFormat:@"self.nid == %@",nid];
                        if([arrCourses filteredArrayUsingPredicate:pred].count == 0) {
                            Course *courseEnt = [[Course alloc]initWith:d];
                            [arrCourses addObject:courseEnt];
                        }
                    }
                }
                
                if (arr.count < 10) {
                    pageIndex = -1;
                }else{
                    pageIndex = pageIndex + 1;
                }
            }else {
                pageIndex =  1;
                if ([jsonData isKindOfClass:[NSString class]]){
                    showAletViewWithMessage(jsonData);
                }else{
                    showAletViewWithMessage(kFailAPI);
                }
            }
            [tblParent reloadData];
            
        }else{
            [arrCourses removeAllObjects];
            pageIndex = 1;
            [tblParent reloadData];
        }
        isLoadingData = false;
    }];
}

-(void) searchAdvanceAPI
{
    imgVFilter.image = [UIImage imageNamed:@"ic_s_sel_filter"];
    NSString *dStart = [globalDateFormatter() stringFromDate:[globalDateOnlyFormatter() dateFromString:searchObj.startDate]];
    NSString *dEnd = [globalDateFormatter() stringFromDate:[globalDateOnlyFormatter() dateFromString:searchObj.endDate]];
    
    //Dates
    [adSearchDict setValue:dStart forKey:@"start_date"];
    [adSearchDict setValue:dEnd forKey:@"end_date"];
    
    //Age Group
    if ([searchObj getAgeValue] != -1) {
        [adSearchDict setValue:[NSNumber numberWithInt:[searchObj getAgeValue]] forKey:@"age_group"];
    }
    
    [adSearchDict setValue:[NSNumber numberWithInt:[searchObj getOrderValue]] forKey:@"sorting"];

    
    //Price
    [adSearchDict setValue:[NSNumber numberWithInt:[searchObj getPriceValue]] forKey:@"price"];
    
    //Batch
    [adSearchDict setValue:[NSNumber numberWithInt:[searchObj getClassValue] + 1] forKey:@"batch_size"];
    
    //sessions
    [adSearchDict setValue:[NSNumber numberWithInt:[searchObj getSessionsValue]] forKey:@"sessions"];
    
    //days_of_week
    if (searchObj.weekDays.count > 0){
        [adSearchDict setValue:searchObj.weekDays forKey:@"days_of_week"];
    }
    
    //            [adSearchDict setValue:@2 forKey:@"form"];
    [adSearchDict setValue:[NSNumber numberWithInt:adPageIndexA] forKey:@"page"];
    [self startActivity];
    isLoadingData = true;
    [[NetworkManager sharedInstance] postRequestUrl:apiSearchUrl paramter:adSearchDict withCallback:^(id jsonData, WebServiceResult result) {
        NSLog(@"%@",jsonData);
        [self stopActivity];
        if (result == WebServiceResultSuccess)
        {
            if ([jsonData isKindOfClass:[NSArray class]])
            {
                NSArray *arr = jsonData;
                if (adPageIndexA == 1) {
                    [arrCourses removeAllObjects];
                }
                for (NSDictionary *dict in jsonData)
                {
                    if ([dict isKindOfClass:[NSDictionary class]])
                    {
                        NSMutableDictionary *d = [dict mutableCopy];
                        [d handleNullValue];
                        NSString *nid = d[@"nid"];
                        NSPredicate *pred =[NSPredicate predicateWithFormat:@"self.nid == %@",nid];
                        if([arrCourses filteredArrayUsingPredicate:pred].count == 0) {
                            Course *courseEnt = [[Course alloc]initWith:d];
                            [arrCourses addObject:courseEnt];
                        }                    }
                }
                
                if (arr.count < 10) {
                    adPageIndexA = -1;
                }else{
                    adPageIndexA = adPageIndexA + 1;
                }
                [tblParent reloadData];
            }else{
                adPageIndexA = 1;
            }
            isLoadingData = false;
        }
    }];
}
@end

