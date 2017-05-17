//
//  Item.h
//  美UI
//
//  Created by Lee on 16/8/8.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@interface Item : NSObject

@property (nonatomic, copy) NSString *app_id;
@property (nonatomic, copy) NSString *pic_id;
@property (nonatomic, strong) NSArray *sys_tag;
@property (nonatomic, strong) NSArray *user_tag;
@property (nonatomic, copy) NSString *app_name;
@property (nonatomic, copy) NSString *brief;
@property (nonatomic, copy) NSString *user_pic;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, assign) CGFloat pic_h;
@property (nonatomic, assign) CGFloat pic_w;
@property (nonatomic, strong) UIImage *placeholder;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) NSInteger is_like;

@property (nonatomic, strong) NSArray *user_tag_history;

@end
