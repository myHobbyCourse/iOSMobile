//
//  QRScanPopVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 30/03/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import "QRScanPopVC.h"

@interface QRScanPopVC ()

@end

@implementation QRScanPopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    tblParent.estimatedRowHeight = 50;
    tblParent.rowHeight = UITableViewAutomaticDimension;

    // Do any additional setup after loading the view.
}

#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifer = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    GenericTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.lblTitle.text = (self.isFromCourseDetails) ? self.courseObj.title : self.courseObj.tutor;
    }else if (indexPath.row == 1) {
        cell.lblTitle.text = [NSString stringWithFormat:@"%@ %@ %@ %@",self.courseObj.address_1,self.courseObj.address_2,self.courseObj.city,self.courseObj.postal_code];
    }else if (indexPath.row == 2) {
        [cell.imgV sd_setImageWithURL:[NSURL URLWithString:(self.isFromCourseDetails) ? self.courseObj.qrcode : self.courseObj.qrcode_vendor]];
    }
    
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
