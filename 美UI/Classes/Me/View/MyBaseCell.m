//
//  MyBaseCell.m
//  美UI
//
//  Created by Lee on 17/3/13.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "MyBaseCell.h"
#import "MUIMeCollectItem.h"
#import "Item.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>

@interface MyBaseCell ()

@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UILabel *categoryLabel;

@end

@implementation MyBaseCell

static NSInteger const margin = 5;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = RGB(242, 242, 242);
    [self addSubview:self.backView];
    [self addSubview:self.categoryLabel];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.categoryLabel.mas_top).offset(-10);
    }];
    
    [self.categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}

- (void)setItem:(MUIMeCollectItem *)item {
    _item = item;
    
    self.categoryLabel.text = item.category;

    NSInteger columnCount = 2;
    CGFloat width = (self.bounds.size.width - (margin * (columnCount + 1))) / columnCount;
    NSInteger count = MIN(4, item.items.count);
    
    for (NSInteger i=0; i<count; i++) {
        Item *temp = item.items[i];
        CGFloat heigth = width * temp.pic_h / temp.pic_w;
        NSInteger row = i / columnCount;
        NSInteger column = i % columnCount;
        CGFloat x = column * (width + margin) + margin;
        CGFloat y = row * (heigth + margin) + margin;
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.backView addSubview:imageView];
        imageView.frame = CGRectMake(x, y, width, heigth);
        [imageView sd_setImageWithURL:[NSURL URLWithString:temp.pic] placeholderImage:temp.placeholder];
    }
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = RGB(240, 240, 235);
        _backView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        _backView.layer.shadowOffset = CGSizeMake(0.5, 0.5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _backView.layer.shadowOpacity = 0.3;//阴影透明度，默认0
        _backView.layer.shadowRadius = 2;//阴影半径，默认3
        _backView.layer.cornerRadius = 1;
    }
    return _backView;
}

- (UILabel *)categoryLabel {
    if (_categoryLabel == nil) {
        _categoryLabel = [[UILabel alloc] init];
        _categoryLabel.font = FONT(15);
        _categoryLabel.textColor = RGB(55, 55, 55);
    }
    return _categoryLabel;
}

@end
