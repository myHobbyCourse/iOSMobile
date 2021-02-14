//
//  HomeVC_iPad.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 24/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeVC_iPad : ParentViewController< UITableViewDataSource, UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate>
{
    NSMutableArray* arrData;
    IBOutlet UITableView *tblsubCategory;
    IBOutlet UITableView *tblCategoryList;
    IBOutlet UIView* viewCategory;
    IBOutlet UICollectionView *collectView;
    IBOutlet UIButton *btnCategorySelection;
    IBOutlet UIButton *btnSearch;
}


@end
