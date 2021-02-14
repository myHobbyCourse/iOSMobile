//
//  OrderCourseTableViewCell.h
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/20/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"

@interface OrderCourseTableViewCell : MGSwipeTableCell {
    
    IBOutlet UILabel*lblOrder_number;
    IBOutlet UILabel*lblUpdated_date;
    IBOutlet UILabel*lblTotal;
    IBOutlet UILabel*lblOrder_status;
    IBOutlet UIImageView *img;

}
@property(strong,nonatomic)     IBOutlet UIImageView *img;
- (void) setData:(UserOrder*) course;

@end