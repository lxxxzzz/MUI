//
//  RightRefresh.m
//  美UI
//
//  Created by Lee on 16/8/9.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "RightRefresh.h"
#import <Masonry.h>

@interface RightRefresh ()
/** 图片*/
@property (nonatomic, strong) UIImageView *imageView;
/** 文字*/
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation RightRefresh

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)dealloc {
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];
}

- (void)setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    [scrollView addSubview:self];
    
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [scrollView addSubview:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (![@"contentOffset" isEqualToString:keyPath] || self.scrollView.contentSize.width == 0)return;
    if (self.scrollView.contentOffset.x + SCREEN_WIDTH  > self.scrollView.contentSize.width + self.frame.size.width) {
        [UIView animateWithDuration:0.5 animations:^{
            self.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        } completion:^(BOOL finished) {
            self.titleLabel.text = @"松开加载更多";
        }];
        if(!self.scrollView.isDragging){
            if (!self.refreshing){
                self.refreshing = true;
                if (self.operation) {
                    self.operation();
                }
            }
        }
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.imageView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.titleLabel.text = @"右拉加载更多";
            self.refreshing = false;
        }];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(15);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-10);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 17));
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left);
    }];
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"arrowHori"];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"右拉加载更多";
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

@end
