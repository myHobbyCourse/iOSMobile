//
//  MenuViewController.m
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/15/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import "MenuViewController.h"


@interface MenuViewController ()
{
    NSMutableArray *arrMenu;
    
    NSMutableArray *arrMenuIcon;
    IBOutlet UIImageView *imgProfile;
    IBOutlet UITableView *tblMenu;
    IBOutlet UILabel *lblUserName;
    IBOutlet UILabel *lblUserSinceDate;
    
}
@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    imgProfile.layer.cornerRadius = imgProfile.frame.size.width/2;
    imgProfile.layer.masksToBounds =YES;
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidOpen object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        lblUserName.text = APPDELEGATE.userCurrent.name;
        if (APPDELEGATE.userCurrent.created){
            double timestampval =  [APPDELEGATE.userCurrent.created doubleValue];
            if (timestampval){
                NSTimeInterval timestamp = (NSTimeInterval)timestampval;
                NSString *str =  [f2DIGItYearTimeFormatter() stringFromDate:[NSDate dateWithTimeIntervalSince1970:timestamp]];
                if (str) {
                    lblUserSinceDate.text = [NSString stringWithFormat:@"Member Since: \n%@",str];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!APPDELEGATE.userCurrent.isVendor)
            {
                arrMenu = [[NSMutableArray alloc] initWithObjects:@"Home",@"Cart",@"My Favourite Courses",@"My Orders",@"My Coupons",@"My Messages",@"My Reviews",@"My Account",@"FAQ",@"Log out", nil];
                arrMenuIcon = [[NSMutableArray alloc] initWithObjects:@"icc_Home",@"cart_menu",@"icc_My_Favourite_courses",@"icc_My_Orders",@"icc_My_Vouchers",@"msg_menu",@"icc_My_Reviews",@"edit_profile",@"ic_FAQ",@"logOut_menu", nil];
            }else
            {
                arrMenu = [[NSMutableArray alloc] initWithObjects:@"Home",@"Publish a Course",@"Sales DashBoard and Bookings",@"My Courses on Sale",@"My Course History",@"Attendace",@"Our Tutors",@"Our Locations",@"Cart",@"My Favourite Courses",@"My Orders",@"My Coupons",@"My Messages",@"My Reviews",@"My Account",@"FAQ",@"Log Out", nil];
                arrMenuIcon = [[NSMutableArray alloc] initWithObjects:@"icc_Home",@"publish_course",@"icc_Dashboard",@"ic_myCourse",@"icc_My_Courses_History",@"icc_Attendance",@"ic_FAQ",@"ic_FAQ",@"cart_menu",@"icc_My_Favourite_courses",@"icc_My_Orders",@"icc_My_Vouchers",@"msg_menu",@"icc_My_Reviews",@"edit_profile",@"ic_FAQ",@"logOut_menu", nil];
            }
            [tblMenu reloadData];
            [self setProfileImage];
        });
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidClose object:nil queue:nil usingBlock:^(NSNotification *note)
     {
         arrMenuIcon = nil;
         arrMenu = nil;
     }];
}


-(void) setProfileImage
{
    if (![APPDELEGATE.userCurrent.picture isKindOfClass:[NSNull class]] && [APPDELEGATE.userCurrent.picture isKindOfClass:[NSString class]])
    {
        UIImage *img = [self getImage];
        if (img)
        {
            imgProfile.image = img;
        }
        else
        {
            [imgProfile sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:APPDELEGATE.userCurrent.picture] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {
                 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
                 NSString *documentsDirectory = [paths objectAtIndex:0];
                 NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:@"MyProfileImage.png"];
                 NSData *imageData = UIImagePNGRepresentation(image);
                 [imageData writeToFile:getImagePath atomically:NO];
                 
             }];
        }
    }else{
        imgProfile.image = [UIImage imageNamed:@"placeholder"];
    }
}
- (UIImage*)getImage {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:@"MyProfileImage.png"];
    UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
    return img;
}
-(void) logout
{
    UIStoryboard *mainStoryboard = getStoryBoardDeviceBased(StoryboardMain);
    [self startActivity];
    [[NetworkManager sharedInstance] postRequestUrl:apiLogoutUrl paramter:nil withCallback:^(NSDictionary *jsonData, WebServiceResult result) {
        [self stopActivity];
        NSDictionary * dict = [UserDefault dictionaryRepresentation];
        for (id key in dict) {
            [UserDefault removeObjectForKey:key];
        }
        [UserDefault synchronize];
        [self flushDatabase];
        APPDELEGATE.selectedCity = @"";
        UIViewController  *vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"LoginViewController"];
        [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc withSlideOutAnimation:NO andCompletion:nil];
    }];
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
#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *mainStoryboard = getStoryBoardDeviceBased(StoryboardMain);
    UIViewController  *vc;
    if (APPDELEGATE.userCurrent.isVendor)
    {
        switch (indexPath.row) {
            case 0:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"CoursesListViewController"];
                break;
            case 1:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"CreateCourseiPadViewController"];
                break;
            case 2:
                vc = [getStoryBoardDeviceBased(StoryboardSalesDash) instantiateViewControllerWithIdentifier: @"SalesDashBoardVC"];
                break;
            case 3:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"MyCoursesViewController"];
                break;
            case 4:
                vc = [getStoryBoardDeviceBased(StoryboardRevision) instantiateViewControllerWithIdentifier: @"RevisionListVC"];
                break;
            case 5:
                vc = [getStoryBoardDeviceBased(StoryboardAttendance) instantiateViewControllerWithIdentifier: @"AttScheduleVC"];
                break;
            case 6:
                vc = [getStoryBoardDeviceBased(StoryboardTutor) instantiateViewControllerWithIdentifier: @"TutorListVC"];
                break;
            case 7:
                vc = [getStoryBoardDeviceBased(StoryboardVenue) instantiateViewControllerWithIdentifier: @"VenueListVC"];
                break;
            case 8:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"ShoppingCartViewController"];
                break;
            case 9:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"FavCourseViewController"];
                break;
            case 10:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"OrderCoursesViewController"];
                break;
            case 11:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"MyCouponsViewController"];
                break;
            case 12:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"MessagesViewController"];
                break;
            case 13:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"MyCommentViewController"];
                break;
            case 14:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
                break;
            case 15:
                vc = [getStoryBoardDeviceBased(StoryboardFaq) instantiateViewControllerWithIdentifier: @"FAndQViewController"];                break;
            case 16:
                [self logout];
                break;
                
            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"CoursesListViewController"];
                break;
            case 1:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ShoppingCartViewController"];
                break;
            case 2:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"FavCourseViewController"];
                break;
            case 3:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"OrderCoursesViewController"];
                break;
            case 4:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"MyCouponsViewController"];
                break;
            case 5:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"MessagesViewController"];
                break;
            case 6:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"MyCommentViewController"];
                break;
            case 7:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"EditProfileViewController"];
                break;
            case 8:
                vc = [getStoryBoardDeviceBased(StoryboardFaq) instantiateViewControllerWithIdentifier: @"FAndQViewController"];
                break;
            case 9:
                [self logout];
                break;
                
            default:
                break;
        }
    }
    if (vc) {
        [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc withSlideOutAnimation:NO andCompletion:nil];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrMenu.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell" forIndexPath:indexPath];
    UILabel *lblTittle = (UILabel*)[cell viewWithTag:5];
    UILabel *lblSeprator = (UILabel*)[cell viewWithTag:7];
    UIImageView *img = (UIImageView*)[cell viewWithTag:3];
    lblTittle.text = arrMenu[indexPath.row];
    img.image = [UIImage imageNamed:arrMenuIcon[indexPath.row]];
    // Configure the cell...
    cell.backgroundColor = [UIColor clearColor];
    
    if (indexPath.row == arrMenu.count - 4 || (indexPath.row == 7 && APPDELEGATE.userCurrent.isVendor)) {
        lblSeprator.backgroundColor = __THEME_COLOR;
    }else{
        lblSeprator.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    }
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}



@end
