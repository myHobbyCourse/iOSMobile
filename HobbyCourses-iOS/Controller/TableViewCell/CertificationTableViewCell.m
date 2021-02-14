//
//  CertificationTableViewCell.m
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/18/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import "CertificationTableViewCell.h"

@implementation CertificationTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void) setDataCertificate:(NSString*) txt {
    lblText.text = txt;
}

@end