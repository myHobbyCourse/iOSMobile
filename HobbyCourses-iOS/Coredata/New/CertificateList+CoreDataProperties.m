//
//  CertificateList+CoreDataProperties.m
//  HobbyCourses
//
//  Created by iOS Dev on 21/01/17.
//  Copyright © 2017 Code Atena. All rights reserved.
//

#import "CertificateList+CoreDataProperties.h"

@implementation CertificateList (CoreDataProperties)

+ (NSFetchRequest<CertificateList *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CertificateList"];
}

@dynamic certificateName;
@dynamic certificateIndex;
@dynamic courseID;
@dynamic course;



@end
