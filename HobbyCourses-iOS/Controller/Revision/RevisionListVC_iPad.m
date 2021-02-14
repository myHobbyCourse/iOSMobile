//
//  RevisionListVC_iPad.m
//  HobbyCourses
//
//  Created by iOS Dev on 07/11/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "RevisionListVC_iPad.h"

@interface RevisionListVC_iPad ()
{
    NSMutableArray<RevisonBatches*> *arrRevionList;
    NSMutableArray<RevisonBatches*> *arrRevionListCopy;
    NSMutableArray *arrSelectedSection;
    NSInteger selectedRow;
    
    __weak IBOutlet NSLayoutConstraint *_heightSearch;
    IBOutlet UITextField *txtSearch;
    IBOutlet UIView *viewShadow;
    
}
@end

@implementation RevisionListVC_iPad
- (void)viewDidLoad {
    [super viewDidLoad];
    tableview.estimatedRowHeight = 80;
    tableview.rowHeight = UITableViewAutomaticDimension;
    [self getRevisonList];
    self.title = @"All Courses";
    arrSelectedSection = [[NSMutableArray alloc]init];
    
    arrRevionList = [[NSMutableArray alloc]init];
    arrRevionListCopy = [[NSMutableArray alloc]init];
    [txtSearch addTarget:self action:@selector(searchTextValueChange:) forControlEvents:UIControlEventEditingChanged];
    _heightSearch.constant = 0;
    selectedRow = 0;
    tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    // Do any additional setup after loading the view.
    [self addShaowForiPad:viewShadow];
    viewShadow.backgroundColor = [UIColor whiteColor];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"iPad Course history list Screen"];
}

#pragma mark Search
-(IBAction)btnSearchOpen:(UIButton*)sender{
    [self.view endEditing:true];
    if (_heightSearch.constant == 0) {
        [UIView animateWithDuration:0.2 animations:^{
            _heightSearch.constant = 50;
            [self.view layoutIfNeeded];
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            _heightSearch.constant = 0;
            [self.view layoutIfNeeded];
            
        }];
        txtSearch.text = @"";
        [self searchTextValueChange:txtSearch];
    }
}
-(void)searchTextValueChange:(UITextField *)textFiled
{
    if (textFiled.text.tringString.length > 1) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.title contains[c] %@ OR self.created contains[c] %@ OR self.product_id contains[c] %@",textFiled.text,textFiled.text,textFiled.text];
        arrRevionList = [[arrRevionListCopy filteredArrayUsingPredicate:predicate] mutableCopy];
    }else{
        [arrRevionList removeAllObjects];
        [arrRevionList addObjectsFromArray:arrRevionListCopy];
    }
    [tableview reloadData];
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    textField.text = @"";
    [self searchTextValueChange:textField];
    return true;
}
#pragma mark - API Calles
-(void) getRevisonList {
    [self startActivity];
    [[NetworkManager sharedInstance] postRequestUrl:apiRevisonList paramter:nil withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        tableview.hidden = NO;
        if (result == WebServiceResultSuccess) {
            if ([jsonData isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in jsonData) {
                    if ([dict isKindOfClass:[NSDictionary class]]) {
                        NSMutableDictionary *d = [dict mutableCopy];
                        [d handleNullValue];
                        RevisonBatches *obj = [[RevisonBatches alloc]initWith:d];
                        [obj getRefreshBlock:^(NSString *anyValue) {
                            [tableview reloadData];
                            [tblParent reloadData];
                            HCLog(@"%@",obj.changesCount);
                            lblChanges.text = [NSString stringWithFormat:@"Changes %@",obj.changesCount];
                        }];
                        [arrRevionList addObject:obj];
                        [arrRevionListCopy addObject:obj];
                        
                    }else{
                        tableview.hidden = YES;
                        showAletViewWithMessage(@"Awkward…No Class history found for you");
                        
                        break;
                    }
                    
                }
                [tableview reloadData];
            }
        }
    }];
    
}

#pragma mark - UITableDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == tblParent)
        return 1;
    
    return arrRevionList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == tblParent) {
        
        if(section < arrRevionList.count && arrRevionList[section].arrChanges.count > 0 && selectedRow == section){
            return arrRevionList[section].arrChanges.count;
        }
        return 0;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tableview) {
        RevisionListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.lblNo.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        cell.lblTittle .text = arrRevionList[indexPath.row].title;
        cell.lblTittle.textColor = __THEME_GRAY;
        cell.lblNo.textColor = __THEME_GRAY;
        cell.lblPublishDate .text = arrRevionList[indexPath.row].created;
        cell.lblBatchDesc .text = arrRevionList[indexPath.row].product_id;
        cell.lblChangesCount.text = (_isStringEmpty(arrRevionList[indexPath.row].changesCount)) ? @"-" :arrRevionList[indexPath.row].changesCount;
        
        if (selectedRow == indexPath.section) {
            cell.backgroundColor = __THEME_lightGreen;
            cell.lblPublishDate.textColor = [UIColor whiteColor];
            cell.lblBatchDesc.textColor = [UIColor whiteColor];
        }else{
            cell.backgroundColor = [UIColor whiteColor];
            cell.lblPublishDate.textColor = __THEME_GRAY;
            cell.lblBatchDesc.textColor = __THEME_GRAY;
        }

        
        return cell;
    }else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];
        NSString *strDate = arrRevionList[indexPath.section].arrChanges[indexPath.row];
        NSDate *dateObj = [ddMMMyyhhmma() dateFromString:strDate];
        
        UILabel *lbl = [cell viewWithTag:11];
        lbl.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
        
        UILabel *lbl1 = [cell viewWithTag:12];
        //        self.change_date = [NSString stringWithFormat:@"%@",[ddMMMyyhhmma() stringFromDate:dd]];
        
        lbl1.text = [NSString stringWithFormat:@"%@",[globalDateOnlyFormatter() stringFromDate:dateObj]];
        
        UILabel *lbl2 = [cell viewWithTag:13];
        lbl2.text = [NSString stringWithFormat:@"%@",[_timeFormatter() stringFromDate:dateObj]];
        
        cell.backgroundColor = [UIColor whiteColor];
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tableview){
        selectedRow = indexPath.section;
        lblChanges.text = [NSString stringWithFormat:@"Changes %lu",(unsigned long)arrRevionList[indexPath.section].arrChanges.count];
    }

    
    [tableview reloadData];
    [tblParent reloadData];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"segueDetailBatch"]) {
        RevisionDetailVC * vc = segue.destinationViewController;
        vc.product = sender;
    }
}

@end
