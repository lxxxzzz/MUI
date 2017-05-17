//
//  MUICollectionView.m
//  美UI
//
//  Created by Lee on 16-4-8.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import "MUICollectionView.h"

@implementation MUICollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.showsVerticalScrollIndicator = FALSE;
        self.showsHorizontalScrollIndicator = FALSE;
        self.autoresizingMask = 0;
        self.alwaysBounceVertical = YES;
        self.backgroundColor = COLLECT_VIEW_COLOR;
    }
    return self;
}

@end
