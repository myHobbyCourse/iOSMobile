//
//  FormAddAmenitiesVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 20/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "FormAddAmenitiesVC.h"

@interface FormAddAmenitiesVC () {
    NSMutableArray<Amenities*> *arrAmenities;
    NSMutableArray<NSString*> *arrSelectedAm;
}
@end

@implementation FormAddAmenitiesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    tblParent.rowHeight = UITableViewAutomaticDimension;
    tblParent.estimatedRowHeight = 50;
    arrAmenities = [NSMutableArray new];
    arrSelectedAm = [NSMutableArray new];
    [arrSelectedAm addObjectsFromArray:dataClass.crsAmenities];
//    arrTittle  = [[NSArray alloc] initWithObjects:@"A play area",
//                  @"Car Parking area",
//                  @"Waste bins",
//                  @"FSeating/Benches",
//                  @"Games court for football and basketball",
//                  @"Changing rooms",
//                  @"First Aid",
//                  @"Childcare",
//                  @"Family Change Room",
//                  @"Shop",
//                  @"Swimming Pool",
//                  @"Courts",
//                  @"Weight Room",
//                  @"Cardio Exercise Area",
//                  @"Aerobics Studio / Dance Studio",
//                  @"Spin Room (Indoor Stationary Cycling)",
//                  @"Free Wi-Fi",
//                  @"Wheelchair Accessible",
//                  @"Showers",
//                  @"Central A/C",
//                  nil];

    [self getAmenitiesList];
    // Do any additional setup after loading the view.
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [tblParent reloadData];
    [self updateToGoogleAnalytics:@"Amenities Screen"];

}
#pragma mark- API Call
-(void) getAmenitiesList{
    [self startActivity];
    [[NetworkManager sharedInstance] postRequestUrl:apiGetAmenities paramter:nil withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        HCLog(@"%@",jsonData);
        if (result == WebServiceResultSuccess) {
            for (NSDictionary *dict in jsonData) {
                Amenities * obj = [[Amenities alloc]initWith:dict];
                [arrAmenities addObject:obj];
            }
            [tblParent reloadData];
        }
    }];
}
#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrAmenities.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UIImageView *imgV = [cell viewWithTag:11];
    UILabel *lbl = [cell viewWithTag:12];
    UIButton *btn = [cell viewWithTag:13];

    cell.backgroundColor = [UIColor clearColor];
    [imgV sd_setImageWithURL:arrAmenities[indexPath.row].getUrl];

    lbl.text = arrAmenities[indexPath.row].title;
    if ([arrSelectedAm containsObject:arrAmenities[indexPath.row].title]) {
        btn.selected = YES;
    }else{
        btn.selected = NO;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([arrSelectedAm containsObject:arrAmenities[indexPath.row].title]) {
        [arrSelectedAm removeObject:arrAmenities[indexPath.row].title];
    }else{
        [arrSelectedAm addObject:arrAmenities[indexPath.row].title];
    }
    [tblParent reloadData];
}
-(IBAction)btnSave:(UIButton*)sender {

    [dataClass.crsAmenities removeAllObjects];
    CourseForm *course = [CourseForm getObjectbyRowID:dataClass.rowID];
    [AmeitiesList deleteAmeities];
    for (NSString *strAm in arrSelectedAm) {
        [dataClass.crsAmenities addObject:strAm];
        [AmeitiesList insertAmeities:strAm courseForm:course];
    }
    [self parentDismiss:sender];
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
