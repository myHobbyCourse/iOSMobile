//
//  MessagesViewController.h
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/16/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MessagesViewController : ParentViewController < UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray* arrData;
    IBOutlet UIButton *btnBack;
}

@property(assign) BOOL isNewthread;
@property(assign) BOOL isBackArrow;

@property(strong,nonatomic) CourseDetail *couseEntity;

@end
