//
//  ClassInfoPopVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 29/03/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import "ClassInfoPopVC.h"

@interface ClassInfoPopVC (){
    Search *searchObj;

}

@end

@implementation ClassInfoPopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    searchObj = [Search new];
    tblParent.estimatedRowHeight = 50;
    tblParent.rowHeight = UITableViewAutomaticDimension;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return searchObj.arrClass.count;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 1 || indexPath.row == 0 || indexPath.row == 2) {
        NSString *identifer = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
        return cell;
    }else{
        GenericTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell3" forIndexPath:indexPath];
        cell.lblTitle.text = searchObj.arrClass[indexPath.row];
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
