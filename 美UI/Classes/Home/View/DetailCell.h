//
//  DetailCell.h
//  美UI
//
//  Created by Lee on 16/11/9.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Item, DetailCell, MUIHomeUserInfoView;

@protocol DetailCellDelegatge <NSObject>

@optional
- (void)detailCellDidScroll:(UIScrollView *)scrollView;

@end

@interface DetailCell : UICollectionViewCell

@property (nonatomic, strong) Item *item;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, weak) id <DetailCellDelegatge> delegate;
@property (nonatomic, strong) MUIHomeUserInfoView *userView;

@end
