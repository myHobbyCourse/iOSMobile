//
//  FavCourseViewController.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 04/05/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavCourseViewController : ParentViewController
{
    IBOutlet UICollectionView *collectionView;
    IBOutlet UILabel *lblCount;
    IBOutlet UITableView *tblFav;
    IBOutlet UIView *viewEmpty;
}
@end
