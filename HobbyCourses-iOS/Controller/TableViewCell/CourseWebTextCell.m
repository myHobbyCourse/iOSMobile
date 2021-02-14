//
//  CourseWebTextCell.m
//  HobbyCourses
//
//  Created by iOS Dev on 29/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "CourseWebTextCell.h"

@implementation CourseWebTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *output = [self.webViewDesc stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"foo\").offsetHeight;"];
    NSLog(@"height: %@", output);
    if (self.controllerDetails.isDescSize != 0) {
        return;
    }
    if (output.intValue > 90) {
        self.btnReadMore.hidden = false;
    }else{
        self.btnReadMore.hidden = true;
        __descHeight.constant = output.intValue;
    }
}
@end
