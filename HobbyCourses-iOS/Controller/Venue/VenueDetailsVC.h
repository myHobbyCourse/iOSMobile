//
//  VenueDetailsVC.h
//  HobbyCourses
//
//  Created by iOS Dev on 17/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VenueDetailsVC : ParentViewController
{
    IBOutlet UIImageView *imgTutor;
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblDesc;
    IBOutlet UIButton *btnUpadateVenue;
    IBOutlet UIButton *btnDeleteVenue;

}
@property(strong,nonatomic) VenuesEntity *venue;
@property(assign) BOOL isFromDetails;
@end
