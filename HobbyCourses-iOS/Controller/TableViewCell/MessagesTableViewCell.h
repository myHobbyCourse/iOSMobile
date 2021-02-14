//
//  MessagesTableViewCell.h
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/16/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"


@interface MessagesTableViewCell : ConstrainedTableViewCell {
    IBOutlet UIImageView*       imvUserPhoto;
    IBOutlet UILabel*           lblUserName;
    IBOutlet UILabel*           lblLastMessage;
    IBOutlet UILabel*           lblLastTime;
    IBOutlet UIButton*          btnStatus;
}

- (void) setData:(MessageModel*) message;

@end
