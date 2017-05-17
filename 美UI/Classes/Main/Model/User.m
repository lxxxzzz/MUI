//
//  User.m
//  美UI
//
//  Created by Lee on 16/8/8.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "User.h"
#import <objc/runtime.h>

@implementation User
static User *_instance = nil;

+ (BOOL)isOnline {
    return _instance.user_id.length > 0;
}

+ (void)userWithJSON:(NSDictionary *)dict completion:(void (^)())completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:dict[@"user_pic"]];
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        _instance.user_id = dict[@"user_id"];
        _instance.unionid = dict[@"user_id"];
        _instance.username = dict[@"username"];
        _instance.nickname = dict[@"nickname"];
        _instance.user_pic = dict[@"user_pic"];
        _instance.tags = dict[@"user_tag_history"];
        if (data) {
            _instance.userIcon = data;
        }
        [self save2SandBox];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    });
}

+ (void)logout {
    _instance.user_id = nil;
    _instance.nickname = nil;
    _instance.username = nil;
    _instance.user_pic = nil;
    _instance.userIcon = nil;
    _instance.tags = [NSMutableArray array];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"user_id"];
    [defaults removeObjectForKey:@"nickname"];
    [defaults removeObjectForKey:@"headimgurl"];
    [defaults removeObjectForKey:@"userIcon"];
    [defaults synchronize];
}

+ (void)save2SandBox {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_instance.user_id forKey:@"user_id"];
    [defaults setObject:_instance.username forKey:@"username"];
    [defaults setObject:_instance.nickname forKey:@"nickname"];
    [defaults setObject:_instance.user_pic forKey:@"user_pic"];
    [defaults setObject:_instance.userIcon forKey:@"userIcon"];
    [defaults setObject:_instance.tags forKey:@"user_tag_history"];
    [defaults synchronize];
}

+ (instancetype)sharedUser {
    if (_instance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            _instance = [[self alloc] init];
            _instance.user_id = [defaults objectForKey:@"user_id"];
            _instance.nickname = [defaults objectForKey:@"nickname"];
            _instance.username = [defaults objectForKey:@"username"];
            _instance.user_pic = [defaults objectForKey:@"user_pic"];
            _instance.userIcon = [defaults objectForKey:@"userIcon"];
            _instance.tags = [defaults objectForKey:@"user_tag_history"];
        });
    }
    return _instance;
}

+ (void)load {
    [self sharedUser];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}



@end
