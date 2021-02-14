//
//  VenueListVC.h
//  HobbyCourses
//
//  Created by iOS Dev on 16/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VenueListVC : ParentViewController
{
    IBOutlet UIButton *btnAddVenue;
    IBOutlet UITableView *tableview;
}
@property(nonatomic,strong) CourseDetail *courseEntity;
@property(assign) BOOL isSelectLocation;
@property (nonatomic, strong) CommonBlock commonBlock;
@property(assign) BOOL isFromDetails;

-(void) getRefreshBlock:(CommonBlock)refreshBlock;

@end
