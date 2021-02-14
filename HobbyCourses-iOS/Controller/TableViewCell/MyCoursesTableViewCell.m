//
//  MyCoursesTableViewCell.m
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/15/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import "MyCoursesTableViewCell.h"

@implementation MyCoursesTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void) setOfflineData:(DataClass*) course {
    lblName.text = [NSString stringWithFormat:@"  %@  ",course.crsCategory.category];
    lblTitle.text = course.crsTitle;
    
    
    lblBatchSize.text = course.crsBatch;
    lblTutor.text = course.crsTutor;;
    lblLoccation.text = course.crsCity;
    lblPost.text = [NSString stringWithFormat:@"Uploaded - "];
    lblAvailable.text = [NSString stringWithFormat:@"Available until -"];
    if (course.crsImages.count > 0) {
        imgV.image = course.crsImages[0];
    }
    
    
    [btnUsers setTitle:[NSString stringWithFormat:@"%@", course.crsBatch] forState:UIControlStateNormal];
    [btnPost setTitle:[NSString stringWithFormat:@"Uploaded -"] forState:UIControlStateNormal];
    [btnAvailable setTitle:[NSString stringWithFormat:@"Available until -"] forState:UIControlStateNormal];
    
}
- (void) setData:(CourseDetail*) course {
    lblName.text = [NSString stringWithFormat:@"  %@  ",course.category];
    lblTitle.text = course.title;
    if (course.productArr && course.productArr.count> 0 ) {
        ProductEntity * obj = course.productArr[0];
        lblBatchSize.text = obj.batch_size;
        lblTutor.text = course.author;;
        lblLoccation.text = course.city;
        lblPost.text = [NSString stringWithFormat:@"Uploaded - %@",course.post_date];
        lblAvailable.text = [NSString stringWithFormat:@"Available until %@",obj.course_end_date];
        if (course.field_deal_image.count > 0) {
            [imgV sd_setImageWithURL:[NSURL URLWithString:course.field_deal_image[0]] placeholderImage:_placeHolderImg];
        }
        
        
        [btnUsers setTitle:[NSString stringWithFormat:@"%@", obj.batch_size] forState:UIControlStateNormal];
        [btnPost setTitle:[NSString stringWithFormat:@"Uploaded - %@",course.post_date] forState:UIControlStateNormal];
        [btnAvailable setTitle:[NSString stringWithFormat:@"Available until %@",obj.course_end_date] forState:UIControlStateNormal];
    }
}

@end
