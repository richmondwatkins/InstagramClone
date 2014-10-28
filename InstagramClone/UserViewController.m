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

    self.userEmailTextField.text = userEmail;
    self.usernameTextField.text = username;

    NSLog(@"%@", [PFUser currentUser]);
    // Do any additional setup after loading the view.
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
