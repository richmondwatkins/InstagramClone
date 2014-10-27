//
//  Photo.h
//  InstagramClone
//
//  Created by Richmond on 10/27/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface Photo : NSObject
//@property creator
//@property PhotoID
@property CLLocationCoordinate2D coordinates;
@property NSArray *likes; //userIDs
//@property image ***not sure what type it will be
@property NSDate *createdTime;

@end
