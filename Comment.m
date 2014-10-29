//
//  Comment.m
//  InstagramClone
//
//  Created by Richmond on 10/29/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "Comment.h"
@implementation Comment

@dynamic owner;
@dynamic photo;
@dynamic commentText;

+(void)load{
    [self registerSubclass];
}

+(NSString *)parseClassName{
    return @"Comment";
}

@end
