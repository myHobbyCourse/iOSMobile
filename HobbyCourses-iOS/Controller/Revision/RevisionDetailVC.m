//
//  RevisionDetailVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 07/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "RevisionDetailVC.h"
#import "Revision.h"

@interface RevisionDetailVC ()
{
    NSMutableArray<Revision*> *arrRevision;
}
@end

@implementation RevisionDetailVC
@synthesize product;

- (void)viewDidLoad {
    [super viewDidLoad];
    tableview.estimatedRowHeight = 100;
    tableview.rowHeight = UITableViewAutomaticDimension;
    
    arrRevision = [NSMutableArray new];
    [self getRevisonDetails];
    self.title = @"My Course History";
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Course history detail Screen"];
}

#pragma mark - API Calls
-(void) getRevisonDetails {
    [self startActivity];
    [[NetworkManager sharedInstance] postRequestUrl:apiRevisionDetails paramter:@{@"product_id": product.product_id} withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        if (result == WebServiceResultSuccess) {
            for (NSMutableDictionary *dict in jsonData) {
                Revision *obj = [[Revision alloc]initWith:dict];
                [arrRevision addObject:obj];
            }
        }
        [tableview reloadData];
    }];
    
}
#pragma mark - UITableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return arrRevision.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return arrRevision[section - 1].arrHistory_timing.count + 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        RevisionListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.lblTittle .text = product.title;
        cell.lblPublishDate .text = product.created;
        cell.lblBatchDesc .text = product.product_id;
    
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = [UIColor whiteColor];
        }else{
            cell.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
        }
        return cell;
    }else{
        Revision * objRevision = arrRevision[indexPath.section -1];
        if (indexPath.row == 0) {
            RevisionListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CellData" forIndexPath:indexPath];
            cell.lblTittle.text = [NSString stringWithFormat:@"Price: %@",objRevision.history_data.price];
            cell.lblPublishDate.text = [NSString stringWithFormat:@"Batch Size: %@",objRevision.history_data.batch_size];
            cell.lblBatchDesc.text = [NSString stringWithFormat:@"Age: %@",objRevision.history_data.age_group];
         
            cell.lblTittle.textColor = [UIColor blackColor];
            cell.lblPublishDate.textColor = [UIColor blackColor];
            cell.lblBatchDesc.textColor = [UIColor blackColor];
            return cell;
        }else{
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CellTime" forIndexPath:indexPath];
            RevisionHistoryTimings * objTimings = objRevision.arrHistory_timing[indexPath.row -1];
            UILabel * lbl1 = [cell viewWithTag:11];
            UILabel * lbl2 = [cell viewWithTag:12];
            UILabel * lbl3 = [cell viewWithTag:13];
            lbl1.text = objTimings.title;
            lbl2.text = objTimings.start;
            lbl3.text = objTimings.end;
            return cell;
        }
    }
}


@end
