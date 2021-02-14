//
//  ConversationViewController.h
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/21/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
@interface ConversationViewController : ParentViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray* arrData;
    IBOutlet UITextField *tfSendMessage;
    IBOutlet UILabel *msgTittle;
    IBOutlet UILabel *lblSubject;
    IBOutlet UILabel *lblReceiverNmae;
    IBOutlet NSLayoutConstraint *_heightConstaint;
    
}

@property(strong,nonatomic) MessageModel *msgEntity;
@property(assign) BOOL isNewthread;
@property(strong,nonatomic) CourseDetail *couseEntity;

-(void) getMsgList;
-(void) refreshTbl;
@end
