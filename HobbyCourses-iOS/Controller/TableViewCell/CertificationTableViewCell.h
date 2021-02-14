//
//  CertificationTableViewCell.h
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/18/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CertificationTableViewCell : UITableViewCell {
    IBOutlet UILabel*       lblText;
}

- (void) setDataCertificate:(NSString*) txt;
@end
