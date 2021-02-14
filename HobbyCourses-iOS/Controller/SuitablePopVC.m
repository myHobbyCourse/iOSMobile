//
//  SuitablePopVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 29/03/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import "SuitablePopVC.h"

@interface SuitablePopVC (){
    NSMutableAttributedString *attributedText;
}

@end

@implementation SuitablePopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    tblParent.estimatedRowHeight = 50;
    tblParent.rowHeight = UITableViewAutomaticDimension;
  
//    NSMutableAttributedString* attrString = [[NSMutableAttributedString  alloc] initWithString:@"The suitability of the course is restricted to either all the ladies or to all the gentlemen until be mentioned otherwise for both of them."];
//    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//    [style setLineSpacing:24];
//    [attrString addAttribute:NSParagraphStyleAttributeName
//                       value:style
//                       range:NSMakeRange(0, attrString.length)];
//    attributedText = attrString;
    
    UIFont *font = [UIFont hcOpenSansRegularWithSize:(is_iPad()) ? 20 : (23 * _widthRatio)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.paragraphSpacing = 100 * font.lineHeight;
    [paragraphStyle setLineSpacing:8];
    NSDictionary *attributes = @{NSFontAttributeName:font,
                                 NSForegroundColorAttributeName:[UIColor darkGrayColor],
                                 NSBackgroundColorAttributeName:[UIColor clearColor],
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 };
     attributedText = [[NSMutableAttributedString alloc] initWithString:@"The suitability of the course is restricted to either all the ladies or to all the gentlemen until be mentioned otherwise for both of them." attributes:attributes];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 230 * _widthRatio;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        NSString *identifer = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
        GenericTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.lblTitle.attributedText = attributedText;
    }
        return cell;
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
