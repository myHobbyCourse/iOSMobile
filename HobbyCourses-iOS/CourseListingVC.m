//
//  CourseListingVC.m
//  AirbnbClone
//
//  Created by iOS Dev on 23/08/16.
//  Copyright © 2016 iOS Dev. All rights reserved.
//

#import "CourseListingVC.h"
#import "CourseListingCell.h"
#import "QRCodeReader.h"
#import "QRCodeReaderViewController.h"

@interface CourseListingVC ()<QRCodeReaderDelegate>
{
    IBOutlet NSLayoutConstraint *_categoryHeight;
    IBOutlet UITableView *tblCategory;
    IBOutlet UICollectionView *cvSubCategory;
    IBOutlet UIButton *btnCategory;
    IBOutlet UIButton *btnSelectedCity;
    IBOutlet UIView *viewHeader;
    
    UIRefreshControl *refreshControl;
    
    NSMutableArray *arrayCourseListData;
    NSArray *arrFilter;
    NSString *filterBy;
    int selectedIndex;
//    NSIndexPath *selectedCatIndex;
    int attamptedCount;
    NSString *tempCity;
    BOOL isFromQR;
}
@end

@implementation CourseListingVC
@synthesize arrCourse,arrFavCourse,arrRecentCourse,arrWeekend,arrEvenings;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    
    attamptedCount = 0;
    tblParent.estimatedRowHeight = 250;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    
    viewHeader.frame = CGRectMake(0, 0, _screenSize.width, 128 * _widthRatio);
    
    [self initData];
    [self initConfigure];
    
//    [self fetchCategoryList];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [tblParent addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(checkSelectedcity:) forControlEvents:UIControlEventValueChanged];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    isFromQR = false; // Use for stop animation
    [self updateToGoogleAnalytics:@"Home course scroller Screen"];
}

-(void)viewDidAppear:(BOOL)animated{
    [tblParent reloadData];
    _categoryHeight.constant = 0;
    
}
#pragma mark - Other Methods
-(void) initData {
    arrayCourseListData = [NSMutableArray new];
    arrCourse = [NSMutableArray new];
    arrFavCourse = [NSMutableArray new];
    arrRecentCourse = [NSMutableArray new];
    arrWeekend = [NSMutableArray new];
    arrEvenings = [NSMutableArray new];
    _arrCategoryC = [NSMutableArray new];
    
    filterBy = @"0";
    arrFilter = [[NSArray alloc]initWithObjects:@"Price (Highest)",@"Price (Lowest)",@"Newly Uploaded",@"Earlier Uploaded",@"Most Voted",@"Least Voted",@"Most Reviewed",@"Least Reviewed", nil];
    lblUserName.text = [NSString stringWithFormat:@"Hi,%@",APPDELEGATE.userCurrent.name];
    selectedIndex = 0;
}
-(void) profileChecker{
    
    if (APPDELEGATE.isOpenProfile) {
        ProfileComlateVC *vc= [getStoryBoardDeviceBased(StoryboardProfile) instantiateViewControllerWithIdentifier:@"ProfileComlateVC"];
        [vc getRefreshBlock:^(NSString *anyValue) {
            [self checkSelectedcity:nil];
        }];
        [self.navigationController pushViewController:vc animated:false];
    }else{
        [self checkSelectedcity:nil];
    }
}
-(void) initConfigure {
    
    if ([CLLocationManager locationServicesEnabled]){
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
            AllowLocationVC *vc = [getStoryBoardDeviceBased(StoryboardSettings) instantiateViewControllerWithIdentifier:@"AllowLocationVC"];
            [vc getRefreshBlock:^(NSString *anyValue) {
                [self profileChecker];
            }];
            [self presentViewController:vc animated:YES completion:nil];
        }else{
            [self profileChecker];
        }
        
    }else{
        [self profileChecker];
    }
    
    
    
    if (![self checkStringValue:APPDELEGATE.deviceTokenReg]) {
        NSDictionary *dict = @{@"type":@"ios",@"token":APPDELEGATE.deviceTokenReg};
        if (![UserDefault boolForKey:@"isPushSet"])
        {
            [[NetworkManager sharedInstance] postRequestUrl:apiPush paramter:dict withCallback:^(id jsonData, WebServiceResult result) {
                if (result == WebServiceResultSuccess)
                {
                    [UserDefault setBool:true forKey:@"isPushSet"];
                }
            }];
        }
    }
}


//Check seected city & open or fetch city related data
-(void) allApiCall{
    [btnSelectedCity setTitle:APPDELEGATE.selectedCity forState:UIControlStateNormal];
    [self getRecentViewedCourse];
    [self fetchCategoryList];
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types == UIUserNotificationTypeNone) {
        AllowNotificationVC *vc = [getStoryBoardDeviceBased(StoryboardSettings) instantiateViewControllerWithIdentifier:@"AllowNotificationVC"];
        [self presentViewController:vc animated:true completion:nil];
    }
}
-(void) checkSelectedcity:(NSString *) popCity {
    
    APPDELEGATE.selectedCity = [UserDefault valueForKey:kSelectedCity];
    
    
    if (_isStringEmpty(APPDELEGATE.selectedCity) && popCity == nil) {
        if (!_isStringEmpty(userINFO.city) && attamptedCount == 0) {
            [self fetchTop50Course:nil city:userINFO.city completion:^{
                [self allApiCall];
                
            }];
        }else if (!_isStringEmpty([MyLocationManager sharedInstance].cityName) && ![tempCity isEqualToString:[MyLocationManager sharedInstance].cityName]) {
            tempCity = [MyLocationManager sharedInstance].cityName;
            [self fetchTop50Course:nil city:[MyLocationManager sharedInstance].cityName completion:^{
                [self allApiCall];
                
            }];
        }else{
            attamptedCount = 0;
            [self presentCityPopUpView:false];
        }
        
    }else{
        if (attamptedCount == 0) {
            [self fetchTop50Course:nil city:(_isStringEmpty(popCity)) ? [UserDefault stringForKey:kSelectedCity] : popCity completion:^{
                [self allApiCall];
            }];
            
            
        }else{
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                //code to be executed on the main queue after delay
                [AppUtils actionWithMessage:kAppName withMessage:@"There is not course for city,Please try different location." alertType:UIAlertControllerStyleAlert button:@[@"YES"] controller:self block:^(NSString *tapped) {
                    if ([tapped isEqualToString:@"YES"]) {
                        attamptedCount = 0;
                        [self presentCityPopUpView:false];
                    }
                }];
            });
        }
    }
}

#pragma mark - Other Methods
-(void) presentCityPopUpView:(BOOL) flag
{
    UIStoryboard *mainStoryboard = getStoryBoardDeviceBased(StoryboardMain);
    SelectCityViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"SelectCityViewController"];
    vc.view.backgroundColor = [UIColor clearColor];
    vc.isShowbtn = flag;
    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [APPDELEGATE.window.rootViewController presentViewController:vc animated:NO completion:nil];
    
    [vc getCityBlock:^(NSString *anyValue) {
        APPDELEGATE.selectedCity = anyValue;
        [self checkSelectedcity:anyValue];
        [self fetchCategoryList];
    }];
}

-(NSString*) getSortCourseUrl {
    if ([arrFilter[filterBy.integerValue] isEqualToString:@"Newly Uploaded"] ) {
        return @"created/desc";
    }else if([arrFilter[filterBy.integerValue] isEqualToString:@"Earlier Uploaded"] ) {
        return @"created/asc";
    }else if([arrFilter[filterBy.integerValue] isEqualToString:@"Most Reviewed"] ) {
        return @"reviews/desc";
    }else if([arrFilter[filterBy.integerValue] isEqualToString:@"Least Reviewed"] ) {
        return @"reviews/asc";
    }else if([arrFilter[filterBy.integerValue] isEqualToString:@"Price (Highest)"] ) {
        return @"price/desc";
    }else if([arrFilter[filterBy.integerValue] isEqualToString:@"Price (Lowest)"] ) {
        return @"price/asc";
    }else if([arrFilter[filterBy.integerValue] isEqualToString:@"Most Voted"] ) {
        return @"vote/desc";
    }else if([arrFilter[filterBy.integerValue] isEqualToString:@"Least Voted"] ) {
        return @"vote/asc";
    }
    return nil;
}
-(void) hideshowTables:(BOOL) flag{
    if (flag) {
        tblCategory.alpha = 0;
        tblParent.alpha = 1;
    }else{
        tblCategory.alpha = 1;
        tblParent.alpha = 0;
    }
}
#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"%@", result);
    [JPUtility.shared performOperation:0.1 block:^{
        if ([result containsString:@"&nid:"]) {
            isFromQR = true;
            NSArray *arr = [result componentsSeparatedByString:@"&nid:"];
            if (arr.count > 0) {
                self.courseNID = [arr lastObject];
                [self performSegueWithIdentifier:@"segueDetails" sender:self];
            }
        }else if( [result containsString:@"&uid:"]) {
            NSArray *arr = [result componentsSeparatedByString:@"&uid:"];
            if (arr.count > 0) {
                [self performSegueWithIdentifier:@"segueVendor" sender:[arr lastObject]];
            }
        }else{
            showAletViewWithMessage(@"Invalide code,Try again");
        }
    }];
    
    
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - UIButton MEthod
-(IBAction)btnScanQR:(UIButton*)sender{
    QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    // Instantiate the view controller
    QRCodeReaderViewController *vc = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Cancel" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:false];
    // Set the presentation style
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    // Define the delegate receiver
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:NULL];
    
}
-(IBAction)btnFilter:(id)sender {
    self.tabBarController.selectedIndex = 1;
}


-(IBAction)btnOpenCategoryPopUp:(UIButton*)sender {
    if (_categoryHeight.constant == 0) {
        tblCategory.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            _categoryHeight.constant = (tblCategory.contentSize.height > _screenSize.height - 149) ? _screenSize.height - 149 : tblCategory.contentSize.height;
            tblCategory.alpha = 1;
        }];
    }else{
        _categoryHeight.constant = 0;
    }
}
-(IBAction)btnOpenCitySectionPopUp:(UIButton*)sender {
    
    [self presentCityPopUpView:true];
}
#pragma mark  Orientation Change
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    // Do view manipulation here.
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [tblParent reloadData];
}
#pragma mark  API Calls
-(void) fetchTop50Course:(NSString*) endUrl city:(NSString*) selectedCity completion:(myCompletion) block
{
    if (![self isNetAvailable])
    {
        [self getTop50offlineCourse];
        return;
    }
    APPDELEGATE.selectedCity = selectedCity.tringString;
    [self startActivity];
    NSString *url = [NSString stringWithFormat:@"http://myhobbycourses.com/myhobbycourses_endpoint/%@%@/all/all/reviews/desc",apiTop50Url,selectedCity.tringString];
    
    //    tblParent.hidden = true;
    [[NetworkManager sharedInstance] getRequestUrl:url paramter:nil isToken:NO withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        [refreshControl endRefreshing];
        if (result == WebServiceResultSuccess)
        {
            tblParent.hidden = false;
            if ([jsonData isKindOfClass:[NSArray class]])
            {
                NSArray *arr = jsonData;
                if (arr.count > 0) {
                    [UserDefault setValue:selectedCity forKey:kSelectedCity];
                    APPDELEGATE.selectedCity =  [UserDefault stringForKey:kSelectedCity];
                    [arrCourse removeAllObjects];
                    block();
                }else{
                    attamptedCount = attamptedCount + 1;
                    [self checkSelectedcity:nil];
                }
                
                for (NSDictionary *dict in jsonData) {
                    NSMutableDictionary *d = [dict mutableCopy];
                    [d handleNullValue];
                    CourseDetail *courseEnt = [[CourseDetail alloc]initWith:d];
                    [arrCourse addObject:courseEnt];
                }
                if (arrCourse.count> 0) {
                    [UserDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:jsonData] forKey:kCourseListKey];
                    [UserDefault synchronize];
                    [arrayCourseListData removeAllObjects];
                    [arrayCourseListData addObjectsFromArray:arrCourse];
                }
            }
        } else {
            showAletViewWithMessage(kFailAPI);
        }
        [tblParent reloadData];
    }];
}
-(void) getTop50offlineCourse
{
    NSData *data = [UserDefault objectForKey:kCourseListKey];
    if (data) {
        NSArray *jsonData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([jsonData isKindOfClass:[NSArray class]]) {
            [arrCourse removeAllObjects];
            for (NSDictionary *dict in jsonData) {
                NSMutableDictionary *d = [dict mutableCopy];
                [d handleNullValue];
                CourseDetail *courseEnt = [[CourseDetail alloc]initWith:d];
                [arrCourse addObject:courseEnt];
            }
            [arrayCourseListData addObjectsFromArray:arrCourse];
            
        }else{
            showAletViewWithMessage(@"No Course found,Please select different city.");
        }
        [tblParent reloadData];
    }
}
-(void) getWeekendCourses {
    
    NSString *url = [NSString stringWithFormat:@"http://myhobbycourses.com/myhobbycourses_endpoint/%@%@/all/all/weekend/desc",apiTop50Url,APPDELEGATE.selectedCity];
    [[NetworkManager sharedInstance] getRequestUrl:url paramter:nil isToken:NO withCallback:^(id jsonData, WebServiceResult result) {
        if (result == WebServiceResultSuccess) {
            if ([jsonData isKindOfClass:[NSArray class]])
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [arrWeekend removeAllObjects];
                    for(NSDictionary *dict in jsonData)
                    {
                        NSMutableDictionary *d = [dict mutableCopy];
                        [d handleNullValue];
                        CourseDetail *entity = [[CourseDetail alloc]initWith:d];
                        [arrWeekend addObject:entity];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [tblParent reloadData];
                    });
                });
                
                
            }
            if ([jsonData isKindOfClass:[NSArray class]]) {
                [UserDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:jsonData] forKey:kWeekendKey];
                [UserDefault synchronize];
            }
        }
    }];
}
-(void) getEveningsCourses{
    NSString *url = [NSString stringWithFormat:@"http://myhobbycourses.com/myhobbycourses_endpoint/%@%@/all/all/evenings/desc",apiTop50Url,APPDELEGATE.selectedCity];
    [[NetworkManager sharedInstance] getRequestUrl:url paramter:nil isToken:NO withCallback:^(id jsonData, WebServiceResult result) {
        if (result == WebServiceResultSuccess) {
            if ([jsonData isKindOfClass:[NSArray class]])
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [arrEvenings removeAllObjects];
                    for(NSDictionary *dict in jsonData)
                    {
                        NSMutableDictionary *d = [dict mutableCopy];
                        [d handleNullValue];
                        CourseDetail *entity = [[CourseDetail alloc]initWith:d];
                        [arrEvenings addObject:entity];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [tblParent reloadData];
                    });
                });
                
            }
            if ([jsonData isKindOfClass:[NSArray class]]) {
                [UserDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:jsonData] forKey:kWeekendKey];
                [UserDefault synchronize];
            }
        }
    }];
}
#pragma mark - API RecetCourse
-(void) getRecentViewedCourse // It's new couese change later by client so name keep recent
{
    if (![self isNetAvailable])
    {
        NSData *data = [UserDefault objectForKey:kRecentKey];
        if (data)
        {
            NSDictionary *jsonData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [self parseRecentCourse:jsonData];
        }
    }else {
        NSString *url = [NSString stringWithFormat:@"http://myhobbycourses.com/myhobbycourses_endpoint/%@%@/all/all/created/desc",apiTop50Url,APPDELEGATE.selectedCity];
        [self startActivity];
        [[NetworkManager sharedInstance] getRequestUrl:url paramter:nil isToken:NO withCallback:^(id jsonData, WebServiceResult result) {
            if (result == WebServiceResultSuccess) {
                [self parseRecentCourse:jsonData];
                if ([jsonData isKindOfClass:[NSArray class]]) {
                    [UserDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:jsonData] forKey:kRecentKey];
                    [UserDefault synchronize];
                }
            }
            [self getDicountPriceCourse];
            
        }];
    }
}
-(void) parseRecentCourse:(id) jsonData
{
    if ([jsonData isKindOfClass:[NSArray class]])
    {
        [arrRecentCourse removeAllObjects];
        for(NSDictionary *dict in jsonData)
        {
            NSMutableDictionary *d = [dict mutableCopy];
            [d handleNullValue];
            CourseDetail *entity = [[CourseDetail alloc]initWith:d];
            [arrRecentCourse addObject:entity];
        }
        [tblParent reloadData];
    }
    
}
#pragma mark - API Fav
-(void) getDicountPriceCourse
{
    [[NetworkManager sharedInstance] getRequestUrl:[NSString stringWithFormat:@"http://myhobbycourses.com/myhobbycourses_endpoint/%@%@/all/all/price/desc",apiTop50Url,APPDELEGATE.selectedCity] paramter:nil isToken:NO withCallback:^(id jsonData, WebServiceResult result) {
        if (result == WebServiceResultSuccess) {
            if ([jsonData isKindOfClass:[NSArray class]])
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [arrFavCourse removeAllObjects];
                    for(NSDictionary *dict in jsonData)
                    {
                        NSMutableDictionary *d = [dict mutableCopy];
                        [d handleNullValue];
                        CourseDetail *entity = [[CourseDetail alloc]initWith:d];
                        [arrFavCourse addObject:entity];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [tblParent reloadData];
                        [self stopActivity];
                    });
                });
            }else{
                [self stopActivity];
            }
            [self getWeekendCourses];
            [self getEveningsCourses];
        }
    }];
}
#pragma mark - API Category

-(void) fetchCategoryList
{
    if (![self isNetAvailable]){
        [self offlineCategory];
        return;
    }
    
    [[NetworkManager sharedInstance] postRequestUrl:apiCategorylistUrl paramter:@{@"city":(_isStringEmpty(APPDELEGATE.selectedCity)) ? @"London" : APPDELEGATE.selectedCity } withCallback:^(id jsonData, WebServiceResult result) {
        if (result == WebServiceResultSuccess) {
            
            if ([jsonData isKindOfClass:[NSArray class]]) {
                [_arrCategoryC removeAllObjects];
                for (NSDictionary *dict in jsonData) {
                    CategoryEntity *entity = [[CategoryEntity alloc] initWithDictionary:dict];
                    [CategoryTbl insertCategory:entity];
                    [_arrCategoryC addObject:entity];
                }
                if (_arrCategoryC.count > 1) {
                    [UserDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:jsonData] forKey:kCategoryKey];
                    [UserDefault synchronize];
                    
                }
                [tblCategory reloadData];
                [cvSubCategory reloadData];
            }
        }
    }];
}

-(void) offlineCategory
{
    NSData *data = [UserDefault objectForKey:kCategoryKey];
    if (data) {
        NSArray *arrCat = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        for (NSDictionary *dict in arrCat) {
            CategoryEntity *entity = [[CategoryEntity alloc]initWithDictionary:dict];
            [_arrCategoryC addObject:entity];
        }
    }
}
#pragma mark - UITableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tblParent == tableView) {
        return 6;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ((indexPath.section == 0 || indexPath.section == 2) && tblParent == tableView) {
        return 480 * _widthRatio;
    }else if (indexPath.section == 1  && tblParent == tableView) {
        return 350 * _widthRatio;
    }else if ((indexPath.section == 5 || indexPath.section == 4 || indexPath.section == 3) && tblParent == tableView) {
        return 300 * _widthRatio;
    }
    return UITableViewAutomaticDimension;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tblParent == tableView) {
        switch (section) {
            case 0:
                return (arrCourse.count > 0) ? 1 : 0;
            case 1:
                return (arrRecentCourse.count > 0) ? 1 : 0;
            case 2:
                return (arrFavCourse.count > 0) ? 1 : 0;
            case 3:
                return (arrWeekend.count > 0) ? 1 : 0;
            case 4:
                return (arrEvenings.count > 0) ? 1 : 0;
            case 5:
                return 1;
            default:
                break;
        }
    }
    return _arrCategoryC.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblParent) {
        CourseListingCell * cell;
        switch (indexPath.section) {
            case 0:
                cell = [tableView dequeueReusableCellWithIdentifier:@"CellPopuler" forIndexPath:indexPath];
                cell.controller = self;
                [cell.cvPopuler reloadData];
                break;
            case 1:
                cell = [tableView dequeueReusableCellWithIdentifier:@"CellRecent" forIndexPath:indexPath];
                cell.controller = self;
                [cell.cvRecent reloadData];
                
                break;
            case 2:
                cell = [tableView dequeueReusableCellWithIdentifier:@"CellFav" forIndexPath:indexPath];
                cell.controller = self;
                [cell.cvFavourites reloadData];
                break;
            case 3:
                cell = [tableView dequeueReusableCellWithIdentifier:@"CellWeek" forIndexPath:indexPath];
                cell.controller = self;
                [cell.cvWeek reloadData];
                
                break;
            case 4:
                cell = [tableView dequeueReusableCellWithIdentifier:@"CellEvening" forIndexPath:indexPath];
                cell.controller = self;
                [cell.cvEvening reloadData];
                break;
            case 5:
                cell = [tableView dequeueReusableCellWithIdentifier:@"CellInvite" forIndexPath:indexPath];
                break;
            default:
                break;
        }
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellCategory" forIndexPath:indexPath];
        UILabel *lblCategory = [cell viewWithTag:31];
        if (indexPath.row == 0) {
            lblCategory.text = @"Top Courses";
        }else{
            lblCategory.text = _arrCategoryC[indexPath.row -1].category;
        }
        return cell;
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblCategory) {
            if (indexPath.row == 0) {
                [self hideshowTables:true];
                selectedIndex = indexPath.row;
                [btnCategory setTitle:@"All Courses" forState:UIControlStateNormal];
                
            }else{
                selectedIndex = indexPath.row;
                CategoryEntity *catEnt =  _arrCategoryC[selectedIndex -1];
                [btnCategory setTitle:catEnt.category forState:UIControlStateNormal];
                [UIView animateWithDuration:0.25 animations:^{
                    tblParent.alpha = 0.0;
                    cvSubCategory.alpha = 1.0;
                    
                }];
                [cvSubCategory reloadData];
            }
        
        _categoryHeight.constant = 0;
    }
}
#pragma mark - UICollection View
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (selectedIndex != 0)
    {
        CategoryEntity *catEnt =  _arrCategoryC[selectedIndex - 1];
        return catEnt.subCategories.count;
    }
    return 0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 15, 10, 15);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.view.frame.size.width - 40)/2,(self.view.frame.size.width - 40)/2);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    UIImageView *img = [cell viewWithTag:91];
    UILabel *lbl = [cell viewWithTag:92];
    CategoryEntity *catEnt =  _arrCategoryC[selectedIndex - 1];
    SubCategoryEntity *ent = catEnt.subCategories[indexPath.row];
    lbl.text =[NSString stringWithFormat:@"%@ (%@)",ent.subCategory,ent.course_count];
    
    [img sd_setImageWithURL:[NSURL URLWithString:ent.image]
           placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5].CGColor;
    cell.layer.borderWidth = 0.5;
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 10;
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryEntity *catEnt =  _arrCategoryC[selectedIndex - 1];
    SubCategoryEntity *subCateogory = catEnt.subCategories[indexPath.row];
    if ([subCateogory.course_count intValue] > 0) {
        CategoryCoursesVC *vc = [getStoryBoardDeviceBased(StoryboardLearnerMain) instantiateViewControllerWithIdentifier:@"CategoryCoursesVC"];
        vc.category = catEnt.category;
        vc.subCategory = subCateogory.subCategory;
        [self.navigationController pushViewController:vc animated:true];
    }
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.destinationViewController isKindOfClass:[CourseDetailsVC class]]) {
        CourseDetailsVC *vc = segue.destinationViewController;
        vc.NID = self.courseNID;
        vc.similerCourses = arrRecentCourse;
//        vc.imgVSource = [[NSData alloc]initWithData:UIImageJPEGRepresentation([self animationImgView].image, 1.0)];
    }else if ([segue.identifier isEqualToString:@"segueMap"]){
        CourseLocationViewController * vc = segue.destinationViewController;
        vc.arrayCourseList = arrCourse;
    }else if ([segue.identifier isEqualToString:@"segueVendor"]){
        VendorProfileVC *vc = segue.destinationViewController;
        vc.uid = sender;
    }
}

-(UIImageView*) animationImgView{
    CourseListingCell *cell = [tblParent cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.selectedSection]];
    UICollectionViewCell *collCell;
    switch (self.selectedSection) {
        case 0:
            collCell = [cell.cvPopuler cellForItemAtIndexPath:self.selectedIndexPath];
            break;
        case 1:
            collCell = [cell.cvRecent cellForItemAtIndexPath:self.selectedIndexPath];
            break;
        case 2:
            collCell = [cell.cvFavourites cellForItemAtIndexPath:self.selectedIndexPath];
            break;
        case 3:
            collCell = [cell.cvWeek cellForItemAtIndexPath:self.selectedIndexPath];
            break;
        case 4:
            collCell = [cell.cvEvening cellForItemAtIndexPath:self.selectedIndexPath];
            break;
    }
    UIImageView *imgV = [collCell viewWithTag:11];
    return imgV;
}

#pragma mark - UINavigationControllerDelegate Methods

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    // Sanity
    if (fromVC != self && toVC != self) return nil;
    
    if(([fromVC isKindOfClass:[CourseDetailsVC class]] || [toVC isKindOfClass:[CourseDetailsVC class]]) && isFromQR == false){
        // Determine if we're presenting or dismissing
        ZOTransitionType type = (fromVC == self) ? ZOTransitionTypePresenting : ZOTransitionTypeDismissing;
        
        // Create a transition instance with the selected cell's imageView as the target view
        ZOZolaZoomTransition *zoomTransition = [ZOZolaZoomTransition transitionFromView:[self animationImgView]
                                                                                   type:type
                                                                               duration:0.35
                                                                               delegate:self];
        zoomTransition.fadeColor = self.view.backgroundColor;
        return zoomTransition;
    }else{
        return nil;
    }
}
#pragma mark - ZOZolaZoomTransitionDelegate Methods

- (CGRect)zolaZoomTransition:(ZOZolaZoomTransition *)zoomTransition
        startingFrameForView:(UIView *)targetView
              relativeToView:(UIView *)relativeView
          fromViewController:(UIViewController *)fromViewController
            toViewController:(UIViewController *)toViewController {
    
    if (fromViewController == self) {
        // We're pushing to the detail controller. The starting frame is taken from the selected cell's imageView.
        return [[self animationImgView] convertRect:[self animationImgView].bounds toView:relativeView];
    } else if ([fromViewController isKindOfClass:[CourseDetailsVC class]]) {
        // We're popping back to this master controller. The starting frame is taken from the detailController's imageView.
        CourseDetailsVC *detailController = (CourseDetailsVC *)fromViewController;
        return [detailController.mainImageView convertRect:detailController.mainImageView.bounds toView:relativeView];
    }
    
    return CGRectZero;
}

- (CGRect)zolaZoomTransition:(ZOZolaZoomTransition *)zoomTransition
       finishingFrameForView:(UIView *)targetView
              relativeToView:(UIView *)relativeView
          fromViewController:(UIViewController *)fromViewController
            toViewController:(UIViewController *)toViewController {
    
    if (fromViewController == self && [toViewController isKindOfClass:[CourseDetailsVC class]]) {
        // We're pushing to the detail controller. The finishing frame is taken from the detailController's imageView.
        CourseDetailsVC *detailController = (CourseDetailsVC *)toViewController;
        return [detailController.mainImageView convertRect:detailController.mainImageView.bounds toView:relativeView];
    } else if ([fromViewController isKindOfClass:[CourseDetailsVC class]]) {
        // We're popping back to this master controller. The finishing frame is taken from the selected cell's imageView.
        return [[self animationImgView] convertRect:[self animationImgView].bounds toView:relativeView];
    }
    
    return CGRectZero;
}

@end
