//
//  AgeInfoPopVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 28/03/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import "AgeInfoPopVC.h"

@interface AgeInfoPopVC () {
    NSArray *arrAgeTitle;
    Search *searchObj;
}

@end

@implementation AgeInfoPopVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    arrAgeTitle = [[NSArray alloc] initWithObjects:@"Don't care",@"Any Age",@"Adults",@"A Level",@"GCSE",@"Secondary school",@"Primary school",@"Preschool", nil];
    arrAgeTitle = [[NSMutableArray alloc] initWithObjects:@"Adult",@"Young Adult",@"Middle Age Adult",@"Older Adult",@"A Level",@"GCSE",@"Secondary School",@"Primary School", nil];

    searchObj = [Search new];
    tblParent.estimatedRowHeight = 50;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    // Do any additional setup after loading the view.
}

#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return searchObj.arrAgeValue.count + 1;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        ConstrainedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        return cell;
    }
    else{
        GenericTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        if (indexPath.row == 1) {
            cell.lblSubTitle.text = @"";
        }else{
            cell.lblSubTitle.text = searchObj.arrAgeValue[indexPath.row - 1];
        }
        cell.lblTitle.text = arrAgeTitle[indexPath.row - 1];
        return cell;
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
