//
//  WeekDaysVC.h
//  HobbyCourses
//
//  Created by iOS Dev on 25/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeekDaysVC : ParentViewController{
    IBOutlet UIButton *btnMon;
    IBOutlet UIButton *btnThu;
    IBOutlet UIButton *btnWed;
    IBOutlet UIButton *btnTue;
    IBOutlet UIButton *btnFri;
    IBOutlet UIButton *btnSat;
    IBOutlet UIButton *btnSun;
}
@property(strong,nonatomic) Search *searchObj;

@end
