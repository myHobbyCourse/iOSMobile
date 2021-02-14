//
//  SignUpCell.m
//  HobbyCourses
//
//  Created by iOS Dev on 24/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "SignUpCell.h"

@implementation SignUpCell
@synthesize controller;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
#pragma mark- UITextView Delegate
- (IBAction)textViewDidEditing:(UITextField *)textView
{
    if(is_iPad()){
        if (textView.tag == 11100) {
            _controller_iPAD.userdetail.name = textView.text;
        }else if (textView.tag == 11101) {
            _controller_iPAD.userdetail.mail = textView.text;
        }else if (textView.tag == 11110) {
            _controller_iPAD.userdetail.first_name = textView.text;
        }else if (textView.tag == 11111) {
            _controller_iPAD.userdetail.last_name = textView.text;
        }else if (textView.tag == 11112) {
            _controller_iPAD.userdetail.mobile = textView.text;
        }else if (textView.tag == 11113) {
            _controller_iPAD.userdetail.landline_numbe = textView.text;
        }else if (textView.tag == 11120) {
            _controller_iPAD.userdetail.address = textView.text;
        }else if (textView.tag == 11121) {
            _controller_iPAD.userdetail.address_2 = textView.text;
        }else if (textView.tag == 22200) {
            _controller_iPAD.userdetail.city = textView.text;
        }else if (textView.tag == 22201) {
            _controller_iPAD.userdetail.postal_code = textView.text;
        }else if (textView.tag == 22210) {
            _controller_iPAD.userdetail.company_name = textView.text;
        }else if (textView.tag == 22211) {
            _controller_iPAD.userdetail.company_number = textView.text;
        }else if (textView.tag == 22212) {
            _controller_iPAD.userdetail.field_vat_registration_number = textView.text;
        }else if (textView.tag == 22213) {
            _controller_iPAD.userdetail.website = textView.text;
        }
    }else{
        if (textView.tag == 00) {
            controller.userdetail.name = textView.text;
        }else if (textView.tag == 01) {
            controller.userdetail.mail = textView.text;
        }else if (textView.tag == 10) {
            controller.userdetail.first_name = textView.text;
        }else if (textView.tag == 11) {
            controller.userdetail.last_name = textView.text;
        }else if (textView.tag == 12) {
            controller.userdetail.mobile = textView.text;
        }else if (textView.tag == 13) {
            controller.userdetail.landline_numbe = textView.text;
        }else if (textView.tag == 20) {
            controller.userdetail.address = textView.text;
        }else if (textView.tag == 21) {
            controller.userdetail.address_2 = textView.text;
        }else if (textView.tag == 22) {
            controller.userdetail.city = textView.text;
        }else if (textView.tag == 23) {
            controller.userdetail.postal_code = textView.text;
        }else if (textView.tag == 30) {
            controller.userdetail.company_name = textView.text;
        }else if (textView.tag == 31) {
            controller.userdetail.company_number = textView.text;
        }else if (textView.tag == 32) {
            controller.userdetail.field_vat_registration_number = textView.text;
        }else if (textView.tag == 33) {
            controller.userdetail.website = textView.text;
        }else if (textView.tag == 34) {
            controller.userdetail.reference = textView.text;
        }else if (textView.tag == 35) {
            controller.userdetail.offerCode = textView.text;
        }
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    switch (textField.tag) {
        case 12:
        case 13:
        case 31:
        case 32:
        case 22212:
        case 11112:
        case 11113:
        case 22211:
            textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
            
        default:
            textField.keyboardType = UIKeyboardTypeDefault;
            break;
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    switch (textField.tag) {
        case 00:
        case 11100:{
            return [AppUtils stringOnlyValidation:textField shouldChangeCharactersInRange:range replacementString:string length:30 withSpace:YES];
        }   break;
        case 12:
        case 11112:{
            return [AppUtils numericValidation:textField range:range string:string length:10 withFloat:false];
        }
            break;
        case 13:
        case 11113:{
            return [AppUtils numericValidation:textField range:range string:string length:12 withFloat:false];
        }
            break;
        case 20:
        case 11120:{
            return [AppUtils stringOnlyValidation:textField shouldChangeCharactersInRange:range replacementString:string length:30 withSpace:YES];
        }
            break;
        case 21:
        case 11121:{
            return [AppUtils stringOnlyValidation:textField shouldChangeCharactersInRange:range replacementString:string length:30 withSpace:YES];
        }
            break;
        case 31:
        case 22211:{
            return [AppUtils numericValidation:textField range:range string:string length:8 withFloat:false];
        }
            break;
        case 32:
        case 22212:{
            return [AppUtils numericValidation:textField range:range string:string length:9 withFloat:false];
        }
            break;
        case 33:
        case 22213:{
            return [AppUtils textValidation:textField shouldChangeCharactersInRange:range replacementString:string length:60 withSpecialChars:YES];
        }
            break;
        default:
            break;
    }
    
    return YES;
}
@end
