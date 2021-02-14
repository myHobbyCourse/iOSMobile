//
//  UserSettingVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 28/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "UserSettingVC.h"
#import "HobbyCourses-Swift.h"
#import <UIKit/UIKit.h>

@interface UserSettingVC ()<SFSafariViewControllerDelegate>
{
    NSMutableArray *arrSettings,*arrImages,*arrSettingsTop,*arrImagesTop;
    __weak IBOutlet UIButton *btnCourseDetail;
}
@end

@implementation UserSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    
}

-(void)pushAboutViewCOntroller{
    if (is_iPad()){
        HomeViewController_iPad *abtMe = [getStoryBoardDeviceBased(StoryboardCourseDetail) instantiateViewControllerWithIdentifier:@"HomeViewController_iPad"];
        [[self navigationController] pushViewController:abtMe animated:true];
    }else{
        AboutMeVC *abtMe = [getStoryBoardDeviceBased(StoryboardCourseDetail) instantiateViewControllerWithIdentifier:@"AboutMeVC"];
        [[self navigationController] pushViewController:abtMe animated:true];
    }
   
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Setting Screen"];
}

-(void) initData {
    tblParent.estimatedRowHeight = 70;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    self.navigationController.navigationBarHidden = true;
    lblUserName.text = [NSString stringWithFormat:@"%@",APPDELEGATE.userCurrent.name];
    arrSettings = [[NSMutableArray alloc] initWithObjects:@"Course Basket",@"View Orders",@"Browse Coupons",@"Read Reviews",@"Check Wish List",@"Invite Friends",@"Provide Feedback",@"Get Help & Support",@"View FAQ", nil];
    arrImages = [[NSMutableArray alloc] initWithObjects:@"ic_s_cart",@"ic_s_orders",@"ic_s_coupons",@"ic_s_reviews",@"ic_s_Favourites",@"ic_s_Invite",@"ic_s_Feedback",@"ic_s_Help_Support",@"ic_s_FAQ", nil];
    
    if (APPDELEGATE.userCurrent.isVendor)
    {
        arrSettingsTop = [[NSMutableArray alloc] initWithObjects:@"Publish a Course",@"Sales DashBoard",@"Courses on Sale",@"Course History",@"Track Attendance",@"Tutors",@"Course Locations", nil];
        arrImagesTop = [[NSMutableArray alloc] initWithObjects:@"ic_s_publish",@"ic_s_bookings",@"ic_s_courses_sale",@"ic_s_history",@"ic_s_attendence",@"ic_s_tutors",@"ic_s_Feedback",@"ic_s_Locations", nil];
    }

    if (APPDELEGATE.userCurrent.isVendor && APPDELEGATE.userCurrent.isHourlyTutor)
    {
        arrSettings = [[NSMutableArray alloc] initWithObjects:@"Sales DashBoard",@"Track Attendance",@"Invite Friends",@"Provide Feedback",@"Get Help & Support",@"View FAQ",@"Profile", nil];
        arrImages = [[NSMutableArray alloc] initWithObjects:@"ic_s_bookings",@"ic_s_attendence",@"ic_s_Invite",@"ic_s_Feedback",@"ic_s_Help_Support",@"ic_s_FAQ",@"ic_s_attendence", nil];

    }

    if (![self isNetAvailable]) {
        btnLogOut.backgroundColor = [UIColor lightGrayColor];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void) handleNetworkChange:(NSNotification *)notice
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    if (remoteHostStatus == NotReachable) {
        btnLogOut.backgroundColor = [UIColor lightGrayColor];
    } else if(remoteHostStatus == ReachableViaWiFi || remoteHostStatus == ReachableViaWWAN) {
        btnLogOut.backgroundColor = __THEME_lightGreen;
    }
}
#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (APPDELEGATE.userCurrent.isVendor && APPDELEGATE.userCurrent.isHourlyTutor) {
        return 1;
    } if (APPDELEGATE.userCurrent.isVendor) {
        return 2;
    }else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row < 4 && APPDELEGATE.userCurrent.isVendor) {
        return 0;
    }
    return UITableViewAutomaticDimension;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(APPDELEGATE.userCurrent.isVendor && APPDELEGATE.userCurrent.isHourlyTutor){
        return arrSettings.count;
    }
    if (section == 0 && APPDELEGATE.userCurrent.isVendor)
    {
        return arrSettingsTop.count;
    }
    return arrSettings.count;
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
    UITableViewCell * cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell0" forIndexPath:indexPath];
    }else if (APPDELEGATE.userCurrent.isVendor && APPDELEGATE.userCurrent.isHourlyTutor){
        if(indexPath.row == arrSettings.count - 1){
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];
        }
    }else if(APPDELEGATE.userCurrent.isVendor){
        if (indexPath.section == 0 && indexPath.row == arrSettingsTop.count - 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
        }else if(indexPath.section == 1 && indexPath.row == arrSettings.count - 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
        }else if (indexPath.section == 1 && indexPath.row == 4){
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell0" forIndexPath:indexPath];
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];
        }
    }else if(indexPath.row == arrSettings.count - 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];
    }
    
    UILabel * lbltitle = [cell viewWithTag:11];
    UIImageView * imgV = [cell viewWithTag:12];
    if(APPDELEGATE.userCurrent.isVendor && APPDELEGATE.userCurrent.isHourlyTutor){
        lbltitle.text = arrSettings[indexPath.row];
        imgV.image = [UIImage imageNamed:arrImages[indexPath.row]];
    }else
    if (indexPath.section == 0 && APPDELEGATE.userCurrent.isVendor) {
        lbltitle.text = arrSettingsTop[indexPath.row];
        imgV.image = [UIImage imageNamed:arrImagesTop[indexPath.row]];
    }else{
        lbltitle.text = arrSettings[indexPath.row];
        imgV.image = [UIImage imageNamed:arrImages[indexPath.row]];
    }
    
    UIView * borderView = [cell viewWithTag:51];
    UILabel *diverLbl = [cell viewWithTag:55];
    
    borderView.layer.cornerRadius = 5;
    borderView.layer.borderColor = __THEME_lightGreen.CGColor;
    borderView.layer.borderWidth = 1;
    borderView.hidden = true;
    diverLbl.hidden = false;
    if (indexPath.row == 0) {
        borderView.hidden = false;
    }
    if (indexPath.section == 1 && indexPath.row == 4){
        borderView.hidden = false;
    }

    if (indexPath.row == arrSettingsTop.count - 1 && indexPath.section == 0 && APPDELEGATE.userCurrent.isVendor) {
        diverLbl.hidden = true;
        borderView.hidden = false;
    }else if (indexPath.row == arrSettings.count - 1){
        diverLbl.hidden = true;
        borderView.hidden = false;
    }
    if (is_iPad()) {
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:218.0/255.0 green:240.0/255.0 blue:239.0/255.0 alpha:1.0];
;
        cell.selectedBackgroundView = bgColorView;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (APPDELEGATE.userCurrent.isVendor && APPDELEGATE.userCurrent.isHourlyTutor)
    {
        switch (indexPath.row) {
            case 0:
                [self performSegueWithIdentifier:@"segueSaleDash" sender:self];
                break;
            case 1:
                [self performSegueWithIdentifier:@"segueAttendence" sender:self];
                break;
            case 2:
                [self performSegueWithIdentifier:@"toInvite" sender:self];
                break;
            case 3:
                [self performSegueWithIdentifier:@"toFeedback" sender:self];
                break;
            case 4:
                [self openSupportPage];
                break;
            
            case 5:
                if (is_iPad()) {
                    [self openFAQPage];
                }else{
                    [self performSegueWithIdentifier:@"segueFAQ" sender:self];
                }
                break;
            case 6:
                [self pushAboutViewCOntroller];
                break;
            default:
                break;

        }
    }else
    if (APPDELEGATE.userCurrent.isVendor && indexPath.section == 0)
    {
        switch (indexPath.row) {
            case 0:
                [self performSegueWithIdentifier:@"seguePublish" sender:self];
                break;
            case 1:
                [self performSegueWithIdentifier:@"segueSaleDash" sender:self];
                break;
            case 2:
                [self performSegueWithIdentifier:@"segueMyCourses" sender:self];
                break;
            case 3:
                [self performSegueWithIdentifier:@"segueRevision" sender:self];
                break;
            case 4:
                [self performSegueWithIdentifier:@"segueAttendence" sender:self];
                break;
            case 5:
                [self performSegueWithIdentifier:@"segueTutor" sender:self];
                break;
            case 6:
                [self performSegueWithIdentifier:@"segueVenue" sender:self];
                break;
            case 7:
                [self performSegueWithIdentifier:@"segueCart" sender:self];
                break;
            case 8:
                [self performSegueWithIdentifier:@"segueOrder" sender:self];
                break;
            case 9:
                [self performSegueWithIdentifier:@"segueCoupon" sender:self];
                break;
            case 10:
                [self performSegueWithIdentifier:@"segueReview" sender:self];
                break;
            case 11:
                if (is_iPad()) {
                    [self openFAQPage];
                }else{
                    [self performSegueWithIdentifier:@"segueFAQ" sender:self];
                }
                break;
            case 12:
            {
                
            }
                break;
            default:
                break;
        }
        
    }else{
        switch (indexPath.row) {
            case 0:
                [self performSegueWithIdentifier:@"segueCart" sender:self];
                break;
            case 1:
                [self performSegueWithIdentifier:@"segueOrder" sender:self];
                break;
            case 2:
                [self performSegueWithIdentifier:@"segueCoupon" sender:self];
                break;
            case 3:
                [self performSegueWithIdentifier:@"segueReview" sender:self];
                break;
            case 4:
                [self performSegueWithIdentifier:@"segueFav" sender:self];
                break;
            case 5:
                [self performSegueWithIdentifier:@"toInvite" sender:self];
                break;
            case 6:
                [self performSegueWithIdentifier:@"toFeedback" sender:self];
                break;
            case 7:
                [self openSupportPage];
                break;
            case 8:
                if (is_iPad()) {
                    [self openFAQPage];
                }else{
                    [self performSegueWithIdentifier:@"segueFAQ" sender:self];
                }
                break;
            default:
                break;
        }
    }
}
#pragma mark - SFSafariViewController
-(void) openSupportPage{
    SFSafariViewController *vc = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:kSupportURL]];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}
-(void) openFAQPage{
    SFSafariViewController *vc = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:kFaqURL]];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];
}
#pragma Mark- Other Methods
-(IBAction)btnLogout:(UIButton*)sender {
//    if (![self isNetAvailable]) {
//        return;
//    }
    ActionAlert *alert =  [ActionAlert instanceFromNib:kAppName withMessage:@"Do you wish to logout?" bgColor:__THEME_YELLOW button:@[@"NO",@"YES"] controller:self block:^(Tapped tapped, ActionAlert *alert) {
        if (tapped == TappedOkay) {
            [self logout];
        }
        [alert removeFromSuperview];
    }];
    [APPDELEGATE.window addSubview:alert];
}
-(void) logout
{
    [self startActivity];
    [[NetworkManager sharedInstance] postRequestUrl:apiLogoutUrl paramter:nil withCallback:^(NSDictionary *jsonData, WebServiceResult result) {
        [self stopActivity];
        [self clearAll];

    }];
}
-(void) clearAll{
    [[GIDSignIn sharedInstance] signOut];
    NSDictionary * dict = [UserDefault dictionaryRepresentation];
    for (id key in dict) {
        [UserDefault removeObjectForKey:key];
    }
    [UserDefault synchronize];
    [self flushDatabase];
    APPDELEGATE.selectedCity = @"";
    
    UINavigationController *nav = [getStoryBoardDeviceBased((is_iPad()) ? StoryboardMain : StoryboardEntry) instantiateViewControllerWithIdentifier:@"SlideNavigationController"];
    SpalshViewController *v2 = nav.viewControllers[0];
    v2.isDirectMove = true;
    APPDELEGATE.window.rootViewController = nav;
}

-(void) flushDatabase{
    NSArray *entity = APPDELEGATE.managedObjectModel.entities;
    for (NSEntityDescription *entt in entity) {
        NSFetchRequest * fetchRequest =[[NSFetchRequest alloc] init];
        NSEntityDescription * deleteEntity = [NSEntityDescription entityForName:entt.name inManagedObjectContext:APPDELEGATE.managedObjectContext];
        [fetchRequest setEntity:deleteEntity];
        NSArray *objects =[APPDELEGATE.managedObjectContext executeFetchRequest:fetchRequest error:nil];
        for (NSManagedObject * object in objects) {
            [APPDELEGATE.managedObjectContext deleteObject:object];
        }
        NSError *saveError = nil;
        [APPDELEGATE.managedObjectContext save:&saveError];
    }
    [APPDELEGATE saveContext];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *directory = [documentsDirectory stringByAppendingPathComponent:@"MyProfileImage.png"];
    NSError *error = nil;
    [fm removeItemAtPath:directory error:&error];
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if ([segue.identifier isEqualToString:@"segueSaleDash"]) {
         SalesDashBoardVC *vc = segue.destinationViewController;
         vc.isHideBackBtn = true;
     }
 }

- (IBAction)btnCourseDetail:(UIButton *)sender {
    
    AboutMeVC *aboutVC = [getStoryBoardDeviceBased(StoryboardCourseDetail) instantiateViewControllerWithIdentifier:@"AboutMeVC"];
    [[self navigationController] pushViewController:aboutVC animated:true];
    
//    ProfileSearchResultsViewController *aboutVC = [getStoryBoardDeviceBased(StoryboardCourseDetail) instantiateViewControllerWithIdentifier:@"ProfileSearchResultsViewController"];
//    [[self navigationController] pushViewController:aboutVC animated:true];
    
    /*
    BookingDetailViewController *abtMe = [getStoryBoardDeviceBased(StoryboardCourseDetail) instantiateViewControllerWithIdentifier:@"BookingDetailViewController"];
    [[self navigationController] pushViewController:abtMe animated:true];*/
}

@end
