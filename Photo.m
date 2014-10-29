//
//  Photo.m
//  InstagramClone
//
//  Created by Richmond on 10/28/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "Photo.h"

@implementation Photo

@dynamic user;
@dynamic imageFile;
@dynamic description;
@dynamic tags;

+(void)load{
    [self registerSubclass];
}

+(NSString *)parseClassName{
    return @"Photo";
}

@end
