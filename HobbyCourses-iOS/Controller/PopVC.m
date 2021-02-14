//
//  PopVC.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 16/07/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "PopVC.h"

@interface PopVC ()

@end

@implementation PopVC
@synthesize arrData;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.tableFooterView = [[UIView alloc]init];
    self.preferredContentSize = CGSizeMake(300, 300);
}
#pragma mark - tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SelectCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.lblCity.text = arrData[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate selectedCustomView:arrData[indexPath.row] tag:self.selectedTag];
    [self dismissViewControllerAnimated:false completion:nil];
}

@end
