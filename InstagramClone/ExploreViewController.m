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
@interface ExploreViewController () <UITableViewDelegate, UITableViewDataSource, SearchDelegate>
@property (strong, nonatomic) IBOutlet UITextField *exploreTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *usersArray;
@property NSArray *searchUsernameResults;

@end

@implementation ExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.usersArray = [NSArray array];
    [self refreshDisplay];
    [self addFollower];
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


-(void)addFriendButtonTapped{
    NSLog(@"TAP in Explore");
}

-(void)addFollower{
    PFQuery *query = [PFUser query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        if (!error) {
            PFUser *user = [objects objectAtIndex:4];
            [[PFUser currentUser]  addObject:user forKey:@"following"];
            [user addObject:[PFUser currentUser] forKey:@"followers"];

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
