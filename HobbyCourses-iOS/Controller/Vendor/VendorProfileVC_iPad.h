//
//  VendorProfileVC_iPad.h
//  HobbyCourses
//
//  Created by iOS Dev on 21/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VendorProfileVC_iPad : ParentViewController{
    IBOutlet UIView *viewTop;
    IBOutlet UIButton *btnBack;
}
@property(strong,nonatomic) NSString *uid;
@property(strong,nonatomic) CourseDetail *courseEntity;
@property(strong,nonatomic) NSMutableArray<TutorsEntity*> *arrTuttors;
@property(strong,nonatomic) NSMutableArray<VenuesEntity*> *arrVenues;


@end
