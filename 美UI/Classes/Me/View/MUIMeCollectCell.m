//
//  MUIMeCollectCell.m
//  美UI
//
//  Created by Lee on 16-1-6.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import "MUIMeCollectCell.h"
#import "MUIMeCollectItem.h"
#import "UIImageView+WebCache.h"
#import "Item.h"

#define CELL_W 90
#define CELL_H 148
#define MARGIN 5

@interface MUIMeCollectCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@end

@implementation MUIMeCollectCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGB(242, 242, 242);
    }
    return self;
}

- (void)awakeFromNib {
    self.backView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.backView.layer.shadowOffset = CGSizeMake(0.5,0.5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    self.backView.layer.shadowOpacity = 0.3;//阴影透明度，默认0
    self.backView.layer.shadowRadius = 2;//阴影半径，默认3
    // 圆角
    self.backView.layer.cornerRadius = 1;
}


- (void)setItem:(MUIMeCollectItem *)item {
    _item = item;
    
    self.categoryLabel.text = item.category;
    self.imageView1.image = nil;
    self.imageView2.image = nil;
    self.imageView3.image = nil;
    self.imageView4.image = nil;
    for (int i=0; i<item.items.count; i++) {
        if (i > 4) {
            break;
        }
        Item *temp = item.items[i];
        NSInteger t = 1000 + i;
        UIImageView *image = (UIImageView *)[self.backView viewWithTag:t];
        [image sd_setImageWithURL:[NSURL URLWithString:temp.pic]];
    }
}

@end
