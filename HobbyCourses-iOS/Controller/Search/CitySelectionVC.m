//
//  CitySelectionVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 26/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "CitySelectionVC.h"

@interface CitySelectionVC () {
    IBOutlet UITextField *tfSearch;
    NSMutableArray *arrLocation;
    NSInteger selectedRow;
}

@end

@implementation CitySelectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *str;
    if (!_isStringEmpty(userINFO.city)) {
        str = userINFO.city;
    }else if(!_isStringEmpty([MyLocationManager sharedInstance].cityName)) {
        str = [MyLocationManager sharedInstance].cityName;
    }else{
        str = @"";
    }
    [tfSearch addTarget:self action:@selector(searchTextValueChange:) forControlEvents:UIControlEventEditingChanged];

    arrLocation = [[NSMutableArray alloc] initWithObjects:@"AnyWhere",@"NearBy",str, nil];
    tblParent.estimatedRowHeight = 50;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    [[UserLocation sharedInstance] fetchUserLocationForOnce:self block:^(CLLocation * location, NSError * error) {
        if (location) {
            [MyLocationManager sharedInstance].userLatitude = location.coordinate.latitude;
            [MyLocationManager sharedInstance].userLongitude = location.coordinate.longitude;
        }
    }];
    if (!is_iPad() && ![arrLocation containsObject:_searchObj.location]) {
        [arrLocation addObject:_searchObj.location];
        selectedRow = [arrLocation indexOfObject:_searchObj.location];
        [tblParent reloadData];
    }
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_searchObj && ![arrLocation containsObject:_searchObj.location] && is_iPad()) {
        [arrLocation addObject:_searchObj.location];
        selectedRow = [arrLocation indexOfObject:_searchObj.location];
        [tblParent reloadData];
    }

    [self updateToGoogleAnalytics:@"City Selection Screen"];
}
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrLocation.count;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UILabel *lblCaption = [cell viewWithTag:11];
    lblCaption.text = arrLocation[indexPath.row];
    if (indexPath.row == selectedRow) {
        lblCaption.font = [UIFont boldSystemFontOfSize:lblCaption.font.pointSize];
        lblCaption.textColor = (is_iPad()) ? [UIColor whiteColor] : [UIColor blackColor];
    }else{
        lblCaption.font = [UIFont systemFontOfSize:lblCaption.font.pointSize];
        lblCaption.textColor = __THEME_GRAY;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedRow = indexPath.row;
    [tblParent reloadData];
}
-(IBAction)btnSelectCity:(UIButton*)sender {
    UIStoryboard *mainStoryboard = getStoryBoardDeviceBased(StoryboardMain);
    SelectCityViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"SelectCityViewController"];
    vc.view.backgroundColor = [UIColor clearColor];
//    self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:vc animated:NO completion:nil];
    
    [vc getCityBlock:^(NSString *anyValue) {
        tfSearch.text = anyValue;
        if (![arrLocation containsObject:anyValue]) {
            [arrLocation addObject:anyValue];
            selectedRow = [arrLocation indexOfObject:anyValue];
            [tblParent reloadData];
        }
        
    }];
}
-(IBAction)btnSave:(id)sender {
    if ([arrLocation[selectedRow] isEqualToString:@"NearBy"]) {
            [self startActivity];
            [[UserLocation sharedInstance] fetchUserLocationForOnce:self block:^(CLLocation * location, NSError * error) {
                if (location) {
                    [[UserLocation sharedInstance] cityFromlocation:location block:^(NSString * city) {
                        if (city) {
                            [MyLocationManager sharedInstance].cityName = city;
                            _searchObj.location = [NSString stringWithFormat:@"%@ (%@)",arrLocation[selectedRow],city];
                            [self parentDismiss:nil];
                            [DefaultCenter postNotificationName:@"searchCoursesAPI" object:self];
                        }else{
                            showAletViewWithMessage(@"Location service unable to find city name");
                        }
                    }];
                }else{
                    showAletViewWithMessage(error.localizedDescription);
                }
                [self stopActivity];
            }];
        }else{
            _searchObj.location = arrLocation[selectedRow];
            [self parentDismiss:nil];
            [DefaultCenter postNotificationName:@"searchCoursesAPI" object:self];
        }
}
-(void)searchTextValueChange:(UITextField *)textFiled
{
    
    NSString *place = [textFiled.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSLog(@"%@",place);
    
    if (textFiled.text.length > 1) {
        NSString *path = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=%@&keyword=%@&key=%@",[MyLocationManager sharedInstance].userLatitude,[MyLocationManager sharedInstance].userLongitude,@"50000",place,googleKey];
        [[NetworkManager sharedInstance] getRequestUrl:path paramter:nil isToken:false withCallback:^(id jsonData, WebServiceResult result) {
            HCLog(@"City:%@",jsonData);
        }];
    }
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
