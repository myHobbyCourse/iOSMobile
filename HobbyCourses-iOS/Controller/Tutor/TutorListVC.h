//
//  TutorListVC.h
//  HobbyCourses
//
//  Created by iOS Dev on 16/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorListVC : ParentViewController{
    IBOutlet UIButton *btnAddTutor;
}

@property(nonatomic,strong) CourseDetail *courseEntity;
@property (nonatomic, strong) CommonBlock commonBlock;
-(void) getRefreshBlock:(CommonBlock)refreshBlock;
@property(assign) BOOL isSelectTutor;
@property(assign) BOOL isFromDetails;


@end
