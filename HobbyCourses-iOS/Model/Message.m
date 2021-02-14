//
//  Message.m
//  HobbyCourses-iOS
//
//  Created by Code Atena on 11/16/15.
//  Copyright © 2015 Code Atena. All rights reserved.
//

#import "Message.h"

@implementation Message

- (id) initWith:(NSDictionary*)dict {
    self = [super init];
    if (self)
    {
        self.author = dict[@"author"];
        self.author_picture = dict[@"author_picture"];
        self.author_uid = dict[@"author_uid"];
        self.body = dict[@"body"];
        self.deleted = dict[@"deleted"];
        self.is_new = dict[@"is_new"];
        self.mid = dict[@"mid"];
        self.sending_time = dict[@"sending_time"];
        self.subject = dict[@"subject"];
        self.thread_id = dict[@"thread_id"];
        if (!_isStringEmpty(self.sending_time)) {
            self.dateSending = [ddMMMyyyyHHmmss() dateFromString:self.sending_time];
            self.sending_time = [ddMMMHHmmss() stringFromDate:self.dateSending];
        }
        NSArray *arr = dict[@"participants"];
        if ([arr isKindOfClass:[NSArray class]])
        {
            if (arr && arr.count >0) {
                NSDictionary *dic = arr[0];
                self.uid = dic[@"uid"];
                self.recipient = dic[@"recipient"];


            }
        }
    }
    return self;
}



@end
