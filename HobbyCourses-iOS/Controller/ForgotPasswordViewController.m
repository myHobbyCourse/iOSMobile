//
//  ForgotPasswordViewController.m
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/12/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()<SFSafariViewControllerDelegate>{
    NSString *email;
}
@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tblParent.estimatedRowHeight = 90;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    viewHeader.frame = CGRectMake(0, 0, _screenSize.width, 235 * _heighRatio);
   // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Forgot Password Screen"];
}


-(void) getRefreshBlock:(RefreshBlock)refreshBlock {
    self.refreshBlock = refreshBlock;
}
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * ids = [NSString stringWithFormat:@"Cell%d",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ids forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
        {
            UITextField *tfEmail = [cell viewWithTag:11];
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{ NSForegroundColorAttributeName : [[UIColor whiteColor] colorWithAlphaComponent:0.7] }];
            tfEmail.attributedPlaceholder = str;
        }break;
        case 1:
        {
            UIButton *btnLogin = [cell viewWithTag:31];
            btnLogin.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7].CGColor;
            btnLogin.layer.borderWidth = 1;
        }break;
            
        default:
            break;
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
#pragma mark - UIButton method
-(IBAction)btnHelpCenter:(id)sender{
    SFSafariViewController *vc = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:kSupportURL]];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)btnSocailLogin:(UIButton*)sender{
    switch (sender.tag) {
        case 1:
            _refreshBlock(@"Google");
            break;
        case 2:
            _refreshBlock(@"Twitter");
            break;
        case 3:
            _refreshBlock(@"Facebook");
            break;
            
        default:
            break;
    }
    
}
-(void)btnSendPass:(id)sender
{
    if (email.tringString.length == 0) {
        showAletViewWithMessage(@"Please enter email or username.");
        return;
    }
    [self startActivity];
    [[NetworkManager sharedInstance] postRequestUrl:apiForgotApi paramter:@{@"name":email} withCallback:^(NSDictionary *jsonData, WebServiceResult result) {
        [self stopActivity];
        if (result == WebServiceResultSuccess)
        {
            showAletViewWithMessage(@"We have sent email successfully.Please check your inbox");
        }else {
            showAletViewWithMessage(@"Entered user name or an e-mail address is not recognized.");
        }
    }];
    
}
#pragma mark- UITextView Delegate
- (IBAction)textViewDidEndEditing:(UITextField *)textView{
    email = textView.text;
}


@end
