//
//  ProductCell.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 01/06/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "ProductCell.h"

@implementation ProductCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setData:(ProductEntity *)product
{
    NSDateFormatter *df = globalDateOnlyFormatter();
    NSDateFormatter *dffff = global2DIGItYearFormatter();
    NSDate *dStart = [df dateFromString:product.course_start_date];
    NSDate *dEnd = [df dateFromString:product.course_end_date];
    if (dStart){
        NSString *strDate = [dffff stringFromDate:dStart];
        if (strDate) {
            self.lblStartDate.text = strDate;
        }else{
            self.lblStartDate.text = product.course_start_date;
        }
    }
    if (dEnd){
        NSString *strDate = [dffff stringFromDate:dEnd];
        if (strDate) {
            self.lblEndDate.text = strDate;
        }else{
            self.lblEndDate.text = product.course_end_date;
        }
    }
    NSString* totalString = [product.initial_price stringByTrimmingCharactersInSet: [NSCharacterSet symbolCharacterSet]];

    self.lblSessions.text = product.sessions_number;
    self.lblBatchSize.text = product.batch_size;
    self.lblPice.text = totalString;
}

-(BOOL) checkString:(NSString*) str
{
    if ([str isKindOfClass:[NSNull class]] || str == nil || [str isEqualToString:@""] || str.length == 0)
    {
        return true;
    }
    return false;
    
}
@end
