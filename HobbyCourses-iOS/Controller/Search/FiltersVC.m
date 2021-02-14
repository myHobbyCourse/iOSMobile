//
//  FiltersVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 25/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "FiltersVC.h"

@interface FiltersVC ()<CalenderPickerDelegate>{
    NSArray *arrFilters;
}

@end

@implementation FiltersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateUI];
    arrFilters = [[NSArray alloc] initWithObjects:@"Age Group",@"Price",@"Number of Sessions",@"End Date",@"Weekdays", nil];
   // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Search Filter Screen"];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [tblParent reloadData];
}
-(void) updateUI {
    tblParent.estimatedRowHeight = 90;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    tblParent.tableFooterView = [[UIView alloc]init];
}
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrFilters.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell0" forIndexPath:indexPath];
    UIImageView *imgV = [cell viewWithTag:111];
    UILabel *lblCaption = [cell viewWithTag:11];
    UILabel *lblValue = [cell viewWithTag:12];
    lblCaption.text = arrFilters[indexPath.row];
    imgV.hidden = true;
    switch (indexPath.row) {
        case 0:
            if ([self checkStringValue:_searchObj.ageGroup]) {
                lblValue.text = @"No Preference";
                lblValue.textColor = [UIColor lightGrayColor];
            }else{
                lblValue.text = _searchObj.ageGroup;
                lblValue.textColor = [UIColor blackColor];
                imgV.hidden = false;
            }
            break;
        case 1:
            if ([self checkStringValue:_searchObj.price]) {
                lblValue.text = @"No Preference";
                lblValue.textColor = [UIColor lightGrayColor];
            }else{
                lblValue.text = self.searchObj.price;
                lblValue.textColor = [UIColor blackColor];
                imgV.hidden = false;
            }
            break;
        case 2:
            if ([self checkStringValue:_searchObj.sessions]) {
                lblValue.text = @"No Preference";
                lblValue.textColor = [UIColor lightGrayColor];
            }else{
                lblValue.text = _searchObj.sessions;
                lblValue.textColor = [UIColor blackColor];
                imgV.hidden = false;
            }
            break;
        case 3:
            if ([self checkStringValue:_searchObj.endDate]) {
                lblValue.text = @"No Preference";
                lblValue.textColor = [UIColor lightGrayColor];
            }else{
                lblValue.text = _searchObj.endDate;
                lblValue.textColor = [UIColor blackColor];
                imgV.hidden = false;
            }
            break;
        case 4:
            if (_searchObj.weekDays.count > 0) {
                lblValue.text = [_searchObj.weekDays componentsJoinedByString:@","];
                lblValue.textColor = [UIColor blackColor];
                imgV.hidden = false;
            }else{
                lblValue.text = @"No Preference" ;
                lblValue.textColor = [UIColor lightGrayColor];
            }
            
            break;
            
        default:
            break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_async(dispatch_get_main_queue(), ^{
    
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"segueAge" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"seguePrice" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"segueSession" sender:self];
            break;
        case 3:
            [self performSegueWithIdentifier:@"segueEnd" sender:self];
            break;
        case 4:
            [self performSegueWithIdentifier:@"segueWeekDays" sender:self];
            break;
        default:
            break;
    }
        });
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    if ([segue.identifier isEqualToString:@"segueAge"]) {
        AgeSelectionVC *vc = segue.destinationViewController;
        vc.searchObj = _searchObj;
    }
    if ([segue.identifier isEqualToString:@"seguePrice"]) {
        PriceRangeVC *vc = segue.destinationViewController;
        vc.searchObj = _searchObj;
    }if ([segue.identifier isEqualToString:@"segueSession"]) {
        SessionSelectionVC *vc = segue.destinationViewController;
        vc.searchObj = _searchObj;
    }if ([segue.identifier isEqualToString:@"segueWeekDays"]) {
        WeekDaysVC *vc = segue.destinationViewController;
        vc.searchObj = _searchObj;
    }if ([segue.identifier isEqualToString:@"segueEnd"]) {
        DateCalenderPickerVC *vc = segue.destinationViewController;
        vc.strTitle = @"End Date";
        vc.delegate = self;
    }

}
#pragma Delegates
- (void) selectedCalenderDate:(NSString*) date index:(NSInteger) pos {
    _searchObj.endDate = date;
    [tblParent reloadData];
    [DefaultCenter postNotificationName:@"searchAdvanceAPI" object:self];

}

-(IBAction)btnClearFilters:(id)sender {
    ActionAlert *alert =  [ActionAlert instanceFromNib:kAppName withMessage:@"do you want to clear FILTERs" bgColor:__THEME_YELLOW button:@[@"NO",@"YES"] controller:self block:^(Tapped tapped, ActionAlert *alert) {
        if (tapped == TappedOkay) {
            _searchObj.priceRangeMin = nil;
            _searchObj.priceRangeMax = nil;
            _searchObj.price = nil;
            _searchObj.ageGroup = nil;
            _searchObj.endDate = nil;
            [_searchObj.weekDays removeAllObjects];
            _searchObj.sessions = nil;
            [tblParent reloadData];
            [DefaultCenter postNotificationName:@"searchCoursesAPI" object:self];
            
        }
        [alert removeFromSuperview];
    }];
    [APPDELEGATE.window addSubview:alert];
}
@end
