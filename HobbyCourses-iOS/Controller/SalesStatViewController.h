//
//  SalesStatViewController.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 21/02/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalesStatViewController : ParentViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *tblSales;
}
@property (nonatomic, strong) NSMutableArray *selectedIndexPaths;
@property (assign) BOOL isBackActive;
@end
