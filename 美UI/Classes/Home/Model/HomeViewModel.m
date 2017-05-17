//
//  HomeViewModel.m
//  美UI
//
//  Created by Lee on 17/3/6.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HomeViewModel.h"
#import "HTTPTool.h"
#import "MUIHttpParams.h"
#import "Item.h"
#import "Error.h"
#import <MJExtension.h>

@implementation HomeViewModel

- (void)dataWithSuccess:(void (^)(NSArray *))success failure:(void (^)(Error *))failure {
    NSMutableDictionary *params = [MUIHttpParams homeParams];
    params[@"page"] = [NSString stringWithFormat:@"%ld", self.page]; // 页码
    [HTTPTool GET:MUIBaseUrl params:params success:^(id json) {
        MUIHTTPCode *code = [MUIHTTPCode codeWithJSON:json];
        if (code.success) {
            if (code.datas.count) {
                self.totalPage = code.page;
                NSMutableArray *temp = [NSMutableArray array];
                for (NSDictionary *dict in json[@"data"][@"items"]) {
                    Item *item = [Item mj_objectWithKeyValues:dict];
                    item.user_tag_history = json[@"data"][@"user_tag_history"];
                    [temp addObject:item];
                }
                if (success) {
                    success(temp);
                }
            } else {
                if (failure) {
                    failure([Error errorWithType:ErrorTypeNodata]);
                }
            }
        } else {
            if (failure) {
                failure([Error errorWithType:ErrorTypeRequest]);
            }
        }
    } failure:^(NSError *err) {
        if (failure) {
            failure([Error errorWithType:ErrorTypeNetwork]);
        }
    }];
}


@end
