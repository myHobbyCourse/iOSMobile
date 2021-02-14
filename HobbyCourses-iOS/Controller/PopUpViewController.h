//
//  PopUpViewController.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 26/04/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PopUpViewController;
@protocol PopUpViewControllerProtocol <NSObject>
-(void) selectedValue:(NSString *)val selectedCatIndex:(NSIndexPath *)index type:(BOOL) category;
@end

@interface PopUpViewController : ParentViewController


-(IBAction)btnAppyCity:(id)sender;


@property(assign) BOOL isTypeCat;
@property(assign) NSIndexPath *selectedCatIndex;
@property(assign) float frame;

@property (nonatomic, weak) id<PopUpViewControllerProtocol> delegate;


@end
