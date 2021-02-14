//
//  SessionSelectionVC.h
//  HobbyCourses
//
//  Created by iOS Dev on 25/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionSelectionVC : ParentViewController{
    IBOutlet UILabel *lblNumbers;
    IBOutlet UILabel *lblScreenTitle;
}
@property(strong,nonatomic) Search *searchObj;
@property(strong,nonatomic) NSString *strTitle;

@property(strong,nonatomic) NSString *setSessions;

@property (nonatomic, strong) RefreshBlock refreshBlock;
-(void) getRefreshBlock:(RefreshBlock)refreshBlock;

@end
