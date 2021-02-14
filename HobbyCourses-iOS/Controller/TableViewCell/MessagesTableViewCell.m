//
//  MessagesTableViewCell.m
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/16/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import "MessagesTableViewCell.h"

@implementation MessagesTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setData:(MessageModel*) message {

    if (message.participants && message.participants.count>0)
    {
        ParticipantModel * entiity = message.participants[0];
        lblUserName.text = entiity.participant;
        [imvUserPhoto sd_setImageWithURL:[NSURL URLWithString:entiity.user_image]
                        placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        imvUserPhoto.layer.cornerRadius = ((_screenSize.width * 0.41) * 0.15) / 2;
        imvUserPhoto.layer.masksToBounds = YES;

    }

    
    lblLastMessage.text = message.subject;
    if ([message.has_new isEqualToString:@"1"]) {
        lblLastMessage.font = [UIFont hcOpenSansBoldWithSize:(17 * ((is_iPad()) ? _widthRatioIPAD : _widthRatio))];
    }else{
        lblLastMessage.font = [UIFont hcOpenSansRegularWithSize:(17 * ((is_iPad()) ? _widthRatioIPAD : _widthRatio))];
    }
    
    @try {
        if (!_isStringEmpty(message.last_updated)) {
            NSString *str = [ddMMMHHmm() stringFromDate:[ddMMMyyyyHHmmss() dateFromString:message.last_updated]];
            lblLastTime.text = str;
        }else{
            lblLastTime.text = message.last_updated;
        }
    }
    @catch (NSException *exception) {
        
    }
    
}

@end
