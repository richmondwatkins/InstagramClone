//
//  CommentViewController.m
//  InstagramClone
//
//  Created by Richmond on 10/29/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "CommentViewController.h"
#import "Comment.h"
@interface CommentViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *commentTextField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *comments;
@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)viewDidAppear:(BOOL)animated{
    [self queryComments];
    [self.commentTextField becomeFirstResponder];
}

-(void)queryComments{
    PFQuery *commentsQuery = [Comment query];
    [commentsQuery whereKey:@"photo" equalTo:self.photo];
    [commentsQuery includeKey:@"owner"];

    [commentsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count > 0) {
            self.comments = objects;
            [self.tableView reloadData];
        }
    }];
}


- (IBAction)commentingDidReturn:(UITextField *)textField {

    Comment *comment = [Comment object];
    comment.owner = [PFUser currentUser];
    comment.photo = self.photo;
    comment.commentText = textField.text;

    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];

    textField.text = @"";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.comments.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Comment *comment = [self.comments objectAtIndex:indexPath.row];

    cell.textLabel.text = comment[@"owner"][@"username"];
    cell.textLabel.textColor = [UIColor blueColor];
    cell.detailTextLabel.text = comment[@"commentText"];
    return cell;
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
