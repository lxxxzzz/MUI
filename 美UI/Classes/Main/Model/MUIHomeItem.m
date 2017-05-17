//
//  MUIHomeItem.m
//  美UI
//
//  Created by Lee on 15-12-18.
//  Copyright (c) 2015年 Lee. All rights reserved.
//

#import "MUIHomeItem.h"
#import "MJExtension.h"
#import "UIImage+Stretch.h"
#import "MUICacheTool.h"

static NSArray *_placeholder;
           
@implementation MUIHomeItem

- (void)setTags:(NSMutableArray *)tags {
    _tags = [tags mutableCopy];
}

- (void)setMyTags:(NSMutableArray *)user_tag {
    _user_tag = [user_tag mutableCopy];
}

+ (instancetype)itemWithDict:(NSDictionary *)dict {
    MUIHomeItem *item = [[self alloc] init];
    _placeholder = @[
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
    
    item.url = [dict[@"pic"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    item.desc = dict[@"brief"];
    item.userName = dict[@"user_name"];
    item.userIcon = dict[@"user_pic"];
    item.appName = dict[@"app_name"];
    item.tags = [dict[@"sys_tag"] mutableCopy];
    item.user_tag = [dict[@"user_tag"] mutableCopy];
    item.w = [dict[@"pic_w"] floatValue];
    item.h = [dict[@"pic_h"] floatValue];
    item.pic_id = dict[@"pic_id"];
    int index = arc4random() % _placeholder.count;
    item.placeholderImage = _placeholder[index];
//    item.user_tag_history = dict[@"user_tag_history"];
    return item;
}

+ (instancetype)itemWithJSON:(NSDictionary *)json withUrl:(NSString *)url {
    MUIHomeItem *item = [[self alloc] init];
    NSDictionary *dict = [json[@"data"][@"items"] lastObject];
    item.url = url;
    item.desc = dict[@"brief"];
    item.userName = dict[@"user_name"];
    item.userIcon = dict[@"user_pic"];
    item.appName = dict[@"app_name"];
    item.tags = [dict[@"sys_tag"] mutableCopy];
    item.user_tag = [dict[@"user_tag"] mutableCopy];
    item.w = [dict[@"pic_w"] floatValue];
    item.h = [dict[@"pic_h"] floatValue];
    item.pic_id = dict[@"pic_id"];
//    item.user_tag_history = dict[@"user_tag_history"];
    return item;
}


MJCodingImplementation

@end
