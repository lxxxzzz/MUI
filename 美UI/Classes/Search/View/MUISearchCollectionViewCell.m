//
//  MUISearchCollectionViewCell.m
//  美UI
//
//  Created by Lee on 15-12-26.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "MUISearchCollectionViewCell.h"

@interface MUISearchCollectionViewCell ()

@end

@implementation MUISearchCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self.contentView addSubview:self.title];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [RGB(250, 201, 0) CGColor];
    }
    return self;
}

- (UILabel *)title
{
    if (!_title)
    {
        CGRect titleRect = CGRectMake(0, (self.frame.size.height - 20) * 0.5, self.frame.size.width, 20);
        _title = [[UILabel alloc] initWithFrame:titleRect];
        _title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}

@end
