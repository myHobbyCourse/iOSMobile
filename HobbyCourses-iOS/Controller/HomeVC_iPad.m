//
//  HomeVC_iPad.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 24/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "HomeVC_iPad.h"

#import "CourseTableViewCell.h"

#import "CourseLocationViewController.h"
@interface HomeVC_iPad ()<CourseCVCellProtocol>
{
    NSMutableArray *arrCategory;
    NSArray *arrFilter;
    int selectedIndex;
    NSTimer *timer;
    int refreshCount;
    BOOL isCommentClciked;
    NSArray *arrayCourseListData;
    int pageIndex;
    NSString *selectedSubCategory;
    NSMutableDictionary *filterDict;
    NSString *searchForword;
    IBOutlet NSLayoutConstraint * tblSubCategoryWidth;
    IBOutlet UITextField *tfSearchKeyword;
    IBOutlet UIImageView *imgPopBG;
    IBOutlet UITableView *tblFilter;
    __weak IBOutlet NSLayoutConstraint *NSLeadingtblFilter;
    
    UIRefreshControl *refreshPull;
    NSString *tempSortBy;
}
@end

@implementation HomeVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    selectedIndex = 0;
    
    [self initWidget];
    [self initData];
    tempSortBy = @"0";
    [[MyLocationManager sharedInstance] getCurrentLocation];
    
    refreshCount = 0 ;
    pageIndex = 0;
    tblSubCategoryWidth.constant = 0;
    NSLeadingtblFilter.constant = _screenSize.width * 2;
    if ([UserDefault stringForKey:kSelectedCity]) {
        APPDELEGATE.selectedCity = [UserDefault stringForKey:kSelectedCity];
    }

    if ([APPDELEGATE.selectedCity isEqualToString:@""]) {
        [self performSelector:@selector(presentCityPopUpView:) withObject:false afterDelay:0.8];
    }else
    {
        [self getCategoryApi];
        [self performSelector:@selector(getCourseTop50Course:) withObject:self afterDelay:0.2];
        imgPopBG.hidden = true;
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
    [collectView addSubview:refreshPull];
    [refreshPull setTintColor:[UIColor blackColor]];
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
    [self.view layoutSubviews];
    [self updateToGoogleAnalytics:@"Home Screen Top5oCourse"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidDisappear:(BOOL)animated
{
    [[SDImageCache sharedImageCache] clearMemory];
    //    [[SDImageCache sharedImageCache] clearDisk];
    [self stopTimer];
}

- (void) initWidget {
    [self.navigationItem setHidesBackButton:YES];
    self.navigationController.navigationBarHidden = NO;
    btnCategorySelection.titleLabel.numberOfLines = 0;
}

- (void) initData {
    arrData = [[NSMutableArray alloc]init];
    arrCategory = [[NSMutableArray alloc]init];
    arrFilter = [[NSArray alloc]initWithObjects:@"Newly Uploaded",@"Earlier Uploaded",@"Most Voted",@"Least Voted",@"Most Reviewed",@"Least Reviewed",@"Price (Highest)",@"Price (Lowest)", nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveUpdateCity:)
                                                 name:@"receiveUpdateCity"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(searchCourse:)
                                                 name:@"searchCourse"
                                               object:nil];
    
    tblCategoryList.tableFooterView = [[UIView alloc]init];
    tblsubCategory.tableFooterView = [[UIView alloc]init];
    if (is_iPad()) {
        self.navigationItem.hidesBackButton = YES;
        
    }
    
    
}
-(void) searchCourse:(NSNotification*)notification
{
    [self stopTimer];
    filterDict = notification.object;
    pageIndex = 0;
    [self getCourseApi:filterDict];
    searchForword = notification.userInfo[@"search"];
}
-(void) receiveUpdateCity:(NSNotification*)notification
{
    if ([APPDELEGATE.selectedCity containsString:@"("]) {
        NSRange range = [APPDELEGATE.selectedCity rangeOfString:@"("];
        NSString *shortString = [APPDELEGATE.selectedCity substringToIndex:range.location];
        APPDELEGATE.selectedCity = shortString;
    }
    [btnCategorySelection setTitle:APPDELEGATE.selectedCity forState:UIControlStateNormal];
    [arrCategory removeAllObjects];
    [self hideTblSubCateogry];
    selectedIndex = 0;
    [tblCategoryList reloadData];
    [tblsubCategory reloadData];
    [self getCategoryApi];
    [self getCourseTop50Course:nil];
    imgPopBG.hidden = true;
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
    }else{
        showAletViewWithMessage(kFailAPI);
    }
}
-(void) showTblSubCateogry
{
    dispatch_async(dispatch_get_main_queue(), ^(){
        
        [UIView animateWithDuration:0.2 animations:^{
            tblSubCategoryWidth.constant = 185;
            [self.view layoutIfNeeded];
        } completion:nil];
        
    });
}
-(void) hideTblSubCateogry
{
    dispatch_async(dispatch_get_main_queue(), ^(){
        [UIView animateWithDuration:0.2 animations:^{
            tblSubCategoryWidth.constant = 0;
            [self.view layoutIfNeeded];
        } completion:nil];
        
    });
    
}
-(void) hideShowTbl
{
    dispatch_async(dispatch_get_main_queue(), ^(){
        
        if (tblSubCategoryWidth.constant == 185)
        {
            [UIView animateWithDuration:0.2 animations:^{
                tblSubCategoryWidth.constant = 0;
                [self.view layoutIfNeeded];
            } completion:nil];
        }else
        {
            [UIView animateWithDuration:0.2 animations:^{
                tblSubCategoryWidth.constant = 185;
                [self.view layoutIfNeeded];
            } completion:nil];
        }
        
    });
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

#pragma mark Api call
-(void) getCategoryApi
{
    
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
                [tblCategoryList reloadData];
                [tblsubCategory reloadData];
            }
        }else
        {
            [self offlineCategory];
        }
    }];
}

-(void) getCourseTop50Course:(NSString*) endUrl
{
    [self startActivity];
    NSString *url;
    if (endUrl) {
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
            if ([jsonData isKindOfClass:[NSArray class]])
            {
                [UserDefault setObject:[NSKeyedArchiver archivedDataWithRootObject:jsonData] forKey:kCourseListKey];
                [UserDefault synchronize];
                NSArray *arr = jsonData ;
                if (arr.count> 0 )
                {
                    [arrData removeAllObjects];
                }else{
                    [self retryCity];
                }
                for (NSDictionary *dict in arr)
                {
                    if ([dict isKindOfClass:[NSDictionary class]])
                    {
                        NSMutableDictionary *mDict = [dict mutableCopy];
                        [mDict handleNullValue];
                        CourseDetail *courseEnt = [[CourseDetail alloc]initWith:mDict];
                        [arrData addObject:courseEnt];
                    }
                }
            }
            arrayCourseListData = arrData;
            [collectView reloadData];
            
        }
        else
        {
            NSData *data = [UserDefault objectForKey:kCourseListKey];
            if (data)
            {
                NSArray *jsonData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                if ([jsonData isKindOfClass:[NSArray class]])
                {
                    
                    NSArray *arr = jsonData;
                    for (NSDictionary *dict in arr)
                    {
                        if ([dict isKindOfClass:[NSDictionary class]])
                        {
                            NSMutableDictionary *mDict = [dict mutableCopy];
                            [mDict handleNullValue];
                            CourseDetail *courseEnt = [[CourseDetail alloc]initWith:mDict];
                            [arrData addObject:courseEnt];
                        }
                    }
                    arrayCourseListData = arrData;
                    [collectView reloadData];
                    
                } else {
                    showAletViewWithMessage(kNoCourseForCity);

                }
                
            }else
            {
                showAletViewWithMessage(kNoCourseForCity);

            }
            
        }
    }];
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
        id data = [arrData objectAtIndex:indexPath.row];
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

#pragma mark - pop up screen

-(void) presentCityPopUpView:(BOOL) flag
{
    SelectCityViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectCityViewController"];
    vc.view.backgroundColor = [UIColor clearColor];
    vc.isShowbtn = flag;
    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:vc animated:NO completion:nil];
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
        return arrCategory.count+1;
    }
    if (selectedIndex != 0)
    {
        CategoryEntity *catEnt =  arrCategory[selectedIndex - 1];
        return catEnt.subCategories.count;
    }
    if(tableView == tblFilter)
    {
        return arrFilter.count;
    }
    
    return 0;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblCategoryList)
    {
        return 85;
    }
    if (tableView == tblFilter) {
        return UITableViewAutomaticDimension;
    }
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try
    {
        if (tableView == tblCategoryList)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
            UILabel *lblCat = [cell viewWithTag:3];
            UIImageView *img = [cell viewWithTag:4];
            if (indexPath.row == 0 ) {
                lblCat.text = @"All Category";
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
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
            
            UILabel *lblsubCategory = [cell viewWithTag:3];
            UIImageView *img = [cell viewWithTag:4];
            img.layer.cornerRadius = img.frame.size.width/2;
            img.layer.masksToBounds = true;
            CategoryEntity *ent = arrCategory[selectedIndex - 1];
            SubCategoryEntity *subObj = [ent.subCategories objectAtIndex:indexPath.row];
            lblsubCategory.text = [NSString stringWithFormat:@"%@ (%@)",subObj.subCategory,subObj.course_count];
            
            [img sd_setImageWithURL:[NSURL URLWithString:subObj.image] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            cell.backgroundColor = [UIColor clearColor];
            
            return cell;
        }}
    @catch (NSException *exception) {
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == tblCategoryList)
    {
        if (selectedIndex != indexPath.row)
        {
            selectedIndex = indexPath.row;
            [tblsubCategory reloadData];
            [tblCategoryList reloadData];
            if (indexPath.row == 0) {
                [self btnHome:nil];
            }else{
                [self showTblSubCateogry];
            }

        }else{
            if (indexPath.row != 0) {
                [self hideShowTbl];
            }
        }
    }
    else if(tableView == tblsubCategory)
    {
        CategoryEntity *catEnt =  arrCategory[selectedIndex - 1];
        SubCategoryEntity *ent = catEnt.subCategories[indexPath.row];
        if([ent.course_count integerValue] > 0)
        {
            selectedSubCategory = ent.subCategory;
            pageIndex = 0;
            filterDict = nil;
            [self getCourseApi];
            [self hideShowTbl];
        }
    }
    
    if(tableView == tblFilter)
    {
        tempSortBy = [NSString stringWithFormat:@"%d",indexPath.row];
        [tblFilter reloadData];
    }
}


#pragma mark - UICollectionView delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [arrData count];
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
    
    if (indexPath.row <= arrData.count)
    {
        id data =[arrData objectAtIndex:indexPath.row];
        if ([data isKindOfClass:[Course class]])
        {
            
            Course* course = [arrData objectAtIndex:indexPath.row];
            if(course.images.count == 1){
                CourseListCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell2" forIndexPath:indexPath];
                cell.delegate = self;
                [cell setCourseData:course customCell:cell];
                cell.imgScroll.userInteractionEnabled = NO;
                [cell.contentView addGestureRecognizer:cell.imgScroll.panGestureRecognizer];

                return  cell;
            }else{
                CourseListCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
                cell.delegate = self;
                [cell setCourseData:course customCell:cell];
                cell.imgScroll.userInteractionEnabled = NO;
                [cell.contentView addGestureRecognizer:cell.imgScroll.panGestureRecognizer];

                return cell;
            }
        }else {
            CourseDetail* courseDetail = [arrData objectAtIndex:indexPath.row];
            if(courseDetail.field_deal_image.count == 1){
                CourseListCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell2" forIndexPath:indexPath];
                cell.delegate = self;
                [cell setData:courseDetail customCell:cell];
                cell.imgScroll.userInteractionEnabled = NO;
                [cell.contentView addGestureRecognizer:cell.imgScroll.panGestureRecognizer];
                
                return  cell;
            }else{
                CourseListCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
                cell.delegate = self;
                [cell setData:courseDetail customCell:cell];
                cell.imgScroll.userInteractionEnabled = NO;
                [cell.contentView addGestureRecognizer:cell.imgScroll.panGestureRecognizer];
                return cell;
            }

        }
    }else{
        CourseListCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        return cell;
    }
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    if (tblSubCategoryWidth.constant == 185)
    {
        [self hideTblSubCateogry];
        return;
    }
    [self performSegueWithIdentifier:@"course_detail" sender:indexPath];
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
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
#pragma mark - IBActions
- (IBAction)tblScrollSubCategory:(id)sender
{
    
}
- (IBAction)onCategory:(id)sender
{
    // open city pop up
    [self presentCityPopUpView:true];
}

-(IBAction)btnHome:(id)sender
{
   
    [self getCourseTop50Course:nil];// un select category
    selectedIndex = 0;
    pageIndex = -1;
    filterDict = nil;
    [tblCategoryList reloadData];
    
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
-(IBAction)btnSearchFilter:(id)sender
{
 
    [tfSearchKeyword resignFirstResponder];
    UIStoryboard *mainStoryboard;
    if (is_iPad())
    {
        mainStoryboard = [UIStoryboard storyboardWithName:@"StoryboardiPad"
                                                   bundle: nil];
    }else{
        mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                   bundle: nil];
    }
    
    
    SearchViewController  *vc =(SearchViewController*) [mainStoryboard instantiateViewControllerWithIdentifier: @"SearchViewController"];
    
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
        }else{
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
        CategoryEntity *catEnt =  arrCategory[selectedIndex -1];
        SubCategoryEntity *ent = catEnt.subCategories[path.row];
        vc.category = catEnt.category;
        vc.subCategory = ent.subCategory;
        vc.postalCode = searchForword;
    }else if ([segue.identifier isEqualToString:@"MapScreen"]){
        
        CourseLocationViewController *mapViewController = segue.destinationViewController;
        mapViewController.arrayCourseList = arrayCourseListData;
        mapViewController.selectedCourse = [arrayCourseListData firstObject];
        
    }else if ([segue.identifier isEqualToString:@"segueAdvance"]) {
        AdvanceSearchVC *vc = segue.destinationViewController;
        vc.arrCourses = sender;
        if (filterDict) {
            vc.title  = [NSString stringWithFormat:@"Search By:%@%@",tfSearchKeyword.text,searchForword];
            vc.basicDict = filterDict;
        }
        
        
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
#pragma mark - Search Course based on Filter
-(void) getCourseApi // user when category select
{
    if (selectedSubCategory == nil)
    {
        return;
    }
    pageIndex = pageIndex + 1;
    CategoryEntity *catEnt =  arrCategory[selectedIndex - 1];
    [self startActivity];
    
    NSDictionary *dict = @{@"city":APPDELEGATE.selectedCity,@"category":catEnt.category,@"sorting":APPDELEGATE.sortCourseBy,@"sub_category":selectedSubCategory,@"form":@"1",@"page":[NSString stringWithFormat:@"%d",pageIndex]};
    
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
                    [collectView reloadData];
                }
            }
        }else
        {
            pageIndex = pageIndex - 1;
            showAletViewWithMessage(@"No Course found,Please try again.");
        }
    }];
}
-(void) getCourseApi:(NSMutableDictionary*)dict // used when search pop up fired
{
    [self startActivity];
    pageIndex = pageIndex + 1;
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
                    NSMutableArray * courseArr = [[NSMutableArray alloc]init];
                    for (NSDictionary *dict in arr)
                    {
                        if ([dict isKindOfClass:[NSDictionary class]])
                        {
                            Course *courseEnt = [[Course alloc]initWith:dict];
                            [courseArr addObject:courseEnt];
                        }
                    }
                    if (courseArr.count > 0) {
                        [self performSegueWithIdentifier:@"segueAdvance" sender:courseArr];
                    }else{
                        showAletViewWithMessage(@"No course found.");
                    }
                    if (courseArr.count < 10) {
                        pageIndex = -1;
                    }
                    [collectView reloadData];
                }
            }
        }else
        {
            pageIndex = pageIndex - 1;
            showAletViewWithMessage(@"No Course found,Please try again.");
        }
    }];
    
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
- (IBAction)btnCloseFilter:(UIButton*)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        NSLeadingtblFilter.constant = _screenSize.width *2;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished)
     {
     }];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (scrollView == tblCategoryList || scrollView == tblsubCategory || scrollView == tblFilter)
    {
        return;
    }
    [self startTimer];
    
    // UITableView only moves in one direction, y axis
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    //NSInteger result = maximumOffset - currentOffset;
    
    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= 5.0 && pageIndex != -1)
    {
        if(selectedIndex != 0)
        {
            [self getCourseApi];
        }
    }
}
#pragma mark - UITextFeild Delegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(tfSearchKeyword == textField)
    {
        [self btnSearchFilter:nil];
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

