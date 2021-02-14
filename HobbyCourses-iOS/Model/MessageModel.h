//
//  MessageModel.h
//  HobbyCourses-iOS
//
//  Created by Kirit on 09/03/16.
//  Copyright © 2016 Code Atena. All rights reserved.
//


#import "ParticipantModel.h"

@protocol ParticipantModel
@end

@interface MessageModel : JSONModel

@property (assign, nonatomic) int thread_id;
@property (strong, nonatomic) NSString* subject;
@property (strong, nonatomic) NSString* last_updated;
@property (strong, nonatomic) NSString* has_new;
@property (strong, nonatomic) NSArray<ParticipantModel>* participants;

@end


