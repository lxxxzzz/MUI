//
//  MUIFolderLayout.m
//  美UI
//
//  Created by Lee on 16-4-8.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import "MUIFolderLayout.h"

@implementation MUIFolderLayout

- (instancetype)init
{
    if (self = [super init])
    {
        self.itemSize = CGSizeMake(176, 148);
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
}

- (CGSize)collectionViewContentSize
{
//    CGFloat height= ceil([[self collectionView] numberOfItemsInSection:0]/5)*SCREEN_WIDTH/2;
    
    return CGSizeMake(SCREEN_WIDTH, 200);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    NSMutableArray* attributes = [NSMutableArray array];
    
    for (NSInteger i=0 ; i < [array count]; i++) {
        
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        
    }
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
