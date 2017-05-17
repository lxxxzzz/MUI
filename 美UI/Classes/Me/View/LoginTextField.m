//
//  LoginTextField.m
//  美UI
//
//  Created by Lee on 16/8/9.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "LoginTextField.h"
#import <Masonry.h>

@interface LoginTextField ()

@property (nonatomic, strong) UIImageView *leftView;
@property (nonatomic, strong) UIImageView *line;

@end

@implementation LoginTextField

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.leftView];
        [self addSubview:self.textField];
        [self addSubview:self.line];
    }
    return self;
}

- (void)setImage:(NSString *)image {
    _image = image;
    self.leftView.image = [UIImage imageNamed:image];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.textField.placeholder = placeholder;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(23, 30));
        make.left.mas_equalTo(self.mas_left);
        make.top.mas_equalTo(self.mas_top);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftView.mas_right).offset(19);
        make.top.mas_equalTo(self.mas_top);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.line.mas_top);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
}

- (UIImageView *)leftView {
    if (_leftView == nil) {
        _leftView = [[UIImageView alloc] init];
    }
    return _leftView;
}

- (UITextField *)textField {
    if (_textField == nil) {
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.tintColor = [UIColor grayColor];
    }
    return _textField;
}

- (UIImageView *)line {
    if (_line == nil) {
        _line = [[UIImageView alloc] init];
        _line.image = [UIImage imageNamed:@"login_line"];
    }
    return _line;
}

@end
