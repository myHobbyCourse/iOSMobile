//
//  ConvMyMessageTableViewCell.m
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/22/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import "ConvMyMessageTableViewCell.h"

@implementation ConvMyMessageTableViewCell


- (void) setData: (Message*) message {

    lblBody.text = message.body;
    //lblTime.text = message.sending_time;
    if (!_isStringEmpty(message.sending_time)) {
        NSString *str = [ddMMMHHmm() stringFromDate:[ddMMMHHmmss() dateFromString:message.sending_time]];
        lblTime.text = str;
    }else{
        lblTime.text = message.sending_time;
    }
}

@end
