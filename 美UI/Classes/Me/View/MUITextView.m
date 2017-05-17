//
//  MUITextView.m
//  美UI
//
//  Created by Lee on 17/2/28.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "MUITextView.h"
#import "NSString+MUIExtension.h"

@interface MUITextView () <UITextViewDelegate>

@property (nonatomic, strong) UILabel *label;

@end

@implementation MUITextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    rect.origin.y = 8;
    rect.origin.x = 5;
    CGSize size = [self.placeholder sizeWithText:CGSizeMake(rect.size.width - 2 * rect.origin.x, MAXFLOAT) font:self.font];
    rect.size.height = size.height;
    self.label.frame = rect;
}

- (void)setup {
    [self addSubview:self.label];
    self.delegate = self;
}

- (void)textViewDidChange:(UITextView *)textView {
    self.label.hidden = textView.hasText;
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    
    self.label.font = font;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    
    [self textViewDidChange:self];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    
    [self textViewDidChange:self];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.label.text = placeholder;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    self.label.textColor = placeholderColor;
}

- (UILabel *)label {
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        _label.numberOfLines = 0;
    }
    return _label;
}

@end
