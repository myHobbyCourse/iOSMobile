//
//  SelectCityTableViewCell.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 13/02/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectCityTableViewCell : UITableViewCell
{
    IBOutlet UILabel *lblCity;
    
    IBOutlet UIButton *btnSelection;
}
@property (strong,nonatomic) IBOutlet UILabel *lblCity;
@property (strong,nonatomic) IBOutlet UIButton *btnSelection;
@end
