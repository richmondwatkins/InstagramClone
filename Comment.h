//
//  Comment.h
//  InstagramClone
//
//  Created by Richmond on 10/29/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>
#import "Photo.h"
@interface Comment : PFObject <PFSubclassing>

@property PFUser *owner;
@property Photo *photo;
@property NSString *commentText;

@end
