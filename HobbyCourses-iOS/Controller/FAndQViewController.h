//
//  FAndQViewController.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 20/02/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FAndQViewController : ParentViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *tblFQ;
}
@end
