//
//  ConvUserTableViewCell.m
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/22/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import "ConvUserTableViewCell.h"

@implementation ConvUserTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void) setData: (MessageModel*) message {
    
    if (message.participants && message.participants.count>0) {
        ParticipantModel * entiity = message.participants[0];
        [imvUserPhoto sd_setImageWithURL:[NSURL URLWithString:entiity.user_image]
               placeholderImage:[UIImage imageNamed:@"placeholder"]
                        options:SDWebImageRefreshCached];
        [self layoutIfNeeded];
        imvUserPhoto.layer.cornerRadius = imvUserPhoto.frame.size.width/2;
        imvUserPhoto.layer.masksToBounds = YES;
        lblUserName.text = entiity.participant;
        lblSubject.text = message.subject;//entiity.participant;
        lblReceiverNmae.text = entiity.participant;
    }
    lblLastMessage.text = message.subject;
    
}
- (void) setNewData: (CourseDetail*) course
{
    lblUserName.text = course.author;
    [imvUserPhoto sd_setImageWithURL:[NSURL URLWithString:course.author_image]
                    placeholderImage:[UIImage imageNamed:@"placeholder"]
                             options:SDWebImageRefreshCached];
    [self layoutIfNeeded];
    imvUserPhoto.layer.cornerRadius = imvUserPhoto.frame.size.width/2;
    imvUserPhoto.layer.masksToBounds = YES;
    lblLastMessage.text = course.title;
    lblSubject.text = @"";//entiity.participant;
    lblReceiverNmae.text = course.author;

    
    
}

@end
