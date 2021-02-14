//
//  CommentDetailViewController.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 17/02/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Review.h"
@class RateView;
@interface CommentDetailViewController : ParentViewController
{
   IBOutlet RateView *rate;
}
@property(strong,nonatomic) NSString *nidComment;

@end
