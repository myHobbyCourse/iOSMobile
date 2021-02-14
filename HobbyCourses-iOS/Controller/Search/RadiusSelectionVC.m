//
//  RadiusSelectionVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 25/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "RadiusSelectionVC.h"

@interface RadiusSelectionVC ()

@end

@implementation RadiusSelectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfig];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Search radius Screen"];
}
-(void) initConfig{
    //custom number formatter range slider
    self.rangeSliderCustom.delegate = self;
    self.rangeSliderCustom.minValue = 0;
    self.rangeSliderCustom.maxValue = 100;
    self.rangeSliderCustom.selectedMinimum = 0;
    self.rangeSliderCustom.selectedMaximum = 100;
    self.rangeSliderCustom.minDistance = 10;
    self.rangeSliderCustom.handleImage = [UIImage imageNamed:@"ic_slider_ellipse"];
    self.rangeSliderCustom.selectedHandleDiameterMultiplier = (is_iPad()) ? 1.8 :  1.3;
    self.rangeSliderCustom.lineHeight = 0;
    self.rangeSliderCustom.leftHandle.hidden = true;
    self.rangeSliderCustom.hideLabels = YES;
}
#pragma mark TTRangeSliderViewDelegate
-(void)rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum {
    if (is_iPad()) {
        if (sender.leftHandleSelected) {
            _leftPos.constant = sender.leftHandle.frame.origin.x + 40;
        }else{
            _rightPos.constant = (viewContainer.frame.size.width - 50) - (sender.rightHandle.frame.origin.x);
        }
    }else{
        if (sender.leftHandleSelected) {
            _leftPos.constant = sender.leftHandle.frame.origin.x + 55;
        }else{
            _rightPos.constant = (self.view.frame.size.width - 55) - (sender.rightHandle.frame.origin.x);
        }
    }
    lblRadius.text = [NSString stringWithFormat:@"%d Miles",(int)selectedMaximum];
    [self.view layoutIfNeeded];
}
-(IBAction)btnSave:(id)sender{
    _searchObj.radius = [NSString stringWithFormat:@"%d",(int)self.rangeSliderCustom.selectedMaximum];
    [self parentDismiss:nil];
    [DefaultCenter postNotificationName:@"searchCoursesAPI" object:self];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
