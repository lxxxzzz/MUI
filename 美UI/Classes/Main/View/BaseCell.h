//
//  BaseCell.h
//  美UI
//
//  Created by Lee on 16/8/8.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Item;

@interface BaseCell : UICollectionViewCell

@property (nonatomic, strong) Item *item;
@property (nonatomic, strong) UIImageView *imageView;

@end
