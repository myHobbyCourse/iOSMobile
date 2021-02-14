//
//  FormLocationCell.h
//  HobbyCourses
//
//  Created by iOS Dev on 19/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormLocationCell : UITableViewCell

@property(nonatomic,weak) IBOutlet UIImageView *imgVMap;
@property(nonatomic,weak) IBOutlet MKMapView *mapView;
@end
