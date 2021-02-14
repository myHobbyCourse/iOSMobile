//
//  SalesStatVC_iPad.h
//  HobbyCourses
//
//  Created by iOS Dev on 07/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalesStatVC_iPad : ParentViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *tblSales;
}
@property (nonatomic, strong) NSMutableArray *selectedIndexPaths;
@property (assign) BOOL isBackActive;
@end
