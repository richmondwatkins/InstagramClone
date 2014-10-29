//
//  HomeTableViewCell.m
//  InstagramClone
//
//  Created by MIKE LAND on 10/28/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

+(HomeTableViewCell *)createCellForTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell"];

    UITapGestureRecognizer *doubleTapFolderGesture = [[UITapGestureRecognizer alloc] initWithTarget:cell action:@selector(favoritePhoto)];
    [doubleTapFolderGesture setNumberOfTapsRequired:2];
    [cell addGestureRecognizer:doubleTapFolderGesture];

    cell.heartImageView.hidden = YES;
    return cell;
}

-(void)favoritePhoto{
    [self.delegate favoritePhoto:self];
}


- (IBAction)onCommentButtonTapped:(id)sender {
    [self.delegate commentOnPhoto:self];
}

@end
