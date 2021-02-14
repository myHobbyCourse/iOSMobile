//
//  TimeSelectionVC.h
//  HobbyCourses
//
//  Created by iOS Dev on 28/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TimeSelectionBlock)(NSString *start,NSString *end,NSString *copy);

@interface TimeSelectionVC : ParentViewController{
    
    IBOutlet UILabel *lblScreenTitle;

    //Picker
    IBOutlet UIDatePicker *pickerStart;
    IBOutlet UIView *viewPicker1;
    IBOutlet UILabel *lblRound1;
    IBOutlet UILabel *lblRound2;
    
    IBOutlet UIDatePicker *pickerEnd;
    IBOutlet UIView *viewPicker11;
    IBOutlet UILabel *lblRound11;
    IBOutlet UILabel *lblRound21;
    
    //Other
    IBOutlet UILabel *lblStart;
    IBOutlet UILabel *lblEnd;
    IBOutlet UILabel *lblDuration;
    
    IBOutlet UIButton *btnCopyTill;
    IBOutlet UIButton *btnClear;
}

@property(nonatomic,strong) NSDate *selectedDate;
@property(nonatomic,strong) NSDate *endDate;
@property(nonatomic,strong) NSDate *sessionEndDate;


@property (nonatomic, strong) TimeSelectionBlock timeSelectionBlock;
@property (nonatomic, strong) RefreshBlock refreshBlock;
-(void) deleteBlock:(RefreshBlock)deleteBlock;
-(void) getRefreshBlock:(TimeSelectionBlock) timeSelectionBlock;

@end
