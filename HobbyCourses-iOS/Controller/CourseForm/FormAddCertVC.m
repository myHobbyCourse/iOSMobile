//
//  FormAddCertVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 20/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "FormAddCertVC.h"

@interface FormAddCertVC (){
    CourseForm *course;

}

@end

@implementation FormAddCertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    tblParent.estimatedRowHeight = 50;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    course = [CourseForm getObjectbyRowID:dataClass.rowID];

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [tblParent reloadData];
    [self updateToGoogleAnalytics:@"Add Certificates Screen"];

}
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataClass.crsCertificate.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UILabel *lblSr = [cell viewWithTag:11];
    UITextField *tf = [cell viewWithTag:12];
    UIImageView *imgv = [cell viewWithTag:13];
    UIButton *btn = [cell viewWithTag:14];
    if (dataClass.crsCertificate.count - 1 == indexPath.row) {
        btn.selected  =  NO;
        imgv.hidden = YES;
    }else{
        btn.selected  =  YES;
        imgv.hidden = NO;
    }
    tf.text = dataClass.crsCertificate[indexPath.row];
    lblSr.text = [NSString stringWithFormat:@"%d",indexPath.row +1];
    
    return cell;
}
#pragma mark - Button Action
-(IBAction)btnAddORemoe:(UIButton*)sender{

    NSIndexPath *index = [[NSIndexPath new] indexPathForCellContainingView:sender inTableView:tblParent];
    NSString *vIdx = [NSString stringWithFormat:@"%ld",(long)index.row];
    if (sender.selected) { // Remove
        [CertificateList deleteCertificate:vIdx];
        [dataClass.crsCertificate removeObjectAtIndex:index.row];
    }else{ // Add row
        if (dataClass.crsCertificate.count == 10) {
            return;
        }
        [dataClass.crsCertificate addObject:@""];
        [CertificateList insertCertificate:@"" index:vIdx courseForm:course];

    }
    [tblParent reloadData];

}
#pragma mark - UItextFeildDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSIndexPath *index = [[NSIndexPath new] indexPathForCellContainingView:textField inTableView:tblParent];
    dataClass.crsCertificate[index.row] = textField.text;
    NSString *vIdx = [NSString stringWithFormat:@"%ld",(long)index.row];
    [CertificateList insertCertificate:textField.text index:vIdx courseForm:course];
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
