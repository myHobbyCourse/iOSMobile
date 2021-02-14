//
//  FormPriceVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 20/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "FormPriceVC.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface FormPriceVC (){
    
}

@end

@implementation FormPriceVC
@synthesize price,discount;
- (void)viewDidLoad {
    [super viewDidLoad];
    tblParent.estimatedRowHeight = 100;
    tblParent.rowHeight = UITableViewAutomaticDimension;

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Price submit from Screen"];
}

-(void)viewDidDisappear:(BOOL)animated {
    [self.view endEditing:true];
}

#pragma mark - UIButton
-(IBAction)btnNext:(UIButton*)sender {
    FromOptionVC *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"FromOptionVC"];
    [self.navigationController pushViewController:vc animated:true];
}
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%d",indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    UITextField *tfPrice = [cell viewWithTag:11];
    UITextField *tfDiscount = [cell viewWithTag:12];
    tfPrice.text = price;
    tfDiscount.text = discount;
    if (indexPath.row == 1) {
        UIView *viewBorder = [cell viewWithTag:11];
        viewBorder.layer.borderColor = __THEME_GRAY.CGColor;
        viewBorder.layer.borderWidth = 1.0;
        viewBorder.layer.cornerRadius = 8;
    }
    return cell;
}
-(IBAction)textFeildEditing:(UITextField*)sender {
    if (sender.tag == 11) {
        price = sender.text;
    }else{
        discount = sender.text;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    UITableViewCell *cell = [tblParent cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITextField *tfDiscount = [cell viewWithTag:12];
    UITextField *tfPrice = [cell viewWithTag:11];
    if (textField.tag == 11) {
        
        price = textField.text;
        if (_isStringEmpty(discount)) {
            discount = price;
        }else if (discount.integerValue > price.integerValue){
            discount = price;
        }
        tfPrice.text = price;
        tfDiscount.text = discount;
    }else{
        if (!_isStringEmpty(price) && discount.integerValue > price.integerValue){
            discount = price;
        }else{
            discount = textField.text;
        }
        tfDiscount.text = discount;
    }
}

-(IBAction)btnSave:(id)sender {
    if (discount.integerValue > price.integerValue){
        showAletViewWithMessage(@"Discounted price has to be same else less than regular price");
        return;
    }

    if(self.refreshBlock != nil)
        _refreshBlock([NSString stringWithFormat:@"%@:%@",price,discount]);
    [self parentDismiss:nil];
}
-(void) getRefreshBlock:(RefreshBlock)refreshBlock {
    self.refreshBlock = refreshBlock;
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
