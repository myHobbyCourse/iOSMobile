//
//  TutorProfileVC.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 29/02/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "TutorProfileVC.h"

@interface TutorProfileVC ()

@end

@implementation TutorProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    lblAuther.text = self.auther;
    if (![self.desc isKindOfClass:[NSNull class]]) {
        txtDesc.text = self.desc;
    }else{
        txtDesc.text = @"No details availbale.";
    }
}
-(void) getRefreshBlock:(RefreshBlock)refreshBlock {
    self.refreshBlock = refreshBlock;
}
-(void)tapHandler:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)btnOtherCourses:(id)sender{
    
    _refreshBlock(@"1");
        [self dismissViewControllerAnimated:false completion:nil];
//    [self dismissViewControllerAnimated:YES completion:^{
//        [[NSNotificationCenter defaultCenter]
//         postNotificationName:@"receiveAction"
//         object:@{@"flag":@"1"}];
//    }];

}
-(IBAction)btnAllreviews:(id)sender{
    
    _refreshBlock(@"0");
    [self dismissViewControllerAnimated:false completion:nil];
//    [self dismissViewControllerAnimated:YES completion:^{
//        [[NSNotificationCenter defaultCenter]
//         postNotificationName:@"receiveAction"
//         object:@{@"flag":@"0"}];
//    }];
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
