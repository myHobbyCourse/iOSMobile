//
//  QuestionFQViewController.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 21/02/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionFQViewController : ParentViewController
{
    IBOutlet UITableView *tblQuestion;
}

@property(strong,nonatomic) NSMutableArray *arrQuestion;
@property(strong,nonatomic) NSString *category;
@end
