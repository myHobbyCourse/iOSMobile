//
//  StudentAttCell.m
//  HobbyCourses
//
//  Created by iOS Dev on 07/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "StudentAttCell.h"

@implementation StudentAttCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_imgV layoutIfNeeded];
    _imgV.layer.cornerRadius = _imgV.frame.size.width/2;
    _imgV.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void) setStudentDate:(Student*) stud{
    _lblName.text = stud.name;
    [_imgV sd_setImageWithURL:[NSURL URLWithString:stud.avatar]];
    NSArray * arr = [stud.presence componentsSeparatedByString:@":"];
    if (arr.count == 2) {
        if ([[arr firstObject] isEqualToString:@"1"]) {
            self.btnPresent.selected = true;
            self.btnAbsent.selected = false;
        }else{
            self.btnAbsent.selected = true;
            self.btnPresent.selected = false;
        }
        
        if ([[arr lastObject] isEqualToString:@"1"]) {
            self.btnLate.selected = true;
        }else{
            self.btnLate.selected = false;
        }
    }else {
        if([stud.presence isEqualToString:@"1"]) {
            self.btnPresent.selected = true;
            self.btnAbsent.selected = false;
        }else if([stud.presence isEqualToString:@"0"]) {
            self.btnPresent.selected = false;
            self.btnAbsent.selected = true;
        }else{
            self.btnPresent.selected = false;
            self.btnAbsent.selected = false;
        }
        if ([stud.late isEqualToString:@"1"]) {
            self.btnLate.selected = true;
        }else{
            self.btnLate.selected = false;
        }
    }
    
}
-(IBAction)btnPresent:(UIButton*)sender{
    if ([self.controller.selectedSession.batch_start_date compare:[NSDate date]] == NSOrderedDescending) {
        showAletViewWithMessage(@"Attendance is only available on the day of a session or later, Please visit later");
        return;
    }
    NSString *msg = [NSString stringWithFormat:@"Did %@ attend Daily session?",self.lblName.text];
    [AppUtils actionWithMessage:kAppName withMessage:msg alertType:UIAlertControllerStyleAlert button:@[@"YES"] controller:self.controller block:^(NSString *tapped) {
        if ([tapped isEqualToString:@"YES"]) {
            if (sender.selected) {
//                sender.selected = NO;
            }else{
                sender.selected = YES;
                _btnAbsent.selected = NO;
                [self registerAttendance:@"1" lateEntry:(self.btnLate.selected) ? @"1": @"0"];
            }
        }
    }];
}
-(IBAction)btnAbsent:(UIButton*)sender{
    if ([self.controller.selectedSession.batch_start_date compare:[NSDate date]] == NSOrderedDescending) {
        showAletViewWithMessage(@"Attendance is only available on the day of a session or later, Please visit later");
        return;
    }
    NSString *msg = [NSString stringWithFormat:@"Did %@ miss Daily session?",self.lblName.text];
    [AppUtils actionWithMessage:kAppName withMessage:msg alertType:UIAlertControllerStyleAlert button:@[@"YES"] controller:self.controller block:^(NSString *tapped) {
        if ([tapped isEqualToString:@"YES"]) {
            if (sender.selected) {
//                sender.selected = NO;
            }else{
                sender.selected = YES;
                _btnPresent.selected = NO;
                [self registerAttendance:@"0" lateEntry:(self.btnLate.selected) ? @"1": @"0"];
                
            }}
    }];
}
-(IBAction)btnLate:(UIButton*)sender {
    if ([self.controller.selectedSession.batch_start_date compare:[NSDate date]] == NSOrderedDescending) {
        showAletViewWithMessage(@"Attendance is only available on the day of a session or later, Please visit later");
        return;
    }
    if (sender.selected) {
        sender.selected = NO;
    }else{
        sender.selected = YES;
    }
}


/*
 {
	"product_id":"1090", "uid_student":406, "course_time_start":"1478692800", "course_time_end":"1478527200", "attendance":1, "late":1, "comment":"some comment why he is late"
 }
 */
#pragma mark API Calls
-(void) registerAttendance:(NSString*) attendance lateEntry:(NSString*) late {
    
    [self.controller startActivity];
    [[NetworkManager sharedInstance] postRequestUrl:apiRegAttendance paramter:@{@"product_id":self.controller.product.product_id,@"uid_student":_student.uid,@"course_time_start":[NSString stringWithFormat:@"%d",(int)[self.controller.selectedSession.batch_start_date timeIntervalSince1970]],@"course_time_end":[NSString stringWithFormat:@"%d",(int)[self.controller.selectedSession.batch_end_date timeIntervalSince1970]],@"attendance":attendance,@"late":late,@"comment":self.student.comment} withCallback:^(id jsonData, WebServiceResult result) {
            [self.controller stopActivity];
            if (result == WebServiceResultSuccess) {
                self.student.presence = [NSString stringWithFormat:@"%@:%@",attendance,late];
            }
    }];
}
@end
