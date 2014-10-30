//
//  SearchTableViewCell.h
//  InstagramClone
//
//  Created by Richmond on 10/28/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchDelegate <NSObject>

-(void)addFriendButtonTapped:(UIButton *)button withCell:(id)cell;

@end

@interface SearchTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *followingButton;
@property (strong, nonatomic) IBOutlet UIButton *addFriendButton;
@property id <SearchDelegate> delegate;
@end
