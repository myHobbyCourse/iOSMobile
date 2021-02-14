//
//  TermsVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 31/03/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import "TermsVC.h"

@interface TermsVC ()

@end

@implementation TermsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    tblParent.estimatedRowHeight = 500;
    tblParent.rowHeight = UITableViewAutomaticDimension;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GenericTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UIButton *btnAggre = [cell viewWithTag:11];
    UIButton *btnDecline = [cell viewWithTag:12];
    
    btnAggre.layer.cornerRadius = (43 * _widthRatio) /2;
    btnAggre.layer.masksToBounds = true;
    
    btnDecline.layer.cornerRadius = (43 * _widthRatio) /2;
    btnDecline.layer.masksToBounds = true;
    btnDecline.layer.borderColor = ThemEColor.CGColor;
    btnDecline.layer.borderWidth = 1;
    btnDecline.hidden = true;
    return cell;
}

-(IBAction)btnAcceped:(UIButton*)sender {
    [self parentDismiss:nil];
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
