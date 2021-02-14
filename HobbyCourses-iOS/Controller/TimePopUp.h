//
//  TimePopUp.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 12/06/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SelectTimeDelegate <NSObject>
-(void) selectedDatesTime:(NSString*) start EndTime:(NSString*) end copy:(NSString*) untillDate;
-(void) reloadBatchesAfterDelete;
@end

@interface TimePopUp : ParentViewController<UITextFieldDelegate> {
    IBOutlet UITextField * tfCopy;
}
@property (weak,nonatomic) id<SelectTimeDelegate> delegate;

@property(strong,nonatomic) IBOutlet UIDatePicker *datePicker1;
@property(strong,nonatomic) IBOutlet UIDatePicker *datePicker2;
@property(strong,nonatomic) IBOutlet UILabel *lblDate;
@property(strong,nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property(strong,nonatomic) IBOutlet UIButton *btnDelete;
@property(strong,nonatomic) IBOutlet NSLayoutConstraint *widthDeleteButton;

@property(strong,nonatomic) NSDate * date;  // Display Tittle
@property(strong,nonatomic) NSDate * startDate; // Picker 1
@property(strong,nonatomic) NSDate * endDate; // Picker 2
@property(strong,nonatomic) NSDate * selectedEndDate; // Picker 2

@property(strong,nonatomic) NSString *uuid;
@property(assign) BOOL  isDelete;

@end
