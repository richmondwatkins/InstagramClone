//
//  Favorite.m
//  InstagramClone
//
//  Created by Richmond on 10/28/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "Favorite.h"

@implementation Favorite

@dynamic owner;
@dynamic photo;

+(void)load{
    [self registerSubclass];
}

+(NSString *)parseClassName{
    return @"Favorite";
}

@end
