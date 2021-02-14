//
//  RevisionListCell.m
//  HobbyCourses
//
//  Created by iOS Dev on 06/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "RevisionListCell.h"

@implementation RevisionListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _lblTittle.textColor = [UIColor whiteColor];
    _lblBatchDesc.textColor = [UIColor whiteColor];
    _lblPublishDate.textColor = [UIColor whiteColor];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
