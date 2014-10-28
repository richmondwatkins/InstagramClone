//
//  ViewController.m
//  InstagramClone
//
//  Created by Richmond on 10/27/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import "Photo.h"
#import "HomeTableViewCell.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate>
@property NSArray *homeFeedElements;
@property NSMutableArray *homeImagesArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.homeImagesArray = [NSMutableArray array];
    self.homeFeedElements = @[@"home element 1", @"home element 2"];
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
    }else{
        [self downloadImages];
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

-(void)downloadImages{
    PFQuery *query = [PFQuery queryWithClassName:[Photo parseClassName]];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            if (objects.count > 0) {
                for (PFObject *eachObject in objects) {
                    [self.homeImagesArray addObject:[UIImage imageWithData:[eachObject[@"imageFile"] getData]]];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
//                    NSLog(@"%@", self.homeImagesArray);
                });
            }
        });

    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.homeImagesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell"];
    cell.imageView.image = [self.homeImagesArray objectAtIndex:indexPath.row];
    return cell;
}

@end
