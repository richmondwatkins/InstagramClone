//
//  ExploreViewController.m
//  InstagramClone
//
//  Created by Christopher on 10/27/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "ExploreViewController.h"
#import <Parse/Parse.h>

@interface ExploreViewController () <UITableViewDelegate, UITableViewDataSource>
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
    [self addFollower];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.usersArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
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

-(void)addFollower{
    PFQuery *query = [PFUser query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"%@",objects);

            [[PFUser currentUser] setObject:objects[3] forKey:@"following"];
            [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [objects[3] setObject:[PFUser currentUser] forKey:@"follower"];
                [objects[3] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    NSLog(@"SAved follower");
                }];
            }];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

@end
