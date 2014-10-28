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

@interface UserViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    User *userEmail = [PFUser currentUser][@"email"];
    User *username = [PFUser currentUser][@"username"];

    self.userEmailTextField.text = [userEmail mutableCopy];
    self.usernameTextField.text = [username mutableCopy];

    NSLog(@"%@", [PFUser currentUser]);
    [self downloadImages];
    // Do any additional setup after loading the view.
}

-(void)downloadImages{
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    PFUser *user = [PFUser currentUser];
    [query whereKey:@"user" equalTo:user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        // If there are photos, we start extracting the data
        // Save a list of object IDs while extracting this data

        NSMutableArray *imageArray = [NSMutableArray array];

        if (objects.count > 0) {
            for (PFObject *eachObject in objects) {
                [imageArray addObject:[UIImage imageWithData:[eachObject[@"imageFile"] getData]]];
            }
            NSLog(@"%@",imageArray);
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
