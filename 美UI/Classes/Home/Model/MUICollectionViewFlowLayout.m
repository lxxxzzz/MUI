//
//  MUICollectionViewFlowLayout.m
//  美UI
//
//  Created by Lee on 15-12-18.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "MUICollectionViewFlowLayout.h"

@interface MUICollectionViewFlowLayout ()

@property(nonatomic,retain)NSMutableDictionary *maxYdict;

@end

@implementation MUICollectionViewFlowLayout

- (NSMutableDictionary *)maxYdict {
    if (!_maxYdict) {
        _maxYdict = [NSMutableDictionary dictionary];
    }
    return _maxYdict;
}

- (instancetype)init {
    if (self = [super init]) {
        self.rowMagrin = 10;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.colCount = 2;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (CGSize)collectionViewContentSize {
    __block NSString *maxCol = @"0";
    //找出最短的列
    [self.maxYdict enumerateKeysAndObjectsUsingBlock:^(NSString * column, NSNumber *maxY, BOOL *stop) {
        if ([maxY floatValue] > [self.maxYdict[maxCol] floatValue])
        {
            maxCol = column;
        }
    }];
    return CGSizeMake(0, [self.maxYdict[maxCol] floatValue]);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    __block NSString *minCol = @"0";
    //找出最短的列
    [self.maxYdict enumerateKeysAndObjectsUsingBlock:^(NSString * column, NSNumber *maxY, BOOL *stop) {
        if ([maxY floatValue] < [self.maxYdict[minCol] floatValue]) {
            minCol = column;
        }
    }];
    //    计算宽度
    CGFloat width = (self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right - (self.colCount - 1) * self.colMagrin) / self.colCount;

    //    计算高度
    CGFloat height = [self.delegate waterFlow:self heightForItem:width atIndexPath:indexPath];
    CGFloat x = self.sectionInset.left + (width + self.colMagrin) * [minCol intValue];
    CGFloat y = [self.maxYdict[minCol] floatValue] + self.rowMagrin;
    //    更新最大的y值
    self.maxYdict[minCol] = @(y + height);
    //    计算位置
    UICollectionViewLayoutAttributes * attri = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attri.frame = CGRectMake(x, y, width, height);
    return attri;
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    for(int i = 0;i < self.colCount;i++)
    {
        NSString *col = [NSString stringWithFormat:@"%d",i];
        self.maxYdict[col] = @0;
    }

    NSMutableArray * array = [NSMutableArray array];

    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < count; i++)
    {
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [array addObject:attrs];

    }
    return  array;
}


- (UICollectionViewScrollDirection)scrollDirection
{
    return UICollectionViewScrollDirectionVertical;
}

@end
