//
//  StudeInfo.h
//  HobbyCourses
//
//  Created by iOS Dev on 12/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudeInfo : ConstrainedView

@property (nonatomic, strong) IBOutlet UILabel *lblUsename;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblEmail;
@property (nonatomic, strong) IBOutlet UILabel *lblComment;
@property (nonatomic, strong) IBOutlet UIImageView *imgV;
@property (nonatomic, strong) IBOutlet UIView *viewPop;

+(StudeInfo*) instanceFromNib:(NSArray*)arrInfo controller:(UIViewController*) view;

@end
