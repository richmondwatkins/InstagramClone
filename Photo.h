//
//  Photo.h
//  InstagramClone
//
//  Created by Richmond on 10/28/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>
@interface Photo : PFObject <PFSubclassing>
@property PFUser *user;
@property PFFile *imageFile;
@property NSString *description;
@property NSArray *tags;
@end
