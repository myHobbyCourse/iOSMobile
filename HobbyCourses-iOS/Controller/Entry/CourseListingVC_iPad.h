//
//  CourseListingVC_iPad.h
//  HobbyCourses
//
//  Created by iOS Dev on 03/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseListingVC_iPad : ParentViewController
{
    IBOutlet UILabel *lblUserName;
}
@property(strong,nonatomic) NSMutableArray *arrCourse;
@property(strong,nonatomic) NSMutableArray *arrRecentCourse;
@property(strong,nonatomic) NSMutableArray *arrFavCourse;
@property(strong,nonatomic) NSMutableArray *arrWeekend;
@property(strong,nonatomic) NSMutableArray *arrEvenings;


@property(strong,nonatomic) NSString *courseNID;
//For iPad 
-(void) hideCategoryView;
-(IBAction)btnOpenCitySectionPopUp:(UIButton*)sender;
@end
