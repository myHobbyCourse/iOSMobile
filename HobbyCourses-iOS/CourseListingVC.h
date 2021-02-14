//
//  CourseListingVC.h
//  AirbnbClone
//
//  Created by iOS Dev on 23/08/16.
//  Copyright © 2016 iOS Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZOZolaZoomTransition.h"

@interface CourseListingVC : ParentViewController<UINavigationControllerDelegate,ZOZolaZoomTransitionDelegate>
{
    IBOutlet UILabel *lblUserName;
}
@property(strong,nonatomic) NSMutableArray *arrCourse;
@property(strong,nonatomic) NSMutableArray *arrRecentCourse;
@property(strong,nonatomic) NSMutableArray *arrFavCourse;
@property(strong,nonatomic) NSMutableArray *arrWeekend;
@property(strong,nonatomic) NSMutableArray *arrEvenings;

@property(assign) NSInteger selectedSection;
@property(strong,nonatomic) NSIndexPath *selectedIndexPath;


@property(strong,nonatomic) NSString *courseNID;
@end
