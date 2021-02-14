//
//  VenueListVC_iPad.m
//  HobbyCourses
//
//  Created by iOS Dev on 03/12/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "VenueListVC_iPad.h"

@interface VenueListVC_iPad ()
{
    IBOutlet UITableView *tblLeft;
    IBOutlet UITableView *tblRight;
    IBOutlet UIView *viewShadow;
    IBOutlet UILabel *lblSelectedVenue;
    NSInteger currentIndex;
    NSMutableArray<VenuesEntity*> *arrVenues;
}
@end

@implementation VenueListVC_iPad
@synthesize selectedVenue;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addShaowForiPad:viewShadow];
    tblRight.estimatedRowHeight = 100;
    tblRight.rowHeight = UITableViewAutomaticDimension;
    tblLeft.estimatedRowHeight = 100;
    tblLeft.rowHeight = UITableViewAutomaticDimension;
    tblLeft.tableFooterView = [UIView new];
    arrVenues = [NSMutableArray new];
    currentIndex = -1;
    [tblRight reloadData];
    [self getVenueList];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"iPad Venue List Screen"];
}

#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == tblLeft) {
        return arrVenues.count;
    } else{
        return (selectedVenue == nil) ? 0 : 3;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == tblRight) {
        NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%ld",(long)indexPath.row];
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        switch (indexPath.row) {
            case 0:{
                UIImageView *imgV = [cell viewWithTag:11];
                UILabel *lblAddres = [cell viewWithTag:12];
                lblAddres.text = selectedVenue.location;
                [imgV sd_setImageWithURL:[NSURL URLWithString:selectedVenue.imagePath] placeholderImage:_placeHolderImg];
            }   break;
            case 1:{
                UILabel *lblDesc = [cell viewWithTag:21];
                lblDesc.numberOfLines = 0;
                lblDesc.text = selectedVenue.venue_details;
                
            }   break;
            case 2:{
                UIImageView *imgMap = [cell viewWithTag:31];
                NSString *staticMapUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/staticmap?markers=color:red|%@,%@&%@&sensor=true",selectedVenue.latitude,selectedVenue.longitude,@"zoom=15&size=450x300"];
                NSString * newStringURL = [staticMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [imgMap sd_setImageWithURL:[NSURL URLWithString:newStringURL] placeholderImage:_placeHolderImg];            return cell;
            }   break;
                
            default:
                break;
        }
        return cell;
    }else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        UILabel *lbl = [cell viewWithTag:11];
        UIImageView *imgV = [cell viewWithTag:12];
        [imgV sd_setImageWithURL:[NSURL URLWithString:arrVenues[indexPath.row].imagePath] placeholderImage:_placeHolderImg];

        lbl.text = [NSString stringWithFormat:@"Venue %ld",indexPath.row + 1];
        if (indexPath.row == currentIndex) {
            cell.backgroundColor = [UIColor colorWithRed:159.0/255.0 green:213.0/255.0 blue:214.0/255.0 alpha:1.0];
        }else{
            cell.backgroundColor = [UIColor clearColor];
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tblLeft == tableView) {
        currentIndex = indexPath.row;
        lblSelectedVenue.text = [NSString stringWithFormat:@"VENUE%ld DETAILS",indexPath.row + 1]    ;
        selectedVenue = arrVenues[indexPath.row];
        [tblLeft reloadData];
        [tblRight reloadData];
    }
}
#pragma mark API Calls
-(void) getVenueList {
    [self startActivity];
    NSString *vID = (self.courseEntity == nil) ? APPDELEGATE.userCurrent.uid : self.courseEntity.author_uid;

    [[NetworkManager sharedInstance] postRequestUrl:apiVenueList paramter:@{@"uid":vID,@"page":@1} withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        if (result == WebServiceResultSuccess) {
            for (NSDictionary *dict in jsonData) {
                NSMutableDictionary * d = [dict mutableCopy];
                [d handleNullValue];
                VenuesEntity * objTutor = [[VenuesEntity alloc]initWith:d];
                [arrVenues addObject:objTutor];
            }
            [tblLeft reloadData];
        }
        if (arrVenues.count == 0) {
            showAletViewWithMessage(@"No venue found!!");
        }else{
            currentIndex = 0;
            selectedVenue = arrVenues[0];
            lblSelectedVenue.text = [NSString stringWithFormat:@"VENUE1 DETAILS"];
        }
        [tblLeft reloadData];
        [tblRight reloadData];
        
    }];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
