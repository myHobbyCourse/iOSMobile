//
//  AnswerViewController.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 21/02/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "AnswerViewController.h"

@interface AnswerViewController ()

@end

@implementation AnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!is_iPad())
    {
        lblTittle.text = self.category;
        lblQues.text = self.question;
        lblAns.text = self.answer;
    }
    // Do any additional setup after loading the view.
}


- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
