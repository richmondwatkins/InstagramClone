//
//  User.h
//  InstagramClone
//
//  Created by Richmond on 10/27/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
//property for user ID
@property NSString *username;
@property NSString *email;
@property NSString *fullName;
@property NSArray *followers;
@property NSArray *following;
@property NSArray *photos;
@property NSArray *likedPhotos;
@property NSArray *comments;

@end
