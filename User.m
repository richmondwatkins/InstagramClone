//
//  User.m
//  InstagramClone
//
//  Created by Richmond on 10/28/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "User.h"

@implementation User

+(NSString *)parseClassName{
    return @"User";
}

+(void)load{
    [self registerSubclass];
}

@end
