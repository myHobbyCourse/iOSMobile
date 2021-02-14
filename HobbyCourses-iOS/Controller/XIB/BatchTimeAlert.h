//
//  BatchTimeAlert.h
//  HobbyCourses
//
//  Created by iOS Dev on 06/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^myCompletion)();

@interface BatchTimeAlert : ConstrainedView

@property (nonatomic, strong) IBOutlet UILabel *lblStart;
@property (nonatomic, strong) IBOutlet UILabel *lblEnd;
@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) IBOutlet UILabel *lblDate;
@property (nonatomic, strong) IBOutlet UIView *viewPop;

+(BatchTimeAlert*) instanceFromNib:(NSString*)title withDate:(NSString*) date bgColor:(UIColor*) color time:(NSArray*) Times controller:(UIViewController*) view;

@end
