//
//  HTTPTool.h
//  美UI
//
//  Created by Lee on 17/3/6.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUIHTTPCode.h"

@interface HTTPTool : NSObject

+ (void)GET:(NSString *)url success:(void (^)(id))success failure:(void (^)(NSError *))failure;
+ (void)GET:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void(^)(NSError *err))failure;

+ (void)POST:(NSString *)url params:(NSDictionary *)params success:(void(^)(id json))success failure:(void(^)(NSError *err))failure;

+ (void)POST:(NSString *)url params:(NSDictionary *)params image:(UIImage *)image success:(void (^)(id json))success failure:(void (^)(NSError * err))failure;

@end
