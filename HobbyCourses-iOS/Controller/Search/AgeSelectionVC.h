//
//  AgeSelectionVC.h
//  HobbyCourses
//
//  Created by iOS Dev on 25/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgeSelectionVC : ParentViewController
@property(strong,nonatomic) Search *searchObj;

@property (nonatomic, strong) RefreshBlock refreshBlock;
-(void) refreshBlock:(RefreshBlock)deleteBlock;

@end
