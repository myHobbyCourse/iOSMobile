//
//  RevisionListCell.h
//  HobbyCourses
//
//  Created by iOS Dev on 06/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RevisionListCell : UITableViewCell
@property(strong,nonatomic) IBOutlet UILabel *lblNo;
@property(strong,nonatomic) IBOutlet UILabel *lblTittle;
@property(strong,nonatomic) IBOutlet UILabel *lblPublishDate;
@property(strong,nonatomic) IBOutlet UILabel *lblBatchDesc;
@property(strong,nonatomic) IBOutlet UILabel *lblChangesCount;
@end
