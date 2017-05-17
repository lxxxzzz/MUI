//
//  MyUploadHeaderView.m
//  美UI
//
//  Created by Lee on 17/3/15.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "MyUploadHeaderView.h"
#import "Upload.h"
#import <Masonry.h>

@interface MyUploadHeaderView ()

@property (nonatomic, strong) UILabel *status;
@property (nonatomic, strong) UIButton *showAll;

@end

@implementation MyUploadHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    [self addSubview:self.status];
    [self addSubview:self.showAll];
    
    [self.status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    [self.showAll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}

- (void)action {
    if ([self.delegate respondsToSelector:@selector(headerViewShowMore:)]) {
        [self.delegate headerViewShowMore:self];
    }
}

- (void)setUpload:(Upload *)upload {
    _upload = upload;
    
    self.status.text = upload.title;
}

- (UILabel *)status {
    if (_status == nil) {
        _status = [[UILabel alloc] init];
        _status.font = FONT(12);
    }
    return _status;
}

- (UIButton *)showAll {
    if (_showAll == nil) {
        _showAll = [[UIButton alloc] init];
        _showAll.titleLabel.font = FONT(12);
        [_showAll setTitle:@"显示全部>" forState:UIControlStateNormal];
        [_showAll setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_showAll addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showAll;
}

@end
