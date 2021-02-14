//
//  FormBatchesVC_iPad.m
//  HobbyCourses
//
//  Created by iOS Dev on 13/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "FormBatchesVC_iPad.h"

@interface FormBatchesVC_iPad (){
    IBOutlet UIView *viewShadow;
}

@end

@implementation FormBatchesVC_iPad
@synthesize tblLeft,tblRight,currentIndex;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentIndex = 0;

    
    [self addShaowForiPad:viewShadow];
    viewShadow.backgroundColor = __THEME_lightGreen;
    tblRight.estimatedRowHeight = 100;
    tblRight.rowHeight = UITableViewAutomaticDimension;
    tblLeft.estimatedRowHeight = 100;
    tblLeft.rowHeight = UITableViewAutomaticDimension;
    tblLeft.tableFooterView = [UIView new];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"iPad Add batches from Screen"];
}

#pragma mark - UIButton Action
-(IBAction)btnNext:(UIButton*)sender {
    FromOptionVC_iPad *vc = [self.storyboard instantiateViewControllerWithIdentifier: @"FromOptionVC_iPad"];
    [self.navigationController pushViewController:vc animated:true];
    
}
-(IBAction)btnBatchDuration:(UIButton*)sender {
    if(sender.tag == 302){
        if (_isStringEmpty(dataClass.arrCourseBatches[self.currentIndex].startDate)) {
            showAletViewWithMessage(@"First things first, when would you like your class to start?");
            return;
        }
        
        ActionAlert *alert =  [ActionAlert instanceFromNib:kAppName withMessage:@"You can select your class within 6 months of start date." bgColor:__THEME_YELLOW button:@[@"OK"] controller:self block:^(Tapped tapped, ActionAlert *alert) {
            if (tapped == TappedOkay) {
                DateCalenderPickerVC *vc = [getStoryBoardDeviceBased(StoryboardSearch) instantiateViewControllerWithIdentifier:@"DateCalenderPickerVC"];
                vc.strTitle = @"End Date";
                vc.isBeforeToday = YES;
                vc.endDate = [globalDateOnlyFormatter() dateFromString:dataClass.arrCourseBatches[self.currentIndex].startDate];
                [vc getRefreshBlock:^(NSString *anyValue) {
                    dataClass.arrCourseBatches[self.currentIndex].endDate = anyValue;
                    [ClassList insertOrUpdate:dataClass.arrCourseBatches[self.currentIndex].batchID objects:@[anyValue] feildName:BatchEnd];

                    [tblRight reloadData];
                    [tblLeft reloadData];

                }];
                UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:vc];
                [popover presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
            }
            [alert removeFromSuperview];
        }];
        [APPDELEGATE.window addSubview:alert];

    }else{
        
        DateCalenderPickerVC *vc = [getStoryBoardDeviceBased(StoryboardSearch) instantiateViewControllerWithIdentifier:@"DateCalenderPickerVC"];
        vc.strTitle = @"Start Date";
        vc.isBeforeToday = YES;
        [vc getRefreshBlock:^(NSString *anyValue) {
            dataClass.arrCourseBatches[self.currentIndex].startDate = anyValue;
            [ClassList insertOrUpdate:dataClass.arrCourseBatches[self.currentIndex].batchID objects:@[anyValue] feildName:BatchStart];
            [tblRight reloadData];
            [tblLeft reloadData];
        }];
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:vc];
        [popover presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
}
-(IBAction)btnAddNewBatches:(id)sender {
    ActionAlert *alert =  [ActionAlert instanceFromNib:kAppName withMessage:@"Do you want to add a new batch?" bgColor:__THEME_YELLOW button:@[@"NO",@"YES"] controller:self block:^(Tapped tapped, ActionAlert *alert) {
        if (tapped == TappedOkay) {
            Batches *obj = [[Batches alloc]init];
            NSString *uID = GetTimeStampString;
            obj.batchID = uID;
            [ClassList insertOrUpdate:uID objects:@[] feildName:FeildNameNone];
            [dataClass.arrCourseBatches addObject:obj];
            currentIndex = dataClass.arrCourseBatches.count - 1;
            [tblLeft reloadData];
            [tblRight reloadData];
        }
        [alert removeFromSuperview];
    }];
    [APPDELEGATE.window addSubview:alert];
}
-(IBAction)btnDeleteNewBatches:(id)sender{
    if  (dataClass.arrCourseBatches.count == 1) {
        return;
    }
    ActionAlert *alert =  [ActionAlert instanceFromNib:kAppName withMessage:@"Do you want to delete current batch Details?" bgColor:__THEME_YELLOW button:@[@"NO",@"YES"] controller:self block:^(Tapped tapped, ActionAlert *alert) {
        if (tapped == TappedOkay) {
            [ClassList deleteClass:dataClass.arrCourseBatches[currentIndex].batchID];
            [dataClass.arrCourseBatches removeObjectAtIndex:currentIndex];
            currentIndex = (currentIndex == 0) ? currentIndex : currentIndex - 1;
            [tblLeft reloadData];
            [tblRight reloadData];
        }
        [alert removeFromSuperview];
    }];
    [APPDELEGATE.window addSubview:alert];
}
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == tblLeft) {
        return dataClass.arrCourseBatches.count;
    } else{
        return 5;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == tblRight) {
        if (indexPath.row == 4) {
            CellCalenderBatch * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell4" forIndexPath:indexPath];
            cell.controller = self;
            [cell refreshCalender];
            return cell;
        }else{
            NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%ld",(long)indexPath.row];
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            UIView *viewBorder = [cell viewWithTag:111];
            UIView *viewBorder2 = [cell viewWithTag:112];
            if (viewBorder) {
                viewBorder.layer.borderColor = __THEME_lightGreen.CGColor;
                viewBorder.layer.borderWidth = 1.0;
            }
            if(viewBorder2){
                viewBorder2.layer.borderColor = __THEME_lightGreen.CGColor;
                viewBorder2.layer.borderWidth = 1.0;
            }
            switch (indexPath.row) {
                case 0:{
                    UITextField *tfBatchTitle = [cell viewWithTag:11];
                    tfBatchTitle.text = [NSString stringWithFormat:@"Class %d",currentIndex + 1];
                    tfBatchTitle.userInteractionEnabled = false;
                }   break;
                case 1:{
                    UITextField *tfSession = [cell viewWithTag:11];
                    UITextField *tfSize = [cell viewWithTag:12];
                    tfSession.text = dataClass.arrCourseBatches[self.currentIndex].sessions;
                    tfSize.text = dataClass.arrCourseBatches[self.currentIndex].classSize;
                }   break;
                case 2:{
                    UITextField *tfPrice = [cell viewWithTag:21];
                    UITextField *tfDiscount = [cell viewWithTag:22];
                    tfPrice.text = dataClass.arrCourseBatches[self.currentIndex].price;
                    tfDiscount.text = dataClass.arrCourseBatches[self.currentIndex].discount;
                }   break;
                case 3:{
                    UITextField *tfStart = [cell viewWithTag:11];
                    UITextField *tfEnd = [cell viewWithTag:12];
                    tfStart.text = dataClass.arrCourseBatches[self.currentIndex].startDate;
                    tfEnd.text = dataClass.arrCourseBatches[self.currentIndex].endDate;
                }  break;
                    
                default:
                    break;
            }
            return cell;
        }
    }else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        UILabel *lbl = [cell viewWithTag:11];
        lbl.text = [NSString stringWithFormat:@"Class %ld",indexPath.row + 1];
        if (indexPath.row == self.currentIndex) {
            cell.backgroundColor = [UIColor colorWithRed:159.0/255.0 green:213.0/255.0 blue:214.0/255.0 alpha:1.0];
        }else{
            cell.backgroundColor = [UIColor clearColor];
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tblLeft == tableView) {
        self.currentIndex = indexPath.row;
        [tblLeft reloadData];
        [tblRight reloadData];
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    switch (textField.tag) {
        case 11:
        case 12: {
            return [AppUtils numericValidation:textField range:range string:string length:2 withFloat:false];
        }   break;
        case 21:
        case 22:
        {
            return [AppUtils numericValidation:textField range:range string:string length:6 withFloat:false];
        }
            break;
        default:
            break;
    }
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 21) {
        
        dataClass.arrCourseBatches[self.currentIndex].price = textField.text;
        
        [ClassList insertOrUpdate:dataClass.arrCourseBatches[self.currentIndex].batchID objects:@[textField.text] feildName:BatchPrice];
        
        if (_isStringEmpty(dataClass.arrCourseBatches[self.currentIndex].discount)) {
            
            dataClass.arrCourseBatches[self.currentIndex].discount = dataClass.arrCourseBatches[self.currentIndex].price;
            [ClassList insertOrUpdate:dataClass.arrCourseBatches[self.currentIndex].batchID objects:@[textField.text] feildName:BatchDiscount];
            
        }else if (dataClass.arrCourseBatches[self.currentIndex].discount.integerValue > dataClass.arrCourseBatches[self.currentIndex].price.integerValue) {
            
            dataClass.arrCourseBatches[self.currentIndex].discount = dataClass.arrCourseBatches[self.currentIndex].price;
            [ClassList insertOrUpdate:dataClass.arrCourseBatches[self.currentIndex].batchID objects:@[textField.text] feildName:BatchDiscount];
        }
    }else if(textField.tag == 22) {
        
        if (!_isStringEmpty(dataClass.arrCourseBatches[self.currentIndex].price) && dataClass.arrCourseBatches[self.currentIndex].discount.integerValue > dataClass.arrCourseBatches[self.currentIndex].price.integerValue) {
            
            dataClass.arrCourseBatches[self.currentIndex].discount = dataClass.arrCourseBatches[self.currentIndex].price;
            
            [ClassList insertOrUpdate:dataClass.arrCourseBatches[self.currentIndex].batchID objects:@[dataClass.arrCourseBatches[self.currentIndex].discount] feildName:BatchDiscount];

        }else{
            dataClass.arrCourseBatches[self.currentIndex].discount = textField.text;
            
            [ClassList insertOrUpdate:dataClass.arrCourseBatches[self.currentIndex].batchID objects:@[textField.text] feildName:BatchDiscount];

        }
    }else if(textField.tag == 11) {
        [ClassList insertOrUpdate:dataClass.arrCourseBatches[self.currentIndex].batchID objects:@[textField.text] feildName:BatchSession];
        dataClass.arrCourseBatches[self.currentIndex].sessions = textField.text;

    }else if(textField.tag == 12){
        [ClassList insertOrUpdate:dataClass.arrCourseBatches[self.currentIndex].batchID objects:@[textField.text] feildName:BatchSize];

        dataClass.arrCourseBatches[self.currentIndex].classSize = textField.text;

    }
    [tblRight reloadData];
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
