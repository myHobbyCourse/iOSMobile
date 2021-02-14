//
//  AmenitiesVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 08/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "AmenitiesVC.h"


@interface AmenitiesVC () {
    int img;
}
@end

@implementation AmenitiesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    img = 31;
    [self initData];
    [tblParent reloadData];
    // Do any additional setup after loading the view.
}
-(void) initData {
    tblParent.rowHeight = UITableViewAutomaticDimension;
    tblParent.estimatedRowHeight = 50;
}
#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrAmenities.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UIImageView *imgV = [cell viewWithTag:11];
    UILabel *lbl = [cell viewWithTag:12];
    cell.backgroundColor = [UIColor clearColor];
    [imgV sd_setImageWithURL:self.arrAmenities[indexPath.row].getUrl];
    lbl.text = self.arrAmenities[indexPath.row].title;
    return cell;
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
