//
//  CoursesListViewController.h
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/13/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CoursesListViewController : ParentViewController < UITableViewDataSource, UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray* arrData;
    IBOutlet UITableView *tblCourseList;
    IBOutlet UITableView *tblCategoryList;
    IBOutlet UIView* viewCategory;
    IBOutlet UICollectionView *collectView;
    IBOutlet UIButton *btnCategorySelection;
    IBOutlet NSLayoutConstraint *_widthCategoryView;
}

@end
