//
//  MUIHttpParams.m
//  美UI
//
//  Created by Lee on 16-3-29.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import "MUIHttpParams.h"
#import "User.h"

@implementation MUIHttpParams

+ (NSMutableDictionary *)homeParams
{
    NSMutableDictionary *dict = [self baseParams];
    dict[@"function"] = @"Index/index";
    if ([User isOnline]) {
        dict[@"user_id"] = [User sharedUser].user_id;
    }
    return dict;
}

+ (NSMutableDictionary *)searchParams
{
    NSMutableDictionary *dict = [self baseParams];
    dict[@"function"] = @"Search/index";
    dict[@"page"] = @"1";
    return dict;
}

+ (NSMutableDictionary *)searchResultParams
{
    NSMutableDictionary *dict = [self baseParams];
    dict[@"function"] = @"Search/search";
    dict[@"page"] = @"1";
    return dict;
}

+ (NSMutableDictionary *)baseParams
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"mac"] = @"meiui";
    dict[@"token"] = @"7b41408d1993764335d57232973934dee";
    return dict;
}

+ (NSMutableDictionary *)createTagParams
{
    NSMutableDictionary *dict = [self baseParams];
    dict[@"function"] = @"User/edit_tag_link";
    return dict;
}

+ (NSMutableDictionary *)collectParams
{
    NSMutableDictionary *dict = [self baseParams];
    dict[@"function"] = @"User/center";
    dict[@"page"] = @"1";
    if ([User isOnline]) {
        dict[@"user_id"] = [User sharedUser].user_id;
    }
    return dict;
}

+ (NSMutableDictionary *)feedbackParams
{
    NSMutableDictionary *dict = [self baseParams];
    dict[@"function"] = @"User/add_feedback";
    if ([User isOnline]) {
        dict[@"user_id"] = [User sharedUser].user_id;
    }
    return dict;
}

+ (NSMutableDictionary *)weixinParams
{
    NSMutableDictionary *dict = [self baseParams];
    dict[@"function"] = @"Login/weixin";
    return dict;
}

+ (NSMutableDictionary *)registerMessageParams
{
    NSMutableDictionary *dict = [self baseParams];
    dict[@"function"] = @"Login/get_msg";
    return dict;
}

+ (NSMutableDictionary *)registerParams
{
    NSMutableDictionary *dict = [self baseParams];
    dict[@"function"] = @"Login/mobile";
    return dict;
}

+ (NSMutableDictionary *)resetPasswordParams
{
    NSMutableDictionary *dict = [self baseParams];
    dict[@"function"] = @"Login/pwd_back";
    return dict;
}

+ (NSMutableDictionary *)editNameParams
{
    NSMutableDictionary *dict = [self baseParams];
    dict[@"function"] = @"Login/edit_user";
    return dict;
}

+ (NSMutableDictionary *)editIconParams
{
    NSMutableDictionary *dict = [self baseParams];
    dict[@"function"] = @"Login/upload_pic";
    return dict;
}

+ (NSMutableDictionary *)detailParams
{
    NSMutableDictionary *dict = [self baseParams];
    dict[@"function"] = @"Index/get_pic_detail";
    return dict;
}

@end
