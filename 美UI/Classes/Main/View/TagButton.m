//
//  TagButton.m
//  美UI
//
//  Created by Lee on 16/9/2.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "TagButton.h"

@implementation TagButton

+ (instancetype)buttonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    TagButton *btn = [[TagButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.textColor = TAG_TEXT_COLOR;
    self.borderColor = self.textColor;
    self.bgColor = [UIColor clearColor];
    
    self.selectedTextColor = [UIColor whiteColor];
    self.selectedBgColor = TAG_TEXT_COLOR;
    
    [self setTitleColor:self.textColor forState:UIControlStateNormal];
    
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [self.borderColor CGColor];
    self.layer.cornerRadius = MUITagHeight * 0.5;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    
    [self sizeToFit];
    
    self.width += 2 * MUITagMargin;
    // sizeToFit会改变按钮的宽度，设置回来
    self.height = MUITagHeight;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    [self setNeedsDisplay];
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    [self setNeedsDisplay];
}

- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    [self setNeedsDisplay];
}

- (void)setSelectedTextColor:(UIColor *)selectedTextColor {
    _selectedTextColor = selectedTextColor;
    [self setNeedsDisplay];
}

- (void)setSelectedBgColor:(UIColor *)selectedBgColor {
    _selectedBgColor = selectedBgColor;
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        [self setBackgroundColor:self.selectedBgColor];
        [self setTitleColor:self.selectedTextColor forState:UIControlStateNormal];
        [self.layer setBorderColor:[self.selectedBgColor CGColor]];

    } else {
        [self setTitleColor:self.textColor forState:UIControlStateNormal];
        [self setBackgroundColor:self.bgColor];
        [self.layer setBorderColor:[self.borderColor CGColor]];
    }
    [self setNeedsDisplay];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO;
}

@end
