//
//  PreviewCourseVC_iPad.m
//  HobbyCourses
//
//  Created by iOS Dev on 08/12/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "PreviewCourseVC_iPad.h"

@interface PreviewCourseVC_iPad ()

@end

@implementation PreviewCourseVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    tblParent.estimatedRowHeight = 100;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Preview Course Screen"];
}
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 12;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 1:
        case 2:{
            return 0;
        }
            break;
        case 6:{
            if (dataClass.crsCordinateDict[@"lat"] == nil) { return 0; }
        } break;
            
        case 7:{
            if (_isStringEmpty(dataClass.crsRequirements)) { return 0; }
        } break;
            
            
        default:
            break;
    }
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%d",indexPath.row+1];
    
    switch (indexPath.row) {
        case 0:{
            FromPicCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.controllerPreview = self;
            [cell.cvImages reloadData];
            UILabel *lblPrice = [cell viewWithTag:111];
            lblPrice.text = [NSString stringWithFormat:@"£ %@",(dataClass.arrCourseBatches.count >0) ? dataClass.arrCourseBatches[0].price : @""];
            
            UILabel *lblTitle = [cell viewWithTag:112];
            lblTitle.text = dataClass.crsTitle;
            return cell;
        }
            break;
        case 1:
        case 2:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            UILabel *lblTime = [cell viewWithTag:11];
            UILabel *lblAgeGroup = [cell viewWithTag:12];
            UILabel *lblWeekDay = [cell viewWithTag:13];
            UILabel *lblCity = [cell viewWithTag:14];
            
            lblTime.text =  @"";
            lblWeekDay.text =  @"";
            if (dataClass.arrCourseBatches.count > 0) {
                lblAgeGroup.text = dataClass.crsAgeGroup;
            }
            lblCity.text = dataClass.crsCity;
            
            return cell;
        }
        case 3:{
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            UILabel *lblDesc = [cell viewWithTag:41];
            UIButton *btnMore = [cell viewWithTag:42];
            lblDesc.text = dataClass.crsSummary;
            if (btnMore.selected) {
                lblDesc.numberOfLines = 0;
            }else{
                lblDesc.numberOfLines = 5;
            }
            return cell;
        }
            break;
        case 4:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            UIButton *btnContactEducator = [cell viewWithTag:11];
            btnContactEducator.layer.cornerRadius = 8;
            UILabel *lblTrial = [cell viewWithTag:12];
            UILabel *lblTutor = [cell viewWithTag:13];
            UILabel *lblLand = [cell viewWithTag:14];
            UILabel *lblMobile = [cell viewWithTag:15];
            
            lblTrial.text = [NSString stringWithFormat:@"%@",(dataClass.isTrail) ? @"YES":@"NO"];
            lblTutor.text = [NSString stringWithFormat:@"%@",dataClass.crsTutor];
            lblLand.text = userINFO.landline_numbe;
            lblMobile.text = userINFO.mobile;
            
            return cell;
        }
        case 5:
        {
            CourseDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.controllerPreview = self;
            [cell.cvAmenities reloadData];
            return cell;
        }
        case 6:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            NSString *staticMapUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/staticmap?markers=color:red|%@,%@&%@&sensor=true",dataClass.crsCordinateDict[@"lat"],dataClass.crsCordinateDict[@"lng"],@"zoom=15&size=450x300"];
            NSString * newStringURL = [staticMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            UIImageView *imgV = [cell viewWithTag:11];
            [imgV sd_setImageWithURL:[NSURL URLWithString:newStringURL] placeholderImage:_placeHolderImg];
            return cell;
        }
            
        case 7:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            UILabel *lblReq = [cell viewWithTag:61];
            lblReq.text = [NSString stringWithFormat:@"%@",dataClass.crsRequirements];
            UIButton *btnMore = [cell viewWithTag:62];
            
            if (btnMore.selected) {
                lblReq.numberOfLines = 0;
            }else{
                lblReq.numberOfLines = 3;
            }
            return cell;
        }
        case 8:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            UILabel *lblReq = [cell viewWithTag:91];
            lblReq.text = [NSString stringWithFormat:@"%@",[dataClass.crsCertificate componentsJoinedByString:@","]];
            lblReq.numberOfLines = 0;
            return cell;
        }
        case 9:{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            return cell;
        }
        case 10:{
            CourseDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            //            cell.controllerDetails = self;
            [cell.cvVideo reloadData];
            UIButton *btnMore = [cell viewWithTag:555];
            if (dataClass.crsYoutubeURL.count == 1) {
                btnMore.hidden = true;
            }else{
                btnMore.hidden = false;
            }
            return cell;
        }
        case 11:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell13" forIndexPath:indexPath];
            UIImageView *imgV = [cell viewWithTag:131];
            UILabel *lblTutorName = [cell viewWithTag:132];
            UILabel *lblTutorStatus = [cell viewWithTag:133];
            UIImageView *imgV1 = [cell viewWithTag:135];
            UIImageView *imgV2 = [cell viewWithTag:136];
            UIImageView *imgV3 = [cell viewWithTag:137];
            UIImageView *imgV4 = [cell viewWithTag:138];
            UIImageView *imgV5 = [cell viewWithTag:139];
            UIImageView *imgV6 = [cell viewWithTag:140];
            UILabel *lblReviewCount= [cell viewWithTag:141];
            UIButton *btnOurTutor= [cell viewWithTag:142];
            UIButton *btnOurLocation= [cell viewWithTag:143];
            UIButton *btnOtherCourse= [cell viewWithTag:144];
            UIButton *btnAllReview= [cell viewWithTag:145];
            UILabel *lblEducatorDesc= [cell viewWithTag:146];
            btnOurTutor.layer.cornerRadius = 8;
            btnOurLocation.layer.cornerRadius = 8;
            btnAllReview.layer.cornerRadius = 8;
            btnOtherCourse.layer.cornerRadius = 8;
            imgV.layer.cornerRadius = (_screenSize.width * 0.3)/2;
            imgV.layer.masksToBounds = true;
            [imgV sd_setImageWithURL:[NSURL URLWithString:userINFO.user_picture] placeholderImage:_placeHolderImg];
            lblTutorName.text = userINFO.name;
            lblEducatorDesc.text = userINFO.educator_introduction;
            
            UIButton *btnMore = [cell viewWithTag:147];
            if (btnMore.selected) {
                lblEducatorDesc.numberOfLines = 0;
            }else{
                lblEducatorDesc.numberOfLines = 3;
            }
            
            if ([userINFO.email_verified_flagged.uppercaseString isEqualToString:@"NO"]) {
                imgV1.image = [UIImage imageNamed:@"ic_c_red_tip"];
            }else{
                imgV1.image = [UIImage imageNamed:@"ic_c_green_tip"];
            }
            if ([userINFO.landline_verified_flagged.uppercaseString isEqualToString:@"NO"]) {
                imgV3.image = [UIImage imageNamed:@"ic_c_red_tip"];
            }else{
                imgV3.image = [UIImage imageNamed:@"ic_c_green_tip"];
            }
            if ([userINFO.address_verified_flagged.uppercaseString isEqualToString:@"NO"]) {
                imgV5.image = [UIImage imageNamed:@"ic_c_red_tip"];
            }else {
                imgV5.image = [UIImage imageNamed:@"ic_c_green_tip"];
            }
            if ([userINFO.mobile_verified_flagged.uppercaseString isEqualToString:@"NO"]) {
                imgV2.image = [UIImage imageNamed:@"ic_c_red_tip"];
                
            }else{
                imgV2.image = [UIImage imageNamed:@"ic_c_green_tip"];
            }
            if ([userINFO.social_media_verified_flagged.uppercaseString isEqualToString:@"NO"]) {
                imgV4.image = [UIImage imageNamed:@"ic_c_red_tip"];
            }else{
                imgV4.image = [UIImage imageNamed:@"ic_c_green_tip"];
            }
            if ([userINFO.credit_card_verified_flagged.uppercaseString isEqualToString:@"NO"]) {
                imgV6.image = [UIImage imageNamed:@"ic_c_red_tip"];
            }else{
                imgV6.image = [UIImage imageNamed:@"ic_c_green_tip"];
            }
            
            return cell;
        }
        default:
            break;
    }
    return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
