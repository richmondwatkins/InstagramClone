//
//  ViewController.m
//  InstagramClone
//
//  Created by Richmond on 10/27/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import "ExploreViewController.h"
#import "SearchTableViewCell.h"
#import "Photo.h"
#import "HomeTableViewCell.h"
#import "FollowingRelations.h"
#import "Favorite.h"
#import "CommentViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate, HomeCellDelegate>
@property NSArray *homeFeedElements;
@property NSMutableArray *homeImagesArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableView *commentTableView;
@property NSMutableArray *cells;
@property Photo *selectedPhotoForComment;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cells = [NSMutableArray array];
    self.homeImagesArray = [NSMutableArray array];
    self.homeFeedElements = @[@"home element 1", @"home element 2"];
    if ([PFUser currentUser]) {
        [self findFollowers];

    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate

        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate

        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];

        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
}

- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }

    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;

    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }

    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }

    return informationComplete;
}

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}

-(void)findFollowers{
    PFQuery *queryFollowers = [PFQuery queryWithClassName:[FollowingRelations parseClassName]];
    [queryFollowers whereKey:@"follower" equalTo:[PFUser currentUser]];

    [queryFollowers findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for(PFUser *user in objects){
            [self downloadImages:user[@"following"]];
        }
        [self downloadImages:[PFUser currentUser]];
    }];

}

-(void)downloadImages:(PFUser *)user{
    PFQuery *query = [PFQuery queryWithClassName:[Photo parseClassName]];
    [query whereKey:@"user" equalTo:user];
    [query includeKey:@"user"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            if (objects.count > 0) {
                for (PFObject *eachObject in objects) {
                    NSMutableDictionary *objectDictionary = [NSMutableDictionary new];
                    [objectDictionary setObject:eachObject forKey:@"photoData"];
                    [objectDictionary setObject:[UIImage imageWithData:[eachObject[@"imageFile"] getData]] forKey:@"photoImage"];
                    [self.homeImagesArray addObject:objectDictionary];
                }
                dispatch_async(dispatch_get_main_queue(), ^{

                    [self.homeImagesArray sortUsingComparator:^(NSMutableDictionary *firstObject, NSMutableDictionary *secondObject) {
                        PFObject *one = firstObject[@"photoData"];
                        PFObject *two = secondObject[@"photoData"];
                        return [two.createdAt compare:one.createdAt ];
                    }];
                    [self.tableView reloadData];
                });
            }
        });

    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return self.homeImagesArray.count;

}

- (HomeTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTableViewCell *cell = [HomeTableViewCell createCellForTableView:tableView withIndexPath:indexPath];
    cell.delegate = self;

    NSDictionary *photoDictionary = [self.homeImagesArray objectAtIndex:indexPath.row];
    Photo *photoObject = photoDictionary[@"photoData"];
    cell.imageActual.image = photoDictionary[@"photoImage"];
    cell.friendsName.text = photoDictionary[@"photoData"][@"user"][@"username"];

    PFQuery *favoritesQuery = [Favorite query];
    [favoritesQuery whereKey:@"owner" equalTo:[PFUser currentUser]];
    [favoritesQuery whereKey:@"photo" equalTo:photoObject];

    [favoritesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count > 0) {
            cell.heartImageView.hidden = NO;
        }
    }];

    [self.cells addObject:cell];
    return cell;
}

-(void)favoritePhoto:(HomeTableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    NSMutableDictionary *photoDictionary = [self.homeImagesArray objectAtIndex:indexPath.row];

    Photo *photo = photoDictionary[@"photoData"];

    Favorite *favorite = [Favorite object];
    favorite.owner = [PFUser currentUser];
    favorite.photo = photo;
    [favorite saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        cell.heartImageView.hidden = NO;
    }];
}

-(void)commentOnPhoto:(HomeTableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    NSMutableDictionary *photoDictionary = [self.homeImagesArray objectAtIndex:indexPath.row];

    self.selectedPhotoForComment = photoDictionary[@"photoData"];

    [self performSegueWithIdentifier:@"Comment" sender:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"Comment"]) {
        CommentViewController *commentViewCtrl = segue.destinationViewController;
        commentViewCtrl.photo = self.selectedPhotoForComment;
    }
}

@end
