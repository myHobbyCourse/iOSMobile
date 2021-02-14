//
//  ConvOtherMessageTableViewCell.m
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/22/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import "ConvOtherMessageTableViewCell.h"

@implementation ConvOtherMessageTableViewCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setData: (Message*) message {
    lblBody.text = message.body;
//    lblBody.text = @"Test \n Test Fd";
    if (!_isStringEmpty(message.sending_time)) {
        NSString *str = [ddMMMHHmm() stringFromDate:[ddMMMHHmmss() dateFromString:message.sending_time]];
        lblTime.text = str;
    }else{
        lblTime.text = message.sending_time;
    }
}

@end
