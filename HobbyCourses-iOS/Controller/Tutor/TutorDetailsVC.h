//
//  TutorDetailsVC.h
//  HobbyCourses
//
//  Created by iOS Dev on 16/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorDetailsVC : ParentViewController
{
    IBOutlet UIImageView *imgTutor;
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblDesc;
    IBOutlet UIButton *btnUpadateTutor;
    IBOutlet UIButton *btnDeleteTutor;
}
@property(strong,nonatomic) TutorsEntity *tutor;
@property(assign) BOOL isFromDetails;

@end
