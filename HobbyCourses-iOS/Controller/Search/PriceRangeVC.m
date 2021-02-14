//
//  PriceRangeVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 25/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "PriceRangeVC.h"

@interface PriceRangeVC () {
    NSString *strValue;
    NSInteger selectedRow;
}

@end

@implementation PriceRangeVC
@synthesize searchObj;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfig];
    selectedRow = [searchObj getPriceValue];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [tblParent reloadData];
    [self updateToGoogleAnalytics:@"Search Price range Screen"];
}
-(void) initConfig{
    //custom number formatter range slider
    self.rangeSliderCustom.delegate = self;
    self.rangeSliderCustom.minValue = 0;
    self.rangeSliderCustom.maxValue = 500;
    self.rangeSliderCustom.selectedMinimum = 0;
    self.rangeSliderCustom.selectedMaximum = 500;
    self.rangeSliderCustom.minDistance = 10;
    self.rangeSliderCustom.handleImage = [UIImage imageNamed:@"ic_s_ellipse_slider2"];
    self.rangeSliderCustom.selectedHandleDiameterMultiplier = 1.3;
    self.rangeSliderCustom.lineHeight = 0;
    
    self.rangeSliderCustom.hideLabels = YES;
    
}
#pragma mark TTRangeSliderViewDelegate
-(void)rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum{
    if (is_iPad()) {
        if (sender.leftHandleSelected) {
            _leftPos.constant = sender.leftHandle.frame.origin.x + 40;
            strValue = [NSString stringWithFormat:@"%d",(int)self.rangeSliderCustom.selectedMinimum];
        }else{
            _rightPos.constant = (viewContainer.frame.size.width - 50) - (sender.rightHandle.frame.origin.x);
            strValue = [NSString stringWithFormat:@"%d",(int)self.rangeSliderCustom.selectedMaximum];

        }
    }else{
        if (sender.leftHandleSelected) {
            _leftPos.constant = sender.leftHandle.frame.origin.x + 55;
            strValue = [NSString stringWithFormat:@"%d",(int)self.rangeSliderCustom.selectedMinimum];
        }else{
            _rightPos.constant = (self.view.frame.size.width - 55) - (sender.rightHandle.frame.origin.x);
            strValue = [NSString stringWithFormat:@"%d",(int)self.rangeSliderCustom.selectedMaximum];
        }
    }
    lblPrice.text = [NSString stringWithFormat:@"£%d - £%d ",(int)selectedMinimum,(int)selectedMaximum];

    [self.view layoutIfNeeded];
}
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (searchObj == nil) ? 0 : searchObj.arrPriceSlab.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UILabel *lblCaption = [cell viewWithTag:11];
    lblCaption.text = searchObj.arrPriceSlab[indexPath.row];
    if (indexPath.row == selectedRow) {
        lblCaption.textColor =  [UIColor whiteColor] ;
    }else{
        lblCaption.textColor =  [UIColor blackColor];
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedRow = indexPath.row;
    [tblParent reloadData];
}

-(IBAction)btnSavePrice:(id)sender{
    searchObj.price = searchObj.arrPriceSlab[selectedRow];
    [self parentDismiss:nil];
    [DefaultCenter postNotificationName:@"searchAdvanceAPI" object:self];
    
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
