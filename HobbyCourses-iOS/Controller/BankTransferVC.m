//
//  BankTransferVC.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 09/07/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "BankTransferVC.h"

@interface BankTransferVC ()
{
    NSMutableArray * arrTittles;
    NSMutableArray * arrValues;

    NSString *account_owner;
    NSString *account_number;
    NSString *bank_sort_code;
    NSString *banking_institution;
    NSString *branch_office;
}
@end

@implementation BankTransferVC
@synthesize transfer_ref;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tblParent.rowHeight = UITableViewAutomaticDimension;
    tblParent.estimatedRowHeight = 70;
    //    account_owner = @"myHobyCourses.com";
    //    account_number = @"30729790";
    //    bank_sort_code = @"20-94-67";
    //    banking_institution = @"Barclays Bank UK Plc";
    //    branch_office = @"London";
    
    //    Account owner: myHobyCourses.com
    //    Account number: 30729790
    //    : 20-94-67
    //    Banking institution: Barclays Bank UK Plc
    //    Branch office: London
    arrTittles = [[NSMutableArray alloc]initWithObjects:@"Account Name",@"Bank Name",@"Account Number",@"Sort Code",@"Transfer Reference Number",@"Branch office", nil];
    arrValues = [[NSMutableArray alloc]initWithObjects:@"myhobycourses.com",@"Barclays Bank UK Plc",@"30729790",@"20-94-67",@"",@"London", nil];
    if (_isViewMode) {
        btnComplate.hidden = YES;
        viewHeader.frame = CGRectMake(0, 0, 0, 0);
        
    }
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Bank Transfer Screen"];
}
-(IBAction)btnBackNav:(id)sender{
    if (_isViewMode) {
        [self parentDismiss:nil];
    }
    [super btnBackNav:nil];
}
#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrValues.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    UILabel *lblTittle = [cell viewWithTag:111];
    UILabel *tf = [cell viewWithTag:112];
    lblTittle.text = arrTittles[indexPath.row];
    if (indexPath.row == 4) {
        tf.text = transfer_ref;
    }else{
        tf.text = arrValues[indexPath.row];
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}


-(IBAction)btnComplateAction:(UIButton*)sender {
    [self navigate];
}

-(void) navigate {
    OrderCoursesViewController  *vc = [getStoryBoardDeviceBased(StoryboardMain) instantiateViewControllerWithIdentifier: @"OrderCoursesViewController"];
    //    vc.isBackArrow = true;
    [vc syncOrder];
    UINavigationController *navigationController = self.navigationController;
    NSMutableArray *activeViewControllers=[[NSMutableArray alloc] initWithArray: navigationController.viewControllers] ;
    [activeViewControllers removeLastObject];
    // Reset the navigation stack
    [navigationController setViewControllers:activeViewControllers];
    [navigationController pushViewController:vc animated:YES];
}

@end
