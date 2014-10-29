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
@property (weak, nonatomic) IBOutlet UITextField *userEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSMutableArray *imagesArray;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imagesArray = [NSMutableArray array];

    self.userEmailTextField.text = [PFUser currentUser][@"email"];
    self.usernameTextField.text = [PFUser currentUser][@"email"];

    [self findAllFollowers];
    [self downloadImages];
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
    [queryFollowers includeKey:@"following"];

    [queryFollowers findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for(PFUser *user in objects){
            NSLog(@"%@",user[@"following"]);
        }
    }];

}

@end
