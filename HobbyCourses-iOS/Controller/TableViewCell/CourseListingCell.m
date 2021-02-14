//
//  CourseListingCell.m
//  HobbyCourses
//
//  Created by iOS Dev on 27/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "CourseListingCell.h"

@implementation CourseListingCell

-(void)awakeFromNib {
    [super awakeFromNib];
    self.cvRecent.decelerationRate = UIScrollViewDecelerationRateFast;
    self.cvPopuler.decelerationRate = UIScrollViewDecelerationRateFast;
}

#pragma mark - UICollectionView delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.cvRecent) {
        return self.controller.arrRecentCourse.count;
    }else if (collectionView == _cvFavourites){
        return self.controller.arrFavCourse.count;
    } else if(collectionView == self.cvPopuler){
        return self.controller.arrCourse.count;
    }else if(collectionView == self.cvWeek){
        return self.controller.arrWeekend.count;
    }else if(collectionView == self.cvEvening){
        return self.controller.arrEvenings.count;
    }else if(collectionView == self.cvDetails){
        return (self.controllerDetails == nil)? dataClass.crsImages.count:self.controllerDetails.courseEntity.field_deal_image.count;
        
    }else if (collectionView == self.cvSimilerListing){
        return self.controllerDetails.similerCourses.count;
    }
    return 0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (is_iPad()) {
        if (collectionView == self.cvDetails) {
            return CGSizeMake(_screenSize.width, collectionView.frame.size.height);
        }
        return CGSizeMake(_screenSize.height*0.3, collectionView.frame.size.height);
    }else{
        if (self.cvPopuler == collectionView || self.cvRecent == collectionView || self.cvWeek == collectionView || self.cvSimilerListing == collectionView || self.cvFavourites == collectionView){
            return CGSizeMake((_screenSize.width/2) - (35 * _widthRatio), collectionView.frame.size.height);
        }else if (self.cvEvening == collectionView){
            return CGSizeMake((_screenSize.width/3) - (25 * _widthRatio), collectionView.frame.size.height);
        }else if (self.cvDetails == collectionView){
            return CGSizeMake(_screenSize.width, collectionView.frame.size.height);
        }else{
            return CGSizeMake(_screenSize.width - 40, collectionView.frame.size.height);
        }
    }
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (is_iPad()) {
        int sise = _screenSize.height*0.3;
        int vv = (velocity.x > 0) ? 1: 0;
        int cc = (scrollView.contentOffset.x)/sise;
        int ff = vv + cc;
        targetContentOffset->x = ff * sise;
    }else{
        
        int sise = _screenSize.width - 30;
        
        if (self.cvFavourites == scrollView || self.cvPopuler == scrollView || self.cvRecent == scrollView || self.cvWeek == scrollView || self.cvSimilerListing == scrollView){
            sise = (_screenSize.width/2) - (35 * _widthRatio);
        }else if (self.cvEvening == scrollView  ){
            sise = (_screenSize.width/3) - (25 * _widthRatio);
        }
        int vv = (velocity.x > 0) ? 1: 0;
        int cc = (scrollView.contentOffset.x)/sise;
        int ff = vv + cc;
        targetContentOffset->x = ff * sise;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell;
    if (collectionView == _cvFavourites) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellFav" forIndexPath:indexPath];
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    }
    UIImageView *imgV = [cell viewWithTag:11];
    UIImageView *imgVStar = [cell viewWithTag:222];
    UIImageView *imgAgeGroup = [cell viewWithTag:112];
    UILabel *lblTitle = [cell viewWithTag:12];
    UILabel *lblTime = [cell viewWithTag:13];
    UILabel *lblWeek = [cell viewWithTag:14];
    UILabel *lblGroup = [cell viewWithTag:15];
    UILabel *lblReview = [cell viewWithTag:16];
    UILabel *lblPrice = [cell viewWithTag:17];
    UILabel *lblCity = [cell viewWithTag:18];
    id data;
    lblGroup.text = @"";
    NSMutableArray<CourseDetail*> * arr;
    if (collectionView == self.cvRecent) {
        data = [self.controller.arrRecentCourse objectAtIndex:indexPath.row];
        arr = self.controller.arrRecentCourse;
    }else if (collectionView == _cvFavourites){
        data = [self.controller.arrFavCourse objectAtIndex:indexPath.row];
        lblGroup.text = [arr objectAtIndex:indexPath.row].age_group;
        arr = self.controller.arrFavCourse;
    }else if(collectionView == self.cvPopuler){
        data = [self.controller.arrCourse objectAtIndex:indexPath.row];
        arr = self.controller.arrCourse;
    }else if(collectionView == self.cvSimilerListing) {
        data = [self.controllerDetails.similerCourses objectAtIndex:indexPath.row];
        arr = self.controllerDetails.similerCourses;
    }else if(collectionView == self.cvWeek) {
        data = [self.controller.arrWeekend objectAtIndex:indexPath.row];
        arr = self.controller.arrWeekend;
    }else if(collectionView == self.cvEvening) {
        data = [self.controller.arrEvenings objectAtIndex:indexPath.row];
        arr = self.controller.arrEvenings;
    }else {
        data = [self.controllerDetails.courseEntity.field_deal_image objectAtIndex:indexPath.row];
        arr = self.controllerDetails.courseEntity.field_deal_image;
        
    }
    

    if([data isKindOfClass:[CourseDetail class]]){
        CourseDetail* courseDetail = [arr objectAtIndex:indexPath.row];
        [imgV sd_setImageWithURL:[NSURL URLWithString:(courseDetail.field_deal_image.count > 0) ? [courseDetail.field_deal_image firstObject] : @""]
                placeholderImage:_placeHolderImg];
        lblTitle.text = courseDetail.title;
        lblTime.text =  getTime(courseDetail);
        lblWeek.text =  getDays(courseDetail);
        
        if (courseDetail.productArr.count > 0) {
            ProductEntity * obj = courseDetail.productArr[0];
            lblPrice.text = obj.initial_price;
        }
        lblReview.text = courseDetail.comment_count;
        lblCity.text = courseDetail.city;
        imgVStar.image = [UIImage imageNamed:[NSString stringWithFormat:@"star%@",courseDetail.course_rating]];
        imgAgeGroup.image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_age_%@",[arr objectAtIndex:indexPath.row].age_groupIndex]];
        
    }else if([data isKindOfClass:[NSString class]]) {
        [imgV sd_setImageWithURL:[NSURL URLWithString:(NSString*)data]
                placeholderImage:_placeHolderImg];
    }else if(self.controllerDetails == nil) {
        NSURL *imgUrl = [[DocumentAccess obj] mediaForName:dataClass.crsImages[indexPath.row]];
        if (imgUrl) {
            imgV.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imgUrl] scale:0.8];
        }
    }
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int selected = -1;
    if (collectionView == _cvPopuler) {
        CourseDetail * obj =   self.controller.arrCourse[indexPath.row];
        self.controller.courseNID = obj.nid;
        selected = 0;
        [self.controller performSegueWithIdentifier:@"segueDetails" sender:self];
    }else if (collectionView == self.cvRecent){
        CourseDetail * obj =   self.controller.arrRecentCourse[indexPath.row];
        self.controller.courseNID = obj.nid;
        selected = 1;
        [self.controller performSegueWithIdentifier:@"segueDetails" sender:self];
    }else if (collectionView == self.cvWeek){
        CourseDetail * obj =   self.controller.arrWeekend[indexPath.row];
        self.controller.courseNID = obj.nid;
        selected = 3;
        [self.controller performSegueWithIdentifier:@"segueDetails" sender:self];
    }else if (collectionView == self.cvEvening){
        CourseDetail * obj =   self.controller.arrEvenings[indexPath.row];
        self.controller.courseNID = obj.nid;
        selected = 4;
        [self.controller performSegueWithIdentifier:@"segueDetails" sender:self];
    }else if (collectionView == self.cvFavourites){
        FavCourse * obj =   self.controller.arrFavCourse[indexPath.row];
        self.controller.courseNID = obj.nid;
        selected = 2;
        [self.controller performSegueWithIdentifier:@"segueDetails" sender:self];
    }else if(collectionView == _cvDetails){
        UIStoryboard *mainStoryboard = getStoryBoardDeviceBased(StoryboardMain);
        ImageZoomViewController  *vc;
        UINavigationController *nav;
        if (is_iPad()) {
            nav = [mainStoryboard instantiateViewControllerWithIdentifier: @"ImageZoomNav"];
            vc = nav.viewControllers[0];
        }else{
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ImageZoomViewController"];
        }
        vc.path =[self.controllerDetails.courseEntity.field_deal_image objectAtIndex:indexPath.row];
        if ([self.controllerDetails.courseEntity.field_deal_image isKindOfClass:[NSMutableArray class]]) {
            vc.arrData = self.controllerDetails.courseEntity.field_deal_image;
        }
        vc.course = self.controllerDetails.courseEntity;
        
        [APPDELEGATE.window.rootViewController presentViewController:(is_iPad()) ? nav : vc animated:YES completion:nil];
    }else if(collectionView == _cvSimilerListing) {
        CourseDetail *obj = self.controllerDetails.similerCourses[indexPath.row];
        self.controllerDetails.NID = obj.nid;
        [self.controllerDetails getCourseDetails:obj.nid];
        [self.controllerDetails.tableview setContentOffset:CGPointZero animated:YES];
    }
    if (!is_iPad()) {
        self.controller.selectedIndexPath = indexPath;
        self.controller.selectedSection = selected;
    }
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
