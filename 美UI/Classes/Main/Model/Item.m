//
//  Item.m
//  美UI
//
//  Created by Lee on 16/8/8.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "Item.h"
#import "MJExtension.h"
#import "UIImage+Stretch.h"

/*
 {
	app_id : 17,
	pic_id : 215,
	sys_tag : [ 地图, 动画, 彩云天气 ],
	app_name : 彩云天气,
	pic_w : 750,
	brief : ,
	user_pic : http://www.meiui.me/img/head.jpg,
	user_id : 1,
	pic : http://img.meiui.me/app/彩云天气/地图，动画.PNG,
	user_name : meiui,
	user_tag : [ ],
	pic_h : 1334
 }
 */

static NSArray *_placeholders;

@implementation Item

- (instancetype)init {
    if (self = [super init]) {
        _placeholders = @[
                          [UIImage imageWithColor:RGB(253, 239, 242)],
                          [UIImage imageWithColor:RGB(222, 176, 104)],
                          [UIImage imageWithColor:RGB(246, 191, 188)],
                          [UIImage imageWithColor:RGB(204, 166, 191)],
                          [UIImage imageWithColor:RGB(195, 145, 67)],
                          [UIImage imageWithColor:RGB(160, 216, 239)],
                          [UIImage imageWithColor:RGB(224, 235, 175)],
                          [UIImage imageWithColor:RGB(248, 244, 230)],
                          [UIImage imageWithColor:RGB(179, 173, 160)],
                          [UIImage imageWithColor:RGB(228, 171, 155)]
                          ];
        int index = arc4random() % _placeholders.count;
        self.placeholder = _placeholders[index];
    }
    return self;
}

- (NSString *)pic {
    return [_pic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void)setPic_h:(CGFloat)pic_h {
    _pic_h = pic_h ? pic_h : 198;
}

- (void)setPic_w:(CGFloat)pic_w {
    _pic_w = pic_w ? pic_w : 110;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n app_id = %@ \n app_name = %@ \n sys_tag = %@ \n brief = %@ \n user_id = %@\n user_name = %@\n pic_w = %f\n pic_h = %f\n-----------------这是分割线---------------\n", self.app_id, self.app_name, self.sys_tag, self.brief, self.user_id, self.user_name, self.pic_w, self.pic_h];
}

MJCodingImplementation

@end
