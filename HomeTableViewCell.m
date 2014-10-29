//
//  HomeTableViewCell.m
//  InstagramClone
//
//  Created by MIKE LAND on 10/28/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "Comment.h"
@interface HomeTableViewCell ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation HomeTableViewCell

+(HomeTableViewCell *)createCellForTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Cell created");

    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell"];

    UITapGestureRecognizer *doubleTapFolderGesture = [[UITapGestureRecognizer alloc] initWithTarget:cell action:@selector(favoritePhoto)];
    [doubleTapFolderGesture setNumberOfTapsRequired:2];
    [cell addGestureRecognizer:doubleTapFolderGesture];

    cell.heartImageView.hidden = YES;

    cell.commentTableView.dataSource = cell;
    cell.commentTableView.delegate = cell;

    return cell;
}

-(void)favoritePhoto{
    [self.delegate favoritePhoto:self];
}


- (IBAction)onCommentButtonTapped:(id)sender {
    [self.delegate commentOnPhoto:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Table Created");

    return self.comments.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.alwaysBounceVertical = NO;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];

    Comment *comment = [self.comments objectAtIndex:indexPath.row];
    cell.textLabel.text = comment[@"commentText"];
    NSLog(@"IN CUSTOM TABLE %@",self.comments);
    return cell;
}

@end
