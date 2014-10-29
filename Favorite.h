//
//  Favorite.h
//  InstagramClone
//
//  Created by Richmond on 10/28/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>
#import "Photo.h"
@interface Favorite : PFObject <PFSubclassing>

@property PFUser *owner;
@property Photo *photo;
@end
