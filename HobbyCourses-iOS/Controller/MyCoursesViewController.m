//
//  MyCoursesViewController.m
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/15/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import "MyCoursesViewController.h"
#import "CreateCourseiPadViewController.h"
#import "MyCoursesTableViewCell.h"
#import "Constants.h"
#import "CourseOfflineEntity+CoreDataProperties.h"
#import "CourseOfflineEntity.h"
#import "MBProgressHUD.h"
@interface MyCoursesViewController ()
{
    IBOutlet UITableView *tblMyCourse;
    IBOutlet UICollectionView *collectionV;
    IBOutlet UIView *viewFilter;
    IBOutlet UILabel *lblCountCourse;
    IBOutlet UIButton *btnRecent;
    IBOutlet UIButton *btnEarlest;
    
    NSMutableArray *arrayOfflineCourses;
    MBProgressHUD *hud;
    NSManagedObject *currentMagObj;
    int pageIndex;
    
    NSString *tempSortBy;
    NSArray *arrFilter;
    
    
    __weak IBOutlet NSLayoutConstraint *_heightSearch;
    IBOutlet UITextField *txtSearch;
    NSMutableArray * arrDataCopy;
    NSInteger selectedRow;
}
@end

@implementation MyCoursesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrayOfflineCourses = [[NSMutableArray alloc]init];
    arrDataCopy = [[NSMutableArray alloc]init];
    tblMyCourse.rowHeight = UITableViewAutomaticDimension;
    tblMyCourse.estimatedRowHeight = 70;
    [txtSearch addTarget:self action:@selector(searchTextValueChange:) forControlEvents:UIControlEventEditingChanged];
    _heightSearch.constant = 0;
    selectedRow = -1;
    viewFilter.hidden = !viewFilter.hidden;
}
-(void)viewWillAppear:(BOOL)animated {
    [self getOfflineCourses];
    btnPublish.selected = true;
    pageIndex = 1 ;
    [self initData];
    [self performSelector:@selector(getMyCourses) withObject:self afterDelay:0.5];
    [self updateToGoogleAnalytics:@"My Course Screen for vendor"];
}

#pragma mark Search
-(IBAction)btnSearchOpen:(UIButton*)sender{
    [self.view endEditing:true];
    if (_heightSearch.constant == 0) {
        [UIView animateWithDuration:0.2 animations:^{
            _heightSearch.constant = 50;
            [self.view layoutIfNeeded];
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            _heightSearch.constant = 0;
            [self.view layoutIfNeeded];
            
        }];
        txtSearch.text = @"";
        [self searchTextValueChange:txtSearch];
    }
}
-(void)searchTextValueChange:(UITextField *)textFiled
{
    if (textFiled.text.tringString.length > 1){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title contains[c] %@ OR category contains[c] %@ OR ANY productArr.batch_size contains[c] %@ OR post_date contains[c] %@ OR course_end_date contains[c] %@",textFiled.text,textFiled.text,textFiled.text,textFiled.text,textFiled.text];
        arrData = [[arrDataCopy filteredArrayUsingPredicate:predicate] mutableCopy];
    }else{
        [arrData removeAllObjects];
        [arrData addObjectsFromArray:arrDataCopy];
    }
    [collectionV reloadData];
    [tblMyCourse reloadData];
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    textField.text = @"";
    [self searchTextValueChange:textField];
    return true;
}

-(NSArray*)getUnsubmittedDetailsFromDatabase{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CourseOfflineEntity" inManagedObjectContext:APPDELEGATE.managedObjectContext];
    [request setEntity:entity];
    NSArray *results = [APPDELEGATE.managedObjectContext executeFetchRequest:request error:nil];
    if (results != nil && [results count] > 0)
    {
        return results;
    }
    return [[NSArray alloc] init];
}
-(void)getOfflineCourses
{
    NSArray *arr = [SubmitForm getAllCourseForm];//[self getUnsubmittedDetailsFromDatabase];
    [arrayOfflineCourses removeAllObjects];
    if (arr.count>0)
    {
        [arrayOfflineCourses addObjectsFromArray:arr];
    }
    [tblMyCourse reloadData];
}

-(void) getMyCourses
{
    [self startActivity];
    selectedRow = -1;
    NSString * strSort_by;
    NSString * strOrder_by;
    if ([@"0"  isEqual: tempSortBy]) {
        strSort_by = @"post_date";
        strOrder_by = @"desc";
    }else if  ([@"1"  isEqual: tempSortBy]){
        strSort_by = @"post_date";
        strOrder_by = @"ASC";
    }else if([@"2"  isEqual: tempSortBy]){
        strSort_by = @"commerce_price_amount";
        strOrder_by = @"desc";
    }else{
        strSort_by = @"commerce_price_amount";
        strOrder_by = @"ASC";
    }
    NSString *fuck;
    if (btnPublish.selected) {
        fuck = @"1";
    }else{
        fuck = @"0";
    }
    if (pageIndex == 0 ) {
        pageIndex = pageIndex+1;
    }
    [[NetworkManager sharedInstance] getRequestUrl:[NSString stringWithFormat:@"%@%@/%@/%@/%@",apiMyCourseNew,strSort_by,strOrder_by,[NSString stringWithFormat:@"%d",pageIndex],fuck] paramter:nil isToken:true withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        if (result == WebServiceResultSuccess)
        {
            if ([jsonData isKindOfClass:[NSArray class]])
            {
                if (pageIndex == 1)
                {
                    [arrData removeAllObjects];
                    [arrDataCopy removeAllObjects];
                }
                for (NSDictionary *dict in jsonData)
                {
                    if ([dict isKindOfClass:[NSDictionary class]])
                    {
                        NSMutableDictionary *d = [dict mutableCopy];
                        [d handleNullValue];
                        CourseDetail *courseEnt = [[CourseDetail alloc]initWith:d];
                        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"self.nid == %@",courseEnt.nid];
                        if([arrData filteredArrayUsingPredicate:predicate].count == 0){
                            [arrData addObject:courseEnt];
                            [arrDataCopy addObject:courseEnt];
                        }
                    }
                }
            }
            NSArray *arr = jsonData;
            if (arr.count < 10)
            {
                pageIndex = -1;
            }else{
                pageIndex = pageIndex + 1;
            }
            [tblMyCourse reloadData];
            [collectionV reloadData];
            
            lblCountCourse.text = [NSString stringWithFormat:@"%d Courses %@",arrData.count,[NSString stringWithFormat:@"%@",(btnPublish.selected)?@"Published":@"UnPublished"]];
        } else {
            showAletViewWithMessage(kFailAPI);
        }
    }];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    // UITableView only moves in one direction, y axis
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    //NSInteger result = maximumOffset - currentOffset;
    
    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= 3.0 && pageIndex != -1){
        [self getMyCourses];
        
    }
}


-(void) uploadCourse:(NSArray*) arrPic
{
    NSDictionary* courseDataDic = [NSKeyedUnarchiver unarchiveObjectWithData:[currentMagObj valueForKey:@"courseDetails"]];
    
    NSLog(@"courseDataDic:%@",courseDataDic);
    NSMutableDictionary *dict = [courseDataDic mutableCopy];
    [dict setValue:arrPic forKey:@"images_fids"];
    NSLog(@"courseDataDic set imageID:%@",dict);
    if (dict[@"nid"])
    {
        // Edit course
        [self editCourseAPI:dict];
    }else {
        // post new course
        [self postCourse:dict];
    }
    
}
-(void) deleteCourse:(NSIndexPath*) index
{
    ActionAlert *alert =  [ActionAlert instanceFromNib:@"My Courses" withMessage:@"Do you wish to delete your course? This action can’t be restored" bgColor:__THEME_YELLOW button:@[@"Cancel",@"Delete"] controller:self block:^(Tapped tapped, ActionAlert *alert) {
        if (tapped == TappedOkay) {
            if (arrayOfflineCourses  && arrayOfflineCourses.count>0  && index.section == 0)
            {
                SubmitForm *obj = [arrayOfflineCourses objectAtIndex:index.row];
                [self deleteEntityFromDatabase:obj.objectID];
                [self getOfflineCourses];
            }
            else
            {
                [self startActivity];
                CourseDetail *entity = [arrData objectAtIndex:index.row];
                [[NetworkManager sharedInstance] postRequestFullUrl:apiDeleteCourse paramter:@{@"nid":entity.nid} withCallback:^(id jsonData, WebServiceResult result) {
                    
                    [self stopActivity];
                    
                    if (result == WebServiceResultSuccess)
                    {
                        if ([jsonData isKindOfClass:[NSArray class]])
                        {
                            NSArray *arr = jsonData;
                            if (arr && arr.count>0) {
                                if ([arr firstObject])
                                {
                                    [arrData removeObjectAtIndex:index.row];
                                    [tblMyCourse reloadData];
                                    selectedRow = -1;
                                    pageIndex = 0;
                                    [self getMyCourses];
                                    showAletViewWithMessage(@"Course delete successfully");
                                }else{
                                    showAletViewWithMessage(@"Rats! They stole the cheese and left an error occurred while deleting course");
                                }
                            }else{
                                showAletViewWithMessage(@"Rats! They stole the cheese and left an error occurred while deleting course");
                            }
                            
                        }
                        
                    }else{
                        showAletViewWithMessage(@"Rats! They stole the cheese and left an error occurred while deleting course");
                    }
                }];
            }
        }
        [alert removeFromSuperview];
    }];
    [APPDELEGATE.window addSubview:alert];
}
-(void) editCourse:(NSIndexPath*)index
{
    FromHomeVC *vc = [getStoryBoardDeviceBased(StoryboardCourseFrom) instantiateViewControllerWithIdentifier:(is_iPad()) ? @"FromHomeVC_iPad" : @"FromHomeVC"];
    CourseDetail* course = arrData[index.row];
    vc.courseNid = course.nid;
    [self.navigationController pushViewController:vc animated:true];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void) initData {
    arrData = [[NSMutableArray alloc]init];
    arrFilter = [[NSArray alloc]initWithObjects:@"Most Recent Course",@"Earliest Course", nil];
    tempSortBy = @"0";
}
-(IBAction)btnTypeOption:(UIButton *)sender
{
    if (sender ==  btnPublish && !sender.selected)
    {
        btnPublish.selected = true;
        btnUnPublish.selected = false;
        
    }else if (sender == btnUnPublish && !sender.selected)
    {
        btnPublish.selected = false;
        btnUnPublish.selected = true;
    }
}
#pragma mark - tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (arrayOfflineCourses && arrayOfflineCourses.count>0) {
        return 2;
    }
    return 1;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (arrayOfflineCourses && arrayOfflineCourses.count>0) {
        switch (section) {
            case 0:{
                return @"Draft Course";
            }break;
                
            default:
                break;
        }
    }
    return [NSString stringWithFormat:@"My Courses %@",(btnPublish.selected)?@"Published":@"UnPublished"];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(20, 8, 320, 30);
    myLabel.font = [UIFont boldSystemFontOfSize:18];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    //Create mutable string from original one
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:myLabel.text];
    
    //Fing range of the string you want to change colour
    //If you need to change colour in more that one place just repeat it
    NSRange range = [myLabel.text rangeOfString:(btnPublish.selected)?@"Published":@"UnPublished"];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"F52375"] range:range];
    
    //Add it to the label - notice its not text property but it's attributeText
    myLabel.attributedText = attString;
    
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    headerView.backgroundColor = [UIColor whiteColor];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     if (arrayOfflineCourses && arrayOfflineCourses.count>0) {
        
        switch (section) {
            case 0:{
                return arrayOfflineCourses.count;
            }break;
                
            case 1:{
                return arrData.count;
            }break;
                
            default:
                break;
        }
    }
    
    return [arrData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
        MyCoursesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];//MyCoursesTableViewCell
        CourseDetail* course;
        UILabel *lblNo = [cell viewWithTag:111];
        lblNo.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
        cell.isDraft = NO;
        
        MGSwipeButton *btnDelete = [MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell *sender) {
            NSLog(@"delete button click event!");
            [self deleteCourse:indexPath];
            return YES;
        }];
        
        MGSwipeButton *btnEdit = [MGSwipeButton buttonWithTitle:@"Edit" backgroundColor:__THEME_lightGreen callback:^BOOL(MGSwipeTableCell *sender) {
            NSLog(@"edit buttoon click event!");
            [self editCourse:indexPath];
            return YES;
        }];
        
        if (arrayOfflineCourses && arrayOfflineCourses.count>0) {
            
            switch (indexPath.section) {
                case 0:{
                    SubmitForm *form = [arrayOfflineCourses objectAtIndex:indexPath.row];
                    DataClass *object = [NSKeyedUnarchiver unarchiveObjectWithData:form.courseData];
                    
                    cell.isDraft = YES;
                    [cell setOfflineData:object];
                    cell.rightButtons = @[btnEdit,btnDelete];
                    
                }break;
                    
                case 1:{
                    if (arrData.count > indexPath.row){
                        course = [arrData objectAtIndex:indexPath.row];
                        cell.rightButtons = @[btnEdit,btnDelete];
                        [cell setData:course];
                    }
                    
                }break;
                    
                default:
                    break;
            }
            
        }else{
            if (arrData.count > indexPath.row) {
                course = [arrData objectAtIndex:indexPath.row];
                cell.rightButtons = @[btnEdit,btnDelete];
                [cell setData:course];
            }
        }
        
        cell.rightSwipeSettings.transition = MGSwipeTransitionStatic;
        
        return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


-(void)deleteEntityFromDatabase:(NSManagedObjectID *) ID
{
    NSArray* course = [SubmitForm getAllCourseForm];
    for (NSManagedObject* courseObject in course)
    {
        if ([courseObject.objectID isEqual:ID])
        {
            [APPDELEGATE.managedObjectContext deleteObject:courseObject];
            [APPDELEGATE saveContext];
        }
    }
}
#pragma mark :- Upload Course
-(void) syscOfflineCourse:(NSManagedObject*) courseObject
{
    NSArray* courseImageArr = [NSKeyedUnarchiver unarchiveObjectWithData:[courseObject valueForKey:@"courseImage"]];
    
    [hud hide:true];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = [NSString stringWithFormat:@"Uploading 1 of %d",(int)courseImageArr.count];
    [UploadManager sharedInstance].delegate = self;
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (id data in courseImageArr)
    {
        if ([data isKindOfClass:[NSData class]])
        {
            
            [arr addObject:[UIImage imageWithData:data]];
        }else if([data isKindOfClass:[NSString class]])
        {
            NSData* theData = [NSData dataWithContentsOfURL:[NSURL URLWithString:data]];
            if (theData)
            {
                UIImage *tempImg = [[UIImage alloc] initWithData:theData];
                [arr addObject:tempImg];
            }
        }
        
    }
    if (arr.count>0)
    {
        [[UploadManager sharedInstance] uploadImagesWithArray:arr];
    }else{
        [hud hide:true];
        [self stopActivity];
        showAletViewWithMessage(@"Error occurs while course posting.Your course saved and will be submitted as soon internet available");
    }
    
    
}
#pragma mark - Offline course re-Send
-(void) postCourse:(NSDictionary *)dict
{
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Please wait.";
    
    [[NetworkManager sharedInstance] postRequestFullUrl:apiPostCourse paramter:dict withCallback:^(id jsonData, WebServiceResult result)
     {
         
         if (result == WebServiceResultSuccess)
         {
             // remove object in db as well from var & calls sync again for new object.
             [self deleteEntityFromDatabase:currentMagObj.objectID];
             [self getOfflineCourses];
             
             [hud hide:true];
             showAletViewWithMessage(@"Course post successfully.");
         }
         else
         {
             [hud hide:true];
             showAletViewWithMessage(@"Error occurs while course posting.Your course saved and will be submitted as soon internet available");
         }
     }];
    
}
-(void) editCourseAPI:(NSDictionary*)dict
{
    [[NetworkManager sharedInstance] postRequestFullUrl:apiUpdateCourse paramter:dict withCallback:^(id jsonData, WebServiceResult result) {
        
        if (result == WebServiceResultSuccess)
        {
            [self deleteEntityFromDatabase:currentMagObj.objectID];
            [self getOfflineCourses];
            
            [hud hide:true];
            showAletViewWithMessage(@"Course edit successfully.");
            
        }
        else
        {
            [hud hide:true];
            showAletViewWithMessage(@"Error occurs while course edting.Your course saved and will be submitted as soon internet available");
        }
    }];
}

#pragma mark - Upload Manager Delegate
- (void)updateProgress:(NSNumber *)completed total:(NSNumber *)totalUpload{
    hud.progress = ([completed intValue] * 100/[totalUpload intValue])/100.0f;
    hud.labelText = [NSString stringWithFormat:@"Uploading %d of %d",(int)[completed intValue]+1,(int)[totalUpload intValue]];
}
- (void)uploadCompleted:(NSArray *)arrayFids{
    hud.labelText = @"Upload completed.";
    [self performSelector:@selector(uploadCourse:) withObject:arrayFids afterDelay:1.0];
    [UploadManager sharedInstance].delegate = nil;
}
- (void)uploadFailed
{
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Uploading failed, Please try again.";
    showAletViewWithMessage(@"Your course saved and will be submitted as soon internet available");
    [hud hide:YES afterDelay:1.0];
    [UploadManager sharedInstance].delegate = nil;
}
//
-(CourseDetail*) setCourseEntityFromDict:(NSManagedObject *) obj
{
    NSDictionary* courseDataDic = [NSKeyedUnarchiver unarchiveObjectWithData:[obj valueForKey:@"courseDetails"]];
    
    NSLog(@"courseDataDic:%@",courseDataDic);
    CourseDetail *courseEntity = [[CourseDetail alloc]init];
    courseEntity.offer_valid_from = courseDataDic[@"offer_valid_from"];
    courseEntity.offer_valid_untill = courseDataDic[@"offer_valid_untill"];
    courseEntity.sold = courseDataDic[@"sold"];
    courseEntity.course_start_date = courseDataDic[@"start_date"];
    
    NSArray *arrCert = courseDataDic[@"certification"];
    if (arrCert.count > 1) {
        NSString * result = [[arrCert valueForKey:@"description"] componentsJoinedByString:@","];
        courseEntity.certifications  = result;
    }else if(arrCert.count >0 )
    {
        courseEntity.certifications = [arrCert firstObject];
    }
    courseEntity.course_requirements = courseDataDic[@"course_requirements"];
    
    
    NSMutableArray *arrCategory = [[NSMutableArray alloc]init];
    NSData *data = [UserDefault objectForKey:kCategoryKey];
    if (data)
    {
        NSArray *arrCat = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        for (NSDictionary *dict in arrCat)
        {
            CategoryEntity *entity = [[CategoryEntity alloc]initWithDictionary:dict];
            [arrCategory addObject:entity];
            
        }
    }
    NSArray *arrCatSub = courseDataDic[@"category"];
    for (CategoryEntity *entity in arrCategory)
    {
        if (entity.tid == arrCatSub[0])
        {
            courseEntity.category = entity.category;
        }
        
        for(SubCategoryEntity *subEnt in entity.subCategories)
        {
            if (subEnt.tid ==arrCatSub[1])
            {
                courseEntity.subcategory = subEnt.subCategory;
                
            }
            
        }
    }
    courseEntity.youtube_video = [[NSMutableArray alloc]init];
    [courseEntity.youtube_video addObjectsFromArray:courseDataDic[@"youtube"]];
    courseEntity.tutor = courseDataDic[@"tutor"];
    NSDictionary *addDict = courseDataDic[@"address"];
    courseEntity.address_1 = addDict[@"thoroughfare"];
    courseEntity.address_2 = addDict[@"premise"];
    courseEntity.city = addDict[@"locality"];
    courseEntity.postal_code = addDict[@"postal_code"];
    courseEntity.batch_size = courseDataDic[@"batch_size"];
    courseEntity.course_end_date = courseDataDic[@"end_date"];
    courseEntity.sessions_number = courseDataDic[@"sessions"];
    courseEntity.title = courseDataDic[@"title"];
    courseEntity.quantity = courseDataDic[@"stock"];
    courseEntity.Description = courseDataDic[@"description"];
    courseEntity.short_description = courseDataDic[@"short_description"];
    NSString *strMoney = courseDataDic[@"money_back_guarantee"];
    courseEntity.field_money_back_guarantee = ([strMoney isEqualToString:@"1"]?@"YES":@"NO");
    NSString *strstatus = courseDataDic[@"status"];
    courseEntity.status = ([strstatus isEqualToString:@"1"]?@"ACTIVE":@"NO");
    
    courseEntity.field_deal_image = [[NSMutableArray alloc]init];
    
    NSArray* courseImageArr = [NSKeyedUnarchiver unarchiveObjectWithData:[obj valueForKey:@"courseImage"]];
    for (id data in courseImageArr)
    {
        if ([data isKindOfClass:[NSData class]])
        {
            
            [courseEntity.field_deal_image addObject:[UIImage imageWithData:data]];
        }else if([data isKindOfClass:[NSString class]])
        {
            [courseEntity.field_deal_image addObject:data];
            
        }
        
    }
    return courseEntity;
    
}

#pragma mark - Other method
- (IBAction)btnFilterSelction:(UIButton*)sender{
    NSString *tapped = sender.titleLabel.text;
    if ([tapped isEqualToString:@"Published"]) {
        btnPublish.selected = true;
    }else if ([tapped isEqualToString:@"Un-Published"]) {
        btnPublish.selected = false;
    }else if ([tapped isEqualToString:@"Most Recent"]) {
        tempSortBy = @"0";
    }else if ([tapped isEqualToString:@"Earliest"]) {
        tempSortBy = @"1";
    }
    pageIndex = 0 ;
    [self getMyCourses];
    viewFilter.hidden = !viewFilter.hidden;
}
- (IBAction)btnFilterAction:(UIButton*)sender
{
    if (is_iPad()) {
        viewFilter.hidden = !viewFilter.hidden;
        return;
    }
    [AppUtils actionWithMessage:kAppName withMessage:@"Filter By" alertType:UIAlertControllerStyleAlert button:@[@"Publish",@"Un-Publish",@"Most Recent Course",@"Earliest Course"] controller:self block:^(NSString *tapped) {
        if ([tapped isEqualToString:@"Publish"]) {
            btnPublish.selected = true;
        }else if ([tapped isEqualToString:@"Un-Publish"]) {
            btnPublish.selected = false;
        }else if ([tapped isEqualToString:@"Most Recent Course"]) {
            tempSortBy = @"0";
        }else if ([tapped isEqualToString:@"Earliest Course"]) {
            tempSortBy = @"1";
        }
        pageIndex = 0 ;
        [self getMyCourses];
    }];
}
#pragma mark - UICollectionView delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1.0;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (is_iPad())? arrData.count : 0 ;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //415 * _screen/1024
    return CGSizeMake((437 * _screenSize.width)/1024, (230 * _screenSize.height)/768);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)colectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCourseCVCell * cell = [colectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (indexPath.row == selectedRow) {
        cell.viewAction.hidden = false;
    }else{
        cell.viewAction.hidden = true;
    }
    CourseDetail *course = arrData[indexPath.row];
    cell.lblCategory.text = [NSString stringWithFormat:@"  %@  ",course.category];
    cell.lblTittle.text = course.title;
    [cell refreshBlock:^(NSString *anyValue) {
        if ([anyValue isEqualToString:@"delete"]) {
            [self deleteCourse:indexPath];
        }else{
            [self editCourse:indexPath];
        }
    }];
    cell.lblStatus.text = [NSString stringWithFormat:@"%@",(btnPublish.selected)?@"Published":@"UnPublished"];

    if (course.productArr && course.productArr.count> 0 ) {
        ProductEntity * obj = course.productArr[0];
        cell.lblSize.text = obj.batch_size;
        //lblTutor.text = course.author;;
        cell.lblCity.text = course.city;
        cell.lblUploded.text = [NSString stringWithFormat:@"Uploaded - %@",course.post_date];
        cell.lblAvailble.text = [NSString stringWithFormat:@"Available until %@",obj.course_end_date];
        if (course.field_deal_image.count > 0) {
            [cell.imgV sd_setImageWithURL:[NSURL URLWithString:course.field_deal_image[0]] placeholderImage:_placeHolderImg];
        }
    }
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow = indexPath.row;
    [collectionView reloadData];
}
@end
