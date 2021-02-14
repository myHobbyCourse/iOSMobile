//
//  WeekDaysVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 25/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "WeekDaysVC.h"

@interface WeekDaysVC (){
    NSMutableArray *arrDays;
}

@end

@implementation WeekDaysVC

- (void)viewDidLoad {
    [super viewDidLoad];
    arrDays = _searchObj.weekDays;
    [self preFillValue];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Search Week Days Screen"];
}

-(void) preFillValue{
    if ([arrDays containsObject:@"Monday"]) {
        [self btnStateSelected:true button:btnMon];
    }
    if ([arrDays containsObject:@"Thursday"]) {
        [self btnStateSelected:true button:btnThu];
    }
    if ([arrDays containsObject:@"Wednesday"]) {
        btnWed.selected = false;
        [self btnStateSelected:true button:btnWed];
    }
    if ([arrDays containsObject:@"Tuesday"]) {
        [self btnStateSelected:true button:btnTue];
    }
    if ([arrDays containsObject:@"Friday"]) {
        [self btnStateSelected:true button:btnFri];
    }
    if ([arrDays containsObject:@"Saturday"]) {
        [self btnStateSelected:true button:btnSat];
    }
    if ([arrDays containsObject:@"Sunday"]) {
        [self btnStateSelected:true button:btnSun];
    }
    
}
-(IBAction)btnSelectionDays:(UIButton*)sender{
    if (sender.selected) {
        if (sender == btnMon && btnMon.isSelected) {
            [arrDays removeObject:@"Monday"];
        }else if(sender == btnThu && btnThu.isSelected) {
            [arrDays removeObject:@"Thursday"];
        }else if(sender == btnWed && btnWed.isSelected) {
            [arrDays removeObject:@"Wednesday"];
        }else if(sender == btnTue && btnTue.isSelected) {
            [arrDays removeObject:@"Tuesday"];
        }else if(sender == btnFri && btnFri.isSelected) {
            [arrDays removeObject:@"Friday"];
        }else if(sender == btnSat && btnSat.isSelected) {
            [arrDays removeObject:@"Saturday"];
        }else if(sender == btnSun && btnSun.isSelected) {
            [arrDays removeObject:@"Sunday"];
        }
        
        [self btnStateSelected:false button:sender];
    }else{
        [self btnStateSelected:true button:sender];
        arrDays = [self getCourseDay];
        
    }
}
-(void) btnStateSelected:(BOOL) flag button:(UIButton*) sender{
    if (flag) {
        sender.selected = true;
        [sender setBackgroundImage:[UIImage imageNamed:@"ic_w_selected"] forState:UIControlStateNormal];
        [sender setTitleColor:__THEME_DarkBrown forState:UIControlStateNormal];
        
    }else{
        sender.selected = false;
        [sender setBackgroundImage:[UIImage imageNamed:@"ic_w_normal"] forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}
-(NSMutableArray*) getCourseDay
{
    NSMutableArray *arrSelectCity = [[NSMutableArray alloc]init];
    if (btnMon.isSelected)
    {
        [arrSelectCity addObject:@"Monday"];
    } if(btnThu.isSelected)
    {
        [arrSelectCity addObject:@"Thursday"];
    } if(btnWed.isSelected)
    {
        [arrSelectCity addObject:@"Wednesday"];
    } if(btnTue.isSelected)
    {
        [arrSelectCity addObject:@"Tuesday"];
    } if(btnFri.isSelected)
    {
        [arrSelectCity addObject:@"Friday"];
    } if(btnSat.isSelected)
    {
        [arrSelectCity addObject:@"Saturday"];
    } if(btnSun.isSelected)
    {
        [arrSelectCity addObject:@"Sunday"];
    }
    return arrSelectCity;
}
-(IBAction)btnSave:(id)sender{
    _searchObj.weekDays = arrDays;
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
