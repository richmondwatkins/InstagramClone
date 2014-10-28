//
//  SearchTableViewCell.m
//  InstagramClone
//
//  Created by Richmond on 10/28/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell


- (IBAction)onAddFriendButtonPressed:(UIButton *)sender {
    [self.delegate addFriendButtonTapped];
}

@end
