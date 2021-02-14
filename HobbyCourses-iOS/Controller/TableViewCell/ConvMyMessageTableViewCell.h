//
//  ConvMyMessageTableViewCell.h
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/22/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"
#import "MGSwipeTableCell.h"


@interface ConvMyMessageTableViewCell : MGSwipeTableCell {
    IBOutlet UILabel*       lblTime;
    IBOutlet UILabel*       lblBody;
}

- (void) setData: (Message*) message;

@end
