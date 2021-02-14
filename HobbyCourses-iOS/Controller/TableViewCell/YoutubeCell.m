//
//  YoutubeCell.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 14/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "YoutubeCell.h"

@implementation YoutubeCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [[self delegate] editStarted:string];
    return true;
}
@end
