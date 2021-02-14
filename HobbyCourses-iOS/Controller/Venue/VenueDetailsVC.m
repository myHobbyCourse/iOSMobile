//
//  VenueDetailsVC.m
//  HobbyCourses
//
//  Created by iOS Dev on 17/08/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "VenueDetailsVC.h"

@interface VenueDetailsVC ()

@end

@implementation VenueDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [imgTutor sd_setImageWithURL:[NSURL URLWithString:self.venue.imagePath] placeholderImage:_placeHolderImg];
    lblName.text = self.venue.venue_name;
    lblDesc.text = self.venue.venue_details;
    self.navigationItem.title = @"Venue Details";
    if (_isFromDetails) {
        btnUpadateVenue.hidden = true;
        btnDeleteVenue.hidden = true;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateToGoogleAnalytics:@"Venue Details Screen"];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    AddVenueVC_iPad *vc = segue.destinationViewController;
    vc.selectedVenue = self.venue;
}
-(IBAction)btnBackNav:(id)sender {
    if (is_iPad()) {
        [self parentDismiss:sender];
    }else{
        [self.navigationController popViewControllerAnimated:true];
    }
}

-(IBAction)btnDelete:(UIButton*)sender {
    [self startActivity];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    NSMutableDictionary *venueDict = [NSMutableDictionary new];
    [venueDict setObject:@"delete" forKey:@"action"];
    [venueDict setObject:self.venue.venue_id forKey:@"item_id"];
    [venueDict setObject:self.venue.venue_name forKey:@"name"];
    [venueDict setObject:self.venue.venue_details forKey:@"details"];
    
    [dict setObject:@[venueDict] forKey:@"venues"];
    [[NetworkManager sharedInstance] postRequestUrl:apiUpdate_delete_venue paramter:dict withCallback:^(id jsonData, WebServiceResult result) {
        [self stopActivity];
        if (result == WebServiceResultSuccess) {
            [DefaultCenter postNotificationName:@"refreshVenueList" object:nil];
        }else{
            showAletViewWithMessage(kFailAPI);
        }
        
    }];
}
@end
