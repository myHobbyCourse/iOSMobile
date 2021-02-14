//
//  DateCalenderPickerVC.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 18/06/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCalendar.h"

@protocol CalenderPickerDelegate <NSObject>
- (void) selectedCalenderDate:(NSString*) date index:(NSInteger) pos;
@end

@interface DateCalenderPickerVC : ParentViewController
{
    IBOutlet UILabel *screenTitle;
}
@property(weak,nonatomic) IBOutlet FSCalendar *calenderView;
@property(weak,nonatomic) id<CalenderPickerDelegate> delegate;
@property(assign) BOOL isBeforeToday;
@property(strong,nonatomic) NSDate * setDate;
@property(strong,nonatomic) NSDate * endDate;

@property(strong,nonatomic) NSString *strTitle;

@property(assign) NSInteger selectTxt;


@property (nonatomic, strong) RefreshBlock refreshBlock;
-(void) getRefreshBlock:(RefreshBlock)refreshBlock;

@end
