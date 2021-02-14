//
//  AttendanceViewCell.m
//  HobbyCourses
//
//  Created by iOS Dev on 10/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "AttendanceViewCell.h"

@implementation AttendanceViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void) setWeekAttendacen:(NSArray<Attendance*>*) arrData {
    _viewMon.hidden = true;
    _viewTue.hidden = true;
    _viewWed.hidden = true;
    _viewThu.hidden = true;
    _viewFri.hidden = true;
    _viewSat.hidden = true;
    _viewSun.hidden = true;
    _imgMon.hidden = true;
    _imgTue.hidden = true;
    _imgWed.hidden = true;
    _imgThu.hidden = true;
    _imgFri.hidden = true;
    _imgSat.hidden = true;
    _imgSun.hidden = true;

    for (Attendance *data in arrData) {
        if ([data.strDay isEqualToString:@"Mon"]) {
            [_imgMon sd_setImageWithURL:[NSURL URLWithString:data.student_avatar] placeholderImage:_placeHolderImg];
            _imgMon.hidden = false;
            if ([data.attendance isEqualToString:@"0"]) {
                _viewMon.hidden = false;
            }else{
                _viewMon.hidden = true;
            }
        }else if ([data.strDay isEqualToString:@"Tue"]) {
            [_imgTue sd_setImageWithURL:[NSURL URLWithString:data.student_avatar] placeholderImage:_placeHolderImg];
            _imgTue.hidden = false;
            if ([data.attendance isEqualToString:@"0"]) {
                _viewTue.hidden = false;
            }else{
                _viewTue.hidden = true;
            }
        }else if ([data.strDay isEqualToString:@"Wed"]) {
            [_imgWed sd_setImageWithURL:[NSURL URLWithString:data.student_avatar] placeholderImage:_placeHolderImg];
            _imgWed.hidden = false;
            if ([data.attendance isEqualToString:@"0"]) {
                _viewWed.hidden = false;
            }else{
                _viewWed.hidden = true;
            }
        }else if ([data.strDay isEqualToString:@"Thu"]) {
            [_imgThu sd_setImageWithURL:[NSURL URLWithString:data.student_avatar] placeholderImage:_placeHolderImg];
            _imgThu.hidden = false;
            if ([data.attendance isEqualToString:@"0"]) {
                _viewThu.hidden = false;
            }else{
                _viewThu.hidden = true;
            }
        }else if ([data.strDay isEqualToString:@"Fri"]) {
            [_imgFri sd_setImageWithURL:[NSURL URLWithString:data.student_avatar] placeholderImage:_placeHolderImg];
            _imgFri.hidden = false;
            if ([data.attendance isEqualToString:@"0"]) {
                _viewFri.hidden = false;
            }else{
                _viewFri.hidden = true;
            }
        }else if ([data.strDay isEqualToString:@"Sat"]) {
            [_imgSat sd_setImageWithURL:[NSURL URLWithString:data.student_avatar] placeholderImage:_placeHolderImg];
            _imgSat.hidden = false;
            if ([data.attendance isEqualToString:@"0"]) {
                _viewSat.hidden = false;
            }else{
                _viewSat.hidden = true;
            }
        }else if ([data.strDay isEqualToString:@"Sun"]) {
            [_imgSun sd_setImageWithURL:[NSURL URLWithString:data.student_avatar] placeholderImage:_placeHolderImg];
            _imgSun.hidden = false;
            if ([data.attendance isEqualToString:@"0"]) {
                _viewSun.hidden = false;
            }else{
                _viewSun.hidden = true;
            }
        }
    }
}

@end
