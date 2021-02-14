//
//  SelectCityViewController.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 13/02/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "SelectCityViewController.h"

@interface SelectCityViewController ()
{
    NSMutableArray *arrCopyCity;
    NSString *strSelectedCity;
    IBOutlet NSLayoutConstraint *widthView;
}
@end

@implementation SelectCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrCity = [[NSMutableArray alloc]init];
    arrCopyCity = [[NSMutableArray alloc]init];
    btnApply.layer.cornerRadius = 5;
    btnApply.layer.masksToBounds = true;
    viewContainer.layer.cornerRadius = 8;
    viewContainer.clipsToBounds = true;
    viewContainer.layer.masksToBounds = true;
    
    [self getCityList];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"City Selection Screen"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:true];
    if (self.isShowbtn)
    {
        btnClose.hidden =false;
    }else{
        btnClose.hidden =true;
    }
    
    [tblCityList reloadData];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        // Do something when in landscape
        widthView.constant = self.view.frame.size.width * 0.3;
    }
    else
    {
        // Do something when in portrait
        widthView.constant = self.view.frame.size.width * 0.4;
    }
    
}

-(IBAction)btnClose:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void) orientationChanged:(NSNotification *)note
{
    UIDevice * device = note.object;
    switch(device.orientation)
    {
        case UIDeviceOrientationPortrait:
            /* start special animation */
            widthView.constant = self.view.frame.size.width * 0.4;
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            /* start special animation */
            widthView.constant = self.view.frame.size.width * 0.3;
            break;
            
        case UIDeviceOrientationLandscapeRight:
            /* start special animation */
            widthView.constant = self.view.frame.size.width * 0.3;
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            /* start special animation */
            widthView.constant = self.view.frame.size.width * 0.4;
            break;
            
        default:
            break;
    };
}
-(void) getCityList
{
    
    [self startActivity];
    
    [[NetworkManager sharedInstance] postRequestUrl:apiCityListUrl paramter:nil withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        if (result == WebServiceResultSuccess)
        {
            if ([jsonData isKindOfClass:[NSArray class]])
            {
                NSString *str = jsonData[0];
                if ([str isEqualToString:@"CSRF validation failed"]) {
                    [self getLocalCity];
                }else{
                    [UserDefault setValue:jsonData forKey:@"KeyCityList"];
                    for(NSString *str in jsonData) {
                        if (![str containsString:@"(0)"]) {
                            [arrCity addObject:str];
                        }
                    }
//                    [arrCity addObjectsFromArray:jsonData];
                    arrCopyCity =  arrCity.mutableCopy;
                    [tblCityList reloadData];
                }
            }
        }else{
            [self getLocalCity];
        }
    }];
    
}

-(void) getLocalCity
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    [arrCity addObjectsFromArray:json];
    arrCopyCity =  arrCity.mutableCopy;
    [tblCityList reloadData];
    
}
#pragma mark - UITableview Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (is_iPad()) {
        return 40;
    }
    
    return 30;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrCity.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectCityTableViewCell"];
    cell.lblCity.text = arrCity[indexPath.row];
    cell.lblCity.textColor = [UIColor lightGrayColor];
    if (strSelectedCity == arrCity[indexPath.row]) {
        cell.lblCity.textColor = [UIColor blackColor];
        cell.lblCity.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    } else {
        cell.lblCity.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    strSelectedCity = arrCity[indexPath.row];
    [tblCityList reloadData];
}
-(void)btnAppyCity:(id)sender
{
    if ([self checkStringValue:strSelectedCity]) {
        showAletViewWithMessage(@"Please select city.");
        return;
    }
    if ([strSelectedCity containsString:@"("]) {
        NSRange range = [strSelectedCity rangeOfString:@"("];
        NSString *shortString = [strSelectedCity substringToIndex:range.location];
        _refreshBlock(shortString);
        
    }else{
        _refreshBlock(strSelectedCity);
        
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void) getCityBlock:(GetCityBlock)refreshBlock {
    self.refreshBlock = refreshBlock;
}
-(void)btnSearchLocation:(id)sender
{
    [self startActivity];
    [[UserLocation sharedInstance] fetchUserLocationForOnce:self block:^(CLLocation * location, NSError * error) {
        [self stopActivity];
        if (location) {
            [self findAddressFromLocation:[MyLocationManager sharedInstance].CurrentLocation];
            [MyLocationManager sharedInstance].CurrentLocation = location;
        }else{
            showAletViewWithMessage(@"Where’d you go? Failed to get your current location using GPS");
        }
        
    }];
    
}
#pragma mark - TextField Deleate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    if (newLength > 0)
    {
        if ([textField.text isEqualToString:@""]) {
            [self searchText:string];
        }else{
            [self searchText:textField.text];
        }
    }else{
        [arrCity removeAllObjects];
        [arrCity addObjectsFromArray:arrCopyCity];
        [tblCityList reloadData];
    }
    return YES;
}
-(void) searchText:(NSString*)searchText
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"self BEGINSWITH[c] %@", searchText];
    
    NSArray *arrSearch = [arrCopyCity filteredArrayUsingPredicate:resultPredicate];
    
    [arrCity removeAllObjects];
    [arrCity addObjectsFromArray:arrSearch];
    [tblCityList reloadData];
}

#pragma mark : -
-(void)findAddressFromLocation:(CLLocation*)location
{
    NSLog(@"findAddressFromLocation %@",location);
    if (location == nil)
    {
        showAletViewWithMessage(@"Where’d you go? Failed to get your current location using GPS");
        return;
    }
    CLGeocoder *geoCoder;
    
    if (!geoCoder) {
        geoCoder = [[CLGeocoder alloc]init];
    }
    [self startActivity];
    __weak SelectCityViewController *weakSelf = self;
    [geoCoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error)
     {
         NSLog(@"geoCoder %@",[error debugDescription]);
         [self stopActivity];
         if(placemarks.count > 0){
             
             NSDictionary *address =[placemarks[0] addressDictionary];
             NSArray *arr =address[@"FormattedAddressLines"];
             NSString *strAddress =@"";
             for (int i =0; i< [arr count]; i++) {
                 NSString *str =arr[i];
                 if (i != ([arr count] - 1)) {
                     strAddress = [strAddress stringByAppendingString:str];
                     strAddress = [strAddress stringByAppendingString:@","];
                 }else{
                     strAddress = [strAddress stringByAppendingString:str];
                 }
             }
             
             
             if (![weakSelf checkStringValue:[placemarks[0] locality]]) {
                 tfCity.text = [placemarks[0] locality];
                 [self searchText:tfCity.text];
                 
             }else{
                 [weakSelf showAlertWithTitle:kAppName forMessage:kFailAPI];
             }
         }
         
     }];
    
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
