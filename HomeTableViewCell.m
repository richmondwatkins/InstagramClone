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
    NSString *likeCount = self.likesButton.titleLabel.text;
    int likes = likeCount.intValue;
    likes +=1;
    [self.likesButton.titleLabel setText:[NSString stringWithFormat:@"%i", likes]];
    [self.delegate favoritePhoto:self];
}


- (IBAction)onCommentButtonTapped:(id)sender {
    [self.delegate commentOnPhoto:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.comments.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.alwaysBounceVertical = NO;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];

    Comment *comment = [self.comments objectAtIndex:indexPath.row];
    cell.textLabel.text = comment[@"owner"][@"username"];
    cell.detailTextLabel.text = comment[@"commentText"];
    return cell;
}

@end
