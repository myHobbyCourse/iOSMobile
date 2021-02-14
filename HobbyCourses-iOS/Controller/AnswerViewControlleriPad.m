//
//  AnswerViewControlleriPad.m
//  HobbyCourses-iOS
//
//  Created by Kirit on 27/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "AnswerViewControlleriPad.h"

@interface AnswerViewControlleriPad ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arrayForBool;
}
@end

@implementation AnswerViewControlleriPad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrayForBool = [[NSMutableArray alloc]init];
    
    self.tableViewFAQ.rowHeight = UITableViewAutomaticDimension;
    self.tableViewFAQ.estimatedRowHeight = 100;
    
    self.tableViewFAQ.dataSource = self;
    self.tableViewFAQ.delegate   = self;
    
    [self.tableViewFAQ reloadData];
}



-(void)reloadData
{
    [self.tableViewFAQ reloadData];

    [arrayForBool removeAllObjects];
    
    for (int i=0; i< self.tableViewFAQ.numberOfSections ; i++)
    {
        [arrayForBool addObject:[NSNumber numberWithBool:NO]];
    }
    
    [self.tableViewFAQ reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSArray *array = [self.arrayFAQs allValues];
    return array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[arrayForBool objectAtIndex:indexPath.section] boolValue])
    {

        NSArray *allValues = [self.arrayFAQs allValues];
        
        NSString *str = [[allValues objectAtIndex:indexPath.section] firstObject];

        CGSize constrainedSize = CGSizeMake(self.tableViewFAQ.frame.size.width - 56 , 9999);
        
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIFont fontWithName:@"HelveticaNeue" size:15.0], NSFontAttributeName,
                                              nil];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str attributes:attributesDictionary];
        
        CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];

        
        return (requiredHeight.size.height + 20 < 60)?60:requiredHeight.size.height + 20;
    }
    return 0;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (arrayForBool.count > section && [[arrayForBool objectAtIndex:section] boolValue])
    {
        return 1;
    }
    else
        return 0;
    
//    NSArray *array = [self.arrayFAQs allValues];
//    return array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1"];
    cell.tag = section;

    NSArray *allKeys   = [self.arrayFAQs allKeys];
    UILabel *lblQuestion = (UILabel *)[cell viewWithTag:100];
    lblQuestion.text = [allKeys objectAtIndex:section];
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [cell addGestureRecognizer:headerTapped];
    return cell;
        
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
//    NSArray *allKeys   = [self.arrayFAQs allKeys];
        NSArray *allValues = [self.arrayFAQs allValues];
        
//        UILabel *lblQuestion = (UILabel *)[cell viewWithTag:100];
        UILabel *lblAnswer   = (UILabel *)[cell viewWithTag:101];
        
//        lblQuestion.text = [allKeys objectAtIndex:indexPath.row];
        lblAnswer.text = [[allValues objectAtIndex:indexPath.section] firstObject];
  
    return cell;
}

- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.row == 0) {
        BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        for (int i=0; i< self.tableViewFAQ.numberOfSections; i++) {
            if (indexPath.section==i) {
                [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
            }
        }
        [self.tableViewFAQ reloadData];
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
