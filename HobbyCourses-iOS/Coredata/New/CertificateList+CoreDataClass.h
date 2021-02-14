//
//  CertificateList+CoreDataClass.h
//  HobbyCourses
//
//  Created by iOS Dev on 21/01/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface CertificateList : NSManagedObject
+(void) insertCertificate:(NSString *) name index:(NSString*) idx courseForm:(CourseForm*) course;
+(CertificateList*) getObjectbyRowID:(NSString *) rowKey;
+(BOOL) deleteCertificate:(NSString*) rowKey;
+(NSArray*) getAllCertificate;
@end

NS_ASSUME_NONNULL_END

#import "CertificateList+CoreDataProperties.h"
