//
//  CategoryCoursesVC.h
//  HobbyCourses
//
//  Created by iOS Dev on 21/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryCoursesVC : ParentViewController{
    IBOutlet UILabel *lblCity;
    IBOutlet UILabel *lblScreenTitle;
}

@property(strong,nonatomic) NSString *category;
@property(strong,nonatomic) NSString *subCategory;
@property(assign) int pageIndex;

-(void) getCourseApiSimpleSearch;
@end
