//
//  DetailCell.m
//  美UI
//
//  Created by Lee on 16/11/9.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "DetailCell.h"
#import "MUIHomeUserInfoView.h"
#import "UIImageView+WebCache.h"
#import "Item.h"
#import "TagView.h"
#import "Masonry.h"
#import <YYWebImage.h>

#define DESC_FONT [UIFont systemFontOfSize:11]

@interface DetailCell () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *descText;
@property (nonatomic, strong) TagView *tagsView;
@property (nonatomic, strong) TagView *myTagsView;

@end

@implementation DetailCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageView];
        [self.scrollView addSubview:self.descText];
        [self.scrollView addSubview:self.userView];
        [self.scrollView addSubview:self.tagsView];
        [self.scrollView addSubview:self.myTagsView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
    CGFloat margin = 12;
    CGFloat imageW = self.contentView.width - margin * 2;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollView.mas_top).offset(margin);
        make.left.mas_equalTo(self.scrollView.mas_left).offset(margin);
        make.width.mas_equalTo(imageW);
        make.height.mas_equalTo(@(imageW * self.item.pic_h / self.item.pic_w));
    }];
    
    [self.descText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(12);
        make.left.equalTo(self.imageView.mas_left);
        make.right.equalTo(self.imageView.mas_right);
    }];
    
    [self.userView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.descText.text.length) {
            make.top.equalTo(self.descText.mas_bottom).offset(12);
        } else {
            make.top.equalTo(self.imageView.mas_bottom).offset(12);
        }
        make.left.equalTo(self.imageView.mas_left);
        make.right.equalTo(self.imageView.mas_right);
        make.height.equalTo(@54);
    }];
    
    [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userView.mas_bottom).offset(12);
        make.left.equalTo(self.imageView.mas_left);
        make.right.equalTo(self.imageView.mas_right);
        if (self.item.sys_tag.count) {
            make.height.mas_equalTo(80);
        }
    }];
    
    [self.myTagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tagsView.mas_bottom).offset(12);
        make.left.equalTo(self.imageView.mas_left);
        make.right.equalTo(self.imageView.mas_right);
        if (self.item.user_tag.count) {
            make.height.mas_equalTo(80);
        }
        make.bottom.mas_equalTo(self.scrollView.mas_bottom);
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(detailCellDidScroll:)]) {
        [self.delegate detailCellDidScroll:scrollView];
    }
}

#pragma mark - setter and getter
- (void)setItem:(Item *)item {
    _item = item;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:item.pic] placeholderImage:item.placeholder];
    self.descText.text = item.brief;
    self.userView.line.hidden = (item.brief.length == 0);
    self.userView.item = item;
    self.tagsView.tags = [NSMutableArray arrayWithArray:item.sys_tag];
    self.myTagsView.tags = [NSMutableArray arrayWithArray:item.user_tag];
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.cornerRadius = 5;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

- (UILabel *)descText {
    if (_descText == nil) {
        _descText = [[UILabel alloc] init];
        _descText.textColor = [UIColor grayColor];
        _descText.font = DESC_FONT;
        _descText.numberOfLines = 0;
    }
    return _descText;
}

- (MUIHomeUserInfoView *)userView {
    if (_userView == nil) {
        _userView = [MUIHomeUserInfoView userView];
    }
    return _userView;
}

- (TagView *)tagsView {
    if (_tagsView == nil) {
        _tagsView = [[TagView alloc] init];
        _tagsView.title = @"推荐标签";
    }
    return _tagsView;
}

- (TagView *)myTagsView {
    if (_myTagsView == nil) {
        _myTagsView = [[TagView alloc] init];
        _myTagsView.title = @"我的标签";
        _myTagsView.maxRowCount = 2;
    }
    return _myTagsView;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

@end
