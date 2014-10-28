//
//  UserViewController.m
//  InstagramClone
//
//  Created by MIKE LAND on 10/27/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "UserViewController.h"
#import "User.h"
#import <Parse/Parse.h>
#import "CustomCollectionViewCell.h"
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

    User *userEmail = [PFUser currentUser][@"email"];
    User *username = [PFUser currentUser][@"username"];

    self.userEmailTextField.text = [userEmail mutableCopy];
    self.usernameTextField.text = [username mutableCopy];

    NSLog(@"%@", [PFUser currentUser]);
    [self downloadImages];
}

-(void)downloadImages{
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    PFUser *user = [PFUser currentUser];
    [query whereKey:@"user" equalTo:user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            if (objects.count > 0) {
                for (PFObject *eachObject in objects) {
                    [self.imagesArray addObject:[UIImage imageWithData:[eachObject[@"imageFile"] getData]]];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"%@",self.imagesArray);
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

@end
