//
//  Comment.h
//  InstagramClone
//
//  Created by Richmond on 10/27/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

//@property Comment ID
//@property Photo ID
//@property Author ID
@property NSString *commentText;
@property NSDate *createdTime;
@end
