//
//  ConvUserTableViewCell.h
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/22/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ConvUserTableViewCell : UITableViewCell {
    IBOutlet UIImageView*       imvUserPhoto;
    IBOutlet UILabel*           lblUserName;
    IBOutlet UILabel*           lblLastMessage;
    IBOutlet UIButton*          btnStatus;
    
    IBOutlet UILabel*           lblSubject;
    IBOutlet UILabel*           lblReceiverNmae;

    
}

- (void) setData: (MessageModel*) message;
- (void) setNewData: (CourseDetail*) course;
@end
