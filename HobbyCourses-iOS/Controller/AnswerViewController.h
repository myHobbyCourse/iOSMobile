//
//  AnswerViewController.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 21/02/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerViewController : ParentViewController
{
    IBOutlet UILabel *lblTittle;
    IBOutlet UILabel *lblQues;
    IBOutlet UILabel *lblAns;
}

@property(strong,nonatomic) NSString *category;
@property(strong,nonatomic) NSString *question;
@property(strong,nonatomic) NSString *answer;

@end
