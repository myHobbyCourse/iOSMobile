//
//  VendorProfileVC.h
//  HobbyCourses
//
//  Created by iOS Dev on 17/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VendorProfileVC : ParentViewController{
    IBOutlet UIView *viewTop;
    IBOutlet UIButton *btnBack;
}
@property(strong,nonatomic) CourseDetail *courseEntity;
@property(strong,nonatomic) NSString *uid;
@property(strong,nonatomic) NSMutableArray<TutorsEntity*> *arrTuttors;
@property(strong,nonatomic) NSMutableArray<VenuesEntity*> *arrVenues;

@end
