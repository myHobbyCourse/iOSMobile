//
//  VendorCollectionReusableView.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 21/02/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VendorCollectionReusableView : UICollectionReusableView
{
    IBOutlet UIImageView *imgProfile;
    IBOutlet UILabel *lblCourseTittle;
    IBOutlet UILabel *lblCourseDesc;
    IBOutlet RateView *rate1;
}
@property(strong,nonatomic) IBOutlet UIImageView *imgProfile;
@property(strong,nonatomic) IBOutlet UILabel *lblCourseTittle;
@property(strong,nonatomic) IBOutlet UILabel *lblCourseDesc;
@property(strong,nonatomic) IBOutlet RateView *rate1;

@end
