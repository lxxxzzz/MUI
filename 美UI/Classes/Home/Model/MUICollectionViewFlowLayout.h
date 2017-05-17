//
//  MUICollectionViewFlowLayout.h
//  美UI
//
//  Created by Lee on 15-12-18.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MUICollectionViewFlowLayout;

@protocol MUICollectionViewFlowLayoutDelegate <NSObject>

- (CGFloat)waterFlow:(MUICollectionViewFlowLayout*)waterFlow heightForItem:(CGFloat)width atIndexPath:(NSIndexPath*)indexPath;

@end

@interface MUICollectionViewFlowLayout : UICollectionViewLayout

@property(nonatomic,assign) UIEdgeInsets sectionInset;
@property(nonatomic,assign) CGFloat rowMagrin;
@property(nonatomic,assign) CGFloat colMagrin;
@property(nonatomic,assign) CGFloat colCount;
@property(nonatomic,weak) id <MUICollectionViewFlowLayoutDelegate> delegate;

@end
