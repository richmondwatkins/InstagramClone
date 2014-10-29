//
//  SearchCollectionViewCell.m
//  InstagramClone
//
//  Created by Richmond on 10/29/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "SearchCollectionViewCell.h"

@implementation SearchCollectionViewCell



+(SearchCollectionViewCell *)createCellWithCollection:(UICollectionView *)collectionView andPhoto:(PFObject *)photoObject andIndexPath:(NSIndexPath *)indexPath{
    SearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];

        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            UIImage *image = [UIImage imageWithData:[photoObject[@"imageFile"] getData]];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imageView.image = image;
            });
        });

    return cell;
}


@end
