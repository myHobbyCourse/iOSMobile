//
//  PreviewCourseVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 15/10/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "PreviewCourseVC.h"
#import "Amenities.h"

@interface PreviewCourseVC (){
    NSArray *arrAgeTitle,*cellIdf;
    NSDictionary *attributesText,*attributesReadmore;
    
}

@end

@implementation PreviewCourseVC
@synthesize arrAmenities;
- (void)viewDidLoad {
    [super viewDidLoad];
    tblParent.estimatedRowHeight = 100;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    cellIdf = @[@[@"cellImages", @"cellPlaceAge", @"cellTimer", @"cellAbout", @"cellHost", @"cellContact", @"cellAmenities", @"cellDesc", @"cellReq",],@[@"cellCertificate"], @[@"cellCancellation", @"cellVideo", @"cellLink", @"cellReviews", @"cellWriteReview",@"cellTutor"], @[@"cellButton"],@[@"cellMsg", @"cellMap",
                                                                                                                                                                                                                                                                                                     @"CellListing"]];

    UIFont *font = [UIFont hcOpenSansRegularWithSize:(21 * _widthRatio)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:2];
    attributesText = @{NSFontAttributeName:font,
                       NSForegroundColorAttributeName:[UIColor darkGrayColor],
                       NSBackgroundColorAttributeName:[UIColor clearColor],
                       NSParagraphStyleAttributeName:paragraphStyle,
                       };
    
    attributesReadmore = @{NSFontAttributeName:font,
                           NSForegroundColorAttributeName:ThemEColor,
                           NSBackgroundColorAttributeName:[UIColor clearColor],
                           NSParagraphStyleAttributeName:paragraphStyle,
                           };
    arrAmenities = [NSMutableArray new];
    [self getAmenitiesList];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [tblParent reloadData];
}
-(void) getAmenitiesList{
    [self startActivity];
    [[NetworkManager sharedInstance] postRequestUrl:apiGetAmenities paramter:nil withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        HCLog(@"%@",jsonData);
        if (result == WebServiceResultSuccess) {
            for (NSDictionary *dict in jsonData) {
                Amenities * obj = [[Amenities alloc]initWith:dict];
                if ([dataClass.crsAmenities containsObject:obj.title]) {
                    [arrAmenities addObject:obj];    
                }
                
            }
            [tblParent reloadData];
        }
    }];
}
#pragma mark- UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 9;
        case 1:{
            int i = 0;
            for(NSString *str in dataClass.crsCertificate){
                if (!_isStringEmpty(str)) {
                    i += 1;
                }
            }
            return i;
        }
        case 2:
            return 6;
        case 3:
            return 5;
        case 4:
            return 3;
        default:
            return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellImages"]) {
            return  410 * _widthRatio;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellPlaceAge"]) {
            return 110 * _widthRatio;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellTimer"]) {
            return 0;//(timerDate) ? 200 * _widthRatio : 70 * _widthRatio;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellHost"]) {
            return 335 * _widthRatio;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellContact"]) {
            return 256 * _widthRatio;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellAmenities"]) {
            return (dataClass.crsAmenities.count > 0) ? 140 * _widthRatio : 0;
        }
    }else if (indexPath.section == 2){
        if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellCancellation"]) {
            return 75 * _widthRatio;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellVideo"]) {
            if (dataClass.crsYoutubeURL.count == 0 ) {
                return 0;
            }else{
                return 200 * _widthRatio;
            }
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellLink"]) {
            return 55 * _widthRatio;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellReviews"]) {
            return 0;
        }
    }else if(indexPath.section == 3){
        return 45 * _widthRatio;
    }else if (indexPath.section == 4){
        if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"CellListing"]) {
            return 0;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellMap"]) {
            return 290 * _widthRatio;
        }
    }
    
    
    return UITableViewAutomaticDimension;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
    }else{
        // Remove seperator inset
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        // Prevent the cell from inheriting the Table View's margin settings
        if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
        // Explictly set your cell's layout margins
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier;
    
    Batches *produt =  (dataClass.arrCourseBatches.count > 0) ? dataClass.arrCourseBatches[0] : [Batches new];
    if (indexPath.section == 0) {
        
        cellIdentifier = cellIdf[indexPath.section][indexPath.row];
        if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellImages"]) {
            
            CourseListingCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            [cell.cvDetails reloadData];
            cell.lblTitle.text = dataClass.crsTitle;
            cell.lblPrice.text = produt.price;
            cell.lblReviewCount.text = @"0";
            cell.lblCity.text = dataClass.crsCity;
            UIImageView *imgVStar = [cell viewWithTag:222];
            imgVStar.image = [UIImage imageNamed:[NSString stringWithFormat:@"star%@",@"0"]];
            cell.lblPeopleSaved.text = [NSString stringWithFormat:@"%@ People Saved this",@"0"];
            cell.lblSutableFor.text =  @"Both";
            return cell;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellPlaceAge"]) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            UILabel *lblTime = [cell viewWithTag:11];
            UILabel *lblAgeGroup = [cell viewWithTag:12];
            UIImageView *imgAgeGroup = [cell viewWithTag:112];
            
            UILabel *lblWeekDay = [cell viewWithTag:13];
            UILabel *lblCity = [cell viewWithTag:14];
            
            imgAgeGroup.image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_age_%ld",(long)dataClass.crsAgeGroupIndex]];
            lblTime.text =  produt.classSize;
            lblWeekDay.text = @"";// getDays(self.courseEntity);
            lblAgeGroup.text = dataClass.crsAgeGroup;
            lblCity.text = dataClass.crsCity;
            return cell;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellTimer"]) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
//            [self updateCellTimer:cell];
            return cell;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellAbout"]) {
            ConstrainedTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            [cell layoutIfNeeded];

            ReadMoreTextView *lblDesc = [cell viewWithTag:1];
            lblDesc.attributedReadMoreText = [[NSMutableAttributedString alloc] initWithString:@"... Read more" attributes:attributesReadmore];
            lblDesc.attributedReadLessText = [[NSMutableAttributedString alloc] initWithString:@" Read less" attributes:attributesReadmore];;
            
            lblDesc.attributedText = [[NSAttributedString alloc]initWithString:dataClass.crsShortDesc attributes:attributesText];
            [lblDesc setNeedsUpdateTrim];
            [lblDesc layoutIfNeeded];
            return cell;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellHost"]) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
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
            
            btnOurTutor.layer.cornerRadius = 8;
            btnOurLocation.layer.cornerRadius = 8;
            btnAllReview.layer.cornerRadius = 8;
            btnOtherCourse.layer.cornerRadius = 8;
            imgV.layer.cornerRadius = (60 * _widthRatio)/2;
            imgV.layer.masksToBounds = true;
            [imgV sd_setImageWithURL:[NSURL URLWithString:userINFO.user_picture] placeholderImage:_placeHolderImg];
            
            [lblTutorName setAttributedText:@[@"Offered by ",dataClass.crsTutor] attributes:@[@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName: [UIFont hcOpenSansRegularWithSize:21 * _widthRatio]},@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName: [UIFont hcOpenSansRegularWithSize:21 * _widthRatio]}]];
            lblTutorStatus.text = [NSString stringWithFormat:@"Member Since %@",userINFO.created];
            lblReviewCount.text = @"0";
            
            if ([userINFO.email_verified_flagged.uppercaseString isEqualToString:@"NO"]) {
                imgV1.image = [UIImage imageNamed:@"ic_wrong"];
            }else{
                imgV1.image = [UIImage imageNamed:@"ic_right"];
            }
            if ([userINFO.landline_verified_flagged.uppercaseString isEqualToString:@"NO"]) {
                imgV3.image = [UIImage imageNamed:@"ic_wrong"];
            }else{
                imgV3.image = [UIImage imageNamed:@"ic_right"];
            }
            if ([userINFO.address_verified_flagged.uppercaseString isEqualToString:@"NO"]) {
                imgV5.image = [UIImage imageNamed:@"ic_wrong"];
            }else {
                imgV5.image = [UIImage imageNamed:@"ic_right"];
            }
            if ([userINFO.mobile_verified_flagged.uppercaseString isEqualToString:@"NO"]) {
                imgV2.image = [UIImage imageNamed:@"ic_wrong"];
                
            }else{
                imgV2.image = [UIImage imageNamed:@"ic_right"];
            }
            if ([userINFO.social_media_verified_flagged.uppercaseString isEqualToString:@"NO"]) {
                imgV4.image = [UIImage imageNamed:@"ic_wrong"];
            }else{
                imgV4.image = [UIImage imageNamed:@"ic_right"];
            }
            if ([userINFO.credit_card_verified_flagged.uppercaseString isEqualToString:@"NO"]) {
                imgV6.image = [UIImage imageNamed:@"ic_wrong"];
            }else{
                imgV6.image = [UIImage imageNamed:@"ic_right"];
            }
            
            return cell;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellContact"]) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            UIButton *btnContactEducator = [cell viewWithTag:11];
            btnContactEducator.layer.cornerRadius = 8;
            UILabel *lblTrial = [cell viewWithTag:12];
            UILabel *lblTutor = [cell viewWithTag:13];
            UILabel *lblLand = [cell viewWithTag:14];
            UILabel *lblMobile = [cell viewWithTag:15];
            
            lblTrial.text = [NSString stringWithFormat:@"%@",dataClass.isTrail];
            lblTutor.text = [NSString stringWithFormat:@"%@",dataClass.crsTutor];
            if (!_isStringEmpty(userINFO.landline_numbe) && userINFO.landline_numbe.length > 6) {
                NSString * first3 = [userINFO.landline_numbe substringWithRange:NSMakeRange(0, 3)];
                NSString * last3 = [userINFO.landline_numbe substringWithRange:NSMakeRange(0, 3)];
                lblLand.text = [NSString stringWithFormat:@"%@*%@",first3,last3];
            }else{
                lblLand.text = [NSString stringWithFormat:@"%@",userINFO.landline_numbe];
            }
            if (!_isStringEmpty(userINFO.mobile) && userINFO.mobile.length > 6) {
                NSString * first3 = [userINFO.mobile substringWithRange:NSMakeRange(0, 3)];
                NSString * last3 = [userINFO.mobile substringWithRange:NSMakeRange(0, 3)];
                lblMobile.text = [NSString stringWithFormat:@"%@*%@",first3,last3];
            }else{
                lblMobile.text = [NSString stringWithFormat:@"%@",userINFO.mobile];
            }
            return cell;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellAmenities"]) {
            CourseDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.controllerPreview = self;
            [cell.cvAmenities reloadData];
            return cell;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellDesc"]) {
            ConstrainedTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            [cell layoutIfNeeded];

            ReadMoreTextView *lblDesc = [cell viewWithTag:1];
            lblDesc.attributedReadMoreText = [[NSMutableAttributedString alloc] initWithString:@"... Read more" attributes:attributesReadmore];
            lblDesc.attributedReadLessText = [[NSMutableAttributedString alloc] initWithString:@" Read less" attributes:attributesReadmore];;
            
            lblDesc.attributedText = [[NSAttributedString alloc]initWithString:dataClass.crsSummary attributes:attributesText];
            
            [lblDesc setNeedsUpdateTrim];
            [lblDesc layoutIfNeeded];
            
            return cell;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellReq"]) {
            ConstrainedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            [cell layoutIfNeeded];

            ReadMoreTextView *lblDesc = [cell viewWithTag:1];
            lblDesc.attributedReadMoreText = [[NSMutableAttributedString alloc] initWithString:@"... Read more" attributes:attributesReadmore];
            lblDesc.attributedReadLessText = [[NSMutableAttributedString alloc] initWithString:@" Read less" attributes:attributesReadmore];;
            
            lblDesc.attributedText = [[NSAttributedString alloc]initWithString:dataClass.crsRequirements attributes:attributesText];
            
            [lblDesc setNeedsUpdateTrim];
            [lblDesc layoutIfNeeded];
            
            return cell;
        }
    }else if(indexPath.section == 1){
        cellIdentifier = @"cellCertificate";
        
        GenericTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.lblTitle.text = (indexPath.row == 0) ? @"Certificates" : @"";
        cell.lblSubTitle.text = [dataClass.crsCertificate[indexPath.row] trimmedString];
        return cell;
    }else if(indexPath.section == 2) {
        cellIdentifier = cellIdf[indexPath.section][indexPath.row];
        
        if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellCancellation"]) {
            GenericTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.lblTitle.text = (_isStringEmpty(dataClass.crsCancellation)) ? @"--" : dataClass.crsCancellation;
            return cell;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellVideo"]) {
            CourseDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.controllerPreview = self;
            return cell;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellLink"]) {
            CourseDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            UILabel *lblLink = [cell viewWithTag:91];
            lblLink.text = @"http://tinyurl.com/m85yt";
            return cell;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellReviews"]) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            UILabel *lblReviewCount = [cell viewWithTag:71];
            UIButton *btnReview = [cell viewWithTag:76];
            btnReview.layer.cornerRadius = 8;
            lblReviewCount.text = @"0 Reviews";
            
            return cell;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellWriteReview"]) {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            return cell;
            
        } else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellTutor"]) {
            GenericTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            [cell layoutIfNeeded];
            ReadMoreTextView *lblDesc = [cell viewWithTag:1];
            lblDesc.attributedReadMoreText = [[NSMutableAttributedString alloc] initWithString:@"... Read more" attributes:attributesReadmore];
            lblDesc.attributedReadLessText = [[NSMutableAttributedString alloc] initWithString:@" Read less" attributes:attributesReadmore];;
            
            lblDesc.attributedText = [[NSAttributedString alloc]initWithString:userINFO.educator_introduction attributes:attributesText];
            [lblDesc setNeedsUpdateTrim];
            [lblDesc layoutIfNeeded];
            return cell;
        }
    }else if(indexPath.section == 3){
        GenericTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellButton" forIndexPath:indexPath];
        if(indexPath.row == 0) {
            [cell.lblTitle setAttributedText:@[@"Reviews: 0"] attributes:@[@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName: [UIFont hcOpenSansRegularWithSize:17 * _widthRatio]},@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName: [UIFont hcOpenSansRegularWithSize:17 * _widthRatio]}]];
        }else if(indexPath.row == 1) {
            cell.lblTitle.text = @"Our tutors";
        }else if(indexPath.row == 2) {
            cell.lblTitle.text = @"Our locations";
        }else if(indexPath.row == 3) {
            cell.lblTitle.text = @"My other courses";
        }else if(indexPath.row == 4) {
            cell.lblTitle.text = @"All reviews";
        }
        return cell;
        
    }else {
        cellIdentifier = cellIdf[indexPath.section][indexPath.row];
        
        if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"CellListing"]) {
            CourseListingCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            return cell;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellMap"]) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            NSString *staticMapUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/staticmap?markers=color:red|%@,%@&%@&sensor=true",dataClass.crslat,dataClass.crslng,@"zoom=15&size=450x300"];
            NSString * newStringURL = [staticMapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            UIImageView *imgV = [cell viewWithTag:11];
            [imgV sd_setImageWithURL:[NSURL URLWithString:newStringURL] placeholderImage:_placeHolderImg];
            return cell;
        }else if ([cellIdf[indexPath.section][indexPath.row] isEqualToString:@"cellMsg"]) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            UIButton *btnSendMsg = [cell viewWithTag:141];
            UILabel *lblUpdateOn = [cell viewWithTag:144];
            lblUpdateOn.text = @"-";
            btnSendMsg.layer.cornerRadius = 8;
            return cell;
        }else {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            return cell;
            
        }
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}


/*- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
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
