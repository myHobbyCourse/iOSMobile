//
//  SessionSelectionVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 25/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "SessionSelectionVC.h"

@interface SessionSelectionVC ()

@end

@implementation SessionSelectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    lblNumbers.layer.borderColor = [UIColor whiteColor].CGColor;
    lblNumbers.layer.borderWidth = 1;
    lblNumbers.layer.cornerRadius = 5;
    lblNumbers.layer.masksToBounds = true;
    if (![self checkStringValue:self.strTitle]) {
        lblScreenTitle.text = self.strTitle;
    }
    if (!_isStringEmpty(self.setSessions)) {
        lblNumbers.text = self.setSessions;
    }
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Session Selection Screen"];
}

-(IBAction)btnSession:(UIButton*)sender{
    if (sender.tag == 11) {
        lblNumbers.text = ([lblNumbers.text intValue] - 1 < 0) ? @"1" : [NSString stringWithFormat:@"%d",[lblNumbers.text intValue] - 1];
    }else{
        lblNumbers.text = [NSString stringWithFormat:@"%d",[lblNumbers.text intValue] + 1];
    }
}
-(IBAction)btnSave:(id)sender{
    _searchObj.sessions = lblNumbers.text;
    if(_refreshBlock)
        _refreshBlock(lblNumbers.text);
    [self parentDismiss:nil];
    [DefaultCenter postNotificationName:@"searchAdvanceAPI" object:self];

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
