//
//  TutorProfileVC.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 29/02/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorProfileVC : ParentViewController
{
    IBOutlet UILabel *lblAuther;
    IBOutlet UITextView *txtDesc;
}
-(IBAction)tapHandler:(id)sender;

@property(strong,nonatomic) NSString *autherID;
@property(strong,nonatomic) NSString *auther;
@property(strong,nonatomic) NSString *desc;
@property (nonatomic, strong) RefreshBlock refreshBlock;
-(void) getRefreshBlock:(RefreshBlock)refreshBlock;
@end
