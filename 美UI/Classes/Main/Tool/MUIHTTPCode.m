//
//  MUIHTTPCode.m
//  美UI
//
//  Created by Lee on 16-3-18.
//  Copyright (c) 2016年 Lee. All rights reserved.
//

#import "MUIHTTPCode.h"

@implementation MUIHTTPCode

+ (instancetype)codeWithJSON:(NSDictionary *)dict {
    MUIHTTPCode *code = [[MUIHTTPCode alloc] init];
    NSString *msg = dict[@"alert"][@"msg"];
    code.success = ![msg isKindOfClass:[NSNull class]] && [msg isEqualToString:@"成功请求"];
    if (code.success) {
        code.data = dict[@"data"];
        code.datas = dict[@"data"][@"items"];
        code.tags = dict[@"data"][@"tags"];
        NSRange range = [code.data[@"page"] rangeOfString:@"/"];
        code.page = [[code.data[@"page"] substringFromIndex:range.location + 1] intValue];
    } else {
        code.error = msg;
    }
    
    return code;
}

@end
