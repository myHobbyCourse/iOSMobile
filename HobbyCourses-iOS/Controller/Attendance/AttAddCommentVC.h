//
//  AttAddCommentVC.h
//  HobbyCourses
//
//  Created by iOS Dev on 11/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttAddCommentVC : ParentViewController

@property (nonatomic, strong) IBOutlet UITextView *txtComment;
@property (nonatomic, strong) IBOutlet UIView *viewContainer;
@property (nonatomic, strong) NSString *txt;
@property (nonatomic, strong) RefreshBlock refreshBlock;
-(void) getRefreshBlock:(RefreshBlock)refreshBlock ;


@end
