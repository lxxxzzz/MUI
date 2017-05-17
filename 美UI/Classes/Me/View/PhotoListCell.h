//
//  PhotoListCell.h
//  美UI
//
//  Created by Lee on 17/2/18.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Photo;

@interface PhotoListCell : UICollectionViewCell

@property (strong, nonatomic) Photo *photo;
@property (nonatomic, strong) UIImage *image;

@end
