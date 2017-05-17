//
//  ToolBar.m
//  美UI
//
//  Created by Lee on 17/3/10.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "ToolBar.h"
#import <Masonry.h>

@implementation ToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor grayColor];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self.mas_top);
        make.height.mas_equalTo(0.5);
    }];
    
    UIButton *backBtn = [self buttonWithBackImage:@"tools_back_unclick" high:@"tools_back_clicking" selected:nil action:@selector(buttonEvent:)];
    backBtn.tag = 0;
    UIButton *collectBtn = [self buttonWithBackImage:@"tools_mark_unclick" high:@"tools_mark_clicking" selected:@"tools_mark_clicked" action:@selector(buttonEvent:)];
    collectBtn.tag = 1;
    self.collectButton = collectBtn;
    UIButton *modifyBtn = [self buttonWithBackImage:@"tools_edit_unclick" high:@"tools_edit_clicking" selected:nil action:@selector(buttonEvent:)];
    modifyBtn.tag = 2;
    UIButton *saveBtn = [self buttonWithBackImage:@"tools_down_unclick" high:@"tools_down_clicking" selected:nil action:@selector(buttonEvent:)];
    saveBtn.tag = 3;
    [self addSubview:backBtn];
    [self addSubview:collectBtn];
    [self addSubview:modifyBtn];
    [self addSubview:saveBtn];
    
    CGFloat margin = (SCREEN_WIDTH - 49 * 4) / 5.0;
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(margin);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backBtn.mas_right).offset(margin);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [modifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(collectBtn.mas_right).offset(margin);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(modifyBtn.mas_right).offset(margin);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}

- (void)buttonEvent:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(toolBar:didClickButton:atIndex:)]) {
        [self.delegate toolBar:self didClickButton:btn atIndex:btn.tag];
    }
}

- (UIButton *)buttonWithBackImage:(NSString *)image high:(NSString *)high selected:(NSString *)selected action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:high] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
