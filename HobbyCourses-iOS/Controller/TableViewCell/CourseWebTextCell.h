//
//  CourseWebTextCell.h
//  HobbyCourses
//
//  Created by iOS Dev on 29/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseWebTextCell : UITableViewCell<UIWebViewDelegate>

@property(nonatomic,strong) CourseDetailsVC *controllerDetails;
@property(nonatomic,strong) IBOutlet UIButton *btnReadMore;
@property(nonatomic,strong) IBOutlet UILabel *lblHostName;
@property(nonatomic,strong) IBOutlet UIImageView *imgVHost;
@property(nonatomic,strong) IBOutlet UIWebView *webViewDesc;

@property(nonatomic,strong) IBOutlet NSLayoutConstraint *_descHeight;

@end
