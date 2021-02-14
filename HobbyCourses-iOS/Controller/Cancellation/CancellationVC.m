//
//  CancellationVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 06/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "CancellationVC.h"

@interface CancellationVC ()
{
    NSArray *arrBtns,
    *arrTxt,
    *arrDynamicTittle,*arrEx,
    *arrTittle;
    
    int selectedTerms;
}
@end

@implementation CancellationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedTerms = 0;
    self.navigationItem.title = @"Cancellation";
    [self initData];
    tblParent.estimatedRowHeight = 200;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    tblParent.contentInset = UIEdgeInsetsMake(20, 0, 20, 0);
    if (self.terms) {
        selectedTerms = [arrBtns indexOfObject:self.terms];
        if (selectedTerms > arrDynamicTittle.count) {
            selectedTerms = 0;
        }
        [tblParent reloadData];
    }
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Cancellation Screen"];
}
-(void) initData{
    arrBtns = [[NSArray alloc] initWithObjects:@"Open",@"Mild",@"Rigid",@"Firm", nil];
    arrTxt = [[NSArray alloc]initWithObjects:@"Consumers who wish to cancel and seek refund payment for any class activity booked through us are required to contact the specific Class Provider and make such request known."
              ,@"Each Class Provider has its own cancellation and refund policy, therefore consumers are responsible for making themselves aware of such and any change associated with these before booking the class.",
              @"In the event of a default payment by a specific Class Provider, MyHobbyCourses shall not be held responsible for refunding any amount and/or interest for any cancellation request made by any consumer.",
              @"MyHobbyCouses shall deduct payment collection and payment gateway charges collected by us from all refunds payments. ",
              @"No refund will be granted if no cancellation was requested",nil];
    
    arrDynamicTittle = [[NSArray alloc] initWithObjects:@"Open: Full refund two days before class starts except Administration fees.",
                        @"Mild: Full refund 1 week before class starts except Administration fees.",
                        @"Rigid: Full refund 15 days before class starts except Administration fees.",
                        @"Firm: Full refund 30 days before class starts except Administration fees.", nil];
    
    NSDictionary *dict1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"2 days before",@"0",
                           @"Saturday August 21",@"1",
                           @"For a full refund of class fees, cancellation must be done 2 full days (48 hours before) the class begins, administration fees of 5% will be charged",@"2",
                           @"Sunday - Monday August 22-23",@"3",
                           @"If class begins on Monday and cancellation is done less than 48 hours, 50% administration fee will be charged.",@"4", nil];
    
    NSDictionary *dict2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"1 week before",@"0",@"Sunday August 14",@"1",@"For a full refund of class fees, cancellation must be done 1 week the class begins, administration fees of 5% will be charged",@"2",@"Monday August 22",@"3",@"If class begins on Monday and cancellation is done 1 week before class starts, 50% administration fee will be charged.",@"4", nil];
    
    NSDictionary *dict3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"15 days before",@"0",@"Saturday August 7",@"1",@"For a full refund of class fees, cancellation must be done 15 days before the class begins, 5% administration fee will be charged.",@"2",@"Monday August 22",@"3",@"If class begins on Monday and cancellation is done less than 15 days before class starts, 50% administration fee will be charged.",@"4", nil];
    
    NSDictionary *dict4 = [[NSDictionary alloc] initWithObjectsAndKeys:@"30 days before",@"0",@"Saturday July 24",@"1",@"For a full refund of class fees, cancellation must be done 30 days before class begins, 5% administration fee will be charged.",@"2",@"Sunday - Monday August 12",@"3",@"If class begins on Monday and cancellation is done less than 30 before class starts, 50% administration fee will be charged.",@"4", nil];
    arrEx = [[NSArray alloc]initWithObjects:dict1,dict2,dict3,dict4, nil];
    
    arrTittle  = [[NSArray alloc] initWithObjects:@"Full refund except Administration charges of 5% 30 days and if later, 50 % up to Class Start Day",
                  @"Full refund except Administration charges of 5% 1 week before and if later, 50 % up to Class Start Day",
                  @"Full refund except Administration charges of 5% 15 days before and if later, 50 % up to Class Start Day",
                  @"Full refund except Administration charges of 5% 30 days and if later, 50 % up to Class Start Day", nil];
}
-(IBAction)btnTermChanged:(UIButton*)sender{
    selectedTerms = [arrBtns indexOfObject:sender.titleLabel.text];
    [tblParent reloadData];
}
#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return (is_iPad()) ? 2 : 5;
        case 1:
            return 2;
        case 2:
            return arrTxt.count + 1;
        default:
            return 0;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *str = [NSString stringWithFormat:@"Cell%d",indexPath.row];
        switch (indexPath.row) {
            case 0:
            {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
                cell.backgroundColor = [UIColor clearColor];
                
                return cell;
            }
            case 1:
            case 2:
            case 3:
            case 4:
            {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellBtns" forIndexPath:indexPath];
                UIButton *btn = [cell viewWithTag:11];
                /*btn.layer.cornerRadius = 10;
                 btn.layer.shadowColor = [UIColor whiteColor].CGColor;
                 btn.layer.shadowOpacity = 0.7;
                 btn.layer.shadowOffset = CGSizeMake(-1, 1);*/
                if (is_iPad()) {
                    UIButton *btn2 = [cell viewWithTag:12];
                    UIButton *btn3 = [cell viewWithTag:13];
                    UIButton *btn4 = [cell viewWithTag:14];
                    [btn setTitleColor:__THEME_COLOR forState:UIControlStateNormal];
                    [btn2 setTitleColor:__THEME_COLOR forState:UIControlStateNormal];
                    [btn3 setTitleColor:__THEME_COLOR forState:UIControlStateNormal];
                    [btn4 setTitleColor:__THEME_COLOR forState:UIControlStateNormal];
                    if(selectedTerms == 0){
                        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    }else if(selectedTerms == 1){
                        [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    }else if(selectedTerms == 2){
                        [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    }else if(selectedTerms == 3){
                        [btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    }
                    
                }else{
                    [btn setTitle:arrBtns[indexPath.row-1] forState:UIControlStateNormal];
                    if (indexPath.row - 1 == selectedTerms) {
                        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    }else {
                        [btn setTitleColor:__THEME_COLOR forState:UIControlStateNormal];
                    }
                }
                cell.backgroundColor = [UIColor clearColor];
                return cell;
            }
                
            default:{
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
                cell.backgroundColor = [UIColor clearColor];
                return cell;
            }
        }
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
            UILabel *lbl = [cell viewWithTag:11];
            lbl.text = arrDynamicTittle[selectedTerms];
            cell.backgroundColor = __Light_Gray;
            return cell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellTxt" forIndexPath:indexPath];
            UILabel *lbl = [cell viewWithTag:11];
            lbl.text = arrTxt[indexPath.row - 1];
            cell.backgroundColor = __Light_Gray;
            return cell;
        }
    }else{
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellTT" forIndexPath:indexPath];
            UILabel *lblT = [cell viewWithTag:11];
            lblT.text = arrTittle[selectedTerms];
            cell.backgroundColor = [UIColor clearColor];
            return cell;
            
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellEx" forIndexPath:indexPath];
            UILabel *lblT = [cell viewWithTag:11];
            UILabel *lblD1 = [cell viewWithTag:12];
            UILabel *lblD2 = [cell viewWithTag:13];
            UILabel *lblEx1 = [cell viewWithTag:14];
            UILabel *lblEx2 = [cell viewWithTag:15];
            lblT.text = arrEx[selectedTerms][@"0"];
            lblD1.text = arrEx[selectedTerms][@"1"];
            lblEx1.text = arrEx[selectedTerms][@"2"];
            lblD2.text = arrEx[selectedTerms][@"3"];
            lblEx2.text = arrEx[selectedTerms][@"4"];
            cell.backgroundColor = __Light_Gray;
            return cell;
        }
    }
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
