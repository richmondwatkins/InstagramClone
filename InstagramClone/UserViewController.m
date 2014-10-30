//
//  UserViewController.m
//  InstagramClone
//
//  Created by MIKE LAND on 10/27/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "UserViewController.h"
#import <Parse/Parse.h>
#import "CustomCollectionViewCell.h"
#import "Photo.h"
#import "FollowingRelations.h"
@interface UserViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSMutableArray *imagesArray;


// These labels need to be hooked up with appropriate data
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *postsLabel;
@property (strong, nonatomic) IBOutlet UILabel *followersLabel;
@property (strong, nonatomic) IBOutlet UILabel *followingLabel;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imagesArray = [NSMutableArray array];
}

-(void)viewWillAppear:(BOOL)animated{
    PFUser *user = [PFUser currentUser];
    self.title = user[@"username"];
    self.profileImageView.image = [UIImage imageNamed:@"coco"];

    self.fullNameLabel.text = [PFUser currentUser][@"username"];
    [self.imagesArray removeAllObjects];
    [self findAllFollowers];
    [self downloadImages];

}

- (IBAction)logOutUser:(id)sender {
    [PFUser logOut];
}

-(void)downloadImages{
    PFQuery *query = [PFQuery queryWithClassName:[Photo parseClassName]];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            if (objects.count > 0) {
                for (PFObject *eachObject in objects) {
                    [self.imagesArray addObject:[UIImage imageWithData:[eachObject[@"imageFile"] getData]]];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
            }
        });

    }];

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imagesArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProfileCell" forIndexPath:indexPath];

    cell.cellImageView.image = [self.imagesArray objectAtIndex:indexPath.row];

    return cell;
}

-(void)findAllFollowers{
    PFQuery *queryFollowers = [PFQuery queryWithClassName:[FollowingRelations parseClassName]];
    [queryFollowers whereKey:@"follower" equalTo:[PFUser currentUser]];

    [queryFollowers countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        self.followingLabel.text = [NSString stringWithFormat:@"%i", number];
    }];

    PFQuery *queryFollowing = [PFQuery queryWithClassName:[FollowingRelations parseClassName]];
    [queryFollowing whereKey:@"following" equalTo:[PFUser currentUser]];

    [queryFollowing countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        self.followersLabel.text = [NSString stringWithFormat:@"%i", number];
    }];

    PFQuery *photoQuery = [PFQuery queryWithClassName:[Photo parseClassName]];
    [photoQuery whereKey:@"user" equalTo:[PFUser currentUser]];

    [photoQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        self.postsLabel.text = [NSString stringWithFormat:@"%i", number];
    }];

}

@end
