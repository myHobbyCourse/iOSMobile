//
//  FavCollectionCell.m
//  HobbyCourses
//
//  Created by iOS Dev on 23/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "FavCollectionCell.h"

@implementation FavCollectionCell
@synthesize viewAction;

- (void)awakeFromNib{
    [super awakeFromNib];
    viewAction.layer.cornerRadius = 30;
    viewAction.layer.masksToBounds = YES;
    
    _btnView.layer.borderWidth = 2;
    _btnView.layer.borderColor = __THEME_GREEN.CGColor;
    
    _btnDelete.layer.borderWidth = 2;
    _btnDelete.layer.borderColor = __THEME_COLOR.CGColor;
    
    _rateView.starNormalColor = [UIColor grayColor];
    _rateView.starFillColor = UIColorFromRGB(0xffba00);
}
@end
