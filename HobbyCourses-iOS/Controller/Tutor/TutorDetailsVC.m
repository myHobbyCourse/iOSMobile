//
//  TutorDetailsVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 16/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "TutorDetailsVC.h"

@interface TutorDetailsVC ()

@end

@implementation TutorDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [imgTutor sd_setImageWithURL:[NSURL URLWithString:self.tutor.imagePath] placeholderImage:_placeHolderImg];
    lblName.text = self.tutor.tutor_name;
    lblDesc.text = self.tutor.tutor_details;
    if (_isFromDetails) {
        btnUpadateTutor.hidden = true;
        btnDeleteTutor.hidden = true;
    }
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Tutor Details Screen"];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    AddTutorVC_iPad *vc = segue.destinationViewController;
    vc.selectedTutor = self.tutor;
}

-(IBAction)btnBackNav:(id)sender {
    if (is_iPad()) {
        [self parentDismiss:sender];
    }else{
        [self.navigationController popViewControllerAnimated:true];
    }
}

-(IBAction)btnDelete:(UIButton*)sender {
    [self startActivity];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    NSMutableDictionary *tutorDict = [NSMutableDictionary new];
    [tutorDict setObject:@"delete" forKey:@"action"];
    [tutorDict setObject:self.tutor.tutor_id forKey:@"item_id"];
    [tutorDict setObject:self.tutor.tutor_name forKey:@"name"];
    [tutorDict setObject:self.tutor.tutor_details forKey:@"details"];
    
    [dict setObject:@[tutorDict] forKey:@"tutors"];
    [[NetworkManager sharedInstance] postRequestUrl:update_del_Tutor paramter:dict withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        if (result == WebServiceResultSuccess) {
            [DefaultCenter postNotificationName:@"refreshTutorList" object:nil];
        }else{
            showAletViewWithMessage(kFailAPI);
        }
        
    }];
}
@end
