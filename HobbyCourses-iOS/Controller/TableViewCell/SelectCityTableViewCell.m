//
//  SelectCityTableViewCell.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 13/02/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "SelectCityTableViewCell.h"

@implementation SelectCityTableViewCell
@synthesize lblCity,btnSelection;
- (void)awakeFromNib {
    // Initialization code
    btnSelection.userInteractionEnabled = false;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
