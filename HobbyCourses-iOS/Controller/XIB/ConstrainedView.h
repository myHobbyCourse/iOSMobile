//
//  ConstrainedView.h
//  HobbyCourses
//
//  Created by iOS Dev on 13/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConstrainedView : UIView

@property (nonatomic, strong) IBOutletCollection(NSLayoutConstraint) NSArray *horizontalConstraints;
@property (nonatomic, strong) IBOutletCollection(NSLayoutConstraint) NSArray *verticalConstraints;

@end
