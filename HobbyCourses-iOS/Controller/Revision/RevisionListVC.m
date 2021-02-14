//
//  RevisionListVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 06/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "RevisionListVC.h"

@interface RevisionListVC ()
{
    NSMutableArray<RevisonBatches*> *arrRevionList;
    NSMutableArray<RevisonBatches*> *arrRevionListCopy;
    __weak IBOutlet NSLayoutConstraint *_heightSearch;
    IBOutlet UITextField *txtSearch;
    NSMutableArray *arrSelectedSection;
    
}
@end

@implementation RevisionListVC

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
    tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Course history list Screen"];
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
                            HCLog(@"%@",obj.changesCount);
                            
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return arrRevionList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSIndexPath * index = [NSIndexPath indexPathForRow:1 inSection:section];
    if ([arrSelectedSection containsObject:index]) {
        return arrRevionList[section].arrChanges.count + 1;
    }else{
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        RevisionListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.lblNo.text = [NSString stringWithFormat:@"%ld.",indexPath.row+1];
        cell.lblTittle .text = arrRevionList[indexPath.row].title;
        cell.lblPublishDate .text = arrRevionList[indexPath.row].created;
        cell.lblBatchDesc .text = arrRevionList[indexPath.row].product_id;
        cell.lblChangesCount.text = (_isStringEmpty(arrRevionList[indexPath.row].changesCount)) ? @"-" :arrRevionList[indexPath.row].changesCount;
        return cell;
    }else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];
        UILabel *lbl = [cell viewWithTag:11];
        lbl.text = [NSString stringWithFormat:@"%d. %@",indexPath.row,arrRevionList[indexPath.section].arrChanges[indexPath.row -1]];
        lbl.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor lightGrayColor];
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [self performSegueWithIdentifier:@"segueDetailBatch" sender:arrRevionList[indexPath.row]];
    if (indexPath.row == 0) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
        if ([arrSelectedSection containsObject:index]) {
            [arrSelectedSection removeObject:index];
        }else{
            [arrSelectedSection addObject:index];
        }
        NSIndexSet *set = [[NSIndexSet alloc]initWithIndex:indexPath.section];
        [tableview reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
    }
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
