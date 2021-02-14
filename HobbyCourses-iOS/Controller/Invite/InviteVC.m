//
//  InviteVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 18/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "InviteVC.h"

@interface InviteVC ()<SFSafariViewControllerDelegate>

@end

@implementation InviteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    tblParent.rowHeight = UITableViewAutomaticDimension;
    tblParent.estimatedRowHeight = 200;
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Invite Screen"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(IBAction)btnOpenTermsPage:(UIButton*)sender {
    SFSafariViewController *vc = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:kTermURL]];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%ld",(long)indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    return cell;
}
@end
