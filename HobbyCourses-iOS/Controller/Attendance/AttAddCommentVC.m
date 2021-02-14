//
//  AttAddCommentVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 11/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "AttAddCommentVC.h"

@interface AttAddCommentVC ()

@end

@implementation AttAddCommentVC
@synthesize txtComment;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewContainer.layer.borderColor = [__THEME_GRAY colorWithAlphaComponent:1].CGColor;
    self.viewContainer.layer.borderWidth = 1.0;
    self.viewContainer.layer.masksToBounds = true;
    self.viewContainer.layer.cornerRadius = 10;
    [txtComment becomeFirstResponder];
    txtComment.text = _txt;
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Add Comment Screen"];
}
-(void) getRefreshBlock:(RefreshBlock)refreshBlock {
    self.refreshBlock = refreshBlock;
}

-(IBAction)btbSaveComment:(UIButton*)sender {
    if (![self checkStringValue:txtComment.text]) {
        _refreshBlock(txtComment.text);
        [self dismissViewControllerAnimated:false completion:nil];
    }
    
}

#define MAX_TXT_LENGTH 80
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)replacementText
{
    NSString *newText = [ textView.text stringByReplacingCharactersInRange: range withString: replacementText ];
    if( [newText length]<= MAX_TXT_LENGTH ){
        return YES;
    }
    // case where text length > MAX_LENGTH
    textView.text = [ newText substringToIndex: MAX_TXT_LENGTH ];
    return NO;
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
