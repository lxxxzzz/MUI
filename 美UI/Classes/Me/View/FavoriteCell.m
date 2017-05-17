//
//  FavoriteCell.m
//  美UI
//
//  Created by Lee on 17/2/19.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "FavoriteCell.h"
#import "Item.h"
#import <YYWebImage.h>
#import <UIImageView+WebCache.h>

@interface FavoriteCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation FavoriteCell

static inline float radians(double degrees) {
    return degrees * M_PI / 180;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        self.layer.shadowOffset = CGSizeMake(2.6,1.6);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        self.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        self.layer.shadowRadius = 3;//阴影半径，默认3
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.contentView.bounds;
}


- (void)setItem:(Item *)item {
    _item = item;

    NSURL *url = [NSURL URLWithString:item.pic];
    [self.imageView sd_setImageWithURL:url
                      placeholderImage:item.placeholder
                               options:0
                              progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        NSLog(@"%f",receivedSize / (CGFloat)expectedSize);
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

    }];
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.cornerRadius = 2;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

@end
