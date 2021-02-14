//
//  MyCoursesViewController.h
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/15/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyCoursesViewController : ParentViewController < UITableViewDataSource, UITableViewDelegate,UploadManagerDelegate> {
    NSMutableArray* arrData;
    IBOutlet UIButton *btnPublish;
    IBOutlet UIButton *btnUnPublish;
}
@property(assign)BOOL isBackArrow;
@end