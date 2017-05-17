//
//  MUIMeSettingFooterView.m
//  美UI
//
//  Created by Lee on 16-2-2.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import "MUIMeSettingFooterView.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "User.h"
#import "MUICacheTool.h"

@interface MUIMeSettingFooterView ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomH;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;

@end

@implementation MUIMeSettingFooterView

+ (instancetype)settingFooter {
    return [[[NSBundle mainBundle] loadNibNamed:@"MUIMeSettingFooterView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    self.topH.constant = 0.5;
    self.lineH.constant = 0.5;
    self.bottomH.constant = 0.5;
    [super awakeFromNib];
}

- (void)setCacheSize:(CGFloat)cacheSize {
    _cacheSize = cacheSize;
    NSMutableString *str = [NSMutableString stringWithString:@"清理缓存  "];
    if (cacheSize) {
        NSString *temstr = cacheSize >= 1048576.0f ? [NSString stringWithFormat:@"(%.2fM)",cacheSize / 1048576.0f] : [NSString stringWithFormat:@"(%.2fK)",cacheSize / 1024];
        [str appendString:temstr];
    } else {
        [str appendString:@"0K"];
    }
    NSRange strRange = [str rangeOfString:@"清理缓存"];
    NSRange sizeRange = NSMakeRange(strRange.length, str.length - strRange.length);
    NSMutableAttributedString *strM = [[NSMutableAttributedString alloc] initWithString:str];
    [strM addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:sizeRange];
    [strM addAttribute:NSForegroundColorAttributeName value:RGB(55, 55, 55) range:strRange];
    [self.clearBtn setAttributedTitle:strM forState:UIControlStateNormal];
}

- (IBAction)clearCache:(id)sender {
    if ([self.delegate respondsToSelector:@selector(settingFooterView:clearCache:)]) {
        [self.delegate settingFooterView:self clearCache:sender];
    }
}

- (IBAction)logout:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(settingFooterView:logout:)]) {
        [self.delegate settingFooterView:self logout:sender];
    }
}

@end
