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
#import "Tag.h"
#import "SearchCollectionViewCell.h"
@interface ExploreViewController () <UITableViewDelegate, UITableViewDataSource, SearchDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *exploreTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSArray *usersArray;
@property NSArray *imagesArray;
@property BOOL isSearchingUsers;
@end

@implementation ExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.exploreTextField setFont:[UIFont fontWithName:@"Avenir Next" size:12]];
    self.isSearchingUsers = YES;
    self.usersArray = [NSArray array];
    [self refreshDisplay];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.usersArray.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imagesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.delegate = self;
    PFUser *user = [self.usersArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Avenir Next" size:18];

    cell.textLabel.text = user[@"username"];

    PFQuery *followerQuery = [FollowingRelations query];
    [followerQuery whereKey:@"follower" equalTo:[PFUser currentUser]];
    [followerQuery whereKey:@"following" equalTo:user];
    cell.followingButton.hidden = YES;;
    [followerQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count <= 0) {
            cell.followingButton.hidden = NO;
        }
    }];

    return cell;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PFObject *photoObject = [self.imagesArray objectAtIndex:indexPath.row];
    SearchCollectionViewCell *cell = [SearchCollectionViewCell createCellWithCollection:collectionView andPhoto:photoObject[@"photo"] andIndexPath:indexPath];

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
- (IBAction)onTextFieldDidEndEditing:(UITextField *)sender {
    PFQuery *usernameQuery = [PFUser query];
    [usernameQuery whereKey:@"username" equalTo: self.exploreTextField.text];
    [usernameQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        if (error) {
            NSLog(@"Error %@", error);
        } else {
            NSLog(@"objects after text field %@", objects);
            self.usersArray = objects;
            [self.tableView reloadData];
        }
    }];

}


-(void)addFriendButtonTapped:(UIButton *)button withCell:(SearchTableViewCell *)cell{
    CGPoint buttonPosition = [button convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];

    PFUser *selectedUser = [self.usersArray objectAtIndex:indexPath.row];

    FollowingRelations *followerFollowing = [FollowingRelations object];
    followerFollowing.following = selectedUser;
    followerFollowing.follower = [PFUser currentUser];

    [followerFollowing saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            cell.followingButton.hidden = NO;
        }
    }];
}

- (IBAction)searchUserOrTags:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex) {
        self.tableView.hidden = YES;
        self.isSearchingUsers = NO;
    }else{
        self.tableView.hidden = NO;
        self.isSearchingUsers = YES;
    }
}
- (IBAction)searchEditingEndedOnExit:(id)sender {
    PFQuery *query;
    NSString *key;
    if (self.isSearchingUsers) {
        key = @"username";
        query = [PFUser query];
    }else{
        key = @"tagText";
        query = [Tag query];
    }

    [self performSearchWithQuery:(PFQuery *)query withKey:(NSString *)key];

}

-(void)performSearchWithQuery:(PFQuery *)query withKey:(NSString *)key{

    [query whereKey:key equalTo: self.exploreTextField.text];
    if (self.isSearchingUsers == NO) {
        NSLog(@"TAG");
        [query includeKey:@"photo"];
    }

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        if (error) {
            NSLog(@"Error %@", error);
        } else {

            if (self.isSearchingUsers == NO) {
                NSLog(@"%@",objects);
                self.imagesArray = objects;
                [self.collectionView reloadData];
            }

            self.usersArray = objects;
            [self.tableView reloadData];
        }
    }];
}



@end
