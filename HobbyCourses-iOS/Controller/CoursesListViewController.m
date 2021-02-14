//
//  CoursesListViewController.m
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/13/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import "CoursesListViewController.h"
#import "CourseTableViewCell.h"

#import "CourseLocationViewController.h"

@interface CoursesListViewController ()<CourseTableViewCellProtocol>
{
    NSMutableArray *arrCategory;
    NSArray *arrFilter;
    NSIndexPath *selectedCatIndex;
    NSString *selectedSubCategory;
    int selectedIndex;
    NSTimer *timer;
    int refreshCount;
    BOOL isCommentClciked;
    NSMutableArray *arrayCourseListData;
    int pageIndex;
    UIRefreshControl *refreshPull;
    IBOutlet UITableView *tblFilter;
    NSString *tempSortBy;
    __weak IBOutlet NSLayoutConstraint *NSLeadingtblFilter;
}
@end

@implementation CoursesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWidget];
    [self initData];
    selectedIndex = 0;
    pageIndex = 0;
    tempSortBy = @"0";
    [[MyLocationManager sharedInstance] getCurrentLocation];
    refreshCount = 0 ;
    NSLeadingtblFilter.constant = _screenSize.width * 2;
    if ([UserDefault stringForKey:kSelectedCity]) {
        APPDELEGATE.selectedCity = [UserDefault stringForKey:kSelectedCity];
    }
    if ([APPDELEGATE.selectedCity isEqualToString:@""]) {
        [self performSelector:@selector(presentCityPopUpView:) withObject:false afterDelay:0.8];
        
    } else {
        [self getCategoryApi];
        [self performSelector:@selector(getCourseTop50Course:) withObject:self afterDelay:0.2];
    }
    
    if (![self checkStringValue:APPDELEGATE.deviceTokenReg])
    {
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
    
    refreshPull = [[UIRefreshControl alloc]init];
    [tblCourseList addSubview:refreshPull];
    [refreshPull setTintColor:[UIColor whiteColor]];
    [refreshPull addTarget:self action:@selector(getCourseTop50Course:) forControlEvents:UIControlEventValueChanged];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:true];
    
    [self startTimer];
    isCommentClciked = false;
    if (is_iPad()) {
        self.navigationItem.hidesBackButton = YES;
    }
    [self updateToGoogleAnalytics:@"Home screen Top5oCourse"];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [self stopTimer];
}

- (void) initWidget {
    [self.navigationItem setHidesBackButton:YES];
    self.navigationController.navigationBarHidden = NO;
    viewCategory.hidden = YES;
    btnCategorySelection.titleLabel.numberOfLines = 0;
}

- (void) initData {
    arrData = [[NSMutableArray alloc]init];
    arrayCourseListData = [[NSMutableArray alloc]init];
    arrCategory = [[NSMutableArray alloc]init];
    arrFilter = [[NSArray alloc]initWithObjects:@"Price (Highest)",@"Price (Lowest)",@"Newly Uploaded",@"Earlier Uploaded",@"Most Voted",@"Least Voted",@"Most Reviewed",@"Least Reviewed", nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveUpdateCity:)
                                                 name:@"receiveUpdateCity"
                                               object:nil];
    
    
}
-(void) receiveUpdateCity:(NSNotification*)notification
{
    if ([APPDELEGATE.selectedCity containsString:@"("]) {
        NSRange range = [APPDELEGATE.selectedCity rangeOfString:@"("];
        NSString *shortString = [APPDELEGATE.selectedCity substringToIndex:range.location];
        APPDELEGATE.selectedCity = shortString;
    }
    [arrCategory removeAllObjects];
    [self getCategoryApi];
    [self getCourseTop50Course:nil];
    [UserDefault setValue:APPDELEGATE.selectedCity forKey:kSelectedCity];
    
}
-(void) offlineCategory
{
    NSData *data = [UserDefault objectForKey:kCategoryKey];
    if (data)
    {
        NSArray *arrCat = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        for (NSDictionary *dict in arrCat)
        {
            CategoryEntity *entity = [[CategoryEntity alloc]initWithDictionary:dict];
            [arrCategory addObject:entity];
        }
        [tblCategoryList reloadData];
    }
}
#pragma mark Api call
-(void) getCategoryApi
{
    if(arrCategory.count > 0)
    {return;}
    
    if (![self isNetAvailable])
    {
        [self offlineCategory];
        return;
    }
    [[NetworkManager sharedInstance] postRequestUrl:apiCategorylistUrl paramter:@{@"city":APPDELEGATE.selectedCity} withCallback:^(id jsonData, WebServiceResult result) {
        if (result == WebServiceResultSuccess)
        {
            if ([jsonData isKindOfClass:[NSArray class]])
            {
                for (NSDictionary *dict in jsonData)
                {
                    CategoryEntity *entity = [[CategoryEntity alloc] initWithDictionary:dict];
                    [arrCategory addObject:entity];
                }
                if (arrCategory.count > 1)
                {
                    [UserDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:jsonData] forKey:kCategoryKey];
                    [UserDefault synchronize];
                    
                }
                [collectView reloadData];
                [tblCategoryList reloadData];
            }
        }else
        {
            showAletViewWithMessage(kFailAPI);
        }
    }];
}

-(void) getCourseTop50Course:(NSString*) endUrl
{
    if (![self isNetAvailable])
    {
        [self getTop50offlineCourse];
        return;
    }
    [self startActivity];
    //tblCourseList.hidden = true;
    
    NSString *url;
    if ([endUrl isKindOfClass:[NSString class]]) {
        url = [NSString stringWithFormat:@"http://myhobbycourses.com/myhobbycourses_endpoint/%@%@/all/all/%@",apiTop50Url,APPDELEGATE.selectedCity,endUrl];
    }else{
        url = [NSString stringWithFormat:@"http://myhobbycourses.com/myhobbycourses_endpoint/%@%@/all/all/%@",apiTop50Url,APPDELEGATE.selectedCity,[self getSortCourseUrl]];
    }
    NSLog(@"URL:%@",url);
    
    [[NetworkManager sharedInstance] getRequestUrl:url paramter:nil isToken:NO withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        [refreshPull endRefreshing];
        if (result == WebServiceResultSuccess)
        {
            tblCourseList.hidden =false;
            if ([jsonData isKindOfClass:[NSArray class]])
            {
                NSArray *arr = jsonData;
                if (arr.count > 0) {
                    [arrData removeAllObjects];
                }
                
                for (NSDictionary *dict in jsonData)
                {
                    NSMutableDictionary *d = [dict mutableCopy];
                    [d handleNullValue];
                    
                    CourseDetail *courseEnt = [[CourseDetail alloc]initWith:d];
                    [arrData addObject:courseEnt];
                }
                
                if (arrData.count> 0)
                {
                    [UserDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:jsonData] forKey:kCourseListKey];
                    [UserDefault synchronize];
                    [arrayCourseListData removeAllObjects];
                    [arrayCourseListData addObjectsFromArray:arrData];
                    [tblCourseList reloadData];
                    
                }else
                {
                    [self retryCity];
                }
                
            }
        }
        else
        {
            showAletViewWithMessage(kFailAPI);
        }
    }];
    
}
-(void) getTop50offlineCourse
{
    NSData *data = [UserDefault objectForKey:kCourseListKey];
    if (data)
    {
        NSArray *jsonData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([jsonData isKindOfClass:[NSArray class]])
        {
            [arrData removeAllObjects];
            for (NSDictionary *dict in jsonData)
            {
                NSMutableDictionary *d = [dict mutableCopy];
                [d handleNullValue];
                
                CourseDetail *courseEnt = [[CourseDetail alloc]initWith:d];
                [arrData addObject:courseEnt];
            }
            [arrayCourseListData addObjectsFromArray:arrData];
            [tblCourseList reloadData];
        }else
        {
            showAletViewWithMessage(@"No Course found,Please select different city.");
        }
    }
    [refreshPull endRefreshing];
}
-(void) getCourseApi // user when category select
{
    pageIndex = pageIndex + 1;
    CategoryEntity *catEnt =  arrCategory[selectedIndex - 1];
    [self startActivity];
    
    NSDictionary *dict = @{@"city":APPDELEGATE.selectedCity,@"category":catEnt.category,@"sorting":APPDELEGATE.sortCourseBy,@"sub_category":selectedSubCategory,@"form":@"1",@"page":[NSString stringWithFormat:@"%d",pageIndex]};
    
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
                    if (pageIndex == 1) {
                        [arrData removeAllObjects];
                    }
                    
                    NSMutableArray * courseArr = [[NSMutableArray alloc]init];
                    for (NSDictionary *dict in arr)
                    {
                        if ([dict isKindOfClass:[NSDictionary class]])
                        {
                            Course *courseEnt = [[Course alloc]initWith:dict];
                            [arrData addObject:courseEnt];
                        }
                    }
                    if (courseArr.count > 0) {
                        showAletViewWithMessage(@"No course found.");
                    }
                    
                    if (arrData.count < 10) {
                        pageIndex = -1;
                    }
                    [tblCourseList reloadData];
                    tblCourseList.alpha = 1.0;
                    collectView.alpha = 0.0;
                }
            }
        }else
        {
            pageIndex = pageIndex - 1;
            showAletViewWithMessage(@"No Course found,Please try again.");
        }
    }];
}
-(void) retryCity
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:kAppName
                                  message:@"There is not course for selected city,Please try different location."
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* delete = [UIAlertAction
                             actionWithTitle:@"YES"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self presentCityPopUpView:NO];
                                 
                             }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"NO"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    [alert addAction:delete];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -
-(void) updateTimer
{
    NSInteger count = [tblCourseList indexPathsForVisibleRows].count;
    
    if (refreshCount < count && arrData.count > 0)
    {
        
        NSIndexPath *indexPath =[NSIndexPath indexPathForItem:[[tblCourseList indexPathsForVisibleRows] objectAtIndex:refreshCount].row inSection:0];
        
        CourseTableViewCell *cell = [tblCourseList cellForRowAtIndexPath:indexPath];
        id data = [arrData objectAtIndex:indexPath.row];
        if ([data isKindOfClass:[CourseDetail class]]) {
            
            
            CourseDetail * course = [arrData objectAtIndex:indexPath.row];
            
            if (course.currentPage * self.view.frame.size.width >= course.field_deal_image.count * self.view.frame.size.width)
            {
                course.currentPage = 0;
                CGPoint offset = CGPointMake(course.currentPage * self.view.frame.size.width, 0);
                [cell.imgScroll setContentOffset:offset];
                
            }else{
                CGPoint offset = CGPointMake(course.currentPage * self.view.frame.size.width, 0);
                
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
#pragma mark- Filter Method
- (IBAction)btnOpenCitySelction:(UIButton*)sender {
    [self presentCityPopUpView:true];
}
- (IBAction)btnFilterAction:(UIButton*)sender
{
    if (NSLeadingtblFilter.constant == 0)
    {
        [UIView animateWithDuration:0.25 animations:^{
            NSLeadingtblFilter.constant = _screenSize.width * 2;
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
    APPDELEGATE.sortCourseBy = tempSortBy;
    
    [self getCourseTop50Course:[self getSortCourseUrl]];
    [UIView animateWithDuration:0.25 animations:^{
        NSLeadingtblFilter.constant = _screenSize.width * 2;
        [self.view layoutIfNeeded];
    }];
}
-(NSString*) getSortCourseUrl {
    if ([arrFilter[tempSortBy.integerValue] isEqualToString:@"Newly Uploaded"] ) {
        return @"created/desc";
    }else if([arrFilter[tempSortBy.integerValue] isEqualToString:@"Earlier Uploaded"] ) {
        return @"created/asc";
    }else if([arrFilter[tempSortBy.integerValue] isEqualToString:@"Most Reviewed"] ) {
        return @"reviews/desc";
    }else if([arrFilter[tempSortBy.integerValue] isEqualToString:@"Least Reviewed"] ) {
        return @"reviews/asc";
    }else if([arrFilter[tempSortBy.integerValue] isEqualToString:@"Price (Highest)"] ) {
        return @"price/desc";
    }else if([arrFilter[tempSortBy.integerValue] isEqualToString:@"Price (Lowest)"] ) {
        return @"price/asc";
    }else if([arrFilter[tempSortBy.integerValue] isEqualToString:@"Most Voted"] ) {
        return @"vote/desc";
    }else if([arrFilter[tempSortBy.integerValue] isEqualToString:@"Least Voted"] ) {
        return @"vote/asc";
    }
    return nil;
}

#pragma mark - pop up screen

-(void) presentCityPopUpView:(BOOL)flag
{
    SelectCityViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectCityViewController"];
    vc.view.backgroundColor = [UIColor clearColor];
    vc.isShowbtn = flag;
    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:vc animated:NO completion:nil];
    [vc getCityBlock:^(NSString *anyValue) {
        [self receiveUpdateCity:nil];
    }];
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return NO;
}

#pragma mark - tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tblCategoryList)
    {
        return arrCategory.count + 1;
    }
    if(tableView == tblFilter)
    {
        return arrFilter.count;
    }
    return [arrData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblCategoryList)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        UILabel *lblCat = [cell viewWithTag:3];
        UIImageView *img = [cell viewWithTag:4];
        if (indexPath.row == 0 ) {
            lblCat.text = @"Top Courses";
            img.image = [UIImage imageNamed:@"ic_All_category"];
        }else{
            CategoryEntity *ent = arrCategory[indexPath.row - 1];
            lblCat.text = ent.category;
            [img sd_setImageWithURL:[NSURL URLWithString:ent.image] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        }
        if (selectedIndex == indexPath.row)
        {
            cell.backgroundColor = [UIColor colorWithRed:254.0/255.0f green:52.0/255.0f blue:128.0/255.0f alpha:1.0]; ;
        }else {
            cell.backgroundColor = [UIColor clearColor];
        }
        return cell;
    }else if (tableView == tblFilter)
    {
        // Filter table
        SelectCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectCityTableViewCell"];
        cell.lblCity.text = arrFilter[indexPath.row];
        if (tempSortBy.integerValue == indexPath.row)
        {
            cell.btnSelection.selected = true;
            
        }else
        {
            cell.btnSelection.selected = false;
        }
        return cell;
    }
    else
    {
        CourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseTableViewCell"];
        cell.delegate = self;
        
        id data =[arrData objectAtIndex:indexPath.row];
        if ([data isKindOfClass:[Course class]])
        {
            Course* course = [arrData objectAtIndex:indexPath.row];
            [cell setData:course customCell:cell isscroll:true ];
        }else{
            CourseDetail* courseDetail = [arrData objectAtIndex:indexPath.row];
            [cell setData:courseDetail customCell:cell];
            
        }
        cell.imgScroll.userInteractionEnabled = NO;
        [cell.contentView addGestureRecognizer:cell.imgScroll.panGestureRecognizer];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == tblCategoryList)
    {
        if (selectedCatIndex != indexPath)
        {
            if (indexPath.row == 0) {
                [self btnHome:nil];
                selectedIndex = indexPath.row;
            }else{
                selectedCatIndex = indexPath;
                selectedIndex = indexPath.row;
                CategoryEntity *catEnt =  arrCategory[selectedIndex -1];
                [btnCategorySelection setTitle:catEnt.category forState:UIControlStateNormal];
                [UIView animateWithDuration:0.25 animations:^{
                    tblCourseList.alpha = 0.0;
                    collectView.alpha = 1.0;
                    
                }];
                [tableView reloadData];
                [collectView reloadData];
            }
        }
        viewCategory.hidden = YES;
        
    }else if(tableView == tblFilter)
    {
        tempSortBy = [NSString stringWithFormat:@"%d",indexPath.row];
        [tblFilter reloadData];
    }
    else{
        [self performSegueWithIdentifier:@"course_detail" sender:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblCategoryList) {
        return 85;
    }
    if (tableView == tblFilter) {
        return UITableViewAutomaticDimension;
    }
    return 190 * _heighRatio;
}

#pragma mark - UICollectionView delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == collectView)
    {
        if (selectedIndex != 0)
        {
            CategoryEntity *catEnt =  arrCategory[selectedIndex - 1];
            return catEnt.subCategories.count;
        }
        return 0;
    }
    return 6;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == collectView)
    {
        return CGSizeMake(self.view.frame.size.width/2, self.view.frame.size.width/2);
    }
    return CGSizeMake(self.view.frame.size.width, collectionView.frame.size.height);
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == collectView)
    {
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        UIImageView *img = [cell viewWithTag:91];
        UILabel *lbl = [cell viewWithTag:92];
        CategoryEntity *catEnt =  arrCategory[selectedIndex - 1];
        SubCategoryEntity *ent = catEnt.subCategories[indexPath.row];
        lbl.text =[NSString stringWithFormat:@"%@ (%@)",ent.subCategory,ent.course_count];
        
        [img sd_setImageWithURL:[NSURL URLWithString:ent.image]
               placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        
        return cell;
    }else{
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellImg" forIndexPath:indexPath];
        UIImageView *img = [cell viewWithTag:11];
        if (indexPath.row %2 == 0)
        {
            //@[@"course_news2.png",@"course_news3.png",@"course_news1.png"].
            img.image = [UIImage imageNamed:@"course_news2.png"];
        }else
        {
            img.image = [UIImage imageNamed:@"course_news1.png"];
        }
        
        return cell;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView == collectView)
    {
        CategoryEntity *catEnt =  arrCategory[selectedIndex - 1];
        SubCategoryEntity *ent = catEnt.subCategories[indexPath.row];
        if([ent.course_count integerValue] > 0)
        {
            pageIndex = 0;
            selectedSubCategory = ent.subCategory;
            [self getCourseApi];
        }
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (scrollView == tblCategoryList || scrollView == tblFilter || scrollView == collectView) {
        return;
    }
    
    [self startTimer];
    // UITableView only moves in one direction, y axis
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    //NSInteger result = maximumOffset - currentOffset;
    
    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= 5.0 && pageIndex > 0)
    {
        [self getCourseApi];
    }
}
-(void) startTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    NSLog(@"%s",__PRETTY_FUNCTION__);
    
}
-(void) stopTimer
{
    [timer invalidate];
    timer = nil;
    NSLog(@"%s",__PRETTY_FUNCTION__);
    
}
#pragma mark - IBActions

- (IBAction)onCategory:(id)sender
{
    if (arrCategory.count==0)
    {
        [self getCategoryApi];
        
    }
    viewCategory.hidden = !viewCategory.hidden;
}

-(IBAction)btnHome:(id)sender
{
    if (collectView.alpha == 0.0 && arrData.count == arrayCourseListData.count) {
        return;
    }
    pageIndex = 0;
    [arrData removeAllObjects];
    [arrData addObjectsFromArray:arrayCourseListData];
    [tblCourseList reloadData];
    viewCategory.hidden = true;
    [btnCategorySelection setTitle:@"All Category" forState:UIControlStateNormal];
    [UIView animateWithDuration:0.25 animations:^{
        tblCourseList.alpha = 1.0;
        collectView.alpha = 0.0;
        
    }];
}
-(IBAction)btnMapPin:(id)sender
{
    if ([MyLocationManager sharedInstance].CurrentLocation != nil)
    {
        [self performSegueWithIdentifier:@"MapScreen" sender:self];
    }else{
        showAletViewWithMessage(@"Silly Satellites…GPS was not able to receive your current location");
    }
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"%s : segue.identifier : %@",__PRETTY_FUNCTION__,segue.identifier);
    
    if ([segue.identifier isEqualToString:@"course_detail"])
    {
        CourseDetailViewController *vc =(CourseDetailViewController *) segue.destinationViewController;
        NSIndexPath *path = (NSIndexPath*) sender;
        id data = [arrData objectAtIndex:path.row];
        if ([data isKindOfClass:[CourseDetail class]])
        {
            CourseDetail *course = [arrData objectAtIndex:path.row];
            vc.NID = course.nid;
            
        }else
        {
            Course *course = [arrData objectAtIndex:path.row];
            vc.NID = course.nid;
        }
        if (isCommentClciked) {
            vc.isGoComment = true;
        }else{
            vc.isGoComment = false;
        }
        
        vc.arrLocalViewed = arrData;
        
    }else if([segue.identifier isEqualToString:@"GoToFilterCourse"])
    {
        FilterCourseListVC *vc =(FilterCourseListVC *) segue.destinationViewController;
        NSIndexPath *path = (NSIndexPath*) sender;
        CategoryEntity *catEnt =  arrCategory[selectedIndex - 1];
        SubCategoryEntity *ent = catEnt.subCategories[path.row];
        vc.category = catEnt.category;
        vc.subCategory = ent.subCategory;
    }else if ([segue.identifier isEqualToString:@"MapScreen"]){
        
        CourseLocationViewController *mapViewController = segue.destinationViewController;
        mapViewController.arrayCourseList = [[NSMutableArray alloc] initWithArray:arrData];
        //        mapViewController.selectedCourse = [arrayCourseListData firstObject];
    }
}

#pragma mark - Course TableView Cell delegate
-(void) btnLocationButtonTapped:(CourseTableViewCell *)cell{
    
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:kAppName
                                  message:@"Do you want to see location in google maps?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yes = [UIAlertAction
                          actionWithTitle:@"YES"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action)
                          {
                              NSIndexPath *indexPath = [tblCourseList indexPathForCell:cell];
                              CourseLocationViewController *mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CourseLocationViewController"];
                              mapViewController.arrayCourseList = arrData;
                              mapViewController.selectedCourse = arrData[indexPath.row];
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
-(void) btnCommentBtnTapped:(CourseTableViewCell *)cell
{
    NSIndexPath *indexPath = [tblCourseList indexPathForCell:cell];
    isCommentClciked = true;
    [self performSegueWithIdentifier:@"course_detail" sender:indexPath];
}

@end
