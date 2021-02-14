//
//  OrderDetailCell.h
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 18/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailCell : UITableViewCell
{
    IBOutlet UILabel *lblCourseTittle;
    IBOutlet UILabel *lblbilling_info;
    IBOutlet UILabel *lblorder_total;
    IBOutlet UILabel *lblseller;
    IBOutlet UILabel *lblprice;
    IBOutlet UILabel *lblquantity;
    IBOutlet UILabel *lblstart_date;
    IBOutlet UILabel *lblend_date;
    IBOutlet UILabel *lblsum;
    IBOutlet UILabel *lblcourse_address;
    IBOutlet UILabel *lblseller_info;
    IBOutlet UILabel *lblCoupon;
    IBOutlet UIButton *btnBankInfo;
    IBOutlet UIButton *btnBatchDetails;
    
    IBOutlet UILabel *lblSellerName;
    IBOutlet UILabel *lblSellerAddress;
    IBOutlet UILabel *lblSellerMobile;
    IBOutlet UILabel *lblSellerLand;
    IBOutlet UILabel *lblSellerEmail;
    
    IBOutlet UILabel *lblBorder_iPad;


}
@property(nonatomic,strong) IBOutlet UIButton *btnDetails;
-(void) setData:(OrderDetail*) oderDetail summery:(UserOrder*) headerOrder;

@end
