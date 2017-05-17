//
//  MUIHttpTool.h
//  美UI
//
//  Created by Lee on 16-3-29.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUIHTTPCode.h"

@interface MUIHttpTool : NSObject

+ (void)GET:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void(^)(NSError *err))failure;

+ (void)POST:(NSString *)url params:(NSDictionary *)params success:(void(^)(id json))success failure:(void(^)(NSError *err))failure;

+ (void)POST:(NSString *)url params:(NSDictionary *)params image:(UIImage *)image success:(void (^)(id json))success failure:(void (^)(NSError * err))failure;

@end
