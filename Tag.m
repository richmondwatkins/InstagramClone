//
//  Tag.m
//  InstagramClone
//
//  Created by Richmond on 10/28/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "Tag.h"

@implementation Tag

@dynamic tagText;
@dynamic photo;

+(void)load{
    [self registerSubclass];
}

+(NSString *)parseClassName{
    return @"Tag";
}

@end
