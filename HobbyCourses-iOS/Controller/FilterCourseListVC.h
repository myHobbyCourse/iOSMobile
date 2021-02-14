//
//  FilterCourseListVC.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 05/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterCourseListVC : ParentViewController
{
    IBOutlet UIButton *btnMon;
    IBOutlet UIButton *btnThu;
    IBOutlet UIButton *btnWed;
    IBOutlet UIButton *btnTue;
    IBOutlet UIButton *btnFri;
    IBOutlet UIButton *btnSat;
    IBOutlet UIButton *btnSan;
    IBOutlet UITextField *tfStart;
    IBOutlet UITextField *tfEnd;
    IBOutlet UIView *FilterView;
    
    IBOutlet UITableView *tblCourseList;
    __weak IBOutlet NSLayoutConstraint *NSLeadingtblFilter;
    IBOutlet UILabel *lblTittle;
    IBOutlet UILabel *lblSearch;

}
@property(strong,nonatomic) NSString *category;
@property(strong,nonatomic) NSString *subCategory;

@property (strong, nonatomic) NSMutableArray *arrCourses;
@property (strong, nonatomic) NSMutableDictionary *basicDict;
@property (strong, nonatomic) NSString *postalCode;


@end
