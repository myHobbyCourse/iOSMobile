//
//  FromYouTubeURLsVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 20/09/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "FromYouTubeURLsVC.h"

@interface FromYouTubeURLsVC (){
    CourseForm *course;
    NSMutableArray *arrVideos;
}

@end

@implementation FromYouTubeURLsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    tblParent.estimatedRowHeight = 60;
    tblParent.rowHeight = UITableViewAutomaticDimension;
    arrVideos = [NSMutableArray new];
    course = [CourseForm getObjectbyRowID:dataClass.rowID];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [tblParent reloadData];
    [self updateToGoogleAnalytics:@"Youtube Screen"];
}
-(IBAction)btnSaveVideo:(id)sender {
    int i = 0;
    for(NSString *str in dataClass.crsYoutubeURL) {
        if (![[str lowercaseString] containsString:@"youtube.com"]) {
            showAletViewWithMessage([NSString stringWithFormat:@"Please add valid (%d) youtube video url ex: youtube.com/",i + 1]);
            break;
        }
        i += 1;
    }
                                     
    [self parentDismiss:nil];
}
#pragma mark- UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UILabel *lblSr = [cell viewWithTag:11];
    UITextField *tf = [cell viewWithTag:12];
    if (indexPath.row < dataClass.crsYoutubeURL.count) {
        tf.text = dataClass.crsYoutubeURL[indexPath.row];
    }else{
        tf.text = @"";
    }
    lblSr.text = [NSString stringWithFormat:@"%ld",indexPath.row +1];
    return cell;
}
#pragma mark - UItextFeildDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSIndexPath *index = [[NSIndexPath new] indexPathForCellContainingView:textField inTableView:tblParent];

    if (!_isStringEmpty(textField.text)) {
        if (index.row < dataClass.crsYoutubeURL.count) {
            dataClass.crsYoutubeURL[index.row] = textField.text;
        }else{
            dataClass.crsYoutubeURL[index.row] = textField.text;
        }
        
        [VideoList insertVideos:textField.text index:[NSString stringWithFormat:@"%ld",(long)index.row] courseForm:course];
        
        [tblParent reloadData];
    }else{
        [dataClass.crsYoutubeURL removeObjectAtIndex:index.row];
        [VideoList deleteVideos:[NSString stringWithFormat:@"%ld",(long)index.row]];
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
