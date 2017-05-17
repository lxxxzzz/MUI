//
//  Error.m
//  美UI
//
//  Created by Lee on 17/3/7.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "Error.h"

@implementation Error

- (NSString *)message {
    if (self.type == ErrorTypeNodata) {
        return @"没有数据";
    } else if (self.type == ErrorTypeRequest) {
        return @"请求失败";
    } else if (self.type == ErrorTypeRequest) {
        return @"网络连接错误";
    }
    return nil;
}

+ (instancetype)errorWithType:(ErrorType)type {
    Error *error = [[self alloc] init];
    error.type = type;
    return error;
}

@end
