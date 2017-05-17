//
//  BaseCell.m
//  美UI
//
//  Created by Lee on 16/8/8.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "BaseCell.h"
#import "Item.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>

@interface BaseCell ()

@property (nonatomic, strong) UILabel *desc;
@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UILabel *appName;

@end

static const CGFloat margin = 5;
static CGFloat iconW = 22;

@implementation BaseCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
//        self.layer.cornerRadius = 5;
//        self.layer.masksToBounds = YES;
        [self setupSubviews];
    }
    return self;
}

- (void)setItem:(Item *)item {
    _item = item;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:item.pic] placeholderImage:item.placeholder];
    self.desc.text = item.brief;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:item.user_pic]];
    self.nickName.text = item.user_name;
    self.appName.text = item.app_name;
//    [self setNeedsUpdateConstraints];
//    [self updateConstraintsIfNeeded];
}

- (void)setupSubviews {
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.desc];
    [self.contentView addSubview:self.line];
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.nickName];
    [self.contentView addSubview:self.appName];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.height.mas_equalTo(self.imageView.mas_width).multipliedBy(SCREEN_HEIGHT / (CGFloat)SCREEN_WIDTH);
    }];
    
    [self.desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(margin);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-margin);
        make.bottom.mas_equalTo(self.line.mas_top);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self.nickName.mas_top);
    }];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(iconW, iconW));
        make.centerY.mas_equalTo(self.nickName.mas_centerY);
        make.left.mas_equalTo(self.contentView.mas_left).offset(5);
    }];
    
    [self.nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).offset(5);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.right.mas_equalTo(self.appName.mas_left).offset(-5);
        make.height.mas_equalTo(32);
    }];
    
    [self.appName setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.appName setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.appName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.nickName.mas_bottom);
        make.top.mas_equalTo(self.nickName.mas_top);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-5);
    }];
}

//- (void)updateConstraints {
//    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.contentView.mas_left);
//        make.right.mas_equalTo(self.contentView.mas_right);
//        make.top.mas_equalTo(self.contentView.mas_top);
//        make.height.mas_equalTo(self.imageView.mas_width).multipliedBy(self.item.pic_h / self.item.pic_w);
//    }];
//
//    [super updateConstraints];
//}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.height.mas_equalTo(self.imageView.mas_width).multipliedBy(self.item.pic_h / self.item.pic_w);
    }];
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)desc {
    if (_desc == nil) {
        _desc = [[UILabel alloc] init];
        _desc.font = [UIFont systemFontOfSize:8];
        _desc.numberOfLines = 0;
        _desc.textColor = RGB(85, 85, 85);
    }
    return _desc;
}

- (UIImageView *)line {
    if (_line == nil) {
        _line = [[UIImageView alloc] init];
        _line.image = [UIImage imageNamed:@"line"];
    }
    return _line;
}

- (UIImageView *)icon {
    if (_icon == nil) {
        _icon = [[UIImageView alloc] init];
        _icon.layer.cornerRadius = iconW * 0.5;
        _icon.layer.masksToBounds = YES;
    }
    return _icon;
}

- (UILabel *)nickName {
    if (_nickName == nil) {
        _nickName = [[UILabel alloc] init];
        _nickName.font = [UIFont systemFontOfSize:10];
        _nickName.textColor = RGB(85, 85, 85);
    }
    return _nickName;
}

- (UILabel *)appName {
    if (_appName == nil) {
        _appName = [[UILabel alloc] init];
        _appName.font = [UIFont systemFontOfSize:12];
        _appName.textColor = RGB(55, 55, 55);
    }
    return _appName;
}

@end
