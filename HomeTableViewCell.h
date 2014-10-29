//
//  HomeTableViewCell.h
//  InstagramClone
//
//  Created by MIKE LAND on 10/28/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeCellDelegate

-(void)favoritePhoto:(id)cell;
-(void)commentOnPhoto:(id)cell;
@end

@interface HomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageActual;
@property (strong, nonatomic) IBOutlet UIImageView *heartImageView;

+(HomeTableViewCell *)createCellForTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath;

@property id<HomeCellDelegate> delegate;
@end
