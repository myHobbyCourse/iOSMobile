//
//  FormBatchesVC_iPad.h
//  HobbyCourses
//
//  Created by iOS Dev on 13/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormBatchesVC_iPad : ParentViewController

@property(nonatomic,strong) IBOutlet UITableView *tblLeft;
@property(nonatomic,strong) IBOutlet UITableView *tblRight;

@property(assign) NSInteger currentIndex;

@end
