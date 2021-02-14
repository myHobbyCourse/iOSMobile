//
//  VenueListVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 16/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "VenueListVC.h"

@interface VenueListVC ()
{
    NSMutableArray<VenuesEntity*> *arrVenues;
}
@end

@implementation VenueListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getVenueList];
    self.navigationItem.title = @"Our Locations";
    arrVenues = [NSMutableArray new];
    [DefaultCenter addObserver:self selector:@selector(getNotifcationForUpdate:) name:@"refreshVenueList" object:nil];
    if (_isFromDetails) {
        btnAddVenue.hidden = true;
    }
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Venue List Screen"];
}
-(void)dealloc{
    [DefaultCenter removeObserver:self];
}
-(void) getNotifcationForUpdate:(NSNotification *)notification{
    [self.navigationController popToViewController:self animated:true];
    [self getVenueList];
}
-(IBAction)btnAddNewVenue:(UIButton*)sender {
    if (is_iPad()) {
        [self dismissViewControllerAnimated:false completion:nil];
        [[JPUtility shared] performOperation:0.2 block:^{
            AddVenueVC_iPad *vc = [getStoryBoardDeviceBased(StoryboardVenue) instantiateViewControllerWithIdentifier:@"AddVenueVC_iPad"];
            UINavigationController *nav =  APPDELEGATE.window.rootViewController;
            [nav pushViewController:vc animated:true];
        }];
        
    }else{
        [self performSegueWithIdentifier:@"segueAdd" sender:self];
    }
}
#pragma mark API Calls
-(void) getVenueList {
    [self startActivity];
    NSString *vID = (self.courseEntity == nil) ? APPDELEGATE.userCurrent.uid : self.courseEntity.author_uid;

    [[NetworkManager sharedInstance] postRequestUrl:apiVenueList paramter:@{@"uid":vID,@"page":@1} withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        if (result == WebServiceResultSuccess) {
            [arrVenues removeAllObjects];
            for (NSDictionary *dict in jsonData) {
                NSMutableDictionary * d = [dict mutableCopy];
                [d handleNullValue];
                VenuesEntity * objTutor = [[VenuesEntity alloc]initWith:d];
                [arrVenues addObject:objTutor];
            }
            [tableview reloadData];
        }
        if (arrVenues.count == 0) {
            showAletViewWithMessage(@"No venues found!!");
            tableview.hidden = true;
        }else{
            tableview.hidden = false;
        }
    }];
}
#pragma Mark - UItableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrVenues.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    VenuesEntity * obj = arrVenues[indexPath.row];
    
    UIImageView *imgVenue = [cell viewWithTag:11];
    UILabel *lblName = [cell viewWithTag:12];
    UILabel *lblDesc = [cell viewWithTag:13];
    UIButton *btnMore = [cell viewWithTag:14];
    [imgVenue sd_setImageWithURL:[NSURL URLWithString:obj.imagePath] placeholderImage:_placeHolderImg];
    lblName.text = obj.venue_name;
    lblDesc.text = obj.venue_details;;
    
    btnMore.layer.cornerRadius = 10;
    btnMore.layer.masksToBounds = true;
    if (!self.isSelectLocation) {
        [btnMore setTitle:@"More about this venue" forState:UIControlStateNormal];
    }else{
        [btnMore setTitle:@"Tap to select venue" forState:UIControlStateNormal];
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isSelectLocation) {
        [self performSegueWithIdentifier:@"segueVenueDetails" sender:arrVenues[indexPath.row]];
    }else{
        if (self.commonBlock) {
            self.commonBlock(arrVenues[indexPath.row]);
            (is_iPad()) ? [self dismissViewControllerAnimated:true completion:nil] :[self.navigationController popViewControllerAnimated:true];
        }
    }
    
}
-(void) getRefreshBlock:(CommonBlock)commonBlock {
    self.commonBlock = commonBlock;
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[VenueDetailsVC class]]) {
        VenueDetailsVC *vc = segue.destinationViewController;
        vc.venue = sender;
        vc.isFromDetails = self.isFromDetails;
    }
}


@end
