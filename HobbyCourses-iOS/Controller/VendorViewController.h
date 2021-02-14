//
//  VendorViewController.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 21/02/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VendorViewController : ParentViewController
{
    IBOutlet UILabel *lblVendorName;
    IBOutlet UILabel *lblCourseCount;
}

@property(strong,nonatomic) NSString *verndorID;
@property(strong,nonatomic) NSString *verndorName;
@end
