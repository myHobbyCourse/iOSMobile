//
//  SpalshViewController.m
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/12/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import "SpalshViewController.h"

@interface SpalshViewController ()
{
    IBOutlet UIImageView *img;
}
@end

@implementation SpalshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[[MyLocationManager sharedInstance] getCurrentLocation];
    NSData *data = [UserDefault objectForKey:kUserInformationKey];
    NSDictionary *retrievedDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    APPDELEGATE.userCurrent = [[User alloc]initWith:retrievedDictionary];
    if (APPDELEGATE.userCurrent.token) {
        NSArray *imageNames = @[@"11", @"12", @"13", @"14",@"15", @"16", @"17", @"18",@"19",@"20",@"21"];
        NSMutableArray *images = [[NSMutableArray alloc] init];
        for (int i = 0; i < imageNames.count; i++) {
            [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
        }
        
        // Normal Animation
        img.animationImages = images;
        img.animationDuration = 5;
        img.animationRepeatCount = 1;
        [img startAnimating];
        [self getUserProfile];
    }else{
        [img stopAnimating];
        img.image = [UIImage imageNamed:@"21"];
        [self performSelector:@selector(setUp) withObject:self afterDelay:0.5];
    }
    
}
-(BOOL)prefersStatusBarHidden{
    return true;
}
-(void) setUp {
   if (APPDELEGATE.userCurrent.token) {
        if (APPDELEGATE.userCurrent.isVendor) {
            [self performSegueWithIdentifier:@"segueVendorHome" sender:self];
        }else{
            [self performSegueWithIdentifier:@"segueHome" sender:self];
        }

    } else {
        if (is_iPad()) {
            [self performSegueWithIdentifier:@"splash_login" sender:nil];
        }else{
            [self performSegueWithIdentifier:@"toHelp" sender:self];
        }

    }
    
}

#pragma mark- API Calls Check for profile data
-(void) getUserProfile
{
    
    [[NetworkManager sharedInstance] postRequestFullUrl:@"http://myhobbycourses.com/myhobbycourses_endpoint/user_details_service/get_info" paramter:nil withCallback:^(id jsonData, WebServiceResult result)
     {
         NSLog(@"%@",jsonData);
         if (result == WebServiceResultSuccess) {
             if ([jsonData isKindOfClass:[NSDictionary class]])
             {
                 NSDictionary *dict = jsonData;
                 NSMutableDictionary *d = [dict mutableCopy];
                 [d handleNullValue];
                 userINFO = [[UserDetail alloc]initWith:d];
                 [userINFO getProfileSatus];
             }
         }
         [img stopAnimating];
         img.image = [UIImage imageNamed:@"21"];
         [self performSelector:@selector(setUp) withObject:self afterDelay:1];

     }];
}

@end
