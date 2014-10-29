//
//  HomeTableViewCell.m
//  InstagramClone
//
//  Created by MIKE LAND on 10/28/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "HomeTableViewCell.h"

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

    return 2;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];

    return cell;
}

@end
