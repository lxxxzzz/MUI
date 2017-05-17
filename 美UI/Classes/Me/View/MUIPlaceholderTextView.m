//
//  MUIPlaceholderTextView.m
//  美UI
//
//  Created by Lee on 16-3-17.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import "MUIPlaceholderTextView.h"

@implementation MUIPlaceholderTextView

- (void)drawRect:(CGRect)rect
{
    if (self.hasText) return;
    
    rect.origin.x = 4;
    rect.origin.y = 7;
    rect.size.width -= rect.origin.x * 2;
    rect.size.height -= rect.origin.y * 2;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = self.placeholderColor;
    [self.placeholder drawInRect:rect withAttributes:attrs];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setup
{
    self.font = [UIFont systemFontOfSize:14];
    self.placeholderColor = [UIColor grayColor];
    [MUINotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}

- (void)textDidChange
{
    [self setNeedsDisplay];
}

- (void)dealloc
{
    [MUINotificationCenter removeObserver:self];
}

@end
