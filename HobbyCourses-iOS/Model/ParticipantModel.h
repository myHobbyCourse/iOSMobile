//
//  ParticipantModel.h
//  HobbyCourses-iOS
//
//  Created by Kirit on 09/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//

#import "JSONModel.h"

@interface ParticipantModel : JSONModel

@property (assign, nonatomic) int uid;
@property (strong, nonatomic) NSString* participant;
@property (strong, nonatomic) NSString* user_image;
@end
