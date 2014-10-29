//
//  ExploreViewController.m
//  InstagramClone
//
//  Created by Christopher on 10/27/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "ExploreViewController.h"
#import <Parse/Parse.h>
#import "SearchTableViewCell.h"
#import "SearchTableViewCell.h"
#import "FollowingRelations.h"
@interface ExploreViewController () <UITableViewDelegate, UITableViewDataSource, SearchDelegate>
@property (strong, nonatomic) IBOutlet UITextField *exploreTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *usersArray;

@end

@implementation ExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.usersArray = [NSArray array];
    [self refreshDisplay];
//    [self addFollower];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.usersArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.delegate = self;
    PFUser *user = [self.usersArray objectAtIndex:indexPath.row];
    cell.textLabel.text = user[@"username"];

    PFQuery *followerQuery = [FollowingRelations query];
    [followerQuery whereKey:@"follower" equalTo:[PFUser currentUser]];
    [followerQuery whereKey:@"following" equalTo:user];
    cell.addFriendButton.hidden = YES;
    [followerQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count <= 0) {
            cell.addFriendButton.hidden = NO;
        }
    }];

    return cell;
}

-(void)refreshDisplay
{
    PFQuery *userQuery = [PFUser query];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error %@", error);
        } else {
            self.usersArray = objects;
            [self.tableView reloadData];
        }
    }];

}

-(void)addFriendButtonTapped:(UIButton *)button{
    CGPoint buttonPosition = [button convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];

    PFUser *selectedUser = [self.usersArray objectAtIndex:indexPath.row];

    FollowingRelations *followerFollowing = [FollowingRelations object];
    followerFollowing.following = selectedUser;
    followerFollowing.follower = [PFUser currentUser];

    [followerFollowing saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            button.hidden = YES;
        }
    }];
}

-(void)addFollower{
    PFQuery *query = [PFUser query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        if (!error) {
            PFUser *user = [objects objectAtIndex:4];
            [[PFUser currentUser]  addObject:user forKey:@"following"];
//            [user addObject:[PFUser currentUser] forKey:@"followers"];


            [PFObject saveAllInBackground:@[user, [PFUser currentUser]] block:^(BOOL succeeded, NSError *error) {
                NSLog(@"SAVE ALL WORKED");

                if(succeeded){
                    NSLog(@"SAVE ALL WORKED");
                }
                
            }];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

@end
