//
//  FollowingRelations.m
//  InstagramClone
//
//  Created by Richmond on 10/28/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "FollowingRelations.h"

@implementation FollowingRelations
@dynamic follower;
@dynamic following;

+(void)load{
    [self registerSubclass];
}

+(NSString *)parseClassName{
    return @"FollowingRelations";
}

@end
