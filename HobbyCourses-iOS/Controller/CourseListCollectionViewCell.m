//
//  CourseListCollectionViewCell.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 24/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "CourseListCollectionViewCell.h"

@implementation CourseListCollectionViewCell
@synthesize imgScroll;



- (void) setCourseData:(Course*) course customCell:(CourseListCollectionViewCell *)cell
{
    @try
    {
        lblName.text = [NSString stringWithFormat:@"%@->%@",course.category,course.sub_category];
        lblTitle.text = course.title;
        lblDuration.text = [self getTime:course];
        lblPeriod.text = [self getDays:course];
        if (course.productArr.count > 0) {
            ProductEntity *obj = course.productArr[0];
            lblAges.text = @"";
            lblPrice.text = obj.initial_price;
            
            NSString* totalString = [obj.initial_price stringByTrimmingCharactersInSet: [NSCharacterSet symbolCharacterSet]];
            NSString* discountString = [obj.price stringByTrimmingCharactersInSet: [NSCharacterSet symbolCharacterSet]];
            float total = totalString.floatValue;
            float discount = discountString.floatValue;
            lblDiscount.text = [NSString stringWithFormat:@"£%.2f",100 - ((total/discount) * 100)];
            priceView.hidden = false;
        }else{
            priceView.hidden = true;
        }
        
        
        lblLocation.text = course.city;
        lblNotifyCount.text = course.comment_count;
        [btnLocation setTitle:course.city forState:UIControlStateNormal];
        lblNotifyCount.layer.cornerRadius = lblNotifyCount.frame.size.width/2;
        lblNotifyCount.layer.masksToBounds = YES;
        
        int i=0;
        for (NSString *image in course.images)
        {
            if (i == 0)
            {   [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageHighPriority];
            }
            if(i == 1)
            {
                [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:image]
                                   placeholderImage:[UIImage imageNamed:@"placeholder"]];
            }
            if(i == 2)
            {
                [self.imageView3 sd_setImageWithURL:[NSURL URLWithString:image]
                                   placeholderImage:[UIImage imageNamed:@"placeholder"]];
            }
            i++;
        }
    }
    @catch (NSException *exception) {
        
    }
}
- (void) setData:(CourseDetail*) course customCell:(CourseListCollectionViewCell *)cell
{
    @try
    {
        lblName.text = course.category;
        lblTitle.text = course.title;
        lblDuration.text = [self getTime:course];
        lblPeriod.text = [self getDays:course];
        if (course.productArr.count > 0) {
            ProductEntity *obj = course.productArr[0];
            lblAges.text = @"";
            lblPrice.text = obj.initial_price;
            NSString* totalString = [obj.initial_price stringByTrimmingCharactersInSet: [NSCharacterSet symbolCharacterSet]];
            NSString* discountString = [obj.price stringByTrimmingCharactersInSet: [NSCharacterSet symbolCharacterSet]];
            float total = totalString.floatValue;
            float discount = discountString.floatValue;
            lblDiscount.text = [NSString stringWithFormat:@"£%.2f",100 - ((total/discount) * 100)];
            priceView.hidden = false;
        }else{
            priceView.hidden = true;
        }        lblLocation.text = course.city;
        lblNotifyCount.text = course.comment_count;
        [btnLocation setTitle:course.city forState:UIControlStateNormal];
        
        lblNotifyCount.layer.cornerRadius = lblNotifyCount.frame.size.width/2;
        lblNotifyCount.layer.masksToBounds = YES;
        int i=0;
        for (NSString *image in course.field_deal_image)
        {
            if (i == 0)
            {
                [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageHighPriority];
                
            }
            if(i == 1)
            {
                [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:image]
                                   placeholderImage:[UIImage imageNamed:@"placeholder"]];
            }
            if(i == 2)
            {
                [self.imageView3 sd_setImageWithURL:[NSURL URLWithString:image]
                                   placeholderImage:[UIImage imageNamed:@"placeholder"]];
            }
            i++;
        }
    }
    @catch (NSException *exception) {
        
    }
}
-(NSString*) getDays:(id) entity
{
    NSString *names = @"";
    if ([entity isKindOfClass:[Course class]])
    {
        Course * course = entity;
        if(course.productArr.count > 0) {
            ProductEntity * ent = course.productArr[0];
            if(ent.timingsDate.count > 0){
                TimeBatch *obj = ent.timingsDate[0];
                NSMutableArray *weekArray =  [self getWeekDateFrom:obj.sDate];
                for (TimeBatch *times in ent.timingsDate) {
                    
                    NSComparisonResult result = [times.sDate compare:[weekArray firstObject]]; // comparing two dates
                    NSComparisonResult result2 = [times.sDate compare:[weekArray lastObject]]; // comparing two dates
                    if(result== NSOrderedDescending && result2 == NSOrderedAscending)
                    {
                        if ([names isEqualToString:@""]) {
                            names = times.dayName;
                        }else{
                            names = [NSString stringWithFormat:@"%@,%@",names,times.dayName];
                        }
                    }
                }
            }
        }
    }
    else
    {
        CourseDetail * course = entity;
        if(course.productArr.count > 0) {
            ProductEntity * ent = course.productArr[0];
            if(ent.timingsDate.count > 0){
                TimeBatch *obj = ent.timingsDate[0];
                NSMutableArray *weekArray =  [self getWeekDateFrom:obj.sDate];
                for (TimeBatch *times in ent.timingsDate) {
                    
                    NSComparisonResult result = [times.sDate compare:[weekArray firstObject]]; // comparing two dates
                    NSComparisonResult result2 = [times.sDate compare:[weekArray lastObject]]; // comparing two dates
                    if(result== NSOrderedDescending && result2 == NSOrderedAscending)
                    {
                        if ([names isEqualToString:@""]) {
                            names = times.dayName;
                        }else{
                            names = [NSString stringWithFormat:@"%@,%@",names,times.dayName];
                        }
                    }
                }
            }
        }
    }
    return names;
    
}
- (NSMutableArray*)getWeekDateFrom:(NSDate *)week {
    
    NSDate *date = [self nextDayFromDate:week];
    NSDateComponents *components;
    NSDateComponents *components2 = [[NSDateComponents alloc] init];
    [components2 setDay:1];
    
    NSMutableArray *_weekdays = [[NSMutableArray alloc] init];
    
    for (register unsigned int i=0; i < 7; i++) {
        [_weekdays addObject:date];
        components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
        [components setDay:1];
        date = [CURRENT_CALENDAR dateByAddingComponents:components2 toDate:date options:0];
    }
    return _weekdays;
}
- (NSDate *)nextDayFromDate:(NSDate *)date {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
    [components setDay:[components day] + 1];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    return [CURRENT_CALENDAR dateFromComponents:components];
}

-(NSString*) getTime:(id) entity
{
    if ([entity isKindOfClass:[Course class]])
    {
        Course * course = entity;
        NSDateFormatter *format24 = global24Formatter();
        NSDateFormatter *fromatTime = _timeFormatter();
        NSMutableArray *times =[[NSMutableArray alloc]init];
        if (course.productArr && course.productArr.count > 0) {
            for (ProductEntity *obj in course.productArr) {
                for (NSDictionary * d in obj.timings) {
                    if (d[@"value"] != nil && d[@"value2"] != nil) {
                        NSString *start = d[@"value"];
                        NSString *end = d[@"value2"];
                        NSDate *s1 = [format24 dateFromString:start];
                        NSDate *e2 = [format24 dateFromString:end];
                        if (s1 && e2) {
                            NSString  *startDate = [fromatTime stringFromDate:s1];
                            NSString *endDate = [fromatTime stringFromDate:e2];
                            [times addObject:[NSString stringWithFormat:@"%@-%@",startDate,endDate]];
                        }
                    }
                    if (times.count > 0) {
                        break;
                    }
                }
                if (times.count > 0) {
                    break;
                }
            }
        }
        
        return (times.count == 0)? @"":times[0];
    }
    else
    {
        CourseDetail * course = entity;
        NSDateFormatter *format24 = global24Formatter();
        NSDateFormatter *fromatTime = _timeFormatter();
        NSMutableArray *times =[[NSMutableArray alloc]init];
        if (course.productArr && course.productArr.count > 0) {
            for (ProductEntity *obj in course.productArr) {
                for (NSDictionary * d in obj.timings) {
                    if (d[@"value"] != nil && d[@"value2"] != nil) {
                        NSString *start = d[@"value"];
                        NSString *end = d[@"value2"];
                        NSDate *s1 = [format24 dateFromString:start];
                        NSDate *e2 = [format24 dateFromString:end];
                        if (s1 && e2) {
                            NSString  *startDate = [fromatTime stringFromDate:s1];
                            NSString *endDate = [fromatTime stringFromDate:e2];
                            [times addObject:[NSString stringWithFormat:@"%@-%@",startDate,endDate]];
                        }
                    }
                    if (times.count > 0) {
                        break;
                    }
                }
                if (times.count > 0) {
                    break;
                }
            }
        }
        return (times.count == 0)? @"":times[0];
    }
    return @"";
    
}
-(BOOL) checkString:(NSString*) str
{
    if ([str isKindOfClass:[NSNull class]] || str == nil || [str isEqualToString:@""] || str.length == 0)
    {
        return true;
    }
    return false;
    
}
- (IBAction)btnLocationTapped:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(btnLocationButtonTapped:)]) {
        [self.delegate performSelector:@selector(btnLocationButtonTapped:) withObject:self];
    }
}
- (IBAction)btnCommentTapped:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(btnCommentBtnTapped:)]) {
        [self.delegate performSelector:@selector(btnCommentBtnTapped:) withObject:self];
    }
}


@end
