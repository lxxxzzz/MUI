//
//  TagView.m
//  美UI
//
//  Created by Lee on 16/9/2.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "TagView.h"
#import "NSString+MUIExtension.h"
#import "TagButton.h"

@interface TagView ()

@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) CGFloat backViewHeight;
@property (nonatomic, strong) UIScrollView *backView;

@end

@implementation TagView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.editable = NO;
        self.font = [UIFont systemFontOfSize:12];
        self.borderColor = RGB(250, 200, 0);
        self.btns = [NSMutableArray array];
        self.selectedTags = [NSMutableArray array];
        self.buttonAtts = [NSMutableDictionary dictionary];
        [self addSubview:self.titleLabel];
        [self addSubview:self.backView];
    }
    return self;
}

- (void)setup {
    self.editable = NO;
    self.font = [UIFont systemFontOfSize:12];
    self.borderColor = RGB(250, 200, 0);
    self.btns = [NSMutableArray array];
    self.selectedTags = [NSMutableArray array];
    self.buttonAtts = [NSMutableDictionary dictionary];
    [self addSubview:self.titleLabel];
    [self addSubview:self.backView];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = RGB(55, 55, 55);
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (UIScrollView *)backView {
    if (!_backView) {
        _backView = [[UIScrollView alloc] init];
        _backView.showsHorizontalScrollIndicator = NO;
        _backView.showsVerticalScrollIndicator = NO;
    }
    return _backView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.text = self.title;
    self.titleLabel.frame = CGRectMake(MUITagMargin, 0, self.width, 15);
    
    CGFloat x = 0;
    CGFloat y = CGRectGetMaxY(self.titleLabel.frame);
    CGFloat w = self.width;
    CGFloat h = self.height - y;
    self.backView.frame = CGRectMake(x, y, w, h);
    
    [self updateTagButtonFrame];
}

- (CGFloat)getHeight {
    [self setNeedsDisplay];
    
    self.height = CGRectGetMaxY(self.backView.frame);
    
    return self.height;
}

- (void)setEditable:(BOOL)editable {
    _editable = editable;
    if (self.type == TagTypeShow) { // 如果TagType是TagTypeShow   则不可编辑
        return;
    }
    _editable = editable;
}

- (void)setTags:(NSMutableArray *)tags {
    _tags = [tags mutableCopy];
    
    [self removeAllTags];
    
    if (tags.count) {
        self.hidden = NO;
        for (NSString *title in tags) {
            [self addTag:title];
        }
    } else {
        self.hidden = YES;
    }
}

- (void)setSelectedTags:(NSMutableArray *)selectedTags {
    _selectedTags = [selectedTags mutableCopy];
    
    [self updateTagState];
}

- (void)setButtonAtts:(NSMutableDictionary *)buttonAtts {
    _buttonAtts = buttonAtts;
    
    [self updateTagState];
}

- (void)addTag:(NSString *)text {
    TagButton *btn = [TagButton buttonWithTitle:text target:self action:@selector(onClick:)];
    [self.btns addObject:btn];
    [self.backView addSubview:btn];
    [self updateTagButtonFrame];
}

- (void)removeTag:(TagButton *)btn {
    [btn removeFromSuperview];
    [self.btns removeObject:btn];
    
    [UIView animateWithDuration:0.3f animations:^{
        [self updateTagButtonFrame];
    }];
}

- (void)removeAllTags {
    for (TagButton *btn in self.backView.subviews) {
        if ([btn isKindOfClass:[TagButton class]]) {
            [self removeTag:btn];
        }
    }
    
    [self.btns removeAllObjects];
}

- (void)updateTagButtonFrame {
    for (int i = 0; i < self.btns.count; i++) {
        TagButton *tag = self.btns[i];
        // 设置默认选中的
        tag.selected = [self.selectedTags containsObject:tag.currentTitle];
        if (i == 0) {
            // 第一个按钮
            tag.x = MUITagMargin;
            tag.y = MUITagMargin;
        } else {
            // 其他按钮
            TagButton *lastTag = self.btns[i - 1];
            CGFloat leftWidth = CGRectGetMaxX(lastTag.frame) + MUITagMargin;
            CGFloat rightWidth = self.backView.width - leftWidth;
            if (rightWidth >= tag.width) {
                // 空间够，直接放在后面
                tag.x = CGRectGetMaxX(lastTag.frame) + MUITagMargin;
                tag.y = lastTag.y;
            } else {
                // 空间不够，放到下一行
                tag.x = MUITagMargin;
                tag.y = CGRectGetMaxY(lastTag.frame) + MUITagMargin;
            }
        }
    }
    [self updateContentSize];
}

- (void)updateContentSize {
    CGFloat contentH = CGRectGetMaxY([[self.btns lastObject] frame]) + MUITagMargin;
    if (self.maxRowCount) {
        // 限定行数时需要的宽度
        CGFloat maxH = self.maxRowCount * MUITagHeight + (self.maxRowCount + 1) * MUITagMargin;
        if (maxH > self.backView.height) {
            self.backView.height = maxH;
            self.backView.contentSize = CGSizeMake(self.backView.width, contentH);
        } else {
            self.backView.height = contentH;
        }
    } else {
        self.backView.contentSize = CGSizeMake(self.backView.width, contentH);
        self.backView.height = contentH;
    }
    self.height = CGRectGetMaxY(self.backView.frame);
    
    [self setNeedsDisplay];
}

- (void)updateTagState {
    for (int i = 0; i < self.btns.count; i++) {
        TagButton *tag = self.btns[i];
        // 设置默认选中的
        tag.selected = [self.selectedTags containsObject:tag.currentTitle];
    }
}

- (void)onClick:(TagButton *)btn {
    [self.selectedTags removeAllObjects];
    switch (self.type) {
        case TagTypeShow:
            // 显示
            break;
        case TagTypeSingle:
            // 单选
            if (btn.selected) {
                btn.selected = NO;
            } else {
                for (TagButton *button in self.btns) {
                    button.selected = NO;
                }
                btn.selected = YES;
                [self.selectedTags addObject:btn.currentTitle];
            }
            break;
        case TagTypeMultiple:
            // 多选
            btn.selected = !btn.selected;
            for (TagButton *button in self.btns) {
                if (button.selected) {
                    [self.selectedTags addObject:button.currentTitle];
                }
            }
            break;
        default:
            break;
    }
    if ([self.tagDelegate respondsToSelector:@selector(tagsView:clickButton:selectedItems:)]) {
        [self.tagDelegate tagsView:self clickButton:btn selectedItems:self.selectedTags];
    }
}

@end
