//
//  LocationPopUpViewController.m
//  HobbyCourses-iOS
//
//  Created by iOS Dev on 13/02/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "LocationPopUpViewController.h"

@interface LocationPopUpViewController ()

@end

@implementation LocationPopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedCity:)
                                                 name:@"receivedCity"
                                               object:nil];
    [[MyLocationManager sharedInstance] getCurrentLocation];
    
    [self updateUI];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:true];
    
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updateUI
{
    viewBGWhite.layer.cornerRadius = 10;
    btnApply.layer.cornerRadius = 10;
}
-(void) receivedCity:(NSNotification*)notification
{
    if (![self checkStringValue:[MyLocationManager sharedInstance].postalCode])
    {
        tfPincode.text = [MyLocationManager sharedInstance].postalCode;
    }else if(![self checkStringValue:[MyLocationManager sharedInstance].currentAddress])
    {
        tfPincode.text = [MyLocationManager sharedInstance].currentAddress;
    }

}


#pragma mark - UIbutton Action

-(void)btnSkip:(id)sender
{
    [UserDefault setBool:true forKey:@"isLocationPoped"];
    [self dismissViewControllerAnimated:NO completion:^{
        
        SelectCityViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectCityViewController"];
        vc.view.backgroundColor = [UIColor clearColor];
        self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:vc animated:NO completion:nil];
        
        [APPDELEGATE.window.rootViewController presentViewController:vc animated:NO completion:nil];
    }];
    
}
-(void)btnApplyAction:(id)sender
{
    if (![self checkTextfieldValue:tfPincode])
    {
        [self getAddressfromPincode:tfPincode.text];
        
    }else{
        showAletViewWithMessage(@"Please enter valid pincode");
    }
}
#pragma mark Google api place search
-(NSString*) getAddressfromPincode:(NSString*) pinCode
{
    [self startActivity];
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true&components=country:UK&key=%@",tfPincode.text,googleKey];
    [[ApiService sharedInstance] getMethodWithRelativePath:url paramater:nil block:^(id JSON, WebServiceResult result)
     {
         [self stopActivity];
        if (result == WebServiceResultSuccess)
        {
            if ([[JSON valueForKey:@"status"]  isEqual: @"OK"])
            {
                NSString *address = [[JSON valueForKey:@"results"][0] valueForKey:@"formatted_address"];
                if([address isEqualToString:@"United Kingdom"])
                {
                    showAletViewWithMessage(@"No record found.");
                }
                else
                {
                    showAletViewWithMessage(address);
                    [UserDefault setBool:true forKey:@"isLocationPoped"];

                    APPDELEGATE.selectedCity = [MyLocationManager sharedInstance].cityName;
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:@"receiveUpdateCity"
                     object:self];
                    [self dismissViewControllerAnimated:NO completion:nil];
                    
                }

            }else if ([[JSON valueForKey:@"status"]  isEqual: @"ZERO_RESULTS"]){
                showAletViewWithMessage(@"No record found.");
            }else{
                showAletViewWithMessage(@"Something went wrong.");
            }
            
        }
    }];
    return nil;
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
