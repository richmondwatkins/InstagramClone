//
//  SearchCollectionViewCell.h
//  InstagramClone
//
//  Created by Richmond on 10/29/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SearchCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

+(SearchCollectionViewCell *)createCellWithCollection:(UICollectionView *)collectionView andPhoto:(PFObject *)photoObject andIndexPath:(NSIndexPath *)indexPath;

@end
