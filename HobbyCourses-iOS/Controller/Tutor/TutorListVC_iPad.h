//
//  TutorListVC_iPad.h
//  HobbyCourses
//
//  Created by iOS Dev on 03/12/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorListVC_iPad : ParentViewController
@property(strong,nonatomic) TutorsEntity *selectedTutor;
@property(nonatomic,strong) CourseDetail *courseEntity;

@end
