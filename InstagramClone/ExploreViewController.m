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

@end

@implementation ExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addFollower];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = @"hey";
    return cell;
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
