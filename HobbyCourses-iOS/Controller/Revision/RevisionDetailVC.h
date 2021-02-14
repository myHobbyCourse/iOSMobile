//
//  RevisionDetailVC.h
//  HobbyCourses
//
//  Created by iOS Dev on 07/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RevisonBatches;
@interface RevisionDetailVC : ParentViewController
{
    IBOutlet UITableView *tableview;
}
@property(strong,nonatomic) RevisonBatches *product;

@end
