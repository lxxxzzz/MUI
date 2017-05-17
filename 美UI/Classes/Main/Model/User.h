//
//  User.h
//  美UI
//
//  Created by Lee on 16/8/8.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCopying>

/** 服务器返回的用户id*/
@property (nonatomic, copy) NSString *user_id;
/** 微信登陆后拿到的用户昵称*/
@property (nonatomic, copy) NSString *nickname;
/** 用户名*/
@property (nonatomic, copy) NSString *username;
/** 微信登陆后拿到的用户头像*/
@property (nonatomic, copy) NSString *user_pic;
/** 微信登陆后拿到的用户唯一标识*/
@property (nonatomic, copy) NSString *unionid;
/** 用户头像（data）*/
@property (nonatomic, strong) NSData *userIcon;
/** 用户标签*/
@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic, strong) UIImage *icon;

+ (instancetype)sharedUser;
+ (void)userWithJSON:(NSDictionary *)dict completion:(void (^)())completion;
+ (void)logout;
+ (BOOL)isOnline;

@end
