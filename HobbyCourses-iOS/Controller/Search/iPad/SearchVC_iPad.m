//
//  SearchVC_iPad.m
//  HobbyCourses
//
//  Created by iOS Dev on 09/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "SearchVC_iPad.h"
#import "TimeSlotVC.h"

@interface SearchVC_iPad ()<CalenderPickerDelegate> {
    NSArray *arrSearchBase,*arrSearchImg;
    NSMutableArray *arrCourses;
    NSMutableDictionary *searchDict,*adSearchDict;
    int pageIndex;
    int adPageIndexA;
    BOOL isLoadSearch,isLoadingData;
    
    NSInteger selectedRow;
    NSInteger selectedFilterRow;
    NSArray *arrFilters;
    
    IBOutlet NSLayoutConstraint *_xPosFilterView;
    IBOutlet NSLayoutConstraint *_xPosSortBy;
    
    IBOutlet UICollectionView *cvCourse;
    
    IBOutlet UILabel *lblCourseCount;
    
    IBOutlet UITableView *tblFilter;
    IBOutlet UIImageView *imgVFilter;
    IBOutlet UIImageView *imgVOrderBy;
    
    IBOutlet UIView *viewShadow;
    IBOutlet UIView *viewFilterTable;
    IBOutlet UIView *viewFilterMain;
    IBOutlet UIView *resultView;
    
    IBOutlet UIView *vLocation;
    IBOutlet UIView *vRadius;
    IBOutlet UIView *vStartDate;
    IBOutlet UIView *vClassSize;
    IBOutlet UIView *vPrice;
    IBOutlet UIView *vAge;
    IBOutlet UIView *vWeekDays;
    IBOutlet UIView *vSessions;
    IBOutlet UIView *vSortBy;
    IBOutlet UIView *vClassTime;
    
}

@end

@implementation SearchVC_iPad

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
    [self updateToGoogleAnalytics:@"iPad Search Screen"];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [tblParent reloadData];
}
-(void) GoToProfile{
    if ( APPDELEGATE.userCurrent.isStudent) {
        iPadProfileSearchResultsViewController *vc = (iPadProfileSearchResultsViewController*)[getStoryBoardDeviceBased(StoryboardCourseDetail) instantiateViewControllerWithIdentifier: @"iPadProfileSearchResultsViewController"];
        [[self navigationController] setViewControllers:[[NSArray alloc]initWithObjects:vc, nil] animated:false];
    }
}
-(void) initData{
    arrSearchBase = [[NSArray alloc] initWithObjects:@"Location",@"Radius",@"Start Date",@"Class Size",@"Class Time", nil];
    arrSearchImg = [[NSArray alloc] initWithObjects:@"ic_s_loc",@"ic_s_Radius",@"ic_t_2",@"ic_f_stud_no",@"ic_f_stud_no", nil];
    arrFilters = [[NSArray alloc] initWithObjects:@"Age Group",@"Price",@"Number of Sessions",@"End Date",@"Weekdays", nil];
    searchDict = [[NSMutableDictionary alloc]init];
    arrCourses = [NSMutableArray new];
    searchObj = [[Search alloc] init];
    adSearchDict = [[NSMutableDictionary alloc] init];
    [DefaultCenter addObserver:self selector:@selector(handleNotificationSearch1) name:@"searchCoursesAPI" object:nil];
    [DefaultCenter addObserver:self selector:@selector(handleNotificationSearch2) name:@"searchAdvanceAPI" object:nil];
    isLoadSearch = true;
    selectedRow = -1;
    selectedFilterRow = -1;
    HCLog(@"%@", self.childViewControllers[1]);
    ClassSelectionVC *vc = self.childViewControllers[1];
    vc.searchObj = searchObj;
    isLoadingData = true;
}
-(void) updateUI {
    tblParent.estimatedRowHeight = 90;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    tblFilter.estimatedRowHeight = 90;
    tblFilter.rowHeight = UITableViewAutomaticDimension;
    
    viewKeyBorad.layer.borderColor = __THEME_lightGreen.CGColor;
    viewKeyBorad.layer.borderWidth = 1;
    viewBottomPanel.layer.cornerRadius = 17.5;
    viewBottomPanel.layer.masksToBounds = true;
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Keyword" attributes:@{ NSForegroundColorAttributeName : __THEME_lightGreen }];
    tfSerach.attributedPlaceholder = str;
    tblParent.tableFooterView = [[UIView alloc]init];
    adPageIndexA = 1;
    pageIndex = 1;
    [self addShaowForiPad:viewShadow];
    viewShadow.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    
    viewFilterTable.layer.cornerRadius = 15;
    viewFilterTable.layer.borderColor = __THEME_lightGreen.CGColor;
    viewFilterTable.layer.borderWidth = 2.0;
    
    _xPosSortBy.constant = _screenSize.height;
    _xPosFilterView.constant = _screenSize.height;
}

-(void) hideallView{
    vLocation.hidden = true;
    vRadius.hidden = true;
    vStartDate.hidden = true;
    vClassSize.hidden = true;
    vAge.hidden = true;
    vPrice.hidden = true;
    vWeekDays.hidden = true;
    vSessions.hidden = true;
    vSortBy.hidden = true;
    resultView.hidden = true;
    vClassTime.hidden = true;
}
-(void) handleNotificationSearch1{
    pageIndex = 1;
    isLoadSearch = true;
    [self searchCoursesAPI];
}
-(void) handleNotificationSearch2{
    adPageIndexA = 1;
    isLoadSearch = false;
    [self searchAdvanceAPI];
}
-(void) filterAnimation:(NSInteger) pos {
    [UIView animateWithDuration:0.3 animations:^{
        _xPosFilterView.constant = pos;
        [self.view layoutIfNeeded];
    }];
}
-(void) sortByAnimation:(NSInteger) pos {
    vSortBy.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _xPosSortBy.constant = pos;
        [self.view layoutIfNeeded];
    }];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"segueClass"]) {
        ClassSelectionVC *vc = segue.destinationViewController;
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
#pragma mark- CalenderDate Delegates
- (void) selectedCalenderDate:(NSString*) date index:(NSInteger) pos {
    if (pos == 11) {
        searchObj.startDate = date;
        [tblParent reloadData];
        [self searchCoursesAPI];
    }else{
        searchObj.endDate = date;
        [tblParent reloadData];
        [self searchAdvanceAPI];
    }
    
    
}
#pragma mark- UIbutton Delegate
-(IBAction)btnClearFilters:(id)sender {
    ActionAlert *alert =  [ActionAlert instanceFromNib:kAppName withMessage:@"do you want to clear FILTERs" bgColor:__THEME_YELLOW button:@[@"NO",@"YES"] controller:self block:^(Tapped tapped, ActionAlert *alert) {
        if (tapped == TappedOkay) {
            searchObj.priceRangeMin = nil;
            searchObj.priceRangeMax = nil;
            searchObj.price = nil;
            searchObj.ageGroup = nil;
            searchObj.endDate = nil;
            [searchObj.weekDays removeAllObjects];
            searchObj.sessions = nil;
            [tblParent reloadData];
            [self searchCoursesAPI];
        }
        [alert removeFromSuperview];
    }];
    [APPDELEGATE.window addSubview:alert];
}
-(IBAction)btnMapClicked:(id)sender{
    if (arrCourses.count > 0) {
        [self performSegueWithIdentifier:@"segueMap" sender:self];
    }else{
        showAletViewWithMessage(@"Map it out by selecting a course to view");
    }
}
-(IBAction)btnSortByClicked:(UIButton*)sender {
    
    OrderBySelectionVC *vc = [self.childViewControllers lastObject];
    vc.searchObj = searchObj;
    [vc viewWillAppear:YES];
    [tblParent reloadData];
    [tblFilter reloadData];
    
    if (_xPosSortBy.constant == _screenSize.height) {
        [self sortByAnimation:0];
    } else {
        [self sortByAnimation:_screenSize.height];
    }
    [self updateToGoogleAnalytics:@"iPAd Search Screen"];

}
-(IBAction)btnFilterClicked:(UIButton*)sender {
    selectedFilterRow = -1;
    [tblFilter reloadData];
    if (_xPosFilterView.constant == _screenSize.height) {
        [self filterAnimation:0];
    } else {
        [self filterAnimation:_screenSize.height];
    }
    
}
#pragma mark- UITextFieldDelegate Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    searchObj.keyword = textField.text;
    pageIndex = 1;
    [self searchCoursesAPI];
}
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == tblParent) {
        return 5;
    }else{
        return arrFilters.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == tblParent) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell0" forIndexPath:indexPath];
        UILabel *lblCaption = [cell viewWithTag:11];
        UIImageView *imgV = [cell viewWithTag:13];
        UILabel *lblValue = [cell viewWithTag:12];
        
        lblCaption.text = arrSearchBase[indexPath.row];
        imgV.image = [UIImage imageNamed:arrSearchImg[indexPath.row]];
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
        if (selectedRow == indexPath.row) {
            cell.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:251.0/255.0 blue:250.0/255.0 alpha:1.0];
        }else{
            cell.backgroundColor = [UIColor clearColor];
        }
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell0" forIndexPath:indexPath];
        UIImageView *imgV = [cell viewWithTag:111];
        UILabel *lblCaption = [cell viewWithTag:11];
        UILabel *lblValue = [cell viewWithTag:12];
        lblCaption.text = arrFilters[indexPath.row];
        imgV.hidden = true;
        switch (indexPath.row) {
            case 0:
                if ([self checkStringValue:searchObj.ageGroup]) {
                    lblValue.text = @"No Preference";
                }else{
                    lblValue.text = searchObj.ageGroup;
                    imgV.hidden = false;
                }
                break;
            case 1:
                if ([self checkStringValue:searchObj.price]) {
                    lblValue.text = @"No Preference";
                }else{
                    lblValue.text = searchObj.price;
                    imgV.hidden = false;
                }
                break;
            case 2:
                if ([self checkStringValue:searchObj.sessions]) {
                    lblValue.text = @"No Preference";
                }else{
                    lblValue.text = searchObj.sessions;
                    imgV.hidden = false;
                }
                break;
            case 3:
                lblValue.text = (searchObj.endDate) ? searchObj.endDate : @"No Preference";
                imgV.hidden = false;
                break;
            case 4:
                if (searchObj.weekDays.count > 0) {
                    lblValue.text = [searchObj.weekDays componentsJoinedByString:@","];
                    imgV.hidden = false;
                }else{
                    lblValue.text = @"No Preference" ;
                }
                
                break;
                
            default:
                break;
        }
        if (selectedFilterRow == indexPath.row) {
            cell.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:251.0/255.0 blue:250.0/255.0 alpha:1.0];
        }else{
            cell.backgroundColor = [UIColor clearColor];
        }
        return cell;
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideallView];
    if (tableView == tblParent) {
        selectedRow = indexPath.row;
        switch (indexPath.row) {
            case 0:{
                CitySelectionVC *citySelectionVC = self.childViewControllers[7];
                citySelectionVC.searchObj = searchObj;
                vLocation.hidden = false;}
                break;
            case 1:{
                RadiusSelectionVC *radiusSelectionVC = self.childViewControllers[6];
                radiusSelectionVC.searchObj = searchObj;
                vRadius.hidden = false;}
                break;
            case 2:{
                vStartDate.hidden = false;
                DateCalenderPickerVC *dateCalenderPickerVC = self.childViewControllers[0];
                dateCalenderPickerVC.strTitle = @"Start Date";
                [dateCalenderPickerVC viewWillAppear:true];
                dateCalenderPickerVC.delegate = self;
                dateCalenderPickerVC.selectTxt = 11;
            }   break;
            case 3:
                vClassSize.hidden = false;
                break;
            case 4:{
                TimeSlotVC *vc = self.childViewControllers[8];
                vc.searchObj = searchObj;
                [vc viewWillAppear:false];
                vClassTime.hidden = false;
            }
                break;
                
            default:
                break;
        }
        [tblParent reloadData];
    }else{
        selectedFilterRow = indexPath.row;
        switch (indexPath.row) {
            case 0:{
                vAge.hidden = false;
                AgeSelectionVC *vc = self.childViewControllers[3];
                vc.searchObj = searchObj;
                [vc viewWillAppear:true];
            }   break;
            case 1:{
                PriceRangeVC *vc = self.childViewControllers[2];
                vc.searchObj = searchObj;
                [vc viewWillAppear:true];
                vPrice.hidden = false;
            }   break;
            case 2:{
                SessionSelectionVC *vc = self.childViewControllers[5];
                vc.searchObj = searchObj;
                vSessions.hidden = false;
            } break;
            case 3:{
                vStartDate.hidden = false;
                DateCalenderPickerVC *dateCalenderPickerVC = self.childViewControllers[0];
                dateCalenderPickerVC.strTitle = @"End Date";
                [dateCalenderPickerVC viewWillAppear:true];
                dateCalenderPickerVC.delegate = self;
            } break;
            case 4:{
                WeekDaysVC *vc = self.childViewControllers[4];
                vc.searchObj = searchObj;
                vWeekDays.hidden = false;
            }   break;
            default:
                break;
        }
        [tblFilter reloadData];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    if (maximumOffset - currentOffset <= 5.0 && scrollView == cvCourse) {
//        if (isLoadSearch) {
//            [self searchCoursesAPI];
//        }else{
//            [self searchAdvanceAPI];
//        }
        
    }
}
#pragma mark - UICollection View
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return arrCourses.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((collectionView.frame.size.width - 10)/2,collectionView.frame.size.width /2);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
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
        lblDays.text =  [NSString stringWithFormat:@"%@ %@",getDays(course),getTime(course)];
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
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Course *obj = arrCourses[indexPath.row];
    [self performSegueWithIdentifier:@"segueDetails" sender:obj.nid];
}
#pragma mark - Search API
-(void) searchCoursesAPI
{
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
    
    if (pageIndex == -1) {
        return;
    }
    adPageIndexA = 1;
    if (searchDict == nil) {
        searchDict = [[NSMutableDictionary alloc]init];
    }
    
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

    
    [self hideallView];
    resultView.hidden = false;
    [tblFilter reloadData];
    [tblParent reloadData];
    [self startActivity];
    isLoadingData = true;
    [[NetworkManager sharedInstance] postRequestUrl:apiSearchUrl paramter:searchDict withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        HCLog(@"%@",jsonData);
        searchDict = nil;
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
        lblCourseCount.text = (arrCourses.count > 0) ? [NSString stringWithFormat:@"Explore %lu+ courses",(unsigned long)arrCourses.count] : @"";
        [cvCourse reloadData];
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
//    [adSearchDict setValue:[NSNumber numberWithInt:[searchObj getClassValue] + 1] forKey:@"batch_size"];
    
    //sessions
    [adSearchDict setValue:[NSNumber numberWithInt:[searchObj getSessionsValue]] forKey:@"sessions"];
    
    //days_of_week
    if (searchObj.weekDays.count > 0){
        [adSearchDict setValue:searchObj.weekDays forKey:@"days_of_week"];
    }
    
    [adSearchDict setValue:[NSNumber numberWithInt:adPageIndexA] forKey:@"page"];
    [self hideallView];
    resultView.hidden = false;
    [tblFilter reloadData];
    [tblParent reloadData];
    [self startActivity];
    isLoadingData = true;

    [[NetworkManager sharedInstance] postRequestUrl:apiSearchUrl paramter:adSearchDict withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        HCLog(@"%@",jsonData);
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
        }
        lblCourseCount.text = (arrCourses.count > 0) ? [NSString stringWithFormat:@"Explore %lu+ courses",(unsigned long)arrCourses.count] : @"";
        [cvCourse reloadData];
        isLoadingData = false;
        
    }];
}
@end
