//
//  AnswerViewControlleriPad.h
//  HobbyCourses-iOS
//
//  Created by Kirit on 27/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerViewControlleriPad : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableViewFAQ;

@property (strong, nonatomic) NSDictionary *arrayFAQs;

-(void)reloadData;

@end
