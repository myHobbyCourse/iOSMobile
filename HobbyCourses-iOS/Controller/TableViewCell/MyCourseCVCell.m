//
//  MyCourseCVCell.m
//  HobbyCourses
//
//  Created by iOS Dev on 24/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "MyCourseCVCell.h"

@implementation MyCourseCVCell

@synthesize viewAction;

- (void)awakeFromNib{
    [super awakeFromNib];
    viewAction.layer.cornerRadius = 30;
    viewAction.layer.masksToBounds = YES;
    
    _btnView.layer.borderWidth = 2;
    _btnView.layer.borderColor = __THEME_GREEN.CGColor;
    
    _btnDelete.layer.borderWidth = 2;
    _btnDelete.layer.borderColor = __THEME_COLOR.CGColor;
}
-(IBAction)btnDeleteCourse:(UIButton*)sender{
    self.refreshBlock(@"delete");
}
-(IBAction)btnEditCourse:(UIButton*)sender {
    self.refreshBlock(@"edit");
}

-(void) refreshBlock:(RefreshBlock)refreshBlock {
    self.refreshBlock = refreshBlock;
}

@end
